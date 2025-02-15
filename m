Return-Path: <io-uring+bounces-6455-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 06D78A3698E
	for <lists+io-uring@lfdr.de>; Sat, 15 Feb 2025 01:13:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4FBDC16DDA1
	for <lists+io-uring@lfdr.de>; Sat, 15 Feb 2025 00:11:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 254464C8F;
	Sat, 15 Feb 2025 00:10:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="Ho69KqqX"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26848EAF1
	for <io-uring@vger.kernel.org>; Sat, 15 Feb 2025 00:09:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739578202; cv=none; b=gb/PMSKHNfBgVgcqcqBmWBVx+K5s5C6EYRj/kJEJqSmGKiFNk63rpSySYzKP/o2fLx+EFzOS5R0HpR26/5eOWVSlENOsvBBNaJz5L9eUDWIaLoa2D+sS6LxyAT6iQgGMZvTRGrvJ6Xb5840udLdbuUD1RhNWS3xq+2mjFFl3N+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739578202; c=relaxed/simple;
	bh=L4nGRhBPmFgPHVVSEX9BjtFkYHr7IBZgu9THPPcYsMg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=HILBo6hAL+4VDKVzXMfsItkgRNcz2OxS/dUozZeFREAYfDQ5Pfj6Pw8m833PkWvFlgsVbxk30VKaP36mp/BK0jqzFeCfjAuTn194a7c9bFmUU/1FAr+L0eb4KKlz1gLjIVsNHvf0LZyw5sOc/dstswWVsmIgMlya5s0bA9YNNOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=Ho69KqqX; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-220e83d65e5so35591055ad.1
        for <io-uring@vger.kernel.org>; Fri, 14 Feb 2025 16:09:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1739578199; x=1740182999; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=TU2lLPsuD+1Wjb3qbpreSH3syxEnbs/l9acOJdZRAOQ=;
        b=Ho69KqqXSO+oI21I93w9y9tgIxU0UP9c6m7Cz3pZ0UkBUddK5Q3vjwpM4EOrqJRY8G
         mdEslm7qbM4LB9EJXs3tTS6BD4dGoYI4w7I57mm+bcoXBZIF7IqL5CIFBUpoi0Ykn6hL
         V4n5KLsPiTLmIbjM2qPiakfXq8CJ6bKfSb/Bd70Q62trRMhee+YsfeWYBHBWi8D7OA4b
         fl+t4LSRAYD9mvtY+VPDhe6ZVHR5rupSVElFvrt8ZWTEYxQjYQSaJY09FVgCQ0FdTrrb
         iT+daBm7w9sYf5xzjBolOVJ0nkRLvxSb2tD3HRQ/BdMRNVtfZFugAohoGhQ61LoeoZCT
         oBUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739578199; x=1740182999;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TU2lLPsuD+1Wjb3qbpreSH3syxEnbs/l9acOJdZRAOQ=;
        b=mIA8uTYXI/oiSP+rcxCpwlk4GKolYraEjKocQ0ZdwX7FW9b0/faOKqDMAluQn3UZB+
         w36adaC++/xXwTPZWEVL1bE1MFsHY+AM6/yDyhqsynPLfAmuvbdDZS98jMBSHPzwgIB2
         pQQVuoP7f/fejxVnyfzE7dT1NvKkkRV/TysAd5vH9otYEPY0/QedsX98tTTaSP8y1Uso
         46gNtnpENlsmc2htlXNl+D2Ljqsg2Bto6wwdJv7AAglxaRAvbgwmUPxEnztWpIqZW2ll
         pz6lyv2aO4NLijL1TJQXBZxxttKArVj2Ax0nfnO4eM4UYisgDaSzPVy6Tvfx5zGdvrf0
         kvBw==
X-Gm-Message-State: AOJu0YyOUqXKfQ6Cvs0LS4Q4ETjgEtoV6RdsQd1ODKj619oCr1RIQ7Fo
	8v4YbkC1VPQ8ynUWwiZB+coHFGPHmMHov7g3ZRHUcgpJWfwoCL7MoexZZDCNjjUSyCpofjz2sDz
	A
X-Gm-Gg: ASbGncsjQaPrHZMQYAsyajo6AHoF5hTFEpNfNI5DI5tZ5s4f9nzvcPQGa6yYNHQsUzq
	SXi1zY6XlBJGB7yrLvIPnrCckPfu5h178QA7skWebIm3wofYWYIxa843SgQqYYYcjx2fEBoE1CG
	toJWbG+hpOnykaJyy2x7F2ZaDdRNIsHarqXAZp0XJtzA1WxWr0ZwPbLcvIxO6VdZTf6ofI0OTVp
	tnL60NBdQIb9ul6XnTsibp+jkyad4K/gw6hQ6obvaW+nrJeveIN73MAUcOjKS52MPNl8qYeNiY=
X-Google-Smtp-Source: AGHT+IFtxUdAGsWw/0C9+tu/5Zdu9VucwTHcdgSl4Cw98cDK35mU5kWXBYj/c6cc8QB0vdasn+u3TQ==
X-Received: by 2002:a05:6a20:394b:b0:1ee:1af5:86a9 with SMTP id adf61e73a8af0-1ee8cb17bbcmr3032976637.22.1739578199303;
        Fri, 14 Feb 2025 16:09:59 -0800 (PST)
Received: from localhost ([2a03:2880:ff:3::])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-73257bdca3fsm1507123b3a.161.2025.02.14.16.09.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Feb 2025 16:09:58 -0800 (PST)
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
	Stanislav Fomichev <stfomichev@gmail.com>,
	Joe Damato <jdamato@fastly.com>,
	Pedro Tammela <pctammela@mojatatu.com>,
	lizetao <lizetao1@huawei.com>
Subject: [PATCH v14 00/11] io_uring zero copy rx
Date: Fri, 14 Feb 2025 16:09:35 -0800
Message-ID: <20250215000947.789731-1-dw@davidwei.uk>
X-Mailer: git-send-email 2.43.5
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This patchset contains io_uring patches needed by a new io_uring request
implementing zero copy rx into userspace pages, eliminating a kernel to
user copy.

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
[2]: https://github.com/isilence/linux.git zcrx/v13

liburing for testing:
[3]: https://github.com/isilence/liburing.git zcrx/next

kperf for testing:
[4]: https://git.kernel.dk/kperf.git

Changes in v14:
---------------
* Remove net-next in patch subjects
* Cast to struct sockaddr in selftest for bind() and connect()

Changes in v13:
---------------
io_uring
* Add missing ~IORING_ZCRX_AREA_MASK
* Update documentation
* Selftest changes
  * Remove ipv4 support
  * Use ethtool() instea dof cmd()

net
* Fix race between io_uring closing and netdev unregister
* Regenerate Netlink YAML

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

David Wei (6):
  io_uring/zcrx: add interface queue and refill queue
  io_uring/zcrx: add io_zcrx_area
  io_uring/zcrx: add io_recvzc request
  io_uring/zcrx: set pp memory provider for an rx queue
  net: add documentation for io_uring zcrx
  io_uring/zcrx: add selftest

Pavel Begunkov (5):
  io_uring/zcrx: grab a net device
  io_uring/zcrx: implement zerocopy receive pp memory provider
  io_uring/zcrx: dma-map area for the device
  io_uring/zcrx: throttle receive requests
  io_uring/zcrx: add copy fallback

 Documentation/networking/index.rst            |   1 +
 Documentation/networking/iou-zcrx.rst         | 202 ++++
 Kconfig                                       |   2 +
 include/linux/io_uring_types.h                |   6 +
 include/uapi/linux/io_uring.h                 |  54 +-
 io_uring/KConfig                              |  10 +
 io_uring/Makefile                             |   1 +
 io_uring/io_uring.c                           |   7 +
 io_uring/io_uring.h                           |  10 +
 io_uring/memmap.h                             |   1 +
 io_uring/net.c                                |  74 ++
 io_uring/opdef.c                              |  16 +
 io_uring/register.c                           |   7 +
 io_uring/rsrc.c                               |   2 +-
 io_uring/rsrc.h                               |   1 +
 io_uring/zcrx.c                               | 954 ++++++++++++++++++
 io_uring/zcrx.h                               |  73 ++
 .../selftests/drivers/net/hw/.gitignore       |   2 +
 .../testing/selftests/drivers/net/hw/Makefile |   5 +
 .../selftests/drivers/net/hw/iou-zcrx.c       | 426 ++++++++
 .../selftests/drivers/net/hw/iou-zcrx.py      |  64 ++
 21 files changed, 1916 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/networking/iou-zcrx.rst
 create mode 100644 io_uring/KConfig
 create mode 100644 io_uring/zcrx.c
 create mode 100644 io_uring/zcrx.h
 create mode 100644 tools/testing/selftests/drivers/net/hw/iou-zcrx.c
 create mode 100755 tools/testing/selftests/drivers/net/hw/iou-zcrx.py

-- 
2.43.5


