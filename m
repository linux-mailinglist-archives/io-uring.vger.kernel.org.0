Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3C8157FCBD
	for <lists+io-uring@lfdr.de>; Mon, 25 Jul 2022 11:53:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233694AbiGYJxf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 25 Jul 2022 05:53:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231825AbiGYJxe (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 25 Jul 2022 05:53:34 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39B74167FF
        for <io-uring@vger.kernel.org>; Mon, 25 Jul 2022 02:53:33 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id v13so7400857wru.12
        for <io-uring@vger.kernel.org>; Mon, 25 Jul 2022 02:53:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=A3sihs00hh7yUsVGm61oPxJU/8E8nz9XVaw8rankcW8=;
        b=ey2T+l1twleuG+OFLy9ixDezRiqsXOosmaT+VNL4km6nC26+SIIaK83Y7DUaeyhg09
         LoV6IrhMc1lyr7TKdDteQkatIvvl7I2NtYBRIsrKNb1UIGdjgrsY/C6q4flD12Dr+Nhp
         xQLhUakkqcg/y39b+4TwNsjT94N1YwaYwVsX5JxloKhMI/cn79NGLN3oPZelRGFuFC6l
         0rkiIT0xXfNPufAFrSnWSg/mD4lLASACiCG6gkraoLocATUm0ey6NlgYzyy+FH3QDfSl
         wLENtuHdiPDfkhxkqWulj01c6ll5i1QedYDIjQVZRRLG4kEx5cB3E5I0ycS7Vu6xzG0l
         9ljQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=A3sihs00hh7yUsVGm61oPxJU/8E8nz9XVaw8rankcW8=;
        b=QxBcWdTh2RQ1+cmWSmjhCsds6N6k8c+rwAvBolmWka6Aa1FwE0vW42uIQb0h20lY00
         KcjP1L3XQ/YHt5HTGusgy9w+GhOx7ywbPtkxpKQRrZtFzPRjy6+vtc5mMWBiVOzc/gI6
         hRMCVg7X+0ipnJliU2b84FMhAEP0p++hkxDdwQGTsv1ZvlVDztcJ9dyknFFkZ5OKYnAx
         kksUiHdwuVCJv+SXsU8m5AlufqsUlVDdBeZhXBPpZy9Kq9u92rcHHe8ZNhYneqOKGqDx
         ZqJ5dS92vfRI5ikLmD3J79jrKOPRaO1MB8r6vEIzXXejifDZbZg3OrMSqLQShdSWPCOs
         5V6Q==
X-Gm-Message-State: AJIora+gT0txJUum5k+xsnWM+rK+bxrG5jPHKHGBpxii68iLdrUihvdi
        W6ZUyy11Xf6NNvKXHYrJiG5wqUk5PJulnw==
X-Google-Smtp-Source: AGRyM1tV6ozSF8UOe5fzBkqnm0OEmKIDQSvJAHqzcXcll2hT+9hTADxkfvTqwU2LgQrDJI7LLL3kzw==
X-Received: by 2002:a5d:5089:0:b0:21e:734e:24c6 with SMTP id a9-20020a5d5089000000b0021e734e24c6mr6113481wrt.42.1658742811264;
        Mon, 25 Jul 2022 02:53:31 -0700 (PDT)
Received: from 127.0.0.1localhost.com ([2620:10d:c093:600::1:1720])
        by smtp.gmail.com with ESMTPSA id n12-20020a05600c3b8c00b003a2ed2a40e4sm18909636wms.17.2022.07.25.02.53.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jul 2022 02:53:30 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 1/4] io_uring/net: improve io_get_notif_slot types
Date:   Mon, 25 Jul 2022 10:52:03 +0100
Message-Id: <e4d15aefebb5e55729dd9b5ec01ab16b70033343.1658742118.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <cover.1658742118.git.asml.silence@gmail.com>
References: <cover.1658742118.git.asml.silence@gmail.com>
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

Don't use signed int for slot indexing.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/notif.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/notif.h b/io_uring/notif.h
index 6cd73d7b965b..3e05d2cecb6f 100644
--- a/io_uring/notif.h
+++ b/io_uring/notif.h
@@ -67,7 +67,7 @@ static inline struct io_notif *io_get_notif(struct io_ring_ctx *ctx,
 }
 
 static inline struct io_notif_slot *io_get_notif_slot(struct io_ring_ctx *ctx,
-						      int idx)
+						      unsigned idx)
 	__must_hold(&ctx->uring_lock)
 {
 	if (idx >= ctx->nr_notif_slots)
-- 
2.37.0

