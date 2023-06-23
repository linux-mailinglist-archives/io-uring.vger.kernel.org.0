Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 911C073BD1D
	for <lists+io-uring@lfdr.de>; Fri, 23 Jun 2023 18:49:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232617AbjFWQtQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 23 Jun 2023 12:49:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232508AbjFWQs1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 23 Jun 2023 12:48:27 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A7BF294E
        for <io-uring@vger.kernel.org>; Fri, 23 Jun 2023 09:48:18 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id 41be03b00d2f7-51f64817809so79192a12.1
        for <io-uring@vger.kernel.org>; Fri, 23 Jun 2023 09:48:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1687538897; x=1690130897;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=O6FRdfzJJ3IE7HGRCoH2KJs1eNi5bWS6uTcalNvOlHo=;
        b=JPeKt05L98dx42eDLG5Vv349LtnqlOWFBN9fTLOCcg85Rzeeu2PMgqI9kC9UOkrAtS
         7hOwLz8dDqE42pcWvvTDhb5Y97V+t5hL3C5n1FGYqIhcx1K42R8/p1fP+7EmSKaMGFqJ
         ItPpNVwuNkdrIbzY/cp/HaUJVAQjPeBUoSWjwdLEFik3RWZfbyPS9ZUwkoacq5pdY+uL
         Pp8ZcBPPYMiQz3u/5jLT6rxrmYZbNsSaK4OsWBl7KI77YFszYpSedR8E/cZup2Oj5ogF
         eEITKt61Df5sFyIley9S9VWeNkyThuoVbd9vDrRfnqEYB+0pK+6ZMGXWdR1hA/eBnGu8
         HGxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687538897; x=1690130897;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=O6FRdfzJJ3IE7HGRCoH2KJs1eNi5bWS6uTcalNvOlHo=;
        b=jdCiPe5M7JRjfsipedqjlk68KNh3kNHrGemITKAtluylO7JimCiHdWai4lfls8jdyL
         Iq5JKusSJ7vNuMnaJpsfte7ZyzQ6ZhnvDtrEFNjbITkOxGw8A3kOV3kaZ0In1xjmMJdV
         kkM5ckvo6MMoW6tkSsNMa2WYKSjY6ogQKWSRYsIiShATGOMwhLSOIFPVYaSruowE26AO
         KVKfd4DqcXtNmpww9OdgcWWJwxHm/AKpLm7tkUTAsbTYU6bwwY+mJ9+Fet+aVDjMaTR3
         WLBC+zX+z5TOaHPh361nlUtT8xezEaZISRXxlhdu2ePl3qennxHPSzZQnKDM/NL7BJ5m
         OAlA==
X-Gm-Message-State: AC+VfDwMMkDit+rD1UYn+4qAXqzbWvYoghvkSfJMyhcz2kSsMM0msF/1
        +4pCEpf0Gdqh49ELaincLCkgzVzjkP4Ox9H2Prk=
X-Google-Smtp-Source: ACHHUZ7lTe4YFuu3KCZxRvCWJQ7UGhP5PBcYCU0m50HpHVQOYSXhNsuFTiPCNDsgYAWRA52zG4dyDQ==
X-Received: by 2002:a17:903:32c4:b0:1b3:e352:6d88 with SMTP id i4-20020a17090332c400b001b3e3526d88mr26730004plr.6.1687538897416;
        Fri, 23 Jun 2023 09:48:17 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id n4-20020a170903110400b001b55c0548dfsm7454411plh.97.2023.06.23.09.48.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Jun 2023 09:48:16 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6/8] io_uring/cancel: add IORING_ASYNC_CANCEL_USERDATA
Date:   Fri, 23 Jun 2023 10:48:02 -0600
Message-Id: <20230623164804.610910-7-axboe@kernel.dk>
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

Add a flag to explicitly match on user_data in the request for
cancelation purposes. This is the default behavior if none of the
other match flags are set, but if we ALSO want to match on user_data,
then this flag can be set.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/uapi/linux/io_uring.h |  2 ++
 io_uring/cancel.c             | 18 ++++++++++++------
 2 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index f222d263bc55..e8bf70610568 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -297,11 +297,13 @@ enum io_uring_op {
  *				request 'user_data'
  * IORING_ASYNC_CANCEL_ANY	Match any request
  * IORING_ASYNC_CANCEL_FD_FIXED	'fd' passed in is a fixed descriptor
+ * IORING_ASYNC_CANCEL_USERDATA	Match on user_data, default for no other key
  */
 #define IORING_ASYNC_CANCEL_ALL	(1U << 0)
 #define IORING_ASYNC_CANCEL_FD	(1U << 1)
 #define IORING_ASYNC_CANCEL_ANY	(1U << 2)
 #define IORING_ASYNC_CANCEL_FD_FIXED	(1U << 3)
+#define IORING_ASYNC_CANCEL_USERDATA	(1U << 4)
 
 /*
  * send/sendmsg and recv/recvmsg flags (sqe->ioprio)
diff --git a/io_uring/cancel.c b/io_uring/cancel.c
index bf44563d687d..20612e93a354 100644
--- a/io_uring/cancel.c
+++ b/io_uring/cancel.c
@@ -25,24 +25,30 @@ struct io_cancel {
 };
 
 #define CANCEL_FLAGS	(IORING_ASYNC_CANCEL_ALL | IORING_ASYNC_CANCEL_FD | \
-			 IORING_ASYNC_CANCEL_ANY | IORING_ASYNC_CANCEL_FD_FIXED)
+			 IORING_ASYNC_CANCEL_ANY | IORING_ASYNC_CANCEL_FD_FIXED | \
+			 IORING_ASYNC_CANCEL_USERDATA)
 
 /*
  * Returns true if the request matches the criteria outlined by 'cd'.
  */
 bool io_cancel_req_match(struct io_kiocb *req, struct io_cancel_data *cd)
 {
+	bool match_user_data = cd->flags & IORING_ASYNC_CANCEL_USERDATA;
+
 	if (req->ctx != cd->ctx)
 		return false;
-	if (cd->flags & IORING_ASYNC_CANCEL_ANY) {
+
+	if (!(cd->flags & (IORING_ASYNC_CANCEL_FD)))
+		match_user_data = true;
+
+	if (cd->flags & IORING_ASYNC_CANCEL_ANY)
 		goto check_seq;
-	} else if (cd->flags & IORING_ASYNC_CANCEL_FD) {
+	if (cd->flags & IORING_ASYNC_CANCEL_FD) {
 		if (req->file != cd->file)
 			return false;
-	} else {
-		if (req->cqe.user_data != cd->data)
-			return false;
 	}
+	if (match_user_data && req->cqe.user_data != cd->data)
+		return false;
 	if (cd->flags & IORING_ASYNC_CANCEL_ALL) {
 check_seq:
 		if (cd->seq == req->work.cancel_seq)
-- 
2.40.1

