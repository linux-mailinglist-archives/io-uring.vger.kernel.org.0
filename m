Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61AD36F1CC5
	for <lists+io-uring@lfdr.de>; Fri, 28 Apr 2023 18:40:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229997AbjD1Qkj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 28 Apr 2023 12:40:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229943AbjD1Qki (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 28 Apr 2023 12:40:38 -0400
Received: from out2-smtp.messagingengine.com (out2-smtp.messagingengine.com [66.111.4.26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A18646A0;
        Fri, 28 Apr 2023 09:40:36 -0700 (PDT)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 9134B5C01CC;
        Fri, 28 Apr 2023 12:40:35 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Fri, 28 Apr 2023 12:40:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        joshtriplett.org; h=cc:content-type:content-type:date:date:from
        :from:in-reply-to:message-id:mime-version:reply-to:sender
        :subject:subject:to:to; s=fm2; t=1682700035; x=1682786435; bh=La
        oBiOojUkxX5UqrfOo3s8Jg5v907MZ8tMGaLEs3yys=; b=RkC3SD2a7FEiAVAhPd
        MXmr7VNG8MunOA4Iw+jsPBOg0ayo1lC10VEPl6MuGyC9zUsTGbK7PvnQk+SBPp3U
        VQ24Kiyv4ee7EwmU9BeLc3Lx74kMh0EbRyRXCdCNj3A5sZLrx4DWzMGNi5ycBCqG
        F0Z05FZhY0dONiDiao0WIA5qY67qLs1ZK6QoETggXkOnS/GOxX35IecU7tPjwC5F
        9oG5+3EQCtdbMuJZbzgvStZUQxflYCpVA+MfmY91bReclKcqBLhTChRd16En6cKs
        ATVPREDi1Zrh+s4lhuZY+ooA9zGiB4WIWwZgchCbQZcPr8PflK5NiV0wmwW92BuV
        hLoA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:content-type:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:message-id
        :mime-version:reply-to:sender:subject:subject:to:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
        1682700035; x=1682786435; bh=LaoBiOojUkxX5UqrfOo3s8Jg5v907MZ8tMG
        aLEs3yys=; b=CES9QlwKlDJoeXbJu6weGAC7904Mb9rccWL3Nxin2iox5aV2avR
        v3pVwkWr/CfwuI8bF5dAUy5AP+wA/IVm2NxoA2fRCy2zAGLyc7gxR4QBjNjPbjAT
        J+1G6nKUX+UWX4kx1Akp1G+d5yY9YfKNTo5kWZB/IQV0HoOAsp+mojfITo7x2BN4
        cjI3XNV/j8RDoSFlrSrk8awaChoZVmDlcjx0E8i0PeUs0cLBS7XQIWtDzo4THnKP
        kN4smWquIotkw2616U0qWtZNBvJEC++VocQI2MTRaXYvBoRYAMy/EF0fwJFecEpb
        Ny1YAHkYSHVZ9uTdtO9kYvNCm6BWYUmu3HQ==
X-ME-Sender: <xms:A_dLZJXOFE2ZawmP2gpN5WejE-CkNcovPki5LeEKV_pCvfVdgPlVOg>
    <xme:A_dLZJnvx3If388brhCUPqsOWbAPjQAG7FnX-vqloZAFehsYs55fx7lZ0Npu1dUwd
    cssgBXNEpLVSk7up2Q>
X-ME-Received: <xmr:A_dLZFbS0AZ9opj3lccCUPpSRP90H5FXKdow2vt3xjVB1hEvqY2_IVv2NABJ7kpi9AgVV9V7GlzElVqX-EiO7Vue1Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrfedukedguddtgecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkgggtugesthdtredttddtvdenucfhrhhomheplfhoshhhucfv
    rhhiphhlvghtthcuoehjohhshhesjhhoshhhthhrihhplhgvthhtrdhorhhgqeenucggtf
    frrghtthgvrhhnpeelleeggedtjeejfeeuvddufeeggfektdefkeehveeuvedvvdfhgeff
    gfdvgfffkeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhroh
    hmpehjohhshhesjhhoshhhthhrihhplhgvthhtrdhorhhg
X-ME-Proxy: <xmx:A_dLZMU-DkSL6tYA00IEDFlluE0cMI7IC9GNSkC39bUn_VmwPxujVA>
    <xmx:A_dLZDl8Vbb0CdsFszmcfBE6dSgkAQUZidHmMFsXQFI75ih8rvycLA>
    <xmx:A_dLZJe2c-MM0UFjwwcQfI3mWl165n-0A8r3xPKdAReQ3_wAt1GQDA>
    <xmx:A_dLZIx3NLEYQRSxGYbQCtReasoDLA5pxkszM8w10B1YdlCO07cQLA>
Feedback-ID: i83e94755:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 28 Apr 2023 12:40:33 -0400 (EDT)
Date:   Sat, 29 Apr 2023 01:40:30 +0900
From:   Josh Triplett <josh@joshtriplett.org>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC PATCH] io_uring: Add io_uring_setup flag to pre-register ring
 fd and never install it
Message-ID: <bc8f431bada371c183b95a83399628b605e978a3.1682699803.git.josh@joshtriplett.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

With IORING_REGISTER_USE_REGISTERED_RING, an application can register
the ring fd and use it via registered index rather than installed fd.
This allows using a registered ring for everything *except* the initial
mmap.

With IORING_SETUP_NO_MMAP, io_uring_setup uses buffers allocated by the
user, rather than requiring a subsequent mmap.

The combination of the two allows a user to operate *entirely* via a
registered ring fd, making it unnecessary to ever install the fd in the
first place. So, add a flag IORING_SETUP_REGISTERED_FD_ONLY to make
io_uring_setup register the fd and return a registered index, without
installing the fd.

This allows an application to avoid touching the fd table at all, and
allows a library to never even momentarily install a file descriptor.

This splits out an io_ring_add_registered_file helper from
io_ring_add_registered_fd, for use by io_uring_setup.

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
---

Does this seem like a reasonable approach?

 include/uapi/linux/io_uring.h |  7 +++++++
 io_uring/io_uring.c           | 37 +++++++++++++++++++++--------------
 io_uring/io_uring.h           |  3 +++
 io_uring/tctx.c               | 31 ++++++++++++++++++-----------
 4 files changed, 52 insertions(+), 26 deletions(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 2edba9a274de..f222d263bc55 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -178,6 +178,13 @@ enum {
  */
 #define IORING_SETUP_NO_MMAP		(1U << 14)
 
+/*
+ * Register the ring fd in itself for use with
+ * IORING_REGISTER_USE_REGISTERED_RING; return a registered fd index rather
+ * than an fd.
+ */
+#define IORING_SETUP_REGISTERED_FD_ONLY	(1U << 15)
+
 enum io_uring_op {
 	IORING_OP_NOP,
 	IORING_OP_READV,
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index fccc80c201fb..2bb44364cf86 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3809,19 +3809,13 @@ static __cold int io_allocate_scq_urings(struct io_ring_ctx *ctx,
 	return 0;
 }
 
-static int io_uring_install_fd(struct io_ring_ctx *ctx, struct file *file)
+static int io_uring_install_fd(struct file *file)
 {
-	int ret, fd;
+	int fd;
 
 	fd = get_unused_fd_flags(O_RDWR | O_CLOEXEC);
 	if (fd < 0)
 		return fd;
-
-	ret = __io_uring_add_tctx_node(ctx);
-	if (ret) {
-		put_unused_fd(fd);
-		return ret;
-	}
 	fd_install(fd, file);
 	return fd;
 }
@@ -3861,6 +3855,7 @@ static __cold int io_uring_create(unsigned entries, struct io_uring_params *p,
 				  struct io_uring_params __user *params)
 {
 	struct io_ring_ctx *ctx;
+	struct io_uring_task *tctx;
 	struct file *file;
 	int ret;
 
@@ -3872,6 +3867,10 @@ static __cold int io_uring_create(unsigned entries, struct io_uring_params *p,
 		entries = IORING_MAX_ENTRIES;
 	}
 
+	if ((p->flags & IORING_SETUP_REGISTERED_FD_ONLY)
+	    && !(p->flags & IORING_SETUP_NO_MMAP))
+		return -EINVAL;
+
 	/*
 	 * Use twice as many entries for the CQ ring. It's possible for the
 	 * application to drive a higher depth than the size of the SQ ring,
@@ -4028,22 +4027,30 @@ static __cold int io_uring_create(unsigned entries, struct io_uring_params *p,
 		goto err;
 	}
 
+	ret = __io_uring_add_tctx_node(ctx);
+	if (ret)
+		goto err_fput;
+	tctx = current->io_uring;
+
 	/*
 	 * Install ring fd as the very last thing, so we don't risk someone
 	 * having closed it before we finish setup
 	 */
-	ret = io_uring_install_fd(ctx, file);
-	if (ret < 0) {
-		/* fput will clean it up */
-		fput(file);
-		return ret;
-	}
+	if (p->flags & IORING_SETUP_REGISTERED_FD_ONLY)
+		ret = io_ring_add_registered_file(tctx, file, 0, IO_RINGFD_REG_MAX);
+	else
+		ret = io_uring_install_fd(file);
+	if (ret < 0)
+		goto err_fput;
 
 	trace_io_uring_create(ret, ctx, p->sq_entries, p->cq_entries, p->flags);
 	return ret;
 err:
 	io_ring_ctx_wait_and_kill(ctx);
 	return ret;
+err_fput:
+	fput(file);
+	return ret;
 }
 
 /*
@@ -4070,7 +4077,7 @@ static long io_uring_setup(u32 entries, struct io_uring_params __user *params)
 			IORING_SETUP_COOP_TASKRUN | IORING_SETUP_TASKRUN_FLAG |
 			IORING_SETUP_SQE128 | IORING_SETUP_CQE32 |
 			IORING_SETUP_SINGLE_ISSUER | IORING_SETUP_DEFER_TASKRUN |
-			IORING_SETUP_NO_MMAP))
+			IORING_SETUP_NO_MMAP | IORING_SETUP_REGISTERED_FD_ONLY))
 		return -EINVAL;
 
 	return io_uring_create(entries, &p, params);
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 25515d69d205..54a9a652531f 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -75,6 +75,9 @@ __cold void io_uring_cancel_generic(bool cancel_all, struct io_sq_data *sqd);
 int io_uring_alloc_task_context(struct task_struct *task,
 				struct io_ring_ctx *ctx);
 
+int io_ring_add_registered_file(struct io_uring_task *tctx, struct file *file,
+				     int start, int end);
+
 int io_poll_issue(struct io_kiocb *req, struct io_tw_state *ts);
 int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr);
 int io_do_iopoll(struct io_ring_ctx *ctx, bool force_nonspin);
diff --git a/io_uring/tctx.c b/io_uring/tctx.c
index 3a8d1dd97e1b..c043fe93a3f2 100644
--- a/io_uring/tctx.c
+++ b/io_uring/tctx.c
@@ -208,31 +208,40 @@ void io_uring_unreg_ringfd(void)
 	}
 }
 
-static int io_ring_add_registered_fd(struct io_uring_task *tctx, int fd,
+int io_ring_add_registered_file(struct io_uring_task *tctx, struct file *file,
 				     int start, int end)
 {
-	struct file *file;
 	int offset;
-
 	for (offset = start; offset < end; offset++) {
 		offset = array_index_nospec(offset, IO_RINGFD_REG_MAX);
 		if (tctx->registered_rings[offset])
 			continue;
 
-		file = fget(fd);
-		if (!file) {
-			return -EBADF;
-		} else if (!io_is_uring_fops(file)) {
-			fput(file);
-			return -EOPNOTSUPP;
-		}
 		tctx->registered_rings[offset] = file;
 		return offset;
 	}
-
 	return -EBUSY;
 }
 
+static int io_ring_add_registered_fd(struct io_uring_task *tctx, int fd,
+				     int start, int end)
+{
+	struct file *file;
+	int offset;
+
+	file = fget(fd);
+	if (!file) {
+		return -EBADF;
+	} else if (!io_is_uring_fops(file)) {
+		fput(file);
+		return -EOPNOTSUPP;
+	}
+	offset = io_ring_add_registered_file(tctx, file, start, end);
+	if (offset < 0)
+		fput(file);
+	return offset;
+}
+
 /*
  * Register a ring fd to avoid fdget/fdput for each io_uring_enter()
  * invocation. User passes in an array of struct io_uring_rsrc_update
-- 
2.40.1

