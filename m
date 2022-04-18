Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F22B505EBF
	for <lists+io-uring@lfdr.de>; Mon, 18 Apr 2022 21:53:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346687AbiDRT4T (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 18 Apr 2022 15:56:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236327AbiDRT4S (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 18 Apr 2022 15:56:18 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED5002C65C
        for <io-uring@vger.kernel.org>; Mon, 18 Apr 2022 12:53:38 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id t11so28694234eju.13
        for <io-uring@vger.kernel.org>; Mon, 18 Apr 2022 12:53:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yCa1XIDjcq9bhoKrTDvbvAluNLEDSi6ZzmlY3iY87uM=;
        b=iTsYGh9XJS9XMj02ClifHHCm+pgTKPRy0/8kXw2p6Ceia05OlmKNuIaDUrH0HNSK58
         9WDEdQ+mb1i5ZWchFzAUlRlNMD9rCxsGrq0fDbpfA4fNMRoe6GR6EBHY/kaMEpGuGXOi
         DIUzEkvm/li6Qda5/N4o+rz1hbNPyJcY/nYODumEmnTaqRTAdKP1SneCaCOPFvTlx4In
         hr7lRNuTOdNHGt3l4UyIgqidEa8tVCaSf4sPYp1sMvdANhxh7PjoxLY9Ce8o/VWPD+3U
         cakySCm2as8gc04Y3oPyK4gGcI2++EcA+lwMxGY4Np/ZqYhGkNzdyej7Al1xualR6JNx
         S+Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yCa1XIDjcq9bhoKrTDvbvAluNLEDSi6ZzmlY3iY87uM=;
        b=g+Svf+i97OXV547YXKu+p/QHusPLCOU4NsspZ7y39gOtazUFHu7UOul7JTPqwwUvlx
         /CsyijCaVXph61qI1q3c3ZfOT7CN2U5XpIQq8ErixEeeQQf4+rWGuBvXNzHR6WRixvbG
         HGKGBw8kZyiMxZ50PaQGhMvPIXoIMAcf+jknvswTy5vBtSeqWAafg6mTlsdWO7KggTTA
         xfj74VZvUfZGjRzMpeIbPQn25Ujke0mqpurCMJAFiU4CRgQ/vHN9tXuB0puKPUBnU/Ps
         m1v9QqT70LO3rTJzSjOthDDv5Ph3Kg6OhYMJNGAB0/RyuqAWY3UsCQL09s830wm4pgNX
         XrlQ==
X-Gm-Message-State: AOAM531FpibgczpS30japdVvB7o5c/BDikUJsHk9gMr2wjj4a7MenVf6
        ePuASNTB07QjHK4xG/rqnR+/uN9S7sY=
X-Google-Smtp-Source: ABdhPJzkFro1fxucO7CB1j/IB66/TfKOR6p3mlox52af2wckhdSOI+Pm698talFI67pz6T8cdRhKJQ==
X-Received: by 2002:a17:907:97c9:b0:6db:ab53:1fdf with SMTP id js9-20020a17090797c900b006dbab531fdfmr10427159ejc.406.1650311617274;
        Mon, 18 Apr 2022 12:53:37 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.129.70])
        by smtp.gmail.com with ESMTPSA id bf11-20020a0564021a4b00b00423e997a3ccsm1629143edb.19.2022.04.18.12.53.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Apr 2022 12:53:36 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 1/5] io_uring: use right helpers for file assign locking
Date:   Mon, 18 Apr 2022 20:51:11 +0100
Message-Id: <c9c9ff1e046f6eb68da0a251962a697f8a2275fa.1650311386.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <cover.1650311386.git.asml.silence@gmail.com>
References: <cover.1650311386.git.asml.silence@gmail.com>
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

We have io_ring_submit_[un]lock() functions helping us with conditional
->uring_lock locking, use them in io_file_get_fixed() instead of hand
coding.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 6988bdc182e4..423427e2203f 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7371,8 +7371,7 @@ static inline struct file *io_file_get_fixed(struct io_kiocb *req, int fd,
 	struct file *file = NULL;
 	unsigned long file_ptr;
 
-	if (issue_flags & IO_URING_F_UNLOCKED)
-		mutex_lock(&ctx->uring_lock);
+	io_ring_submit_lock(ctx, issue_flags);
 
 	if (unlikely((unsigned int)fd >= ctx->nr_user_files))
 		goto out;
@@ -7384,8 +7383,7 @@ static inline struct file *io_file_get_fixed(struct io_kiocb *req, int fd,
 	req->flags |= (file_ptr << REQ_F_SUPPORT_NOWAIT_BIT);
 	io_req_set_rsrc_node(req, ctx, 0);
 out:
-	if (issue_flags & IO_URING_F_UNLOCKED)
-		mutex_unlock(&ctx->uring_lock);
+	io_ring_submit_unlock(ctx, issue_flags);
 	return file;
 }
 
-- 
2.35.2

