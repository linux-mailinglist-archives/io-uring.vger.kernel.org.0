Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6348973BD1C
	for <lists+io-uring@lfdr.de>; Fri, 23 Jun 2023 18:49:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232260AbjFWQtN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 23 Jun 2023 12:49:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232499AbjFWQsX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 23 Jun 2023 12:48:23 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26FF02941
        for <io-uring@vger.kernel.org>; Fri, 23 Jun 2023 09:48:17 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id d2e1a72fcca58-668842bc50dso142745b3a.1
        for <io-uring@vger.kernel.org>; Fri, 23 Jun 2023 09:48:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1687538896; x=1690130896;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FfegOzu4tZpSz4Tx9eDD3X8u1MA2kW3UGo/SKYKWbW0=;
        b=0OKXdeZ1q5Tcf8mnhbI/HtvF9pdbEQEifCwFHLjNRm9B9m9HjTBPV8A8TOwWWs1PzK
         5C2tkBPbVZ40OlrgVBCiZc5xg3tCmNUipL8OKBou6V/T8ZgAnTH/eVU6gCzN/6pRpALm
         MTsWdnwlZCOYf2KtF9B1adG7vyrfvT0LqBp/al5UWkh73iCyZ6CUtisLxxShvoreqiQ5
         yRdPudJcJo363KqeqKsSBuptfhspyj4S2g4ib8Hi6PNURCjIXMHAOShg+jJp3Ca8SF3I
         F39nG/iJoQvzqWbVnCBN51di027oE+NNm+1XQar4m7oNab1dJWli0YLzeanVEBAJ0mMy
         VDRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687538896; x=1690130896;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FfegOzu4tZpSz4Tx9eDD3X8u1MA2kW3UGo/SKYKWbW0=;
        b=lUzCEcth366k2747HuTK5yun/JUOZu/2ZxQd47U2XiBPiNEw0FRcMPVVNriXnIpgUu
         V5ooDTTbWwUJ8ZGG/KkUwVqSwUFjcyCVb8jn2qDjDrYuBKYDzrN0WR9RmMti4EdAlVfG
         rWR1mfJc2Jpm4kP9rCzcNpAvyX4t/XmiFq9JhwAkfOrFWuibCVswlhvzIOAKO15UNQ1C
         /NIN6j8idZqrLbi/jleY/P55kcXDGSzeqn0QXH45lVNDW0dtC8teDvv6pruVDohmYztj
         1JkWY/VeEr8cjcEh+UHO2dQ0tmBKR4h0EFZApBP56NMvaJ7cnqBdvIVKs/k3NuCLGbx9
         0qOw==
X-Gm-Message-State: AC+VfDzKLxfh8Uccr/xwYxiRpTCBxC+d7fgxFw4AePDzPTzGHSSkO2aN
        ElUNXOP459MgIVKNCyxozakZ4iO76jff93szUEc=
X-Google-Smtp-Source: ACHHUZ5CyR4CYZkC4YazfVRWb4Zot+a3hPMb9qRSs45mzU1xkveHVitp9mi+vHJ4Q1MUKVlD3BA4kw==
X-Received: by 2002:a05:6a20:8f04:b0:121:d102:248c with SMTP id b4-20020a056a208f0400b00121d102248cmr16511421pzk.6.1687538896033;
        Fri, 23 Jun 2023 09:48:16 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id n4-20020a170903110400b001b55c0548dfsm7454411plh.97.2023.06.23.09.48.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Jun 2023 09:48:15 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5/8] io_uring: use cancelation match helper for poll and timeout requests
Date:   Fri, 23 Jun 2023 10:48:01 -0600
Message-Id: <20230623164804.610910-6-axboe@kernel.dk>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230623164804.610910-1-axboe@kernel.dk>
References: <20230623164804.610910-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Get rid of the request vs io_cancel_data checking and just use the
exported helper for this.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/poll.c    | 12 ++++--------
 io_uring/timeout.c | 12 +++---------
 2 files changed, 7 insertions(+), 17 deletions(-)

diff --git a/io_uring/poll.c b/io_uring/poll.c
index c7bb292c9046..dc1219f606e5 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -824,14 +824,10 @@ static struct io_kiocb *io_poll_file_find(struct io_ring_ctx *ctx,
 
 		spin_lock(&hb->lock);
 		hlist_for_each_entry(req, &hb->list, hash_node) {
-			if (!(cd->flags & IORING_ASYNC_CANCEL_ANY) &&
-			    req->file != cd->file)
-				continue;
-			if (cd->seq == req->work.cancel_seq)
-				continue;
-			req->work.cancel_seq = cd->seq;
-			*out_bucket = hb;
-			return req;
+			if (io_cancel_req_match(req, cd)) {
+				*out_bucket = hb;
+				return req;
+			}
 		}
 		spin_unlock(&hb->lock);
 	}
diff --git a/io_uring/timeout.c b/io_uring/timeout.c
index 4200099ad96e..6242130e73c6 100644
--- a/io_uring/timeout.c
+++ b/io_uring/timeout.c
@@ -268,16 +268,10 @@ static struct io_kiocb *io_timeout_extract(struct io_ring_ctx *ctx,
 	list_for_each_entry(timeout, &ctx->timeout_list, list) {
 		struct io_kiocb *tmp = cmd_to_io_kiocb(timeout);
 
-		if (!(cd->flags & IORING_ASYNC_CANCEL_ANY) &&
-		    cd->data != tmp->cqe.user_data)
-			continue;
-		if (cd->flags & (IORING_ASYNC_CANCEL_ALL|IORING_ASYNC_CANCEL_ANY)) {
-			if (cd->seq == tmp->work.cancel_seq)
-				continue;
-			tmp->work.cancel_seq = cd->seq;
+		if (io_cancel_req_match(tmp, cd)) {
+			req = tmp;
+			break;
 		}
-		req = tmp;
-		break;
 	}
 	if (!req)
 		return ERR_PTR(-ENOENT);
-- 
2.40.1

