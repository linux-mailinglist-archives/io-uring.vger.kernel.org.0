Return-Path: <io-uring+bounces-3739-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 154DA9A11E4
	for <lists+io-uring@lfdr.de>; Wed, 16 Oct 2024 20:53:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A131F1F24E1B
	for <lists+io-uring@lfdr.de>; Wed, 16 Oct 2024 18:53:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B86718E772;
	Wed, 16 Oct 2024 18:53:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="cEF/ozNW"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 415BA18C002
	for <io-uring@vger.kernel.org>; Wed, 16 Oct 2024 18:53:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729104782; cv=none; b=CvtF1mv26zxGs6ywdtuXmY8EIqRIBoRlP9y7cZFJhc+w1Zyv6VPaowNfPT/DbnqOizXajrjf9ro3fnMa1rlbdagiUe9M56mHVZFPofKPEDlchsDsy6lOwA479qXlqcXkDqhUElZ34BKnUiCt8gZ9r6DEp3Q6CdJWSkDIbou+mb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729104782; c=relaxed/simple;
	bh=IhO31ApYjKVwe1fMqMUp9FTwueVwAPIqsi9lQivokZ4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=RvVErEkDsCZNNk0JbY8rDbiKbdM6kZPw/HXemIKqfCAK/X/+YmBklNuYhvaFJRsh/X9+75ZlEgZcgM+buNzf0VFEzrlFFiuv+7GKjE66AGXxPZtpEW+blDgRHn+IF8R/qx3Kc6PT7HjkijB5HYc+al+SmxDXJRfTwxn9+Bo3IKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=cEF/ozNW; arc=none smtp.client-ip=209.85.216.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-2e2e23f2931so122790a91.0
        for <io-uring@vger.kernel.org>; Wed, 16 Oct 2024 11:53:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1729104780; x=1729709580; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=CoRZvAMyt8Xx2eJs0+bhlUuoKsT4RK6Je1wMPmm21CQ=;
        b=cEF/ozNWvGudwyKOvLoeVDZzCalihENvpxagf0rlxVvte7FkJZ5LnanMHdZBJNcwen
         2Y5I/vWkZbCERVO6tf9yyrFsdE5A2BlnC5XY1pzB/x7QB+N5Z56K9VAzDWPXFf6MHPd1
         y789aTUXbfsdLwehuYD6Ty/lFv55LzBlLGKH0szrQnycx9xlG/h1wq6ZRtWZVOJ72biz
         fANC0IfZOUJcpXfe2zgPspiQIEEEHcQqRYyD8Ia/jo7qHc5EXznUlkZdOW5gR2IZWDUI
         89z3I0jHE+LWQtLKuLirUamwj7U7SoIjcDnFwdPdq0bxqi2ueoehHdTBFAvEXDne4MEa
         dwBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729104780; x=1729709580;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CoRZvAMyt8Xx2eJs0+bhlUuoKsT4RK6Je1wMPmm21CQ=;
        b=gGeAB0OUIvneUFPGDHjzMoVp3FWh+spqNPH/OTg4OQvMjNx6Vsji5Y45OXa/3AeroO
         6H/b0lXcvWYNoLkM9Rzku2X8wn8vkdpENJDRmhySLpsI6AiPvxi6Tcliha1I3fcrpFaa
         Wk/VrEAG4XMQcEA+J1+DL+2jvPCaiT800o8mjnLJf8I6CZgHbNV8pKWSVfjImPhbKST9
         tNw2vnRJZ/9N/ZlFl0vjqiJ5dV2hlF+TJZDpy/mqisXbZd8RQg0HeHCVpNaNG7GDqcQK
         rvI12pD2gpVlSC8EoT+sgrGkhrHmymd1zoiie/pxzp/Qa4mQ2GzpiDNbC5Eqo991wUQe
         j6yg==
X-Gm-Message-State: AOJu0Yx5GaWKMA0fsscn36+s4jK3Pwpodb0F+AnUZFNq0YeNwW9TNV0a
	MvWl0GQ96VepkjY71tqR1HMmynxRmwQ/n5jKzdsweDghFukTR3C56zdoqCdlI06zxnU7YtDWhwf
	C
X-Google-Smtp-Source: AGHT+IGvf9a63S85kKe+nDBsPEGt5TpKUB4NAMk+TGPRMseX2DwVAGFWerBejZiqaMJt9mDOjdUleQ==
X-Received: by 2002:a17:90b:4a8f:b0:2e2:e8a9:a1f with SMTP id 98e67ed59e1d1-2e3152c836dmr22409004a91.13.1729104780463;
        Wed, 16 Oct 2024 11:53:00 -0700 (PDT)
Received: from localhost (fwdproxy-prn-016.fbsv.net. [2a03:2880:ff:10::face:b00c])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2e3e0908621sm119335a91.56.2024.10.16.11.52.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Oct 2024 11:52:59 -0700 (PDT)
From: David Wei <dw@davidwei.uk>
To: io-uring@vger.kernel.org,
	netdev@vger.kernel.org
Cc: David Wei <dw@davidwei.uk>,
	Jens Axboe <axboe@kernel.dk>,
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
Subject: [PATCH v6 00/15] io_uring zero copy rx
Date: Wed, 16 Oct 2024 11:52:37 -0700
Message-ID: <20241016185252.3746190-1-dw@davidwei.uk>
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
[2]: https://github.com/isilence/linux.git zcrx/v6

liburing for testing:
[3]: https://github.com/isilence/liburing.git zcrx/next

kperf for testing:
[4]: https://git.kernel.dk/kperf.git

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

David Wei (4):
  io_uring/zcrx: add interface queue and refill queue
  io_uring/zcrx: add io_zcrx_area
  io_uring/zcrx: add io_recvzc request
  io_uring/zcrx: set pp memory provider for an rx queue

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

 Kconfig                                 |   2 +
 include/linux/io_uring_types.h          |   3 +
 include/net/busy_poll.h                 |   6 +
 include/net/netmem.h                    |  21 +-
 include/net/page_pool/memory_provider.h |  14 +
 include/net/page_pool/types.h           |  10 +
 include/uapi/linux/io_uring.h           |  54 ++
 io_uring/KConfig                        |  10 +
 io_uring/Makefile                       |   1 +
 io_uring/io_uring.c                     |   7 +
 io_uring/io_uring.h                     |  10 +
 io_uring/memmap.c                       |   8 +
 io_uring/net.c                          |  74 +++
 io_uring/opdef.c                        |  16 +
 io_uring/register.c                     |   7 +
 io_uring/rsrc.c                         |   2 +-
 io_uring/rsrc.h                         |   1 +
 io_uring/zcrx.c                         | 838 ++++++++++++++++++++++++
 io_uring/zcrx.h                         |  76 +++
 net/core/dev.c                          |  77 ++-
 net/core/devmem.c                       |  51 +-
 net/core/devmem.h                       |  45 +-
 net/core/page_pool.c                    | 102 ++-
 net/core/page_pool_user.c               |  15 +-
 net/ipv4/tcp.c                          |   8 +-
 25 files changed, 1384 insertions(+), 74 deletions(-)
 create mode 100644 include/net/page_pool/memory_provider.h
 create mode 100644 io_uring/KConfig
 create mode 100644 io_uring/zcrx.c
 create mode 100644 io_uring/zcrx.h

-- 
2.43.5


