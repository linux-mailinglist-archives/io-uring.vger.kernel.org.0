Return-Path: <io-uring+bounces-4678-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 44FD09C8249
	for <lists+io-uring@lfdr.de>; Thu, 14 Nov 2024 06:04:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 054E1283473
	for <lists+io-uring@lfdr.de>; Thu, 14 Nov 2024 05:04:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35A5C1E9063;
	Thu, 14 Nov 2024 05:04:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="QsrWfrV9"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54B57165F04
	for <io-uring@vger.kernel.org>; Thu, 14 Nov 2024 05:04:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731560681; cv=none; b=YWLw0VNMRsDu/3JFs6s0hOzv69rhGpFf0rXi2GlGvk0E1H1ZibXQmQMwedqIfQhSJlDefHCpFfxaSeHuwVciBItBAzvzKZkz7Uwmde/BLi6Ii2ic/MrXl6pBgRwORStI5Y5F0LGsi9YVC0JeKTegiEz28UOl+rlgKFpYhkQolzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731560681; c=relaxed/simple;
	bh=Eorl1b/PWmz0PJHSCwv7oqTUSr78hFNEpjuAUa3SIdo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type:
	 References; b=B1DYbXinHVwt+/mMhWFx2GIcCcOXVlZNvaozacTAmiDBqjrAIS15GelFo4n8TUR46bno4i+QYWHgNp/jbNu8WyHp749LN3+osbznbpoJUvd7YYf7MYG64dxUoc5sT9G2kRLU3fFZN7d9cf5J8b0IP0i0zpHoCb1VV6b7GRux5uo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=QsrWfrV9; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20241114050436epoutp01e1ce943c470ec425b08a944ac7cd0c32~HvUK6KSXg1436214362epoutp01_
	for <io-uring@vger.kernel.org>; Thu, 14 Nov 2024 05:04:36 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20241114050436epoutp01e1ce943c470ec425b08a944ac7cd0c32~HvUK6KSXg1436214362epoutp01_
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1731560676;
	bh=4YQ6uCC4OSG3NhE6RFZXfsLmmQ3G7Wkfx+ZBnC6nO6A=;
	h=From:To:Cc:Subject:Date:References:From;
	b=QsrWfrV9XvCgRtOSH0avNQWuO9xoShPhj1vjTQ6PE+B0k/nsNvRIdELIPE2NYSZsr
	 ASCiaUIDgONMPlS1WBII+tNXuDDLLOJbv6jO+B7IfMOk1H+3wGw1hgT7dIJYuMKpbG
	 kBEyILUetnjgo0fyVYj81SwWaPvfg0N/XQZZmUzI=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTP id
	20241114050435epcas5p151e020e858afbcf3062c4d7a2759e58f~HvUKk8hnp1173811738epcas5p1X;
	Thu, 14 Nov 2024 05:04:35 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.178]) by
	epsnrtp2.localdomain (Postfix) with ESMTP id 4Xpp3j27jDz4x9Pv; Thu, 14 Nov
	2024 05:04:33 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
	epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	09.AD.09770.1E485376; Thu, 14 Nov 2024 14:04:33 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20241114050337epcas5p174214fb58aedefee4077447fa71b70f0~HvTUTsNHi2722427224epcas5p1x;
	Thu, 14 Nov 2024 05:03:37 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20241114050337epsmtrp1bca2e4b107ef07eb613437a8ddc923bd~HvTUS_wNY0328503285epsmtrp11;
	Thu, 14 Nov 2024 05:03:37 +0000 (GMT)
X-AuditID: b6c32a4a-bbfff7000000262a-40-673584e15314
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
	0D.6C.18937.9A485376; Thu, 14 Nov 2024 14:03:37 +0900 (KST)
Received: from testpc11818.samsungds.net (unknown [109.105.118.18]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20241114050336epsmtip1c4ca0cf52b6e725b7e3cabf426478d64~HvTTQcxlA0406004060epsmtip1S;
	Thu, 14 Nov 2024 05:03:36 +0000 (GMT)
From: hexue <xue01.he@samsung.com>
To: axboe@kernel.dk, asml.silence@gmail.com
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org, hexue
	<xue01.he@samsung.com>
Subject: [PATCH liburing v2] test: add test cases for hybrid iopoll
Date: Thu, 14 Nov 2024 13:03:30 +0800
Message-ID: <20241114050330.4006367-1-xue01.he@samsung.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrHKsWRmVeSWpSXmKPExsWy7bCmpu7DFtN0g2lPeSzmrNrGaLH6bj+b
	xbvWcywWc39GWVzeNYfN4uyED6wWXRdOsTmwe+ycdZfd4/LZUo/bBz8ze/RtWcXo8XmTXABr
	VLZNRmpiSmqRQmpecn5KZl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtARSgpl
	iTmlQKGAxOJiJX07m6L80pJUhYz84hJbpdSClJwCkwK94sTc4tK8dL281BIrQwMDI1OgwoTs
	jA9PfjMV7NGp+PlwP2MD42OlLkZODgkBE4nzCxYzdTFycQgJ7GaU6Fj0lg3C+cQosfh0EzNI
	FZjze0cQTMfyqc1QHTsZJV6dWM0I4fxglGjZsJ4RpIpNQEli/5YPYLaIgLbE68dTWboYOTiY
	BaIkXqzlBgkLCzhLXHt7hhXEZhFQlfh17CcbiM0rYC0x68t2Nohl8hKLdyxnhogLSpyc+YQF
	xGYGijdvnc0MUXOMXeLOTw4I20XiwcEvrBC2sMSr41vYIWwpiZf9bVB2vsTk7xBnSgjUSKzb
	/I4FwraW+HdlD9SZmhLrd+lDhGUlpp5axwSxlk+i9/cTJog4r8SOeTC2ksSSIyugRkpI/J6w
	iBVkjISAh8TXnWWQIIyVOPfkF8sERvlZSJ6ZheSZWQiLFzAyr2KUTC0ozk1PLTYtMMpLLYfH
	anJ+7iZGcELU8trB+PDBB71DjEwcjIcYJTiYlUR4TzkbpwvxpiRWVqUW5ccXleakFh9iNAWG
	8ERmKdHkfGBKziuJNzSxNDAxMzMzsTQ2M1QS533dOjdFSCA9sSQ1OzW1ILUIpo+Jg1Oqgalx
	eTPPzUDWg7mJpre/617s5AzUapq6STu8U0K13N2ygqmt7rqfg92XWzF7FgvtlL7lMYP7/Ol4
	m62ftKSn7XTcXbOqRNLHfvKV3+or9BefubXH70dgRxEbY07gvg1sZxfyzPw+N6vqwf3aP1Zd
	x6ZETvi/8+6d3vbUqhVp8g2PCs5vtkoQOiQpPXuRKdvWieecAljmCx1+4cA7ubPz2FOprb7r
	GA+2l3EWu1TVSdzT0+3aHZ558fTaQKV1TKH9t7cdfGaQ5anfv1nw5oatU008ym7Ixz06EVcz
	80LNEXX7SVavnWfW/OGcum/brqf2lXtcVs96No3LZ6HHTubVVoVpCWHsE/eUunpfOWsyk0mJ
	pTgj0VCLuag4EQDP5ISOEQQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrBLMWRmVeSWpSXmKPExsWy7bCSnO7KFtN0g+lLhSzmrNrGaLH6bj+b
	xbvWcywWc39GWVzeNYfN4uyED6wWXRdOsTmwe+ycdZfd4/LZUo/bBz8ze/RtWcXo8XmTXABr
	FJdNSmpOZllqkb5dAlfGhye/mQr26FT8fLifsYHxsVIXIyeHhICJxPKpzUxdjFwcQgLbGSWu
	/VvDCJGQkNjx6A8rhC0ssfLfc3aIom+MEm1nJjOBJNgElCT2b/kA1MDBISKgK9F4VwEkzCwQ
	I/FhzwR2EFtYwFni2tszYHNYBFQlfh37yQZi8wpYS8z6sp0NYr68xOIdy5kh4oISJ2c+YYGY
	Iy/RvHU28wRGvllIUrOQpBYwMq1iFE0tKM5Nz00uMNQrTswtLs1L10vOz93ECA5MraAdjMvW
	/9U7xMjEwXiIUYKDWUmE95SzcboQb0piZVVqUX58UWlOavEhRmkOFiVxXuWczhQhgfTEktTs
	1NSC1CKYLBMHp1QDU6zMZcaJ+2yvNPUmnuV6xPuw/ezZCYyMRvFzFmdqq/XFvuj/3S39RJMv
	WORi4Y4bTW4fzWf/LAwXPPb0jts838mG2tOmPEjdsfhxhm+zekDwqZbnM94LMj3/MG/PMU0v
	37MSfq476zzW/G73eDY/VGBC+fXtx3m8FlwtDT1Y0LFtxscjGbJxi+KMxOz0OBesLtx1dFvb
	rzmPPrbccfIQVwo7p7jR69oL66U8xx3LmUI5TK9Pi4nfmS+k9HThXfuqhSllzX9qlHT99vOp
	HZkhkbXk3fOFx7YETLGutj24pij5imZQK19xt4mvo5DVJIaMdTsLG7ZNOLK7IHtWhufF7tnn
	hX9vFYjb8ORZzha1PCWW4oxEQy3mouJEAPHGuAq7AgAA
X-CMS-MailID: 20241114050337epcas5p174214fb58aedefee4077447fa71b70f0
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20241114050337epcas5p174214fb58aedefee4077447fa71b70f0
References: <CGME20241114050337epcas5p174214fb58aedefee4077447fa71b70f0@epcas5p1.samsung.com>

Add a test file for hybrid iopoll to make sure it works safe.Test case
include basic read/write tests, and run in normal iopoll mode and
passthrough mode respectively.

--
changes since v1:
- remove iopoll-hybridpoll.c
- test hybrid poll with exsiting iopoll and io_uring_passthrough
- add a misconfiguration check

Signed-off-by: hexue <xue01.he@samsung.com>
---
 man/io_uring_setup.2            | 10 +++++++++-
 src/include/liburing/io_uring.h |  3 +++
 src/setup.c                     |  4 ++++
 test/io_uring_passthrough.c     | 14 +++++++++-----
 test/iopoll.c                   | 22 +++++++++++++---------
 5 files changed, 38 insertions(+), 15 deletions(-)

diff --git a/man/io_uring_setup.2 b/man/io_uring_setup.2
index 2f87783..fa928fa 100644
--- a/man/io_uring_setup.2
+++ b/man/io_uring_setup.2
@@ -78,7 +78,15 @@ in question. For NVMe devices, the nvme driver must be loaded with the
 parameter set to the desired number of polling queues. The polling queues
 will be shared appropriately between the CPUs in the system, if the number
 is less than the number of online CPU threads.
-
+.TP
+.B IORING_SETUP_HYBRID_IOPOLL
+This flag must setup with
+.B IORING_SETUP_IOPOLL
+flag. hybrid poll is a new
+feature baed on iopoll, this could be a suboptimal solution when running
+on a single thread, it offers higher performance than IRQ and lower CPU
+utilization than polling. Similarly, this feature also requires the devices
+to support polling configuration.
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
diff --git a/src/setup.c b/src/setup.c
index 073de50..d1a87aa 100644
--- a/src/setup.c
+++ b/src/setup.c
@@ -320,6 +320,10 @@ int __io_uring_queue_init_params(unsigned entries, struct io_uring *ring,
 			ring->int_flags |= INT_FLAG_APP_MEM;
 	}
 
+	if ((p->flags & (IORING_SETUP_IOPOLL|IORING_SETUP_HYBRID_IOPOLL)) ==
+			IORING_SETUP_HYBRID_IOPOLL)
+		return -EINVAL;
+
 	fd = __sys_io_uring_setup(entries, p);
 	if (fd < 0) {
 		if ((p->flags & IORING_SETUP_NO_MMAP) &&
diff --git a/test/io_uring_passthrough.c b/test/io_uring_passthrough.c
index f18a186..8604c42 100644
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
+			fprintf(stderr, "test_io failed %d/%d/%d/%d%d\n",
+				read, sqthread, fixed, nonvec, hybrid);
 			goto err;
 		}
 	}
diff --git a/test/iopoll.c b/test/iopoll.c
index 2e0f7ea..0d7bd77 100644
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
+			fprintf(stderr, "test_io failed %d/%d/%d/%d/%d%d\n",
+				write, sqthread, fixed, hybrid, buf_select, defer);
 			goto err;
 		}
 		if (no_iopoll)
-- 
2.34.1


