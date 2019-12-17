Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C284E1235A8
	for <lists+io-uring@lfdr.de>; Tue, 17 Dec 2019 20:27:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728032AbfLQT1g (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 17 Dec 2019 14:27:36 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:40680 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727975AbfLQT1g (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 17 Dec 2019 14:27:36 -0500
Received: by mail-wr1-f65.google.com with SMTP id c14so12581057wrn.7;
        Tue, 17 Dec 2019 11:27:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=9RNl0crDqpQfBa3kLFwGLLqqoZQSjzmeCGiN0amEGwA=;
        b=YIMUHzYWDjrYH1uEgyIiLjt2WySmggOIJCBc4eK2wrouHTbia6Ls+smGLqM681rwdg
         rJ4f1tJi29U5YA9izbYOSvyNY545043LpttSIxpiiQ1dfMBqqnAZbBQkJvunQ4v2cSbS
         xJ94AFtsc4diGBQfzQ9pA0aIHWdFYJSxvKWpof1UydVYAtFDL+7igcwfv09L4AGn13g1
         RsaDdforwTfZoZz5Lllf0z8iHuLnBq6wGu5r3eapWupuPvw3JE4GiGrXQ3WRRg5ls2B4
         Ujngq6m88REzUM+N5Z1157bzU0bn/WqyiT00xigIAxlHImCuupKZGUqYy/gDxN73QGvw
         NlzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9RNl0crDqpQfBa3kLFwGLLqqoZQSjzmeCGiN0amEGwA=;
        b=WEY3fc1ygBou18vEEbJr3+rDJ0Z+PVbVjAnhiLH/RbnhpZ4GEG6auXm1QupKXmo8SA
         HJ5DF1qsEgH3yNdqK4XMgjfEt/3Hz4tbXxJ3WjTf2ZK9+w3PKPZy8rUy7eYZKnaoVjEn
         m63l6IGT1DU+6S+6Hw7zPsZ0dJvskNp4epgUSVRyAKDrEhNUO6IjkwCU9DinwVx7dsmQ
         KuQgDDMkfCJzOysIFTUHIen8MGQiQ/OLJgLOVIlmCmkjo1BhQigL29BFHaEyRfzf7P8H
         QvYxDFlE1ZENOun1HxhpCgz88H1D9uFvBxpXY6Xvnb6r99SNHKQgmb8NsTK7E+BZWK9v
         c0lA==
X-Gm-Message-State: APjAAAXIoQc04JOQmIBlncwmDTngveW6cuT4eePJplJ9pmgQVWqq3B1k
        c6XHjN/PJx0ccyhD87syOLMvcZdc
X-Google-Smtp-Source: APXvYqw+Zkrzl/SU8dtIn56diviXfI/sedIg1RSb2iJvRL/z0FZUlswLcQkM3CCmnLMDhXhiS4jhrg==
X-Received: by 2002:a5d:46c1:: with SMTP id g1mr37964263wrs.200.1576610853889;
        Tue, 17 Dec 2019 11:27:33 -0800 (PST)
Received: from localhost.localdomain ([109.126.149.134])
        by smtp.gmail.com with ESMTPSA id w13sm26711822wru.38.2019.12.17.11.27.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Dec 2019 11:27:33 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] io_uring: rename prev to head
Date:   Tue, 17 Dec 2019 22:26:56 +0300
Message-Id: <96a50f1e5e114421847f7063f98d111b9892a7c7.1576610536.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1576610536.git.asml.silence@gmail.com>
References: <cover.1576610536.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Calling "prev" a head of a link is a bit misleading. Rename it

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index eb6d897ea087..e8ce224dc82c 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3399,10 +3399,10 @@ static bool io_submit_sqe(struct io_kiocb *req, struct io_submit_state *state,
 	 * conditions are true (normal request), then just queue it.
 	 */
 	if (*link) {
-		struct io_kiocb *prev = *link;
+		struct io_kiocb *head = *link;
 
 		if (req->sqe->flags & IOSQE_IO_DRAIN)
-			(*link)->flags |= REQ_F_DRAIN_LINK | REQ_F_IO_DRAIN;
+			head->flags |= REQ_F_DRAIN_LINK | REQ_F_IO_DRAIN;
 
 		if (req->sqe->flags & IOSQE_IO_HARDLINK)
 			req->flags |= REQ_F_HARDLINK;
@@ -3415,11 +3415,11 @@ static bool io_submit_sqe(struct io_kiocb *req, struct io_submit_state *state,
 		ret = io_req_defer_prep(req);
 		if (ret) {
 			/* fail even hard links since we don't submit */
-			prev->flags |= REQ_F_FAIL_LINK;
+			head->flags |= REQ_F_FAIL_LINK;
 			goto err_req;
 		}
-		trace_io_uring_link(ctx, req, prev);
-		list_add_tail(&req->link_list, &prev->link_list);
+		trace_io_uring_link(ctx, req, head);
+		list_add_tail(&req->link_list, &head->link_list);
 	} else if (req->sqe->flags & (IOSQE_IO_LINK|IOSQE_IO_HARDLINK)) {
 		req->flags |= REQ_F_LINK;
 		if (req->sqe->flags & IOSQE_IO_HARDLINK)
-- 
2.24.0

