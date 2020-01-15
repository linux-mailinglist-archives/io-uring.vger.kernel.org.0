Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07FD313B8D3
	for <lists+io-uring@lfdr.de>; Wed, 15 Jan 2020 06:12:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725957AbgAOFMC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Jan 2020 00:12:02 -0500
Received: from mail-pj1-f65.google.com ([209.85.216.65]:37005 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725857AbgAOFMC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Jan 2020 00:12:02 -0500
Received: by mail-pj1-f65.google.com with SMTP id m13so7138667pjb.2
        for <io-uring@vger.kernel.org>; Tue, 14 Jan 2020 21:12:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=BvwiWamvvHCSSYiEbGo1Ur6qR2n1jqxb5nHYC4/gRWQ=;
        b=IgSxoa4+fcQZ6+DtyV7327UjRCW0MgiCZgvT5QnLxfmSl7nZhqIsmG3mcwQWZ0nJBT
         Yr8UyUVgHfEu19gDbVRM60K9MpfgPLzxwh27w8bGA57tdh+E43jgyTKIuWCD3T7gpgmK
         aUzvMdYzOPrtu8dMBoa5J0p16iMT47dACeA52ZfW73t7MJsA9CuiMn8gdyIR9IqUAK0E
         hk0Cn9zs4oYdmQjNHvGteRBfpK9Vtgxc+R2ZMqYgyKmKM6kg0I0IknFtZPGu2EWMZb/5
         gE8qgEkh/7zkL5oiJ6X6heWCJbLQ90WvL8EiIeQLoJB+tgXcnwFmMJnKXifn6fhplySk
         +9EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=BvwiWamvvHCSSYiEbGo1Ur6qR2n1jqxb5nHYC4/gRWQ=;
        b=BMclknx3jfOevW4GukO303L7pvlXXkY1+4nETy+7Hy+VV7ptLRrCJBc2vwR7GnyguT
         UYCOFrjpXyNZP5+95V6R1AISD/kUGwMTJpBduDYgn1XEdZ0GecVyocdXFDZI16qQUEyK
         cCBZNObGGWKSYyr1DS+U12Yd3eVyhZUr18HmfcpuLrcyN461VmVQliO9w6c8+WJBJg9p
         viHpDz885tve9T74jVyI9THtldTEXas8yoDOD2cPYMwCUHUkeM1BitR2Koo/LAy7Xg+b
         jSB9GbOXfX61pG7zpkFVzlxgqfuo0IgjIRQo+Y6dwqJG0SsXRB4EPE+wyDnMGJ41UzpJ
         0QxQ==
X-Gm-Message-State: APjAAAW1tJhN+RDb7S769gHYsEttuYtWuyrjBqRv4ztvmz/Hhmowj+B7
        DRhNj1KNXSJzr+iNmMSV8gcpqXI70Lo=
X-Google-Smtp-Source: APXvYqwwabiqejYVlSaydZkLvQ1N2zRjVn0Y1+9m2G9l5JZ4UKAN7Wupqhbc7pUN6erFbGE/pqvcPw==
X-Received: by 2002:a17:90a:d986:: with SMTP id d6mr33761366pjv.78.1579065121537;
        Tue, 14 Jan 2020 21:12:01 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id 83sm19034915pgh.12.2020.01.14.21.12.00
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Jan 2020 21:12:01 -0800 (PST)
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: be consistent in assigning next work from handler
Message-ID: <e465f9b4-3289-c08e-8ee9-c0200fc2ed57@kernel.dk>
Date:   Tue, 14 Jan 2020 22:12:00 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

If we pass back dependent work in case of links, we need to always
ensure that we call the link setup and work prep handler. If not, we
might be missing some setup for the next work item.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 52 +++++++++++++++++++++++++++------------------------
 1 file changed, 28 insertions(+), 24 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 8321c2f5589b..e32268ce38a5 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2037,6 +2037,28 @@ static bool io_req_cancelled(struct io_kiocb *req)
 	return false;
 }
 
+static void io_link_work_cb(struct io_wq_work **workptr)
+{
+	struct io_wq_work *work = *workptr;
+	struct io_kiocb *link = work->data;
+
+	io_queue_linked_timeout(link);
+	work->func = io_wq_submit_work;
+}
+
+static void io_wq_assign_next(struct io_wq_work **workptr, struct io_kiocb *nxt)
+{
+	struct io_kiocb *link;
+
+	io_prep_async_work(nxt, &link);
+	*workptr = &nxt->work;
+	if (link) {
+		nxt->work.flags |= IO_WQ_WORK_CB;
+		nxt->work.func = io_link_work_cb;
+		nxt->work.data = link;
+	}
+}
+
 static void io_fsync_finish(struct io_wq_work **workptr)
 {
 	struct io_kiocb *req = container_of(*workptr, struct io_kiocb, work);
@@ -2055,7 +2077,7 @@ static void io_fsync_finish(struct io_wq_work **workptr)
 	io_cqring_add_event(req, ret);
 	io_put_req_find_next(req, &nxt);
 	if (nxt)
-		*workptr = &nxt->work;
+		io_wq_assign_next(workptr, nxt);
 }
 
 static int io_fsync(struct io_kiocb *req, struct io_kiocb **nxt,
@@ -2111,7 +2133,7 @@ static void io_sync_file_range_finish(struct io_wq_work **workptr)
 	io_cqring_add_event(req, ret);
 	io_put_req_find_next(req, &nxt);
 	if (nxt)
-		*workptr = &nxt->work;
+		io_wq_assign_next(workptr, nxt);
 }
 
 static int io_sync_file_range(struct io_kiocb *req, struct io_kiocb **nxt,
@@ -2377,7 +2399,7 @@ static void io_accept_finish(struct io_wq_work **workptr)
 		return;
 	__io_accept(req, &nxt, false);
 	if (nxt)
-		*workptr = &nxt->work;
+		io_wq_assign_next(workptr, nxt);
 }
 #endif
 
@@ -2608,7 +2630,7 @@ static void io_poll_complete_work(struct io_wq_work **workptr)
 		req_set_fail_links(req);
 	io_put_req_find_next(req, &nxt);
 	if (nxt)
-		*workptr = &nxt->work;
+		io_wq_assign_next(workptr, nxt);
 }
 
 static int io_poll_wake(struct wait_queue_entry *wait, unsigned mode, int sync,
@@ -3271,15 +3293,6 @@ static int io_issue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 	return 0;
 }
 
-static void io_link_work_cb(struct io_wq_work **workptr)
-{
-	struct io_wq_work *work = *workptr;
-	struct io_kiocb *link = work->data;
-
-	io_queue_linked_timeout(link);
-	work->func = io_wq_submit_work;
-}
-
 static void io_wq_submit_work(struct io_wq_work **workptr)
 {
 	struct io_wq_work *work = *workptr;
@@ -3316,17 +3329,8 @@ static void io_wq_submit_work(struct io_wq_work **workptr)
 	}
 
 	/* if a dependent link is ready, pass it back */
-	if (!ret && nxt) {
-		struct io_kiocb *link;
-
-		io_prep_async_work(nxt, &link);
-		*workptr = &nxt->work;
-		if (link) {
-			nxt->work.flags |= IO_WQ_WORK_CB;
-			nxt->work.func = io_link_work_cb;
-			nxt->work.data = link;
-		}
-	}
+	if (!ret && nxt)
+		io_wq_assign_next(workptr, nxt);
 }
 
 static bool io_req_op_valid(int op)
-- 
2.25.0

-- 
Jens Axboe

