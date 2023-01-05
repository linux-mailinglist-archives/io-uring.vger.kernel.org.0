Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E316865E9B9
	for <lists+io-uring@lfdr.de>; Thu,  5 Jan 2023 12:23:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231725AbjAELXn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 5 Jan 2023 06:23:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233184AbjAELXe (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 5 Jan 2023 06:23:34 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 792D35014E
        for <io-uring@vger.kernel.org>; Thu,  5 Jan 2023 03:23:33 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id g25-20020a7bc4d9000000b003d97c8d4941so1053647wmk.4
        for <io-uring@vger.kernel.org>; Thu, 05 Jan 2023 03:23:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pqtjp7Gb7AWv2wE6SfRrEbU95vMm3JEyoyqrEoS+6sM=;
        b=pQ7Ksk/v1AzsRAICPNo666blYJutdQfZ4NqPPf2AHgFMRIjtqLqXBnibmzS1aE8Q0/
         JfvA56YJTS4BceMka0awGvtluA6qLhp0vGj9oehjrhD+eZ0m8/rQOdMe7DGWSl1grT+D
         l5E12AzyF4lhlCR3h2w09Df89s4R5W651/CpB5TO4zHb9ngvFFL92gDtIAhGxLuUZDIO
         EP0KG6LKFmt4JwdNftMuT9f0DcVcTQcXo6SyWJ8KzICGocwHLzN5i6CE+xNVRlclaszu
         4BMBdHHn2j6rB5GycrYHv5wOtz4rKESO/PbKwyjDhaHUxg27V9D0EV1ZPd+XgA4bieo5
         LPpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pqtjp7Gb7AWv2wE6SfRrEbU95vMm3JEyoyqrEoS+6sM=;
        b=L9QMuFglZogj09UulzrjTg4ddK0Rw+eMoXRvrRshZ9GSvExJ7zi+AZ+BD9oaX2f/Jo
         0aVsuNJQtjIHgqCYOUJDW9ZK10xIps+Jqt+FVv26iqvPbECedXbStg5KXCOIW501LNbx
         SfaCGMrfws8wdOfWGwy8AKWp8DPBXuaW5QStLaRbBgyiF/oksvzZ40WS+XNpIxRR3YPa
         ZgpbpMVpwmpPbNG3AxlFOBizvKpZ1j3xlPzd0CCUHzKs3tCGT7diWHTJTWz3YJHd8T+x
         QPgJPpnbuO+fyg8T0m8+xQmBcJTRoE4NeX6ew3mUGbaQbx8asfX7juYzGMHNjoH4s3GP
         Rqeg==
X-Gm-Message-State: AFqh2kpkGHSsscdK9Tw+twmVGfW7joLBuChnAGMhR2f7VtIVcto8he3n
        fSTXHhTL9WqfBmWpWz0Ola3MYnPF1Gg=
X-Google-Smtp-Source: AMrXdXvZ2HgHmhUYDZexuHUXQNNZ1UR0bl0iOY6dZcSMPsvLYoHX4AF0IGuI3P9XXqck4wbJGVGSiA==
X-Received: by 2002:a05:600c:a51:b0:3cf:6f4d:c259 with SMTP id c17-20020a05600c0a5100b003cf6f4dc259mr35086538wmq.39.1672917812926;
        Thu, 05 Jan 2023 03:23:32 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::2:5c5f])
        by smtp.gmail.com with ESMTPSA id u13-20020a05600c19cd00b003c6f1732f65sm2220688wmq.38.2023.01.05.03.23.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Jan 2023 03:23:32 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCHSET REBASE 07/10] io_uring: simplify io_has_work
Date:   Thu,  5 Jan 2023 11:22:26 +0000
Message-Id: <26af9f73c09a56c9a035f94db56127358688f3aa.1672916894.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1672916894.git.asml.silence@gmail.com>
References: <cover.1672916894.git.asml.silence@gmail.com>
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

->work_llist should never be non-empty for a non DEFER_TASKRUN ring, so
we can safely skip checking the flag.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/io_uring.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index b4ca238cbd63..2376adce9570 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2416,8 +2416,7 @@ struct io_wait_queue {
 static inline bool io_has_work(struct io_ring_ctx *ctx)
 {
 	return test_bit(IO_CHECK_CQ_OVERFLOW_BIT, &ctx->check_cq) ||
-	       ((ctx->flags & IORING_SETUP_DEFER_TASKRUN) &&
-		!llist_empty(&ctx->work_llist));
+	       !llist_empty(&ctx->work_llist);
 }
 
 static inline bool io_should_wake(struct io_wait_queue *iowq)
-- 
2.38.1

