Return-Path: <io-uring+bounces-299-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A1EE8191E0
	for <lists+io-uring@lfdr.de>; Tue, 19 Dec 2023 22:04:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9C78E1C250A3
	for <lists+io-uring@lfdr.de>; Tue, 19 Dec 2023 21:04:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B978A39FE5;
	Tue, 19 Dec 2023 21:04:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="I0iQOps6"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E5A43B783
	for <io-uring@vger.kernel.org>; Tue, 19 Dec 2023 21:04:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-28a5d0ebf1fso78845a91.0
        for <io-uring@vger.kernel.org>; Tue, 19 Dec 2023 13:04:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1703019845; x=1703624645; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=jbsYRKKLT/j29iXR1ovOjOBDsbY1yrRznph85F2Xhmg=;
        b=I0iQOps6jwngrZ6YBnewv88nikEP+4Sp6Js5gtGSPpCasDSmjfzEAyavWqyXwwG/3+
         FTlaWJN1V+AdpEe0H+QUCOp8hIhYX11RxgkJNwVh/41q+Stl0nxoSGxYk/X1LUk+Pap/
         DU5uPMhTC/Tg9Jexv5gESYu8Cn847WYVhDiYS+9iPMxyhZohdg+hz4rPb1WaAHFrfvF/
         Mis0GVJadXBhT4hiGuCNbhEOKTAAmdGC/gtfnqgFVrZub3mutUgwhfOo1yVCtVNv9ywK
         YprNwcgfKXoGBbjG1wI+y/4SMX3JYk9Ipi4OsM2gA85/KuupGZbGQalUzPBQuMAMGmqj
         SDBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703019845; x=1703624645;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jbsYRKKLT/j29iXR1ovOjOBDsbY1yrRznph85F2Xhmg=;
        b=TkP6zT62pY4YSMK6PAc3xMsxsu5od6725rxrf4FiulxI9UBRe2i/X703voj8Eo6FcB
         xMe6U+zbjLczQwPxFbxMSAGKOQ/UO7um0nFZEcjJ/H27BQ8qabROmVTtQYoCzB7dLEIJ
         XMPZHKhW8BQZBYTi31FON84OpWEe0Tgagygzd4sELEyo+feXlB0eHX4fgNJabOOBKyUB
         VkE7qm/zR8/LmKz0/mP6qCkJwP72TxkPuoDsG/sXBOxqw2fYyCsIAqyii3W57a4hXiFi
         DWFnIRqcFRmV3r5buAL8RuAzS5SaxkgWdCawnyQ/CkrSBzb4T701sqvBfLTs3m/AZVFK
         zv8g==
X-Gm-Message-State: AOJu0YxAtAwksl8V7aJDhMXkYxoGOt5c/dG1hEoB7OC8vVlhGxa3aZSf
	y5JQupWi4XhSEP12J5RYAEz5/VhoUpDl4zJw2pnm0QPicvbFow==
X-Google-Smtp-Source: AGHT+IHbnzMdXLx6coHoN6mLUWNAOwEyI6Ie8AkiJQG9NCQ6J5zB0Iy9EoUbKl9Dsl1oiCAme6O09w==
X-Received: by 2002:a17:90a:4f49:b0:28b:d31d:bca5 with SMTP id w9-20020a17090a4f4900b0028bd31dbca5mr12014pjl.32.1703019845094;
        Tue, 19 Dec 2023 13:04:05 -0800 (PST)
Received: from localhost (fwdproxy-prn-009.fbsv.net. [2a03:2880:ff:9::face:b00c])
        by smtp.gmail.com with ESMTPSA id st16-20020a17090b1fd000b0028a4c85a55csm2111869pjb.27.2023.12.19.13.04.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Dec 2023 13:04:04 -0800 (PST)
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
	Mina Almasry <almasrymina@google.com>
Subject: [RFC PATCH v3 00/20] Zero copy Rx using io_uring
Date: Tue, 19 Dec 2023 13:03:37 -0800
Message-Id: <20231219210357.4029713-1-dw@davidwei.uk>
X-Mailer: git-send-email 2.39.3
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patchset is a proposal that adds zero copy network Rx to io_uring.
With it, userspace can register a region of host memory for receiving
data directly from a NIC using DMA, without needing a kernel to user
copy.

Full kernel tree including some out of tree BNXT changes:

https://github.com/spikeh/linux/tree/zcrx_sil

On the userspace side, support is added to both liburing and Netbench:

https://github.com/spikeh/liburing/tree/zcrx2
https://github.com/spikeh/netbench/tree/zcrx

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

Changes in RFC v3:
------------------

* Rebased on top of Jakub Kicinski's memory provider API RFC. The ZC
  pool added is now a backend for memory provider.
* We're also reusing ppiov infrastructure. The refcounting rules stay
  the same but it's shifted into ppiov->refcount. That lets us to
  flexibly manage buffer lifetimes without adding any extra code to the
  common networking paths. It'd also make it easier to support dmabufs
  and device memory in the future.
  * io_uring also knows about pages, and so ppiovs might unnecessarily
    break tools inspecting data, that can easily be solved later.

Many patches are not for upstream as they depend on work in progress,
namely from Mina:

* struct netmem_t
* Driver ndo commands for Rx queue configs
* struct page_pool_iov and shared pp infra

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

* Proper test driver + selftests, maybe netdevsim.
* Revisiting userspace API.
* Multi-region support.
* Steering setup.
* Further optimisation work.
* ...and more.

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

David Wei (6):
  io_uring: add interface queue
  io_uring: add mmap support for shared ifq ringbuffers
  netdev: add XDP_SETUP_ZC_RX command
  io_uring: setup ZC for an Rx queue when registering an ifq
  io_uring: add ZC buf and pool
  io_uring: add io_recvzc request

Pavel Begunkov (14):
  net: page_pool: add ppiov mangling helper
  tcp: don't allow non-devmem originated ppiov
  net: page pool: rework ppiov life cycle
  net: enable napi_pp_put_page for ppiov
  net: page_pool: add ->scrub mem provider callback
  io_uring: separate header for exported net bits
  io_uring/zcrx: implement socket registration
  io_uring: implement pp memory provider for zc rx
  net: page pool: add io_uring memory provider
  net: execute custom callback from napi
  io_uring/zcrx: add copy fallback
  veth: add support for io_uring zc rx
  net: page pool: generalise ppiov dma address get
  bnxt: enable io_uring zc page pool

 drivers/net/ethernet/broadcom/bnxt/bnxt.c     |  71 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.h     |   7 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c |   3 +
 drivers/net/veth.c                            | 211 +++-
 include/linux/io_uring.h                      |   6 -
 include/linux/io_uring/net.h                  |  31 +
 include/linux/io_uring_types.h                |   8 +
 include/linux/net.h                           |   2 +
 include/linux/netdevice.h                     |   6 +
 include/net/busy_poll.h                       |   7 +
 include/net/page_pool/helpers.h               |  27 +-
 include/net/page_pool/types.h                 |   4 +
 include/uapi/linux/io_uring.h                 |  61 ++
 io_uring/Makefile                             |   2 +-
 io_uring/io_uring.c                           |  24 +
 io_uring/net.c                                | 133 ++-
 io_uring/opdef.c                              |  16 +
 io_uring/uring_cmd.c                          |   1 +
 io_uring/zc_rx.c                              | 954 ++++++++++++++++++
 io_uring/zc_rx.h                              |  80 ++
 net/core/dev.c                                |  46 +
 net/core/page_pool.c                          |  68 +-
 net/core/skbuff.c                             |  28 +-
 net/ipv4/tcp.c                                |   7 +
 net/socket.c                                  |   3 +-
 25 files changed, 1737 insertions(+), 69 deletions(-)
 create mode 100644 include/linux/io_uring/net.h
 create mode 100644 io_uring/zc_rx.c
 create mode 100644 io_uring/zc_rx.h

-- 
2.39.3


