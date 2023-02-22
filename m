Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87EDE69F6A4
	for <lists+io-uring@lfdr.de>; Wed, 22 Feb 2023 15:35:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229749AbjBVOfD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 22 Feb 2023 09:35:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229673AbjBVOfB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 22 Feb 2023 09:35:01 -0500
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6E1639CD3
        for <io-uring@vger.kernel.org>; Wed, 22 Feb 2023 06:35:00 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id o4-20020a05600c4fc400b003e1f5f2a29cso6550951wmq.4
        for <io-uring@vger.kernel.org>; Wed, 22 Feb 2023 06:35:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=f3HiHBL+y+RgdCTvyi/fYxznhYJXTO+AV3o9Tm22wDw=;
        b=Y+gI5JDjcCth7jm2hsxm0ZU9tN+GWw1gEMPAOvp95+ImUCK7OVvdcYrAfhYNRPA1wk
         VxjJtz+t1Vd4Q7/3EYxejs90lXWmenoIMTS1ib0M+k3pOzbbYk68BxmoKTq5puAAgZaE
         wOsBIcnUsdn0dQ9h5yUdB5OLvmHrGUMK+2taaBdxqUj/Fu2E+Mmrkmh8AaXvzMsAAIJ6
         +ypWlKy5RlwqXEpPiOdPyj5unhHNuqfr6XUYE+d6f2Zmf6ulXYwMNyhrPWHH+q4KuMJA
         vSKi8aRc+4v3Kt1aw+FC7jHyJuSjFuVGP1t3gtbEcryj6iP6Gb6t+inK5TgAdLqV9xwH
         /niw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=f3HiHBL+y+RgdCTvyi/fYxznhYJXTO+AV3o9Tm22wDw=;
        b=A0JfRJLommnr3Zwk/xdCHbnlWii4eC/bvSqHWJXcVZdHZ5iT/v7SYpQJ8x6leb0MyP
         Z3bFlVwUL8wma5jlvU3uvL24D5f0MF80MXxvtYCSZWkwJJ4Ry9EsTghMU2JyPvaq22Iu
         aTEmXtauQWtMKyCU0I1NV0Vd36uhD/MrVzZJYHe5N2cWyBDHxYoHRfEYDvKxgOJOkvcQ
         FdhBR3zaqfk4SV2ZyKeQyjGeEGbvPq3n7NXU6rU+luTfZhWwvAigqN5UylrhKJ+WBUjM
         3LC3YPulP4Ps2iZC6GH8ElDxc7RS4H92e9E/ia4+j248wLemtgyyWuaLbXWEiwGVr7DD
         6+5w==
X-Gm-Message-State: AO0yUKUTQdXtHIyhNVmwI+BZnoBVpEa2TL+y7fJDkFU/U+c7lMhj7Y2x
        5nZHyqKblBnGxBEiSQNXOqNiMIPoxK0=
X-Google-Smtp-Source: AK7set+XiY0enm9zK4moSTDTvxNDTRCPp2uOFirwiD2rc+fYq587lbwNx4qaS9aBhVY2SLkJi0I80A==
X-Received: by 2002:a05:600c:16c8:b0:3dc:5950:b358 with SMTP id l8-20020a05600c16c800b003dc5950b358mr311690wmn.14.1677076499165;
        Wed, 22 Feb 2023 06:34:59 -0800 (PST)
Received: from 127.0.0.1localhost (94.196.95.64.threembb.co.uk. [94.196.95.64])
        by smtp.gmail.com with ESMTPSA id y24-20020a1c4b18000000b003e22508a343sm8565282wma.12.2023.02.22.06.34.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Feb 2023 06:34:58 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next] io_uring: remove unused wq_list_merge
Date:   Wed, 22 Feb 2023 14:32:43 +0000
Message-Id: <5f9ad0301949213230ad9000a8359d591aae615a.1677002255.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

There are no users of wq_list_merge, kill it.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/slist.h | 22 ----------------------
 1 file changed, 22 deletions(-)

diff --git a/io_uring/slist.h b/io_uring/slist.h
index f27601fa4660..7c198a40d5f1 100644
--- a/io_uring/slist.h
+++ b/io_uring/slist.h
@@ -27,28 +27,6 @@ static inline void wq_list_add_after(struct io_wq_work_node *node,
 		list->last = node;
 }
 
-/**
- * wq_list_merge - merge the second list to the first one.
- * @list0: the first list
- * @list1: the second list
- * Return the first node after mergence.
- */
-static inline struct io_wq_work_node *wq_list_merge(struct io_wq_work_list *list0,
-						    struct io_wq_work_list *list1)
-{
-	struct io_wq_work_node *ret;
-
-	if (!list0->first) {
-		ret = list1->first;
-	} else {
-		ret = list0->first;
-		list0->last->next = list1->first;
-	}
-	INIT_WQ_LIST(list0);
-	INIT_WQ_LIST(list1);
-	return ret;
-}
-
 static inline void wq_list_add_tail(struct io_wq_work_node *node,
 				    struct io_wq_work_list *list)
 {
-- 
2.39.1

