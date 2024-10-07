Return-Path: <io-uring+bounces-3444-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0561F9939F3
	for <lists+io-uring@lfdr.de>; Tue,  8 Oct 2024 00:16:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 82E6A1F22CC5
	for <lists+io-uring@lfdr.de>; Mon,  7 Oct 2024 22:16:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E13F418E040;
	Mon,  7 Oct 2024 22:16:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="WOS4m4nO"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58EBE18DF87
	for <io-uring@vger.kernel.org>; Mon,  7 Oct 2024 22:16:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728339393; cv=none; b=ZNUjVA/oWC9UJhWZhvOZfva+J8NWVooCixDpJ5xQP/Xpp9+556NAx8hAoALWxQG/LPFbtJbBmeasUvnMt/C66yfx+l1P0OVJnySDt8FnROfGMmf8iKu8r3Euoj3QrVazVZDrerQxvCedoHZRMyHnT/S26Frl0WisqZWUguBCd3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728339393; c=relaxed/simple;
	bh=7C8bPrmlWzZ0fDgCfsqHbdUxwredIend7rcx+h8H6Rk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=MsQNKTz0ERWCpQBYPW7ariO/6oFnnoHIFxFQPLyz0S/n38jxnBZqqyfKXCPCoGnnqvtRb90n9TLCyy0aUyPjm3pxZbnn93+cgLCCN459wr7BrB4G4u6SLoGBPsIjMNxxD5vpZdLXqOkrijCyX6Tl8E5+NhcoqUbj7Irvvv6sMJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=WOS4m4nO; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-20b0b2528d8so56226805ad.2
        for <io-uring@vger.kernel.org>; Mon, 07 Oct 2024 15:16:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1728339392; x=1728944192; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=nuv2n+8uEHTfuIuhS+E4zqbrQvcw4irJS2P1hGkAKqo=;
        b=WOS4m4nObv9iC+Ha9m7JIP3hRReKntHSwM3H9y8Duw7ck5vS//Cjb5VeVYX55DenN9
         5mOuDboRYrlltbPfV2eVEaYYrL3Mj1MlKvnwTQBQTTp4g1Cp+70HUkgBYr7mLt4U+1CY
         VFaxAsQ3kPIKhqOYduHPZwC4XO40GmLaslsHwckxXhNSjuSqe4Lisb2Ap3SdxNRwAjiy
         L34c1OR0rRcyr08qg/ZUXrDpftAGln0E+USl2fG2ppdwUoTtn1EIJ6GMwBoZS4T21y57
         9bz0Fut0clR+OcJGidoFx0T7bMI6igqqBvlJiEs8/ERc3mVHCc1E0Z0GUay5DcsNPLHl
         OuYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728339392; x=1728944192;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nuv2n+8uEHTfuIuhS+E4zqbrQvcw4irJS2P1hGkAKqo=;
        b=BTbqO2Z/ilZZ3N+jJZqHdiWlCF4VCMqM5ST0F/j96/85hdO06pH1zlyoIgcCX3+rm5
         Z3GT5rpuceyMSERhTLWZUsBTxirTA317jXI8hAxpAbg8jHhKcv6HwHPOB6l7Om5+WKUF
         TGE1sH81yplLP1NIP+w0EFhSjWOYuycQ1cgtdMVKSM4H+EtvftOSc+Gt/7QXs5nYVk1Z
         Pyq9+MnpksmJn704XErGlT5Ezma2h+Db6dc+PVRf0KKnO8YG4VB5HWst9lcb9G4V1hz1
         95BakmluezTncJ8VS8l2jgQVyfn2/ykfzo1WJWNEnkyvK8LPNXgJCfJJ+6OFNEP9hBxs
         CLOQ==
X-Gm-Message-State: AOJu0Yx9PdS/k3ZVCBAj/m0wXh+XlDEXtS2tXr4BXxvQQ/jdaUkF8dVr
	hhRaE/Ox4H39SKtUiYePpiFjjROQ/yTJ5TUeyGQbAMYvSOWVvupMsNnRIITh6JmF9xlKH8Ws00J
	Q
X-Google-Smtp-Source: AGHT+IHCGtbhDRV/KP3m/cCLBEHrtu8jvcqjBkoWdcKzH5jVoTJKteDirpGCgm+WWhjmQYXvbAmQVw==
X-Received: by 2002:a17:903:4408:b0:20b:b455:eb7c with SMTP id d9443c01a7336-20bff176f0cmr185914875ad.56.1728339386975;
        Mon, 07 Oct 2024 15:16:26 -0700 (PDT)
Received: from localhost (fwdproxy-prn-114.fbsv.net. [2a03:2880:ff:72::face:b00c])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20c1398cecasm44240605ad.276.2024.10.07.15.16.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Oct 2024 15:16:26 -0700 (PDT)
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
	Mina Almasry <almasrymina@google.com>
Subject: [PATCH v1 00/15] io_uring zero copy rx
Date: Mon,  7 Oct 2024 15:15:48 -0700
Message-ID: <20241007221603.1703699-1-dw@davidwei.uk>
X-Mailer: git-send-email 2.43.5
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
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

Test setup:
* AMD EPYC 9454
* Broadcom BCM957508 200G
* Kernel v6.11 base [2]
* liburing fork [3]
* kperf fork [4]
* 4K MTU
* Single TCP flow

With application thread + net rx softirq pinned to _different_ cores:

epoll
82.2 Gbps

io_uring
116.2 Gbps (+41%)

Pinned to _same_ core:

epoll
62.6 Gbps

io_uring
80.9 Gbps (+29%)

==============
Patch overview
==============

Networking folks would be mostly interested in patches 1-8, 11 and 14.
Patches 1-2 clean up net_iov and devmem, then patches 3-8 make changes
to netdev to suit our needs.

Patch 11 implements struct memory_provider_ops, and Patch 14 passes it
all to netdev via the queue API.

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
[2]: https://github.com/isilence/linux.git zcrx/v5

liburing for testing:
[3]: https://github.com/spikeh/liburing/tree/zcrx/next

kperf for testing:
[4]: https://github.com/spikeh/kperf/tree/zcrx/next

Changes in v1:
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

David Wei (5):
  net: page pool: add helper creating area from pages
  io_uring/zcrx: add interface queue and refill queue
  io_uring/zcrx: add io_zcrx_area
  io_uring/zcrx: add io_recvzc request
  io_uring/zcrx: set pp memory provider for an rx queue

Jakub Kicinski (1):
  net: page_pool: create hooks for custom page providers

Pavel Begunkov (9):
  net: devmem: pull struct definitions out of ifdef
  net: prefix devmem specific helpers
  net: generalise net_iov chunk owners
  net: prepare for non devmem TCP memory providers
  net: page_pool: add ->scrub mem provider callback
  net: add helper executing custom callback from napi
  io_uring/zcrx: implement zerocopy receive pp memory provider
  io_uring/zcrx: add copy fallback
  io_uring/zcrx: throttle receive requests

 include/linux/io_uring/net.h   |   5 +
 include/linux/io_uring_types.h |   3 +
 include/net/busy_poll.h        |   6 +
 include/net/netmem.h           |  21 +-
 include/net/page_pool/types.h  |  27 ++
 include/uapi/linux/io_uring.h  |  54 +++
 io_uring/Makefile              |   1 +
 io_uring/io_uring.c            |   7 +
 io_uring/io_uring.h            |  10 +
 io_uring/memmap.c              |   8 +
 io_uring/net.c                 |  81 ++++
 io_uring/opdef.c               |  16 +
 io_uring/register.c            |   7 +
 io_uring/rsrc.c                |   2 +-
 io_uring/rsrc.h                |   1 +
 io_uring/zcrx.c                | 847 +++++++++++++++++++++++++++++++++
 io_uring/zcrx.h                |  74 +++
 net/core/dev.c                 |  53 +++
 net/core/devmem.c              |  44 +-
 net/core/devmem.h              |  71 ++-
 net/core/page_pool.c           |  81 +++-
 net/core/page_pool_user.c      |  15 +-
 net/ipv4/tcp.c                 |   8 +-
 23 files changed, 1364 insertions(+), 78 deletions(-)
 create mode 100644 io_uring/zcrx.c
 create mode 100644 io_uring/zcrx.h

-- 
2.43.5


