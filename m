Return-Path: <io-uring+bounces-5977-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BD56EA153C9
	for <lists+io-uring@lfdr.de>; Fri, 17 Jan 2025 17:11:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 26C733A18C5
	for <lists+io-uring@lfdr.de>; Fri, 17 Jan 2025 16:11:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C8EC18B495;
	Fri, 17 Jan 2025 16:11:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Gq3YzDRS"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 603561946C7;
	Fri, 17 Jan 2025 16:11:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737130281; cv=none; b=Al7DI+RfzLe/MuF317z/Q734OqQPG0swXTlfW4rlQEtHH8Rq3w2+TCApnrl+3rbx/9l8pruLbZ17AI+gqoBGjjaHutYUe0IAUNbFbF39tJsdZ/Dd2vjZOFzyLWPbH7rRucnKbt2O5GrmvmjAzD2BZRPZTbHcFuey54O+1BUlK8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737130281; c=relaxed/simple;
	bh=EESGJbpWFW67yiNMBQcbXcr5GGjIfKJrTqdRjPTjB0Y=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=qP0aRnLYb5xzCEa8SOjMYc3MyjNw4oXD/1mQSdA0TAghcV8VquWDGxJZOBnWCbQW8h07hGo4kDCTg5Z3cH8zgA5J1EhwMRt2cRxfuuXHZUv9LZ6qiekVOQHRZjOfcvbG0F072TUQYQi4mRkfo0rsT9RHNogVL4H5vUN086J2m9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Gq3YzDRS; arc=none smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-5d3ecae02beso3202015a12.0;
        Fri, 17 Jan 2025 08:11:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737130277; x=1737735077; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=UiOkSPky5jnvcQbG0jVwBd8T1QSgWUQYT/uccfdcKmI=;
        b=Gq3YzDRScUOt8P6iyGRuXoVc50B/MqLMty5iP+pqUm9GvQ9bvcgsT48oLxHko6Mw8r
         JhaPgqpleNp6qWoZAI2X26+emnx2tpDR/uD6du+Vmj34Q97Uj4MbEViPO/ByAgfxPOP/
         lVrXA58WQcaidykzBklaZ/Rf1uQDsb9oNi/kX2HRoUvnZ/SofAmam9lE8ekPBxRwVLyP
         +jV0HNROe17Rh+adATgsilABT3QGQ/Se/P90Grpc9tHkZVp5ebcPdpNiMFzSuaDc0MvS
         WhlKUTv835zV3W5HtP9usbk+ffeMNVjp8Xpi25x8gL1Je519L1KFydXHNa9OvsLncOTP
         LSVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737130277; x=1737735077;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UiOkSPky5jnvcQbG0jVwBd8T1QSgWUQYT/uccfdcKmI=;
        b=aaFn/mGnWgCIc2lUgsRA66Jax+15gVDpRU8B7hLw2QETdF9kK30yQmTcuVmL0n2HVJ
         DYltzDEMRhCQtocSKwOvrB/hte9EKqwflhtiZ99K5WGEwXk4bqy/QgZWOEpR+e2J6Snt
         YQSQskQ8cTGM7HCPiWnoX226a73jX/7/xhkbltWTTnG4ChcBTSEGaYoSXvKXS2BiRR4E
         7IcBrqaG4uOsh1+jXFwfPEbMRmktCUIb7XNdTj9Fn/o/ue+rB/PG5pm45zo3VBgPW8x9
         MY+7U0at6M10g234XH7jU7A7UIORSOh5Xfq8P9Iky1Gn0cSYNvNN7OmzTYdrdfLrc5Ea
         +UrQ==
X-Forwarded-Encrypted: i=1; AJvYcCUTII5/pzi2NxlGJWRndAYrxHqjjZn18694qtnu0kfEHOn1iMXSDmbA4YplzVf0wmJui5E1OcM=@vger.kernel.org
X-Gm-Message-State: AOJu0YwTR2NXSFZmQCjqo29kJcQo8Y3PoH2D4JbUN1K7Jdjsc43HVz6c
	gu65FC1A7TK5OojkBxb5i6mmax/RNt98jDaHDarB+RUfYuuMsbpRuDT0Jw==
X-Gm-Gg: ASbGncttqLoVOofxdABZOY2iLxXyZRvinUAz5VQK06vS2ZzkFvgeSzwMoCGzY1ELS/F
	orV5sFbfiozdGQn+xHZeCA9+GzWojwr1roYoc8zmwBsxX2sH3nQzgg1yq/Fad7kykFdmci2Q+cP
	J3kw4W8RQ4iVOlrXpCkdMWIQ2QRW9q3dOyLvA3ZsN662Wpn8SSKw90+PmknS2vFcB2zX6vS8Gi9
	e5enPzEXRr4P8fA5Y4t5fcYm68xr+JZOf0/1NBz
X-Google-Smtp-Source: AGHT+IFK75OyTvYTBdyii1YjGe1ya/bOpVL/YnfL4ozdt8BvGS9g7d/AjluJynJC+WjF8OaeVroMvQ==
X-Received: by 2002:a17:907:7da5:b0:aab:8a9d:6d81 with SMTP id a640c23a62f3a-ab38b3afad9mr347117566b.44.1737130277086;
        Fri, 17 Jan 2025 08:11:17 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::1:56de])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab384f23007sm193716366b.96.2025.01.17.08.11.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jan 2025 08:11:16 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org,
	netdev@vger.kernel.org
Cc: asml.silence@gmail.com,
	Jens Axboe <axboe@kernel.dk>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	David Ahern <dsahern@kernel.org>,
	Mina Almasry <almasrymina@google.com>,
	Stanislav Fomichev <stfomichev@gmail.com>,
	Joe Damato <jdamato@fastly.com>,
	Pedro Tammela <pctammela@mojatatu.com>,
	David Wei <dw@davidwei.uk>
Subject: [PATCH net-next v12 00/10] io_uring zero copy rx
Date: Fri, 17 Jan 2025 16:11:38 +0000
Message-ID: <cover.1737129699.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This patchset contains net/ patches needed by a new io_uring request
implementing zero copy rx into userspace pages, eliminating a kernel
to user copy.

We configure a page pool that a driver uses to fill a hw rx queue to
hand out user pages instead of kernel pages. Any data that ends up
hitting this hw rx queue will thus be dma'd into userspace memory
directly, without needing to be bounced through kernel memory. 'Reading'
data out of a socket instead becomes a _notification_ mechanism, where
the kernel tells userspace where the data is. The overall approach is
similar to the devmem TCP proposal.

This relies on hw header/data split, flow steering and RSS to ensure
packet headers remain in kernel memory and only desired flows hit a hw
rx queue configured for zero copy. Configuring this is outside of the
scope of this patchset.

We share netdev core infra with devmem TCP. The main difference is that
io_uring is used for the uAPI and the lifetime of all objects are bound
to an io_uring instance. Data is 'read' using a new io_uring request
type. When done, data is returned via a new shared refill queue. A zero
copy page pool refills a hw rx queue from this refill queue directly. Of
course, the lifetime of these data buffers are managed by io_uring
rather than the networking stack, with different refcounting rules.

This patchset is the first step adding basic zero copy support. We will
extend this iteratively with new features e.g. dynamically allocated
zero copy areas, THP support, dmabuf support, improved copy fallback,
general optimisations and more.

In terms of netdev support, we're first targeting Broadcom bnxt. Patches
aren't included since Taehee Yoo has already sent a more comprehensive
patchset adding support in [1]. Google gve should already support this,
and Mellanox mlx5 support is WIP pending driver changes.

===========
Performance
===========

Note: Comparison with epoll + TCP_ZEROCOPY_RECEIVE isn't done yet.

Test setup:
* AMD EPYC 9454
* Broadcom BCM957508 200G
* Kernel v6.11 base [2]
* liburing fork [3]
* kperf fork [4]
* 4K MTU
* Single TCP flow

With application thread + net rx softirq pinned to _different_ cores:

+-------------------------------+
| epoll     | io_uring          |
|-----------|-------------------|
| 82.2 Gbps | 116.2 Gbps (+41%) |
+-------------------------------+

Pinned to _same_ core:

+-------------------------------+
| epoll     | io_uring          |
|-----------|-------------------|
| 62.6 Gbps | 80.9 Gbps (+29%)  |
+-------------------------------+

=====
Links
=====

Broadcom bnxt support:
[1]: https://lore.kernel.org/netdev/20241003160620.1521626-8-ap420073@gmail.com/

Linux kernel branch including io_uring bits:
[2]: https://github.com/isilence/linux.git zcrx/v12

liburing for testing:
[3]: https://github.com/isilence/liburing.git zcrx/next

kperf for testing:
[4]: https://git.kernel.dk/kperf.git

Changes in v12:
---------------
* Check nla_nest_start() errors
* Don't leak a netdev, add missing netdev_put()
* Warn on failed queue restart during close

Changes in v11:
---------------
* Add a shim provider helper for page_pool_set_dma_addr_netmem()
* Drop netdev in ->uninstall, pin struct device instead
* Add net_mp_open_rxq() and net_mp_close_rxq()
* Remove unneeded CFLAGS += -I/usr/include/ in selftest Makefile

Changes in v10:
---------------
* Fix !CONFIG_PAGE_POOL build
* Use acquire/release for RQ in examples
* Fix page_pool_ref_netmem for net_iov
* Move provider helpers / definitions into a new file
* Don’t export page_pool_{set,clear}_pp_info, introduce
  net_mp_niov_{set,clear}_page_pool() instead
* Remove devmem.h from net/core/page_pool_user.c
* Add Netdev yaml for io-uring attribute
* Add memory provider ops for filling in Netlink info

Changes in v9:
--------------
* Fail proof against multiple page pools running the same memory
  provider
  * Lock the consumer side of the refill queue.
  * Move scrub into io_uring exit.
  * Kill napi_execute.
  * Kill area init api and export finer grained net helpers as partial
    init now need to happen in ->alloc_netmems()
* Separate user refcounting.
  * Fix copy fallback path math.
* Add rodata check to page_pool_init()
* Fix incorrect path in documentation

Changes in v8:
--------------
* add documentation and selftest
* use io_uring regions for the refill ring

Changes in v7:
--------------
net:
* Use NAPI_F_PREFER_BUSY_POLL for napi_execute + stylistics changes.

Changes in v6:
--------------
Please note: Comparison with TCP_ZEROCOPY_RECEIVE isn't done yet.

net:
* Drop a devmem.h clean up patch.
* Migrate to netdev_get_by_index from deprecated API.
* Fix !CONFIG_NET_DEVMEM build.
* Don’t return into the page pool cache directly, use a new helper
* Refactor napi_execute

io_uring:
* Require IORING_RECV_MULTISHOT flag set.
* Add unselectable CONFIG_IO_URING_ZCRX.
* Pulled latest io_uring changes.
* Unexport io_uring_pp_zc_ops.

Changes in v5:
--------------
* Rebase on top of merged net_iov + netmem infra.
* Decouple net_iov from devmem TCP.
* Use netdev queue API to allocate an rx queue.
* Minor uAPI enhancements for future extensibility.
* QoS improvements with request throttling.

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

David Wei (2):
  netdev: add io_uring memory provider info
  net: add helpers for setting a memory provider on an rx queue

Pavel Begunkov (8):
  net: page_pool: don't cast mp param to devmem
  net: prefix devmem specific helpers
  net: generalise net_iov chunk owners
  net: page_pool: create hooks for custom memory providers
  net: page_pool: add callback for mp info printing
  net: page_pool: add a mp hook to unregister_netdevice*
  net: prepare for non devmem TCP memory providers
  net: page_pool: add memory provider helpers

 Documentation/netlink/specs/netdev.yaml | 15 ++++
 include/net/netmem.h                    | 21 +++++-
 include/net/page_pool/memory_provider.h | 45 ++++++++++++
 include/net/page_pool/types.h           |  4 ++
 include/uapi/linux/netdev.h             |  8 +++
 net/core/dev.c                          | 16 ++++-
 net/core/devmem.c                       | 93 ++++++++++++++++---------
 net/core/devmem.h                       | 49 ++++++-------
 net/core/netdev-genl.c                  | 11 +--
 net/core/netdev_rx_queue.c              | 62 +++++++++++++++++
 net/core/page_pool.c                    | 51 +++++++++++---
 net/core/page_pool_user.c               |  7 +-
 net/ipv4/tcp.c                          |  7 +-
 tools/include/uapi/linux/netdev.h       |  8 +++
 14 files changed, 316 insertions(+), 81 deletions(-)
 create mode 100644 include/net/page_pool/memory_provider.h

-- 
2.47.1


