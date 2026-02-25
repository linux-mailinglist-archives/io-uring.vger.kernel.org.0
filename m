Return-Path: <io-uring+bounces-12420-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id ABb8Bj4xn2lXZQQAu9opvQ
	(envelope-from <io-uring+bounces-12420-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 25 Feb 2026 18:28:30 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id B5E8B19B8D9
	for <lists+io-uring@lfdr.de>; Wed, 25 Feb 2026 18:28:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 1E8413035483
	for <lists+io-uring@lfdr.de>; Wed, 25 Feb 2026 17:28:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C0933E9F7D;
	Wed, 25 Feb 2026 17:28:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Bw9CGybL"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96B883E9F9A
	for <io-uring@vger.kernel.org>; Wed, 25 Feb 2026 17:28:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772040495; cv=none; b=ikIHWRSVUr3SX97shfKq7Z2LD2xtREXIFFPbIPnNJPzbJXqWB3Wo3hSVckSXLhLqzpV/Se1PD7p3KzMafzj7g2NYunsMmcSFpR/a87na2OrZ0uNcR4hnXAQG+6/WD9LqApVxDgTNhK/rIp/j1iGr3T44nH0vAsGkQaYODbp/KoA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772040495; c=relaxed/simple;
	bh=xdhqC4I0YQ70IxrcnfpjFAvjjBmua1K62BAgzEErPfY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=vB/RalU6ad6ONKfNEdAH4Mr1p2tihl+6mRrXxIH525upeoWwi/O87i9t678JAAPmZ+OcDoZTcGPkU6zg/eGaVKvA21EFcCO0BqwivPUAIUwC22M/EHEqRGBooD3e6iCU97aQ2L25C+cZoRQSXVAgkAKmPuDHNjzcCJr/aDmaez0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Bw9CGybL; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-482f454be5bso11049445e9.0
        for <io-uring@vger.kernel.org>; Wed, 25 Feb 2026 09:28:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772040488; x=1772645288; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=TMQmOyGAqQj2qy00h0OMBwI+I5DQvE6dofnEajKCgh4=;
        b=Bw9CGybLpuPPfLoZtLIvUAvF6QSOLJ4NU1WwzEwcbw5aRtU5F+JKo0wM0A+U6n8HRu
         2s5KAhhngmyxRf3pABPID46RXGFvCdzVwO9zhR6XMMnOmGgwqIm05rWLFWYbuoam19R8
         9/k98mBvmurJKSFFML+Gpzoocn1rIwB/63SjOO9GDF+qRAnZ33ygvKVZDDyVZ9JZtMPU
         Iorf0eFrOQCQdUbOmtB0JZq469NZqVpdQkjOBYoiV1c6mHtX0pTd0AUs245nanT494uH
         PPn4I5xlzi+QUVMiIY4poxSMMtLDHyJUUqu4EkQR98LXKG7UXc/yYT/E9OFOhFsaxSwp
         81Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772040488; x=1772645288;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TMQmOyGAqQj2qy00h0OMBwI+I5DQvE6dofnEajKCgh4=;
        b=DnGKqAQ7WH8aXLRTzEhm09ci4JiLeS+T64OpSNY5gDiEnV61QhSjiZwn7xvFi8hXvN
         2FJtIUgweyiGdUppRu85SiDfjz2sypEqcp6m3wFHHcKsJ8h8VuksY2QJ4FPvIA5o58fC
         j6QaxNNrwkG1mqQPivvPgolo4AbnDc9YyjqSoKI7d2f0P1ixPOGPOI3XeZTMySAGjgS7
         YqI50iTCMEuJz53wWk0vBMoF/prDjXDHid/cs+R5PNtgGvi8sYwYrN2DeRlZA2VPI4ms
         JXS/U1DI4HLsXKxmikv/PXBOWNHKe8M0UQAl1yNnHLwRUtaL7nZkpAzp4pVX6rMdPmlk
         8hbQ==
X-Gm-Message-State: AOJu0YynsYx/wR60nuT74z403AxQTwV3LWK8vpSeoaf+UrNfxdmAkJAr
	FWT+oML2sppcktiTqgoiAEheGkBS2Anm9L2bAJs3hhGK1XN4JNbyipejj3OpTA==
X-Gm-Gg: ATEYQzyH/gLaGpcq7IoVrqO0rYy6NXTT4b8EJW/hCSk4k4CwEvCCPs0LaowHEJ7W7R3
	TfiiZ8pJO2X39ouSprJh/WzRMFITXW5oweOb5JXnZv2V0OAOmYoWRY6RjaxXGAcdFHPAFXa+gh+
	aD+GO1D/OagrBFt9TZKUzEvrxslAAoEibpn1Q2uizLzln1Qq5hI7hyLrG4jiX4IyHYslBuP+HA8
	cUplxoElzJgvKX9WrQJYiJk7Lv9TZwn/xwfVJyuhEUBjdisn3mwlXeFmAEEod07jPhvIdpywWIH
	UwwMH/HGxhSKF1027qmnXu0cJBwc59FiKMjCcSouJyH3Z10TwVEnYl7gVJoUDAuCb5aNd6lmTqU
	rOqAYSMK9JGR2JQVAyjvs47nU2H3XhRYnt/0f7b12YhSHjhmno8pmGAe75bOFApd+lJxISSFKyv
	6io6dGu88FksaprFRWd0ixJ2dryYBenBXiGG0cFuda6R2BC3QzCph12FiIZRcbIhJBSpNzCTp1J
	WMmX2wXF83GS7KzNlzyXObi8McZLA==
X-Received: by 2002:a05:600c:548a:b0:483:a352:b4e4 with SMTP id 5b1f17b1804b1-483bd73638emr79639195e9.6.1772040488015;
        Wed, 25 Feb 2026 09:28:08 -0800 (PST)
Received: from 127.mynet ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-483bd6f26d7sm92121945e9.3.2026.02.25.09.28.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Feb 2026 09:28:07 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	axboe@kernel.dk
Subject: [PATCH liburing v2 1/1] tests: test timeout with immediate arguments
Date: Wed, 25 Feb 2026 17:28:03 +0000
Message-ID: <86e674b0742b1931ce197b022d228cc9217bc737.1772040411.git.asml.silence@gmail.com>
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
	TAGGED_FROM(0.00)[bounces-12420-lists,io-uring=lfdr.de];
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
X-Rspamd-Queue-Id: B5E8B19B8D9
X-Rspamd-Action: no action

IORING_TIMEOUT_IMMEDIATE_ARG allows the user to store the timeout in the
SQE without indirection to a user timespec. Update io_uring.h and extend
tests to cover the feature.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 src/include/liburing/io_uring.h |  5 ++++
 test/timeout.c                  | 46 ++++++++++++++++++++++++++++-----
 2 files changed, 45 insertions(+), 6 deletions(-)

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
index 003ba743..6bef0a7e 100644
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
@@ -252,6 +267,11 @@ static int test_single_timeout(struct io_uring *ring)
 	ret = cqe->res;
 	io_uring_cqe_seen(ring, cqe);
 	if (ret == -EINVAL) {
+		if (immediate) {
+			no_immediate = true;
+			fprintf(stdout, "%s: Timeout (imm) not supported, ignored\n", __FUNCTION__);
+			return 0;
+		}
 		fprintf(stdout, "%s: Timeout not supported, ignored\n", __FUNCTION__);
 		not_supported = 1;
 		return 0;
@@ -1765,7 +1785,7 @@ int main(int argc, char *argv[])
 	ret = io_uring_queue_init(8, &sqpoll_ring, IORING_SETUP_SQPOLL);
 	sqpoll = !ret;
 
-	ret = test_single_timeout(&ring);
+	ret = test_single_timeout(&ring, false);
 	if (ret) {
 		fprintf(stderr, "test_single_timeout failed\n");
 		return ret;
@@ -1773,6 +1793,12 @@ int main(int argc, char *argv[])
 	if (not_supported)
 		return 0;
 
+	ret = test_single_timeout(&ring, true);
+	if (ret) {
+		fprintf(stderr, "test_single_timeout (imm) failed\n");
+		return ret;
+	}
+
 	ret = test_multi_timeout(&ring);
 	if (ret) {
 		fprintf(stderr, "test_multi_timeout failed\n");
@@ -1797,12 +1823,20 @@ int main(int argc, char *argv[])
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


