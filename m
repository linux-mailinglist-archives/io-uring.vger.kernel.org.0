Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A6E911F20A
	for <lists+io-uring@lfdr.de>; Sat, 14 Dec 2019 15:32:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725900AbfLNOc0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 14 Dec 2019 09:32:26 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:38839 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725872AbfLNOc0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 14 Dec 2019 09:32:26 -0500
Received: by mail-lj1-f193.google.com with SMTP id k8so1916641ljh.5;
        Sat, 14 Dec 2019 06:32:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=Eh8ihC6qfc/wJON6akO+nDoCfJM/SJL9lZfSseHNz9M=;
        b=QtDQUYh5xX4natfZkxU9TAw/+BANCFiRtYYhNQvA6WKmR12vI7iJWark1MmzbAXfHJ
         /wgeMkCUHku60elPojerq7WBLvoiCp30SMJYfRoOrRiGEuZBhwmwPb+CbXO0rxFNon3k
         rn8ZiTYjfFkVqq7lUQzLx3ess07wapMC3gbeX08VLYxa9askzmLSM8zVLNOU9NOy1/DN
         iMPZUyI89wEdllwaKj85UfsEquwiI+82BsVinT1WsDMG/4jzqzxFdUhuhbryaOYmuI1c
         nhXZxCuxySWigFeMbYrPJdrNb13EjFnz11y5MGorlLOqGb5ENuokNNhU7tX5DrZ5GqhW
         zKhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Eh8ihC6qfc/wJON6akO+nDoCfJM/SJL9lZfSseHNz9M=;
        b=YdP97L4tidmC2hbJ1xVPc+Ee5/wE1AWWv7T0iTOjSJc5FnHvxcEfij6MGlq3Anh4rX
         N0yelBJ7lK1ToJlKTXlm8hJR/bOeQvEInLVwe+6wQwO8tBdxsQou+oZX9KywmVAQMSZ/
         HdASTnnKEQTmXjQiXf9qNrj+mMq52r895aq/ffC7TkDOcCk/k0sP6vcmXnGX58eICRNt
         hIdi9RjCfn4OfoC2E1kt1froKjTfCOm1fod2w+7wipaEDYcDOTbJNzZz/2UQwl1rKRLf
         fZj+CtKxakwJQBk0TN/y66Rly3uKtT/L/QufQXKDWc5gHNEKlRKSqoOTXBvp+1agKpBp
         pdHA==
X-Gm-Message-State: APjAAAWpn8w94aS3RAt+f7JoE6QeGRwNdKOSre7/05EGMOHDgQq1VLya
        5bGN4Unso1ESbWq/qk/bNXqm4A0WuvE=
X-Google-Smtp-Source: APXvYqwkvAS1wgVDtwOqr56+ZWG1h7uv/J2tmU8uZ84jHXKNG1hXj9U8Py+/XDxHePhLgBrw3RXc0g==
X-Received: by 2002:a2e:9705:: with SMTP id r5mr13321066lji.114.1576333944244;
        Sat, 14 Dec 2019 06:32:24 -0800 (PST)
Received: from localhost.localdomain ([212.122.72.247])
        by smtp.gmail.com with ESMTPSA id f11sm6873066lfa.9.2019.12.14.06.32.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Dec 2019 06:32:23 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] io_uring: don't wait when under-submitting
Date:   Sat, 14 Dec 2019 17:31:57 +0300
Message-Id: <6256169d519f72fe592e70be47a04aa0e9c3b9a1.1576333754.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <5caa38be87f069eb4cc921d58ee1a98ff5d53978.1576223348.git.asml.silence@gmail.com>
References: <5caa38be87f069eb4cc921d58ee1a98ff5d53978.1576223348.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

There is no reliable way to submit and wait in a single syscall, as
io_submit_sqes() may under-consume sqes (in case of an early error).
Then it will wait for not-yet-submitted requests, deadlocking the user
in most cases.

Don't wait/poll if can't submit all sqes, and return -EAGAIN

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---

v2: cap min_complete if submitted partially (Jens Axboe)

 fs/io_uring.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index c2f66e30a812..4c281f382bec 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3526,11 +3526,8 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr,
 		unsigned int sqe_flags;
 
 		req = io_get_req(ctx, statep);
-		if (unlikely(!req)) {
-			if (!submitted)
-				submitted = -EAGAIN;
+		if (unlikely(!req))
 			break;
-		}
 		if (!io_get_sqring(ctx, req)) {
 			__io_free_req(req);
 			break;
@@ -4910,6 +4907,14 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 		submitted = io_submit_sqes(ctx, to_submit, f.file, fd,
 					   &cur_mm, false);
 		mutex_unlock(&ctx->uring_lock);
+
+		if (submitted != to_submit) {
+			if (!submitted) {
+				submitted = -EAGAIN;
+				goto done;
+			}
+			min_complete = min(min_complete, (u32)submitted);
+		}
 	}
 	if (flags & IORING_ENTER_GETEVENTS) {
 		unsigned nr_events = 0;
@@ -4922,7 +4927,7 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 			ret = io_cqring_wait(ctx, min_complete, sig, sigsz);
 		}
 	}
-
+done:
 	percpu_ref_put(&ctx->refs);
 out_fput:
 	fdput(f);
-- 
2.24.0

