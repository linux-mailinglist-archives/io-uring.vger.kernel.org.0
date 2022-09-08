Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 206575B1CBE
	for <lists+io-uring@lfdr.de>; Thu,  8 Sep 2022 14:22:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231676AbiIHMWv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 8 Sep 2022 08:22:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231719AbiIHMWs (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 8 Sep 2022 08:22:48 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0151E12C4B4
        for <io-uring@vger.kernel.org>; Thu,  8 Sep 2022 05:22:40 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id gh9so15725883ejc.8
        for <io-uring@vger.kernel.org>; Thu, 08 Sep 2022 05:22:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=QtGYKdepH6VIklXqjHVUhOxm0sOXFXaUexJ5gRR/+aQ=;
        b=XTJDQBy0Qar2pFhyrf8mlZV/Q8940Ge0M5sfmws6PD+lHuwA9Y4Mprc130InGMk3Pc
         S3FI6+LvS9Z++Z5rCzoajlBHkbd1f08S51tMm9tpWlHE95eF4q0zVHZsf5RvjFBSCuib
         X/GQTCWaghieoDc2JIkBa1E8d5lMJWBrX/v5XiSOPsb0YCo11NC5qd+hMTjZV4z2AQPq
         ClLjfTjb/y/a4fhw28Dt/gMHa+qLnj/6lg7yn+4DnwBfIYZZ+XV7fk61x9OCCh2+k8X6
         fFGoWplSTBrpbQDFmZgWBXO8RsTWuFW5gKdzroktUFNVH4fq572sevfmDEErZ6wiWbSu
         nm+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=QtGYKdepH6VIklXqjHVUhOxm0sOXFXaUexJ5gRR/+aQ=;
        b=bzchoNnXIZLDYCEP9b256tx8WX/1Kxs0tZCpeKfFF9Dto5J5/+UG09nJTHe1eJUd1C
         QuGbJS2LnEp66D7LKfkw2Kh4e1aA+A7WDIFXoIe8JGwIu95VKiiOz9SDAN/hMxqjCy+W
         brAn7KH2egbm73Ef7ClPy74g2TWhxlKwOc2emnYB8WGRICzd35B6Q/KH+Muov7Uf4I4/
         P/a/TFifzPOz1cE1okK1M+xLznnCYNsfEuq0+4/AEO8ZyfZngoIxxXvJdDpQspigpIOg
         7NUOK46EYWk3tebT6OD76h46hwLtHc9G32066tkRAgIIvD99mXwuExd1RkLUDrNrw+Pb
         ATfQ==
X-Gm-Message-State: ACgBeo0j6XsOpW4G39P3uHx46CkWMsRQ3DC9wyH/bIxsNA/s/aMBLs0S
        841FHzLDnBCDaUsPCm7mGxs+lnYXP2Y=
X-Google-Smtp-Source: AA6agR7LWmK/IPgDPLQLGYSC3VCRyXVMiFcBfRV5ZR09Uvsd+NU8m6O4ufNEPMQkPWZi8Zln466zMQ==
X-Received: by 2002:a17:907:7241:b0:779:2fc:9a40 with SMTP id ds1-20020a170907724100b0077902fc9a40mr101662ejc.173.1662639758775;
        Thu, 08 Sep 2022 05:22:38 -0700 (PDT)
Received: from 127.0.0.1localhost.com ([2620:10d:c092:600::2:cfb9])
        by smtp.gmail.com with ESMTPSA id p9-20020a17090653c900b0074a82932e3bsm1191791ejo.77.2022.09.08.05.22.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Sep 2022 05:22:38 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 5/8] io_uring/net: io_async_msghdr caches for sendzc
Date:   Thu,  8 Sep 2022 13:20:31 +0100
Message-Id: <42fa615b6e0be25f47a685c35d7b5e4f1b03d348.1662639236.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <cover.1662639236.git.asml.silence@gmail.com>
References: <cover.1662639236.git.asml.silence@gmail.com>
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

We already keep io_async_msghdr caches for normal send/recv requests,
use them also for zerocopy send.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/net.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index fa54a35191d7..ff1fed00876f 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -196,10 +196,9 @@ int io_sendzc_prep_async(struct io_kiocb *req)
 
 	if (!zc->addr || req_has_async_data(req))
 		return 0;
-	if (io_alloc_async_data(req))
+	io = io_msg_alloc_async_prep(req);
+	if (!io)
 		return -ENOMEM;
-
-	io = req->async_data;
 	ret = move_addr_to_kernel(zc->addr, zc->addr_len, &io->addr);
 	return ret;
 }
@@ -212,9 +211,9 @@ static int io_setup_async_addr(struct io_kiocb *req,
 
 	if (!addr || req_has_async_data(req))
 		return -EAGAIN;
-	if (io_alloc_async_data(req))
+	io = io_msg_alloc_async(req, issue_flags);
+	if (!io)
 		return -ENOMEM;
-	io = req->async_data;
 	memcpy(&io->addr, addr, sizeof(io->addr));
 	return -EAGAIN;
 }
-- 
2.37.2

