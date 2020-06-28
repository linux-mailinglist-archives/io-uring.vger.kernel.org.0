Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D4B020C752
	for <lists+io-uring@lfdr.de>; Sun, 28 Jun 2020 11:54:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726214AbgF1Jy0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 28 Jun 2020 05:54:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725999AbgF1JyZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 28 Jun 2020 05:54:25 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76678C061794
        for <io-uring@vger.kernel.org>; Sun, 28 Jun 2020 02:54:25 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id n2so1179743edr.5
        for <io-uring@vger.kernel.org>; Sun, 28 Jun 2020 02:54:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=eOpr48FKAaJ5Q09EKKJIvh/U8rvJVoZUudRgJz91oJw=;
        b=IVerMxa5vkT2Olys2es3Y5CnySIr2AvEEh+7FiqwyYyAHFc0Unq4gtj3zTIFKRts2u
         R84IMUaMUufnvKz/MaNpHS4eYxzKvoiWm08m5R+BHAOd1R7tunQVq8wrG9p+ZzZaDslo
         NgzebAD0bcIBmNE0Vc5UtILGPFY3XAFk3RcgcTq3mZjkaD/XD7KV5rrdGiHolL3h3Rqa
         drk6F2uQwDPlKVyRVNY5QD/EnMu8R5f9o+8XP6hyhwxMhOQI4OrjZaBk28DDFcOHsW/q
         si1w45DiNbZhPcqfaWcLM9CUaJj/ATUN+AMKPpywTYG3vGb+R4U4+cbd0Z8Q5/kjhAsq
         C4yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eOpr48FKAaJ5Q09EKKJIvh/U8rvJVoZUudRgJz91oJw=;
        b=jyHWeimiSaw6LTS4CRBesJ0a7nbuBb5YSRWfm5oINawIzJsENi+Cl8p5zCp2+XblGG
         anyVDC2e511adI0ScehUx1lFRc5p/prDox52370KikVT/0CifjIwecRGy+BFecwMwnTd
         B0gXCVnTDAT+gV7gGWnbeAk2IPACsXgJvjAU6qLRPEPtTXzNvAHrPC0Hj3OW403ZneSq
         cv5m7r/DqYycuH38BTw5VNy9s3QqEDGTNHNAPVuQ7jOJ5ypJvUXBYNz3gS76PZTFm7BX
         KfzlW3krZz7WiLbvvzcV0sNrsIolnrofh3+3P94jCN7QPESZru7GHejpDtqlbhiNgtJt
         Pn0g==
X-Gm-Message-State: AOAM531669ZbCF3cnLJ+2boIaJCaBeLfoXrLWTdElTWerdsZ+zIcHxmQ
        qfTSdqtQ1867unnE+hp32H1/WO8U
X-Google-Smtp-Source: ABdhPJzshODHWtb4qP2EQuxuJb/5HA3MqH0LDq6pcg9SsRYsnOTAAweQ4JFtRPzZ4Uxs+WUzRS3X3w==
X-Received: by 2002:a50:8465:: with SMTP id 92mr11779254edp.388.1593338064209;
        Sun, 28 Jun 2020 02:54:24 -0700 (PDT)
Received: from localhost.localdomain ([82.209.196.123])
        by smtp.gmail.com with ESMTPSA id w15sm10089490ejk.103.2020.06.28.02.54.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Jun 2020 02:54:23 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 06/10] io_uring: kill REQ_F_LINK_NEXT
Date:   Sun, 28 Jun 2020 12:52:34 +0300
Message-Id: <ac2d994fbd527f77a9fc75c96924460aee5a52fd.1593337097.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1593337097.git.asml.silence@gmail.com>
References: <cover.1593337097.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

After pulling nxt from a request, it's no more a link's head, so
clear REQ_F_LINK_HEAD. Absence of this flag also indicates that
there are no linked requests, so replacing REQ_F_LINK_NEXT,
which can be killed.

Linked timeouts also behave leaving the flag intact when necessary.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index f64cca727021..b9f44c6b32f1 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -526,7 +526,6 @@ enum {
 	REQ_F_BUFFER_SELECT_BIT	= IOSQE_BUFFER_SELECT_BIT,
 
 	REQ_F_LINK_HEAD_BIT,
-	REQ_F_LINK_NEXT_BIT,
 	REQ_F_FAIL_LINK_BIT,
 	REQ_F_INFLIGHT_BIT,
 	REQ_F_CUR_POS_BIT,
@@ -565,8 +564,6 @@ enum {
 
 	/* head of a link */
 	REQ_F_LINK_HEAD		= BIT(REQ_F_LINK_HEAD_BIT),
-	/* already grabbed next link */
-	REQ_F_LINK_NEXT		= BIT(REQ_F_LINK_NEXT_BIT),
 	/* fail rest of links */
 	REQ_F_FAIL_LINK		= BIT(REQ_F_FAIL_LINK_BIT),
 	/* on inflight list */
@@ -1559,10 +1556,6 @@ static void io_req_link_next(struct io_kiocb *req, struct io_kiocb **nxtptr)
 	struct io_ring_ctx *ctx = req->ctx;
 	bool wake_ev = false;
 
-	/* Already got next link */
-	if (req->flags & REQ_F_LINK_NEXT)
-		return;
-
 	/*
 	 * The list should never be empty when we are called here. But could
 	 * potentially happen if the chain is messed up, check to be on the
@@ -1587,7 +1580,6 @@ static void io_req_link_next(struct io_kiocb *req, struct io_kiocb **nxtptr)
 		break;
 	}
 
-	req->flags |= REQ_F_LINK_NEXT;
 	if (wake_ev)
 		io_cqring_ev_posted(ctx);
 }
@@ -1628,6 +1620,7 @@ static void io_req_find_next(struct io_kiocb *req, struct io_kiocb **nxt)
 {
 	if (likely(!(req->flags & REQ_F_LINK_HEAD)))
 		return;
+	req->flags &= ~REQ_F_LINK_HEAD;
 
 	/*
 	 * If LINK is set, we have dependent requests in this chain. If we
-- 
2.24.0

