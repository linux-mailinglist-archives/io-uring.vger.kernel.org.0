Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63EAF5E946E
	for <lists+io-uring@lfdr.de>; Sun, 25 Sep 2022 18:44:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231146AbiIYQow (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 25 Sep 2022 12:44:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230387AbiIYQov (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 25 Sep 2022 12:44:51 -0400
Received: from out3-smtp.messagingengine.com (out3-smtp.messagingengine.com [66.111.4.27])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C08010FF8;
        Sun, 25 Sep 2022 09:44:47 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id B6F8A5C008F;
        Sun, 25 Sep 2022 12:44:43 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Sun, 25 Sep 2022 12:44:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        joshtriplett.org; h=cc:content-type:date:date:from:from
        :in-reply-to:message-id:mime-version:reply-to:sender:subject
        :subject:to:to; s=fm1; t=1664124283; x=1664210683; bh=nYRqMwSy8Z
        ZKm+VpVVjWnWK5Uz29ogk3At+/jsQjtpw=; b=WTcwaltYPThzBVbTCZFZxCi7gc
        hbQWF91Eax9PgQGNLMS7bFhPbFARm6ordGTIJmPQy93pXqqcZ0cuR4C7RU3m0XiI
        8hrSCUNkIG+rXLiojI6/P5GQOnmerLQ3DkuWwfJd7xmo95346NzUVCkeYznZza57
        /3C0SL5NUe9SEynAU0dGWVlTu90LOrnglzMNdciERkPm09SlkWrVOOoiYVbr1dvV
        Cbvtt/uFTO1NlDlElEcGJx+N2XhxpmPlXc8T76FcTjQhRQD3HvqxliPWFuTFePth
        JmeFdAaqnv+/6uLT62Efo5CMPf2nhE6MoUiy6hi1wlGxrA/NlJ3gV1ez5Hww==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:message-id:mime-version
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1664124283; x=
        1664210683; bh=nYRqMwSy8ZZKm+VpVVjWnWK5Uz29ogk3At+/jsQjtpw=; b=l
        ku5ye0nbXEX5IjesLcPRPzSbpUg0ukGowybR2gT6dCyT0EkPpS1gxeLYl3uLWcjr
        Kk3vrEmafFh5E5Ud7dSiI2afTuJv6Iqi1/ZysZfflk7+0287yuKCSWibYMZN88YN
        XvKcG8G+66uWUI0htErOp/vjvqQ46YjBHPWRdkT72rRD2bhLC+99pz1R2YYmJroc
        MyKmvlVXiZRy5oUht846d1dgp5DPjW5ODa4gxOhzxhyxXaWW/hYqTSlhJdFbRmhp
        NPDDC12ThW5kjX/uGNDahl7xN3GzBNyfYHTpjYybAvGWAuRGOBuoiupa84ty7Le6
        E9GRWdc6HVrxL714wqvUA==
X-ME-Sender: <xms:e4UwYycFOUvC5VRmDBZ4BbbeKZaGtBEYgWqGXB_iRlNcr0tF71_qgg>
    <xme:e4UwY8NX0hta5Ag-b8g4VV78hHbQy_4cayYx9smJA2xScYHHte8ToDl6ONn-TF021
    SH22zTbwuC1P9KzftA>
X-ME-Received: <xmr:e4UwYzjojMxBhW67fIYo2mm2GonsOCvUZBsDsoXtGmXRGS1Ezduv-vs7Nvq6fpSPW6FW9uWUqf7ArFv0mqsUw-7ePiGTLXiUFiIbNkYo4CaA5ezR>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrfeegtddguddtiecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkgggtugesthdtredttddtvdenucfhrhhomheplfhoshhhucfv
    rhhiphhlvghtthcuoehjohhshhesjhhoshhhthhrihhplhgvthhtrdhorhhgqeenucggtf
    frrghtthgvrhhnpeelleeggedtjeejfeeuvddufeeggfektdefkeehveeuvedvvdfhgeff
    gfdvgfffkeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhroh
    hmpehjohhshhesjhhoshhhthhrihhplhgvthhtrdhorhhg
X-ME-Proxy: <xmx:e4UwY_-bJJmAIOkEvwgkeExjx7yM_3ENbENmS9L5YuLu73zQ5RFryg>
    <xmx:e4UwY-tJFUZnS2kXxyHxMYq1dJK8l8YPuLoWr3oJIu3PL9LrQpzKaw>
    <xmx:e4UwY2E3BGdmLdGtQ16C4dgkYPuaGsp0F2-xX5Vgbdq4IyPCfa745Q>
    <xmx:e4UwY36JaaISHIkWvHi8BgYz0PjEfFuNIiiCDN63mg-NjeI54S2Hqg>
Feedback-ID: i83e94755:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 25 Sep 2022 12:44:41 -0400 (EDT)
Date:   Sun, 25 Sep 2022 17:44:39 +0100
From:   Josh Triplett <josh@joshtriplett.org>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] io_uring: Support calling io_uring_register with a
 registered ring fd
Message-ID: <3cbedc531b633af4fe8632f7276aa843b5a54875.1664123680.git.josh@joshtriplett.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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

This is enough for many libraries to use io_uring transparently without
disrupting any callers. Libraries with even more stringent requirements
(e.g. never even transiently having a file descriptor open) will need
two additional pieces:
- Adding a flag to io_uring_setup to set up the ring directly as a
  registered file descriptor, without ever putting it in the file
  descriptor table.
- Supporting the initial mmap via a registered file descriptor, such as
  via an io_uring_register call.

 include/uapi/linux/io_uring.h |  6 +++++-
 io_uring/io_uring.c           | 30 +++++++++++++++++++++++-------
 2 files changed, 28 insertions(+), 8 deletions(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 6b83177fd41d..103b4babc175 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -427,6 +427,7 @@ struct io_uring_params {
 #define IORING_FEAT_RSRC_TAGS		(1U << 10)
 #define IORING_FEAT_CQE_SKIP		(1U << 11)
 #define IORING_FEAT_LINKED_FILE		(1U << 12)
+#define IORING_FEAT_REG_REG_RING	(1U << 13)
 
 /*
  * io_uring_register(2) opcodes and arguments
@@ -474,7 +475,10 @@ enum {
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
index 2965b354efc8..efe5170d3e77 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3350,7 +3350,7 @@ static __cold int io_uring_create(unsigned entries, struct io_uring_params *p,
 			IORING_FEAT_POLL_32BITS | IORING_FEAT_SQPOLL_NONFIXED |
 			IORING_FEAT_EXT_ARG | IORING_FEAT_NATIVE_WORKERS |
 			IORING_FEAT_RSRC_TAGS | IORING_FEAT_CQE_SKIP |
-			IORING_FEAT_LINKED_FILE;
+			IORING_FEAT_LINKED_FILE | IORING_FEAT_REG_REG_RING;
 
 	if (copy_to_user(params, p, sizeof(*p))) {
 		ret = -EFAULT;
@@ -3857,13 +3857,29 @@ SYSCALL_DEFINE4(io_uring_register, unsigned int, fd, unsigned int, opcode,
 	long ret = -EBADF;
 	struct fd f;
 
-	f = fdget(fd);
-	if (!f.file)
-		return -EBADF;
+	/*
+	 * Ring fd has been registered via IORING_REGISTER_RING_FDS, we
+	 * need only dereference our task private array to find it.
+	 */
+	if (opcode & IORING_REGISTER_USE_REGISTERED_RING) {
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
2.37.2

