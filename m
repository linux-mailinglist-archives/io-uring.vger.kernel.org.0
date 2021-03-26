Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22F6934ABF5
	for <lists+io-uring@lfdr.de>; Fri, 26 Mar 2021 16:53:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231201AbhCZPwv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 26 Mar 2021 11:52:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230070AbhCZPwQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 26 Mar 2021 11:52:16 -0400
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B215EC0613B2
        for <io-uring@vger.kernel.org>; Fri, 26 Mar 2021 08:52:16 -0700 (PDT)
Received: by mail-il1-x130.google.com with SMTP id d2so5381499ilm.10
        for <io-uring@vger.kernel.org>; Fri, 26 Mar 2021 08:52:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=w3EKLjKkkRDyuhjHErOaTe+JpmWOCkVYfmQHbnU0kHI=;
        b=Q1n38aK+c3uamMZgFIc52ESkgPLBNxfDOGN7cty0ag6K+9uXQQt8jsruCvD/gYKN+t
         +kdItJ4kmtALD5eZzPiP2L1gFkR0F54a1kMbVVa65L1FM3qbBZZu8wiHl6LqrRKyUUTm
         nOQLogXH/Fa+o9sIL9hFjdET6GD18bBlkXSSVjm20oSMAqx6mDRkFJ8i2NSmz7nxZFRK
         fsptYBAowRRYz8tNWlGQ9DeIMyufh/rQVIL8GWaRxuilhHtE9ZhRE2v0ZkR88Wjv4rpJ
         YyxoaljHyNoTrYhrlRhF/wmb1Jcb9xlO+yDgttrYCwXXuQ7EdM1M4htKWdcnqtsMYe93
         ygFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=w3EKLjKkkRDyuhjHErOaTe+JpmWOCkVYfmQHbnU0kHI=;
        b=WHqdrIX2iLgOJitpLr8Qyo8Aq5H8MQ80sEo55UVh7AgN34XD628QdgvRmYDxqvKY9b
         XB+4k8/ShT+JU7HWMjWOWixwYGGgbLU5BsUCJ2IGFIaQ3VJJG7cMdZlL3rlROpVk24NS
         LLMlh7XiUV0fdq7MNqBtwMzuEqyLViXvOdMVevPzkR3gC4e97V4xG8nYSnXHCX1zTZFu
         FqiWAwrWx8lwJDdNwNwBMYuyJqIjz5fhi3JYWL7onlilLTvs1rj9/16slJ84IwYyLhCS
         aguGqZq0OgD6AYOfmv+RaHWglS57WKaPGgKpKEKXTa40Ibd9tIGPvaxkO8nEwLxP4ix8
         Z+DA==
X-Gm-Message-State: AOAM532H/igcHAsi7VT3M7tEIenMdf5WA9OrAGZ5rYHvWs8W0VXqYZWO
        YcOjVgqp9NhJIitWFAgR86zHXTeVTHcRfw==
X-Google-Smtp-Source: ABdhPJzKUpNoS4pw8KCPWFEvmW62Pe4ry7Ir9wj1n+5XszzM0F7ROsSkdti+mcIBm/8GcFiCQduIkQ==
X-Received: by 2002:a92:c748:: with SMTP id y8mr9218586ilp.37.1616773936005;
        Fri, 26 Mar 2021 08:52:16 -0700 (PDT)
Received: from p1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id a7sm4456337ilj.64.2021.03.26.08.52.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Mar 2021 08:52:15 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     torvalds@linux-foundation.org, ebiederm@xmission.com,
        metze@samba.org, oleg@redhat.com, linux-kernel@vger.kernel.org,
        Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 10/10] io_uring: don't cancel extra on files match
Date:   Fri, 26 Mar 2021 09:51:28 -0600
Message-Id: <20210326155128.1057078-16-axboe@kernel.dk>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210326155128.1057078-1-axboe@kernel.dk>
References: <20210326155128.1057078-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

As tasks always wait and kill their io-wq on exec/exit, files are of no
more concern to us, so we don't need to specifically cancel them by hand
in those cases. Moreover we should not, because io_match_task() looks at
req->task->files now, which is always true and so leads to extra
cancellations, that wasn't a case before per-task io-wq.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/0566c1de9b9dd417f5de345c817ca953580e0e2e.1616696997.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 4189e1b684e1..66ae46874d85 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1094,8 +1094,6 @@ static bool io_match_task(struct io_kiocb *head,
 	io_for_each_link(req, head) {
 		if (req->flags & REQ_F_INFLIGHT)
 			return true;
-		if (req->task->files == files)
-			return true;
 	}
 	return false;
 }
-- 
2.31.0

