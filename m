Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F36414598FA
	for <lists+io-uring@lfdr.de>; Tue, 23 Nov 2021 01:08:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229709AbhKWALq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 22 Nov 2021 19:11:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230411AbhKWALp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 22 Nov 2021 19:11:45 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE841C06173E
        for <io-uring@vger.kernel.org>; Mon, 22 Nov 2021 16:08:37 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id o13so843971wrs.12
        for <io-uring@vger.kernel.org>; Mon, 22 Nov 2021 16:08:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/69qN9p7a5aQPZwbH4a8jbkrwqZIfDEqz/H2P+ZNY3E=;
        b=mKphS4LQYViNbl0Y/dtyBf6pAt3z30jwF53MZpAyLizv7TFZkzXP/65yXSd0zYEOSO
         att4rHE6yopkbjL91O4bvfeaNjAU1J3idYh6Llo/RpGTNL0+9jMBsbXjBh08qopwWC2B
         JlWWKtop1w7lq6VDABjzJNEeviYVqTvQX6zAGkk82r9DR7vh7FsFGKGnPKZ+fyjGd6r+
         eDtSgFR5lwIrnyntRJN9A7cB2l39zsSo00iFt8qopIHLSh3QLGgdwfYCm97VfnNofiM6
         p7WvbW9ACCJcStT8pBxDGlOX2yObbykTyXHhk3WaBvOTvdMKqMPB8XbhlPyYYyS4YJaA
         mORQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/69qN9p7a5aQPZwbH4a8jbkrwqZIfDEqz/H2P+ZNY3E=;
        b=1lp4PTvCIw1kOMoIlghJsnHJ1VxwGGTEBImidyZAfsdqA5zFk7D82tCUolw3uDzyfF
         p43SzLoHXbZD2DdGQRMd+5htIdd21fx2oQlF8sJzjY/8qwOEkIgtF02xwhmJQr2ndHuB
         Xb8QLY7GctB0jsC2l/YvFATb5wvL73A7JAxlEPcDDGWjuD2/ATnzeXK9JEAeIIQ/1YvV
         pWMDYT4iMJqrIiK8tWRzYyVHCuoJNMamIUhaIY2/N1UYzRr1fqwxi+TCe/YA/7W9Ba20
         G0zIEsEbPD5yPWrqEo7b6ZkjFteo/TxfIfUmhsQ8O3qbqIMSIXN9+5j8j5O3o89Tvjb7
         i6VQ==
X-Gm-Message-State: AOAM531RrRpaq8ZwUsxhvKAEwMl942NvYST0v27uO95V2Zsh/pIfYz5J
        53+EB/ZXJtt+lzNTYvgCNHMRzYEuE8Q=
X-Google-Smtp-Source: ABdhPJwOCg8f5W1+6HrAC3jvbeU5iDaDSQoR5Po+cwdo3CTdjVWFY6OkWP9v4GAqWswMNmfUAiNQRg==
X-Received: by 2002:a5d:6447:: with SMTP id d7mr1828774wrw.118.1637626116141;
        Mon, 22 Nov 2021 16:08:36 -0800 (PST)
Received: from 127.0.0.1localhost ([185.69.145.196])
        by smtp.gmail.com with ESMTPSA id r62sm10139409wmr.35.2021.11.22.16.08.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Nov 2021 16:08:35 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH 1/4] io_uring: simplify reissue in kiocb_done
Date:   Tue, 23 Nov 2021 00:07:46 +0000
Message-Id: <667c33484b05b612e9420e1b1d5f4dc46d0ee9ce.1637524285.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <cover.1637524285.git.asml.silence@gmail.com>
References: <cover.1637524285.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Simplify failed resubmission prep in kiocb_done(), it's a bit ugly with
conditional logic and hand handling cflags / select buffers. Instead,
punt to tw and use io_req_task_complete() already handling all the
cases.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index e98e7ce3dc39..e4f3ac35e447 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2948,17 +2948,10 @@ static void kiocb_done(struct kiocb *kiocb, ssize_t ret,
 		if (io_resubmit_prep(req)) {
 			io_req_task_queue_reissue(req);
 		} else {
-			unsigned int cflags = io_put_rw_kbuf(req);
-			struct io_ring_ctx *ctx = req->ctx;
-
 			req_set_fail(req);
-			if (issue_flags & IO_URING_F_UNLOCKED) {
-				mutex_lock(&ctx->uring_lock);
-				__io_req_complete(req, issue_flags, ret, cflags);
-				mutex_unlock(&ctx->uring_lock);
-			} else {
-				__io_req_complete(req, issue_flags, ret, cflags);
-			}
+			req->result = ret;
+			req->io_task_work.func = io_req_task_complete;
+			io_req_task_work_add(req);
 		}
 	}
 }
-- 
2.33.1

