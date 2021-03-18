Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 349CD340506
	for <lists+io-uring@lfdr.de>; Thu, 18 Mar 2021 12:59:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229747AbhCRL6w (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 18 Mar 2021 07:58:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229745AbhCRL6n (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 18 Mar 2021 07:58:43 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 643B3C06174A
        for <io-uring@vger.kernel.org>; Thu, 18 Mar 2021 04:58:43 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id t9so5211203wrn.11
        for <io-uring@vger.kernel.org>; Thu, 18 Mar 2021 04:58:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HEVa+LFBSyizvjoG7dqOngE69ycWWFmDeci7hkBX9sg=;
        b=mjNrXQjqlYcPl06hlCDxIoojTlN4hehp9iA8ohjSA5hN7+vQNEddeHyd50Begrtv18
         HyFPwXhnZwZfYr/ofAOC1Yz5gmZVQK8nO7q7xTcvGw2mFhhhmtoz8OZ+6C5pnXHOSmwD
         uJO1IBMlg+d8V0Ee9R0XvgyahXTItHEHPBuO28bK1jskAifUdvo3Yl4z6Dfv4FjQtDGb
         ZjKezull/0YiRZSvp44pIUr0LU9MlC1LAYaGrTdMlQOKlQxC/ortDoIpyZN9oTRJ3Vra
         C4PaskVmsMDLI5NmaGDfkqDXEKxQoc7gCw99+eHctS1y76yYGIYBbxVjPp5i9Rl+GhfB
         Wa1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HEVa+LFBSyizvjoG7dqOngE69ycWWFmDeci7hkBX9sg=;
        b=dPBaRM5M3Go5oojNlmgW/Vnt10dQs9ctVyBHJDY4TshZotQDBWYpeDNqhRMzHz5UQN
         SoL3jgxUvq/JblUG6NqvMBmDsYiVS2RWQmYeSYUIalW+UC/FNmEBpRHpNdOMNbqkZhRQ
         ZlSKU99VxdRuyF9X4vUYNJy7783ByUv2E8jJStGAJ9iBaAfXcAlQA/SyOobaFiAd5K+8
         wv5taX7g/3F2tAW3K43LniZXrt2+8l/mHWp59zCGEQWmjF5kl5CSXlTX14UnHFXg71yP
         8m3Szv1s6V1Y/OueBxOWYrKEraM1CRcg6375KSx4yJM2moy88j8jF5LXBTJQlfWSrGVZ
         w+9g==
X-Gm-Message-State: AOAM532mjwK4aQy0VctxWoSVKDOZQJeHwte6q1T5p4vpwCvJ3ophn6Vl
        pTyGi1oQ8DkjrXtTrP4W2OvOf52uQOdc3Q==
X-Google-Smtp-Source: ABdhPJxluTYPxCbNX//U7iHL+mbGHYPfKJ1xNwTJ3IWKb8CKze6qXriy8bioYSeIlDPaknX1dblEXg==
X-Received: by 2002:adf:a1d8:: with SMTP id v24mr9091056wrv.378.1616068722165;
        Thu, 18 Mar 2021 04:58:42 -0700 (PDT)
Received: from localhost.localdomain ([185.69.144.156])
        by smtp.gmail.com with ESMTPSA id i11sm2714452wro.53.2021.03.18.04.58.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Mar 2021 04:58:41 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 1/1] io_uring: don't leak creds on SQO attach error
Date:   Thu, 18 Mar 2021 11:54:35 +0000
Message-Id: <7c7e783bbc4b785825b159d4172527de0014ebc2.1616066965.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Attaching to already dead/dying SQPOLL task is disallowed in
io_sq_offload_create(), but cleanup is hand coded by calling
io_put_sq_data()/etc., that miss to put ctx->sq_creds.

Defer everything to error-path io_sq_thread_finish(), adding
ctx->sqd_list in the error case as well as finish will handle it.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index dcdb6e83f1a2..f258264a2e89 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7904,22 +7904,17 @@ static int io_sq_offload_create(struct io_ring_ctx *ctx,
 
 		ret = 0;
 		io_sq_thread_park(sqd);
+		list_add(&ctx->sqd_list, &sqd->ctx_list);
+		io_sqd_update_thread_idle(sqd);
 		/* don't attach to a dying SQPOLL thread, would be racy */
-		if (attached && !sqd->thread) {
+		if (attached && !sqd->thread)
 			ret = -ENXIO;
-		} else {
-			list_add(&ctx->sqd_list, &sqd->ctx_list);
-			io_sqd_update_thread_idle(sqd);
-		}
 		io_sq_thread_unpark(sqd);
 
-		if (ret < 0) {
-			io_put_sq_data(sqd);
-			ctx->sq_data = NULL;
-			return ret;
-		} else if (attached) {
+		if (ret < 0)
+			goto err;
+		if (attached)
 			return 0;
-		}
 
 		if (p->flags & IORING_SETUP_SQ_AFF) {
 			int cpu = p->sq_thread_cpu;
-- 
2.24.0

