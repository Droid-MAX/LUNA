FROM python:3.8-slim

ENV HOME=/root
WORKDIR $HOME

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y build-essential git rustc cargo libusb-1.0-0-dev libgtk-4-dev && rm -rf /var/lib/apt/lists/*
RUN pip install --no-cache-dir poetry2setup prompt_toolkit pyside6 yowasp-yosys yowasp-nextpnr-ecp5
RUN find $(dirname $(which yowasp-yosys)) -type f -name "yowasp-*" -execdir bash -c 'x="{}";mv -v $x ${x##*yowasp-}' \;

RUN git clone https://github.com/greatscottgadgets/luna $HOME/luna
RUN cd $HOME/luna && poetry2setup > setup.py && pip install --no-cache-dir -e .

RUN git clone https://github.com/greatscottgadgets/packetry $HOME/packetry
RUN cd $HOME/packetry && cargo build

ENTRYPOINT ["/bin/bash"]
