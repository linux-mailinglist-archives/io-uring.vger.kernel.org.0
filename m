Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E16401E291F
	for <lists+io-uring@lfdr.de>; Tue, 26 May 2020 19:38:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389359AbgEZRgF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 26 May 2020 13:36:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389243AbgEZRfp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 26 May 2020 13:35:45 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49623C03E96D;
        Tue, 26 May 2020 10:35:45 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id nr22so8370588ejb.6;
        Tue, 26 May 2020 10:35:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=cF/H22IrH4Q++fp1tOhrxsdESk3Jt5D36vD3e1cvXpU=;
        b=Psm6/u9JyWiod1LQIXrR0p6geR/OTP/AXtstHIqJ2z5f4vmvyHd8/hyNWBC1LQpCWk
         eMuyrvCGP4XwfEymacF1sxMOGa6ckZOHvjAdEtnQVRUojgj57TDZ5Ibbizufk2jOoOKU
         nboqv2csyoPVN21/GJYoKRlE+M03MyBi6jT4IfjbYHR4QKhsHNYkojDWpU9L0goJbn4G
         530wcFy+P31pZBLHwSmBaG56Uc2lia+61IKvFurGtcFusOxFDsQaWkwkSak0gcxnz0yV
         uqRKQWRtA0ok3Po5baAFT3YSVDbXQyirfeVXbBcBWG4o4F/uX0mD6nPg1Eyolv5tfhWD
         RFRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cF/H22IrH4Q++fp1tOhrxsdESk3Jt5D36vD3e1cvXpU=;
        b=cNKKT/KrghBMKubsxyNLWcT/CnFp+7yYYrwTHvtNMQhPEfenKsC1niV2FZTeYO54Qm
         S8tgKHdkWRiME3VslhmrTghh8RFstNKSXhitmUsxmpbgDRW7SSon+3lhAEactZZ+60dm
         LNjbxI2dEVDBrEQa/SQNxoDIOBlQj/DyTwaaQz37xB+YA5xS9SWpPkbQwKqAxzzgbzDm
         oqyWmabphJqK1ugyKfBfQ1bxEAxpZPY/MRM5jXdE976awkyBqdI84SK0TDqi3os3CNoU
         /KmpGbWOgZC5ygwxDzCq5x2Kzij78BFtvs4fKTaq3UY26TZbSW4vA/NJvsUJKIY86MQE
         Xsmg==
X-Gm-Message-State: AOAM532PXnGUAYZN5yNbYPPzdSVX+rtQ09qYIqNFRjbfW3V6pff7zadv
        BwiGz7Tgy6H4P8q3HPpsspU=
X-Google-Smtp-Source: ABdhPJytD61Yw291LkD8z776m83gt45LaQp113EgOfSPIqZRJ+7XU7Du+iRwX5pYRp6NKP6f3LdWfw==
X-Received: by 2002:a17:906:944e:: with SMTP id z14mr2051658ejx.86.1590514543968;
        Tue, 26 May 2020 10:35:43 -0700 (PDT)
Received: from localhost.localdomain ([5.100.193.151])
        by smtp.gmail.com with ESMTPSA id bz8sm391326ejc.94.2020.05.26.10.35.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 May 2020 10:35:43 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/6] io_uring: simplify io_timeout locking
Date:   Tue, 26 May 2020 20:34:03 +0300
Message-Id: <a34d6960cbd39aed1361b7cfd0a606acddfec193.1590513806.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1590513806.git.asml.silence@gmail.com>
References: <cover.1590513806.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Move spin_lock_irq() earlier to have only 1 call site of it in
io_timeout(). It makes the flow easier.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 42b5603ee410..e30fc17dd268 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4845,6 +4845,7 @@ static int io_timeout(struct io_kiocb *req)
 	u32 seq = req->sequence;
 
 	data = &req->io->timeout;
+	spin_lock_irq(&ctx->completion_lock);
 
 	/*
 	 * sqe->off holds how many events that need to occur for this
@@ -4853,7 +4854,6 @@ static int io_timeout(struct io_kiocb *req)
 	 */
 	if (!count) {
 		req->flags |= REQ_F_TIMEOUT_NOSEQ;
-		spin_lock_irq(&ctx->completion_lock);
 		entry = ctx->timeout_list.prev;
 		goto add;
 	}
@@ -4864,7 +4864,6 @@ static int io_timeout(struct io_kiocb *req)
 	 * Insertion sort, ensuring the first entry in the list is always
 	 * the one we need first.
 	 */
-	spin_lock_irq(&ctx->completion_lock);
 	list_for_each_prev(entry, &ctx->timeout_list) {
 		struct io_kiocb *nxt = list_entry(entry, struct io_kiocb, list);
 		unsigned nxt_seq;
-- 
2.24.0

