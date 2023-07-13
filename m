Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0286F751E62
	for <lists+io-uring@lfdr.de>; Thu, 13 Jul 2023 12:07:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234475AbjGMKHa (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 13 Jul 2023 06:07:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234623AbjGMKGn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 13 Jul 2023 06:06:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DFBE212B;
        Thu, 13 Jul 2023 03:06:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 04D7760ADC;
        Thu, 13 Jul 2023 10:06:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34C10C433D9;
        Thu, 13 Jul 2023 10:06:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689242793;
        bh=+Df4cQ3XZPwLfFxJgIqPrDY4l9UAdwCjr9DGoW3/ojk=;
        h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
        b=j+ukf52dvZ+nUEPwpL9/EYruyhEbJbg7d1yjKDMcd3GOYxX7RclutpFcH5UUHlkpI
         fnIEho3ycJz28JfRAPfizI9cf3F0lqh4jC9ZF+UZUl5JTb6HfdwpWlIJ9bsmZ0DsOQ
         PAjBHJokUk/yF6GqX5PHCHsaDKT13j+MVST75N+zeiC2em3PJTUKrCtRR1KKmsmMCX
         MYnQq0YQbswQU++9LLW3pgHXNsdqcZtbb04btB9J/lGIIF9SRPTFcmVmql2ih2n6bH
         BAMadKjZaQhxN2qUstf+rs137LSKZ/kMx1juo/8V60a80JJWvq1eqYcfgXe/BuR2sH
         +vKmJxA1p+x+A==
From:   Christian Brauner <brauner@kernel.org>
Date:   Thu, 13 Jul 2023 12:05:38 +0200
Subject: [PATCH 2/2] eventfd: simplify eventfd_signal_mask()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230713-vfs-eventfd-signal-v1-2-7fda6c5d212b@kernel.org>
References: <20230713-vfs-eventfd-signal-v1-0-7fda6c5d212b@kernel.org>
In-Reply-To: <20230713-vfs-eventfd-signal-v1-0-7fda6c5d212b@kernel.org>
To:     linux-fsdevel@vger.kernel.org
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        David Woodhouse <dwmw2@infradead.org>,
        Paul Durrant <paul@xen.org>, Oded Gabbay <ogabbay@kernel.org>,
        Wu Hao <hao.wu@intel.com>, Tom Rix <trix@redhat.com>,
        Moritz Fischer <mdf@kernel.org>, Xu Yilun <yilun.xu@intel.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        David Airlie <airlied@gmail.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Leon Romanovsky <leon@kernel.org>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Frederic Barrat <fbarrat@linux.ibm.com>,
        Andrew Donnellan <ajd@linux.ibm.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Eric Farman <farman@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Vineeth Vijayan <vneethv@linux.ibm.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Harald Freudenberger <freude@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Eric Auger <eric.auger@redhat.com>, Fei Li <fei1.li@intel.com>,
        Benjamin LaHaise <bcrl@kvack.org>,
        Christian Brauner <brauner@kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@kernel.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Shakeel Butt <shakeelb@google.com>,
        Muchun Song <muchun.song@linux.dev>,
        Kirti Wankhede <kwankhede@nvidia.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-fpga@vger.kernel.org, intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-rdma@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org,
        linux-usb@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-aio@kvack.org, cgroups@vger.kernel.org, linux-mm@kvack.org,
        Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org
X-Mailer: b4 0.13-dev-099c9
X-Developer-Signature: v=1; a=openpgp-sha256; l=4338; i=brauner@kernel.org;
 h=from:subject:message-id; bh=+Df4cQ3XZPwLfFxJgIqPrDY4l9UAdwCjr9DGoW3/ojk=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMaSsP1NbdfmkaWaxQvZah7/MWs/ufCrO2q82U2T1DIWDSy0u
 LwzX6ChhYRDjYpAVU2RxaDcJl1vOU7HZKFMDZg4rE8gQBi5OAZiIshkjww4t2ytlzT8ElQsqm7Su/N
 b3T10XyfCvYZ2XvvOJclnpCIbvvh+/WjLaTozOzj3stenvds+qri//VkTNPGGwWHTi+Uc8AA==
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The eventfd_signal_mask() helper was introduced for io_uring and similar
to eventfd_signal() it always passed 1 for @n. So don't bother with that
argument at all.

Signed-off-by: Christian Brauner <brauner@kernel.org>
---
 drivers/gpu/drm/i915/gvt/interrupt.c | 2 +-
 fs/eventfd.c                         | 9 +++++----
 include/linux/eventfd.h              | 9 ++++-----
 io_uring/io_uring.c                  | 4 ++--
 4 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/gpu/drm/i915/gvt/interrupt.c b/drivers/gpu/drm/i915/gvt/interrupt.c
index 3d9e09c2add4..31aff6f733d4 100644
--- a/drivers/gpu/drm/i915/gvt/interrupt.c
+++ b/drivers/gpu/drm/i915/gvt/interrupt.c
@@ -435,7 +435,7 @@ static int inject_virtual_interrupt(struct intel_vgpu *vgpu)
 	 */
 	if (!test_bit(INTEL_VGPU_STATUS_ATTACHED, vgpu->status))
 		return -ESRCH;
-	if (vgpu->msi_trigger && eventfd_signal(vgpu->msi_trigger) != 1)
+	if (vgpu->msi_trigger && !eventfd_signal(vgpu->msi_trigger))
 		return -EFAULT;
 	return 0;
 }
diff --git a/fs/eventfd.c b/fs/eventfd.c
index dc9e01053235..077be5da72bd 100644
--- a/fs/eventfd.c
+++ b/fs/eventfd.c
@@ -43,9 +43,10 @@ struct eventfd_ctx {
 	int id;
 };
 
-__u64 eventfd_signal_mask(struct eventfd_ctx *ctx, __u64 n, __poll_t mask)
+bool eventfd_signal_mask(struct eventfd_ctx *ctx, __poll_t mask)
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
@@ -82,9 +83,9 @@ __u64 eventfd_signal_mask(struct eventfd_ctx *ctx, __u64 n, __poll_t mask)
  *
  * Returns the amount by which the counter was incremented.
  */
-__u64 eventfd_signal(struct eventfd_ctx *ctx)
+bool eventfd_signal(struct eventfd_ctx *ctx)
 {
-	return eventfd_signal_mask(ctx, 1, 0);
+	return eventfd_signal_mask(ctx, 0);
 }
 EXPORT_SYMBOL_GPL(eventfd_signal);
 
diff --git a/include/linux/eventfd.h b/include/linux/eventfd.h
index 562089431551..0155ee25f7c8 100644
--- a/include/linux/eventfd.h
+++ b/include/linux/eventfd.h
@@ -35,8 +35,8 @@ void eventfd_ctx_put(struct eventfd_ctx *ctx);
 struct file *eventfd_fget(int fd);
 struct eventfd_ctx *eventfd_ctx_fdget(int fd);
 struct eventfd_ctx *eventfd_ctx_fileget(struct file *file);
-__u64 eventfd_signal(struct eventfd_ctx *ctx);
-__u64 eventfd_signal_mask(struct eventfd_ctx *ctx, __u64 n, __poll_t mask);
+bool eventfd_signal(struct eventfd_ctx *ctx);
+bool eventfd_signal_mask(struct eventfd_ctx *ctx, __poll_t mask);
 int eventfd_ctx_remove_wait_queue(struct eventfd_ctx *ctx, wait_queue_entry_t *wait,
 				  __u64 *cnt);
 void eventfd_ctx_do_read(struct eventfd_ctx *ctx, __u64 *cnt);
@@ -58,13 +58,12 @@ static inline struct eventfd_ctx *eventfd_ctx_fdget(int fd)
 	return ERR_PTR(-ENOSYS);
 }
 
-static inline int eventfd_signal(struct eventfd_ctx *ctx)
+static inline bool eventfd_signal(struct eventfd_ctx *ctx)
 {
 	return -ENOSYS;
 }
 
-static inline int eventfd_signal_mask(struct eventfd_ctx *ctx, __u64 n,
-				      unsigned mask)
+static inline bool eventfd_signal_mask(struct eventfd_ctx *ctx, unsigned mask)
 {
 	return -ENOSYS;
 }
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index e8096d502a7c..a9359ef73935 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -537,7 +537,7 @@ static void io_eventfd_ops(struct rcu_head *rcu)
 	int ops = atomic_xchg(&ev_fd->ops, 0);
 
 	if (ops & BIT(IO_EVENTFD_OP_SIGNAL_BIT))
-		eventfd_signal_mask(ev_fd->cq_ev_fd, 1, EPOLL_URING_WAKE);
+		eventfd_signal_mask(ev_fd->cq_ev_fd, EPOLL_URING_WAKE);
 
 	/* IO_EVENTFD_OP_FREE_BIT may not be set here depending on callback
 	 * ordering in a race but if references are 0 we know we have to free
@@ -573,7 +573,7 @@ static void io_eventfd_signal(struct io_ring_ctx *ctx)
 		goto out;
 
 	if (likely(eventfd_signal_allowed())) {
-		eventfd_signal_mask(ev_fd->cq_ev_fd, 1, EPOLL_URING_WAKE);
+		eventfd_signal_mask(ev_fd->cq_ev_fd, EPOLL_URING_WAKE);
 	} else {
 		atomic_inc(&ev_fd->refs);
 		if (!atomic_fetch_or(BIT(IO_EVENTFD_OP_SIGNAL_BIT), &ev_fd->ops))

-- 
2.34.1

