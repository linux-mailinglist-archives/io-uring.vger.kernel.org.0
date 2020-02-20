Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F873166859
	for <lists+io-uring@lfdr.de>; Thu, 20 Feb 2020 21:32:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728976AbgBTUb6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 20 Feb 2020 15:31:58 -0500
Received: from mail-pj1-f65.google.com ([209.85.216.65]:51800 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728400AbgBTUb6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 20 Feb 2020 15:31:58 -0500
Received: by mail-pj1-f65.google.com with SMTP id fa20so1347722pjb.1
        for <io-uring@vger.kernel.org>; Thu, 20 Feb 2020 12:31:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BPdue20yPrEAO95/cy8rDvve5g73RfBeOXqMHkni0CA=;
        b=Gv4eHnFPAZFeTtDI9jJxpyTTQA8YOx4QUUMSmO/QBHz2JMXRHzIj/l4gfjSXWSEwuk
         gJ65RhL08czRAwAHdGRV6VUOgBCybxUxVMOLcK+hT17R5nC3qc9Fs/jPzG4S+aym4MF/
         XpaxGYDJSS5GxJtjvHkevcS7cIAwpVjt4LBzBsFX9k3+0nZ5Z6JrTLgwuiamb+8FR2nS
         KqHzlG6XwCLXRsKhIKs0G7XJigOM55uH0geO/x8Y4fVcP3r9Rf6ySjvtLnyGs6+OUy5h
         4AL/J2PYBCeB1JcOc4uYN9xhaASIOZmCw+bQwnvSAIk8hC1GyGIJAdDsjBcqtPvF+pCJ
         ZKBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BPdue20yPrEAO95/cy8rDvve5g73RfBeOXqMHkni0CA=;
        b=aNAhOpSGiCJwAeR4JE2KHVIAuto/dh889YkIyIdqRCEU8Yr0esnt5yYJALS5iXA2RK
         DN4m1tuk0NIyfGx3c5tNUX7jaGes2EpSm0A6yjI+knjd/zbaLcq5LvArybkHtbny51Wa
         YElQNLGmMtqvffwpl8u3fUFwWug5wu76DVcA/zJVG9M54KW9QteldLr4Cjs+N7qnlItY
         XbXak7kFGYsrUz4dh7nROhIFFXR+2lDjF2K/WdlJGD0N28XTrqXck1pd/DMd09fuyekR
         dgAX+ygAvU4W0/7OTeNBz5xcxzP2/fr0j95c/uG4Q9+NE/RB7RglwSJXlfYSl9X6Cz+q
         ychQ==
X-Gm-Message-State: APjAAAWSHx3GBmB4s36NCFHUKMKF1ceEaNBGohg8hG0O0K+QeAKobdB2
        CEDtA6Zm/eKUkcFnvI9+ZNYA4TgThyE=
X-Google-Smtp-Source: APXvYqx4aT3i4BgJMTVJagFm+YpMY0oplfzV/NfmteE633UfY5hn95zvE2r/HmJULvYk9mNdS5jwTw==
X-Received: by 2002:a17:90b:11d0:: with SMTP id gv16mr5682979pjb.109.1582230716172;
        Thu, 20 Feb 2020 12:31:56 -0800 (PST)
Received: from x1.localdomain ([2605:e000:100e:8c61:8495:a173:67ea:559c])
        by smtp.gmail.com with ESMTPSA id z10sm169672pgj.73.2020.02.20.12.31.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Feb 2020 12:31:55 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     glauber@scylladb.com, peterz@infradead.org, asml.silence@gmail.com,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/9] io_uring: consider any io_read/write -EAGAIN as final
Date:   Thu, 20 Feb 2020 13:31:43 -0700
Message-Id: <20200220203151.18709-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200220203151.18709-1-axboe@kernel.dk>
References: <20200220203151.18709-1-axboe@kernel.dk>
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
index 6e249aa97ba3..bd3a39b0f4ee 100644
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

