Return-Path: <io-uring+bounces-10910-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 08323C9D6CA
	for <lists+io-uring@lfdr.de>; Wed, 03 Dec 2025 01:38:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 81F073A5542
	for <lists+io-uring@lfdr.de>; Wed,  3 Dec 2025 00:38:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24E9E220F47;
	Wed,  3 Dec 2025 00:36:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JTb7Q3Jc"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87BC81B425C
	for <io-uring@vger.kernel.org>; Wed,  3 Dec 2025 00:36:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764722218; cv=none; b=Xffx0d4P9pD5uU4qhX86Lt0z53iCfClHpOqnPQPh+VEzR/jLTZVAce7SPWQSMXyBQJn5/iCGxaoH9n6dxsASbxMEDJ2Z0AuTip/7DDSKsRlm+q6BhEqqyCgzyU53+1myWyoWjbauM3dky21xlySMnxQc+YScnqcqKS7I54k0JtY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764722218; c=relaxed/simple;
	bh=I4PCjUhCFFP1GB1VqUWFB+sDj0RF8PYOH5kRYPwdMU0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d/Ke1ojUm/qA6DRkNZwBSl9aSai1w94/Cdbpo0enjY2J+NvQGfPp5Wa2NNfoWn+rt8Piu1eYljVrE063HW6BaexXHg8wxfFrr+uXRAIXkQZ0ASM+eh8/XpXYKjSchRaVz3qdjKY0hKQLbs1wjLf1VqcHDnK6WWps4+EYX6C8iWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JTb7Q3Jc; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-340ba29d518so4084615a91.3
        for <io-uring@vger.kernel.org>; Tue, 02 Dec 2025 16:36:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764722215; x=1765327015; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=g67IYzmx504GLKJLdQ6KeR6Js5spiNZKZTk6IyeAF4o=;
        b=JTb7Q3Jcmn7awzSe2c95jwvLWvwWlfXc7tAPR8krVKN90P4p4pIGJiVuLlJ5F9xg4t
         TWK/+atw/+fu1W0MOnwfbTcNdo2TZVPdcxCPVg2R06Zq838wnxPBbtIZPQsiXBgIPufw
         r26Z5F8QZ8i4Rb4fGUDVFW0uFIXkmywfblJot0Dvs8b9c/DvCt9UoWXAd4TRVfinOpcz
         d71FeUEoNpjQHOwSpM5du75W+i50hj8sFoOIKTuiEeXtv+XP8b+pYCo+Cez1C4xUpCHb
         Fifjz2G+9ipbU7G+tUaZjUV0wNCQEsNo3JQFhyIzcm80Yx6bcQMQ3QlwbbfSjvHETQq2
         f63A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764722215; x=1765327015;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=g67IYzmx504GLKJLdQ6KeR6Js5spiNZKZTk6IyeAF4o=;
        b=IW8vPRjp18IDADzx48Zs50I0AWD4qYJinxUC0q7hxmhI9eya3+JbB7ka7qEmdFQsHQ
         0Y7ozo8E1TUtWIFZVxssMteOy25eGcNrVLVUrVr5YelKLoikYODFzDolVeTlzVAKWq1p
         tcfGB45RWoUcQQGUD3JSi5nECYkm54ynnZvnizsBhMEG1GwIZ1zs8r7eMHg8mIy7CQ6d
         or3jdVzwUSpHPd/xMa5AgqASbZlH3rGeyTJ74ap5daQLFdy6y+uiuw20Bdphji5UCSNh
         odpVsJEbmAJZ1PIcchkecW6Obry90D7pZ833WeoA4Kkj2jXB6uiLgUD+ixSxWO0s5Sew
         yXwA==
X-Forwarded-Encrypted: i=1; AJvYcCWwKLgAs+wqOa9ZkK4FLzS5SzDBZwdK1qdQPZAmkb3SZr9WPE+PzgZPYhj+YyXqmCzyMMVa75llHQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YxvvwBYx0NXtQGAWRV9SApBDBpeko1Ie1SQMG/F5arOeu7fyN94
	ie6D9nF9ZzEIlS7ezy13OJf3vQscEdrq0m6fwfbloNh8AxV1mWVwQPCN
X-Gm-Gg: ASbGncsKJ6BO7dPNAf5fx9cBJb8CX7IIM69rh8ZFyYJwElbJw/KiOaU7Ix9U21G0RkP
	n6QGDmTflIpQ0t4NQvgyB9KQnLCDu++W4gxIV+J/2V5ShqINnJ0IADX2cqFSboik+renh7+ImAN
	sPnzTNAx7JbljULDhUCTaO2QOKdnPJOT3XBh+jYjY/O8dGoZ0kE6OO1SbjIG9lL4e/mmBDjzQhO
	9L/syZs3GzZl3zclDFX4a8XjlyXsEA13sukIyREZJYU18m5jYRo+4slrlH/hWW517q/b5a/qzl+
	/aXqw8VX6nnivKp/VjES1jTGmJliCBhkvd69T5eAPCUwk8wpur7JArZpqXVs2UpgzRtNtwnHwT+
	X+GGWD1EWGFFdxrYs5v6s5Df/NM5wefnihjt6YmSANm+FarzKfcNF8Jz9asEprkZPOeYV8zXmzI
	3AiAFo5EepdOCMAM1c9Q==
X-Google-Smtp-Source: AGHT+IEmMrKmYau6ubCLOnd41tW/2v1wfGh90/z9/DwV23To9h3XaBWAdOeePVBvtUlGw5F6XI1+Ww==
X-Received: by 2002:a17:90a:d2ce:b0:340:bc27:97bd with SMTP id 98e67ed59e1d1-349125fb0admr522039a91.9.1764722214878;
        Tue, 02 Dec 2025 16:36:54 -0800 (PST)
Received: from localhost ([2a03:2880:ff:72::])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-34910bd6665sm633512a91.12.2025.12.02.16.36.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Dec 2025 16:36:54 -0800 (PST)
From: Joanne Koong <joannelkoong@gmail.com>
To: miklos@szeredi.hu,
	axboe@kernel.dk
Cc: bschubert@ddn.com,
	asml.silence@gmail.com,
	io-uring@vger.kernel.org,
	csander@purestorage.com,
	xiaobing.li@samsung.com,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH v1 15/30] fuse: refactor io-uring logic for getting next fuse request
Date: Tue,  2 Dec 2025 16:35:10 -0800
Message-ID: <20251203003526.2889477-16-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251203003526.2889477-1-joannelkoong@gmail.com>
References: <20251203003526.2889477-1-joannelkoong@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Simplify the logic for getting the next fuse request.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
Reviewed-by: Bernd Schubert <bschubert@ddn.com>
---
 fs/fuse/dev_uring.c | 78 ++++++++++++++++-----------------------------
 1 file changed, 28 insertions(+), 50 deletions(-)

diff --git a/fs/fuse/dev_uring.c b/fs/fuse/dev_uring.c
index 5ceb217ced1b..1efee4391af5 100644
--- a/fs/fuse/dev_uring.c
+++ b/fs/fuse/dev_uring.c
@@ -714,34 +714,6 @@ static int fuse_uring_prepare_send(struct fuse_ring_ent *ent,
 	return err;
 }
 
-/*
- * Write data to the ring buffer and send the request to userspace,
- * userspace will read it
- * This is comparable with classical read(/dev/fuse)
- */
-static int fuse_uring_send_next_to_ring(struct fuse_ring_ent *ent,
-					struct fuse_req *req,
-					unsigned int issue_flags)
-{
-	struct fuse_ring_queue *queue = ent->queue;
-	int err;
-	struct io_uring_cmd *cmd;
-
-	err = fuse_uring_prepare_send(ent, req);
-	if (err)
-		return err;
-
-	spin_lock(&queue->lock);
-	cmd = ent->cmd;
-	ent->cmd = NULL;
-	ent->state = FRRS_USERSPACE;
-	list_move_tail(&ent->list, &queue->ent_in_userspace);
-	spin_unlock(&queue->lock);
-
-	io_uring_cmd_done(cmd, 0, issue_flags);
-	return 0;
-}
-
 /*
  * Make a ring entry available for fuse_req assignment
  */
@@ -838,11 +810,13 @@ static void fuse_uring_commit(struct fuse_ring_ent *ent, struct fuse_req *req,
 }
 
 /*
- * Get the next fuse req and send it
+ * Get the next fuse req.
+ *
+ * Returns true if the next fuse request has been assigned to the ent.
+ * Else, there is no next fuse request and this returns false.
  */
-static void fuse_uring_next_fuse_req(struct fuse_ring_ent *ent,
-				     struct fuse_ring_queue *queue,
-				     unsigned int issue_flags)
+static bool fuse_uring_get_next_fuse_req(struct fuse_ring_ent *ent,
+					 struct fuse_ring_queue *queue)
 {
 	int err;
 	struct fuse_req *req;
@@ -854,10 +828,12 @@ static void fuse_uring_next_fuse_req(struct fuse_ring_ent *ent,
 	spin_unlock(&queue->lock);
 
 	if (req) {
-		err = fuse_uring_send_next_to_ring(ent, req, issue_flags);
+		err = fuse_uring_prepare_send(ent, req);
 		if (err)
 			goto retry;
 	}
+
+	return req != NULL;
 }
 
 static int fuse_ring_ent_set_commit(struct fuse_ring_ent *ent)
@@ -875,6 +851,20 @@ static int fuse_ring_ent_set_commit(struct fuse_ring_ent *ent)
 	return 0;
 }
 
+static void fuse_uring_send(struct fuse_ring_ent *ent, struct io_uring_cmd *cmd,
+			    ssize_t ret, unsigned int issue_flags)
+{
+	struct fuse_ring_queue *queue = ent->queue;
+
+	spin_lock(&queue->lock);
+	ent->state = FRRS_USERSPACE;
+	list_move_tail(&ent->list, &queue->ent_in_userspace);
+	ent->cmd = NULL;
+	spin_unlock(&queue->lock);
+
+	io_uring_cmd_done(cmd, ret, issue_flags);
+}
+
 /* FUSE_URING_CMD_COMMIT_AND_FETCH handler */
 static int fuse_uring_commit_fetch(struct io_uring_cmd *cmd, int issue_flags,
 				   struct fuse_conn *fc)
@@ -946,7 +936,8 @@ static int fuse_uring_commit_fetch(struct io_uring_cmd *cmd, int issue_flags,
 	 * and fetching is done in one step vs legacy fuse, which has separated
 	 * read (fetch request) and write (commit result).
 	 */
-	fuse_uring_next_fuse_req(ent, queue, issue_flags);
+	if (fuse_uring_get_next_fuse_req(ent, queue))
+		fuse_uring_send(ent, cmd, 0, issue_flags);
 	return 0;
 }
 
@@ -1194,20 +1185,6 @@ int fuse_uring_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags)
 	return -EIOCBQUEUED;
 }
 
-static void fuse_uring_send(struct fuse_ring_ent *ent, struct io_uring_cmd *cmd,
-			    ssize_t ret, unsigned int issue_flags)
-{
-	struct fuse_ring_queue *queue = ent->queue;
-
-	spin_lock(&queue->lock);
-	ent->state = FRRS_USERSPACE;
-	list_move_tail(&ent->list, &queue->ent_in_userspace);
-	ent->cmd = NULL;
-	spin_unlock(&queue->lock);
-
-	io_uring_cmd_done(cmd, ret, issue_flags);
-}
-
 /*
  * This prepares and sends the ring request in fuse-uring task context.
  * User buffers are not mapped yet - the application does not have permission
@@ -1224,8 +1201,9 @@ static void fuse_uring_send_in_task(struct io_tw_req tw_req, io_tw_token_t tw)
 	if (!tw.cancel) {
 		err = fuse_uring_prepare_send(ent, ent->fuse_req);
 		if (err) {
-			fuse_uring_next_fuse_req(ent, queue, issue_flags);
-			return;
+			if (!fuse_uring_get_next_fuse_req(ent, queue))
+				return;
+			err = 0;
 		}
 	} else {
 		err = -ECANCELED;
-- 
2.47.3


