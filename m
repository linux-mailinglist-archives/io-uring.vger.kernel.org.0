Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 787D44E403E
	for <lists+io-uring@lfdr.de>; Tue, 22 Mar 2022 15:10:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234907AbiCVOKm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 22 Mar 2022 10:10:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234869AbiCVOKk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 22 Mar 2022 10:10:40 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 402F45E162
        for <io-uring@vger.kernel.org>; Tue, 22 Mar 2022 07:09:13 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id n35so9544531wms.5
        for <io-uring@vger.kernel.org>; Tue, 22 Mar 2022 07:09:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=t3jmwHa0EzjVBW2IwOJpFR1IYphM7vn87uy8aJdIr9s=;
        b=FvKqWi+pNsQpn1k5b781/oCP3OB4YYa/m88XFBVpQquFpjLurYSrs8gLaNmHuU7Iiv
         cZgxQ/OUcMfpRNN4tuPiAhjMBgjTTRvPUYcye58XNK2xveq1AXaytTPcn+93AUQZHS5A
         IBZQTU+8+x+kqqE7StCdlzbibSRDj9EQAc2BSj82+CSLOh+NGx5+V4iWF4LSn1K8Bw4c
         dgBCWROzsM6/ILH1EP030CVj6ajS3st2yAeomxXEwaukToUq/WbcXPdsC4OGcWNQ5uOA
         Qg1p89Y9Z7RN4M/QYRN34py1nSLH1ehcDB1o6TRzMpZjNHZZxH5MSXkn2eetPy4lraFO
         t6sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=t3jmwHa0EzjVBW2IwOJpFR1IYphM7vn87uy8aJdIr9s=;
        b=SjfSUPxS8mg0i3bFldMxH2FGZ2jiDSpVj3QuiHbHcYEUcQJjpu/PtleewNWyjMWyXY
         nokyd5HGVcnTne+e2oug+1eq+5vKkX4R7idYJAw1VsDPoW+UE02I4KpEyspD8WmidMtC
         rYALftJqO8tRT3+Os907u711zQcC2TYs3RI2M31ojWvWfTeSvgOxBPsEql65utq92Pyx
         v7aL+Qyi39T38Ndd/NfUVmOG7M9TH+6hx+RW4KZlLQTHnTPTghEGHAyubgDndjhf22sw
         0yRdX7KIwThR7Nw4vKLsfDCQfyU8EYqk4+zTfZlGnLM+Fwrys0y9OvAFkY5KyteViKd2
         6exw==
X-Gm-Message-State: AOAM530pn3oZ1uckoKl9brN61MJUM48oOKG3Yr2nQwAegNNYuFrP0Vt+
        IMHnOdhaOARHdoFHXmcgJDNWtaLRynMNgA==
X-Google-Smtp-Source: ABdhPJzqV73nzMn8U0gU9sbeI1GJpXNbNvlU5t6VMhoFB8HGMA/D5xiud94uIX0X/DCJzboStKkxpA==
X-Received: by 2002:a7b:ce02:0:b0:381:2007:f75c with SMTP id m2-20020a7bce02000000b003812007f75cmr4129348wmc.6.1647958151609;
        Tue, 22 Mar 2022 07:09:11 -0700 (PDT)
Received: from 127.0.0.1localhost (82-132-222-32.dab.02.net. [82.132.222.32])
        by smtp.gmail.com with ESMTPSA id m3-20020a5d64a3000000b00203ed35b0aesm21987733wrp.108.2022.03.22.07.09.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Mar 2022 07:09:11 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 2/3] io_uring: pre-calculate syscall iopolling decision
Date:   Tue, 22 Mar 2022 14:07:57 +0000
Message-Id: <7fd2f8fc2606305aa06dd8c0ff8f76a66b39c383.1647957378.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1647957378.git.asml.silence@gmail.com>
References: <cover.1647957378.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Syscall should only iopoll for events when it's a IOPOLL ring and is not
SQPOLL. Instead of check both flags every time we can save it in ring
flags so it's easier to use. We don't care much about an extra if there,
however it will be inconvenient to copy-paste this chunk with checks in
future patches.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 8d29ef2e552a..d7ca4f28cfa4 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -359,6 +359,7 @@ struct io_ring_ctx {
 		unsigned int		drain_active: 1;
 		unsigned int		drain_disabled: 1;
 		unsigned int		has_evfd: 1;
+		unsigned int		syscall_iopoll: 1;
 	} ____cacheline_aligned_in_smp;
 
 	/* submission data */
@@ -10936,14 +10937,7 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 	if (flags & IORING_ENTER_GETEVENTS) {
 		min_complete = min(min_complete, ctx->cq_entries);
 
-		/*
-		 * When SETUP_IOPOLL and SETUP_SQPOLL are both enabled, user
-		 * space applications don't need to do io completion events
-		 * polling again, they can rely on io_sq_thread to do polling
-		 * work, which can reduce cpu usage and uring_lock contention.
-		 */
-		if (ctx->flags & IORING_SETUP_IOPOLL &&
-		    !(ctx->flags & IORING_SETUP_SQPOLL)) {
+		if (ctx->syscall_iopoll) {
 			ret = io_validate_ext_arg(flags, argp, argsz);
 			if (unlikely(ret))
 				goto out;
@@ -11281,6 +11275,17 @@ static __cold int io_uring_create(unsigned entries, struct io_uring_params *p,
 	ctx = io_ring_ctx_alloc(p);
 	if (!ctx)
 		return -ENOMEM;
+
+	/*
+	 * When SETUP_IOPOLL and SETUP_SQPOLL are both enabled, user
+	 * space applications don't need to do io completion events
+	 * polling again, they can rely on io_sq_thread to do polling
+	 * work, which can reduce cpu usage and uring_lock contention.
+	 */
+	if (ctx->flags & IORING_SETUP_IOPOLL &&
+	    !(ctx->flags & IORING_SETUP_SQPOLL))
+		ctx->syscall_iopoll = 1;
+
 	ctx->compat = in_compat_syscall();
 	if (!capable(CAP_IPC_LOCK))
 		ctx->user = get_uid(current_user());
-- 
2.35.1

