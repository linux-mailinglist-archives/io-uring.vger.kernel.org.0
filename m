Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8209C17490B
	for <lists+io-uring@lfdr.de>; Sat, 29 Feb 2020 20:57:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727247AbgB2T5F (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 29 Feb 2020 14:57:05 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:33493 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727194AbgB2T5F (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 29 Feb 2020 14:57:05 -0500
Received: by mail-wr1-f65.google.com with SMTP id x7so7573449wrr.0;
        Sat, 29 Feb 2020 11:57:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=vvkDjAk4ndVLVwI1Z85PO4wShGWFE753uje7rnBIzBg=;
        b=t2DDU3+hkN8w194qqvWUopVfWP6u0sKq3Z19CzBXahiRvO7xABcJJau8w10RTTkA0M
         lxL8kCgpuWA8U0gL+svruQ9DgmOMuCA/RQzwozxbOhxdOVEaCfMNyYIj22bKk2LMkzcN
         TP8l0emC/VhIOxO1h/xUPAoM5IG35668eoiIRtdF4OvwG1MwcTZK097OeE5VZc00rCWE
         +i6Djpi3yXFAAR9/tpala0OkFAToxPbS0cLrtWDbmkekPFbGxs3hTf2xrD4JhPHXN2jq
         xjrk7BZI4QVR4CKsfhFch2A+fHFvuzA1dGUJpyX+2qXXjOzTf2CI3rB0fioKtmbklj9N
         uhLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vvkDjAk4ndVLVwI1Z85PO4wShGWFE753uje7rnBIzBg=;
        b=nNur+r/57QjJAWbJsz9VYemqRDwlQ6AJ8cQtnmfF4myJamh1X5NKjEZm8vJQxiDesG
         y9Llw7b26PPcB/DsBevUBQGKdB0wDSREuQMTRQAL3/tDPNmJnQwUUNbLSggWft5O69iN
         L+Z9PfN55VbPHUkb0zMYsClLdOEAE3xGFvvXSFNpBmmMr6Btme24hhtqt4MtO7l6nke0
         tPNLCaLgYtXpBUF4frPXdOaSqGOMLNXbeSGlN37vKqjyVOoD/Zlk2e3EKGzLA0rV+s9j
         UHlQJKwhOrIeOaQ9wXlxC7/k48G6YkFKcvWjn1srf7xrGWHTO/9ZRNUwtYoseTrYN6e1
         58aQ==
X-Gm-Message-State: APjAAAW9OtVytIz5qvOiwIy2L/necWN9Y8gJlfL2I97ApPbZwG5Le4p/
        SWTQ9csID8CozznwEPc+01QN/EC8
X-Google-Smtp-Source: APXvYqxryE7Rk5zddXt9LGFByBc1I2MYRMoiGnlh9NTKNJeG9V7EA89QCMdLrnpj6epKJ2gU2TH4dA==
X-Received: by 2002:adf:f052:: with SMTP id t18mr11411182wro.192.1583006222335;
        Sat, 29 Feb 2020 11:57:02 -0800 (PST)
Received: from localhost.localdomain ([109.126.130.242])
        by smtp.gmail.com with ESMTPSA id k16sm19171386wrd.17.2020.02.29.11.57.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Feb 2020 11:57:01 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] io_uring: remove io_prep_next_work()
Date:   Sat, 29 Feb 2020 22:56:10 +0300
Message-Id: <b97698208e565be70ae0afae1851e0964260c3f8.1583006078.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <d5893319c019695321a357cb1f09e76ed40715d1.1583005556.git.asml.silence@gmail.com>
References: <d5893319c019695321a357cb1f09e76ed40715d1.1583005556.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io-wq cares about IO_WQ_WORK_UNBOUND flag only while enqueueing, so
it's useless setting it for a next req of a link. Thus, removed it
from io_prep_linked_timeout(), and inline the function.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---

v2: fix unfortunate cherry-pick

 fs/io_uring.c | 13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 74498c9cd023..768cf18cf912 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -999,17 +999,6 @@ static inline void io_req_work_drop_env(struct io_kiocb *req)
 	}
 }
 
-static inline void io_prep_next_work(struct io_kiocb *req,
-				     struct io_kiocb **link)
-{
-	const struct io_op_def *def = &io_op_defs[req->opcode];
-
-	if (!(req->flags & REQ_F_ISREG) && def->unbound_nonreg_file)
-		req->work.flags |= IO_WQ_WORK_UNBOUND;
-
-	*link = io_prep_linked_timeout(req);
-}
-
 static inline bool io_prep_async_work(struct io_kiocb *req,
 				      struct io_kiocb **link)
 {
@@ -2581,8 +2570,8 @@ static void io_wq_assign_next(struct io_wq_work **workptr, struct io_kiocb *nxt)
 {
 	struct io_kiocb *link;
 
-	io_prep_next_work(nxt, &link);
 	*workptr = &nxt->work;
+	link = io_prep_linked_timeout(nxt);
 	if (link) {
 		nxt->work.func = io_link_work_cb;
 		nxt->work.data = link;
-- 
2.24.0

