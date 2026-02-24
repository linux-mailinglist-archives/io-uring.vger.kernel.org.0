Return-Path: <io-uring+bounces-12400-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id eBlqNtPOnWn4SAQAu9opvQ
	(envelope-from <io-uring+bounces-12400-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 24 Feb 2026 17:16:19 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 836D5189A85
	for <lists+io-uring@lfdr.de>; Tue, 24 Feb 2026 17:16:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 8575830244C9
	for <lists+io-uring@lfdr.de>; Tue, 24 Feb 2026 16:16:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E3921F1304;
	Tue, 24 Feb 2026 16:16:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FIPfrI4s"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCE853A4F47
	for <io-uring@vger.kernel.org>; Tue, 24 Feb 2026 16:16:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771949771; cv=none; b=RtN+14Dbc1cZT0Wo0U8VlK7BEm8FmvDWzriVxFlsMttJDCrh2QOOz7Ev3zN74dTR4pNYd5YVtLecv3/2Xa5dXKgecAHbCgJduZCLdOYgF9mJ7OVUnIEzRuruaqC647rup1P+UxdcGo43qPcU+uL+480UyFtPsmKZ6r2RbMMj554=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771949771; c=relaxed/simple;
	bh=1MugPZFHb3PGxAzEb98iXvCj2bGor7UXoqhxBXUwmAA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=u2YljQdQxoCDHlpQ63IkkeHYfdKV502bB94TuswWitJuuyzw9mtwsqNJhH+SxRkHBoMIoc6xBpx8h/SACywsAOzxV+Br1iGjB3uav4+FPkubmnO+u2fVvgzveE+MAIgbbSF0f7K59FIYzCKxitcqkL436xO7tuZDSzQffII670I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FIPfrI4s; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-48379a42f76so44062245e9.0
        for <io-uring@vger.kernel.org>; Tue, 24 Feb 2026 08:16:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771949768; x=1772554568; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=XGqBTdg62cdEQ7Tpz0bhM9C51bAaHlyOsn06BJi8NEg=;
        b=FIPfrI4sVkKVq8FBC6+Ur/lBdEaNBOM94COxpBqjDxU6Ta3j4pRBzvxEz4l0NL5oY3
         LD2fdA4BmyfndjTucmkHmJ3G6+Tu4mZU/eLQXQOzMvhVPpdpS/FDKHCcyc2m2+05xk/n
         QaiNB16XKF2EIfKvsnJW+3b5P1PpgMrVbGvk97oeodMMdH5h9psQa1jb7I9+v1/PQqXS
         zvtvh+SQ6Y5pfLpYZlTovSRiXH/fWW+iJhDugZcAg2BZdBiyNHRanORg8s1/cD96U1ra
         9iZdcYdm8kkOqLX83XFkf5w+C7/yMevBqWN7nP27HD0WRetDKmY7lnU0+r8eujpWe/zV
         DCuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771949768; x=1772554568;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XGqBTdg62cdEQ7Tpz0bhM9C51bAaHlyOsn06BJi8NEg=;
        b=FTm6dsfC27Ytq7we2vsb67JJ2quO83mRlMt7BtiHe1YV7IzU9Jcz3wXoJ6WnkR5QyS
         yGD4dthsgASHxjkZIIfnPwZUXuEBFNjZVhp5mWk/K/fURNTKEux9oZqiT5XEagQXxmfs
         NW8RdcpDRFmOXObrwpdCCo14XtpsLVLgWkP9u8fWnicO4Sg8UUfmlb7GMjmsP83QfkSJ
         F8jD8Br85c7W5mn8jKqM8rR6HK5AwHjyglRGkHjSSsNHUa0Kxv2tkUTt1Xt84uN2g3AI
         F9dk1zregLfclNQvjBvRJYiFvkZ2r95SIhk9WDm7TNoWyL1UdPoRaeDvYZNeEOjWhOfd
         OCiA==
X-Gm-Message-State: AOJu0YxHTYmLCXvJ+kq0RI1hmmXCfq6GcG+dj+Z2EPafujQdOZNj8BjR
	G7T+BskDxgepXyXVb/OzBzlnJdiXan5sjuN0yL7LnowUygu4pt2JeqjXtwnfHw==
X-Gm-Gg: AZuq6aK+qMoARYk5HNa6d2QthJPYhgEGca2HYjg8tFwK9a46Doqm7hPfzl4xWndlg0Z
	XdvyVWHFB/huZRcmE2gKnNOZ5Ng/Z1JlpmTk6GanGOk14QUyMK9N/+47YZ7CGZIJewpfAv6FCsM
	D4q62dIx73NgkcWhl/SlfNB6PKspZOt219e42wdjfFrTNjJjh+yMhyAvsk03B4iyQh25DCMivg/
	n56auGqustWGPLwmfG1ThRiX/mpAZIXtWoTyJQ8EDnabCaykq+XofDWz8IbHPdLUA1eh78rpuuh
	NwAPrN0rBXQghysXUGJ3hMseJPEk+pIzv7MAeR7U6AsCSTYY8uyDc0t9brIMvNJ9IGm7lURL+2y
	0xjc8BwaDni2Q0AgPFmVQEhBqU0AjUYLJvGgap4HedhPx/jXe3I4Zmf0KE+cuqZZSawGY8+vHzW
	/AV4tT3lZwobtOugp7i+2dBo1FHFZlq1FLmsfnykllNC4gYEWmk1UDZOZs4Rd3B/GOyRDYpFopY
	aHChj+FMDYkLYjgWebgjv412MK3FQ==
X-Received: by 2002:a05:600c:4e12:b0:483:56c4:73ac with SMTP id 5b1f17b1804b1-483a95eac1cmr234161235e9.7.1771949767700;
        Tue, 24 Feb 2026 08:16:07 -0800 (PST)
Received: from 127.mynet ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-483b823a52asm22477245e9.11.2026.02.24.08.16.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Feb 2026 08:16:07 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	axboe@kernel.dk
Subject: [PATCH liburing 1/1] tests: test timeout with immediate arguments
Date: Tue, 24 Feb 2026 16:16:02 +0000
Message-ID: <0e0674b59c96d821f884b9063607dd194d91b551.1771949741.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[gmail.com:+];
	TAGGED_FROM(0.00)[bounces-12400-lists,io-uring=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,kernel.dk];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 836D5189A85
X-Rspamd-Action: no action

IORING_TIMEOUT_IMMEDIATE_ARG allows the user to store the timeout in the
SQE without indirection to a user timespec. Update io_uring.h and extend
tests to cover the feature.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 src/include/liburing/io_uring.h |  5 ++++
 test/timeout.c                  | 44 ++++++++++++++++++++++++++++-----
 2 files changed, 43 insertions(+), 6 deletions(-)

diff --git a/src/include/liburing/io_uring.h b/src/include/liburing/io_uring.h
index ab1450ec..74b3f86d 100644
--- a/src/include/liburing/io_uring.h
+++ b/src/include/liburing/io_uring.h
@@ -332,6 +332,10 @@ enum io_uring_op {
 
 /*
  * sqe->timeout_flags
+ *
+ * IORING_TIMEOUT_IMMEDIATE_ARG:	If set, sqe->addr stores the timeout
+ *					value in nanoseconds instead of
+ *					pointing to a timespec.
  */
 #define IORING_TIMEOUT_ABS		(1U << 0)
 #define IORING_TIMEOUT_UPDATE		(1U << 1)
@@ -340,6 +344,7 @@ enum io_uring_op {
 #define IORING_LINK_TIMEOUT_UPDATE	(1U << 4)
 #define IORING_TIMEOUT_ETIME_SUCCESS	(1U << 5)
 #define IORING_TIMEOUT_MULTISHOT	(1U << 6)
+#define IORING_TIMEOUT_IMMEDIATE_ARG	(1U << 7)
 #define IORING_TIMEOUT_CLOCK_MASK	(IORING_TIMEOUT_BOOTTIME | IORING_TIMEOUT_REALTIME)
 #define IORING_TIMEOUT_UPDATE_MASK	(IORING_TIMEOUT_UPDATE | IORING_LINK_TIMEOUT_UPDATE)
 /*
diff --git a/test/timeout.c b/test/timeout.c
index 003ba743..332efcbc 100644
--- a/test/timeout.c
+++ b/test/timeout.c
@@ -23,6 +23,7 @@
 static int not_supported;
 static int no_modify;
 static int no_multishot;
+static int no_immediate;
 
 static void msec_to_ts(struct __kernel_timespec *ts, unsigned int msec)
 {
@@ -30,11 +31,25 @@ static void msec_to_ts(struct __kernel_timespec *ts, unsigned int msec)
 	ts->tv_nsec = (msec % 1000) * 1000000;
 }
 
+static void t_prep_timeout_rel(struct io_uring_sqe *sqe,
+				const struct __kernel_timespec *ts,
+				bool immediate)
+{
+	if (!immediate) {
+		io_uring_prep_timeout(sqe, ts, 0, 0);
+		return;
+	}
+
+	io_uring_prep_timeout(sqe, NULL, 0, 0);
+	sqe->addr = ts->tv_sec * 1000000000 + ts->tv_nsec;
+	sqe->timeout_flags = IORING_TIMEOUT_IMMEDIATE_ARG;
+}
+
 /*
  * Test that we return to userspace if a timeout triggers, even if we
  * don't satisfy the number of events asked for.
  */
-static int test_single_timeout_many(struct io_uring *ring)
+static int test_single_timeout_many(struct io_uring *ring, bool immediate)
 {
 	struct io_uring_cqe *cqe;
 	struct io_uring_sqe *sqe;
@@ -50,7 +65,7 @@ static int test_single_timeout_many(struct io_uring *ring)
 	}
 
 	msec_to_ts(&ts, TIMEOUT_MSEC);
-	io_uring_prep_timeout(sqe, &ts, 0, 0);
+	t_prep_timeout_rel(sqe, &ts, immediate);
 
 	ret = io_uring_submit(ring);
 	if (ret <= 0) {
@@ -219,7 +234,7 @@ err:
 /*
  * Test single timeout waking us up
  */
-static int test_single_timeout(struct io_uring *ring)
+static int test_single_timeout(struct io_uring *ring, bool immediate)
 {
 	struct io_uring_cqe *cqe;
 	struct io_uring_sqe *sqe;
@@ -235,7 +250,7 @@ static int test_single_timeout(struct io_uring *ring)
 	}
 
 	msec_to_ts(&ts, TIMEOUT_MSEC);
-	io_uring_prep_timeout(sqe, &ts, 0, 0);
+	t_prep_timeout_rel(sqe, &ts, immediate);
 
 	ret = io_uring_submit(ring);
 	if (ret <= 0) {
@@ -1765,7 +1780,7 @@ int main(int argc, char *argv[])
 	ret = io_uring_queue_init(8, &sqpoll_ring, IORING_SETUP_SQPOLL);
 	sqpoll = !ret;
 
-	ret = test_single_timeout(&ring);
+	ret = test_single_timeout(&ring, false);
 	if (ret) {
 		fprintf(stderr, "test_single_timeout failed\n");
 		return ret;
@@ -1773,6 +1788,15 @@ int main(int argc, char *argv[])
 	if (not_supported)
 		return 0;
 
+	ret = test_single_timeout(&ring, true);
+	if (ret == -EINVAL) {
+		no_immediate = true;
+		printf("Immeidate timeout arguments not supported\n");
+	} else if (ret) {
+		fprintf(stderr, "test_single_timeout (imm) failed\n");
+		return ret;
+	}
+
 	ret = test_multi_timeout(&ring);
 	if (ret) {
 		fprintf(stderr, "test_multi_timeout failed\n");
@@ -1797,12 +1821,20 @@ int main(int argc, char *argv[])
 		return ret;
 	}
 
-	ret = test_single_timeout_many(&ring);
+	ret = test_single_timeout_many(&ring, false);
 	if (ret) {
 		fprintf(stderr, "test_single_timeout_many failed\n");
 		return ret;
 	}
 
+	if (!no_immediate) {
+		ret = test_single_timeout_many(&ring, true);
+		if (ret) {
+			fprintf(stderr, "test_single_timeout_many (imm) failed\n");
+			return ret;
+		}
+	}
+
 	ret = test_single_timeout_nr(&ring, 1);
 	if (ret) {
 		fprintf(stderr, "test_single_timeout_nr(1) failed\n");
-- 
2.53.0


