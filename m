Return-Path: <io-uring+bounces-130-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4BDCB7F46E5
	for <lists+io-uring@lfdr.de>; Wed, 22 Nov 2023 13:50:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6D59A1C209AF
	for <lists+io-uring@lfdr.de>; Wed, 22 Nov 2023 12:50:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8AFF74C60E;
	Wed, 22 Nov 2023 12:50:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fcF4pxKR"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45D2B495FB;
	Wed, 22 Nov 2023 12:50:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 467BDC433CB;
	Wed, 22 Nov 2023 12:49:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1700657408;
	bh=aU2J72Xp3JKGs0IOk/3BX7BmnbVjjSktFzc5W0fL98s=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=fcF4pxKRziGSAF2FOqxImPOzC2PEVz+iXrlHdDaPyM6/v6o+f16jjdAN+lC2pUX0Z
	 c6Vj4pEReJ7qSGBsgd/Etcb/Bx/NFbs8vsXFZDe0htqh1OD5+o81eDXmshIPtuoyBK
	 lUfl8SFejNcIDe347vDzewRE22FCt1MWsk2CM4stuQE/3LK9tJj9skrI0zg5sl10Ot
	 aC+S7ghlxwZ2rYR03/mACnTcLYZ3VnGDGFga1iJsrVdoW+9CIorT0HYAGwO2anWZen
	 uIJ0oJqCh8DfwGg5lQlRhQShmsIUNUkRjdY2uwh1ov0dsfb3jgNLqtI1PY54/gVbLF
	 del/29joBTz5A==
From: Christian Brauner <brauner@kernel.org>
Date: Wed, 22 Nov 2023 13:48:25 +0100
Subject: [PATCH v2 4/4] eventfd: make eventfd_signal{_mask}() void
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20231122-vfs-eventfd-signal-v2-4-bd549b14ce0c@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3854; i=brauner@kernel.org;
 h=from:subject:message-id; bh=aU2J72Xp3JKGs0IOk/3BX7BmnbVjjSktFzc5W0fL98s=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMaTG/lj73/5dRNiNYIfwQ9VnNb8kSHjtMQlc94/11mwNB
 qlLZUUiHaUsDGJcDLJiiiwO7Sbhcst5KjYbZWrAzGFlAhnCwMUpABP5zcjwh+t1UN76vf945tSW
 T/rxjCHQpq4w94r2Zqm/ATIn/7GqSjMyvH01XYi3/rDPbk7Hf182bChuXbCzsfD2+Wr+47+PXN/
 CxAMA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

No caller care about the return value.

Signed-off-by: Christian Brauner <brauner@kernel.org>
---
 fs/eventfd.c            | 40 +++++++++++++++-------------------------
 include/linux/eventfd.h | 16 +++++++---------
 2 files changed, 22 insertions(+), 34 deletions(-)

diff --git a/fs/eventfd.c b/fs/eventfd.c
index a9a6de920fb4..13be2fb7fc96 100644
--- a/fs/eventfd.c
+++ b/fs/eventfd.c
@@ -43,10 +43,19 @@ struct eventfd_ctx {
 	int id;
 };
 
-__u64 eventfd_signal_mask(struct eventfd_ctx *ctx, __poll_t mask)
+/**
+ * eventfd_signal - Adds @n to the eventfd counter.
+ * @ctx: [in] Pointer to the eventfd context.
+ * @mask: [in] poll mask
+ *
+ * This function is supposed to be called by the kernel in paths that do not
+ * allow sleeping. In this function we allow the counter to reach the ULLONG_MAX
+ * value, and we signal this as overflow condition by returning a EPOLLERR
+ * to poll(2).
+ */
+void eventfd_signal_mask(struct eventfd_ctx *ctx, __poll_t mask)
 {
 	unsigned long flags;
-	__u64 n = 1;
 
 	/*
 	 * Deadlock or stack overflow issues can happen if we recurse here
@@ -57,37 +66,18 @@ __u64 eventfd_signal_mask(struct eventfd_ctx *ctx, __poll_t mask)
 	 * safe context.
 	 */
 	if (WARN_ON_ONCE(current->in_eventfd))
-		return 0;
+		return;
 
 	spin_lock_irqsave(&ctx->wqh.lock, flags);
 	current->in_eventfd = 1;
-	if (ULLONG_MAX - ctx->count < n)
-		n = ULLONG_MAX - ctx->count;
-	ctx->count += n;
+	if (ctx->count < ULLONG_MAX)
+		ctx->count++;
 	if (waitqueue_active(&ctx->wqh))
 		wake_up_locked_poll(&ctx->wqh, EPOLLIN | mask);
 	current->in_eventfd = 0;
 	spin_unlock_irqrestore(&ctx->wqh.lock, flags);
-
-	return n == 1;
-}
-
-/**
- * eventfd_signal - Adds @n to the eventfd counter.
- * @ctx: [in] Pointer to the eventfd context.
- *
- * This function is supposed to be called by the kernel in paths that do not
- * allow sleeping. In this function we allow the counter to reach the ULLONG_MAX
- * value, and we signal this as overflow condition by returning a EPOLLERR
- * to poll(2).
- *
- * Returns the amount by which the counter was incremented.
- */
-__u64 eventfd_signal(struct eventfd_ctx *ctx)
-{
-	return eventfd_signal_mask(ctx, 0);
 }
-EXPORT_SYMBOL_GPL(eventfd_signal);
+EXPORT_SYMBOL_GPL(eventfd_signal_mask);
 
 static void eventfd_free_ctx(struct eventfd_ctx *ctx)
 {
diff --git a/include/linux/eventfd.h b/include/linux/eventfd.h
index 4f8aac7eb62a..fea7c4eb01d6 100644
--- a/include/linux/eventfd.h
+++ b/include/linux/eventfd.h
@@ -35,8 +35,7 @@ void eventfd_ctx_put(struct eventfd_ctx *ctx);
 struct file *eventfd_fget(int fd);
 struct eventfd_ctx *eventfd_ctx_fdget(int fd);
 struct eventfd_ctx *eventfd_ctx_fileget(struct file *file);
-__u64 eventfd_signal(struct eventfd_ctx *ctx);
-__u64 eventfd_signal_mask(struct eventfd_ctx *ctx, __poll_t mask);
+void eventfd_signal_mask(struct eventfd_ctx *ctx, __poll_t mask);
 int eventfd_ctx_remove_wait_queue(struct eventfd_ctx *ctx, wait_queue_entry_t *wait,
 				  __u64 *cnt);
 void eventfd_ctx_do_read(struct eventfd_ctx *ctx, __u64 *cnt);
@@ -58,14 +57,8 @@ static inline struct eventfd_ctx *eventfd_ctx_fdget(int fd)
 	return ERR_PTR(-ENOSYS);
 }
 
-static inline int eventfd_signal(struct eventfd_ctx *ctx)
+static inline void eventfd_signal_mask(struct eventfd_ctx *ctx, unsigned mask)
 {
-	return -ENOSYS;
-}
-
-static inline int eventfd_signal_mask(struct eventfd_ctx *ctx, unsigned mask)
-{
-	return -ENOSYS;
 }
 
 static inline void eventfd_ctx_put(struct eventfd_ctx *ctx)
@@ -91,5 +84,10 @@ static inline void eventfd_ctx_do_read(struct eventfd_ctx *ctx, __u64 *cnt)
 
 #endif
 
+static inline void eventfd_signal(struct eventfd_ctx *ctx)
+{
+	eventfd_signal_mask(ctx, 0);
+}
+
 #endif /* _LINUX_EVENTFD_H */
 

-- 
2.42.0


