Return-Path: <io-uring+bounces-11872-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uKlnIlNScWkKCQAAu9opvQ
	(envelope-from <io-uring+bounces-11872-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 21 Jan 2026 23:25:23 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id E39C15EC27
	for <lists+io-uring@lfdr.de>; Wed, 21 Jan 2026 23:25:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id D3D38865311
	for <lists+io-uring@lfdr.de>; Wed, 21 Jan 2026 22:23:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15BB43EFD2C;
	Wed, 21 Jan 2026 22:23:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LpHteQCl"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 540EB41325F
	for <io-uring@vger.kernel.org>; Wed, 21 Jan 2026 22:23:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769034213; cv=none; b=jBJUBzuYfBq5l92HeY9TFpkxBEJjAS13o9HJHB7nE3tKBurGbHSsyhM1VCEZazoB08Eib59RFM7Dwq7vCziP5MOHLCpUIJ5mY4BdMxAAuoMuQvBI8jjkzgLAscmpEM6tcoKM6NcuvfxR3AEPTWbw2YyzSQDoqATiTtndERogjPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769034213; c=relaxed/simple;
	bh=3S98HTrXfTR8hHNXtPrSv4OpUEJSFZzWNfTjMqyjl3Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AI4NzrfEBiQIJCy6j0aIHSRxSHKaZI/kuIhunzktcjsJiju1TGTYvk/6kCqqM8//LsEosIyyVPeS5LrbF0eFZtIh2140tTlSOSWJQKUJkXNejUj5RxIPUwwSs7RwD/22z/r/NH4jC+G5VaYVa/YoC5I4065Nl4zpYGYz+TSair0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LpHteQCl; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4801d24d91bso3189895e9.2
        for <io-uring@vger.kernel.org>; Wed, 21 Jan 2026 14:23:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769034209; x=1769639009; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ebLZK+fmA5oG5hHGI4nFFAGWUXom+a0NGGMgBmORfJ0=;
        b=LpHteQClA9CVfqBrxQBbgDPUPnr9CVMTDoZvB5+MqrpVADWsxUXhtK4+hgX1rExutq
         cV1+sSqvYagEaCfDWknCfNk8KMsroutPt2+XyniUoG4v4eK9xXVoxxO8NWI2eUClEyHW
         KKTuQei1T7GvVAnbf0Ojto+roKxkDCNmpxUFQBI+AqMYHRG0wXjKpmDqZivAlQeh23Qo
         aAoAeEiKipwkfn+5p4XK/4uL+YO7uXP9IREvVz4gbvCEjmX5rxLgFs55JPCnxNILqHjA
         AwuFkP6rB7zSl5N/AgRJ3t0ZdvwCgmC9e+ypoPvUku9Kq0n7IoqB1rvEzwUllTW6BdXs
         wQ7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769034209; x=1769639009;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ebLZK+fmA5oG5hHGI4nFFAGWUXom+a0NGGMgBmORfJ0=;
        b=YdUYbiglbjwklI7KBKEYFI7BRu69bmFK4V1bdOrMeku7ndv+ORTGwnwdIPbP+Sn99b
         hJ0HXc4lXRs9PVqziuYIj1czj8idpuJcPTXTTrohsjJCK5nSa4Ml6nWaY9XA4sbzubFD
         1UbclI8d9Lk/SaPFZEBLjwssV/KfiEpQIKXrozQJWSdqMZooeDITsw451TDzQpSzUeOg
         nKsKYA5YByQgokqA5Ol7KQ4Iet/6G7YtcokdA7NvGvnZzeRtAAt8l3dIe/F2E6XrYD3/
         MFmnZbcFx9Oz2fhl+F2UAjLtdwqL87Ov3ym7C/uO1Zi4MMpjnh4g4kO6SnNlqzJ34/Sf
         BNgg==
X-Gm-Message-State: AOJu0YyVdem7lnT4Nq0T+HUzwK3HQg/+PM4O0OE2Qmo0T2T583KpAikR
	M5sG7jx8whm43RQwwqBIqLPT4aKv/PnbxAiBQxuW3206y9P4BDPx1VLqCaKMzg==
X-Gm-Gg: AZuq6aKPS3s1Jn84c1FEaa1ftzj4To79NWSukXLkQgWtQCdkBKMJJy/PR7rDX2t+J8w
	m7g12wWQQhEWB+PIRnZchzr/M+ctFEjah9A8TkJuYCfCS9Hd4VLeSpSVWwklQiiWfL1C5inf3Jc
	cyl/MddEZQuj6f4m9koU8kWp/OpGq6iex2r3D2OT7tAseH5rqTHo0n+pEk+C8iL0pZOCT8IpNma
	APgDJ66ZNc0Lbey+VxFpLsIYCO0E4Msimwc6vfzTWgCGZ4DkUQ07hImHo6EA45n/TBHGvwYCPEZ
	oj187H8IrY+45MMPGoP9zZ9uydnUc6P2vAwEvV3rTezObxitxjXY3jVqgpwMEJtecXA/ZYzUvc7
	oX6/OEaDCTs3YfOApA3/QuGjWwDnsizyWK02r4cz1NYLzs7DWg1Bvzt5kTSt+iidIpkTpRm5JBK
	z5xQTxkfHD8VJR+vjxQxklnrENzfdxL0AlEvj5uwlm+kTan3bGIwCXgYymf2ESTYPeTPr9rgeWj
	YVZgGNezn817cpQkQ==
X-Received: by 2002:a05:600c:3496:b0:477:8b77:155e with SMTP id 5b1f17b1804b1-480416de873mr91534665e9.15.1769034209147;
        Wed, 21 Jan 2026 14:23:29 -0800 (PST)
Received: from 127.mynet ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43569921da2sm40011103f8f.1.2026.01.21.14.23.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jan 2026 14:23:28 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	axboe@kernel.dk
Subject: [PATCH liburing 1/2] src/queue: Add support for non circular SQ
Date: Wed, 21 Jan 2026 22:23:21 +0000
Message-ID: <494ec4d2a87b5e57ca8d006bc36f04cb98d2dc8a.1769034107.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1769034107.git.asml.silence@gmail.com>
References: <cover.1769034107.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.46 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DMARC_POLICY_ALLOW(0.00)[gmail.com,none];
	FREEMAIL_CC(0.00)[gmail.com,kernel.dk];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-11872-lists,io-uring=lfdr.de];
	PRECEDENCE_BULK(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:7979, ipnet:142.0.200.0/24, country:US];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	FREEMAIL_FROM(0.00)[gmail.com];
	DBL_BLOCKED_OPENRESOLVER(0.00)[dfw.mirrors.kernel.org:helo,dfw.mirrors.kernel.org:rdns]
X-Rspamd-Queue-Id: E39C15EC27
X-Rspamd-Action: no action

With IORING_SETUP_SQ_REWIND, the kernel doesn't use the SQ headers and
always submits SQEs with indices in a range [0, nr_submit), where
nr_submit is the syscall argument. Add liburing support for that.
The head is now kept to be 0, and tail effectively tracks the number of
entries to submit, which matches the normal formula
to_submit = (tail - head) mod N

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 src/include/liburing.h          |  5 ++++-
 src/include/liburing/io_uring.h | 12 ++++++++++++
 src/queue.c                     |  5 +++++
 3 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/src/include/liburing.h b/src/include/liburing.h
index 8a882a08..4758c955 100644
--- a/src/include/liburing.h
+++ b/src/include/liburing.h
@@ -1918,9 +1918,12 @@ IOURINGINLINE struct io_uring_sqe *_io_uring_get_sqe(struct io_uring *ring)
 	LIBURING_NOEXCEPT
 {
 	struct io_uring_sq *sq = &ring->sq;
-	unsigned head = io_uring_load_sq_head(ring), tail = sq->sqe_tail;
+	unsigned head = 0, tail = sq->sqe_tail;
 	struct io_uring_sqe *sqe;
 
+	if (!(ring->flags & IORING_SETUP_SQ_REWIND))
+		head = io_uring_load_sq_head(ring);
+
 	if (tail - head >= sq->ring_entries)
 		return NULL;
 
diff --git a/src/include/liburing/io_uring.h b/src/include/liburing/io_uring.h
index 8e8b8e6a..2696b43d 100644
--- a/src/include/liburing/io_uring.h
+++ b/src/include/liburing/io_uring.h
@@ -233,6 +233,18 @@ enum io_uring_sqe_flags_bit {
  */
 #define IORING_SETUP_SQE_MIXED		(1U << 19)
 
+/*
+ * When set, io_uring ignores SQ head and tail and fetches SQEs to submit
+ * starting from index 0 instead from the index stored in the head pointer.
+ * IOW, the user should place all SQE at the beginning of the SQ memory
+ * before issuing a submission syscall.
+ *
+ * It requires IORING_SETUP_NO_SQARRAY and is incompatible with
+ * IORING_SETUP_SQPOLL. The user must also never change the SQ head and tail
+ * values and keep it set to 0. Any other value is undefined behaviour.
+ */
+#define IORING_SETUP_SQ_REWIND		(1U << 20)
+
 enum io_uring_op {
 	IORING_OP_NOP,
 	IORING_OP_READV,
diff --git a/src/queue.c b/src/queue.c
index c8ada7e8..00995ace 100644
--- a/src/queue.c
+++ b/src/queue.c
@@ -205,6 +205,11 @@ static unsigned __io_uring_flush_sq(struct io_uring *ring)
 	struct io_uring_sq *sq = &ring->sq;
 	unsigned tail = sq->sqe_tail;
 
+	if (ring->flags & IORING_SETUP_SQ_REWIND) {
+		sq->sqe_tail = 0;
+		return tail;
+	}
+
 	if (sq->sqe_head != tail) {
 		sq->sqe_head = tail;
 		/*
-- 
2.52.0


