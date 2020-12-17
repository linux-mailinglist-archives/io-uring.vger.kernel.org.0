Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBC342DC9EE
	for <lists+io-uring@lfdr.de>; Thu, 17 Dec 2020 01:29:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727146AbgLQA2r (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 16 Dec 2020 19:28:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726908AbgLQA2r (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 16 Dec 2020 19:28:47 -0500
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 264C8C0617A6
        for <io-uring@vger.kernel.org>; Wed, 16 Dec 2020 16:28:07 -0800 (PST)
Received: by mail-wm1-x32b.google.com with SMTP id 190so3973774wmz.0
        for <io-uring@vger.kernel.org>; Wed, 16 Dec 2020 16:28:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=HR2i4x4jE72i2txTdHRE/OaQlAnJGSIGw5F9aI8gQL4=;
        b=kZtjSxMbz3Slcfbop7GDY6ennPi415fm+kCiPX6wRjOLXi2xgfGv0giHqG3v13FuGN
         ZKRMIesNVrqBRAU+dD4QFxChQu9MtaM8OrGvbkPMNWEBfwb0E+azNbl0f2sqRjevR1OC
         mewYYjVAUrOVZspaoNwZDLGjG2V/utgPPdnRM/qb6u6PULkpqUyK8+lH5SffuO8moFsR
         VFtmk+l2PgP0h5A7c9sCe1HFGgPGKbdD348kQyRF9kewrUD2CZk8vWME9kAFbcJCSGC1
         sA30/HeOMTtM7azwVQxHxFuqptqJH/8iMlh1W8OzLk7iArZRKUims3LFXPdED/ASx0Sr
         gsyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HR2i4x4jE72i2txTdHRE/OaQlAnJGSIGw5F9aI8gQL4=;
        b=m3cMdIqD1CSROClK1D/GFPmtdNhoroKScO4T8O7wh5kgRHrUCNZD22g3ZTML5qEUkV
         PKl/H192ZUd6ybX31R4OoHN8rV7ZSWSFmXGeWsJX+bjeDITcvILvTcbjL5T/+alAjUwL
         BQbZincQ988DfyRbMLJJrEJ5YqYqlybep+9CG6b6jdO8ipymZ/e2aLz0E+9oZh9ptcdM
         YlBUnve12rAq7M9e3+IbiO4mtshIEU6eGUFf1E0lnaNfstiuXpJtJ3c4UIEXy6btVFiA
         +QXOIywXrR0yqVxJb5IiuVmqdL9NR3bmzMRJIz5WNWWYurRFg9k0wqPpLCoha8iSaYMD
         dz8g==
X-Gm-Message-State: AOAM530AkYs3KsVbqqcw+/AnBLZycywuqD0hG3QV9qR6OsE60f33qxUj
        uj/55ZG5dGel6LlTJRfFk20=
X-Google-Smtp-Source: ABdhPJxuctXpl2Z4NJ5iZnTAhpX3UwbXTx9U6pFF1mXtNbsATkveXj84KMCSXh4z23vPxSQa3K3sQg==
X-Received: by 2002:a7b:c24b:: with SMTP id b11mr5866511wmj.168.1608164885967;
        Wed, 16 Dec 2020 16:28:05 -0800 (PST)
Received: from localhost.localdomain ([185.69.144.225])
        by smtp.gmail.com with ESMTPSA id h29sm5711161wrc.68.2020.12.16.16.28.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Dec 2020 16:28:05 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 2/5] io_uring: remove racy overflow list fast checks
Date:   Thu, 17 Dec 2020 00:24:36 +0000
Message-Id: <c284b5b13c54615ae8d041f1482d0bd7cabca654.1608164394.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1608164394.git.asml.silence@gmail.com>
References: <cover.1608164394.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

list_empty_careful() is not racy only if some conditions are met, i.e.
no re-adds after del_init. io_cqring_overflow_flush() does list_move(),
so it's actually racy.

Remove those checks, we have ->cq_check_overflow for the fast path.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 7115147a25a8..3c8134be4a05 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1725,8 +1725,6 @@ static bool io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool force,
 	LIST_HEAD(list);
 
 	if (!force) {
-		if (list_empty_careful(&ctx->cq_overflow_list))
-			return true;
 		if ((ctx->cached_cq_tail - READ_ONCE(rings->cq.head) ==
 		    rings->cq_ring_entries))
 			return false;
@@ -6831,8 +6829,7 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr)
 
 	/* if we have a backlog and couldn't flush it all, return BUSY */
 	if (test_bit(0, &ctx->sq_check_overflow)) {
-		if (!list_empty(&ctx->cq_overflow_list) &&
-		    !io_cqring_overflow_flush(ctx, false, NULL, NULL))
+		if (!io_cqring_overflow_flush(ctx, false, NULL, NULL))
 			return -EBUSY;
 	}
 
-- 
2.24.0

