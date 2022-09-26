Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 500465EB5AF
	for <lists+io-uring@lfdr.de>; Tue, 27 Sep 2022 01:24:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231305AbiIZXX6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 26 Sep 2022 19:23:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231332AbiIZXXa (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 26 Sep 2022 19:23:30 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B92375CF0
        for <io-uring@vger.kernel.org>; Mon, 26 Sep 2022 16:21:42 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id o5so5511338wms.1
        for <io-uring@vger.kernel.org>; Mon, 26 Sep 2022 16:21:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=gnOOAPoZ7GOp9P0945PJk9CfgwZn+k9Do3cZbeKmceo=;
        b=GWValW1wRzUMUQsyQh/M4yXejPvhND9Hb2WzuBzgq5FboFJq7IH5Ge5wv2z7LB+zjk
         1DV3Le3n207begFJjyI31zcejkuWUt9rLZ8arB/QSF5rOWMu84ziAzLSvLH26boM5ySe
         d1W9EBWTjjU0DPznK+vHb6wSebuaWLSZ2XxHymfrfIAegPEANKTkOHWvilb6YOm9HLBs
         HrtBnPOrVMXlAcRRKrpLbzN5DPJaQiekN0b5dQeiQv/V3t9BnDo6YeXja9+UKo/yZlxn
         MVZ2pFgHV2/BIJ2PS2z2uGRQZf7G/3Ti34IFwNVqmprpkbPBhh8c0GGuhzJUqdxmzGaD
         DQTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=gnOOAPoZ7GOp9P0945PJk9CfgwZn+k9Do3cZbeKmceo=;
        b=d86VUOCZOzhVJ60CzGcCltGBbaagGKVtP5uI3Tnk9dfGlEfWe6ammIIRVQcL78Wk7j
         dxP+uwVsLecKgnPjcjxKwcTbFmRiYkQg6ylFEwqjOWRpN1EePLcsVvM/YCwI+nRBwcwt
         FzcmjRZ88xqZJzbPnT22hKpinHPWEfChc2v1oraPdbnBL5xbRJUAL5pNSwrPD9r4WnI6
         lieyGCPsK2ZnLMD1mkhEBPk1gH2Y1682sCe1Paud59XLt80sFbZS8hM+AukUjnhpYFbM
         DxzrrBi5WwfnWTkZsjQX9VBOqndBoOW3+cWmQW9bFpVYD70oOGsDn3rQZtw205mtFcEb
         wOUg==
X-Gm-Message-State: ACrzQf3lgdVz480sTf8qXPL3IxRFG+9rjcdgVupiUFo07FIfSVV+xWtt
        2+DNApH66UqYR6xSlOKnzQwm/4VFvw0=
X-Google-Smtp-Source: AMsMyM4yO7rOesFLaIIpW9w5BJGNoHexQzzwZnFSkLOi72BYA7dkEeQsXiE6tScrylcM9d2K7v1F8A==
X-Received: by 2002:a05:600c:3d17:b0:3b4:adc7:976c with SMTP id bh23-20020a05600c3d1700b003b4adc7976cmr620480wmb.108.1664234500254;
        Mon, 26 Sep 2022 16:21:40 -0700 (PDT)
Received: from 127.0.0.1localhost (94.196.228.157.threembb.co.uk. [94.196.228.157])
        by smtp.gmail.com with ESMTPSA id p16-20020adfe610000000b00225239d9265sm90616wrm.74.2022.09.26.16.21.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Sep 2022 16:21:39 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 2/2] io_uring/rw: don't lose short results on io_setup_async_rw()
Date:   Tue, 27 Sep 2022 00:20:29 +0100
Message-Id: <c83f3f4882511ee07c99f27f148e1838cb2d7c07.1664234240.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <cover.1664234240.git.asml.silence@gmail.com>
References: <cover.1664234240.git.asml.silence@gmail.com>
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

If a retry io_setup_async_rw() fails we lose result from the first
io_iter_do_read(), which is a problem mostly for streams/sockets.

Cc: stable@vger.kernel.org
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/rw.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/io_uring/rw.c b/io_uring/rw.c
index c562203d7a67..722c06026701 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -794,10 +794,12 @@ int io_read(struct io_kiocb *req, unsigned int issue_flags)
 	iov_iter_restore(&s->iter, &s->iter_state);
 
 	ret2 = io_setup_async_rw(req, iovec, s, true);
-	if (ret2)
-		return ret2;
-
 	iovec = NULL;
+	if (ret2) {
+		ret = ret > 0 ? ret : ret2;
+		goto done;
+	}
+
 	io = req->async_data;
 	s = &io->s;
 	/*
-- 
2.37.2

