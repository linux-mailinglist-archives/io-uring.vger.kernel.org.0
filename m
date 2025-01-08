Return-Path: <io-uring+bounces-5754-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A9CE1A067CA
	for <lists+io-uring@lfdr.de>; Wed,  8 Jan 2025 23:07:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9CD34167817
	for <lists+io-uring@lfdr.de>; Wed,  8 Jan 2025 22:07:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5CA6F202F97;
	Wed,  8 Jan 2025 22:07:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="IR+dFiuM"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88C35200BBF
	for <io-uring@vger.kernel.org>; Wed,  8 Jan 2025 22:07:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736374025; cv=none; b=IUW6FiiauYh/SEkA7EOhWSkNEjmG2hSNwTEy9UBZTVi6+IiVdf7EB5Fss8LBNVdiOhiuZtOZcPNDuOSx4jelYMHpQKWK47a5oHgmYVl40rc1uDfUMHnydV87hepr4WPdgkYYhRXqpAIHMIuwuVRfLRh/Vzxia/+YQnBqu9t/bwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736374025; c=relaxed/simple;
	bh=ifTOFffNmInukWOQZrTA1B8AQpNdxGhnhmXy4vIhlUk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=IjS+MRL1dicnGcu4h9VfQF2AJw9j/C+Ve5nkM5mV/OZ+kY/HBgBJm/TpNN+MdtuI2ythoUWwIHAZxTbhs2lDcNhnLJlOfKRHL7k9PUWnbd7oRmwoUP3mXPNFF3UlFQDOFHeKira5pjPVfT1wbRNiX0BCAiMPZrgZy/VFhy9gz2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=IR+dFiuM; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2161eb95317so3216435ad.1
        for <io-uring@vger.kernel.org>; Wed, 08 Jan 2025 14:07:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1736374023; x=1736978823; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=8TwtFeZ459ZzxbFFdo2bBKsRwrMcsfsnb6A5nzATa+w=;
        b=IR+dFiuMNZhZttfqHVHy7k6PswGF/GjUK5wKQGwnJrfJFubw43jtg5AwXSv1yNG444
         oE/MBOjnys2jKjueC+Ce3UGhy1/w4WgU3249u5n6Uzo6PPnumggpeZy/2FMz79f+yPd1
         wdb6ZgaNU+MoqS39BJ0p0H/d5vMVYqOLfNMUB0T4h4j+Y1rwjW2CAvzwKeWKddqGFIb0
         0yQXRYiBFcqKhzXtyS689sOjRsa6Vyitz4hGUrOmjFkl2i+tS3kgevRUB9Gvmy08CrH+
         mWkgd5znyxEyP/+wR/ayIWHNcmMNEiSZ9YcLKUcTJhcZGPDCoLUNb1R42dIUrhFWksoq
         TkGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736374023; x=1736978823;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8TwtFeZ459ZzxbFFdo2bBKsRwrMcsfsnb6A5nzATa+w=;
        b=SAbTk/8bVVl3X/aYGil4bcKbd899JTPBAEC3rbAGeg4TqhF+dz/fQ885R5bGshj07f
         8N4Ksv+9wD/8ZGIABz52p2N6+04ZEzvO8xwO73+D6Nn2fAnfq/ph4rPczZvJ7rEmfsTG
         zi1jhmzi3bvIo5sAhr1YHHZrcPu2CVFUxe4J4KWAxc5dqPpK3Yb9ISWhsfJXAoxCN2wq
         3blNvoXuxqIWwsTEECFs1bMvGvf6O8I7XcPlec6okwtRhwD13TStS9ydSMHsw/lN7w5P
         d5nCsZzHYqCn01Al4ZCT6c8P7EUT8OoSCrXETwOQKAe18GrbrSm2KPd/hFGRU/WDLivM
         Xijg==
X-Gm-Message-State: AOJu0YyCvX4xo2exg56EtUEPpwDAMRyeee2J8Z5hltBWDagYRd4H+RO7
	VVBfnLnXbSHZ4BJyXskkYic+e3/O3Yk6fxIP67CmS82xyp67pvqZhSYKZX8oe+7y52YL7rTTaFk
	G
X-Gm-Gg: ASbGncuoujFBs/6BoaUij7FnrJts3x2na8ygp8Pj74WKgzTzG9mWJnx6o1P2BJyLuxd
	nNyhXPI/IQY8oQnHPS4UTGFBFW0qwzWhIAGklOja2JFAMXXd+uVSiEwciGuX06kH5tPwDD18CwO
	0Wwk4XtlIpuo8s7u2pSXLivyayguPpuZIwHiedfEBwEfDuXiXDNpIt051+s79r/Pe1sZBGvuXf6
	800WUgVQUBdzE9h5BMAlVXITaUw2RSpUdJp8Cu5
X-Google-Smtp-Source: AGHT+IEziAhn7+6vF5MmknKzWeHzXmClrnCwTXEQOJjXpRvfthINOiufzHHQEjOTuVLuSydkC+SF6Q==
X-Received: by 2002:a17:902:ccc1:b0:215:3849:9275 with SMTP id d9443c01a7336-21a84009112mr74426775ad.49.1736374022857;
        Wed, 08 Jan 2025 14:07:02 -0800 (PST)
Received: from localhost ([2a03:2880:ff:9::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-219dc9cde50sm330502935ad.154.2025.01.08.14.07.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jan 2025 14:07:02 -0800 (PST)
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
Subject: [PATCH net-next v10 00/22] io_uring zero copy rx
Date: Wed,  8 Jan 2025 14:06:21 -0800
Message-ID: <20250108220644.3528845-1-dw@davidwei.uk>
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

David Wei (8):
  net: page pool: export page_pool_set_dma_addr_netmem()
  netdev: add io_uring memory provider info
  io_uring/zcrx: add interface queue and refill queue
  io_uring/zcrx: add io_zcrx_area
  io_uring/zcrx: add io_recvzc request
  io_uring/zcrx: set pp memory provider for an rx queue
  net: add documentation for io_uring zcrx
  io_uring/zcrx: add selftest

Jakub Kicinski (1):
  net: page_pool: create hooks for custom memory providers

Pavel Begunkov (13):
  net: make page_pool_ref_netmem work with net iovs
  net: page_pool: don't cast mp param to devmem
  net: prefix devmem specific helpers
  net: generalise net_iov chunk owners
  net: page_pool: add callback for mp info printing
  net: page_pool: add a mp hook to unregister_netdevice*
  net: prepare for non devmem TCP memory providers
  net: page_pool: add memory provider helpers
  io_uring/zcrx: grab a net device
  io_uring/zcrx: implement zerocopy receive pp memory provider
  io_uring/zcrx: dma-map area for the device
  io_uring/zcrx: throttle receive requests
  io_uring/zcrx: add copy fallback

 Documentation/netlink/specs/netdev.yaml       |  15 +
 Documentation/networking/index.rst            |   1 +
 Documentation/networking/iou-zcrx.rst         | 201 ++++
 Kconfig                                       |   2 +
 include/linux/io_uring_types.h                |   6 +
 include/net/netmem.h                          |  21 +-
 include/net/page_pool/helpers.h               |  12 +-
 include/net/page_pool/memory_provider.h       |  44 +
 include/net/page_pool/types.h                 |   4 +
 include/uapi/linux/io_uring.h                 |  54 +-
 include/uapi/linux/netdev.h                   |   8 +
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
 io_uring/zcrx.c                               | 969 ++++++++++++++++++
 io_uring/zcrx.h                               |  71 ++
 net/core/dev.c                                |  16 +-
 net/core/devmem.c                             |  93 +-
 net/core/devmem.h                             |  49 +-
 net/core/netdev-genl.c                        |  11 +-
 net/core/page_pool.c                          |  62 +-
 net/core/page_pool_priv.h                     |  17 -
 net/core/page_pool_user.c                     |   7 +-
 net/ipv4/tcp.c                                |   7 +-
 tools/include/uapi/linux/netdev.h             |   8 +
 .../selftests/drivers/net/hw/.gitignore       |   2 +
 .../testing/selftests/drivers/net/hw/Makefile |   6 +
 .../selftests/drivers/net/hw/iou-zcrx.c       | 432 ++++++++
 .../selftests/drivers/net/hw/iou-zcrx.py      |  64 ++
 36 files changed, 2210 insertions(+), 101 deletions(-)
 create mode 100644 Documentation/networking/iou-zcrx.rst
 create mode 100644 include/net/page_pool/memory_provider.h
 create mode 100644 io_uring/KConfig
 create mode 100644 io_uring/zcrx.c
 create mode 100644 io_uring/zcrx.h
 create mode 100644 tools/testing/selftests/drivers/net/hw/iou-zcrx.c
 create mode 100755 tools/testing/selftests/drivers/net/hw/iou-zcrx.py

-- 
2.43.5


