Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E7DB6E32AA
	for <lists+io-uring@lfdr.de>; Sat, 15 Apr 2023 18:59:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230117AbjDOQ7d (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 15 Apr 2023 12:59:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230099AbjDOQ7b (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 15 Apr 2023 12:59:31 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF6B42D73;
        Sat, 15 Apr 2023 09:59:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1681577964;
        bh=1HH1sIzyttjvQASCsqW0jgwLWUwEbTPpuWqZnbijq/w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=qb2BIxW8QpC8r13B8e90DEP8nr0o+UZXO29J6oTUidco+3YRU9XxxtwVOsyn7mBVM
         mQl3HD/B0jh4lmIydIJyHsiNkDt3OKiPI3S+r+KrIV1211PraAZ+gORvTLXbUOnFoQ
         6og34vaFtvVSgUPZNoYxphrQdFuxKK+EsgUTkAvViqkdj06BMbjIkC71BYIRlaBF8b
         Nqt4RDHo7OT9CB5rU7wQ5barDHeTu695P0I5NXM2W0zSI8+m5Q3s/bxDkqVLOx6VEd
         3G2BxQyejemTIzzmlHzMYvLGwTPojnf3DxdPLH/rQ7slxsWh8WtsS7UZaxn+zb9e53
         KFcnHtQwMm1WQ==
Received: from localhost.localdomain (unknown [182.253.88.211])
        by gnuweeb.org (Postfix) with ESMTPSA id D47ED245532;
        Sat, 15 Apr 2023 23:59:21 +0700 (WIB)
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>
Subject: [PATCH liburing 3/3] man/io_uring_cqe_get_data.3: Fix a misleading return value
Date:   Sat, 15 Apr 2023 23:59:04 +0700
Message-Id: <20230415165904.791841-4-ammarfaizi2@gnuweeb.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230415165904.791841-1-ammarfaizi2@gnuweeb.org>
References: <20230415165904.791841-1-ammarfaizi2@gnuweeb.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Since commit 8ecd3fd959634df8 ("Don't clear sqe->user_data as part of
command prep"), the prep functions no longer zero the user data. If the
user_data is not set, it will contain whatever previous value in it.

Therefore, the returned value when the user_data is-not-set is not
always NULL. And oh, someone once hit an issue because they assume the
return value is NULL if the user_data is not set. See the link below.

Fix the manpage, tell that the return value will be undefined.

Link: https://github.com/axboe/liburing/issues/575#issuecomment-1110516140
Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 man/io_uring_cqe_get_data.3 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/man/io_uring_cqe_get_data.3 b/man/io_uring_cqe_get_data.3
index 4cbb32cd864e12c2..a4d2988a49d92aa8 100644
--- a/man/io_uring_cqe_get_data.3
+++ b/man/io_uring_cqe_get_data.3
@@ -46,7 +46,7 @@ or
 If the
 .I user_data
 value has been set before submitting the request, it will be returned.
-Otherwise the functions returns NULL.
+Otherwise, the return value is undefined.
 .SH SEE ALSO
 .BR io_uring_get_sqe (3),
 .BR io_uring_sqe_set_data (3),
-- 
Ammar Faizi

