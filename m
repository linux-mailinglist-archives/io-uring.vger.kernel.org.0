Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D70913198C4
	for <lists+io-uring@lfdr.de>; Fri, 12 Feb 2021 04:28:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229662AbhBLD2a (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 11 Feb 2021 22:28:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbhBLD2a (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 11 Feb 2021 22:28:30 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5A80C0613D6
        for <io-uring@vger.kernel.org>; Thu, 11 Feb 2021 19:27:49 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id v1so2744495wrd.6
        for <io-uring@vger.kernel.org>; Thu, 11 Feb 2021 19:27:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=s/xH/+YICchHTTlWF/jTk2+H/VCDppkNbvRXXUjSwe4=;
        b=PQXHSe7qEnj2sFUwsLiFPf8ZrtYeRLmbIM8+GcIZ4WESwKBpRjrT7zD5U3FaGxn0/F
         ucEkyjtlLY/kjS6ZfnPKq3aDdaSuY1tiEt8V1gEs0uo1nmaP5lyVwyGT5DDUyA0wsr8Q
         A7slEfrJuLGtqYeeu8FZXIRuZ+BYgtnqndjqnvylnNuZ/hVLm1cpze4Iqo52l6ms7XWm
         3Lkc+FuN3QImZKQrG36LKRALM1VpcWNY765MWinWKHyq9JzEG+AoydkwcvUjOwFFahfd
         g/HjCUyOtR8COivOXr6ktCJ5vG3E16HX3jFaUTu2nl+hWMhtURwiOEiljWKz12DehSgt
         b5rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=s/xH/+YICchHTTlWF/jTk2+H/VCDppkNbvRXXUjSwe4=;
        b=IGUanM35cWSxIBIgIURu2x4gE2IwonbUFFN2617Qam/cPNuy8kUnCg6Jg+kS7DiXj/
         w+8+o0a1MjQlaG+T4N9ITQRxKl8OfUkMnhVE6TDuTytlR+qi3r9ZkE6OuEf1aP5LJgDO
         60mxUfhpQ/ji3DZ8g3taSSYGTWpb16MwfN6gzsWFNdGfoLjyJvZ88drUCefF5BdoN9Zn
         sWizL5MRCB80IXnGc0u2JlEQgAlxjtPGxS25rv7nGyXeuWDy6zkXZY62C/ZY0Kna6bAM
         QHT3DUy7WZB6SXcgy6O7MjlsI9cUIqwzx0hJC92iUgmeoyuZN/RsEGREdzjwoS7YDog0
         GpDA==
X-Gm-Message-State: AOAM531H6/SH3Si2y3y+K6NJrnn9veTkVeYIt4y2B5QJ6K3sXmx1qF/D
        n3dBaeBK1H23vG+FK6OJzFE=
X-Google-Smtp-Source: ABdhPJzqM7/wvI1oG27DazfknY4oZtss+KBA2oKdqGJJKMPEkWR/zMy45gorCCbciIV8gJqy/svW9w==
X-Received: by 2002:adf:ee09:: with SMTP id y9mr935342wrn.74.1613100468576;
        Thu, 11 Feb 2021 19:27:48 -0800 (PST)
Received: from localhost.localdomain ([185.69.144.228])
        by smtp.gmail.com with ESMTPSA id c62sm12973479wmd.43.2021.02.11.19.27.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Feb 2021 19:27:48 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 2/5] io_uring: optimise out unlikely link queue
Date:   Fri, 12 Feb 2021 03:23:51 +0000
Message-Id: <dcb9cec5832c5f47d348947fcf65c4b98bad42f0.1613099986.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1613099986.git.asml.silence@gmail.com>
References: <cover.1613099986.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

__io_queue_sqe() tries to issue as much requests of a link as it can,
and uses io_put_req_find_next() to extract a next one, targeting inline
completed requests. As now __io_queue_sqe() is always used together with
struct io_comp_state, it leaves next propagation only a small window and
only for async reqs, that doesn't justify its existence.

Remove it, make __io_queue_sqe() to issue only a head request. It
simplifies the code and will allow other optimisations.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 42 ++++++++++--------------------------------
 1 file changed, 10 insertions(+), 32 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 8c2613bf54d3..26d1080217e5 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6563,26 +6563,20 @@ static struct io_kiocb *io_prep_linked_timeout(struct io_kiocb *req)
 
 static void __io_queue_sqe(struct io_kiocb *req)
 {
-	struct io_kiocb *linked_timeout;
+	struct io_kiocb *linked_timeout = io_prep_linked_timeout(req);
 	const struct cred *old_creds = NULL;
 	int ret;
 
-again:
-	linked_timeout = io_prep_linked_timeout(req);
-
 	if ((req->flags & REQ_F_WORK_INITIALIZED) &&
 	    (req->work.flags & IO_WQ_WORK_CREDS) &&
-	    req->work.identity->creds != current_cred()) {
-		if (old_creds)
-			revert_creds(old_creds);
-		if (old_creds == req->work.identity->creds)
-			old_creds = NULL; /* restored original creds */
-		else
-			old_creds = override_creds(req->work.identity->creds);
-	}
+	    req->work.identity->creds != current_cred())
+		old_creds = override_creds(req->work.identity->creds);
 
 	ret = io_issue_sqe(req, IO_URING_F_NONBLOCK|IO_URING_F_COMPLETE_DEFER);
 
+	if (old_creds)
+		revert_creds(old_creds);
+
 	/*
 	 * We async punt it if the file wasn't marked NOWAIT, or if the file
 	 * doesn't support non-blocking read/write attempts
@@ -6595,9 +6589,6 @@ static void __io_queue_sqe(struct io_kiocb *req)
 			 */
 			io_queue_async_work(req);
 		}
-
-		if (linked_timeout)
-			io_queue_linked_timeout(linked_timeout);
 	} else if (likely(!ret)) {
 		/* drop submission reference */
 		if (req->flags & REQ_F_COMPLETE_INLINE) {
@@ -6605,31 +6596,18 @@ static void __io_queue_sqe(struct io_kiocb *req)
 			struct io_comp_state *cs = &ctx->submit_state.comp;
 
 			cs->reqs[cs->nr++] = req;
-			if (cs->nr == IO_COMPL_BATCH)
+			if (cs->nr == ARRAY_SIZE(cs->reqs))
 				io_submit_flush_completions(cs, ctx);
-			req = NULL;
 		} else {
-			req = io_put_req_find_next(req);
-		}
-
-		if (linked_timeout)
-			io_queue_linked_timeout(linked_timeout);
-
-		if (req) {
-			if (!(req->flags & REQ_F_FORCE_ASYNC))
-				goto again;
-			io_queue_async_work(req);
+			io_put_req(req);
 		}
 	} else {
-		/* un-prep timeout, so it'll be killed as any other linked */
-		req->flags &= ~REQ_F_LINK_TIMEOUT;
 		req_set_fail_links(req);
 		io_put_req(req);
 		io_req_complete(req, ret);
 	}
-
-	if (old_creds)
-		revert_creds(old_creds);
+	if (linked_timeout)
+		io_queue_linked_timeout(linked_timeout);
 }
 
 static void io_queue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe)
-- 
2.24.0

