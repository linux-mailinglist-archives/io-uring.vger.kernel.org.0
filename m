Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF05832D9C9
	for <lists+io-uring@lfdr.de>; Thu,  4 Mar 2021 19:58:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233635AbhCDS5z (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 4 Mar 2021 13:57:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235738AbhCDS5s (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 4 Mar 2021 13:57:48 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD0F9C061764
        for <io-uring@vger.kernel.org>; Thu,  4 Mar 2021 10:56:33 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id e10so28598232wro.12
        for <io-uring@vger.kernel.org>; Thu, 04 Mar 2021 10:56:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=lP9XHHqewsykWU4PNQpzB7zQ56ls52K8dBzx4aMKMfc=;
        b=SPOa9dsTqgAYKkfzrbMGPS58IZxzxF0WjNsEygIbYViHRSfcYL5KJf//Cc1/mtA3c0
         bdAPpz5MQY8Yh/R4KDUOtY8rXI+zVxywpfK2PEvzIiuficd7yoiBPqKt+laJlVjINg6J
         annx/5mGxRRKrEXo5LK1NVNf4NoXxTMMAyJC+ka4NniJLwXzlwsAlA/a8JW3YZVWf3zP
         yGMUyhcY9/hXosnAMAlRt/Qf1cHthaE8M+APAWnJVpD5e+B73lkjRBez+TKqMS1DHYES
         LcuXK8ewAhF6Vdypg8Arvv6lM7vbzzPdSbdA+08A7M0P46zV8oCLLp9zyww8uM7szeW2
         j0/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lP9XHHqewsykWU4PNQpzB7zQ56ls52K8dBzx4aMKMfc=;
        b=FabjIch2Hyr9CrzdDUqaOi8EujoNIBAziDbJQIYe84YpqnN//AqKaZ9AjlLJOxyKBb
         LprGvLRDejmvFb0DcEgHbhE2bCYnVtrGlKVd4zl11YqAch7O8umE7cqPzTqzC8l67tis
         H9Q/EKQAWICv8jq55H7g4ZSez4OrQhTfy5mNmQdM1lovN1GUm51S1eHM9fPeVhmT1nQT
         c39Lg+n3/9LNRuo296Ytkp6bwMnQqHGFdep9HSl/kYFP2yjRMm6WcC3chBAbaD4/FwwK
         VJ/aUEU/ApFtQO7TAfj/MeoE2aKky2lglyfPN7UDIxy+qlNB34aaW1O98sojIoXaf0UU
         tDtg==
X-Gm-Message-State: AOAM533glWhN0/Du5XWGahNRmoj/A23WJEgwoUKyHqpLqn/jlrq0fEfF
        3nTZrWBTn3HmwD+knPkU4jU=
X-Google-Smtp-Source: ABdhPJylgA5vJWiHeAoj7Vq6vbuQH2TxeDEQQBrXrCRfR2cdUnzCsWDs9U8n7GTjjUSkRopE5Da0kA==
X-Received: by 2002:a5d:4203:: with SMTP id n3mr5490250wrq.116.1614884192611;
        Thu, 04 Mar 2021 10:56:32 -0800 (PST)
Received: from localhost.localdomain ([148.252.129.216])
        by smtp.gmail.com with ESMTPSA id k11sm575800wmj.1.2021.03.04.10.56.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Mar 2021 10:56:32 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 07/11] io_uring: keep io_req_free_batch() call locality
Date:   Thu,  4 Mar 2021 18:52:21 +0000
Message-Id: <4d19a3cfa02c12bf3d0cc86fe0cc437a7fac737b.1614883424.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1614883423.git.asml.silence@gmail.com>
References: <cover.1614883423.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Don't do a function call (io_dismantle_req()) in the middle and place it
to near other function calls, otherwise may lead to excessive register
spilling.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 94b080c3cc65..9ebc447456ab 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2052,6 +2052,7 @@ static void io_req_free_batch(struct req_batch *rb, struct io_kiocb *req,
 			      struct io_submit_state *state)
 {
 	io_queue_next(req);
+	io_dismantle_req(req);
 
 	if (req->task != rb->task) {
 		if (rb->task)
@@ -2062,7 +2063,6 @@ static void io_req_free_batch(struct req_batch *rb, struct io_kiocb *req,
 	rb->task_refs++;
 	rb->ctx_refs++;
 
-	io_dismantle_req(req);
 	if (state->free_reqs != ARRAY_SIZE(state->reqs))
 		state->reqs[state->free_reqs++] = req;
 	else
-- 
2.24.0

