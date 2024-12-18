Return-Path: <io-uring+bounces-5532-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 312A89F5BA0
	for <lists+io-uring@lfdr.de>; Wed, 18 Dec 2024 01:36:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E81137A504F
	for <lists+io-uring@lfdr.de>; Wed, 18 Dec 2024 00:36:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 44B1F18E2A;
	Wed, 18 Dec 2024 00:36:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="WKS6vj8R"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E7AF1E48A
	for <io-uring@vger.kernel.org>; Wed, 18 Dec 2024 00:35:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734482161; cv=none; b=Q55DLaEvsdQAzVW1ZSjT/ta8BRg3udNnXYO9TOgBJagy+xNg8Ilem0cuL4KYB/KsnBWUdseG5L9xNWB2sqxmKiV6gOcH65w99w9FpGe9+sEp1cH69h7L7Q0jb4HOJ7zHXDCZMHRKLqFTu/l+vehXU7EbtwpBIP79mrsSpGdTmdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734482161; c=relaxed/simple;
	bh=50Dx9kmoOh+vzqjcHJ7hd+TYXXo2Bs+jHq9+zxvFQyk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=r0a2YLWnHS4B3zJS1Mzv0rHVZrqp61Fynd+mL1lD1BdcIJ3QRWqppzMpGyU6jP/JVbJMKg4hWQPS9fVF+MTi7UW20CapH6hDuKkSiMxHg7vc0VAy5y4EribB8CXM4vi0Gu3GrZWJ2qLorR5RVbYE4srZSJccyio1z9klEkB+Qb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=WKS6vj8R; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-216426b0865so52212795ad.0
        for <io-uring@vger.kernel.org>; Tue, 17 Dec 2024 16:35:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1734482158; x=1735086958; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=6lVdA4j4BxLY3YlbXJ79A+JCOlBT2Yv6eMvVrI1hxlk=;
        b=WKS6vj8RU6hbAKtzPud55qeJFCzPvzgcYAY9PmfpxkV6Pz+NE/68cx+PAc8EqewUPW
         rswx4sVjMLT/MVllALi3L2AZIvWcXUZL3ML5wfyLyJy7apVRnGg2Cw5CknJ39XjHPk2j
         iAIs4YFlFfYFOtN5gIUZa4JKne65aREtacqtMMd9bojxvHLS7FqD6cBcbSeSkUngSaSx
         4BjJRQl1p3ymDMc23RFZUJ9e0Y5lJK1RXIaUgZgE3FSQXSeao84fg8AY5UyzttuB2eJb
         EE4coZqn45qAc3k5sCNTY1VoChPt1PTc5vRacdqJDRY82xo5eItdVqDUc4fmyNyr+sxD
         hEpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734482158; x=1735086958;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6lVdA4j4BxLY3YlbXJ79A+JCOlBT2Yv6eMvVrI1hxlk=;
        b=nheLQQPBTX+Mdtdoud6hLqYuu6HVPmcxw2qOkrv7ETVTWkzPKAoHq56kXsV5pYKiiw
         mcFKJ6uuAkpELHAbDlLhANZm1h3sf9mu+DS+N9EYnjxgK+oCrefylgPf8XXlSx2MwWI4
         iNb8D+wmL1XDctEsC5LQ1104Pu/dWYkMwOIneul456mpGtTuVImIjdhi5kFQuccE+hrz
         BJ7x0DAIIApAxOYXj4zJiNnv0LBrT/dPIAimLgZ1wXi9eCuiKFiN8NsCIdYwWvbUS1Dm
         DaX0lOcN95XOmXO92t8AUuny0jY2Pj4PzdJa4eAONBJdEc7ZWMY6W0ZzwMnYRV2n89MD
         caOA==
X-Gm-Message-State: AOJu0Yy2h3hS3l5j7kzI48USETQ8AO2oCVURuqFw9nuvaGOOL7GXU6XQ
	RkCvu5YaOa0ck9oijzhad0BIVMCo2dB+rY0xkaTShcXV+N75J7J4Tl5IsrJ/qnRdcrhAxc0j302
	X
X-Gm-Gg: ASbGncuiQjLu45laZy6rQNvvX7Z82R9gkZtcOXUb38nz8X6vGe+aDS5Cv/PRE4djj6v
	CeeHQ1QKbk6JEYytc3ry3tiHxmqgalIsGdt3VRUjL8+c99y0WuY/kEZL+TGjWcVZ8AuZmVMnE16
	0Ixk7VZ9CjVxbIg/qNJUhHb4dLbA1TqWYr7Xbb16E7pTCoidA6xElD44CgZx8P4L8BXp9HzTcQK
	PofHmBDqaQebzDflUP6byxtrrE4r2Or6kSb5qZoCQ==
X-Google-Smtp-Source: AGHT+IEdyNf1j/g1LPpl7F8z+XnpGn7HyRl1ebsW4ErycQo3iikrgtwnq7J2iQQa6UhoZyM8LXH5zA==
X-Received: by 2002:a17:902:db0d:b0:215:9470:7e82 with SMTP id d9443c01a7336-218d6fbe456mr12586775ad.4.1734482158437;
        Tue, 17 Dec 2024 16:35:58 -0800 (PST)
Received: from localhost ([2a03:2880:ff:1f::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-218a1e640d3sm65190965ad.229.2024.12.17.16.35.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Dec 2024 16:35:57 -0800 (PST)
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
	Pedro Tammela <pctammela@mojatatu.com>
Subject: [PATCH net-next v9 00/21] io_uring zero copy rx
Date: Tue, 17 Dec 2024 16:35:28 -0800
Message-ID: <20241218003549.786301-1-dw@davidwei.uk>
X-Mailer: git-send-email 2.43.5
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This patchset adds support for zero copy rx into userspace pages using
io_uring, eliminating a kernel to user copy.

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

============
Pull Request
============

The following changes since commit d22f955cc2cb9684dd45396f974101f288869485:

  rust: net::phy scope ThisModule usage in the module_phy_driver macro (2024-12-17 13:30:45 +0100)

are available in the Git repository at:

  https://github.com/spikeh/linux zcrx/v9

for you to fetch changes up to ea606d17b90b853c8c72d490daaccfb81adce3b8:

  io_uring/zcrx: add selftest (2024-12-17 16:26:02 -0800)

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

Linux kernel branch:
[2]: https://github.com/spikeh/linux.git zcrx/v9

liburing for testing:
[3]: https://github.com/isilence/liburing.git zcrx/next

kperf for testing:
[4]: https://git.kernel.dk/kperf.git

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


David Wei (7):
  io_uring/zcrx: add interface queue and refill queue
  io_uring/zcrx: add io_zcrx_area
  net: page pool: export page_pool_set_dma_addr_netmem()
  io_uring/zcrx: add io_recvzc request
  io_uring/zcrx: set pp memory provider for an rx queue
  net: add documentation for io_uring zcrx
  io_uring/zcrx: add selftest

Jakub Kicinski (1):
  net: page_pool: create hooks for custom page providers

Pavel Begunkov (13):
  net: page_pool: don't cast mp param to devmem
  net: prefix devmem specific helpers
  net: generalise net_iov chunk owners
  net: page_pool: add mp op for netlink reporting
  net: page_pool: add a mp hook to unregister_netdevice*
  net: prepare for non devmem TCP memory providers
  net: expose page_pool_{set,clear}_pp_info
  net: page_pool: introduce page_pool_mp_return_in_cache
  io_uring/zcrx: grab a net device
  io_uring/zcrx: dma-map area for the device
  io_uring/zcrx: implement zerocopy receive pp memory provider
  io_uring/zcrx: throttle receive requests
  io_uring/zcrx: add copy fallback

 Documentation/networking/index.rst            |   1 +
 Documentation/networking/iou-zcrx.rst         | 201 ++++
 Kconfig                                       |   2 +
 include/linux/io_uring_types.h                |   6 +
 include/net/netmem.h                          |  21 +-
 include/net/page_pool/helpers.h               |  20 +
 include/net/page_pool/types.h                 |  13 +
 include/uapi/linux/io_uring.h                 |  54 +-
 include/uapi/linux/netdev.h                   |   1 +
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
 io_uring/zcrx.c                               | 936 ++++++++++++++++++
 io_uring/zcrx.h                               |  71 ++
 net/core/dev.c                                |  16 +-
 net/core/devmem.c                             |  91 +-
 net/core/devmem.h                             |  50 +-
 net/core/page_pool.c                          |  53 +-
 net/core/page_pool_priv.h                     |  26 -
 net/core/page_pool_user.c                     |   5 +-
 net/ipv4/tcp.c                                |   7 +-
 .../selftests/drivers/net/hw/.gitignore       |   2 +
 .../testing/selftests/drivers/net/hw/Makefile |   6 +
 .../selftests/drivers/net/hw/iou-zcrx.c       | 432 ++++++++
 .../selftests/drivers/net/hw/iou-zcrx.py      |  64 ++
 32 files changed, 2104 insertions(+), 103 deletions(-)
 create mode 100644 Documentation/networking/iou-zcrx.rst
 create mode 100644 io_uring/KConfig
 create mode 100644 io_uring/zcrx.c
 create mode 100644 io_uring/zcrx.h
 create mode 100644 tools/testing/selftests/drivers/net/hw/iou-zcrx.c
 create mode 100755 tools/testing/selftests/drivers/net/hw/iou-zcrx.py

-- 
2.43.5


