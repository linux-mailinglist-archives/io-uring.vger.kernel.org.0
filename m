Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 661753ABA62
	for <lists+io-uring@lfdr.de>; Thu, 17 Jun 2021 19:14:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232079AbhFQRQw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 17 Jun 2021 13:16:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232041AbhFQRQw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 17 Jun 2021 13:16:52 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FB0CC06175F
        for <io-uring@vger.kernel.org>; Thu, 17 Jun 2021 10:14:44 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id c84so3894961wme.5
        for <io-uring@vger.kernel.org>; Thu, 17 Jun 2021 10:14:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=ILuax7lV370NTQfwMHhlkPTxBiuXT196yG6iGKDaQJk=;
        b=vOtKmRU7ffULnVC0LZI7UFLTvKgI8EYa1qsQcaqJIUtfV0z+Ce71YwoMKkQzZYZLEB
         UkbWIlAjCh62fiiiv+cVlLDTDDpS7uPr78xdAHvUQwmsJKP4/u9IKrUwkl5kKA3PvgDi
         9wkff4PA+d48rT5QKe9lfhxw5LVQrmLEUJSIHPMDgwwpylwNAOQYQ46tE9vFLC96XhhP
         yVJbUGSGKLqhx1WMrbP072Boq5rSz4JJs3RIJ8sIF1Li2XQpFvrllrKHGqSQQdlX2/Ph
         58UpjvMt/p0WFAqrOTm1MNUCCayuTk2HqZerJzmBHYgFp1Ro8GAMe7Febw+y2iGdlpLy
         yVZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ILuax7lV370NTQfwMHhlkPTxBiuXT196yG6iGKDaQJk=;
        b=pfxkmDzr51Khy2om2FrrYodztFzShicWqKp3feXnIwlXrqNGVYRDFgo1bPJi2aGFPF
         kbHysvtidqP7Aq9rO5kgFtYAQhhaF726AN7c64Ns0dPcWYYzHBbJPZWaiJTjUGRmbAQ0
         rBgr4ViFJa6+FQFrAKImcHpMUpUsHUJKbgy1NZYVCVOGmpMzEwuuzNsuCy6va4y7pre3
         /O+5x11nnHUE3cRS2vMl4l6hQ5WVws+dCUhRuwR2RAah2XtkCBXM3+ux/QE3FsXMhov/
         hY70gnqNHgfqKpn1SrA2lgtuG3O/Q/+AOHXV0Tc/gOxjcqIK9KTNQDcOpRSBmFUmraRU
         dqwg==
X-Gm-Message-State: AOAM5327IHGwqpWrgH10QCsYORsQhEMA3tOl6dv/d0ZUV5ozRFkAY7NU
        SNda45NrEMt21jeU4lYaFsk=
X-Google-Smtp-Source: ABdhPJxIaji77d9WD2pmC2Lv04MVLAFhvER07cMvKhteX6o03UK0GYkB/KG+No22DUHZq6i/Agj2fw==
X-Received: by 2002:a05:600c:3658:: with SMTP id y24mr6255046wmq.6.1623950082939;
        Thu, 17 Jun 2021 10:14:42 -0700 (PDT)
Received: from localhost.localdomain ([148.252.132.93])
        by smtp.gmail.com with ESMTPSA id g17sm6208033wrp.61.2021.06.17.10.14.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Jun 2021 10:14:42 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 10/12] io_uring: refactor tctx task_work list splicing
Date:   Thu, 17 Jun 2021 18:14:08 +0100
Message-Id: <d076c83fedb8253baf43acb23b8fafd7c5da1714.1623949695.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1623949695.git.asml.silence@gmail.com>
References: <cover.1623949695.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We don't need a full copy of tctx->task_list in tctx_task_work(), but
only a first one, so just assign node directly.

Taking into account that task_works are run in a context of a task,
it's very unlikely to first see non-empty tctx->task_list and then
splice it empty, can only happen with task_work cancellations that is
not-normal slow path anyway. Hence, get rid of the check in the end,
it's there not for validity but "performance" purposes.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index f31f00c6e829..31afe25596d7 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1897,15 +1897,13 @@ static void tctx_task_work(struct callback_head *cb)
 	clear_bit(0, &tctx->task_state);
 
 	while (!wq_list_empty(&tctx->task_list)) {
-		struct io_wq_work_list list;
 		struct io_wq_work_node *node;
 
 		spin_lock_irq(&tctx->task_lock);
-		list = tctx->task_list;
+		node = tctx->task_list.first;
 		INIT_WQ_LIST(&tctx->task_list);
 		spin_unlock_irq(&tctx->task_lock);
 
-		node = list.first;
 		while (node) {
 			struct io_wq_work_node *next = node->next;
 			struct io_kiocb *req = container_of(node, struct io_kiocb,
@@ -1919,9 +1917,6 @@ static void tctx_task_work(struct callback_head *cb)
 			req->task_work.func(&req->task_work);
 			node = next;
 		}
-
-		if (!list.first)
-			break;
 		cond_resched();
 	}
 
-- 
2.31.1

