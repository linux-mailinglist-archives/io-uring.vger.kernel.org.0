Return-Path: <io-uring+bounces-2654-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A193D947791
	for <lists+io-uring@lfdr.de>; Mon,  5 Aug 2024 10:53:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4FA66280C15
	for <lists+io-uring@lfdr.de>; Mon,  5 Aug 2024 08:53:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A73FF13DDC2;
	Mon,  5 Aug 2024 08:53:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="J1XAhZtC"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5431713D503
	for <io-uring@vger.kernel.org>; Mon,  5 Aug 2024 08:53:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722848035; cv=none; b=Z6QaHD+cMzo0RhKRvPMMyQ9/xK9Yj0O0U3CqV1miHWh0icX0ovykOHlZoF7gjAxNenV9iCFBugicz8hO0X8Zk65OtEn7LdPZEWBHnahWkbE33cvlGqCWqvjemAAsfiD5zi1cwJ3a3kjg21XCCt3j5KmgetwQXycw25bh13rjWvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722848035; c=relaxed/simple;
	bh=n9r8UsQXxeUvA0twrQXXvlKdoKo6AiUtzrrDkYlZVAc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type:
	 References; b=U8oyvPSfdCCAOhLvAO0/DgRSYsCK7j4AAWb6bCpO0sXIhxHYlUa9rP5XOhyyrVkxFaiXmrZXP0rEgDQiEXPL071ErxWC85/pScjVwfrn+Ed5tkn4hcAKezueOj8jlaO8YPoyIamFOoTYkV/HCFD5AVhqRF651p8vjWdJzmP0tbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=J1XAhZtC; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20240805084700epoutp02a2e2d3e6c759f5da5cae34cb1f7bbf82~oyMhO8Y8r1140811408epoutp02S
	for <io-uring@vger.kernel.org>; Mon,  5 Aug 2024 08:47:00 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20240805084700epoutp02a2e2d3e6c759f5da5cae34cb1f7bbf82~oyMhO8Y8r1140811408epoutp02S
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1722847620;
	bh=uetkEzag5r5fl+Eg++G6xmeLHwKeW0WAmvfJ1f0LGaw=;
	h=From:To:Cc:Subject:Date:References:From;
	b=J1XAhZtCZHULHWdqniIX0jdLBZ/p2WfUAwugE850tpAjJTLgJ1PtvkMlnKLH6MFlC
	 x5mtrJ5IZrJ2Hdzphy54qOKdCzNr7bV6PSKuxG1NejlKs5JgEh3STdh9zbtzEavqU2
	 DbgLcQZ74VtDVoMUmQKV8EIgDnHIFZjwZqwdr6qA=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTP id
	20240805084659epcas5p29c6a08817975aeac2cdec89abc65b427~oyMg8icwd0400604006epcas5p22;
	Mon,  5 Aug 2024 08:46:59 +0000 (GMT)
Received: from epsmgec5p1new.samsung.com (unknown [182.195.38.183]) by
	epsnrtp4.localdomain (Postfix) with ESMTP id 4Wcqmx5W8Kz4x9Pv; Mon,  5 Aug
	2024 08:46:57 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
	epsmgec5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	2E.64.08855.18190B66; Mon,  5 Aug 2024 17:46:57 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20240805084453epcas5p363b93b10eaf53df5725417d3d7fbcca0~oyKq9TrsC2891328913epcas5p3S;
	Mon,  5 Aug 2024 08:44:53 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20240805084453epsmtrp20a2591099eeae2b43e11113a2cb8e6b0~oyKq8qqTa0718807188epsmtrp2S;
	Mon,  5 Aug 2024 08:44:53 +0000 (GMT)
X-AuditID: b6c32a44-107ff70000002297-46-66b091817ebd
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
	E2.DE.19367.40190B66; Mon,  5 Aug 2024 17:44:52 +0900 (KST)
Received: from lcl-Standard-PC-i440FX-PIIX-1996.. (unknown
	[109.105.118.124]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20240805084452epsmtip24329fcf418638d83100b29def362b046~oyKqBGFMV1151611516epsmtip2p;
	Mon,  5 Aug 2024 08:44:52 +0000 (GMT)
From: Chenliang Li <cliang01.li@samsung.com>
To: axboe@kernel.dk, asml.silence@gmail.com
Cc: io-uring@vger.kernel.org, gost.dev@samsung.com, Chenliang Li
	<cliang01.li@samsung.com>
Subject: [PATCH liburing] test/fixed-hugepage: Add small-huge page mixture
 testcase
Date: Mon,  5 Aug 2024 16:44:42 +0800
Message-Id: <20240805084442.4494-1-cliang01.li@samsung.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLKsWRmVeSWpSXmKPExsWy7bCmlm7jxA1pBpc3qlvMWbWN0WL13X42
	i9N/H7NY3Dywk8niXes5Fotf3XcZLc5O+MDqwO6xc9Zddo/LZ0s9+rasYvT4vEkugCUq2yYj
	NTEltUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMH6AAlhbLEnFKg
	UEBicbGSvp1NUX5pSapCRn5xia1SakFKToFJgV5xYm5xaV66Xl5qiZWhgYGRKVBhQnbGyktb
	2QtmKVQ0/jjK3MD4TLKLkZNDQsBEYvqaJlYQW0hgN6PEnDPBXYxcQPYnRomDZ7axwTlnO7oY
	YTqWnVjCBJHYCVQ18Sc7hNPEJLHv0Xs2kCo2AR2J3yt+sYDYIgLaEq8fTwWzmQViJH5eeABW
	IywQKvFlRh87iM0ioCrx6cUpsBpeAWuJ249uM0Nsk5fYf/AsM0RcUOLkzCdQc+QlmrfOZgZZ
	LCFwjF1i6eVdbBANLhK9LStYIWxhiVfHt7BD2FISn9/tBarhALKLJZatk4PobWGUeP9uDtRr
	1hL/ruxhAalhFtCUWL9LHyIsKzH11DomiL18Er2/nzBBxHkldsyDsVUlLhzcBrVKWmLthK1Q
	93tInFmylRESvrESty8/ZZ3AKD8LyTuzkLwzC2HzAkbmVYySqQXFuempyaYFhnmp5fCITc7P
	3cQITodaLjsYb8z/p3eIkYmD8RCjBAezkghvV+mGNCHelMTKqtSi/Pii0pzU4kOMpsAwnsgs
	JZqcD0zIeSXxhiaWBiZmZmYmlsZmhkrivK9b56YICaQnlqRmp6YWpBbB9DFxcEo1MKXFFwf5
	cnNkBJztqv9zcMbx1WJ1L6b456rk6j0T+e0QrRKbWN/e4LowvOHhvu29H53+q9i8mxszd03n
	KjMZiVr3t39avC0m/Oo2WXdHcPPnSXaLX6bFeE9XvKF9U9v8UvCBCXc2aTpu52a9IrPhZ7dT
	wDP2xp02S0rFslfNi1sjrLG73P/B396p7Jkl7eumO1/P0VFiVV0clfFA59/R5r1vcmLlFZ6d
	5HDqjdnk6hP4aO+JsI1CTBUuUakz7sr21Nzjvn/80Lu2qVE7H2p6fC5O/zNL+Mc5RY+fLZ0e
	3IZ+IsGh5kvDeuO9/BS3rdr745VB0g+PSRe/r3djnPvpStnHt3bra/ecD+hazahzUomlOCPR
	UIu5qDgRAKbz/O8QBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrCLMWRmVeSWpSXmKPExsWy7bCSvC7LxA1pBmcvWFvMWbWN0WL13X42
	i9N/H7NY3Dywk8niXes5Fotf3XcZLc5O+MDqwO6xc9Zddo/LZ0s9+rasYvT4vEkugCWKyyYl
	NSezLLVI3y6BK2Plpa3sBbMUKhp/HGVuYHwm2cXIySEhYCKx7MQSpi5GLg4hge2MErdnNbFB
	JKQlOg61skPYwhIr/z1nhyhqYJKY9+oPM0iCTUBH4veKXyxdjBwcIgK6Eo13FUDCzAJxEiuf
	n2YFsYUFgiU2zJvCCGKzCKhKfHpxigXE5hWwlrj96DYzxHx5if0HzzJDxAUlTs58wgIxR16i
	eets5gmMfLOQpGYhSS1gZFrFKJpaUJybnptcYKhXnJhbXJqXrpecn7uJERyQWkE7GJet/6t3
	iJGJg/EQowQHs5IIb1fphjQh3pTEyqrUovz4otKc1OJDjNIcLErivMo5nSlCAumJJanZqakF
	qUUwWSYOTqkGpi4/500qjzL0/sbx/d0rarRuMcvkpQ07L598oK+8wmXyjU2Nq+/7bgt53eia
	e2SD6rVHa1c9Nc1P9LV2rHt837j3+ma139N3F2mfvMum/CZPsaDbkk3LvN74+8OP3/KtNu/s
	FEtwXLvtruzd1vLdp75vrL2ivTB6UUGsO8O6zsXtXEffa5otiAtzfaF04e+izTP+P/0ixV2j
	xrxkRtLrySnLZ0zydn0XP+ViXZbmsTde57x/ni17L/dWvmHWl+lf2B8EZG6Jltv2+57v57tt
	IW8qy+Kj6vrsV9mau11fVLX0qfCi2XKhfs/fWu2+liSeovMxVa3+3KKva1IWcm7ef+Rq8efq
	80wvy2YWRby2W6mixFKckWioxVxUnAgADHe+97cCAAA=
X-CMS-MailID: 20240805084453epcas5p363b93b10eaf53df5725417d3d7fbcca0
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240805084453epcas5p363b93b10eaf53df5725417d3d7fbcca0
References: <CGME20240805084453epcas5p363b93b10eaf53df5725417d3d7fbcca0@epcas5p3.samsung.com>

Add a test case where a fixed buffer is composed of a small page and
a huge page, and begins with the small page. Originally we have huge-small
test case where the buffer begins with the huge page, add this one to
cover more should-not-coalesce scenarios.

Suggested-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Chenliang Li <cliang01.li@samsung.com>
---
 test/fixed-hugepage.c | 42 ++++++++++++++++++++++++++++++++----------
 1 file changed, 32 insertions(+), 10 deletions(-)

diff --git a/test/fixed-hugepage.c b/test/fixed-hugepage.c
index 67a3fa0..b455d9f 100644
--- a/test/fixed-hugepage.c
+++ b/test/fixed-hugepage.c
@@ -76,10 +76,11 @@ static int mmap_hugebufs(struct iovec *iov, int nr_bufs, size_t buf_size, size_t
 }
 
 /* map a hugepage and smaller page to a contiguous memory */
-static int mmap_mixture(struct iovec *iov, int nr_bufs, size_t buf_size)
+static int mmap_mixture(struct iovec *iov, int nr_bufs, size_t buf_size, bool huge_on_left)
 {
 	int i;
-	void *small_base = NULL, *huge_base = NULL, *start = NULL;
+	void *small_base = NULL, *huge_base = NULL, *start = NULL,
+	     *huge_start = NULL, *small_start = NULL;
 	size_t small_size = buf_size - HUGEPAGE_SIZE;
 	size_t seg_size = ((buf_size / HUGEPAGE_SIZE) + 1) * HUGEPAGE_SIZE;
 
@@ -92,7 +93,15 @@ static int mmap_mixture(struct iovec *iov, int nr_bufs, size_t buf_size)
 	}
 
 	for (i = 0; i < nr_bufs; i++) {
-		huge_base = mmap(start, HUGEPAGE_SIZE, PROT_READ | PROT_WRITE,
+		if (huge_on_left) {
+			huge_start = start;
+			small_start = start + HUGEPAGE_SIZE;
+		} else {
+			huge_start = start + HUGEPAGE_SIZE;
+			small_start = start + HUGEPAGE_SIZE - small_size;
+		}
+
+		huge_base = mmap(huge_start, HUGEPAGE_SIZE, PROT_READ | PROT_WRITE,
 				MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB | MAP_FIXED, -1, 0);
 		if (huge_base == MAP_FAILED) {
 			printf("Unable to map hugetlb page in the page mixture. "
@@ -101,7 +110,7 @@ static int mmap_mixture(struct iovec *iov, int nr_bufs, size_t buf_size)
 			return -1;
 		}
 
-		small_base = mmap(start + HUGEPAGE_SIZE, small_size, PROT_READ | PROT_WRITE,
+		small_base = mmap(small_start, small_size, PROT_READ | PROT_WRITE,
 				MAP_PRIVATE | MAP_ANONYMOUS | MAP_FIXED, -1, 0);
 		if (small_base == MAP_FAILED) {
 			printf("Unable to map small page in the page mixture. "
@@ -110,8 +119,14 @@ static int mmap_mixture(struct iovec *iov, int nr_bufs, size_t buf_size)
 			return -1;
 		}
 
-		memset(huge_base, 0, buf_size);
-		iov[i].iov_base = huge_base;
+		if (huge_on_left) {
+			iov[i].iov_base = huge_base;
+			memset(huge_base, 0, buf_size);
+		}
+		else {
+			iov[i].iov_base = small_base;
+			memset(small_base, 0, buf_size);
+		}
 		iov[i].iov_len = buf_size;
 		start += seg_size;
 	}
@@ -315,13 +330,13 @@ static int test_multi_unaligned_mthps(struct io_uring *ring, int fd_in, int fd_o
 }
 
 /* Should not coalesce */
-static int test_page_mixture(struct io_uring *ring, int fd_in, int fd_out)
+static int test_page_mixture(struct io_uring *ring, int fd_in, int fd_out, int huge_on_left)
 {
 	struct iovec iov[NR_BUFS];
 	size_t buf_size = HUGEPAGE_SIZE + MTHP_16KB;
 	int ret;
 
-	if (mmap_mixture(iov, NR_BUFS, buf_size))
+	if (mmap_mixture(iov, NR_BUFS, buf_size, huge_on_left))
 		return T_EXIT_SKIP;
 
 	ret = register_submit(ring, iov, NR_BUFS, fd_in, fd_out);
@@ -377,10 +392,17 @@ int main(int argc, char *argv[])
 		return ret;
 	}
 
-	ret = test_page_mixture(&ring, fd_in, fd_out);
+	ret = test_page_mixture(&ring, fd_in, fd_out, true);
+	if (ret != T_EXIT_PASS) {
+		if (ret != T_EXIT_SKIP)
+			fprintf(stderr, "Test huge small page mixture (start with huge) failed.\n");
+		return ret;
+	}
+
+	ret = test_page_mixture(&ring, fd_in, fd_out, false);
 	if (ret != T_EXIT_PASS) {
 		if (ret != T_EXIT_SKIP)
-			fprintf(stderr, "Test huge small page mixture failed.\n");
+			fprintf(stderr, "Test huge small page mixture (start with small) failed.\n");
 		return ret;
 	}
 

base-commit: 118622a3188e637d66ddec386b22e86fa8c01700
-- 
2.34.1


