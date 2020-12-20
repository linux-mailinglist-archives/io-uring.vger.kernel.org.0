Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5E732DF583
	for <lists+io-uring@lfdr.de>; Sun, 20 Dec 2020 14:26:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726886AbgLTN0L (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 20 Dec 2020 08:26:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726901AbgLTN0J (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 20 Dec 2020 08:26:09 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AA83C061285
        for <io-uring@vger.kernel.org>; Sun, 20 Dec 2020 05:25:17 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id m5so7968191wrx.9
        for <io-uring@vger.kernel.org>; Sun, 20 Dec 2020 05:25:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=7TED2wGm10Qq88wkje8CQFnYxVWaAq0DycRKS2IhW1w=;
        b=WAcRaV/ucWjSZAsUK2xWBs1TiD0pHeIN0/MfuGjGh+zooOq8RBpjbJhCZaZKQT0eCr
         +Z+zMpC0AoVXYMmsIbu0JWRaF2JqyuGPRVNiLQCLbL2XakieXD8vp9DmIJ4NQYxGLgh2
         oLa/YPiyrzSynAE+qkkFheb8jNXr/lUC1w6T6iGVDjZQBojKFor6Sc7W6ZW8761koXgP
         Agqsd4+AJmqu9wcf5zLcYcc/3+vXQlpYTl18ZYWmNSG7D3VyfRg5wxxuxuY8EAbnEBlN
         5gR8mj6FgMaXNCSWoIV4Ge36c1quj1ypvOrZeDjUuiunRj/T2yWgjMAGFK2ifEgo1id4
         kzsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7TED2wGm10Qq88wkje8CQFnYxVWaAq0DycRKS2IhW1w=;
        b=snzJ7wUkj/+g8aeOQgTAksZqvyvFabpakiU5jYB20IaimzpuEp9qzlNfpf687K3374
         fSuVw5sr5A7UA/FddGSgVWeDFtBN8ahCwnxVP6bf3YhiaH0vmc4xWTE1/ZHJdE0I5aUI
         fsgfTxvT5hyGNx3DyqV7lXoq2rBL9KQnNjE7qF2/y9QrDwENiQps160dAgc5rDbR5YQq
         ssifMWt3OPWs3KsuW1WDvRJEe21KL6OBMy7b/txEG2YfMgKWG9TRZxEp8OSzURzN+eIP
         b937I6gYzeHAkZEYwwqwkEFn/kHMw9ijtA7ZZgDLNJsmdpKZQniZ56jdSzHJpgW7Gukd
         3gsA==
X-Gm-Message-State: AOAM531Rd3dal4X63LXonurhs2a9T49zcasLYI5szDZf4ldZZrO6F28n
        X79Zd/aD5koccq4ZIGB2D1TkLV4XutdegA==
X-Google-Smtp-Source: ABdhPJxaeBOdKZFSfR61OH9vI7z5h3Pqu3FOOp9Vd3VRH5J21s85e0Tr10jvC/f+4+Dk1lWqZF4s0A==
X-Received: by 2002:a5d:4cd1:: with SMTP id c17mr13847084wrt.49.1608470716046;
        Sun, 20 Dec 2020 05:25:16 -0800 (PST)
Received: from localhost.localdomain ([85.255.237.164])
        by smtp.gmail.com with ESMTPSA id l11sm22946519wrt.23.2020.12.20.05.25.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Dec 2020 05:25:15 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 3/3] io_uring: fix cancellation hangs
Date:   Sun, 20 Dec 2020 13:21:45 +0000
Message-Id: <f06b936c1a537828f4055a3673d05e82c846d77c.1608469706.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1608469706.git.asml.silence@gmail.com>
References: <cover.1608469706.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We may enter files cancellation with requests that we want to cancel and
that are currently enqueued as task_work. However, before that happens
do_exit() sets PF_EXITING, disabling io_run_task_work() and so locking
up cancellation.

Also, if run between setting PF_EXITING and exit_task_work(), as the
case exit_files() and so io_uring cancellation, task_work_add() might
actually enqueue more task works.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 30edf47a8f1a..941fe9b64fd9 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2357,12 +2357,6 @@ static inline unsigned int io_put_rw_kbuf(struct io_kiocb *req)
 
 static inline bool io_run_task_work(void)
 {
-	/*
-	 * Not safe to run on exiting task, and the task_work handling will
-	 * not add work to such a task.
-	 */
-	if (unlikely(current->flags & PF_EXITING))
-		return false;
 	if (current->task_works) {
 		__set_current_state(TASK_RUNNING);
 		task_work_run();
-- 
2.24.0

