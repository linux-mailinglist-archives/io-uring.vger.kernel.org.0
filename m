Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B5F750A113
	for <lists+io-uring@lfdr.de>; Thu, 21 Apr 2022 15:45:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386738AbiDUNsJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 21 Apr 2022 09:48:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386686AbiDUNsH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 21 Apr 2022 09:48:07 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06663B7C4
        for <io-uring@vger.kernel.org>; Thu, 21 Apr 2022 06:45:18 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id m14so6778612wrb.6
        for <io-uring@vger.kernel.org>; Thu, 21 Apr 2022 06:45:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LG+k7pJP3va2B4CC4iSsk2VNWTmooFBrD6JfxyKCyN8=;
        b=ZM1C8xwtpvgZj+8bwXXgJ7OKmSBK4eFkqpaNrr55aEg7tvwRctAHVDrrk5HMeTnKg2
         EdA/5LFZ7xp+wCmrGksNnd4jGg8rgcHlJv8t3f25JQ3I/eDsoRqQKV9aLOze3HB+aTwI
         KuwLkAk/0bp7p/CVABy3fBWz9tNvEJNzva6vGPl/wwbZyEEGmzPAQEctog9T8rjJNKxQ
         730z08uj9KkTBMiFKqt7LffO277HdMyTQYIfCKyQTLBncsMrXF/byh7cqwODF/Qf4K0v
         qItm2DJ8IjrwSXKldLobSc3WRry6V4M4jI5HOsDI6mgGrPXxgdu64rUdL+JkacEHzbXY
         bFCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LG+k7pJP3va2B4CC4iSsk2VNWTmooFBrD6JfxyKCyN8=;
        b=wdPP6lko05dN3j67nP0j2rJbaNAF3o+umut7h814cWvE+3Y1bipwFMMQfrQaCFerW5
         gqzO3yNuD7CRCKLLWFU5eKKFgx2Vjzyzka9I2uMO0z3I7OlRP77gWaAOoCTgalYQWsfJ
         HGIqYgBlAYJFAZN3726lmR5auXV/Tlq4qEZyTeDVULkazAwpmMbGcG+3MuV5vyynVWIo
         wD1EhX1GfLc/IadXBpKceKlCqV322nhOGvG/hsUGZ7uSYO9Qo+9RDH2wp/rEXPJPX700
         yOdir/DM3FqUy06dgY/qHC6e/+SkRgWiJvvYCIAf1C9XS/cEAiD9Bh35rmbjbEzLOSS+
         Mb7A==
X-Gm-Message-State: AOAM530yKHuHlNXRdFcwufy8JR2fD02S2cq90VHLR5dNMTq0NJpMnp9z
        DRutu6mGgnV2HnMTy+Mp1C3GbQr/rJE=
X-Google-Smtp-Source: ABdhPJxNVOsNV2Bd+293hXWLjH5rQOjT9KwnTfw6MefMmbHyzRMXyKhdActrKUijfxKSErmK/j9M4g==
X-Received: by 2002:adf:e5d2:0:b0:207:9be3:c080 with SMTP id a18-20020adfe5d2000000b002079be3c080mr19214545wrn.519.1650548716433;
        Thu, 21 Apr 2022 06:45:16 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.129.218])
        by smtp.gmail.com with ESMTPSA id m7-20020adfe0c7000000b002060e7bbe49sm2837821wri.45.2022.04.21.06.45.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Apr 2022 06:45:16 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [RFC 09/11] io_uring: refactor io_run_task_work()
Date:   Thu, 21 Apr 2022 14:44:22 +0100
Message-Id: <65798ad1404ed1a33a2bb57eea78ca44f6963d54.1650548192.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <cover.1650548192.git.asml.silence@gmail.com>
References: <cover.1650548192.git.asml.silence@gmail.com>
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

The second check in io_run_task_work() is there only for SQPOLL, for
which we use TWA_NONE. Remove the check and hand code SQPOLL specific
task_work running where it makes sense.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index ea7b0c71ca8b..6397348748ad 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2793,9 +2793,7 @@ static inline unsigned int io_sqring_entries(struct io_ring_ctx *ctx)
 
 static inline bool io_run_task_work(void)
 {
-	struct io_uring_task *tctx = current->io_uring;
-
-	if (test_thread_flag(TIF_NOTIFY_SIGNAL) || (tctx && tctx->task_running)) {
+	if (test_thread_flag(TIF_NOTIFY_SIGNAL)) {
 		__set_current_state(TASK_RUNNING);
 		clear_notify_signal();
 		io_uring_task_work_run();
@@ -10382,6 +10380,10 @@ static __cold void io_uring_cancel_generic(bool cancel_all,
 
 		prepare_to_wait(&tctx->wait, &wait, TASK_INTERRUPTIBLE);
 		io_run_task_work();
+		if (tctx->task_running) {
+			__set_current_state(TASK_RUNNING);
+			io_uring_task_work_run();
+		}
 		io_uring_drop_tctx_refs(current);
 
 		/*
-- 
2.36.0

