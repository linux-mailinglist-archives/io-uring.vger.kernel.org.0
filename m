Return-Path: <io-uring+bounces-4752-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 157BD9CFBC6
	for <lists+io-uring@lfdr.de>; Sat, 16 Nov 2024 01:38:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A57CCB25BC0
	for <lists+io-uring@lfdr.de>; Sat, 16 Nov 2024 00:38:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F13A2F22;
	Sat, 16 Nov 2024 00:38:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="Hr8CxAqx"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A79B54A2D
	for <io-uring@vger.kernel.org>; Sat, 16 Nov 2024 00:38:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731717512; cv=none; b=fT3kMXqS4aRU1TZIo8pzOeH2EYZE5FaURSo8uZIEB7dRgKGrtaBV+vtutFmEW3hV2jdwvDL+UDBFLkFSmHKssoObQ4EZzq1wnaX7iWw41gbNdKul3klAf6uLHxwe8crCMZMH75HqcBgamo3InLBg/xxyoOrurGR1DCbvmS7Qh2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731717512; c=relaxed/simple;
	bh=t1vCeo5lTQFQurmgvCD7KrtQWeTgc4JK48eez+iOc/0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type:
	 References; b=ddfLRgka9cBSr0HvLzkWlkkZ/gjdYA01w0M0JwXfAyy6RiHjqT/mBg8yNAqvF8MkvB/BYX9t9oQgXxScxyG7Kua58MfKOI5X0h6CAVJOLq5RAuPQMkLVkTahNQ0+FbvMnLWAPBtbFx+tV5ddcIBCeW28CXv3cDbCq5KoLVZUygE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=Hr8CxAqx; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20241116003822epoutp04d34065db8639ae77e27476c68524bec5~IS_SfvYO_0817208172epoutp04C
	for <io-uring@vger.kernel.org>; Sat, 16 Nov 2024 00:38:22 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20241116003822epoutp04d34065db8639ae77e27476c68524bec5~IS_SfvYO_0817208172epoutp04C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1731717502;
	bh=IwlTmZT5ly83ymAFq3LsD5a0KejeC0vx6fyHaxqjcEk=;
	h=From:To:Cc:Subject:Date:References:From;
	b=Hr8CxAqxAbZLLLPWzEEBtP2Va8AbviJx6HowneSBiiJ05GPSygGdZDReb36UUwT7h
	 RC9p+7bqzG0mfdzjfUzmh9h/TFeXpPJn4+x6VkhVYuCUpYluelf1/lN0TZs5GlWXCH
	 uXMyyuturYOi4LKdgYulNXuWLLFhXgVvCjdqxHgM=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTP id
	20241116003820epcas5p2c3a89d566507d8c8f6f6e9d7c71656fb~IS_RhTp3P0681106811epcas5p23;
	Sat, 16 Nov 2024 00:38:20 +0000 (GMT)
Received: from epsmgec5p1-new.samsung.com (unknown [182.195.38.182]) by
	epsnrtp4.localdomain (Postfix) with ESMTP id 4Xqw3b1zvzz4x9Pv; Sat, 16 Nov
	2024 00:38:19 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
	epsmgec5p1-new.samsung.com (Symantec Messaging Gateway) with SMTP id
	B4.E8.15219.B79E7376; Sat, 16 Nov 2024 09:38:19 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20241115070021epcas5p4bf0dddfd2e511f43efd4587ba408e6ed~IEihehJKm0640806408epcas5p45;
	Fri, 15 Nov 2024 07:00:21 +0000 (GMT)
Received: from epsmgmc1p1new.samsung.com (unknown [182.195.42.40]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20241115070021epsmtrp18b8fdeeeb39192e18a49c2634f5e9cef~IEihc6Wsn1170311703epsmtrp1f;
	Fri, 15 Nov 2024 07:00:21 +0000 (GMT)
X-AuditID: b6c32a50-26bbe70000023b73-eb-6737e97b0c8e
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgmc1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	22.92.07371.581F6376; Fri, 15 Nov 2024 16:00:21 +0900 (KST)
Received: from testpc11818.samsungds.net (unknown [109.105.118.18]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20241115070019epsmtip2ac98dd1d3045cbc200bb1f6a9d50768e~IEif9Jodj2740227402epsmtip2w;
	Fri, 15 Nov 2024 07:00:19 +0000 (GMT)
From: hexue <xue01.he@samsung.com>
To: axboe@kernel.dk, asml.silence@gmail.com
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org, hexue
	<xue01.he@samsung.com>
Subject: [PATCH liburing v3] test: add test cases for hybrid iopoll
Date: Fri, 15 Nov 2024 15:00:13 +0800
Message-ID: <20241115070013.882470-1-xue01.he@samsung.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrNKsWRmVeSWpSXmKPExsWy7bCmpm71S/N0g/V3eSzmrNrGaLH6bj+b
	xbvWcywWv7rvMlpc3jWHzeLshA+sFl0XTrE5sHvsnHWX3ePy2VKPvi2rGD0+b5ILYInKtslI
	TUxJLVJIzUvOT8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21VXLxCdB1y8wBOkBJoSwxpxQo
	FJBYXKykb2dTlF9akqqQkV9cYquUWpCSU2BSoFecmFtcmpeul5daYmVoYGBkClSYkJ3x//Qq
	loIjGhW3/uk0MJ6V72Lk5JAQMJFo+reUDcQWEtjDKPF6E2cXIxeQ/YlRYu+XTcwQzjdGifbZ
	d9hgOk7uXcECkdjLKDFj0gomCOcHo8Th9YsYQarYBJQk9m/5AGaLCGhLvH48FaiDg4NZIEri
	xVpukLCwgLPE+dlfGEHCLAKqEvuXZYOEeQWsJM7+PMgOsUteYvGO5cwQcUGJkzOfsIDYzEDx
	5q2zwY6TEDjGLtE9cylUg4vEx62XoWxhiVfHt0DZUhIv+9ug7HyJyd/XM0LYNRLrNr9jgbCt
	Jf5d2QN1pqbE+l36EGFZiamn1jFB7OWT6P39hAkiziuxYx6MrSSx5MgKqJESEr8nLGKFsD0k
	Hk7ayw4J3ViJ151rmScwys9C8s4sJO/MQti8gJF5FaNUakFxbnpqsmmBoW5eajk8WpPzczcx
	glOhVsAOxtUb/uodYmTiYDzEKMHBrCTCe8nVPF2INyWxsiq1KD++qDQntfgQoykwjCcyS4km
	5wOTcV5JvKGJpYGJmZmZiaWxmaGSOO/r1rkpQgLpiSWp2ampBalFMH1MHJxSDUza/zoiIgU9
	OKxt7O7lf1p3Z8XrN43clb0nGYQ52U/KqZz8Y3/9fqDmVyNdyQ9lVewF81JOTPU68UHo7eHl
	p1/9XPS8d//MvH+5T+ysTd+HRPh/nP6bs+zssUTNXq7Hu1/EvCjdmim44flS0ftRdlXNd7av
	Ofpih0jxA6kD3837P3you2meP0mf7dzp9v5tL4zuiW8L0dWXLd7w98zivf+2ZO15duxSTvjT
	LJnpa5frVfTO3Tv7vLTj5unGl7k+r61mMH/05VVAkOm3R4lZ3zapbTpa6ZTSwM1R4fL388MJ
	Ro8Ou3dOufTTv7pTzuaIbvKBG4/2Ck5esauBYcsvxoXMz612bTqp7F+vemT65i+rSpVYijMS
	DbWYi4oTAZPGvt4OBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrGLMWRmVeSWpSXmKPExsWy7bCSvG7rR7N0g59XuSzmrNrGaLH6bj+b
	xbvWcywWv7rvMlpc3jWHzeLshA+sFl0XTrE5sHvsnHWX3ePy2VKPvi2rGD0+b5ILYInisklJ
	zcksSy3St0vgyvh/ehVLwRGNilv/dBoYz8p3MXJySAiYSJzcu4Kli5GLQ0hgN6NE07L3LBAJ
	CYkdj/6wQtjCEiv/PWeHKPrGKLHk0nRGkASbgJLE/i0fgGwODhEBXYnGuwogYWaBGIkPeyaw
	g9jCAs4S52d/ASthEVCV2L8sGyTMK2AlcfbnQXaI8fISi3csZ4aIC0qcnPmEBWKMvETz1tnM
	Exj5ZiFJzUKSWsDItIpRMrWgODc9N9mwwDAvtVyvODG3uDQvXS85P3cTIzgotTR2MN6b/0/v
	ECMTB+MhRgkOZiUR3lPOxulCvCmJlVWpRfnxRaU5qcWHGKU5WJTEeQ1nzE4REkhPLEnNTk0t
	SC2CyTJxcEo1MHkFd1b90O2ocVt6Piqv6iBHt09w3LKWsDUWu9ncKgUuPJW9nDRppcKMa3uU
	RBNCxUsuCa8KCd9wKXSTVmhI2yKGyLVVJapJ/+fXHFT4fO9U57Q/yTyMe1+fnNux612Xp8u1
	Y+6Md8tnXJh2aaabhZT79apTh1I27m1/3bFr2/rVjxTPi7zJqDsx1yLsKLt81nSbPV2vL1VW
	dF6Qq2WKlTwU+9NbcPtMkdxMGbbrasv5FRrXXnuz++Kz2zmylnGFLCLZE/NFvi+LFZ5958yW
	i5c2N/m/5rm2JHoP2zFmdqlrO9ju7pjT8+feDJv3zFze/2q+XNG859um7pAq45Ou9fX4v1s+
	K9x03fYGhRlsm6HEUpyRaKjFXFScCADbLu91uQIAAA==
X-CMS-MailID: 20241115070021epcas5p4bf0dddfd2e511f43efd4587ba408e6ed
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20241115070021epcas5p4bf0dddfd2e511f43efd4587ba408e6ed
References: <CGME20241115070021epcas5p4bf0dddfd2e511f43efd4587ba408e6ed@epcas5p4.samsung.com>

Add a test file for hybrid iopoll to make sure it works safe.Test case
include basic read/write tests, and run in normal iopoll mode and
passthrough mode respectively.

--
changes since v1:
- remove iopoll-hybridpoll.c
- test hybrid poll with exsiting iopoll and io_uring_passthrough
- add a misconfiguration check

changes since v2:
- modify description of man doc

Signed-off-by: hexue <xue01.he@samsung.com>
---
 man/io_uring_setup.2            | 10 +++++++++-
 src/include/liburing/io_uring.h |  3 +++
 test/io_uring_passthrough.c     | 14 +++++++++-----
 test/iopoll.c                   | 22 +++++++++++++---------
 4 files changed, 34 insertions(+), 15 deletions(-)

diff --git a/man/io_uring_setup.2 b/man/io_uring_setup.2
index 2f87783..f226db0 100644
--- a/man/io_uring_setup.2
+++ b/man/io_uring_setup.2
@@ -78,7 +78,15 @@ in question. For NVMe devices, the nvme driver must be loaded with the
 parameter set to the desired number of polling queues. The polling queues
 will be shared appropriately between the CPUs in the system, if the number
 is less than the number of online CPU threads.
-
+.TP
+.B IORING_SETUP_HYBRID_IOPOLL
+This flag must be used with
+.B IORING_SETUP_IOPOLL
+flag. Hybrid io polling is a feature based on iopoll, it differs from strict
+polling in that it will delay a bit before doing completion side polling, to
+avoid wasting too much CPU resources. Like
+.B IOPOLL
+, it requires that devices support polling.
 .TP
 .B IORING_SETUP_SQPOLL
 When this flag is specified, a kernel thread is created to perform
diff --git a/src/include/liburing/io_uring.h b/src/include/liburing/io_uring.h
index 20bc570..d16364c 100644
--- a/src/include/liburing/io_uring.h
+++ b/src/include/liburing/io_uring.h
@@ -200,6 +200,9 @@ enum io_uring_sqe_flags_bit {
  */
 #define IORING_SETUP_NO_SQARRAY		(1U << 16)
 
+/* Use hybrid poll in iopoll process */
+#define IORING_SETUP_HYBRID_IOPOLL      (1U << 17)
+
 enum io_uring_op {
 	IORING_OP_NOP,
 	IORING_OP_READV,
diff --git a/test/io_uring_passthrough.c b/test/io_uring_passthrough.c
index f18a186..bea4f39 100644
--- a/test/io_uring_passthrough.c
+++ b/test/io_uring_passthrough.c
@@ -254,7 +254,7 @@ err:
 }
 
 static int test_io(const char *file, int tc, int read, int sqthread,
-		   int fixed, int nonvec)
+		   int fixed, int nonvec, int hybrid)
 {
 	struct io_uring ring;
 	int ret, ring_flags = 0;
@@ -265,6 +265,9 @@ static int test_io(const char *file, int tc, int read, int sqthread,
 	if (sqthread)
 		ring_flags |= IORING_SETUP_SQPOLL;
 
+	if (hybrid)
+		ring_flags |= IORING_SETUP_IOPOLL | IORING_SETUP_HYBRID_IOPOLL;
+
 	ret = t_create_ring(64, &ring, ring_flags);
 	if (ret == T_SETUP_SKIP)
 		return 0;
@@ -449,18 +452,19 @@ int main(int argc, char *argv[])
 
 	vecs = t_create_buffers(BUFFERS, BS);
 
-	for (i = 0; i < 16; i++) {
+	for (i = 0; i < 32; i++) {
 		int read = (i & 1) != 0;
 		int sqthread = (i & 2) != 0;
 		int fixed = (i & 4) != 0;
 		int nonvec = (i & 8) != 0;
+		int hybrid = (i & 16) != 0;
 
-		ret = test_io(fname, i, read, sqthread, fixed, nonvec);
+		ret = test_io(fname, i, read, sqthread, fixed, nonvec, hybrid);
 		if (no_pt)
 			break;
 		if (ret) {
-			fprintf(stderr, "test_io failed %d/%d/%d/%d\n",
-				read, sqthread, fixed, nonvec);
+			fprintf(stderr, "test_io failed %d/%d/%d/%d/%d\n",
+				read, sqthread, fixed, nonvec, hybrid);
 			goto err;
 		}
 	}
diff --git a/test/iopoll.c b/test/iopoll.c
index 2e0f7ea..5ff26a4 100644
--- a/test/iopoll.c
+++ b/test/iopoll.c
@@ -351,7 +351,7 @@ ok:
 }
 
 static int test_io(const char *file, int write, int sqthread, int fixed,
-		   int buf_select, int defer)
+		   int hybrid, int buf_select, int defer)
 {
 	struct io_uring ring;
 	int ret, ring_flags = IORING_SETUP_IOPOLL;
@@ -363,6 +363,9 @@ static int test_io(const char *file, int write, int sqthread, int fixed,
 		ring_flags |= IORING_SETUP_SINGLE_ISSUER |
 			      IORING_SETUP_DEFER_TASKRUN;
 
+	if (hybrid)
+		ring_flags |= IORING_SETUP_HYBRID_IOPOLL;
+
 	ret = t_create_ring(64, &ring, ring_flags);
 	if (ret == T_SETUP_SKIP)
 		return 0;
@@ -418,22 +421,23 @@ int main(int argc, char *argv[])
 
 	vecs = t_create_buffers(BUFFERS, BS);
 
-	nr = 32;
+	nr = 64;
 	if (no_buf_select)
-		nr = 8;
-	else if (!t_probe_defer_taskrun())
 		nr = 16;
+	else if (!t_probe_defer_taskrun())
+		nr = 32;
 	for (i = 0; i < nr; i++) {
 		int write = (i & 1) != 0;
 		int sqthread = (i & 2) != 0;
 		int fixed = (i & 4) != 0;
-		int buf_select = (i & 8) != 0;
-		int defer = (i & 16) != 0;
+		int hybrid = (i & 8) != 0;
+		int buf_select = (i & 16) != 0;
+		int defer = (i & 32) != 0;
 
-		ret = test_io(fname, write, sqthread, fixed, buf_select, defer);
+		ret = test_io(fname, write, sqthread, fixed, hybrid, buf_select, defer);
 		if (ret) {
-			fprintf(stderr, "test_io failed %d/%d/%d/%d/%d\n",
-				write, sqthread, fixed, buf_select, defer);
+			fprintf(stderr, "test_io failed %d/%d/%d/%d/%d/%d\n",
+				write, sqthread, fixed, hybrid, buf_select, defer);
 			goto err;
 		}
 		if (no_iopoll)
-- 
2.34.1


