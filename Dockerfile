FROM python:3.8-slim

ENV HOME=/root
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y git libusb-1.0-0-dev minicom tmux && rm -rf /var/lib/apt/lists/*
RUN pip install --no-cache-dir poetry2setup yowasp-yosys yowasp-nextpnr-ecp5
RUN find $(dirname $(which yowasp-yosys)) -type f -name "yowasp-*" -execdir bash -c 'x="{}";mv -v $x ${x##*yowasp-}' \;

RUN git clone --depth=1 https://github.com/greatscottgadgets/luna $HOME/luna
RUN cd $HOME/luna && poetry2setup > setup.py && pip install --no-cache-dir -e .

RUN git clone --depth=1 https://github.com/greatscottgadgets/ViewSB $HOME/ViewSB
RUN cd $HOME/ViewSB && pip install --no-cache-dir -r requirements.txt && python setup.py install

WORKDIR $HOME
ENTRYPOINT ["/bin/bash"]
