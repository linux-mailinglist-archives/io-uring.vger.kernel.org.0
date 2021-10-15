Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B9E242F7B9
	for <lists+io-uring@lfdr.de>; Fri, 15 Oct 2021 18:10:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241140AbhJOQMQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 15 Oct 2021 12:12:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236932AbhJOQMO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 15 Oct 2021 12:12:14 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8870FC061764
        for <io-uring@vger.kernel.org>; Fri, 15 Oct 2021 09:10:07 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id 63-20020a1c0042000000b0030d60716239so3424779wma.4
        for <io-uring@vger.kernel.org>; Fri, 15 Oct 2021 09:10:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3WxXqwTlNoCNQmBMLYhbjEktFBaSjlUmkbQqiD3X+qg=;
        b=cOlk9P7lD+xOh16KFmN6CR0awZLq1u6MwpoR7UX8vQxck4dKcqPTAOjm0TkRXumT/w
         Kqq+P97jRL6TVIZpxnJlKMZKB8F1hI64Mh0AJxabKLGAAhB/+3oJ7fmSue7CcWRf8E8u
         rSeyW+3m2Amnzz8opCzklkz7mSilZHTBJ37kL1b2HXXWZNQvINBvs1+m/98SzurFFxP9
         28/bVpzj+7d8x2J6ZJnmbz86GmdAW/7OlcScliyjpRCQ+2+XhVbHOkL3S6SMvsFzJVMa
         PO6/4TEMisr61dtGer9RBuwuOGnp/YbYXCtohT0QpIkjHBE2MvnAWTlwBeDmYgHgNktm
         2wew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3WxXqwTlNoCNQmBMLYhbjEktFBaSjlUmkbQqiD3X+qg=;
        b=6eP5yOZtmemhOOj7W0B55uGvFGqeV+CvUa/bHxYqQZShXkVLLd2fYWJCHhabtlgWtg
         knr1DDUvCfbS9q9752lZYnyVZPhtbpX4wQFw+M4Qd8vunLhTVVd3jhUcmJgB2xGnmJ92
         pm23jEN9xqtjAVGNNknXjRhaJ2ogqQd+EBqOtStODUObF1ZrBD4UE0bChP0GvG45YezK
         +cXuduQy3h2iC37inKZrXWjsMqKDduUX6fPy7GdfrDu9ng2T1HwH5EvGHMkGmt8XRAK/
         Kf3mNsLK9sukUWFT83xvzWrn7oZzQ59lWFuiWoTNjjcUqrMQ3vl/avogTfhcmOwUryvg
         lc5w==
X-Gm-Message-State: AOAM5301qD8/dVnJ7HXYAFhVLszTfpzbL4f4QQe57TUmGmw0+41qdqfD
        uAT/m7B0M+RU5hHq2NM65dojEld/d0Y=
X-Google-Smtp-Source: ABdhPJydV6RKYnM3e8VOcsnC44B7LdpvWaZrg3LwNjwy/5YhENrkVK9moxT9yHoO2PJFMY0MLKVBdw==
X-Received: by 2002:a1c:a9d3:: with SMTP id s202mr26800480wme.128.1634314205955;
        Fri, 15 Oct 2021 09:10:05 -0700 (PDT)
Received: from localhost.localdomain ([185.69.145.218])
        by smtp.gmail.com with ESMTPSA id c15sm5282811wrs.19.2021.10.15.09.10.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Oct 2021 09:10:05 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 2/8] io_uring: kill io_wq_current_is_worker() in iopoll
Date:   Fri, 15 Oct 2021 17:09:12 +0100
Message-Id: <7546d5a58efa4360173541c6fe02ee6b8c7b4ea7.1634314022.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <cover.1634314022.git.asml.silence@gmail.com>
References: <cover.1634314022.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Don't decide about locking based on io_wq_current_is_worker(), it's not
consistent with all other code and is expensive, use issue_flags.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index c1a00535e130..9fdbdf1cdb78 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2708,13 +2708,13 @@ static void io_complete_rw_iopoll(struct kiocb *kiocb, long res, long res2)
  * find it from a io_do_iopoll() thread before the issuer is done
  * accessing the kiocb cookie.
  */
-static void io_iopoll_req_issued(struct io_kiocb *req)
+static void io_iopoll_req_issued(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_ring_ctx *ctx = req->ctx;
-	const bool in_async = io_wq_current_is_worker();
+	const bool need_lock = !(issue_flags & IO_URING_F_NONBLOCK);
 
 	/* workqueue context doesn't hold uring_lock, grab it now */
-	if (unlikely(in_async))
+	if (unlikely(need_lock))
 		mutex_lock(&ctx->uring_lock);
 
 	/*
@@ -2750,7 +2750,7 @@ static void io_iopoll_req_issued(struct io_kiocb *req)
 	else
 		wq_list_add_tail(&req->comp_list, &ctx->iopoll_list);
 
-	if (unlikely(in_async)) {
+	if (unlikely(need_lock)) {
 		/*
 		 * If IORING_SETUP_SQPOLL is enabled, sqes are either handle
 		 * in sq thread task context or in io worker task context. If
@@ -6718,7 +6718,7 @@ static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
 		return ret;
 	/* If the op doesn't have a file, we're not polling for it */
 	if ((req->ctx->flags & IORING_SETUP_IOPOLL) && req->file)
-		io_iopoll_req_issued(req);
+		io_iopoll_req_issued(req, issue_flags);
 
 	return 0;
 }
-- 
2.33.0

