Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC5B61F1EB5
	for <lists+io-uring@lfdr.de>; Mon,  8 Jun 2020 20:09:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725924AbgFHSJz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 8 Jun 2020 14:09:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725280AbgFHSJv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 8 Jun 2020 14:09:51 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4963FC08C5C2;
        Mon,  8 Jun 2020 11:09:51 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id m32so9031326ede.8;
        Mon, 08 Jun 2020 11:09:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NqcWwVumF9LnBSojmV0nzx2ARdT5wsG5BpfatlWZVrk=;
        b=Exiv6cTdUp7CMWekoIHZVPDZo1dACrbX4tXki33fJeICBPXBgAhV3LCAQG1riPCoC3
         qRWhCmky1EoEv7yyEgPzd2KmPz6l+UZa52obbaWhZkQqCthYzUam4JtpJm2Fdx8GU6r6
         oszOto+acsPLVGnsJxTdqnB42w5GKzOLKrpEgOvd1oEnM9wfUwKCPNq2Qfq97KAF0rYf
         Dkto+dkU8oVwUaR7LnY+eGJ2hAUU8uQibUG7IkeF+OZ/H17gS5SXS8jITuUbevQVk/l+
         6o/uCwfsnPOr8wbN2Uh/OfKA1wZ1P5MXtyQsMikY+rAAZArj7WJxsOlPksS7YSaHwVR5
         a6Iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NqcWwVumF9LnBSojmV0nzx2ARdT5wsG5BpfatlWZVrk=;
        b=lRB+6Rd9FvfragMHGM+zXYUdVsVASGVkh2NEwgulx+HPq+w067LEVt3o3TEX6yIF4S
         BSIt+P/eqvnT1jmPhF01AX990VRv7LVo7SgzjMPKkCGdDFXO7RGB7c++ODeBn+0LHnR5
         j8axdn/1TU4rUs1I9C1zjEAtoA3imI72p7aZdC0U5xrTkRfsp7FTqm6lSqnfafTuvk86
         WtNV/t8gt2ZNBd26tqfImD0x4G5IpDCNHTqoa/v9nJogGIETXRuWJLc23KqpEpkOXoXq
         eqaSqFTdxQBeDF2z7VWpRE/nIKd4keE8Tx02ah4i1Pxq+atpMDilVdAyu27J1UPT9UR/
         p53A==
X-Gm-Message-State: AOAM530pMuDZtnZjUvYyg5x9/MxI9ZJwGxKlXDNgHTpu4lMhlfkPqRxX
        ZYXpubfDyQdDfqrsJNgV6j5tPTLc
X-Google-Smtp-Source: ABdhPJzfeDyhbKHjnNdELRjSogyPE0C+pk5k3pdxADTTJUpFiHmghJtFvAXMkqyHk2Mzu2ce/JLYIQ==
X-Received: by 2002:a05:6402:1216:: with SMTP id c22mr24031309edw.208.1591639789576;
        Mon, 08 Jun 2020 11:09:49 -0700 (PDT)
Received: from localhost.localdomain ([5.100.193.151])
        by smtp.gmail.com with ESMTPSA id ok21sm10515029ejb.82.2020.06.08.11.09.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2020 11:09:49 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, xiaoguang.wang@linux.alibaba.com
Subject: [PATCH 1/4] io_uring: don't derive close state from ->func
Date:   Mon,  8 Jun 2020 21:08:17 +0300
Message-Id: <8935dcfc447acd2ffd8b0397a21cf8cb0e6bdec4.1591637070.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1591637070.git.asml.silence@gmail.com>
References: <cover.1591637070.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Relying on having a specific work.func is dangerous, even if an opcode
handler set it itself. E.g. io_wq_assign_next() can modify it.

io_close() sets a custom work.func to indicate that
__close_fd_get_file() was already called. Fortunately, there is no bugs
with io_wq_assign_next() and close yet.

Still, do it safe and always be prepared to be called through
io_wq_submit_work(). Zero req->close.put_file in prep, and call
__close_fd_get_file() IFF it's NULL.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 50 +++++++++++++++++---------------------------------
 1 file changed, 17 insertions(+), 33 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 3aebbf96c123..9acd695cc473 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3479,53 +3479,37 @@ static int io_close_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	    req->close.fd == req->ctx->ring_fd)
 		return -EBADF;
 
+	req->close.put_file = NULL;
 	return 0;
 }
 
-/* only called when __close_fd_get_file() is done */
-static void __io_close_finish(struct io_kiocb *req)
-{
-	int ret;
-
-	ret = filp_close(req->close.put_file, req->work.files);
-	if (ret < 0)
-		req_set_fail_links(req);
-	io_cqring_add_event(req, ret);
-	fput(req->close.put_file);
-	io_put_req(req);
-}
-
-static void io_close_finish(struct io_wq_work **workptr)
-{
-	struct io_kiocb *req = container_of(*workptr, struct io_kiocb, work);
-
-	/* not cancellable, don't do io_req_cancelled() */
-	__io_close_finish(req);
-	io_steal_work(req, workptr);
-}
-
 static int io_close(struct io_kiocb *req, bool force_nonblock)
 {
+	struct io_close *close = &req->close;
 	int ret;
 
-	req->close.put_file = NULL;
-	ret = __close_fd_get_file(req->close.fd, &req->close.put_file);
-	if (ret < 0)
-		return (ret == -ENOENT) ? -EBADF : ret;
+	/* might be already done during nonblock submission */
+	if (!close->put_file) {
+		ret = __close_fd_get_file(close->fd, &close->put_file);
+		if (ret < 0)
+			return (ret == -ENOENT) ? -EBADF : ret;
+	}
 
 	/* if the file has a flush method, be safe and punt to async */
-	if (req->close.put_file->f_op->flush && force_nonblock) {
+	if (close->put_file->f_op->flush && force_nonblock) {
 		/* avoid grabbing files - we don't need the files */
 		req->flags |= REQ_F_NO_FILE_TABLE | REQ_F_MUST_PUNT;
-		req->work.func = io_close_finish;
 		return -EAGAIN;
 	}
 
-	/*
-	 * No ->flush(), safely close from here and just punt the
-	 * fput() to async context.
-	 */
-	__io_close_finish(req);
+	/* No ->flush() or already async, safely close from here */
+	ret = filp_close(close->put_file, req->work.files);
+	if (ret < 0)
+		req_set_fail_links(req);
+	io_cqring_add_event(req, ret);
+	fput(close->put_file);
+	close->put_file = NULL;
+	io_put_req(req);
 	return 0;
 }
 
-- 
2.24.0

