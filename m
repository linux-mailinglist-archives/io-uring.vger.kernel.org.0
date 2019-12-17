Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E05FD1235AD
	for <lists+io-uring@lfdr.de>; Tue, 17 Dec 2019 20:28:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728047AbfLQT1q (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 17 Dec 2019 14:27:46 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:42771 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727402AbfLQT1g (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 17 Dec 2019 14:27:36 -0500
Received: by mail-wr1-f67.google.com with SMTP id q6so12539002wro.9;
        Tue, 17 Dec 2019 11:27:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=w8z6Z+q5AMgohv9HEXOzFkf7StlaTie6vN3wWqRf/BE=;
        b=MUbpjkpZZL/HXRE99eYO1MJI+SH72A/qUyCkbUHxZruUaMt9qT4Pbeypu/veK8IXSp
         4JuUcQoVnKm3emXQ0ZYAhM1WvhLArkv585TgfRgm//n15eYZ3vkJBoQQ+RWz0xMheiqi
         kMsfEQM8SC1tW0xMeFjmhyBA4ZfcjpoECLqlVttc3Mb7+fY3uvmQEnL9lVuLpOWxFDxm
         /Gb0Y1/UCfLk6/lnzAaz7CQmAsS09FouK0lIGiCsxaw9tAVS7K8mBSfsuleQlGwNfvqX
         j6bC1JWY1MLlvRQUKz0A49pFrT3sKmtIPacsTDUTWYGW+d7sl1vXZ8gti/U+pTn22cIk
         rtBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=w8z6Z+q5AMgohv9HEXOzFkf7StlaTie6vN3wWqRf/BE=;
        b=hczmZNHHsMLTv+bXWMiLyMIcMgeIwXeIrf3GljTwZ+2Q4kbwK3+E/F/XAlips9h1xD
         kYSYv+vl+hYjUA9EKfNskEfRHFolUXOucEp8bS433pDPLgHt/vEsZxXNX5x0i9JXXeSn
         KGkplELum0sc7lfiBAjz9LDD4wgLXmk9FDNMD/ayXEQeoBFFKBdyK6AZ/9ItuN1ZtySD
         iDPyXC1nS2X7F7+bvs7GMtq4afhPBYomssABpuqYpPYpzbbeWWC/HnUaCL1eaA3Ca3e/
         dzFvGHNcsrJILMYbiXU8eqBtIbsAr01MzJ7B7vURv1R9n3i3eTJYoX+oTdTZDjTmhnqc
         OoSw==
X-Gm-Message-State: APjAAAVT7sAw40095qvUbcSglXvkcbyuXamgDYUlKWgNDPQeqjuFXhBA
        nTFy8etn+xhRTLxmaIHQFfymuExl
X-Google-Smtp-Source: APXvYqxcMmsBKxF7ZZah0FsdQzbYmDGmyqLjwd+qLGAbDj1f0nzxeLuH98h1CP61XhGEiaf9SXIX6w==
X-Received: by 2002:a5d:4c85:: with SMTP id z5mr37787660wrs.42.1576610855010;
        Tue, 17 Dec 2019 11:27:35 -0800 (PST)
Received: from localhost.localdomain ([109.126.149.134])
        by smtp.gmail.com with ESMTPSA id w13sm26711822wru.38.2019.12.17.11.27.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Dec 2019 11:27:34 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] io_uring: move trace_submit_sqe into submit_sqe
Date:   Tue, 17 Dec 2019 22:26:57 +0300
Message-Id: <ad4921dbe500cab48e81e62fc648c526a3e7f21b.1576610536.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1576610536.git.asml.silence@gmail.com>
References: <cover.1576610536.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

For better locality, call trace_io_uring_submit_sqe() from submit_sqe()
rather than io_submit_sqes(). No functional change.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index e8ce224dc82c..ee461bcd3121 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3375,7 +3375,8 @@ static bool io_submit_sqe(struct io_kiocb *req, struct io_submit_state *state,
 	struct io_ring_ctx *ctx = req->ctx;
 	int ret;
 
-	req->user_data = req->sqe->user_data;
+	req->user_data = READ_ONCE(req->sqe->user_data);
+	trace_io_uring_submit_sqe(ctx, req->user_data, true, req->in_async);
 
 	/* enforce forwards compatibility on users */
 	if (unlikely(req->sqe->flags & ~SQE_VALID_FLAGS)) {
@@ -3569,8 +3570,6 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr,
 		req->has_user = *mm != NULL;
 		req->in_async = async;
 		req->needs_fixed_file = async;
-		trace_io_uring_submit_sqe(ctx, req->sqe->user_data,
-					  true, async);
 		if (!io_submit_sqe(req, statep, &link))
 			break;
 		/*
-- 
2.24.0

