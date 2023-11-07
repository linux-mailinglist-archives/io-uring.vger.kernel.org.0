Return-Path: <io-uring+bounces-51-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AD2A27E4AD8
	for <lists+io-uring@lfdr.de>; Tue,  7 Nov 2023 22:41:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DD63A1C209DE
	for <lists+io-uring@lfdr.de>; Tue,  7 Nov 2023 21:41:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AAC69450CA;
	Tue,  7 Nov 2023 21:40:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="cNDzU9qO"
X-Original-To: io-uring@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA2E136B14
	for <io-uring@vger.kernel.org>; Tue,  7 Nov 2023 21:40:57 +0000 (UTC)
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67EA210DB
	for <io-uring@vger.kernel.org>; Tue,  7 Nov 2023 13:40:57 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id d9443c01a7336-1cc329ce84cso55985655ad.2
        for <io-uring@vger.kernel.org>; Tue, 07 Nov 2023 13:40:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1699393256; x=1699998056; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=AVJZqVcyma3ct6BfK13ilT3hI6yMCDJSgtxoPkUL7Us=;
        b=cNDzU9qOn7UWFCp+xGJqPzi4U1ruEp8023y/neUzTcRYCYL9tU6J0CR5vh8fhJY+ti
         8d5Ierb2suE6aqhxidEcrOMmg2wyN6jI2AqzxXnofBm/eQZK+EqVrvavG9/t3OumB7E3
         hgBgbOSXey1LNsoXKkjK6fil8UHPOKRvCncHBQjjediVbYtPkRN4RfoEVJ55kYsMYdcO
         SMv2k2N2XchplNx7WFUzSoKkl6bHi6lF8n1ehnRC+GILPA44tHNHeC8Q94RdU4nYZktl
         R0pmfMWKHdP0MmbnbTXdYn6w9GmCIxkPCq4PJ8jSgGDJVvljCgfUbzFsNQtAiOfxQVi1
         kP9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699393256; x=1699998056;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AVJZqVcyma3ct6BfK13ilT3hI6yMCDJSgtxoPkUL7Us=;
        b=VVuPOmpUypcZeEdzuiEQASqoWa/BZbgPHvT8cWUGh3Z+X0FpOOzBT6Emr0D+cUyXW/
         e8JRBe62DaLrwnKF+Cd5pCvAH6X3qHWkXtOX2+rxgPlt0L1vjLYYECdxVJe0HoKIzFU6
         vvajZgduNNqKkGIAYZcWD7oAEDpOKBnUqz5coAheEpU4qOsbpzpPWUeEQpxvPfQyybBc
         Vyzpf1cljlHHcpVGBMLXHSygNamhaCjMM87WYS96LI6dFx1N6bhvs4e7EGLAKUL6+Ntm
         nHG5z4BgAmOoWkse8UQyXNlxMArih3EfAW+ruTlY9ibBY9c7PetL/MkXBVEs+/hGgrva
         w0vw==
X-Gm-Message-State: AOJu0YwUiLp2Rjy55VGJIIixSbMZRHN7KEhS5vnErOWgHV7AvPTq7rX7
	VR1ztJW9YboOM/3sdEpDXG48gVvHYyOgmkQg5V5paQ==
X-Google-Smtp-Source: AGHT+IEsv6fK+LHzXXi/oHWB63hwNVvn+nqPWFiS64BbMdemDnSHvz9isUHkY1sOCc9meRMUmkMMyg==
X-Received: by 2002:a17:902:ce91:b0:1cc:5425:bb4 with SMTP id f17-20020a170902ce9100b001cc54250bb4mr238392plg.52.1699393256425;
        Tue, 07 Nov 2023 13:40:56 -0800 (PST)
Received: from localhost (fwdproxy-prn-017.fbsv.net. [2a03:2880:ff:11::face:b00c])
        by smtp.gmail.com with ESMTPSA id ji3-20020a170903324300b001c5fc11c085sm265202plb.264.2023.11.07.13.40.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Nov 2023 13:40:56 -0800 (PST)
From: David Wei <dw@davidwei.uk>
To: io-uring@vger.kernel.org,
	netdev@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	David Ahern <dsahern@kernel.org>,
	Mina Almasry <almasrymina@google.com>,
	Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
	Dragos Tatulea <dtatulea@nvidia.com>
Subject: [RFC PATCH v2 00/20] Zero copy Rx using io_uring
Date: Tue,  7 Nov 2023 13:40:25 -0800
Message-Id: <20231107214045.2172393-1-dw@davidwei.uk>
X-Mailer: git-send-email 2.39.3
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Changes in RFC v2:
------------------

* Added copy fallback support if userspace memory allocated for ZC Rx
  runs out, or if header splitting or flow steering fails.
* Added veth support for ZC Rx, for testing and demonstration. We will
  need to figure out what driver would be best for such testing
  functionality in the future. Perhaps netdevsim?
* Added socket registration API to io_uring to associate specific
  sockets with ifqs/Rx queues for ZC.
* Added multi-socket support, such that multiple connections can be
  steered into the same hardware Rx queue.
* Added Netbench server/client support.

Known deficiencies that we will address in a future patchset:

* Rebase on top of Kuba's page pool memory provider RFC.
* Proper test driver + selftests, maybe netdevsim.
* Further optimisation work.
* ...and more.

We are looking for feedback on our approach. Here are some example
points we would like to specifically discuss:

* Use of bpf_netdev_command to set up a hardware Rx queue for ZC?
* Tagging page private fields with a magic cookie to distinguish special
  userspace pages used for ZC Rx. This is used when reading skbs from a
  socket in io_uring to decide what to do.

This patchset is a proposal that adds zero copy network Rx to io_uring.
With it, userspace can register a region of host memory for receiving
data directly from a NIC using DMA, without needing a kernel to user
copy.

Full kernel tree including some out of tree BNXT changes:

https://github.com/spikeh/linux/tree/zcrx_sil

On the userspace side, support is added to both liburing and Netbench:

https://github.com/spikeh/liburing/tree/zcrx2
https://github.com/spikeh/netbench/tree/zcrx

If you would like to try out this patchset, build and run the kernel
tree then build Netbench using liburing, all from forks above.

Run setup.sh first:

https://gist.github.com/isilence/e6a28ce41a545a261566672104afa461

Then run the following commands:

sudo ip netns exec nsserv ./netbench --server_only 1 --v6 false \
    --rx "io_uring --provide_buffers 0 --use_zc 1 \
    --zc_pool_pages 16384 --zc_ifname ptp-serv" --use_port 9999

sudo ip netns exec nscl ./netbench --client_only 1 --v6 false \
    --tx "epoll --threads 1 --per_thread 1 --size 2800" \
    --host 10.10.10.20 --use_port 9999

Hardware support is added to the Broadcom BNXT driver. This patchset +
userspace code was tested on an Intel Xeon Platinum 8321HC CPU and
Broadcom BCM57504 NIC.

Early benchmarks using this prototype, with iperf3 as a load generator,
showed a ~50% reduction in overall system memory bandwidth as measured
using perf counters. Note that DDIO must be disabled on Intel systems.
Build Netbench using the modified liburing above.

This patchset is based on the work by Jonathan Lemon
<jonathan.lemon@gmail.com>:
https://lore.kernel.org/io-uring/20221108050521.3198458-1-jonathan.lemon@gmail.com/

David Wei (13):
  io_uring: add interface queue
  io_uring: add mmap support for shared ifq ringbuffers
  netdev: add XDP_SETUP_ZC_RX command
  io_uring: setup ZC for an Rx queue when registering an ifq
  io_uring: add ZC buf and pool
  io_uring: add ZC pool API
  skbuff: add SKBFL_FIXED_FRAG and skb_fixed()
  io_uring: allocate a uarg for freeing zero copy skbs
  io_uring: delay ZC pool destruction
  net: add data pool
  io_uring: add io_recvzc request
  bnxt: use data pool
  io_uring/zcrx: add multi socket support per Rx queue

Pavel Begunkov (7):
  io_uring/zcrx: implement socket registration
  io_uring/zcrx: propagate ifq down the stack
  io_uring/zcrx: introduce io_zc_get_rbuf_cqe
  io_uring/zcrx: add copy fallback
  net: execute custom callback from napi
  io_uring/zcrx: copy fallback to ring buffers
  veth: add support for io_uring zc rx

 drivers/net/ethernet/broadcom/bnxt/bnxt.c     |  61 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.h     |   5 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c |   3 +
 drivers/net/veth.c                            | 179 +++-
 include/linux/io_uring.h                      |  33 +
 include/linux/io_uring_types.h                |   6 +
 include/linux/net.h                           |   2 +
 include/linux/netdevice.h                     |   7 +
 include/linux/skbuff.h                        |  10 +-
 include/net/busy_poll.h                       |   2 +
 include/net/data_pool.h                       |  74 ++
 include/net/netdev_rx_queue.h                 |   2 +
 include/uapi/linux/io_uring.h                 |  61 ++
 io_uring/Makefile                             |   3 +-
 io_uring/io_uring.c                           |  19 +
 io_uring/kbuf.c                               |  27 +
 io_uring/kbuf.h                               |   5 +
 io_uring/net.c                                | 136 ++-
 io_uring/opdef.c                              |  16 +
 io_uring/zc_rx.c                              | 967 ++++++++++++++++++
 io_uring/zc_rx.h                              |  69 ++
 net/core/dev.c                                |  51 +
 net/socket.c                                  |   1 +
 23 files changed, 1721 insertions(+), 18 deletions(-)
 create mode 100644 include/net/data_pool.h
 create mode 100644 io_uring/zc_rx.c
 create mode 100644 io_uring/zc_rx.h

-- 
2.39.3


