Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B135C3A5B5B
	for <lists+io-uring@lfdr.de>; Mon, 14 Jun 2021 03:36:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232076AbhFNBi7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 13 Jun 2021 21:38:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232269AbhFNBi6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 13 Jun 2021 21:38:58 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52C64C061574
        for <io-uring@vger.kernel.org>; Sun, 13 Jun 2021 18:36:46 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id b145-20020a1c80970000b029019c8c824054so11848488wmd.5
        for <io-uring@vger.kernel.org>; Sun, 13 Jun 2021 18:36:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=rWVbMxWyymLy321d2DxnFWpmxGEFqrTiR1ltRfTYo8U=;
        b=fx1Zt9ijLNnlkGcWXyiuNE/Uv1A+b+CqUM70MmNxPk6GV7hUrXenBSdE4oYExuZ+rY
         P2ZOtI0fmqYWcaXCvDo96PACq5NX62c8e8bcZ62PjtA7RkHbsJu0Aydojtn05KxpBlcL
         rL2axPK6i0zK5BGNzQVwXDo1CIgRGFmm6PsWcKczoFbVyAKRRk6lZ98HRPNi4/5WaxU9
         qkdF4eSVqNGAe9F88IStGV3qJ6CWIYYDnbaIK4BFSoEgIG7R6EVa0eic2nadOuNgbkow
         NPMHKG6WMajxGi+A+rNB+PlQUiVThQnxZDkxYLzq7KG90pcO0ua0mrPIQdoDN9xx0d6t
         j/Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rWVbMxWyymLy321d2DxnFWpmxGEFqrTiR1ltRfTYo8U=;
        b=O35g5cBOudgOSncN6C2JRez7LHP0SU74QqeYODGXVjb6QIUNwnwUWHfNHFwQtb87zo
         pAP3XVBn7YD8n9HwsmoeJERO7soGgOBkQ4BkUnBdR3758HvfxhPbtYFcO98ti7bsaDnf
         /IFX4zDmT9XhVl7jAOW3Ut9Pp/99DR4kVcPAzmTbp9tiJxYfNToRagJORjILhe5iw/YA
         y5mB3+1NE8TFBJRN/tBi1SaJoIr0onjNVhGxtjhQeobkS9T/MfT5fnWOTNzFURxAfNpL
         30m2HAJWFAYSOt+uAuoHRq3kDSnD2DJ+lTMyYYRnACDP2aN/ryRPdMCaELO4WyOeozvC
         5cCg==
X-Gm-Message-State: AOAM533d+RzPtGL7qega+wSERGDHOdmYzYrMogMbjmzjcENRuy6dWOmw
        ihxvnAqlp1jOgLMYD3j/LTbwuRtQU0Jmxg==
X-Google-Smtp-Source: ABdhPJwoEfhhAXRJrkTqCK3RGkm+iuyKrORbjRN3krdCAn5MDEhM3/lQpNgjkSYt/TcqJNQRpF0eWw==
X-Received: by 2002:a1c:e343:: with SMTP id a64mr13998269wmh.114.1623634604898;
        Sun, 13 Jun 2021 18:36:44 -0700 (PDT)
Received: from localhost.localdomain ([85.255.237.119])
        by smtp.gmail.com with ESMTPSA id a9sm6795291wrv.37.2021.06.13.18.36.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Jun 2021 18:36:44 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 01/13] io-wq: embed wqe ptr array into struct io_wq
Date:   Mon, 14 Jun 2021 02:36:12 +0100
Message-Id: <1482c6a001923bbed662dc38a8a580fb08b1ed8c.1623634181.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1623634181.git.asml.silence@gmail.com>
References: <cover.1623634181.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io-wq keeps an array of pointers to struct io_wqe, allocate this array
as a part of struct io-wq, it's easier to code and saves an extra
indirection for nearly each io-wq call.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io-wq.c | 15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index b3e8624a37d0..1ca98fc7d52b 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -102,7 +102,6 @@ struct io_wqe {
  * Per io_wq state
   */
 struct io_wq {
-	struct io_wqe **wqes;
 	unsigned long state;
 
 	free_work_fn *free_work;
@@ -118,6 +117,8 @@ struct io_wq {
 	struct hlist_node cpuhp_node;
 
 	struct task_struct *task;
+
+	struct io_wqe *wqes[];
 };
 
 static enum cpuhp_state io_wq_online;
@@ -907,17 +908,12 @@ struct io_wq *io_wq_create(unsigned bounded, struct io_wq_data *data)
 	if (WARN_ON_ONCE(!data->free_work || !data->do_work))
 		return ERR_PTR(-EINVAL);
 
-	wq = kzalloc(sizeof(*wq), GFP_KERNEL);
+	wq = kzalloc(struct_size(wq, wqes, nr_node_ids), GFP_KERNEL);
 	if (!wq)
 		return ERR_PTR(-ENOMEM);
-
-	wq->wqes = kcalloc(nr_node_ids, sizeof(struct io_wqe *), GFP_KERNEL);
-	if (!wq->wqes)
-		goto err_wq;
-
 	ret = cpuhp_state_add_instance_nocalls(io_wq_online, &wq->cpuhp_node);
 	if (ret)
-		goto err_wqes;
+		goto err_wq;
 
 	refcount_inc(&data->hash->refs);
 	wq->hash = data->hash;
@@ -962,8 +958,6 @@ struct io_wq *io_wq_create(unsigned bounded, struct io_wq_data *data)
 	cpuhp_state_remove_instance_nocalls(io_wq_online, &wq->cpuhp_node);
 	for_each_node(node)
 		kfree(wq->wqes[node]);
-err_wqes:
-	kfree(wq->wqes);
 err_wq:
 	kfree(wq);
 	return ERR_PTR(ret);
@@ -1036,7 +1030,6 @@ static void io_wq_destroy(struct io_wq *wq)
 		kfree(wqe);
 	}
 	io_wq_put_hash(wq->hash);
-	kfree(wq->wqes);
 	kfree(wq);
 }
 
-- 
2.31.1

