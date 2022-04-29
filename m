Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B6DE515310
	for <lists+io-uring@lfdr.de>; Fri, 29 Apr 2022 19:56:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379492AbiD2SAG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 29 Apr 2022 14:00:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379834AbiD2SAD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 29 Apr 2022 14:00:03 -0400
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B545BC44C3
        for <io-uring@vger.kernel.org>; Fri, 29 Apr 2022 10:56:44 -0700 (PDT)
Received: by mail-il1-x132.google.com with SMTP id r17so4461799iln.9
        for <io-uring@vger.kernel.org>; Fri, 29 Apr 2022 10:56:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kvQp3PzEwPyo0t/2MRUbVmXPNrATyUTeiveDQI37c7k=;
        b=K3mgpA5aeSA+pB2yDHYNX39enwwLjod4rdDZym9beZ3emqEc2/prnIoxVoWTZUmRHT
         YXIIfb52Sr1Q3LPZBLAxYAmQ6YOlrk4S04I5W6XSUoHHFETHfsz9Ujd5QxAPC61qom/u
         mdO7EOsszQ4HvlNUwOjLdgyMoZNFS1ossgxjaq022attw/21BKcP/itGcxCG+fCdTGMC
         kJboIJgQ2rUafbNgVWLGnv1ESNQ70UQGmBKfkMeSmEU2gZaCLpKXL1zqwhZhw8rcTZiK
         jf3pqP9sDKpu0Kxi/Zst8HoRkBCzmggEPBHRHvJCRsXZ0yhP6um9ITfXS3xsTToiYHTK
         ijTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kvQp3PzEwPyo0t/2MRUbVmXPNrATyUTeiveDQI37c7k=;
        b=VeRXSEAqNbkJIOv3qU+5krBm8/GiEnDZBcau+PLICTL58XOVmRGSwunaYhx6Mp3JKi
         xRQpS2sX8xMfPKkSa9MNl42z67fWER4tOMeZ4iewWYmigkI5ZJ4RzF1ifmk9vPjpR+KG
         smFdxHLzs5Q5mMn7GLS5mBZSEYoOVpupyMOxlDnJDTEEsVuLu8rmjEoWoxgKkchfcDTe
         YhXXK5B/gEENTbCwsJcr5agxFbCbbuecHhIQs5BxnKpxkYbE4/OOnMAdNDar+S5VZg3C
         n9vM5VdVvKXU2FpM2sGzraaoZ/TEjGf4U4apGyh3638L5xkis1s7Sss1B+ylrqPB4LO+
         KkoQ==
X-Gm-Message-State: AOAM53215JyO/5rzN2ryYXRitB9+acLk0+SrZ7qFYHgtzXWbHorI625P
        0RrFcZNXyu2pUMHK+gwNr3Aq4cNfPHd7ew==
X-Google-Smtp-Source: ABdhPJxqYcAE4f74GhnxZqCfl7IH0Q0NHwFYJMnnvoGDekhd1yXnkVadO9ZcYYIYVLN4Q1Xu2W+jpg==
X-Received: by 2002:a05:6e02:1c2d:b0:2cc:4986:3f61 with SMTP id m13-20020a056e021c2d00b002cc49863f61mr219704ilh.246.1651255003845;
        Fri, 29 Apr 2022 10:56:43 -0700 (PDT)
Received: from m1.localdomain ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id o9-20020a02cc29000000b0032b3a78179dsm744082jap.97.2022.04.29.10.56.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Apr 2022 10:56:43 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 04/11] io_uring: ignore ->buf_index if REQ_F_BUFFER_SELECT isn't set
Date:   Fri, 29 Apr 2022 11:56:28 -0600
Message-Id: <20220429175635.230192-5-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220429175635.230192-1-axboe@kernel.dk>
References: <20220429175635.230192-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

There's no point in validity checking buf_index if the request doesn't
have REQ_F_BUFFER_SELECT set, as we will never use it for that case.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index cdb23f9861c5..a570f47e3f76 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3686,10 +3686,6 @@ static struct iovec *__io_import_iovec(int rw, struct io_kiocb *req,
 		return NULL;
 	}
 
-	/* buffer index only valid with fixed read/write, or buffer select  */
-	if (unlikely(req->buf_index && !(req->flags & REQ_F_BUFFER_SELECT)))
-		return ERR_PTR(-EINVAL);
-
 	buf = u64_to_user_ptr(req->rw.addr);
 	sqe_len = req->rw.len;
 
-- 
2.35.1

