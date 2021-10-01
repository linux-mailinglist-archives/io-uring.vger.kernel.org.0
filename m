Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C03D941F2AD
	for <lists+io-uring@lfdr.de>; Fri,  1 Oct 2021 19:07:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231564AbhJARJg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 1 Oct 2021 13:09:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230187AbhJARJg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 1 Oct 2021 13:09:36 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EABD1C061775
        for <io-uring@vger.kernel.org>; Fri,  1 Oct 2021 10:07:51 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id ba1so37211336edb.4
        for <io-uring@vger.kernel.org>; Fri, 01 Oct 2021 10:07:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RtsWZ3Y5bGkp9hmYhaSx9+lLDN139qzZ5zMKgCVZENM=;
        b=UlB4LOEidf93SD2b4oMJx9oT3S1IpCTjeV8nH2lwJloeJkNbrwQ1ApJbrCjrVgWEsj
         0LAkmoKpbRd+Fli3C485Zsawj8z/miZoakRCK7Wws2hVSHQ0w2cVbfS9dztLpSmdrIdT
         qOLxDVfEJo8iVws+cuZf9EnRZ/+unZnbA076U4/QomOLLB16dcQvPdAy/cR1KLVUl6E9
         8PIEW7YB92P4b0T3GfAOzHzGU5u5CFaYNA/hOklno0hzO8floJ8eTkS001HJne0CoQxI
         325UM64wC14r5diT3JC3zEf4MFIsfwt+yjFmw1uWfyHVyQnFXHh/ZWmAE3ZAVgkbbs89
         Rgbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RtsWZ3Y5bGkp9hmYhaSx9+lLDN139qzZ5zMKgCVZENM=;
        b=BXe/nYuQ3pPZF3jwfwbfFISYY1cTbXIyQ30i2DV19zD1/K3nKSUekZPVgrvoiNJWF9
         SevHgUpGRBLKKLWMsQ8B4Tyyi9cdqqakn8bkU4kS4/T7uLzBXmNQqMJ68SWubFbfEBUF
         BVvO65NcucHVGDwJGgKMHDyEU6S7WzRslK0RrRJxu2FMrUNmIR3RWGOIi1bVsBBJBCnc
         Xw9W01YFENUK/mjXiJO6BFHhoVTdkNUBXAeesCFq5e8DUYGWztCLvzS1QgwBN/Kf7zf4
         NAifLfxpgPEHGEk68r6Hodgo2LnolG5T1Ns7AQw4eiFByHBVxpbHEyjDOcXHihGgasKd
         JWvw==
X-Gm-Message-State: AOAM530sh6Q9EUfUOQ+zJUx6kAAzVEJoq0BcmOMIylkdy5zRMWV1K6A4
        422gNmYP/xIpQ9e3zSycm2NYsPJ7LsY=
X-Google-Smtp-Source: ABdhPJx26Q4LeBu2ZIYg2OSBgb2DzfK1LK4GE+aR+UV4PJvivWhULhaUzaTt+Rv9HGmUFN2agE49Ww==
X-Received: by 2002:a17:906:d1d1:: with SMTP id bs17mr7271638ejb.198.1633108070184;
        Fri, 01 Oct 2021 10:07:50 -0700 (PDT)
Received: from localhost.localdomain ([85.255.233.39])
        by smtp.gmail.com with ESMTPSA id y93sm3604480ede.42.2021.10.01.10.07.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Oct 2021 10:07:49 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com
Subject: [PATCH 3/4] io_uring: init opcode in io_init_req()
Date:   Fri,  1 Oct 2021 18:07:02 +0100
Message-Id: <a0f59291fd52da4672c323542fd56fd899e23f8f.1633107393.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <cover.1633107393.git.asml.silence@gmail.com>
References: <cover.1633107393.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Move io_req_prep() call inside of io_init_req(), it simplifies a bit
error handling for callers.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 8d6d8415e89d..ddb23bb2e4b8 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6994,7 +6994,7 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 {
 	struct io_submit_state *state;
 	unsigned int sqe_flags;
-	int personality, ret = 0;
+	int personality;
 
 	/* req is partially pre-initialised, see io_preinit_req() */
 	req->opcode = READ_ONCE(sqe->opcode);
@@ -7055,9 +7055,10 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 		req->file = io_file_get(ctx, req, READ_ONCE(sqe->fd),
 					(sqe_flags & IOSQE_FIXED_FILE));
 		if (unlikely(!req->file))
-			ret = -EBADF;
+			return -EBADF;
 	}
-	return ret;
+
+	return io_req_prep(req, sqe);
 }
 
 static int io_submit_sqe(struct io_ring_ctx *ctx, struct io_kiocb *req,
@@ -7069,7 +7070,6 @@ static int io_submit_sqe(struct io_ring_ctx *ctx, struct io_kiocb *req,
 
 	ret = io_init_req(ctx, req, sqe);
 	if (unlikely(ret)) {
-fail_req:
 		trace_io_uring_req_failed(sqe, ret);
 
 		/* fail even hard links since we don't submit */
@@ -7094,10 +7094,6 @@ static int io_submit_sqe(struct io_ring_ctx *ctx, struct io_kiocb *req,
 			return ret;
 		}
 		req_fail_link_node(req, ret);
-	} else {
-		ret = io_req_prep(req, sqe);
-		if (unlikely(ret))
-			goto fail_req;
 	}
 
 	/* don't need @sqe from now on */
-- 
2.33.0

