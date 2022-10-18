Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC1F76032CA
	for <lists+io-uring@lfdr.de>; Tue, 18 Oct 2022 20:49:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230285AbiJRStH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 18 Oct 2022 14:49:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230291AbiJRSs5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 18 Oct 2022 14:48:57 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4589EA0242;
        Tue, 18 Oct 2022 11:48:50 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id d26so34480907eje.10;
        Tue, 18 Oct 2022 11:48:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OEXvp1IreEp3SXV31DiUhQRIjvrLdojheHeDjSM1+mQ=;
        b=StZ853wy/e5RtsJT54EGTUKpdC1tUlgOYlrs3sEGGMffoVhFCAcySZ+zNVfaD1MQTp
         hMR7D7Kq7Xkwj7xChLcHAirblIX5aaAaqxy0G/6wY09rasb4Wyz7bPp1wQmhVBenkfs3
         XaUUSrpMu+p7lybYOS2F+fq432f0WVK60coyn97CguE3CAs29HGOugjHrvxF/A8W/foA
         evsF12c3sbuzYKU+33M7yTxBruThoComQQJs1211x2nevgPNAk6CvOnmOw1ecu6qEER1
         33dhbDf7rIyUZWUKI6TvvvWxR8b8S8I4Ekt328WSeicvjAGCOySDvgplDFdTSIHYEOGB
         dNUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OEXvp1IreEp3SXV31DiUhQRIjvrLdojheHeDjSM1+mQ=;
        b=rEd69rZm96JdZRjEzTiuJU0cq2IEvTSYB/FkH6WI4irV8c43pxo5+DKOLhwryrb9S5
         0TkKESplNyIfm/U4omXALfThSThVt5EQbdhIkjHOgfHsefn9JTX7uWkjjXy/YB7q37SM
         g47aueFhSKrnHl4zXEk00JgqZjwNJ8Saeq21q9a16xlrd5gb2RMQt6B7RFOD5DPwRcju
         eTMlNCQ746UTuKhEwzC0ZET3YWlo96bhccNVfzK3ePNFGlTQtvV4EmdNshLPPKjT2/MA
         jY2Eyh7/HPtKp96rgZDRXMxh/0573Sl0cf+xefMld3+XSi7eAnm/eoq3gFUktb//zZPX
         HMVQ==
X-Gm-Message-State: ACrzQf0WXswtPtC8zGQWolWrabbjJwLwiaTivXRENkJPoLC12lft6WaQ
        fwJpaDaQM2e3r056f3+apB0=
X-Google-Smtp-Source: AMsMyM5Y5ZS6TDv/2mH05016sSTBXkDL48kYZI7q6Xe+foRLWaJOLgSM1up164i2Bm1RjXBT7PL2RQ==
X-Received: by 2002:a17:907:7632:b0:78d:b5ba:87db with SMTP id jy18-20020a170907763200b0078db5ba87dbmr3568466ejc.661.1666118928064;
        Tue, 18 Oct 2022 11:48:48 -0700 (PDT)
Received: from 127.0.0.1localhost (94.197.72.2.threembb.co.uk. [94.197.72.2])
        by smtp.gmail.com with ESMTPSA id j18-20020a17090623f200b0078db18d7972sm7855355ejg.117.2022.10.18.11.48.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Oct 2022 11:48:47 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org
Cc:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [RFC for-next 4/4] io_uring/rw: enable bio caches for IRQ rw
Date:   Tue, 18 Oct 2022 19:47:16 +0100
Message-Id: <11cf38513c45083955d4ee2cedbb46df0a9f6081.1666114003.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <cover.1666114003.git.asml.silence@gmail.com>
References: <cover.1666114003.git.asml.silence@gmail.com>
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
index 100de2626e47..ff609b762742 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -667,6 +667,7 @@ static int io_rw_init_file(struct io_kiocb *req, fmode_t mode)
 	ret = kiocb_set_rw_flags(kiocb, rw->flags);
 	if (unlikely(ret))
 		return ret;
+	kiocb->ki_flags |= IOCB_ALLOC_CACHE;
 
 	/*
 	 * If the file is marked O_NONBLOCK, still allow retry for it if it
@@ -682,7 +683,7 @@ static int io_rw_init_file(struct io_kiocb *req, fmode_t mode)
 			return -EOPNOTSUPP;
 
 		kiocb->private = NULL;
-		kiocb->ki_flags |= IOCB_HIPRI | IOCB_ALLOC_CACHE;
+		kiocb->ki_flags |= IOCB_HIPRI;
 		kiocb->ki_complete = io_complete_rw_iopoll;
 		req->iopoll_completed = 0;
 	} else {
-- 
2.38.0

