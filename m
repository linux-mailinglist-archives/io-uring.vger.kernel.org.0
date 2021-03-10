Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F0F0334BD8
	for <lists+io-uring@lfdr.de>; Wed, 10 Mar 2021 23:45:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231478AbhCJWoo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 10 Mar 2021 17:44:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231964AbhCJWo1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 10 Mar 2021 17:44:27 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06656C061764
        for <io-uring@vger.kernel.org>; Wed, 10 Mar 2021 14:44:27 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id kk2-20020a17090b4a02b02900c777aa746fso8326205pjb.3
        for <io-uring@vger.kernel.org>; Wed, 10 Mar 2021 14:44:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=sKQGvUOJxXPV2ZcUWBnJCp3Wp4QVRYFaqJiu4W/ezJk=;
        b=04Y72nINkSjgEnj7BQ1DGt5fG3JbuHpeVh0h0Pfx1MQT9nkCBwLGFD4S91LfFkeYnh
         QAu194FiSqniX0QkmACjjQo62x3toA9y7W73Tl5LDdMiOJv2zP7L1SMJMbMMkaGY/GcO
         Lb0RfHyBermWqAEypponooDEXr+b9Hrxbk3QKSKh8zmTkMqFuJr3gtqtzRT3LanCmjnu
         yEPOLruhwSwIISYYSh0Z33ByJIvFCW3WXXpYO5hbyouXbF2rNl5pLerFAdOcTi8Uyiur
         64lsQO0KakJpciJTLZ6QNpjqWPnoKrPvuuTP3oW29G61t1GbLQJY9vKOM0qHLkscqGlV
         XKQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sKQGvUOJxXPV2ZcUWBnJCp3Wp4QVRYFaqJiu4W/ezJk=;
        b=gJwyb0Lvh1ZujFB56JxjgABX6dTpdRgSIJP6eTqKRVhsCsREb7cA8KKk6Fy0bs+d3X
         O2H8Fp5t2HyQZe4i0ieiwUAjeszqnRjgL3OfShLVkiVTivUCUnPj/UPf4DUwXkiTuHlk
         x0LHTsyJ9n+7TTCgD3K1AGlUZWNpGDAFqatVVgMtJeSs3YGiEgbb0XufcSp7mYhV01mf
         ptN8izFFRMqA7Z0xSrf/jAq4mpAcVPcvd4Al4kg/U/MD+K+xCg5RMj+c5ox+4Ig2R1b8
         X/r3zwdeotGQkwMyb691rrlSV5Hllnq0mFEW2xoVo5GnAI24X7upJ/PQ3EM1Go7nX3O7
         ArHQ==
X-Gm-Message-State: AOAM533CPmnSpWUHmbK2HROYUY3/styX5jW4eeJHq9+Fi/qkNWj0heGr
        RaqV37w917UCdCM/hjuWsnKa2VIuWonijA==
X-Google-Smtp-Source: ABdhPJwQBMabPNcqF8mz0bq9q73bRB0NriQy1m+9kckpehVa0I79BV0qrWrJ2RqZbU2F4I5RS9gTtQ==
X-Received: by 2002:a17:90b:903:: with SMTP id bo3mr5897162pjb.198.1615416266379;
        Wed, 10 Mar 2021 14:44:26 -0800 (PST)
Received: from localhost.localdomain ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id j23sm475783pfn.94.2021.03.10.14.44.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Mar 2021 14:44:26 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 22/27] io_uring: move all io_kiocb init early in io_init_req()
Date:   Wed, 10 Mar 2021 15:43:53 -0700
Message-Id: <20210310224358.1494503-23-axboe@kernel.dk>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210310224358.1494503-1-axboe@kernel.dk>
References: <20210310224358.1494503-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

If we hit an error path in the function, make sure that the io_kiocb is
fully initialized at that point so that freeing the request always sees
a valid state.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index f7153483a3ac..0f18e4a7bd08 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6327,6 +6327,9 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 	refcount_set(&req->refs, 2);
 	req->task = current;
 	req->result = 0;
+	req->work.list.next = NULL;
+	req->work.creds = NULL;
+	req->work.flags = 0;
 
 	/* enforce forwards compatibility on users */
 	if (unlikely(sqe_flags & ~SQE_VALID_FLAGS)) {
@@ -6344,17 +6347,13 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 	    !io_op_defs[req->opcode].buffer_select)
 		return -EOPNOTSUPP;
 
-	req->work.list.next = NULL;
 	personality = READ_ONCE(sqe->personality);
 	if (personality) {
 		req->work.creds = xa_load(&ctx->personalities, personality);
 		if (!req->work.creds)
 			return -EINVAL;
 		get_cred(req->work.creds);
-	} else {
-		req->work.creds = NULL;
 	}
-	req->work.flags = 0;
 	state = &ctx->submit_state;
 
 	/*
-- 
2.30.2

