FROM gentoo/portage:20181207 as portage
FROM gentoo/stage3-amd64-nomultilib:20181207

LABEL maintainer "Scrolliris <support@scrolliris.com>"

COPY --from=portage /usr/portage /usr/portage

ADD make.conf /etc/portage/make.conf

RUN set -eux \
    && eselect news read --quiet new >/dev/null 2>&1 \
    && emerge -qv \
      =net-misc/curl-7.62.0 \
    && emerge -qv \
      =dev-db/postgresql-9.6.11 \
      =dev-libs/libmemcached-1.0.18-r3 \
      =sys-devel/gettext-0.19.8.1 \
      =dev-lang/python-3.6.6

# venv
RUN python3.6 -m venv /venv
ENV VIRTUAL_ENV /venv
ENV PATH /venv/bin:$PATH

RUN set -eux \
    && . /venv/bin/activate \
    && pip install -U setuptools pip \
    && pip install nodeenv \
    && nodeenv -p --node=8.11.4

CMD ["/bin/bash"]
