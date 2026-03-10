Return-Path: <io-uring+bounces-12611-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4E4cMg2qr2nibQIAu9opvQ
	(envelope-from <io-uring+bounces-12611-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 10 Mar 2026 06:20:13 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id CAB922456D2
	for <lists+io-uring@lfdr.de>; Tue, 10 Mar 2026 06:20:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id B8340301730E
	for <lists+io-uring@lfdr.de>; Tue, 10 Mar 2026 05:20:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 215DA126F3B;
	Tue, 10 Mar 2026 05:20:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SdL42Gw+"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-dy1-f172.google.com (mail-dy1-f172.google.com [74.125.82.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF0EE26B973
	for <io-uring@vger.kernel.org>; Tue, 10 Mar 2026 05:20:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773120009; cv=none; b=HbQAjMXXqYP9iSGgPt5okNsvG7cGMcaKpgSq+5pkVdkEQR7VCQqUMowN4kqpcWKBIC3vXq9UWWImlxBHpXGDiMbTLhQXDul23eKgAOuNsH73/itPLVZi9NVndQGNjc+gTut028F8j+nVExWW6Nqdx5YBNZhZ8lxcpXR1NerQyRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773120009; c=relaxed/simple;
	bh=BbKcvQ7mt385MhYGiSN9nUfQiCRbBax6u10YZhLCKTA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FdZ6uezTcTVNybVz/x35hdwr9LQVyAeplZXa8liU+bUcIMAiX9I3roJWgkU+bcckAV3OJr2iYH/cgy/iziaH9HIqQmId+1KgpJyBBf6x+md+C5hQ9EhrW8Ld/Y4lad6PofsWWx1wfkEbGyORO8qeG51bqkRLlcQRrI1km21qGBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SdL42Gw+; arc=none smtp.client-ip=74.125.82.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-dy1-f172.google.com with SMTP id 5a478bee46e88-2be27fa54feso10303536eec.0
        for <io-uring@vger.kernel.org>; Mon, 09 Mar 2026 22:20:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773120007; x=1773724807; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CkXSDCMdUKYEdHIlsA+xlEE1BHUCHTD6Efayo3Mqoio=;
        b=SdL42Gw+1ZDcVnc82dOmddvhpNjgleteX2KumLdJopfLt4trXpppZC7zn5XYKw80cB
         nUzxUUzB321k0MAQ57al8PxkrYvDSbffpVBUo7IPRImePg791AKEoUF3FXLHhVjWj3fF
         e68RMBIxYHSZ5JrOV2jWaJDOp5JA6kKo4//JR3/V/oWtwjaa2MjTiFS88xEiJHtz9GEB
         WNYOba7qMPHuWVUjJfXc45cXuSItwqFXB79CBsZlKTGLM4FAI4laBPqY8C76XhgL2b+Q
         B+Cl21W8KLME/+vG+YGP4FVQFetCge7j4nkEjZHKBisQoswStTOwF9p9vas9z3IrjQvG
         atdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773120007; x=1773724807;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=CkXSDCMdUKYEdHIlsA+xlEE1BHUCHTD6Efayo3Mqoio=;
        b=ig3a8NsWJdsW0u9hGndAfrFSvQ5R+b2lYhdTWOAiDhqOf/ek9UGTTUKM5VMK5SaFur
         wp3oc4Hvft0QsHUCEwiew97LFqY6CNpBbpWDvxP4levW8+lnJD0No0u4yTrE0TjriJu4
         L2U8YncTfouFc8Fghrf9SvW3R1gFbt+u3Iv7Cpd/SJsBGNX16cgQvlG7ZpXfAGbcvPN5
         8jhTkQLt3HPtrEpfKeTsMnrTZYGbOMmpsDgpLwuyXDxIcCHzRtxsGYCRAaUpq2qzkK5d
         9RvDupQvOfByQKeFZkPe7VFgjc5Mhi3VxRPFM861uJG+E2DiPdB06cdCLuVeD4lrFOUs
         gJig==
X-Gm-Message-State: AOJu0YyL5cxXvy84jUJ0ykARcSEihRBzWb2HSulO9NNRA4HrC8tXzgr6
	REpknuynSTqPTfbn6g2MMjhHBvU3fyVc/GNat+cpZLcN7oOCApU33F84cTFR7d63
X-Gm-Gg: ATEYQzwmBChrBJEIlbyvrzBmfdZ8/auEjoXqLa3rkII3w5A43KkK6EkQ5C9UF1UrLFx
	yrjHyNXxjC1pEww58PER6mAgSH02XJDBYSQfrZaG8HviF7qh0ZbwlyNjn1WN+AAalHu0F3RQdoL
	cL/Xh7VzDcwsRsJTupzAaY3joYT0Q4Q3GkNov5vvK8R3yfRqQToShdqWoXgZGFo3n4eu7HrX/dC
	jRpCluPwFiFab9lECX4vyYp9lZ7y+QFkb1PRe7gAb/yIFUscvdIvCx6LtIL0DtsZhf2xgyHrEYc
	H7VeSU9goRGGSuIltGBWcYtkOxgIpdFalflkVitZwLDap+on9rcykw3y3ZvjK/Z3njCGiGihdfl
	/T0PhWZDjZBxxdNX17GXpFA6VN2gie2sOcbuwsW8o/D6YtTonT8salO6LNF0WB3Br1yBLzkTSgm
	rjCksGpTqU2bLZMWieiXRL+7iriDfBXhe2mMI5jyDw0oYU8dqaJadhCzHKGwSQKOdcbrzXnEL4z
	4TX5GmIaN0j
X-Received: by 2002:a05:7301:1e97:b0:2be:d6e:6ba3 with SMTP id 5a478bee46e88-2be4e05bb11mr5298507eec.24.1773120006570;
        Mon, 09 Mar 2026 22:20:06 -0700 (PDT)
Received: from localhost.localdomain ([109.104.115.136])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2be4f94833bsm11663237eec.18.2026.03.09.22.20.05
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 09 Mar 2026 22:20:06 -0700 (PDT)
From: Tom Ryan <ryan36005@gmail.com>
To: io-uring@vger.kernel.org
Cc: axboe@kernel.dk,
	gregkh@linuxfoundation.org,
	kbusch@kernel.org,
	csander@purestorage.com,
	Tom Ryan <ryan36005@gmail.com>
Subject: [PATCH liburing] test/sqe-mixed-boundary: validate physical SQE index for 128-byte ops
Date: Mon,  9 Mar 2026 22:20:03 -0700
Message-ID: <20260310052003.72871-2-ryan36005@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260310052003.72871-1-ryan36005@gmail.com>
References: <aa9Bjbplx3b_Uvmj@kbusch-mbp>
 <20260310052003.72871-1-ryan36005@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: CAB922456D2
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	FREEMAIL_CC(0.00)[kernel.dk,linuxfoundation.org,kernel.org,purestorage.com,gmail.com];
	TAGGED_FROM(0.00)[bounces-12611-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ryan36005@gmail.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[io-uring];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_FIVE(0.00)[6];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:rdns,sin.lore.kernel.org:helo]
X-Rspamd-Action: no action

Add a test for the kernel fix that replaces the cached_sq_head alignment
check with physical SQE index validation in io_init_req() for SQE_MIXED
128-byte operations.

test_valid_position: verifies that a NOP128 at a valid physical slot
(identity-mapped via sq_array) succeeds.

test_oob_boundary: verifies that a NOP128 remapped via sq_array to the
last physical SQE slot is rejected with -EINVAL, preventing a 64-byte
OOB read past the SQE array.

Signed-off-by: Tom Ryan <ryan36005@gmail.com>
---
 test/Makefile             |   1 +
 test/sqe-mixed-boundary.c | 182 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 183 insertions(+)
 create mode 100644 test/sqe-mixed-boundary.c

diff --git a/test/Makefile b/test/Makefile
index 7b94a1f..a10d44c 100644
--- a/test/Makefile
+++ b/test/Makefile
@@ -253,6 +253,7 @@ test_srcs := \
 	sq-poll-share.c \
 	sqpoll-sleep.c \
 	sq-space_left.c \
+	sqe-mixed-boundary.c \
 	sqe-mixed-nop.c \
 	sqe-mixed-bad-wrap.c \
 	sqe-mixed-uring_cmd.c \
diff --git a/test/sqe-mixed-boundary.c b/test/sqe-mixed-boundary.c
new file mode 100644
index 0000000..f2e6b47
--- /dev/null
+++ b/test/sqe-mixed-boundary.c
@@ -0,0 +1,182 @@
+/* SPDX-License-Identifier: MIT */
+/*
+ * Description: test SQE_MIXED physical SQE boundary validation with sq_array
+ *
+ * Verify that 128-byte operations are correctly rejected when sq_array
+ * remaps them to the last physical SQE slot, preventing a 64-byte OOB
+ * read past the SQE array.
+ */
+#include <stdio.h>
+#include <string.h>
+
+#include "liburing.h"
+#include "helpers.h"
+#include "test.h"
+
+#define NENTRIES	64
+
+/*
+ * Positive test: NOP128 at a valid physical position should succeed.
+ */
+static int test_valid_position(void)
+{
+	struct io_uring ring;
+	struct io_uring_cqe *cqe;
+	struct io_uring_sqe *sqe;
+	int ret;
+
+	ret = io_uring_queue_init(NENTRIES, &ring, IORING_SETUP_SQE_MIXED);
+	if (ret) {
+		if (ret == -EINVAL)
+			return T_EXIT_SKIP;
+		fprintf(stderr, "ring init: %d\n", ret);
+		return T_EXIT_FAIL;
+	}
+
+	sqe = io_uring_get_sqe(&ring);
+	io_uring_prep_nop(sqe);
+	sqe->user_data = 1;
+
+	sqe = io_uring_get_sqe128(&ring);
+	if (!sqe) {
+		fprintf(stderr, "get_sqe128 failed\n");
+		goto fail;
+	}
+	io_uring_prep_nop128(sqe);
+	sqe->user_data = 2;
+
+	ret = io_uring_submit(&ring);
+	if (ret < 0) {
+		fprintf(stderr, "submit: %d\n", ret);
+		goto fail;
+	}
+
+	ret = io_uring_wait_cqe(&ring, &cqe);
+	if (ret) {
+		fprintf(stderr, "wait_cqe: %d\n", ret);
+		goto fail;
+	}
+	io_uring_cqe_seen(&ring, cqe);
+
+	ret = io_uring_wait_cqe(&ring, &cqe);
+	if (ret) {
+		fprintf(stderr, "wait_cqe: %d\n", ret);
+		goto fail;
+	}
+	if (cqe->user_data == 2 && cqe->res != 0) {
+		fprintf(stderr, "NOP128 at valid position failed: %d\n",
+			cqe->res);
+		io_uring_cqe_seen(&ring, cqe);
+		goto fail;
+	}
+	io_uring_cqe_seen(&ring, cqe);
+
+	io_uring_queue_exit(&ring);
+	return T_EXIT_PASS;
+fail:
+	io_uring_queue_exit(&ring);
+	return T_EXIT_FAIL;
+}
+
+/*
+ * Negative test: NOP128 at the last physical SQE slot via sq_array remap
+ * must be rejected. Without the kernel fix, this triggers a 64-byte OOB
+ * read in io_uring_cmd_sqe_copy().
+ */
+static int test_oob_boundary(void)
+{
+	struct io_uring ring;
+	struct io_uring_cqe *cqe;
+	struct io_uring_sqe *sqe;
+	unsigned mask;
+	int ret, i, found;
+
+	ret = io_uring_queue_init(NENTRIES, &ring, IORING_SETUP_SQE_MIXED);
+	if (ret) {
+		if (ret == -EINVAL)
+			return T_EXIT_SKIP;
+		fprintf(stderr, "ring init: %d\n", ret);
+		return T_EXIT_FAIL;
+	}
+
+	mask = *ring.sq.kring_entries - 1;
+
+	/* Advance internal tail: NOP (1) + NOP128 (2) = 3 slots */
+	sqe = io_uring_get_sqe(&ring);
+	io_uring_prep_nop(sqe);
+	sqe->user_data = 1;
+
+	sqe = io_uring_get_sqe128(&ring);
+	if (!sqe) {
+		fprintf(stderr, "get_sqe128 failed\n");
+		goto fail;
+	}
+
+	/*
+	 * Override: remap logical position 1 to last physical slot.
+	 * Prep NOP128 there instead of the position get_sqe128 returned.
+	 */
+	ring.sq.array[1] = mask;
+	memset(&ring.sq.sqes[mask], 0, sizeof(struct io_uring_sqe));
+	io_uring_prep_nop128(&ring.sq.sqes[mask]);
+	ring.sq.sqes[mask].user_data = 2;
+
+	ret = io_uring_submit(&ring);
+	if (ret < 0) {
+		fprintf(stderr, "submit: %d\n", ret);
+		goto fail;
+	}
+
+	found = 0;
+	for (i = 0; i < 3; i++) {
+		ret = io_uring_wait_cqe(&ring, &cqe);
+		if (ret)
+			break;
+		if (cqe->user_data == 2) {
+			if (cqe->res != -EINVAL) {
+				fprintf(stderr,
+					"NOP128 at last slot: expected -EINVAL, got %d\n",
+					cqe->res);
+				io_uring_cqe_seen(&ring, cqe);
+				goto fail;
+			}
+			found = 1;
+		}
+		io_uring_cqe_seen(&ring, cqe);
+	}
+
+	if (!found) {
+		fprintf(stderr, "no CQE for NOP128 boundary test\n");
+		goto fail;
+	}
+
+	io_uring_queue_exit(&ring);
+	return T_EXIT_PASS;
+fail:
+	io_uring_queue_exit(&ring);
+	return T_EXIT_FAIL;
+}
+
+int main(int argc, char *argv[])
+{
+	int ret;
+
+	if (argc > 1)
+		return T_EXIT_SKIP;
+
+	ret = test_valid_position();
+	if (ret == T_EXIT_SKIP)
+		return T_EXIT_SKIP;
+	if (ret) {
+		fprintf(stderr, "test_valid_position failed\n");
+		return T_EXIT_FAIL;
+	}
+
+	ret = test_oob_boundary();
+	if (ret) {
+		fprintf(stderr, "test_oob_boundary failed\n");
+		return ret;
+	}
+
+	return T_EXIT_PASS;
+}
-- 
2.50.1 (Apple Git-155)


