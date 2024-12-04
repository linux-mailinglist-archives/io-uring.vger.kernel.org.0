Return-Path: <io-uring+bounces-5213-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F2119E442C
	for <lists+io-uring@lfdr.de>; Wed,  4 Dec 2024 20:10:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 113C7B45064
	for <lists+io-uring@lfdr.de>; Wed,  4 Dec 2024 17:56:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 330411714CF;
	Wed,  4 Dec 2024 17:22:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="F1JNElXV"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4264B2391BA
	for <io-uring@vger.kernel.org>; Wed,  4 Dec 2024 17:22:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733332964; cv=none; b=Cdei1myBaASMDCH9qWUZLHTw1EqNfsPQWCU4bnhYp9SACy6DdKC2ldLfvaSl0zF7wf53jaaEcUycDtuDD39R6c2y4KUINe5NQLLdB9nxgmtjo0GlgiTosCaEfvvMN3yNWtdwgn/swDjWK6oyyNIc0yAX7ExTPWDi7oQyVGxPPp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733332964; c=relaxed/simple;
	bh=CQ/5YfEJvkG5WscL4093Y9mZyhtCYa/aZu85bhnRsoc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=acPTEH8ZX7OEO4+gUuy+CnmSfcy6ezEZNH2LBHKAD1k2XnaPe2yJh0pZ53+lQcOZgbpPxXyC7UTJ3Buh6HPi9YELH2JMvEnMeCM+iiyOIw+FUiE1zkejiRpvgjMh2A68gEoGxgqk7GHtassGHbv9aFYiJnO0DQ4nzWLXDi3drsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=F1JNElXV; arc=none smtp.client-ip=209.85.215.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-7fbc1ca1046so49314a12.0
        for <io-uring@vger.kernel.org>; Wed, 04 Dec 2024 09:22:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1733332961; x=1733937761; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=GzUZlML4zdc55ZOBuwqdAZPFhGyN3Gd9Cwr1/cz4A38=;
        b=F1JNElXV4EumbE5RZ0YuoX+hycd5YS0aB3on3XlelSvoN+H79oGAazvrNSnekid2b8
         2Y2XRXdx64JjC+OlYx5yZnHrtwyuurXTCZcMUtUM44k7teFSKlVPvxP3kyrDFmdvJCRS
         PaIaqTe05FGsAdsGukA8QYzuenLYMchb6ikS1Os1ZraJucbIp7PSqhRIb39jzWzXcCd5
         wgYnqtCz+7YH/f9S47OXFlzOxo1zIUWKr2QtgEaqMLyDe3F87yo4UWEcxeDI3e+/YgKQ
         AUlP/du125/6gjA37dStCUMJqY3aCtv7jtkm8qu7w51QWJCcj9dK/N7dBdzJJv0BQ0H9
         lIkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733332961; x=1733937761;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GzUZlML4zdc55ZOBuwqdAZPFhGyN3Gd9Cwr1/cz4A38=;
        b=uYHMHrOqAYIltCqO2R0sgE7W3XVjxvMzPYpWkcllcFdx8j7mEYfTfLPGkySy2g9AuP
         64d8P+POWjSww4V2l8tqZl/aQYa5U8DLZyHupd+pseD3vHVLCobGt1uwOv4bAtU84XdE
         UmSeEkeX6EI8VMSkG2AqBnMFsEvjy6XLMu0dLmL0nf6An8ZfDs2BafPwv6cgQEk061u8
         4EP5iAGNxQyLA7Hz+cv6ogrFXUMlS0xtgHU9qhRZ47Bvy/mlpdhr3UY5YWkzAd6WpGPL
         Ey1CEePbETljkOLqPChcHrvraSS2rE2HsDlT2HWvzdtAoS0btWuwQ5OBxW0KWpIZybD/
         UAfg==
X-Gm-Message-State: AOJu0YzVEiiDloTd5Cf9F4FW3ff2PSR9FjKdy4pohUILyABVeTe5rkDl
	4pZYKMnMRW0YPkBOQLW2lNnndt7e9+O5OIh2VRWfw+erzYMcEqfTAFDFRTCSYph33Zi4IOlBzpY
	0
X-Gm-Gg: ASbGncshLD7sQH3l134cYKFKIrK6DjeHyeXnJfqQ6mHYzhgdVVs4nzMPzUSDpCwgz8C
	+2SsdctdQ7L/To+bJ4qii6tH32JAnJFFxieIEco2j4JStUDQrgwTpxom3XRf0+EuokIvtTgFrZ7
	CrMCo+khrg+gF23lXAVtDwxp83Td+wWNgKICQg0fqNaSlQ9xaEwiaLPRbylV+CjSXhfbTV/2NJI
	K7+r3r/d1f2KCBZRtKWcyE8cULCSyZZX0E=
X-Google-Smtp-Source: AGHT+IGI20u7e5CYbx/vBstDIX2y0Y4Q3dUiNYLAKbvvnNhfjri8X2hV8ZElUBh79vdJpj9GHWDjZQ==
X-Received: by 2002:a05:6a21:7e85:b0:1e1:7536:87d2 with SMTP id adf61e73a8af0-1e175368d60mr3181694637.44.1733332961451;
        Wed, 04 Dec 2024 09:22:41 -0800 (PST)
Received: from localhost ([2a03:2880:ff:19::])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7fc9c32250asm11705361a12.46.2024.12.04.09.22.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Dec 2024 09:22:40 -0800 (PST)
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
Subject: [PATCH net-next v8 00/17] io_uring zero copy rx
Date: Wed,  4 Dec 2024 09:21:39 -0800
Message-ID: <20241204172204.4180482-1-dw@davidwei.uk>
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

==============
Patch overview
==============

Networking folks would be mostly interested in patches 1-8, 11, 12 and
14. Patches 1-8 make the necessary prerequisite changes in netdev core.

Patch 11 implements struct memory_provider_ops, patch 12 adds a
recv_actor_t func used with tcp_read_sock(), and patch 14 passes it all
to netdev via the queue API.

io_uring folks would be mostly interested in patches 9-15:

* Initial registration that sets up a hw rx queue.
* Shared ringbuf for userspace to return buffers.
* New request type for doing zero copy rx reads.

=====
Links
=====

Broadcom bnxt support:
[1]: https://lore.kernel.org/netdev/20241003160620.1521626-8-ap420073@gmail.com/

Linux kernel branch:
[2]: https://github.com/spikeh/linux.git zcrx/next

liburing for testing:
[3]: https://github.com/isilence/liburing.git zcrx/next

kperf for testing:
[4]: https://git.kernel.dk/kperf.git

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

Jakub Kicinski (1):
  net: page_pool: create hooks for custom page providers

Pavel Begunkov (10):
  net: prefix devmem specific helpers
  net: generalise net_iov chunk owners
  net: prepare for non devmem TCP memory providers
  net: page_pool: add ->scrub mem provider callback
  net: page pool: add helper creating area from pages
  net: page_pool: introduce page_pool_mp_return_in_cache
  net: add helper executing custom callback from napi
  io_uring/zcrx: implement zerocopy receive pp memory provider
  io_uring/zcrx: add copy fallback
  io_uring/zcrx: throttle receive requests

 Documentation/networking/iou-zcrx.rst         | 201 +++++
 Kconfig                                       |   2 +
 include/linux/io_uring_types.h                |   4 +
 include/net/busy_poll.h                       |   6 +
 include/net/netmem.h                          |  21 +-
 include/net/page_pool/memory_provider.h       |  14 +
 include/net/page_pool/types.h                 |  10 +
 include/uapi/linux/io_uring.h                 |  54 +-
 io_uring/KConfig                              |  10 +
 io_uring/Makefile                             |   1 +
 io_uring/io_uring.c                           |   7 +
 io_uring/io_uring.h                           |  10 +
 io_uring/net.c                                |  74 ++
 io_uring/opdef.c                              |  16 +
 io_uring/register.c                           |   7 +
 io_uring/rsrc.c                               |   2 +-
 io_uring/rsrc.h                               |   1 +
 io_uring/zcrx.c                               | 845 ++++++++++++++++++
 io_uring/zcrx.h                               |  75 ++
 net/core/dev.c                                |  81 +-
 net/core/devmem.c                             |  51 +-
 net/core/devmem.h                             |  45 +-
 net/core/page_pool.c                          | 102 ++-
 net/core/page_pool_user.c                     |  15 +-
 net/ipv4/tcp.c                                |   8 +-
 .../selftests/drivers/net/hw/.gitignore       |   2 +
 .../testing/selftests/drivers/net/hw/Makefile |   6 +
 .../selftests/drivers/net/hw/iou-zcrx.c       | 432 +++++++++
 .../selftests/drivers/net/hw/iou-zcrx.py      |  64 ++
 29 files changed, 2091 insertions(+), 75 deletions(-)
 create mode 100644 Documentation/networking/iou-zcrx.rst
 create mode 100644 include/net/page_pool/memory_provider.h
 create mode 100644 io_uring/KConfig
 create mode 100644 io_uring/zcrx.c
 create mode 100644 io_uring/zcrx.h
 create mode 100644 tools/testing/selftests/drivers/net/hw/iou-zcrx.c
 create mode 100755 tools/testing/selftests/drivers/net/hw/iou-zcrx.py

-- 
2.43.5


