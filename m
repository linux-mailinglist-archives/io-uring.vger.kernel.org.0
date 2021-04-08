Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70E6D35793E
	for <lists+io-uring@lfdr.de>; Thu,  8 Apr 2021 02:58:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229966AbhDHA7I (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 7 Apr 2021 20:59:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbhDHA7H (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 7 Apr 2021 20:59:07 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D10B6C061760
        for <io-uring@vger.kernel.org>; Wed,  7 Apr 2021 17:58:56 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id s7so111034wru.6
        for <io-uring@vger.kernel.org>; Wed, 07 Apr 2021 17:58:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=VzZClwmJ0QXLGWALoXeSx2HEesPrzrVUdZEWJtMZzs4=;
        b=HZyuu/+ZC2Ecv0dre89FyrSXCkHebBOs0CW+A2TK+YvcxPs0H8urMYza9awEqEu+7B
         W0NpgBFLMXYDX6aQE5We/fAjPXGPABP3s/VT5BaD8WgwTp8YoybZBkjDvQQOp44WC3gh
         5q8BvI5oBs17GA0yEWQCl4f2bFvdqhICqmihCM2ug1AbzEhSOz2k8zfzJDd9gs26UqyS
         9994eoSA1t11thmVdOSVntZBAXJL81wVg8SCRjfghDQ8p7CdwEJGJVCtAtg72H3mWCht
         b0OJAZdsG+ALf60fFH6bxOWj6RAsUnC3d9BmQR6d4PjKMegey5TGFfDnXfwQDJOulFr6
         azTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VzZClwmJ0QXLGWALoXeSx2HEesPrzrVUdZEWJtMZzs4=;
        b=Sv0wsKqg8QCj5TkEqM0MdPt0KWVfnwLuGX4IFxRWrXty83T25Lywf9bxCcL+VXZLuW
         22suqPaBZ3UL++lrsu8J/hM2vA1g5deCikygJghHRxaba4mgBZVCw1oSfNIwtWPhEH+I
         tKj/Je+jIG64J/iGE8EloTrUVRxv4mMOmGues5id733RFH8ztqJq8CV9uej269gNEXmx
         If7emBu99I81xdA+1clQ9g0tg15acmdeihzPdiJ18BuKq5PgoF+QEj3HkUtuapZ5+XZ/
         gpyotlSWkLKarLav2i7V5NJgHLGZiqTmkQbhKe/r9R30ncvgs5Y0iJbErsbdpahLIUJt
         LBAg==
X-Gm-Message-State: AOAM531g7bKp5YdYsj2VtSb85p8yK4nRgDafFQlKx5Ta2Sw8+Hcy1zUy
        ofEng/rFQeA47NBImr1+uto=
X-Google-Smtp-Source: ABdhPJyOC7REuxhTirjKmCx9KQC92QKgYb3O1ByYE/deM/xv9hF0aK7/00tt6dTQr2sd6rEJMKsA6g==
X-Received: by 2002:a05:6000:83:: with SMTP id m3mr7320287wrx.321.1617843535665;
        Wed, 07 Apr 2021 17:58:55 -0700 (PDT)
Received: from localhost.localdomain ([148.252.132.202])
        by smtp.gmail.com with ESMTPSA id s9sm12219287wmh.31.2021.04.07.17.58.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Apr 2021 17:58:55 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 1/4] io_uring: clear F_REISSUE right after getting it
Date:   Thu,  8 Apr 2021 01:54:39 +0100
Message-Id: <11dcead939343f4e27cab0074d34afcab771bfa4.1617842918.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1617842918.git.asml.silence@gmail.com>
References: <cover.1617842918.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

There are lots of ways r/w request may continue its path after getting
REQ_F_REISSUE, it's not necessarily io-wq and can be, e.g. apoll,
and submitted via  io_async_task_func() -> __io_req_task_submit()

Clear the flag right after getting it, so the next attempt is well
prepared regardless how the request will be executed.

Fixes: 230d50d448ac ("io_uring: move reissue into regular IO path")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 65a17d560a73..f1881ac0744b 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3294,6 +3294,7 @@ static int io_read(struct io_kiocb *req, unsigned int issue_flags)
 	ret = io_iter_do_read(req, iter);
 
 	if (ret == -EAGAIN || (req->flags & REQ_F_REISSUE)) {
+		req->flags &= ~REQ_F_REISSUE;
 		/* IOPOLL retry should happen for io-wq threads */
 		if (!force_nonblock && !(req->ctx->flags & IORING_SETUP_IOPOLL))
 			goto done;
@@ -3417,8 +3418,10 @@ static int io_write(struct io_kiocb *req, unsigned int issue_flags)
 	else
 		ret2 = -EINVAL;
 
-	if (req->flags & REQ_F_REISSUE)
+	if (req->flags & REQ_F_REISSUE) {
+		req->flags &= ~REQ_F_REISSUE;
 		ret2 = -EAGAIN;
+	}
 
 	/*
 	 * Raw bdev writes will return -EOPNOTSUPP for IOCB_NOWAIT. Just
@@ -6173,7 +6176,6 @@ static void io_wq_submit_work(struct io_wq_work *work)
 		ret = -ECANCELED;
 
 	if (!ret) {
-		req->flags &= ~REQ_F_REISSUE;
 		do {
 			ret = io_issue_sqe(req, 0);
 			/*
-- 
2.24.0

