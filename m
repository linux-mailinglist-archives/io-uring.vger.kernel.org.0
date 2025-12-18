Return-Path: <io-uring+bounces-11193-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C55FCCAED8
	for <lists+io-uring@lfdr.de>; Thu, 18 Dec 2025 09:36:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 9F9523015D33
	for <lists+io-uring@lfdr.de>; Thu, 18 Dec 2025 08:36:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD14B332911;
	Thu, 18 Dec 2025 08:34:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NBVvY/0T"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3DC8332EA0
	for <io-uring@vger.kernel.org>; Thu, 18 Dec 2025 08:34:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766046898; cv=none; b=dX6IM43B2Fost62ux4YfFfvo9I1S8zt2ryDglZOSSo+5iVNKivtREotMZVnWGSiGGZw1B+4hNcETk6YJGGGiGI1IS6Xz9XywayLjH//+u8e78268d6vCCpC9+/LEpsMR4HhQ6SRebpw5xJ2xrHBJ5j1cOwInLDekl0YvJuK2IXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766046898; c=relaxed/simple;
	bh=I4PCjUhCFFP1GB1VqUWFB+sDj0RF8PYOH5kRYPwdMU0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZCOyhBPHEG9Tu74/9mM3TXIniaCZJMjdcsSRHTBu4yTtRYwA7S8HUoiQXo0KuOA95kdQT/hud9NUKnqjI352DSiqIjeay2dDFr/o/ppy2a+Tva+5d8hobl/lHSgouPCPVU+MfKXOPS5d2V0ZcXUhTQnlrIaqyEJD+GpTG5v5sEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NBVvY/0T; arc=none smtp.client-ip=209.85.216.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-34c868b197eso449718a91.2
        for <io-uring@vger.kernel.org>; Thu, 18 Dec 2025 00:34:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766046895; x=1766651695; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=g67IYzmx504GLKJLdQ6KeR6Js5spiNZKZTk6IyeAF4o=;
        b=NBVvY/0Tt4msSrRSU1M/AsRbSwMwDeEXaIk5HJIrc5Vf1AyiSeNSQotOqvuFfP4PEP
         TKPhFS3xjOlzNvyhvphPfbJBNp+3tDxXRVOjcOZzzYd1ZPwQKELFLKLTeyr0nV63sj3v
         bP9oidz6ktWgNY7AaiIA48x0WXtxpBc13o6EZ+NXxjc0skNz4ir39U32k/OegAdD1R/7
         Ai7SkWlTqw9zt8UGhcPHblXlugnieOB/xjYu2OTEWe+0lko1UJl6pDGRSKbfNiyOiTr/
         6LKDLxDw84ge0xj7krZjlFAtpKIRQW1UhGrhZBoKZbTIHJ99ukCihPY/Ht97CWWTr1pM
         46IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766046895; x=1766651695;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=g67IYzmx504GLKJLdQ6KeR6Js5spiNZKZTk6IyeAF4o=;
        b=r0/EbLi23WPH6PnwOpheLBKMzz3fbr6b5cmAEmrqPvwK8RHE7t8B/cHwlde/lZF8ZS
         fbhqRbzdkLZOuA9dHZBvkxJ+hhtWTK/Ixr8S7+bk+zNEcL1K6f4+NsXwMqSRvYO5Sb36
         7zbjQS16MioEB8hI0n5Tws5dGDSLyjCRciyqnti8bdfGCdmE9sO0cnNfOLUGRvU6Ul1x
         pQU1hsYtQnuovFYrQInZPCfmD8HzT9DgTstXilrm39TnnBqHoKsc3dFc1c3ZjRFckK4N
         jtdsPeZWNODc4tNs1LmOnfCwyOH5tMD2liSr1avf5FAq3yg1vHOAbW8fP+nxHwEtYzDn
         sUaQ==
X-Forwarded-Encrypted: i=1; AJvYcCUz/Z+JYhMPj9WtUQVV1MHsFvxONP4wLukf+FUz0BdE/3EZgGurazfdk4nYLdfgW8R3FC1yejm1QQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy4feTWhJsYi9saQqLL1W5oi8iZ47MLb5RB08k+nvy/EEi/49BE
	NTtLaw0Np5TZPWSmpXEf77HU8BthL2Ad4dhl7dP1lSxndkBu/+gtS6AE
X-Gm-Gg: AY/fxX7TWFb3AjIxGKZHLjZlKHN/xVkMwTkAcCDqVp6cGoRHq4+WmsGNJUiPYfFQkjk
	UODjO4PzVMbrNycvwxzrdy5jp0XFrqCLQjY2sliuM2Tln11R99eH81EKiUl9curZbmrpXCs8UuL
	bKXwSTFdii0WEITQI91i2ATvRGHh4iJg7KjwNVmxhcHazmX4zL4FH3dO0ZWlgv2Epbt6VBr65yH
	2OOk6TxBersGXECdh4zy5SdbWcIn08Uw0z5wA+zv1T+V7tGnYYsaJaLxwawDpcQS2uL+CD7HrWi
	EFAdEFmQHiJbHlmMIvFKw476rMnHyLHnccu9b/QW0/MndOjggoaZV+sekWHhXHvdhTYoz8slgtl
	Q7E5msDAnwpNMWlU5bO/eOv3J7E73m1FVpyog/zTEipZlA946q4HpAb/22VInsFlLJCQXWrIR7U
	FgviV9QTq6nw+5KhJOCg==
X-Google-Smtp-Source: AGHT+IF/p/y/kl1yM86joGXG9jG/grAJ6/PcF91F297eKjLjiVmKHBpD6HoiFcTcH44dMX7EBNIOag==
X-Received: by 2002:a17:90a:d450:b0:34c:f92a:ad05 with SMTP id 98e67ed59e1d1-34cf92ac1ebmr5215054a91.11.1766046895285;
        Thu, 18 Dec 2025 00:34:55 -0800 (PST)
Received: from localhost ([2a03:2880:ff:42::])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-34e70dccd14sm1774089a91.16.2025.12.18.00.34.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Dec 2025 00:34:55 -0800 (PST)
From: Joanne Koong <joannelkoong@gmail.com>
To: miklos@szeredi.hu,
	axboe@kernel.dk
Cc: bschubert@ddn.com,
	asml.silence@gmail.com,
	io-uring@vger.kernel.org,
	csander@purestorage.com,
	xiaobing.li@samsung.com,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH v2 13/25] fuse: refactor io-uring logic for getting next fuse request
Date: Thu, 18 Dec 2025 00:33:07 -0800
Message-ID: <20251218083319.3485503-14-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251218083319.3485503-1-joannelkoong@gmail.com>
References: <20251218083319.3485503-1-joannelkoong@gmail.com>
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


