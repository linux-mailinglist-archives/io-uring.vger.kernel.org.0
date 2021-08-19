Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DD8C3F18A2
	for <lists+io-uring@lfdr.de>; Thu, 19 Aug 2021 13:57:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238105AbhHSL5m (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 19 Aug 2021 07:57:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238210AbhHSL5l (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 19 Aug 2021 07:57:41 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9CA1C061756
        for <io-uring@vger.kernel.org>; Thu, 19 Aug 2021 04:57:05 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id k29so8696981wrd.7
        for <io-uring@vger.kernel.org>; Thu, 19 Aug 2021 04:57:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=Oa7vv7NKbfPRT1BkhidZVLj8ICwbNAJII3KY6PWpyIA=;
        b=CwIhv6xFohBLKIPYQ1/0v8ZZbre38jZRxYnytN9ULkpGp0SwAz+yCBBsFkT9bfvmNx
         COVS85CaFPxT6K0FRSJIemvtLvWC6geHH8B+Es4/i7334TqvElZ7flC2XhboMVomvdju
         um49hd4vqPF6bYExWbWFop2MNovdNiT31qyzVDEjpZWYLvFJIqmGYebsfJ3y33+xeb51
         I5LBHtua2DNQwCPE1Z3PyfwMGB6EyrIB+zn1tUNnfj3LjxtDtMmMvHKXi8S436pxn+RD
         VJK1gAntItV+inoJWkvsemwHTnHUPhIQ7OsmjABZCL+M5WvYgcYzIu8EODmQI2yDKTce
         UrVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Oa7vv7NKbfPRT1BkhidZVLj8ICwbNAJII3KY6PWpyIA=;
        b=q2TBmYQAjxSm3+69V0LQUjor59HFlQheMwWa5ukBjG+mNuihOlGWCYu52lVbth9ugN
         mjJAqbn0xlxzpuE/GSv8DCvemcRg5GjQtBnKOPhbDDDQyaJNSNXtipHPfhkqdmfuhGeJ
         LoVcjA8yKCHG2e+x146OaYUHBLL801t2c8Wn6wrYUB5h2ArL5whgRfTk4SNsKeAM5+Ni
         Pl+NsW7Pw6ULJ1Q+mcJiRlWuao9CVgeolvPFGAXbAE6n97IOcV2cFHIbvpipA9+H57wk
         4K2XuWiI+9rIagxZgcK6dFgL0KF/R/8iNzWx2A6YDo6egwxQnCpJ54kSmT2n1qa9cZYu
         cc4g==
X-Gm-Message-State: AOAM530I/sdibWTntUBkh5gn7dySDHGoObIIjxpfzGCOCCgkvL4qBety
        fQ7LDcBwoIwBWFY0pUvE+u8=
X-Google-Smtp-Source: ABdhPJzXrk2Uq6MUpC1tRCx6VMr1abtgQ4rkJMa6qIFKUQ1waYbhdifVeNYD+OWQHtoy+Ds2+Ze0Tg==
X-Received: by 2002:adf:ba01:: with SMTP id o1mr3396115wrg.419.1629374224371;
        Thu, 19 Aug 2021 04:57:04 -0700 (PDT)
Received: from localhost.localdomain ([185.69.145.21])
        by smtp.gmail.com with ESMTPSA id r10sm2700906wrp.28.2021.08.19.04.57.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Aug 2021 04:57:04 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 1/2] io_uring: remove mutex in io_req_task_cancel()
Date:   Thu, 19 Aug 2021 12:56:25 +0100
Message-Id: <4479bb41699ed5d868c7f9a423c2dfb4d68541de.1629374041.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1629374041.git.asml.silence@gmail.com>
References: <cover.1629374041.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_req_complete_failed() only does io_req_complete_post(), which we
don't need to protect by ->uring_lock, so remove mutex_lock / unlock
from there.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 5e99473ad6fc..bdab831a1185 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2111,12 +2111,7 @@ static void io_req_task_work_add(struct io_kiocb *req)
 
 static void io_req_task_cancel(struct io_kiocb *req)
 {
-	struct io_ring_ctx *ctx = req->ctx;
-
-	/* ctx is guaranteed to stay alive while we hold uring_lock */
-	mutex_lock(&ctx->uring_lock);
 	io_req_complete_failed(req, req->result);
-	mutex_unlock(&ctx->uring_lock);
 }
 
 static void io_req_task_submit(struct io_kiocb *req)
-- 
2.32.0

