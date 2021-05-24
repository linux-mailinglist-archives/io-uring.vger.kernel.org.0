Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CE2538F67B
	for <lists+io-uring@lfdr.de>; Tue, 25 May 2021 01:51:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229581AbhEXXxC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 24 May 2021 19:53:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbhEXXxB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 24 May 2021 19:53:01 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5406C061574
        for <io-uring@vger.kernel.org>; Mon, 24 May 2021 16:51:31 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id o127so15711998wmo.4
        for <io-uring@vger.kernel.org>; Mon, 24 May 2021 16:51:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=HFpLVlxtKKpUfcRiRRM3+jqG1uN2BFStIqZr4hvRirY=;
        b=TshjK4I3ML11/y0T6lHFDHfLXVc5ET9nEgXcwmXD92eZ2+QocSG8VjrUShY+ePRIcW
         1jv5Lw8laXYaQXHyCno6U6UzgQrqWwBK+L+zZ4tXMyGOBYvNvA1lV9chwdi5dUgK++7p
         5cq/sbtExsX8eYQ2BiWnVm3Uk4GKc5lHY29uyBu3ods6GQG4ZTPgpcG+iP5TBvk1R2MZ
         24VT8NqHBR6YxpFbnZ1GNvsZWtbsf8RqYVuT/Q5FamzN294r0dO/WxIs+9/ksScVxwb+
         vhf1uQhx+5AOtpWmtFriphBD67JpgJZlp6kvrHnWRUAYAklAgqBXpTTAK0j0+A0ouxW5
         s6XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HFpLVlxtKKpUfcRiRRM3+jqG1uN2BFStIqZr4hvRirY=;
        b=HUitKoAPvVq0Ej8IGh5W0DA5SQvPTsiY5PS/ojbvMhnIU0VW6GcoyK8svUMfODluPZ
         oCfkp/8y7x70qCpqk0xef+ZQnpG8AHFVPQG5A/WXwO/0MW41KBYkwaPwQ2ULpQqFAoY8
         RSgDsa/pkHgvxF0rSZZpb7XEdh6qhoNQQ8GWCDHkhFswONk8QIau/K/fGwr1QUy+hZTs
         RAL5R8ZLQ5qphdAs1Ht3BxZN3iutoX4w0UDavjGXaov8j3PO5XYMlP/sJ3A9En9IeyQu
         qf0CpPgcgsKIZCfM5LRag2ayxDbT8U8DJHUe3TBR6uHDvT0vWrlKYf9YiaZrVnZ/4mwF
         aCwg==
X-Gm-Message-State: AOAM533EYmF2PFl/+JECA5MwxUmk/sBLBdZjDdFG8+f9SjvWQVlIHZJ3
        B3tScWJSSATPJEwdF3/4dVDlhHahh6MOi9l+
X-Google-Smtp-Source: ABdhPJym+7l+hfoevZgHI861B6dedldhXX2J8oe+4/1t7a4gb9Cj+KIrRBMsDtqrFyGZfk2akr5K9A==
X-Received: by 2002:a05:600c:224d:: with SMTP id a13mr1122687wmm.183.1621900290458;
        Mon, 24 May 2021 16:51:30 -0700 (PDT)
Received: from localhost.localdomain ([85.255.235.116])
        by smtp.gmail.com with ESMTPSA id f7sm8961069wmq.30.2021.05.24.16.51.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 May 2021 16:51:30 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 02/13] io-wq: remove unused io-wq refcounting
Date:   Tue, 25 May 2021 00:51:01 +0100
Message-Id: <ae37f9e9c4899198013fdda1929590d0de40f07a.1621899872.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1621899872.git.asml.silence@gmail.com>
References: <cover.1621899872.git.asml.silence@gmail.com>
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
index 961c4dbf1220..a0e43d1b94af 100644
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
@@ -1035,8 +1032,7 @@ void io_wq_put_and_exit(struct io_wq *wq)
 	WARN_ON_ONCE(!test_bit(IO_WQ_BIT_EXIT, &wq->state));
 
 	io_wq_exit_workers(wq);
-	if (refcount_dec_and_test(&wq->refs))
-		io_wq_destroy(wq);
+	io_wq_destroy(wq);
 }
 
 static bool io_wq_worker_affinity(struct io_worker *worker, void *data)
-- 
2.31.1

