Return-Path: <io-uring+bounces-129-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ED9337F46DC
	for <lists+io-uring@lfdr.de>; Wed, 22 Nov 2023 13:50:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2F770B20E7B
	for <lists+io-uring@lfdr.de>; Wed, 22 Nov 2023 12:50:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E3004C62A;
	Wed, 22 Nov 2023 12:49:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sH8Tm1wP"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44ACF43ABE;
	Wed, 22 Nov 2023 12:49:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 917EAC433D9;
	Wed, 22 Nov 2023 12:49:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1700657391;
	bh=hkU4HuuqkNDsQyioSQIrRKs3Tgv1T8STkBb7WyDQZe8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=sH8Tm1wP4EJijR7jWPvNmVl3mBtGkN3wNNGbSdSvEFuMdvkY1E+QcVQvJITT2RIsW
	 PEZ3zcrNhYwSEpVPHfg4a4zhavH8mDv02NXVgiIbz8f69fdg4BB2d9Zli1lRzYSb6z
	 EhsClQyaa8F9yvudTBUtM4my+Rx0dMR0LAc+gsTxCigYWjUsjR3qlZZqilJVkyWppo
	 yGn3YPu1G4hIzrWGGgQSL4WErzUbY4QLyvvdHlzbxEk04+A1PVD2meTrRkiqNGZrYf
	 zKCJTM3AbkjVz3eM9Q0Xi3c64W42/3N1VaWB+hvIpTkCgb37ZYi4HaREDHPLbxjZgc
	 W9uhC2VfgcM3w==
From: Christian Brauner <brauner@kernel.org>
Date: Wed, 22 Nov 2023 13:48:24 +0100
Subject: [PATCH v2 3/4] eventfd: simplify eventfd_signal_mask()
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20231122-vfs-eventfd-signal-v2-3-bd549b14ce0c@kernel.org>
References: <20231122-vfs-eventfd-signal-v2-0-bd549b14ce0c@kernel.org>
In-Reply-To: <20231122-vfs-eventfd-signal-v2-0-bd549b14ce0c@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Jan Kara <jack@suse.cz>, 
 Vitaly Kuznetsov <vkuznets@redhat.com>, 
 Sean Christopherson <seanjc@google.com>, 
 Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, 
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
 David Woodhouse <dwmw2@infradead.org>, Paul Durrant <paul@xen.org>, 
 Oded Gabbay <ogabbay@kernel.org>, Wu Hao <hao.wu@intel.com>, 
 Tom Rix <trix@redhat.com>, Moritz Fischer <mdf@kernel.org>, 
 Xu Yilun <yilun.xu@intel.com>, Zhenyu Wang <zhenyuw@linux.intel.com>, 
 Zhi Wang <zhi.a.wang@intel.com>, Jani Nikula <jani.nikula@linux.intel.com>, 
 Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, 
 Rodrigo Vivi <rodrigo.vivi@intel.com>, 
 Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>, 
 David Airlie <airlied@gmail.com>, Daniel Vetter <daniel@ffwll.ch>, 
 Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, 
 Frederic Barrat <fbarrat@linux.ibm.com>, 
 Andrew Donnellan <ajd@linux.ibm.com>, Arnd Bergmann <arnd@arndb.de>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 Eric Farman <farman@linux.ibm.com>, Matthew Rosato <mjrosato@linux.ibm.com>, 
 Halil Pasic <pasic@linux.ibm.com>, Vineeth Vijayan <vneethv@linux.ibm.com>, 
 Peter Oberparleiter <oberpar@linux.ibm.com>, 
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
 Alexander Gordeev <agordeev@linux.ibm.com>, 
 Christian Borntraeger <borntraeger@linux.ibm.com>, 
 Sven Schnelle <svens@linux.ibm.com>, Tony Krowiak <akrowiak@linux.ibm.com>, 
 Jason Herne <jjherne@linux.ibm.com>, 
 Harald Freudenberger <freude@linux.ibm.com>, 
 "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
 Xuan Zhuo <xuanzhuo@linux.alibaba.com>, 
 Diana Craciun <diana.craciun@oss.nxp.com>, 
 Alex Williamson <alex.williamson@redhat.com>, 
 Eric Auger <eric.auger@redhat.com>, Fei Li <fei1.li@intel.com>, 
 Benjamin LaHaise <bcrl@kvack.org>, Christian Brauner <brauner@kernel.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeelb@google.com>, Muchun Song <muchun.song@linux.dev>, 
 Kirti Wankhede <kwankhede@nvidia.com>, kvm@vger.kernel.org, 
 linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, 
 linux-fpga@vger.kernel.org, intel-gvt-dev@lists.freedesktop.org, 
 intel-gfx@lists.freedesktop.org, linux-rdma@vger.kernel.org, 
 linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org, 
 linux-usb@vger.kernel.org, virtualization@lists.linux-foundation.org, 
 netdev@vger.kernel.org, linux-aio@kvack.org, cgroups@vger.kernel.org, 
 linux-mm@kvack.org, Jens Axboe <axboe@kernel.dk>, 
 Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
X-Mailer: b4 0.13-dev-26615
X-Developer-Signature: v=1; a=openpgp-sha256; l=3315; i=brauner@kernel.org;
 h=from:subject:message-id; bh=hkU4HuuqkNDsQyioSQIrRKs3Tgv1T8STkBb7WyDQZe8=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMaTG/liTnx+1a0vsCaGMN23r18xIsnV/pBwn1ZPp37Mqs
 7FRsi+uo5SFQYyLQVZMkcWh3SRcbjlPxWajTA2YOaxMIEMYuDgFYCLd4YwMmxu+PXlzuflnQNcx
 jdSWzQFP5u+/ce54mkHTWs4J/1MYfRgZVub+qv3K3/m32t58z12JNyZxGoI5uyT1mLNNT0rt0T7
 KCQA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

The eventfd_signal_mask() helper was introduced for io_uring and similar
to eventfd_signal() it always passed 1 for @n. So don't bother with that
argument at all.

Signed-off-by: Christian Brauner <brauner@kernel.org>
---
 fs/eventfd.c            | 7 ++++---
 include/linux/eventfd.h | 5 ++---
 io_uring/io_uring.c     | 4 ++--
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/eventfd.c b/fs/eventfd.c
index dc9e01053235..a9a6de920fb4 100644
--- a/fs/eventfd.c
+++ b/fs/eventfd.c
@@ -43,9 +43,10 @@ struct eventfd_ctx {
 	int id;
 };
 
-__u64 eventfd_signal_mask(struct eventfd_ctx *ctx, __u64 n, __poll_t mask)
+__u64 eventfd_signal_mask(struct eventfd_ctx *ctx, __poll_t mask)
 {
 	unsigned long flags;
+	__u64 n = 1;
 
 	/*
 	 * Deadlock or stack overflow issues can happen if we recurse here
@@ -68,7 +69,7 @@ __u64 eventfd_signal_mask(struct eventfd_ctx *ctx, __u64 n, __poll_t mask)
 	current->in_eventfd = 0;
 	spin_unlock_irqrestore(&ctx->wqh.lock, flags);
 
-	return n;
+	return n == 1;
 }
 
 /**
@@ -84,7 +85,7 @@ __u64 eventfd_signal_mask(struct eventfd_ctx *ctx, __u64 n, __poll_t mask)
  */
 __u64 eventfd_signal(struct eventfd_ctx *ctx)
 {
-	return eventfd_signal_mask(ctx, 1, 0);
+	return eventfd_signal_mask(ctx, 0);
 }
 EXPORT_SYMBOL_GPL(eventfd_signal);
 
diff --git a/include/linux/eventfd.h b/include/linux/eventfd.h
index 562089431551..4f8aac7eb62a 100644
--- a/include/linux/eventfd.h
+++ b/include/linux/eventfd.h
@@ -36,7 +36,7 @@ struct file *eventfd_fget(int fd);
 struct eventfd_ctx *eventfd_ctx_fdget(int fd);
 struct eventfd_ctx *eventfd_ctx_fileget(struct file *file);
 __u64 eventfd_signal(struct eventfd_ctx *ctx);
-__u64 eventfd_signal_mask(struct eventfd_ctx *ctx, __u64 n, __poll_t mask);
+__u64 eventfd_signal_mask(struct eventfd_ctx *ctx, __poll_t mask);
 int eventfd_ctx_remove_wait_queue(struct eventfd_ctx *ctx, wait_queue_entry_t *wait,
 				  __u64 *cnt);
 void eventfd_ctx_do_read(struct eventfd_ctx *ctx, __u64 *cnt);
@@ -63,8 +63,7 @@ static inline int eventfd_signal(struct eventfd_ctx *ctx)
 	return -ENOSYS;
 }
 
-static inline int eventfd_signal_mask(struct eventfd_ctx *ctx, __u64 n,
-				      unsigned mask)
+static inline int eventfd_signal_mask(struct eventfd_ctx *ctx, unsigned mask)
 {
 	return -ENOSYS;
 }
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index ed254076c723..70170a41eac4 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -558,7 +558,7 @@ static void io_eventfd_ops(struct rcu_head *rcu)
 	int ops = atomic_xchg(&ev_fd->ops, 0);
 
 	if (ops & BIT(IO_EVENTFD_OP_SIGNAL_BIT))
-		eventfd_signal_mask(ev_fd->cq_ev_fd, 1, EPOLL_URING_WAKE);
+		eventfd_signal_mask(ev_fd->cq_ev_fd, EPOLL_URING_WAKE);
 
 	/* IO_EVENTFD_OP_FREE_BIT may not be set here depending on callback
 	 * ordering in a race but if references are 0 we know we have to free
@@ -594,7 +594,7 @@ static void io_eventfd_signal(struct io_ring_ctx *ctx)
 		goto out;
 
 	if (likely(eventfd_signal_allowed())) {
-		eventfd_signal_mask(ev_fd->cq_ev_fd, 1, EPOLL_URING_WAKE);
+		eventfd_signal_mask(ev_fd->cq_ev_fd, EPOLL_URING_WAKE);
 	} else {
 		atomic_inc(&ev_fd->refs);
 		if (!atomic_fetch_or(BIT(IO_EVENTFD_OP_SIGNAL_BIT), &ev_fd->ops))

-- 
2.42.0


