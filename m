Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83D7F607519
	for <lists+io-uring@lfdr.de>; Fri, 21 Oct 2022 12:36:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229744AbiJUKgc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 21 Oct 2022 06:36:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230000AbiJUKg3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 21 Oct 2022 06:36:29 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3532254741;
        Fri, 21 Oct 2022 03:36:19 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id l16-20020a05600c4f1000b003c6c0d2a445so1676156wmq.4;
        Fri, 21 Oct 2022 03:36:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pkARs+3t3d0DBXZp/1mvegLMP5wKNB5zcgGJobQgxns=;
        b=OOyVh9Bkdok2YYySU1BPYbs3ZfK2bhDyQlOqYH/DTJyKwDGyhLgS2KlUHR0rY64LkJ
         Lh/fWnbnGDhixFe10hCRVFGasAEi6y/icxbTRA8KMwHe1OIQ9XRSpU6S3zG6JNyUQ7oL
         1JbYWn9mvKsMSqcErnkqoWBCgWcVxwcfHyr16tKw978fI8FV/ZOYlgwLiZ3WVqB5w2sF
         FNgStqTS0b0BTMnaTHLG1hUYERaB3A/r9mVqRJjfvZzFydzrfCgggknbhyCen0a1dlBJ
         SeIcBpXaoEgjP2xyJFOjB4cYrrs7HNfnR56npfYCwYZVYaGsqm0V1Iid8tGolN9ITmi3
         DDIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pkARs+3t3d0DBXZp/1mvegLMP5wKNB5zcgGJobQgxns=;
        b=zgQpD5vRyFerOdYvXDc93zFMAVCxbgKoFeStj0zWi6sMFpBzUFRNU1vr2yxVhTjCYi
         cv5OvsrVRHtIe4YqeHc7gEI9n2llk0+2Ov6HdnBcCx1edj2gddUUu8nwR5OOasvBNEFE
         qNS2BCl/iB3LKoP2UqouoNVXzOhd4aZfGqkyOmvJmLS2NTE1TkeLXxiYHCnBeIbcB1hT
         PzO0qzjpRV2RXdfcCtgHAKeMP1luMPpluTAFDBvtMDVUN7xjeDi0OQVgekGtmy1/lx3Z
         Djl18R5ytWOcCiRHKrHZN/oAwCe37IBivdMqLSJ9A+DlUjf6W+QhfshM/QVME5N10Fdy
         fCqQ==
X-Gm-Message-State: ACrzQf17zn0WKpOIDuWAv48Ol1Yo8IllSPRsr7JxiNYdik/JBcg7O+wM
        ZaVxtxB3PXVDd85yyHVFiDw=
X-Google-Smtp-Source: AMsMyM5GYP7Uu6E80ioSuAGCTMwzwjcEEpPM8QIZdlbNnCuL08gFL0jSnkODDQk6Ycea3cXGX1Gyrw==
X-Received: by 2002:a05:600c:1c8f:b0:3c6:d732:9d6 with SMTP id k15-20020a05600c1c8f00b003c6d73209d6mr31579587wms.23.1666348578014;
        Fri, 21 Oct 2022 03:36:18 -0700 (PDT)
Received: from 127.0.0.1localhost.com ([2620:10d:c092:600::2:f27e])
        by smtp.gmail.com with ESMTPSA id e14-20020a5d65ce000000b0022abcc1e3cesm18544759wrw.116.2022.10.21.03.36.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Oct 2022 03:36:17 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org
Cc:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH for-next v3 3/3] io_uring/rw: enable bio caches for IRQ rw
Date:   Fri, 21 Oct 2022 11:34:07 +0100
Message-Id: <aab3521d49fd6c1ff6ea194c9e63d05565efc103.1666347703.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <cover.1666347703.git.asml.silence@gmail.com>
References: <cover.1666347703.git.asml.silence@gmail.com>
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

Now we can use IOCB_ALLOC_CACHE not only for iopoll'ed reads/write but
also for normal IRQ driven I/O.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/rw.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/io_uring/rw.c b/io_uring/rw.c
index a25cd44cd415..009ed489cfa0 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -647,6 +647,7 @@ static int io_rw_init_file(struct io_kiocb *req, fmode_t mode)
 	ret = kiocb_set_rw_flags(kiocb, rw->flags);
 	if (unlikely(ret))
 		return ret;
+	kiocb->ki_flags |= IOCB_ALLOC_CACHE;
 
 	/*
 	 * If the file is marked O_NONBLOCK, still allow retry for it if it
@@ -662,7 +663,7 @@ static int io_rw_init_file(struct io_kiocb *req, fmode_t mode)
 			return -EOPNOTSUPP;
 
 		kiocb->private = NULL;
-		kiocb->ki_flags |= IOCB_HIPRI | IOCB_ALLOC_CACHE;
+		kiocb->ki_flags |= IOCB_HIPRI;
 		kiocb->ki_complete = io_complete_rw_iopoll;
 		req->iopoll_completed = 0;
 	} else {
-- 
2.38.0

