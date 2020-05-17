Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D98E1D679D
	for <lists+io-uring@lfdr.de>; Sun, 17 May 2020 13:15:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727978AbgEQLPL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 17 May 2020 07:15:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727966AbgEQLPI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 17 May 2020 07:15:08 -0400
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36B4FC061A0C;
        Sun, 17 May 2020 04:15:08 -0700 (PDT)
Received: by mail-lf1-x144.google.com with SMTP id v5so5463655lfp.13;
        Sun, 17 May 2020 04:15:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=9FMn8rDj4mlz2ncywpsHUDI1Lr6iaXbglOWZhSk2bnc=;
        b=X6g//psFeEijs6rN378GerBQyW29EyOZm+NkJSmSdbV9jM4CCsNbwXrzE8Jb65X09c
         HBFt3EzfUmJr57wKQMTSy0JctxnjI+LGlaQ5/ELC1SBqpoc4+/bl4nQ0f4axQ77xSzb2
         IT0CDpSHR9QFxijPFXQTcIhe41063s/IeYHNHGiwo8UQfUCLBaQIoBsJPJnxOSUbZePk
         dppPv7E7ciLlBnTRrPudrDkUTjMi1anWAnxb2kW8gFhg3tYsSNQQ7+GnfWK3fGoD8dnq
         R/tihqBiOMurN0QHkwPB/Nxh85g5kcj/bv0E287xQSsHlnRhC+BjWMFu7IyV38QrOAFe
         MafQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9FMn8rDj4mlz2ncywpsHUDI1Lr6iaXbglOWZhSk2bnc=;
        b=OsNqgg+qNuOfsmX/Ib9D/OxDtVmVFEY4HkZqBeJhpXFeAQ4X5rE8jncvX3yjmsZ+R9
         /sjtjs7UYdsp5Dr8GvV85rGyJ/cWwWxShnAcgttiG9LR+7dV3pyLOIm7OkWtUcUAjZvp
         4vnq7B8z5n4qJJ6seSXdKwMxUDT3v5XfiGed1DscwC1yVALFbzjUhMRh0a1+Z1b1aMAh
         o5kF0m7l84mKN2YY5PY27P/sIE0sdm4DfQfla+tQ1IsoFTZlkogekA9CnhL5dEygxaBe
         Vb6j4xln++iqcx3CkRSl49kY5HZRvTyDjURwCjw1PJEatOufvh9tFWOeJ9Jh04OFcKOF
         NwAw==
X-Gm-Message-State: AOAM533TRZmHxdhDkiyF7eONE4zP19cf1N/wi3kW5pRq8sjTk7s9mrJD
        DC9eEVM5Reiifl3GZKcAxwkD1Sd3
X-Google-Smtp-Source: ABdhPJzrxLuYg3CIvB42NPjeYM9+DN57d7sYFFyfjMk4qroy8GTPdnykTA6PliMG2yLV4pFF0io8Sw==
X-Received: by 2002:a05:6512:308e:: with SMTP id z14mr8436850lfd.29.1589714106711;
        Sun, 17 May 2020 04:15:06 -0700 (PDT)
Received: from localhost.localdomain ([82.209.196.123])
        by smtp.gmail.com with ESMTPSA id v2sm3970990ljv.86.2020.05.17.04.15.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 May 2020 04:15:06 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] io_uring: don't repeat valid flag list
Date:   Sun, 17 May 2020 14:13:42 +0300
Message-Id: <68d4e966edfecad390f0367e71f9fc874dccb01a.1589713554.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1589713554.git.asml.silence@gmail.com>
References: <cover.1589713554.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

req->flags stores all sqe->flags. After checking that sqe->flags are
valid set if IOSQE* flags, no need to double check it, just forward them
all.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 9c5a95414cbd..83b599815cf0 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5924,9 +5924,7 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 	}
 
 	/* same numerical values with corresponding REQ_F_*, safe to copy */
-	req->flags |= sqe_flags & (IOSQE_IO_DRAIN | IOSQE_IO_HARDLINK |
-					IOSQE_ASYNC | IOSQE_FIXED_FILE |
-					IOSQE_BUFFER_SELECT | IOSQE_IO_LINK);
+	req->flags |= sqe_flags;
 
 	if (!io_op_defs[req->opcode].needs_file)
 		return 0;
-- 
2.24.0

