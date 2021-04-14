Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B52035F428
	for <lists+io-uring@lfdr.de>; Wed, 14 Apr 2021 14:46:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233225AbhDNMnT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 14 Apr 2021 08:43:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233558AbhDNMnS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 14 Apr 2021 08:43:18 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CE57C061756
        for <io-uring@vger.kernel.org>; Wed, 14 Apr 2021 05:42:56 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id k26so3327111wrc.8
        for <io-uring@vger.kernel.org>; Wed, 14 Apr 2021 05:42:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=VI1fw/7EK9qWyY0VWzJLFtkCSBonMMUYXtzaKXPeiKA=;
        b=UUE2o125EoptRWPjKsGgUVjqTwTIPycPXqWqTiaamfH1yuFaH91kwimA7feHnxrTxP
         v3DaLYfiC7uCgWsi1i9xe6cxsABXtVeQXbqXMd7K1SMhUT+UEgBT+gtT+huJ3YaT6am2
         oOlALg6cboIxybaCZPTmL+cnbpvHXB8AKYdAolLxgf+5NDtwuyJCM1eSeWKpkRrNQjvK
         7Zu3W+GVKMuxUgjHmqisvKhY2O0ykBarG/FupDqlNZBSGv1l+iSpgPPX8XnRGwwWdZnW
         /kC2FBu2rwNlU80XFxkEGAvomTHBUxjxKlpXp4OWr2LqSIDfuEpdD/F6bbOCcBxAZvxd
         78Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VI1fw/7EK9qWyY0VWzJLFtkCSBonMMUYXtzaKXPeiKA=;
        b=Tx/wgLPILIgkUDJY660lTf127+dvSjTbz3iLJ1UKbA+t2vttuIkz08rGhCG3uXjf8O
         EU+8u3FRK97F1q4HQKrTIB9yHbn5s7qnngnksWH0UAwU2A02rgnCEckA+5qJS8K8jnNC
         JB2Gi0UBxb53bsC0SmWVXVOoDWJjeVgIFw19sbdLJ0z+YK8+GWlzntCOCWhztzozykl5
         cM1SE/tTr1OaYFoVb4oK/dgwMZyoUZetJRZp+9UrOzNeQuf+SI2A02HSaZHBmIY87OYl
         htD50jVg+uF7DGbKEJXztR+VD/RlHnjcqeZMAhvOoJOvM86xWPJwGRT7X0SaMF+E7LEE
         5g0w==
X-Gm-Message-State: AOAM53119D3JbLD9IG7W+yVpARRzS9hBdvCUgDEBWJsUL5I8Z/NRAnAJ
        tJINlreqvr8ZFgHERy4FR0gmOrjbJ21aCQ==
X-Google-Smtp-Source: ABdhPJzxYvWN+aEJcw/oCfMeFEPEMjFD2awy+kb72XBPF2VtIItmv1YGMX4Nrp2gQEd2P13qbaWE5w==
X-Received: by 2002:a5d:5308:: with SMTP id e8mr28138777wrv.41.1618404174916;
        Wed, 14 Apr 2021 05:42:54 -0700 (PDT)
Received: from localhost.localdomain ([185.69.144.37])
        by smtp.gmail.com with ESMTPSA id f2sm5179912wmp.20.2021.04.14.05.42.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Apr 2021 05:42:54 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v2 2/5] io_uring: refactor io_ring_exit_work()
Date:   Wed, 14 Apr 2021 13:38:34 +0100
Message-Id: <8042ff02416ca0ced8305c30417b635c59ac570a.1618403742.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1618403742.git.asml.silence@gmail.com>
References: <cover.1618403742.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Don't reinit io_ring_exit_work()'s exit work/completions on each
iteration, that's wasteful. Also add list_rotate_left(), so if we failed
to complete the task job, we don't try it again and again but defer it
until others are processed.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 693fb5c5e58c..6a70bf455c49 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8601,6 +8601,9 @@ static void io_ring_exit_work(struct work_struct *work)
 		WARN_ON_ONCE(time_after(jiffies, timeout));
 	} while (!wait_for_completion_timeout(&ctx->ref_comp, HZ/20));
 
+	init_completion(&exit.completion);
+	init_task_work(&exit.task_work, io_tctx_exit_cb);
+	exit.ctx = ctx;
 	/*
 	 * Some may use context even when all refs and requests have been put,
 	 * and they are free to do so while still holding uring_lock or
@@ -8613,9 +8616,8 @@ static void io_ring_exit_work(struct work_struct *work)
 
 		node = list_first_entry(&ctx->tctx_list, struct io_tctx_node,
 					ctx_node);
-		exit.ctx = ctx;
-		init_completion(&exit.completion);
-		init_task_work(&exit.task_work, io_tctx_exit_cb);
+		/* don't spin on a single task if cancellation failed */
+		list_rotate_left(&ctx->tctx_list);
 		ret = task_work_add(node->task, &exit.task_work, TWA_SIGNAL);
 		if (WARN_ON_ONCE(ret))
 			continue;
@@ -8623,7 +8625,6 @@ static void io_ring_exit_work(struct work_struct *work)
 
 		mutex_unlock(&ctx->uring_lock);
 		wait_for_completion(&exit.completion);
-		cond_resched();
 		mutex_lock(&ctx->uring_lock);
 	}
 	mutex_unlock(&ctx->uring_lock);
-- 
2.24.0

