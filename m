Return-Path: <io-uring+bounces-5925-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8027CA14530
	for <lists+io-uring@lfdr.de>; Fri, 17 Jan 2025 00:17:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C0E7C3A673E
	for <lists+io-uring@lfdr.de>; Thu, 16 Jan 2025 23:17:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EEBF3216602;
	Thu, 16 Jan 2025 23:17:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="khfo9boY"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 385C61DD0D6
	for <io-uring@vger.kernel.org>; Thu, 16 Jan 2025 23:17:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737069432; cv=none; b=ng8D29iuWWIcpFbRy5C/Hyc3j/9Ic6E1RzFnv04jHI30TulqTQ24Sl9Fi2Eh7f9njMso4l7+cR+0wptW9ew5DD2Mx6MS6qa2oTPNE6lEEw9MEQs32stIaRgf0DVnVLyAe7vbnM2BYU/VjEkoZaJORg/2/hEvuisbudESjxgDwK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737069432; c=relaxed/simple;
	bh=2neUjX9U9vvDFDZvFXIU21nfIN4oAkPvMwx/NCnY9l8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=GZlX8RpImDsJXs/10ndtdEG7roMRPOZilYLjy62on8yumIg73Wt9ofR5YSJKolrncvReDzuDAbENp9FqIPsv+twF/S+BOW2cN6VQ+4dMhXTbhekQb2E8k7+SOR02euSA2tidB91ctD03aEH88oM18wXw6xWjVGL2IWi/6IBqoEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=khfo9boY; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-218c8aca5f1so36448295ad.0
        for <io-uring@vger.kernel.org>; Thu, 16 Jan 2025 15:17:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1737069430; x=1737674230; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=3Aps8Dd6GMLkLQw5U4KWZoGyauB3IQanrW1rkjdtB3A=;
        b=khfo9boYCZhdXUPQdQFcgmdI0HGTz5b2t/C1wMXX+BNM0aycGqoSF+0SBPoGX4hKEd
         xwVjhzGIrgAvaUTTbtpXJPTL2BDQFO6wfPRvF0Vfcbg+8eFHD3uilZeK5s/1YpdPurFJ
         f/rwqIIhyISo9zBvxQ45gBVdnaWq9eku7vQbYEv8uPR4I68dQpTVg3SZOLC0QHRWk39/
         KwzN7Gna4iZsiASuXwpvfqfvN2ESZr1eYGwZBF4efq81fhkhW3eoUbOuMj1ZbxKNCfl9
         pwy2tnhAW19cuJYUQMtdYqORlHLbQNxT1Ah+arNhZhjiVOZWee03uqtn7RTpdPI5vMm+
         aGVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737069430; x=1737674230;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3Aps8Dd6GMLkLQw5U4KWZoGyauB3IQanrW1rkjdtB3A=;
        b=YIH2H2cv0eOvCQpxn6gwPXFHNAbeCbOSyodRA6hqn2+4yZypv3ajSZhMdVn4sFRANL
         Twobszd5+qIUEl5XRZxXvRD0eSmq8p9hUauFhtyvJLyl3TB2T51IH3CFoYjDFsEYjsV2
         CIZqHAb/64y0iRo4JWDXEgDgB769DkftICBlJt9B4g4euuPMPZonKF38e2gZv8ftoPTj
         WqD5WFhNKTzGgMq+Ok36ShL1uIduKaFie66eWYN7mXuodx1f5bo926pKCPOVlIF65nCJ
         YP+fote3ugHCpR0r6P8ecH4801vkAwueZz4G/PGYJf5+HMuijY2QcRBE0ing9AknBcZe
         dRjw==
X-Gm-Message-State: AOJu0YwAU6iEfVBwGMk9ToGFG76qSHmlr+cmqcmm4w8ec4eGJwLHM2pF
	5+H35OOUM2XKvh1P2wlUIn47pLnZ8e2woKO13glckM5jpEIL/nuXog2IsTFL5O3lJDeuVcMt13U
	Y
X-Gm-Gg: ASbGncsEgeDhLHAyouUlANA12TDo01LPiDAsBO7x7cG0TjALErVRQSq/vW1+D72vkeF
	lYEov/zJVB1Fpns2Lt6H9d6I6PcjC+SifaIybNu7j83Mn14mWtWy+2mru2wEZUEm/ob125mnvRY
	5Zuwr/XkF7Bz1tAOHYyIvtrqOw5NOCa8jv1OB8WChMv30gycUlTCKBXyJcyk1qwKSL057wdiu0k
	SH8bjyehzc7tfBbdtdMmxzFXckcR3jdJZayfvPD
X-Google-Smtp-Source: AGHT+IEHj5B8WeSYKe8zgGmm1pUClJEkr8LL9hSNvCZSETR3JKrQKjLA9yg5kAzd37d89daxFFLfZg==
X-Received: by 2002:aa7:88d1:0:b0:729:35b:542e with SMTP id d2e1a72fcca58-72dafb90892mr805354b3a.16.1737069430378;
        Thu, 16 Jan 2025 15:17:10 -0800 (PST)
Received: from localhost ([2a03:2880:ff:8::])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-72daba48cd0sm547499b3a.131.2025.01.16.15.17.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jan 2025 15:17:10 -0800 (PST)
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
Subject: [PATCH net-next v11 00/21] io_uring zero copy rx
Date: Thu, 16 Jan 2025 15:16:42 -0800
Message-ID: <20250116231704.2402455-1-dw@davidwei.uk>
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

David Wei (9):
  netdev: add io_uring memory provider info
  net: page_pool: add memory provider helpers
  net: add helpers for setting a memory provider on an rx queue
  io_uring/zcrx: add interface queue and refill queue
  io_uring/zcrx: add io_zcrx_area
  io_uring/zcrx: add io_recvzc request
  io_uring/zcrx: set pp memory provider for an rx queue
  net: add documentation for io_uring zcrx
  io_uring/zcrx: add selftest

Pavel Begunkov (12):
  net: page_pool: don't cast mp param to devmem
  net: prefix devmem specific helpers
  net: generalise net_iov chunk owners
  net: page_pool: create hooks for custom memory providers
  net: page_pool: add callback for mp info printing
  net: page_pool: add a mp hook to unregister_netdevice*
  net: prepare for non devmem TCP memory providers
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
 include/net/page_pool/memory_provider.h       |  45 +
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
 io_uring/zcrx.c                               | 947 ++++++++++++++++++
 io_uring/zcrx.h                               |  73 ++
 net/core/dev.c                                |  16 +-
 net/core/devmem.c                             |  93 +-
 net/core/devmem.h                             |  49 +-
 net/core/netdev-genl.c                        |  11 +-
 net/core/netdev_rx_queue.c                    |  66 ++
 net/core/page_pool.c                          |  51 +-
 net/core/page_pool_user.c                     |   7 +-
 net/ipv4/tcp.c                                |   7 +-
 tools/include/uapi/linux/netdev.h             |   8 +
 .../selftests/drivers/net/hw/.gitignore       |   2 +
 .../testing/selftests/drivers/net/hw/Makefile |   5 +
 .../selftests/drivers/net/hw/iou-zcrx.c       | 432 ++++++++
 .../selftests/drivers/net/hw/iou-zcrx.py      |  64 ++
 35 files changed, 2234 insertions(+), 83 deletions(-)
 create mode 100644 Documentation/networking/iou-zcrx.rst
 create mode 100644 include/net/page_pool/memory_provider.h
 create mode 100644 io_uring/KConfig
 create mode 100644 io_uring/zcrx.c
 create mode 100644 io_uring/zcrx.h
 create mode 100644 tools/testing/selftests/drivers/net/hw/iou-zcrx.c
 create mode 100755 tools/testing/selftests/drivers/net/hw/iou-zcrx.py

-- 
2.43.5


