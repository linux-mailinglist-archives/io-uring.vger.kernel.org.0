Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3212165B990
	for <lists+io-uring@lfdr.de>; Tue,  3 Jan 2023 04:05:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236622AbjACDFb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 2 Jan 2023 22:05:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236576AbjACDF1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 2 Jan 2023 22:05:27 -0500
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A305BBF59
        for <io-uring@vger.kernel.org>; Mon,  2 Jan 2023 19:05:26 -0800 (PST)
Received: by mail-wm1-x32f.google.com with SMTP id ay2-20020a05600c1e0200b003d22e3e796dso22196992wmb.0
        for <io-uring@vger.kernel.org>; Mon, 02 Jan 2023 19:05:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=P+EQRTaDuT5Ag8ayOXl3BanL3YIC2TQpRoWl91YOkYw=;
        b=LUd8Ax58JoWPH+xsb0kt6PRIXVdauaIvdhT6CBr6IZG9EIfvn4Hq3NP9QWNZ5oGb5T
         JNWCn93/2Q/vjIDxQ04sUH91JaJBRFnPfP3JsCIv50yTmSzT1z92pTgO32ZWOxCEgJb8
         TBXvgR7pYXViXEHDMqsveX+kN7QI1CcKb/tlQIHZQ1FHnn7yN+4lR17GFGK73DkUxd1z
         dyUFqJ0B6otMPpplSPEGfQl1/J0RBN74hcVvMPxp/xlk1KYsLysAHLPnqvNarvWB5+BE
         AxZaHrRJjFYRVv7iJei0fHiYpHI/6jsNDXSOE5kly9zul5IhplO2Vrrj3xRZnV4/Zced
         oaOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=P+EQRTaDuT5Ag8ayOXl3BanL3YIC2TQpRoWl91YOkYw=;
        b=x33F06uTh9PJWQ4/ybYRDraRlXuD6Vcss8AZGiXNr3sYXIPdjbLuB7Cd/a7izi9zOk
         onOngx07NtovBN8VmVb/j62XPgENNSiJVvK2ICmN84WGCiruGzmM2VZrpvQvMW4c0FJ3
         Sj7Lqvw9ei4xtXf0oiu5NJA9Q87X5FvkJACwiQPFVhBsIadHCQzLQJ41ZYPOhy20ubpf
         iQ6IKO9+USwx823Cahu7HT0IMrJqN4o9SAXLBxylfV6MRU0Cya0xYlxEgq3ZHXBXah27
         iQvCy7HwkWulas73PbEhTaxGMi3H2fPMEjOcw25IJ7csH0nF7iRPB6YZqYCLbM/7AeUR
         o+yQ==
X-Gm-Message-State: AFqh2kqGVZ2TAguYEQ99fo7rPHYvyUj/W/K/BRaxALk1ECKc4swERjCo
        K8QpLhl0n8pezk02kBZUBqeZWc+2Zms=
X-Google-Smtp-Source: AMrXdXutjqoipSI+zkKApC13atGLI0G/vroWPZs4dg6wEzF1CW7cpwm72TNRCJE+3nUWBJfSQjPRBg==
X-Received: by 2002:a05:600c:2252:b0:3d3:5d8b:7af with SMTP id a18-20020a05600c225200b003d35d8b07afmr32615459wmm.41.1672715125097;
        Mon, 02 Jan 2023 19:05:25 -0800 (PST)
Received: from 127.0.0.1localhost (188.28.229.101.threembb.co.uk. [188.28.229.101])
        by smtp.gmail.com with ESMTPSA id m1-20020a7bca41000000b003d1de805de5sm39967839wml.16.2023.01.02.19.05.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Jan 2023 19:05:24 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [RFC v2 07/13] io_uring: simplify io_has_work
Date:   Tue,  3 Jan 2023 03:03:58 +0000
Message-Id: <8a275bf82c72132862aba3f268718555caa81a53.1672713341.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1672713341.git.asml.silence@gmail.com>
References: <cover.1672713341.git.asml.silence@gmail.com>
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
---
 io_uring/io_uring.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index fc9604848bbb..a8d3826f3d17 100644
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

