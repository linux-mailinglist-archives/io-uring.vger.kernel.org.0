Return-Path: <io-uring+bounces-7755-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E35CA9F172
	for <lists+io-uring@lfdr.de>; Mon, 28 Apr 2025 14:52:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 204885A1549
	for <lists+io-uring@lfdr.de>; Mon, 28 Apr 2025 12:52:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4969226A1AF;
	Mon, 28 Apr 2025 12:51:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aUfe9Kr6"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64FE22690D0
	for <io-uring@vger.kernel.org>; Mon, 28 Apr 2025 12:51:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745844710; cv=none; b=qgUhcRLrg6x9S6Ub6O73EIT8jRMRul7eh+YP1Q6Kst5m1GdmmQmq1RMMVZpM9NKDcp/C6/B1UHLdS7KTmg38OLbZs6m+tnPmIP2u//b5TjNJom5YMcgc8ETERNdHQIlALZEhKt6beA5cJzMmJm7fptfHFp05C5Cvh+yhv28lSj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745844710; c=relaxed/simple;
	bh=b4WBz0R0HZIKNQLcrjUcJ5RizhtLtc3pqMeaITWAxwU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bSBBoC6220Us22p7T0x2Z1V70pbAetj1OCDxUwOcHynZM4fMCM4tuTGvAlMgU5Zo4PBzrD0/pEk0sj+EjPnmN9l3W33Vq97K7/Ti2TO8WRuA30DDlIsyrUEZey0KcOINPTeMVh/TsEsP058p526kb7N7nnnnmcae/eCZN2PlpQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aUfe9Kr6; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-ace98258d4bso259218066b.1
        for <io-uring@vger.kernel.org>; Mon, 28 Apr 2025 05:51:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745844706; x=1746449506; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HM+UkCFZX7CTKbBB+/Tml5IWwkzsdGG26QxMXAvXHzg=;
        b=aUfe9Kr6EDxvzHZ5QtBytgQjatpAlVvDJ0tBL5mBpHIUEIz6q11LXIrOLJufmsQoGa
         g+VXPjwfUAyA/ih5+TCzSAvjO71Vrd6pY4r5L+IG2HLNyiKVv/0TiuF/fX2+pcWmc49g
         IXYQdUf61LgIesIioeAhfrDNwFH14NUGJFhChR0Anmc7AkwGxk1V9e+5rNSeh5xroP82
         HQr4ol9IgRl5MHSclKdEdC+RKEAyYVxOR9AfGF9wJL2P/y4IPm3lKJrFA9ILdUZpiShf
         /cO0jfbYDXl5lHN+FNtzpkwDV50LdbQAGuKMkik8uMGWy9XclS3y2IVLBlMrPDe4Lbbs
         xiVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745844706; x=1746449506;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HM+UkCFZX7CTKbBB+/Tml5IWwkzsdGG26QxMXAvXHzg=;
        b=pmqgKRHjuZ0XL2aMpkAd3wHVvdWrDC0LrXk0yFirvgO61B+te3qyWM09SeGxrxqJOZ
         8ZcXmKbAYXbXnIwhgGI+PjgXyT26fG7IZf+jVn+UrnqPQXPXCXfktkGZFRU7Nr0FzzuR
         nTNJxMBHLuGU6htdJfPOMTavwNrbCQhBg4mYnVLjmyyeohbe1eZOTUdBK1Zk8LDDlQD7
         kUcMpSGKdb8cm0BB7Mrv6A5lNIK84XVbAwNch35rCqKdZGVJOzVXOQkfpH2foKQVjC70
         e10dua6J7uXHJTyxjDPUpJTiB/UhtctZcXQVDbxHtX0eZaGOIb4dGzoe46LbN1kW8ys6
         +YZg==
X-Gm-Message-State: AOJu0YwMEBtfjM0QPZQhi21DWdTYcBY4cHN8c/7Cm1T6HumPmHMKlhWH
	xg+rA+fzHhbwfZNCFjLTA4jQAv0pPs1C7PcziA25a4H1v4qeYQ7hLisvaQ==
X-Gm-Gg: ASbGncspTrH5DpCQouUjaTw2VcR8vfNopcqxZKsvSnDT0UHMT+FmwUNbOlFclX48QeL
	a+c2HtVTSUw6vp7kv2K4YYcA2RL99Ee+XB4GdM3cvsridwUe+FCzgpjlqsFZ9HCTRTcdMUZvjxo
	uShZ/HvAecZVeVDHP9HwdBlImhSvlszY87Br9haLw01AO3AvKpkx+xZuQMGVHWBcglZ8P/lMolh
	ureSMYXPP9I7DDNcWyS3k7Mvrj94vFSOSV1BZWGHz1eqtcMtRE0Q+/CYBqlpTdtRuR+SSkjrGOz
	K5jLtz6Npvr4hZRa9EZq6cH+
X-Google-Smtp-Source: AGHT+IH3LncghcKTowTLtlJwbXNTE2pAn/1x3dvtBpilhyCnGLJ5qP1jBY2+o/I5n5HTAjDfXgdWIw==
X-Received: by 2002:a17:907:9719:b0:ace:6bfb:4a11 with SMTP id a640c23a62f3a-ace710951aemr963960066b.24.1745844706083;
        Mon, 28 Apr 2025 05:51:46 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:c92c])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ace6e58673dsm613010766b.76.2025.04.28.05.51.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Apr 2025 05:51:45 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>
Subject: [PATCH RFC 4/7] io_uring/poll: introduce io_arm_apoll()
Date: Mon, 28 Apr 2025 13:52:35 +0100
Message-ID: <275ff22a8d4d1524bbf3b6514af8ab291d682a6b.1745843119.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1745843119.git.asml.silence@gmail.com>
References: <cover.1745843119.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In preparation to allowing commands to do file polling, add a helper
that takes the desired poll event mask and arms it for polling. We won't
be able to use io_arm_poll_handler() with IORING_OP_URING_CMD as it
tries to infer the mask from the opcode data, and we can't unify it
across all commands.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/poll.c | 43 ++++++++++++++++++++++++++-----------------
 io_uring/poll.h |  1 +
 2 files changed, 27 insertions(+), 17 deletions(-)

diff --git a/io_uring/poll.c b/io_uring/poll.c
index 8eb744eb9f4c..9e6d9b889733 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -669,33 +669,17 @@ static struct async_poll *io_req_alloc_apoll(struct io_kiocb *req,
 	return apoll;
 }
 
-int io_arm_poll_handler(struct io_kiocb *req, unsigned issue_flags)
+int io_arm_apoll(struct io_kiocb *req, unsigned issue_flags, __poll_t mask)
 {
-	const struct io_issue_def *def = &io_issue_defs[req->opcode];
 	struct async_poll *apoll;
 	struct io_poll_table ipt;
-	__poll_t mask = POLLPRI | POLLERR | EPOLLET;
 	int ret;
 
-	if (!def->pollin && !def->pollout)
-		return IO_APOLL_ABORTED;
 	if (!io_file_can_poll(req))
 		return IO_APOLL_ABORTED;
 	if (!(req->flags & REQ_F_APOLL_MULTISHOT))
 		mask |= EPOLLONESHOT;
 
-	if (def->pollin) {
-		mask |= EPOLLIN | EPOLLRDNORM;
-
-		/* If reading from MSG_ERRQUEUE using recvmsg, ignore POLLIN */
-		if (req->flags & REQ_F_CLEAR_POLLIN)
-			mask &= ~EPOLLIN;
-	} else {
-		mask |= EPOLLOUT | EPOLLWRNORM;
-	}
-	if (def->poll_exclusive)
-		mask |= EPOLLEXCLUSIVE;
-
 	apoll = io_req_alloc_apoll(req, issue_flags);
 	if (!apoll)
 		return IO_APOLL_ABORTED;
@@ -712,6 +696,31 @@ int io_arm_poll_handler(struct io_kiocb *req, unsigned issue_flags)
 	return IO_APOLL_OK;
 }
 
+int io_arm_poll_handler(struct io_kiocb *req, unsigned issue_flags)
+{
+	const struct io_issue_def *def = &io_issue_defs[req->opcode];
+	__poll_t mask = POLLPRI | POLLERR | EPOLLET;
+
+	if (!def->pollin && !def->pollout)
+		return IO_APOLL_ABORTED;
+	if (!io_file_can_poll(req))
+		return IO_APOLL_ABORTED;
+
+	if (def->pollin) {
+		mask |= EPOLLIN | EPOLLRDNORM;
+
+		/* If reading from MSG_ERRQUEUE using recvmsg, ignore POLLIN */
+		if (req->flags & REQ_F_CLEAR_POLLIN)
+		mask &= ~EPOLLIN;
+	} else {
+		mask |= EPOLLOUT | EPOLLWRNORM;
+	}
+	if (def->poll_exclusive)
+		mask |= EPOLLEXCLUSIVE;
+
+	return io_arm_apoll(req, issue_flags, mask);
+}
+
 /*
  * Returns true if we found and killed one or more poll requests
  */
diff --git a/io_uring/poll.h b/io_uring/poll.h
index 27e2db2ed4ae..c8438286dfa0 100644
--- a/io_uring/poll.h
+++ b/io_uring/poll.h
@@ -41,6 +41,7 @@ int io_poll_remove(struct io_kiocb *req, unsigned int issue_flags);
 struct io_cancel_data;
 int io_poll_cancel(struct io_ring_ctx *ctx, struct io_cancel_data *cd,
 		   unsigned issue_flags);
+int io_arm_apoll(struct io_kiocb *req, unsigned issue_flags, __poll_t mask);
 int io_arm_poll_handler(struct io_kiocb *req, unsigned issue_flags);
 bool io_poll_remove_all(struct io_ring_ctx *ctx, struct io_uring_task *tctx,
 			bool cancel_all);
-- 
2.48.1


