Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21321662906
	for <lists+io-uring@lfdr.de>; Mon,  9 Jan 2023 15:51:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234828AbjAIOve (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 9 Jan 2023 09:51:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229649AbjAIOvO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 9 Jan 2023 09:51:14 -0500
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E53E53E841
        for <io-uring@vger.kernel.org>; Mon,  9 Jan 2023 06:47:38 -0800 (PST)
Received: by mail-ej1-x62d.google.com with SMTP id az20so1624758ejc.1
        for <io-uring@vger.kernel.org>; Mon, 09 Jan 2023 06:47:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7g4vgDRhIhKHTbt0MChXU5vp/QdCButiCZ9Su7pb0b8=;
        b=CHbMHC0uXaxbNKNzqTBlD0wDepE3G6WeD0Z15shtB9BZt5mmj2MqtKaQ62HR/ukZ1E
         uX3ID5v9jrAw5U/LJwOQCb2R0cRJ99VRAQOK9ton95ti8Y88t6O93nCDlfYoNnUlMUvQ
         ptdpGrd3rZLouSoeDDYVom67/Wx3dvEPlXk+TnOoeG+P1TvOYCLce/maOmAyD5mvqw/x
         yEPddoM8KC6V3iDFVmNGSv75rRpYetFzMafJuBExUHyAIulIeVpgNQSlQVvSvniwIpQs
         uRtuqintDss0mH/pzNBlZ+9wOe6eHVuicvOXxVs6IzqXPQmlMiN2Muy8aGi5ghffeIjs
         UHhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7g4vgDRhIhKHTbt0MChXU5vp/QdCButiCZ9Su7pb0b8=;
        b=AwkN1UZZlDNGLEVsZ8FR5bjujbw7FB4tsSXyHSpk8jfNNmeiFADOt5LqJlYnQqX5rA
         71LC0/JHaTfeyuTgyVwhkz2kpGxPhQWflAnVNspBytCHMfqMS2b3EVSJmQjSD8kW+LVB
         4FzWztRzNo0hg4moK7XldNSvApDKV4Fqwlxrlcq9CWer1I9ZQNF0VZRj4D8O6OFh/ZGg
         z+plFX4IQEhWLXDaN3KpSCX3kYb95ZpoedaAP+AQ5LHiQ5d1Q9pc+uyciLZXhTR/a99C
         bc1H88Ebh5reVVjOmAAbZwHovvPqa09EBJVNXpr9MmjfNVzMzzR12TIRhuejskejiGy6
         m2xQ==
X-Gm-Message-State: AFqh2kojfE7AhMH3KQ/ngimM0Xe4/Vw83nnOc9o1m44z38QwO/0JObxN
        AFEF5qX9MQ8EIEE9KZLo8F90vxRmoVw=
X-Google-Smtp-Source: AMrXdXtAE+7WmhaMEg6Wk1Y95LJBvOVkgrCR1+XhVRX0hqfmvrQUNOMwraoOrIezC6oRcaF6z+0ACw==
X-Received: by 2002:a17:907:c717:b0:7c1:ad6:638a with SMTP id ty23-20020a170907c71700b007c10ad6638amr60330073ejc.17.1673275657331;
        Mon, 09 Jan 2023 06:47:37 -0800 (PST)
Received: from 127.0.0.1localhost (188.29.102.7.threembb.co.uk. [188.29.102.7])
        by smtp.gmail.com with ESMTPSA id x11-20020a170906b08b00b0084c62b7b7d8sm3839578ejy.187.2023.01.09.06.47.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Jan 2023 06:47:37 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH v3 08/11] io_uring: wake up optimisations
Date:   Mon,  9 Jan 2023 14:46:10 +0000
Message-Id: <60ad9768ec74435a0ddaa6eec0ffa7729474f69f.1673274244.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1673274244.git.asml.silence@gmail.com>
References: <cover.1673274244.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Flush completions is done either from the submit syscall or by the
task_work, both are in the context of the submitter task, and when it
goes for a single threaded rings like implied by ->task_complete, there
won't be any waiters on ->cq_wait but the master task. That means that
there can be no tasks sleeping on cq_wait while we run
__io_submit_flush_completions() and so waking up can be skipped.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index a6ed022c1356..0dabd0f3271f 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -621,6 +621,25 @@ static inline void __io_cq_unlock_post(struct io_ring_ctx *ctx)
 	io_cqring_wake(ctx);
 }
 
+static inline void __io_cq_unlock_post_flush(struct io_ring_ctx *ctx)
+	__releases(ctx->completion_lock)
+{
+	io_commit_cqring(ctx);
+	__io_cq_unlock(ctx);
+	io_commit_cqring_flush(ctx);
+
+	/*
+	 * As ->task_complete implies that the ring is single tasked, cq_wait
+	 * may only be waited on by the current in io_cqring_wait(), but since
+	 * it will re-check the wakeup conditions once we return we can safely
+	 * skip waking it up.
+	 */
+	if (!(ctx->flags & IORING_SETUP_DEFER_TASKRUN)) {
+		smp_mb();
+		__io_cqring_wake(ctx);
+	}
+}
+
 void io_cq_unlock_post(struct io_ring_ctx *ctx)
 	__releases(ctx->completion_lock)
 {
@@ -1480,7 +1499,7 @@ static void __io_submit_flush_completions(struct io_ring_ctx *ctx)
 			}
 		}
 	}
-	__io_cq_unlock_post(ctx);
+	__io_cq_unlock_post_flush(ctx);
 
 	if (!wq_list_empty(&ctx->submit_state.compl_reqs)) {
 		io_free_batch_list(ctx, state->compl_reqs.first);
-- 
2.38.1

