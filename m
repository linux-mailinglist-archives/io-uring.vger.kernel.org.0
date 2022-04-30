Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DE3A51608D
	for <lists+io-uring@lfdr.de>; Sat, 30 Apr 2022 22:54:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245095AbiD3Uzj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 30 Apr 2022 16:55:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245134AbiD3Uxx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 30 Apr 2022 16:53:53 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF2E66416
        for <io-uring@vger.kernel.org>; Sat, 30 Apr 2022 13:50:30 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id cq17-20020a17090af99100b001dc0386cd8fso4575291pjb.5
        for <io-uring@vger.kernel.org>; Sat, 30 Apr 2022 13:50:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kvQp3PzEwPyo0t/2MRUbVmXPNrATyUTeiveDQI37c7k=;
        b=EFzWRJFed1aVimkqNxt6T3LTJEEfKYR2Pq2TcX433MxsnEr7vp/eKyao9h8vFGC8Nw
         e+qEwo+Iw21J3XsVFbs9TgiGU+GhSgB6dB0ANXGghob+nnPwsnKF/l+z98rr93hfOoup
         cvLU2MOQ7ej/mBnfVq2f0X5ubC/o+WK8x/w2ipBO/tr0bjNaEY3zujoHOiBJ4VJk2h0t
         ZyfmBWdjeS2Raa/l3DsCrReEv9lhZv6VJji3CAgywy3sL9wYqG9oCcbcP+Y22Wkr5dH0
         iOnQGa4GZWx3Gm36exdhOfYv92nvD7vIulxN8XRKiC1KkvZV2wkX9XgVvIo4lp21akS3
         1/Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kvQp3PzEwPyo0t/2MRUbVmXPNrATyUTeiveDQI37c7k=;
        b=T39ft2jK5Fxtkx2LDl647Xu29AlkxRCi8wtPOsCMEf19sKRFLKB2alYc3+bmXBCSXQ
         f8n5d8Tp4KMm5gdY1Vu7pdfJxGU5iCQ6Nev23CCt8zf2cFBZcqjV2YqOXH6Bs/km/rRt
         NMTyfWnx6LV73nCtUFNT8YpM35RMOaSmYHCXHuekE92SG8TthxWto/3ZKUsFYujQ6mAD
         C58urtCgK0lMdjPcjpQc5CFv8G+kjW2Ju88dxC8s3IiHBuWcI+CnTuX3/QteTKgIoYwn
         ECvXcHGtDQ8Nw+LmpJ/yZ/XWxSVpLwCIC1rrhdcWg8qx05IcRPf6n7MrdskCjVt3m9GN
         t3mQ==
X-Gm-Message-State: AOAM532DMG0+G7fd9Qz1sqD//xWK7h6raoU6bjBNswIgCjKOQKQJNDqB
        oJtWLlHV1aveKSIYchfXB4BpbGlklRgTaRRh
X-Google-Smtp-Source: ABdhPJx4A+T+KDOYKLWvGlf4cqAsfL/mWuXeYtdN5thu928V/oZ+ysuA1V8r8tVj9Vhr2acszYMcfQ==
X-Received: by 2002:a17:90a:fc8a:b0:1d8:ace3:70bc with SMTP id ci10-20020a17090afc8a00b001d8ace370bcmr10571084pjb.37.1651351830157;
        Sat, 30 Apr 2022 13:50:30 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id t13-20020a17090340cd00b0015e8d4eb1c4sm1854066pld.14.2022.04.30.13.50.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 Apr 2022 13:50:29 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 04/12] io_uring: ignore ->buf_index if REQ_F_BUFFER_SELECT isn't set
Date:   Sat, 30 Apr 2022 14:50:14 -0600
Message-Id: <20220430205022.324902-5-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220430205022.324902-1-axboe@kernel.dk>
References: <20220430205022.324902-1-axboe@kernel.dk>
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

