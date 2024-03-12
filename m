Return-Path: <io-uring+bounces-902-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 02692879DB4
	for <lists+io-uring@lfdr.de>; Tue, 12 Mar 2024 22:46:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A9BF62825E4
	for <lists+io-uring@lfdr.de>; Tue, 12 Mar 2024 21:46:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6BB6143C7B;
	Tue, 12 Mar 2024 21:44:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="flv4yFm4"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9FEA143753
	for <io-uring@vger.kernel.org>; Tue, 12 Mar 2024 21:44:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710279876; cv=none; b=MaqjLlXBwfw1JZ9qAtUQQMaPoQ5Zq9tIm+7BA05fzf5QCXJju089G5ELFpqQA+IK33wcXzz0h2KvXSm0/lu6PcMoqrfuXl2HJD+tyiHWPE1LBpVg2o7ht+yohhDSMzHyG23UqUa6z2VAZe9nnN/8Zc4UEzaNf9ADJuW08IUpfyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710279876; c=relaxed/simple;
	bh=HbMLQ0HD1E7UHtw4VSX38KM+HT5CUH3L0YK3XDrE/18=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=JWXCXvJhaHnsf+oarzYlezvNo+i9wdgynK4803/kaaaK+vAdJDzYn7wfbrcwwPEmKd/lS7u9PcUA5Vb+2k8AVd+2cDDRgnfWNoBDfokeNmkeeztWS8zFfDp+0evTtKuJXdWbGAifgW6/A9zxv5vA7ndAQJ6mrVL9+Xc1/iSzuEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=flv4yFm4; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-1dd10a37d68so3422795ad.2
        for <io-uring@vger.kernel.org>; Tue, 12 Mar 2024 14:44:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1710279874; x=1710884674; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=5eO8gM2RtZqrOolc6NogGR6fkDkvymdIIdLJNjiyriQ=;
        b=flv4yFm40E4U6N+ZsvdOzskCxYQnpxUacbcyoj0qIRmkJBW9rvKK453qylFvWNkoto
         m9pYh3kOtiV3g11jo2j6iJP5elc8SExR+S64a9gfh9TCZ86blnDbwQ8mr7cAj/b83UBH
         AJLMe5jm3CEU4ekw2jSUUupn5PyKp66FyJEjmUhNqg0mf8Q9bdhYII1lvn/QcM0yF1A5
         vDBx5wJ37mC3I3G/P6hLbYhrBQNiSPXlHzcL0n6DeQ4N2VG007LOCwBj/tjxSWOUvq1B
         dX/Ha7nDnou+mK1OWztFTGwx+UCsVJVtY6UBGQBx1UQlmPXvM5B/GXnwrFfga1bDSamo
         KGSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710279874; x=1710884674;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5eO8gM2RtZqrOolc6NogGR6fkDkvymdIIdLJNjiyriQ=;
        b=bz2F6pbLhFg3b2BZFC5ciaUZVWoLs80MG9KyPzug+Rw+2J3Dk9xll5+ro2xVtdxsTT
         2xF4w5hmHWg10aJPZ8VIt70kAEPwwL640eDyiVGD1UOteaWOMLUSuommHJQ/okItvmqz
         b7P3Mc7fToQxvYviCFcuavIQg2et0bToojSWeHcbGTnW+cWO1EBjFaVLuhq4gU0CG5wn
         2EaaKj9/9Jlf2/U8/4JU0Hdb+v9dqhVZL4o5nhjUYSq2bqJ/ZPUzpDWSmH+LAK4WreuL
         /y8+V8u3g2OaWegLDKK1a+hpqdoWbSMBrlKsQwtwOw4cEH6THrEznUTAS67dhavmV+26
         5Wnw==
X-Gm-Message-State: AOJu0YzW9IUK2jr8bLPTv151+YWqMMHuxzuo8YpH2C/KdatWM6nRIPXd
	l0AkhKLpZo90ZH7amY1VjTrKh9rsWWgzSIGDcbMrq9d4w5BEFG57pdkyhjvG8KK/0WQ2nYkwHtF
	3
X-Google-Smtp-Source: AGHT+IGUZlbyBfpryoFo8y1ZZRCIJc9MaGPPUkOazFNOkaPw8jH3LQWVOeCb8g9FlTX8rjpYBtp/ww==
X-Received: by 2002:a17:903:110c:b0:1dc:cbaa:f5dd with SMTP id n12-20020a170903110c00b001dccbaaf5ddmr1844263plh.39.1710279873881;
        Tue, 12 Mar 2024 14:44:33 -0700 (PDT)
Received: from localhost (fwdproxy-prn-014.fbsv.net. [2a03:2880:ff:e::face:b00c])
        by smtp.gmail.com with ESMTPSA id t8-20020a170902e84800b001c407fac227sm7162255plg.41.2024.03.12.14.44.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Mar 2024 14:44:33 -0700 (PDT)
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
Subject: [RFC PATCH v4 00/16] Zero copy Rx using io_uring
Date: Tue, 12 Mar 2024 14:44:14 -0700
Message-ID: <20240312214430.2923019-1-dw@davidwei.uk>
X-Mailer: git-send-email 2.43.0
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

This is still a WIP and has a list of known issues. We're looking for
feedback on the overall approach.

Full kernel tree including some out of tree BNXT changes:

https://github.com/spikeh/linux/tree/zcrx

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

Changes in RFC v4:
------------------

* Rebased on top of Mina Almasry's TCP devmem patchset and latest
  net-next, now sharing common infra e.g.:
    * netmem_t and net_iovs
    * Page pool memory provider
* The registered buffer (rbuf) completion queue where completions from
  io_recvzc requests are posted is removed. Now these post into the main
  completion queue, using big (32-byte) CQEs. The first 16 bytes is an
  ordinary CQE, while the latter 16 bytes contain the io_uring_rbuf_cqe
  as before. This vastly simplifies the uAPI and removes a level of
  indirection in userspace when looking for payloads.
  * The rbuf refill queue is still needed for userspace to return
    buffers to kernel.
* Simplified code and uAPI on the io_uring side, particularly
  io_recvzc() and io_zc_rx_recv(). Many unnecessary lines were removed
  e.g. extra msg flags, readlen, etc.

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

David Wei (7):
  io_uring: introduce interface queue
  io_uring: add mmap support for shared ifq ringbuffers
  netdev: add XDP_SETUP_ZC_RX command
  io_uring: setup ZC for an Rx queue when registering an ifq
  io_uring: add zero copy buf representation and pool
  io_uring: add io_recvzc request
  io_uring/zcrx: add copy fallback

Pavel Begunkov (9):
  net: generalise pp provider params passing
  io_uring: delayed cqe commit
  net: page_pool: add ->scrub mem provider callback
  io_uring: separate header for exported net bits
  io_uring/zcrx: implement socket registration
  io_uring: implement pp memory provider for zc rx
  io_uring/zcrx: implement PP_FLAG_DMA_* handling
  net: execute custom callback from napi
  veth: add support for io_uring zc rx

 drivers/net/veth.c             | 214 +++++++-
 include/linux/io_uring.h       |   6 -
 include/linux/io_uring/net.h   |  30 ++
 include/linux/io_uring_types.h |   5 +
 include/linux/net.h            |   2 +
 include/linux/netdevice.h      |   6 +
 include/net/busy_poll.h        |   7 +
 include/net/netdev_rx_queue.h  |   3 +
 include/net/page_pool/types.h  |   2 +
 include/uapi/linux/io_uring.h  |  50 ++
 io_uring/Makefile              |   3 +-
 io_uring/io_uring.c            |  15 +-
 io_uring/io_uring.h            |  10 +
 io_uring/net.c                 | 108 +++-
 io_uring/opdef.c               |  16 +
 io_uring/register.c            |  13 +
 io_uring/uring_cmd.c           |   1 +
 io_uring/zc_rx.c               | 916 +++++++++++++++++++++++++++++++++
 io_uring/zc_rx.h               |  83 +++
 net/core/dev.c                 |  48 +-
 net/core/page_pool.c           |   8 +-
 net/socket.c                   |   3 +-
 22 files changed, 1530 insertions(+), 19 deletions(-)
 create mode 100644 include/linux/io_uring/net.h
 create mode 100644 io_uring/zc_rx.c
 create mode 100644 io_uring/zc_rx.h

-- 
2.43.0


