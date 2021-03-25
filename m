Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 448373492CF
	for <lists+io-uring@lfdr.de>; Thu, 25 Mar 2021 14:13:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230230AbhCYNMc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 25 Mar 2021 09:12:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230288AbhCYNMZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 25 Mar 2021 09:12:25 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAC7EC061760
        for <io-uring@vger.kernel.org>; Thu, 25 Mar 2021 06:12:21 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id m20-20020a7bcb940000b029010cab7e5a9fso3070503wmi.3
        for <io-uring@vger.kernel.org>; Thu, 25 Mar 2021 06:12:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=6E5dszCpEjMk05uGa6GiM4GC87p62JIjbt165Q63Yds=;
        b=l2idNTLvi8PDrSktq2Ky6havWsZXQGl+GLg3MA2ZBCecPURRu4KfmQHeM3/eMbxbEr
         ZJJ+gZwSK3E2NgtuJNulWoC/8TzUnpz9CE5VeIvGNAQWCtXkU2gSf71f3gFKAe4OylrY
         Ih6WTDPG9HWw1yX80APce3zkcOQVoKcg/TtzfWCYNpuwzaFjlkAynwoBM9gi+RpxBjBc
         MsTQG7OIQUgH85gG9mj3n4Lxhlxa9buVS7LyLqorQn2zCzvIupYcS3cSTUhHlq9xNyLn
         8FIhb58Pwh4qQDBkPxN461kSu2PnESCr628DgHDXiBuu+VEA7prXuMlnll7Xl2tM3yqL
         z8fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6E5dszCpEjMk05uGa6GiM4GC87p62JIjbt165Q63Yds=;
        b=hBwc8uXXpE3QaG3urQ3K8PoRU3QVZARS59fH6aHkOYbRhssI8pF0PZTVl7Q5XHl0wr
         YqMwF0hNcLo+ua4M7Sx/XQnhFDU8Pq7wMom3jcWHMHy4XnJtm3P+CeEDyglLfzl1hPWL
         bBdmTqcbyFDw0QyQlZjeLLvk1I5MxTEe5QPt4IWBVT6nbzBMasraSAP33iQoVL3u3SI+
         wDtSa3NcYmTfMZNDqyYlvliT9NXiWdbc4+9uUPpQx6jt4Dgrjnh/S5z5Raih+1Yi3oT7
         T2qCbj3+ClNQg2xxFmWyP3QkZgraOq6aOoxyJJvk2x22kuPMFrfc6/h54woS6FWlWFCy
         m+kg==
X-Gm-Message-State: AOAM532WKsAv50EPBhU/y8rvT625ZZMWZ7Ab+qh4auBlhc+g10pgSuYz
        yf0iu49pC8Yarlmeu61tR8A=
X-Google-Smtp-Source: ABdhPJze7+b9u+ayb4PAZ5zhyY9W3jdaU+yaZ2K4yn8jb2xco8juqut8VaBnqZ+aP9a/rIbvBTe7+w==
X-Received: by 2002:a1c:a98a:: with SMTP id s132mr8205602wme.12.1616677940642;
        Thu, 25 Mar 2021 06:12:20 -0700 (PDT)
Received: from localhost.localdomain ([148.252.129.162])
        by smtp.gmail.com with ESMTPSA id i4sm5754285wmq.12.2021.03.25.06.12.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Mar 2021 06:12:20 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v3 06/17] io_uring: refactor io_queue_rsrc_removal()
Date:   Thu, 25 Mar 2021 13:07:55 +0000
Message-Id: <3022ffbdbeaafe5f8f94199d9ad139c3ce5f7eee.1616677487.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1616677487.git.asml.silence@gmail.com>
References: <cover.1616677487.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Pass rsrc_node into io_queue_rsrc_removal() explicitly. Just a
simple preparation patch, makes following changes nicer.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index ba89cd56b6f8..6d2e3a3c202e 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7624,27 +7624,20 @@ static int io_sqe_file_register(struct io_ring_ctx *ctx, struct file *file,
 #endif
 }
 
-static int io_queue_rsrc_removal(struct io_rsrc_data *data, void *rsrc)
+static int io_queue_rsrc_removal(struct io_rsrc_data *data,
+				 struct io_rsrc_node *node, void *rsrc)
 {
 	struct io_rsrc_put *prsrc;
-	struct io_rsrc_node *ref_node = data->node;
 
 	prsrc = kzalloc(sizeof(*prsrc), GFP_KERNEL);
 	if (!prsrc)
 		return -ENOMEM;
 
 	prsrc->rsrc = rsrc;
-	list_add(&prsrc->list, &ref_node->rsrc_list);
-
+	list_add(&prsrc->list, &node->rsrc_list);
 	return 0;
 }
 
-static inline int io_queue_file_removal(struct io_rsrc_data *data,
-					struct file *file)
-{
-	return io_queue_rsrc_removal(data, (void *)file);
-}
-
 static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 				 struct io_uring_rsrc_update *up,
 				 unsigned nr_args)
@@ -7679,7 +7672,7 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 
 		if (*file_slot) {
 			file = (struct file *) ((unsigned long) *file_slot & FFS_MASK);
-			err = io_queue_file_removal(data, file);
+			err = io_queue_rsrc_removal(data, data->node, file);
 			if (err)
 				break;
 			*file_slot = NULL;
-- 
2.24.0

