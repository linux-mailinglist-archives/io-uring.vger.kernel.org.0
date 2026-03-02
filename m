Return-Path: <io-uring+bounces-12516-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id gGnYAfy+pWknFgAAu9opvQ
	(envelope-from <io-uring+bounces-12516-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 02 Mar 2026 17:46:52 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 509881DD2C0
	for <lists+io-uring@lfdr.de>; Mon, 02 Mar 2026 17:46:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 6A45D3047523
	for <lists+io-uring@lfdr.de>; Mon,  2 Mar 2026 16:40:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D2C0A218ADD;
	Mon,  2 Mar 2026 16:40:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BPJ3k3Eh"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62DF42FE071
	for <io-uring@vger.kernel.org>; Mon,  2 Mar 2026 16:40:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772469612; cv=none; b=T9a9LI1hhw0L24Dg+1E6q65oSH+bGs4DE4sOsW4Eww3L8RSmqCx4Y3Ntc17B/Ewteh1TYhtb1wK+7Wapu4tJsI6pBHqM3S6MKym8uzpWbCuia+k1CwaqIWaCk3zzZ2V8qUam5vi3drucqT/QS30BX2n9XcI4yzS1wWzK9pUfw0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772469612; c=relaxed/simple;
	bh=4GmQb2/zi/7DP7MI78Pr8TiGh8s7D2aMSXEi/6ZS9E0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=iFC78vwJWNTc8IBKj4Epq+jE85+/BQv+oxZOTHILh3igKZqvzyLxS3FrdP7C/d1dxeLyTsg82iY7bqoOoAHJX25gAC5H1GrMkVeFsGly75MsLBTnK471Ss5eJG6gvmq8+w/q+fW27foxfUdDScaWh/2uE+wa3sRW5PjFYeFJKno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BPJ3k3Eh; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4837634de51so19519995e9.1
        for <io-uring@vger.kernel.org>; Mon, 02 Mar 2026 08:40:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772469609; x=1773074409; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=4unpQDkdz2bn6rSM6atE8hGTT8L4zWzevtcPYXp+MDo=;
        b=BPJ3k3EhZwVUmmY2o6+BgqPPNqfYOJptnsSqKQLq1byOGdTHq6/WY4eOEnfF3BKvy2
         5LAT0rCy0gIZJohSfFSSIyrRgTv78e+Tcglqphfvl0geZGoTOeau/I53qTSl+AGVRmlg
         +7Z+kJrqcjIBO9UzftDEWgw7FDf0I5sgh8+j0mwy9sNQj7XMIFbld9ZpD7x9rwlJ8gWW
         TNg6As+3htxjfXeTXGTIkje0IozoTOrR628SvDAyJQ1ty727AT7mHtSr4zRbO+xKmc5f
         k7ADZtbqiHjuzAAP/6kRC6suFVRKDtXG9Nnm/ZTLP/LH38jdFJeJnZVsYi+46SMPFIwL
         H2Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772469609; x=1773074409;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4unpQDkdz2bn6rSM6atE8hGTT8L4zWzevtcPYXp+MDo=;
        b=sTRItywSmMMdquQxYdmagK+CukalGNKcBX1ZpztcKFJiHg5RQ1cDxcsFpwJrpbxRPC
         /Q7XXfTTF0/nCRKvyqQp3z3Q+OzwlRZFcJaGa/juMj5jf8UR4kK4sSrwDXEU7QEVimao
         FjNK9acPmgfBeCip8QCOD8/c4vHB+1fwZy7Rdw8xwT7N93HZ+MPkCGZVXpMRFN8qEpcz
         QK2pxYo9Pc5SjINkuitZTLWZMnEQNjJw8TAP2vwTyQuBhvrxgNQ212TPolk143p0koWx
         xVAOqcXMjTTVCO/jx3NGyf1FL79LZaCkslheSD+pcSz3dJM+qhmIq/1EjoEtTJJPJdk0
         /Ung==
X-Gm-Message-State: AOJu0Yzam7/d1lR1Td/VhqZwJcTamjdilNKK2K1vnV3WH+AFGlw+asx+
	eTMbZlMRbkRcnmKzRUo+BNL2NHpPV4ue5mFuGi4XzXTxonOCgYTH8QGQMsIKtw==
X-Gm-Gg: ATEYQzwO4P5RkkIEwvv24XVglY1Vr/Sv3izFuFm6NU6wSaTRwlSKUhkKb1lNMnBFjlQ
	AxJ+0Dp0zTeoVeeje0SDpBk/gqLi/oNX71v6dhdNS0XJCOT1emIruHBKIr0VmCBwuw8YR1GK7az
	5Lq7oB0Ed2+U1t+I4wdLnnhAxct9Y3b2ebk87ArHHBwv2MdmaxhR2/NE40SYxSs9QgPRDvA9UtW
	SqL3s7XleeyZf8886kSJ9/iVCDIZfLUTDDSbQAi2f5MP9u6xNqEc7aJ/5rgxsMBBKnrPoK/nBj4
	fNvQWw7zNdOu4XqFXN63NBuCVOi41cGUCwzPHSKJN3nOmDHm1Xp2HrvK4R2kHeHDzGTfqoTcAr3
	wcKHehFONQUuJdhtZ0s14LtNm1/rfue3oXkw6uQWO+7FC7rXpBG6Irvj6my8UCGMm7lTCA16khD
	5Xr8ag9NpITG8CzgdqU8Y4DpfmErXfYPhuoLRIyoiw//HYX79ZigIjtCuW1HiTK52Ig2P3t03Ga
	wgYzP7bnbS8PktROi2BmSuiyivwcQ==
X-Received: by 2002:a05:600c:1d0e:b0:483:acd9:bd18 with SMTP id 5b1f17b1804b1-483c9bc55ecmr227236675e9.1.1772469609046;
        Mon, 02 Mar 2026 08:40:09 -0800 (PST)
Received: from 127.mynet ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-439ae0e7abasm14565482f8f.23.2026.03.02.08.40.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Mar 2026 08:40:08 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	axboe@kernel.dk
Subject: [PATCH liburing 1/1] tests/timeout: add abs imm timeout test
Date: Mon,  2 Mar 2026 16:40:00 +0000
Message-ID: <652575b9e2b08c08a32537f27b398504236e8be5.1772469585.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 509881DD2C0
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12516-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,kernel.dk];
	RCVD_COUNT_FIVE(0.00)[5];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	PRECEDENCE_BULK(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_NONE(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	FREEMAIL_FROM(0.00)[gmail.com];
	FROM_HAS_DN(0.00)[]
X-Rspamd-Action: no action

Add a simple test for absolute immediate argument timeout.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 test/timeout.c | 35 ++++++++++++++++++++++-------------
 1 file changed, 22 insertions(+), 13 deletions(-)

diff --git a/test/timeout.c b/test/timeout.c
index 6bef0a7e..0ca387ba 100644
--- a/test/timeout.c
+++ b/test/timeout.c
@@ -31,18 +31,19 @@ static void msec_to_ts(struct __kernel_timespec *ts, unsigned int msec)
 	ts->tv_nsec = (msec % 1000) * 1000000;
 }
 
-static void t_prep_timeout_rel(struct io_uring_sqe *sqe,
-				const struct __kernel_timespec *ts,
-				bool immediate)
+static void t_prep_timeout(struct io_uring_sqe *sqe,
+			   const struct __kernel_timespec *ts,
+			   unsigned flags,
+			   bool immediate)
 {
 	if (!immediate) {
 		io_uring_prep_timeout(sqe, ts, 0, 0);
-		return;
+	} else {
+		io_uring_prep_timeout(sqe, NULL, 0, 0);
+		sqe->addr = ts->tv_sec * 1000000000 + ts->tv_nsec;
+		sqe->timeout_flags = IORING_TIMEOUT_IMMEDIATE_ARG;
 	}
-
-	io_uring_prep_timeout(sqe, NULL, 0, 0);
-	sqe->addr = ts->tv_sec * 1000000000 + ts->tv_nsec;
-	sqe->timeout_flags = IORING_TIMEOUT_IMMEDIATE_ARG;
+	sqe->timeout_flags |= flags;
 }
 
 /*
@@ -65,7 +66,7 @@ static int test_single_timeout_many(struct io_uring *ring, bool immediate)
 	}
 
 	msec_to_ts(&ts, TIMEOUT_MSEC);
-	t_prep_timeout_rel(sqe, &ts, immediate);
+	t_prep_timeout(sqe, &ts, 0, immediate);
 
 	ret = io_uring_submit(ring);
 	if (ret <= 0) {
@@ -250,7 +251,7 @@ static int test_single_timeout(struct io_uring *ring, bool immediate)
 	}
 
 	msec_to_ts(&ts, TIMEOUT_MSEC);
-	t_prep_timeout_rel(sqe, &ts, immediate);
+	t_prep_timeout(sqe, &ts, 0, immediate);
 
 	ret = io_uring_submit(ring);
 	if (ret <= 0) {
@@ -436,7 +437,7 @@ err:
 /*
  * Test single absolute timeout waking us up
  */
-static int test_single_timeout_abs(struct io_uring *ring)
+static int test_single_timeout_abs(struct io_uring *ring, bool immediate)
 {
 	struct io_uring_cqe *cqe;
 	struct io_uring_sqe *sqe;
@@ -455,7 +456,7 @@ static int test_single_timeout_abs(struct io_uring *ring)
 	clock_gettime(CLOCK_MONOTONIC, &abs_ts);
 	ts.tv_sec = abs_ts.tv_sec + 1;
 	ts.tv_nsec = abs_ts.tv_nsec;
-	io_uring_prep_timeout(sqe, &ts, 0, IORING_TIMEOUT_ABS);
+	t_prep_timeout(sqe, &ts, IORING_TIMEOUT_ABS, immediate);
 
 	ret = io_uring_submit(ring);
 	if (ret <= 0) {
@@ -1805,12 +1806,20 @@ int main(int argc, char *argv[])
 		return ret;
 	}
 
-	ret = test_single_timeout_abs(&ring);
+	ret = test_single_timeout_abs(&ring, false);
 	if (ret) {
 		fprintf(stderr, "test_single_timeout_abs failed\n");
 		return ret;
 	}
 
+	if (!no_immediate) {
+		ret = test_single_timeout_abs(&ring, true);
+		if (ret) {
+			fprintf(stderr, "test_single_timeout_abs (imm) failed\n");
+			return ret;
+		}
+	}
+
 	ret = test_single_timeout_remove(&ring);
 	if (ret) {
 		fprintf(stderr, "test_single_timeout_remove failed\n");
-- 
2.53.0


