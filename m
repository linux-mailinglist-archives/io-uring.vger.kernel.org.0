Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BDE2B168979
	for <lists+io-uring@lfdr.de>; Fri, 21 Feb 2020 22:46:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726683AbgBUVqN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 21 Feb 2020 16:46:13 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:36275 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728624AbgBUVqN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 21 Feb 2020 16:46:13 -0500
Received: by mail-pl1-f196.google.com with SMTP id a6so1428194plm.3
        for <io-uring@vger.kernel.org>; Fri, 21 Feb 2020 13:46:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lzL/t7SD6s/z2qKnEvemgs7cT7YC6VyVexeUGW+peZs=;
        b=gCuVY6O1ZaLb/XOepsyJMoUMlZI/Uospuiz8txm8EpQIIZDQQXaOv/Xl+fntjzc1DW
         2jGL0Cfq2a18il7gflY+NtQdcg5e6dE/jBz2ZkuVPy9EVaTp1ERyl47+u6z2Gn9Li9Sm
         8+HdLsG9dTU1WD/WryE6OExmi1Dsg5CT5h05dH22otsxf/9f8z6+XP4UyuqQ0ERNLPS6
         uNqzI70QYfBmraYaQtwb8gMquBxMPjm20ti8zTKJQxLnuDG0RSjiJvSNwkiPF/4pxXx1
         btg+j4mFKyQzMTa9bV80JuVNIuWr4oqy0GrKJRHcuKwTMF6Wy6DPmidS9VD7Jj95IsZc
         TU6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lzL/t7SD6s/z2qKnEvemgs7cT7YC6VyVexeUGW+peZs=;
        b=OASAy7XWWo0g+tO7O11hQAPfRKyGQdyV5pLREWFcAfVHNjKIpOgX7w0lgekJ7CTolO
         ez45vJ3SNZeNLZy0EiPltZ1Guq14a8VyxDhJbIoIPj6VLuxfVqjibKJCA3edhmg13yVl
         2ZRue7cl+GDq6y2OihKj+dwqhct9E1P924EpPFAnIXmg6X8IfDK4juKb6T1A8ZeGIwrL
         n4EMvZfxjbVIU4gPE1+2sofeCvxryY9IlW2+fSWOB6KmxZm4+ntMojAoV5bV7LEEdvNK
         JlRl+TlkpGP2y7jjJHaZ95GwIXB/56Z26LxrPuSyLrDjRVmRKco1jMG4IYcjOhbhOqyF
         cocw==
X-Gm-Message-State: APjAAAVklEmovEmSfR4Pg8c5ar2MPXhp7X/LoVzrjgMU1VR6BOYXUjXq
        uMrxx6kVlcK6eUy9vvDbrqd/SRVOvEY=
X-Google-Smtp-Source: APXvYqxzNIf/aaY5iC0CLCaLTd7kFWX7xR1MTNIUNbtOtVnYHx9lCkzP3hHCQorOWgBbSJcj5x3FXQ==
X-Received: by 2002:a17:90a:cb0f:: with SMTP id z15mr5394375pjt.67.1582321571063;
        Fri, 21 Feb 2020 13:46:11 -0800 (PST)
Received: from x1.localdomain ([2605:e000:100e:8c61:91ff:e31e:f68d:32a9])
        by smtp.gmail.com with ESMTPSA id a22sm4043312pfk.108.2020.02.21.13.46.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Feb 2020 13:46:10 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     glauber@scylladb.com, peterz@infradead.org, asml.silence@gmail.com,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/7] io_uring: consider any io_read/write -EAGAIN as final
Date:   Fri, 21 Feb 2020 14:46:00 -0700
Message-Id: <20200221214606.12533-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221214606.12533-1-axboe@kernel.dk>
References: <20200221214606.12533-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

If the -EAGAIN happens because of a static condition, then a poll
or later retry won't fix it. We must call it again from blocking
condition. Play it safe and ensure that any -EAGAIN condition from read
or write must retry from async context.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index b43467b3a8dc..e175fed0274a 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2255,10 +2255,8 @@ static int io_read(struct io_kiocb *req, struct io_kiocb **nxt,
 	 * If the file doesn't support async, mark it as REQ_F_MUST_PUNT so
 	 * we know to async punt it even if it was opened O_NONBLOCK
 	 */
-	if (force_nonblock && !io_file_supports_async(req->file)) {
-		req->flags |= REQ_F_MUST_PUNT;
+	if (force_nonblock && !io_file_supports_async(req->file))
 		goto copy_iov;
-	}
 
 	iov_count = iov_iter_count(&iter);
 	ret = rw_verify_area(READ, req->file, &kiocb->ki_pos, iov_count);
@@ -2279,6 +2277,8 @@ static int io_read(struct io_kiocb *req, struct io_kiocb **nxt,
 						inline_vecs, &iter);
 			if (ret)
 				goto out_free;
+			/* any defer here is final, must blocking retry */
+			req->flags |= REQ_F_MUST_PUNT;
 			return -EAGAIN;
 		}
 	}
@@ -2344,10 +2344,8 @@ static int io_write(struct io_kiocb *req, struct io_kiocb **nxt,
 	 * If the file doesn't support async, mark it as REQ_F_MUST_PUNT so
 	 * we know to async punt it even if it was opened O_NONBLOCK
 	 */
-	if (force_nonblock && !io_file_supports_async(req->file)) {
-		req->flags |= REQ_F_MUST_PUNT;
+	if (force_nonblock && !io_file_supports_async(req->file))
 		goto copy_iov;
-	}
 
 	/* file path doesn't support NOWAIT for non-direct_IO */
 	if (force_nonblock && !(kiocb->ki_flags & IOCB_DIRECT) &&
@@ -2392,6 +2390,8 @@ static int io_write(struct io_kiocb *req, struct io_kiocb **nxt,
 						inline_vecs, &iter);
 			if (ret)
 				goto out_free;
+			/* any defer here is final, must blocking retry */
+			req->flags |= REQ_F_MUST_PUNT;
 			return -EAGAIN;
 		}
 	}
-- 
2.25.1

