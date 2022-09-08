Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CEDA5B22F0
	for <lists+io-uring@lfdr.de>; Thu,  8 Sep 2022 17:59:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231237AbiIHP7J (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 8 Sep 2022 11:59:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230407AbiIHP7G (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 8 Sep 2022 11:59:06 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68F7DF827F
        for <io-uring@vger.kernel.org>; Thu,  8 Sep 2022 08:59:05 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id l14so15622663eja.7
        for <io-uring@vger.kernel.org>; Thu, 08 Sep 2022 08:59:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=v9r22If6h69B1ae0T4+KgnzjvLRV9orbZ+tGlc/KePA=;
        b=liAwAX8RYVmIYFl6pJUImMIE+VXAw+4dzJsTJf1gNfbORPKRWuIBeWkBPO+55D7cMh
         kBJ8q5YwVjJC0al34icZSRvxrh2xFkBn6KLCUl2W3T32T2ncdJA/I1bzUWGq8sQ1azi0
         hVe+ablw54+cytgjz6vinvq/TBu9ggpGdeFUJyJybQjB+K9u1XsYRmDTTLJjvJx7ZQTF
         i6cGG8p0lfPWVAxudV+ySR7GN/2p5ledFsg6yDuwJnDFHnzn5qeo6V2dicp5KU3ALuee
         rcHRXTUN9zi93X1R+tFZb90mORhMQZOPodtDKpLkyVALCWizipH38LtpnID8gGz3mQaI
         h2nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=v9r22If6h69B1ae0T4+KgnzjvLRV9orbZ+tGlc/KePA=;
        b=RqKmOecGsqkEs0mLbWQNJiZ/TsSDU/yQX5wFenkkr+wL6PBjIjr3x6EriL/GC+Mpyg
         G9Wcof/Imh2b/dtj35AU67NEjfHRur+whnOhsfnNPC3j6b3n5LzTwNqm0UGj527YptHv
         vsG5ab73w+QHuop80m/ocynGq65ESm/8zivyHvzSKDXA/MYOuAKbHOOd7dhVBI1wHjZs
         xXuQnQvB+1iHcBgzK5tPMATB/NI/1hvCjO3M9XGSrsaDuTTn5dIsv+pUMraP3C5/ovqJ
         uW+O5ZnZ3OVTSccvo5v5f8ca45Ue4oOak2PaiOsGuGCi8p0VAZ9Inior7iz0cxLndOlI
         HHQg==
X-Gm-Message-State: ACgBeo28dt8eE+nomE5Zs55wKzAa81nI0thKSELSLxqoKbONgu7Rwk1R
        cKy3EBP4ZLaIY7GQfdpLq95lry+gxRI=
X-Google-Smtp-Source: AA6agR5p1ZvUb4chugFj7qMOaj7gPWy6tcbc/XUwuvKD+NYoAkJzE/QVCXD6LhxTNuUx86ndtArrhw==
X-Received: by 2002:a17:907:94c2:b0:73d:c534:1ac0 with SMTP id dn2-20020a17090794c200b0073dc5341ac0mr6598776ejc.461.1662652743423;
        Thu, 08 Sep 2022 08:59:03 -0700 (PDT)
Received: from 127.0.0.1localhost.com ([2620:10d:c092:600::2:cfb9])
        by smtp.gmail.com with ESMTPSA id q26-20020a1709060e5a00b0073872f367cesm1392503eji.112.2022.09.08.08.59.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Sep 2022 08:59:03 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com,
        Dylan Yudaken <dylany@fb.com>
Subject: [PATCH 5/6] io_uring: add fast path for io_run_local_work()
Date:   Thu,  8 Sep 2022 16:56:56 +0100
Message-Id: <f6a885f372bad2d77d9cd87341b0a86a4000c0ff.1662652536.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <cover.1662652536.git.asml.silence@gmail.com>
References: <cover.1662652536.git.asml.silence@gmail.com>
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

We'll grab uring_lock and call __io_run_local_work() with several
atomics inside even if there are no task works. Skip it if ->work_llist
is empty.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 2fb5f1e78fb2..85b795e4dc6a 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1208,6 +1208,9 @@ int io_run_local_work(struct io_ring_ctx *ctx)
 	bool locked;
 	int ret;
 
+	if (llist_empty(&ctx->work_llist))
+		return 0;
+
 	locked = mutex_trylock(&ctx->uring_lock);
 	ret = __io_run_local_work(ctx, locked);
 	if (locked)
-- 
2.37.2

