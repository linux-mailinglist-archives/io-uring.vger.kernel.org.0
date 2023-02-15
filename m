Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 537016972C8
	for <lists+io-uring@lfdr.de>; Wed, 15 Feb 2023 01:42:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229920AbjBOAma (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Feb 2023 19:42:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229726AbjBOAm2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 14 Feb 2023 19:42:28 -0500
Received: from out3-smtp.messagingengine.com (out3-smtp.messagingengine.com [66.111.4.27])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ED0529421;
        Tue, 14 Feb 2023 16:42:27 -0800 (PST)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id B1A945C00DB;
        Tue, 14 Feb 2023 19:42:24 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Tue, 14 Feb 2023 19:42:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        joshtriplett.org; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:message-id:mime-version:reply-to:sender:subject
        :subject:to:to; s=fm3; t=1676421744; x=1676508144; bh=DHhH1JoeiX
        66EERg5p8H+9Bmcu5xlKhXQD6vz214Iuk=; b=hjNr/+igREIXtgBg3t9yDPlab7
        T9xJPiiYCfcJ3zYXvQYIvHq0ey6AhKl7lajTVhbsU1cBcnYjCgIOS3Ti2f8M3EAH
        uK+hyF9G9yGVW57dsV86CRn7QQ3ouyXFp9dCPOWwVJ+vblxwpOiTDeM25zQxHxrz
        H1gARUO8LFsbSfqyYHBphpFiQWcdrGMw+H/r8rGsb3dHrs7t/POVAmgkaanOu/55
        67V2MeqEnIM3rAfJxTng0m4kXP5P9yxs+88SCAITyJLAQugRwuW9DZY28HRDholN
        7PN0Iss3ClD1uAiGKBZr+0gXTQ0+BArEgdVGE5rojKL7tBesHTGr5NNCzwqg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:message-id:mime-version
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1676421744; x=
        1676508144; bh=DHhH1JoeiX66EERg5p8H+9Bmcu5xlKhXQD6vz214Iuk=; b=M
        zEvoM8ZQOezxFY3E1zOLZfw5zN2PrbqpRCU1CA8fvIfqokKLQy6HgbK60cbyBPdg
        k3v/jhe5BSYr6KTMzwZifuVgHm/e5kEmfPviqxHSd1tNafqMQJ8+FSPb/OqEQ5Cq
        XFOWO3SfvGSEDFMJSNEd584u7G4g6Xs32RDrFKEuUeMJmDF4jZio7K8HW0V+u/K6
        eRPaIvQAIXCg2LYW3/aHyqkRX0qtUmJb9kO/F22Rewqc5RI/3BcJAVAFgUea5RKE
        G9p9/OP+oCSvtB6MC2UW33xgt5wOdqpT2IBQ7Ffne2q3XokQcv4LS+VY8H0J6lOo
        /isN7Ngq4VtBP8IZNujiw==
X-ME-Sender: <xms:cCrsY2AOBjzIhLuJugGLY0cwh8E19la813l5WOj6ceygIFc5wRoMyw>
    <xme:cCrsYwh79MeXRBB3l43McyzfRn1N3VHOswbR19xYimWyco6eknRJuNwqJaEjQRinR
    MlGBnD9IEwQ-X0rm6M>
X-ME-Received: <xmr:cCrsY5nqYRyIICB7UqLTi7Kai8qjBYbIFe3i2RYEaLa2r-sMRZR7AfLJs9g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrudeigedgvdehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkgggtugesthdtredttddtvdenucfhrhhomheplfhoshhhucfv
    rhhiphhlvghtthcuoehjohhshhesjhhoshhhthhrihhplhgvthhtrdhorhhgqeenucggtf
    frrghtthgvrhhnpeduvdelheettdfgvddvleegueefudegudevffekjeegffefvdeikeeh
    vdehleekhfenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhroh
    hmpehjohhshhesjhhoshhhthhrihhplhgvthhtrdhorhhg
X-ME-Proxy: <xmx:cCrsY0zFZUZzwdZ-wYsp1rwdQ-yiHWGFiqFbV0OhV-a8aL9qzjkr8A>
    <xmx:cCrsY7QN625Huvr0xsBxk1JvE_JzYrxmJLaK5SgiIlSzrkPclu3WaA>
    <xmx:cCrsY_YpO6NcjzOLIa3tpNBkyRqCmwpcolYVfa-IzesWL63n-8ZT9Q>
    <xmx:cCrsY2edns2LRi52926PBCZ694z7AQdoCTYjGev-8FsHUitAVVN-OQ>
Feedback-ID: i83e94755:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 14 Feb 2023 19:42:23 -0500 (EST)
Date:   Tue, 14 Feb 2023 16:42:22 -0800
From:   Josh Triplett <josh@joshtriplett.org>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCHv2] io_uring: Support calling io_uring_register with a
 registered ring fd
Message-ID: <f2396369e638284586b069dbddffb8c992afba95.1676419314.git.josh@joshtriplett.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add a new flag IORING_REGISTER_USE_REGISTERED_RING (set via the high bit
of the opcode) to treat the fd as a registered index rather than a file
descriptor.

This makes it possible for a library to open an io_uring, register the
ring fd, close the ring fd, and subsequently use the ring entirely via
registered index.

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
---

v2: Rebase. Change io_uring_register to extract the flag from the opcode first.

 include/uapi/linux/io_uring.h |  6 +++++-
 io_uring/io_uring.c           | 34 +++++++++++++++++++++++++++-------
 2 files changed, 32 insertions(+), 8 deletions(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 2780bce62faf..35e6f8046b9b 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -470,6 +470,7 @@ struct io_uring_params {
 #define IORING_FEAT_RSRC_TAGS		(1U << 10)
 #define IORING_FEAT_CQE_SKIP		(1U << 11)
 #define IORING_FEAT_LINKED_FILE		(1U << 12)
+#define IORING_FEAT_REG_REG_RING	(1U << 13)
 
 /*
  * io_uring_register(2) opcodes and arguments
@@ -517,7 +518,10 @@ enum {
 	IORING_REGISTER_FILE_ALLOC_RANGE	= 25,
 
 	/* this goes last */
-	IORING_REGISTER_LAST
+	IORING_REGISTER_LAST,
+
+	/* flag added to the opcode to use a registered ring fd */
+	IORING_REGISTER_USE_REGISTERED_RING	= 1U << 31
 };
 
 /* io-wq worker categories */
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index db623b3185c8..1fb743ecba5a 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3663,7 +3663,7 @@ static __cold int io_uring_create(unsigned entries, struct io_uring_params *p,
 			IORING_FEAT_POLL_32BITS | IORING_FEAT_SQPOLL_NONFIXED |
 			IORING_FEAT_EXT_ARG | IORING_FEAT_NATIVE_WORKERS |
 			IORING_FEAT_RSRC_TAGS | IORING_FEAT_CQE_SKIP |
-			IORING_FEAT_LINKED_FILE;
+			IORING_FEAT_LINKED_FILE | IORING_FEAT_REG_REG_RING;
 
 	if (copy_to_user(params, p, sizeof(*p))) {
 		ret = -EFAULT;
@@ -4177,17 +4177,37 @@ SYSCALL_DEFINE4(io_uring_register, unsigned int, fd, unsigned int, opcode,
 	struct io_ring_ctx *ctx;
 	long ret = -EBADF;
 	struct fd f;
+	bool use_registered_ring;
+
+	use_registered_ring = !!(opcode & IORING_REGISTER_USE_REGISTERED_RING);
+	opcode &= ~IORING_REGISTER_USE_REGISTERED_RING;
 
 	if (opcode >= IORING_REGISTER_LAST)
 		return -EINVAL;
 
-	f = fdget(fd);
-	if (!f.file)
-		return -EBADF;
+	if (use_registered_ring) {
+		/*
+		 * Ring fd has been registered via IORING_REGISTER_RING_FDS, we
+		 * need only dereference our task private array to find it.
+		 */
+		struct io_uring_task *tctx = current->io_uring;
 
-	ret = -EOPNOTSUPP;
-	if (!io_is_uring_fops(f.file))
-		goto out_fput;
+		if (unlikely(!tctx || fd >= IO_RINGFD_REG_MAX))
+			return -EINVAL;
+		fd = array_index_nospec(fd, IO_RINGFD_REG_MAX);
+		f.file = tctx->registered_rings[fd];
+		f.flags = 0;
+		if (unlikely(!f.file))
+			return -EBADF;
+		opcode &= ~IORING_REGISTER_USE_REGISTERED_RING;
+	} else {
+		f = fdget(fd);
+		if (unlikely(!f.file))
+			return -EBADF;
+		ret = -EOPNOTSUPP;
+		if (!io_is_uring_fops(f.file))
+			goto out_fput;
+	}
 
 	ctx = f.file->private_data;
 
-- 
2.39.1

