Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4415A3A5B5A
	for <lists+io-uring@lfdr.de>; Mon, 14 Jun 2021 03:36:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232279AbhFNBi6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 13 Jun 2021 21:38:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232230AbhFNBi6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 13 Jun 2021 21:38:58 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D519C061767
        for <io-uring@vger.kernel.org>; Sun, 13 Jun 2021 18:36:47 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id a20so12651122wrc.0
        for <io-uring@vger.kernel.org>; Sun, 13 Jun 2021 18:36:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=gnE4iMn5O7WEqGGm2Cpxsf3iD+XKIjbR6rfDYDEVwcQ=;
        b=O+hO4t92ldZpP4PmGv9CwsamT8bi12fPo+bpDqtHTukk4TyKetoaV2Zo4SlP/oEubt
         7ziXzvK4Tufu5v1gDQN0tG8dqAUC+o/+5Y7OgIHo1uXZbhUtRE/3giy9Exjqb98YmQW/
         WJLuzQY31OwyIimKy5unAwqRLfXmkqUpznWH+uHyCuGPDp0FY+IEZlRH7dKmprLV3via
         QJydLlTrCYA33ETrevedyoj0rIR/moL8Wa8QQYPDC67m0jBqybDRBxWv/uK4ewLuxaFY
         V0aCvXu7gDHJPKYv3XLF1LyZsvDAc7uISghgnlRa57LSbjImwwN1eXY9Lymo2HA4wuK8
         TYjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gnE4iMn5O7WEqGGm2Cpxsf3iD+XKIjbR6rfDYDEVwcQ=;
        b=mlq4cPCJJ0QK+/NUDMJeKnisg8zPVUsXGEFS+lWCRIw53i8tLRDerYiTiyiS34OKOW
         YkPDeMVDaPXL9cJfTW82F5LZE/y5M9NJlZZ4QmZp+C5TOv3GAcFvsVrsCxjCYQZFhSx8
         2W3Q/CBp7yaNVrBdJJIru7UBEBFLF2dndEi/v0s94qhvQnoMCKYoEogYYFBht2mvjigO
         JprAhAkMsW1aLZDAf/LilJ7mGSjU0srJj8sswlxmec3AKPE/iMbMCms/0gH1Znu9l9sL
         V8NHn0ZqqFrE7hMyzRZAyYkvA+W2ohJ7q6j8eni43+AvljqKQdG6M+48VY4MWnwcejmq
         cJOw==
X-Gm-Message-State: AOAM533c6YpY71Bj+AVApyHHgyLDTleVCm4MSuQ6vaCC8SSN6AAr+rpD
        0gutz5mF7XgUAKx9YGNDezc=
X-Google-Smtp-Source: ABdhPJzRagXrbo4519kr2JM4Cb5lhaYFa5uwy1Dsr7z15dhAVVS+tJ/yDXVGPjjtlRUzyCAcpISPkQ==
X-Received: by 2002:adf:c18a:: with SMTP id x10mr15916797wre.193.1623634605914;
        Sun, 13 Jun 2021 18:36:45 -0700 (PDT)
Received: from localhost.localdomain ([85.255.237.119])
        by smtp.gmail.com with ESMTPSA id a9sm6795291wrv.37.2021.06.13.18.36.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Jun 2021 18:36:45 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 02/13] io-wq: remove unused io-wq refcounting
Date:   Mon, 14 Jun 2021 02:36:13 +0100
Message-Id: <401007393528ea7c102360e69a29b64498e15db2.1623634181.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1623634181.git.asml.silence@gmail.com>
References: <cover.1623634181.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

iowq->refs is initialised to one and killed on exit, so it's not used
and we can kill it.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io-wq.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index 1ca98fc7d52b..f058ea0bcae8 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -109,8 +109,6 @@ struct io_wq {
 
 	struct io_wq_hash *hash;
 
-	refcount_t refs;
-
 	atomic_t worker_refs;
 	struct completion worker_done;
 
@@ -949,7 +947,6 @@ struct io_wq *io_wq_create(unsigned bounded, struct io_wq_data *data)
 	}
 
 	wq->task = get_task_struct(data->task);
-	refcount_set(&wq->refs, 1);
 	atomic_set(&wq->worker_refs, 1);
 	init_completion(&wq->worker_done);
 	return wq;
@@ -1038,8 +1035,7 @@ void io_wq_put_and_exit(struct io_wq *wq)
 	WARN_ON_ONCE(!test_bit(IO_WQ_BIT_EXIT, &wq->state));
 
 	io_wq_exit_workers(wq);
-	if (refcount_dec_and_test(&wq->refs))
-		io_wq_destroy(wq);
+	io_wq_destroy(wq);
 }
 
 static bool io_wq_worker_affinity(struct io_worker *worker, void *data)
-- 
2.31.1

