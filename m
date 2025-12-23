Return-Path: <io-uring+bounces-11264-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 8FF37CD780F
	for <lists+io-uring@lfdr.de>; Tue, 23 Dec 2025 01:37:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 08452301FA73
	for <lists+io-uring@lfdr.de>; Tue, 23 Dec 2025 00:36:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C195F1F4613;
	Tue, 23 Dec 2025 00:36:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ndOJ7X3l"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CDCD1F63D9
	for <io-uring@vger.kernel.org>; Tue, 23 Dec 2025 00:36:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766450208; cv=none; b=SI9lUVM7Ynzqobh9bvWhbktHb2ks7/tL0/uQZUnRAjQ3PTjbG+6F6OI5MFJaFTMiwka0sJmz3yVBLTwPSu8u0S4bqhF4gyDlBs/g3DIDwQIkLh7YFt+zYfqH43EFsa0+X0xlM+kB7RWnY1Bj29jHsuP9RpjfR1ZXbwTbQL3D+78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766450208; c=relaxed/simple;
	bh=I4PCjUhCFFP1GB1VqUWFB+sDj0RF8PYOH5kRYPwdMU0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kd8JZFs0DK97T+42nNvOZqmaARErldxBfYjj41//T9XH70+qxVKzY1CWmP4ZoNc4WmzZN/v8lW4KnpLHwzADPCyWLnUdyvklMagE5MnfbAESvE4ftu4YAgZ8ofbNGr5GcKqh1+yhv8wp9xFdja/QXUcPAqtqcemO+u8gT+M9IjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ndOJ7X3l; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-7ade456b6abso3717326b3a.3
        for <io-uring@vger.kernel.org>; Mon, 22 Dec 2025 16:36:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766450206; x=1767055006; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=g67IYzmx504GLKJLdQ6KeR6Js5spiNZKZTk6IyeAF4o=;
        b=ndOJ7X3lkazLLB5T6iJ18y5gMUZX+EUkSk8oET20oJb44t7DbL8TAVdiCz4BFetVeD
         ErLw4i7CWa32cJZt1H8ZgUA09XThJ7CmZ1uMcTS6JvEGMZBhuDu1ZpouB7fBB3eaWypk
         ES/SoIjbWAIl2ucJ90ro+1LsBikOb7lsCuDv7NOO3QIbCJunOGKRIHLOg7ueB2ECaEgh
         sTuepEnnZ9y/RvFnu+t+uf20BRqD6M96KeUkZbnDnY9Bcn31QMO4JbckUfpzu4CvCyWn
         PgwIvqyx1HT8fjX4IWF0Hlgmef24CWUrROXMj2Zxrd8dKWsRHtQLXsQJ662ky1WymSII
         dcZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766450206; x=1767055006;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=g67IYzmx504GLKJLdQ6KeR6Js5spiNZKZTk6IyeAF4o=;
        b=gKgnhA7+RkmnkC7QdesZobM4YTvnjcSSN1yvpNttmZaK5ot9FjV4I+0GjrEdJ84i5t
         JeoKP5UJ0hptrmsTnoiK4GfzRvff7qf8Td++98ZtX0/TJJVX7rfOAMJR9yLLZMc07+T4
         lwBwFPBz9hocwlSftDbLqtnC0gMfVbbrF62M0kLfsmK8emKcql3Gv3Z352v9UMVLNFHR
         W29CtHLFCRwpfmVS/LbiTv0rNm3D0GWums01mGbb8BfD7IGGu/7MMiCpdEA22hJGomqE
         cLqH5e0Mu17qQ+GIcdfgH/DWRKuQud8i4HaZGw1MV0U1EL8XMRVFS1u1zRQcogtr9KDS
         wQkQ==
X-Forwarded-Encrypted: i=1; AJvYcCUgIxn0v1DZ87Z/DTn7INHgVcxbSU1MM+FnJ6vHOpkDhoiC5Osj0tTEBx2BEyQZvTVG4hrsz8L0BQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yxa58fVuhxt98l0wUBrtA/gCQEFYdN9dVaeZNktdobyKAjacq70
	zlz4RY4SGYgCYwDEVB1jqNPb9duMVLIO2PLFQBz0UGg3PZ8Xbgpl2yO+
X-Gm-Gg: AY/fxX4Qe/6zXxK/7HIDfllm14i7ZDeOerhGl2hOAPADFJ6VsQPUfzt19MBoB8ZfGU3
	0cQXyPMqVNs1q9f5StlrbGLd0TNguAgwsYDLNz6USVC0SataXJFG0ECGQXDwr2BTys28o2MLS9N
	zVuK7A78yFK1rZWZL7LS4she+EqqnrafSOpWfMwQnCXgOKIIqs+AU/o27e3QjRD1q9xxhjUkGvh
	i9O5WfqOSOTTUjG18QKg94RV2aeDQ4QCKoH/w4SYnz1Hif27MbR9p1HITaaVIVU3i5bwPhrf2WM
	WHLX2nIPrHs5GVJwutDYsr5RFH7XxZR1eejALSwgFAgOTqn74gfW90u3jsFv+lTiVI7ke4SYT23
	b8vc5rqgwBkz0pIbQwPAa7qrDqbw31InOseS5eg1LM0X8wFAJBsjfTn6Kf2MEER34TU9oQ0B5CB
	q8HHfmedPN8EGdjIdPzy6N1MriXyFN
X-Google-Smtp-Source: AGHT+IHJpkmBRKq5Hh6VMxIgjdednIBQpwnsYQEJizs7Dwe0EIAKbTjb73hdhO3a3piwfpc/zRbqmw==
X-Received: by 2002:a05:6a00:3286:b0:7aa:3fed:40ff with SMTP id d2e1a72fcca58-7ff64116e68mr11530579b3a.13.1766450206497;
        Mon, 22 Dec 2025 16:36:46 -0800 (PST)
Received: from localhost ([2a03:2880:ff:56::])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7ff7e797787sm11558631b3a.60.2025.12.22.16.36.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Dec 2025 16:36:46 -0800 (PST)
From: Joanne Koong <joannelkoong@gmail.com>
To: miklos@szeredi.hu,
	axboe@kernel.dk
Cc: bschubert@ddn.com,
	asml.silence@gmail.com,
	io-uring@vger.kernel.org,
	csander@purestorage.com,
	xiaobing.li@samsung.com,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH v3 13/25] fuse: refactor io-uring logic for getting next fuse request
Date: Mon, 22 Dec 2025 16:35:10 -0800
Message-ID: <20251223003522.3055912-14-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251223003522.3055912-1-joannelkoong@gmail.com>
References: <20251223003522.3055912-1-joannelkoong@gmail.com>
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


