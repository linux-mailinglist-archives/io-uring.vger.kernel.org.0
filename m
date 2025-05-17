Return-Path: <io-uring+bounces-8038-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 48D37ABAA95
	for <lists+io-uring@lfdr.de>; Sat, 17 May 2025 16:08:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3F4F47B3787
	for <lists+io-uring@lfdr.de>; Sat, 17 May 2025 14:06:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61F0B1FFC5B;
	Sat, 17 May 2025 14:07:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="JxnnpZph"
X-Original-To: io-uring@vger.kernel.org
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.3])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13F645680
	for <io-uring@vger.kernel.org>; Sat, 17 May 2025 14:07:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747490876; cv=none; b=ePquCYcoahfJs8+WjtDaZDAJnz5h8P/RxJ7yjgdT21xDY6/rScsSra7YVN1iYd+UBN00JJCLpr9vw+TxPaoBKiIzHox9OOu3vZt/CqZ2PfstkdRXspE16zBmsQ1+N4iCacKKWDVKaDDvWGCs+71YHPZeDS9uU7xWwAhIf8Cf7Vg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747490876; c=relaxed/simple;
	bh=O0DT+/b7CnVCJ60RUo1y/r/VjJqgaYXwYEysxAZOvhE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hhtOiC0djTn5hB2CU864kx5l2C0YzyQR1YxRuD5a/ubCPK45Xebd0PGYh1Chmh8kmOgCpwIDACit8gR3fNpfmAZvNpuIkzufii6rVTS+NvwqK3xNFIJ5Ya/Pa2ls+p0mcE7JrO95MZyisSSUq3n/RB8VZAheIVD0r2L/SD6ew5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=JxnnpZph; arc=none smtp.client-ip=220.197.31.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=EJ
	WlMw8gu3jDwS247w1Hko7uLfv7A+/G7OP06B4kt2k=; b=JxnnpZphWdLJJAn9pD
	682vzTbhGOuQB8qK5tY7agZbfd84WLLkA5oJU6oQe3rlED3moeDcGnC3u6CzFT7r
	ybrbTXgFU9c2RAeOZvCCZdeeJ9FWvEMrERsZk2IPON1tsNmu8WoAijdpCmOudN9U
	yG9SwaiRMBASeDkyBflQ9gV+o=
Received: from localhost.localdomain (unknown [])
	by gzsmtp2 (Coremail) with SMTP id PSgvCgCXq7U0mCho4gjbAg--.18020S2;
	Sat, 17 May 2025 22:07:49 +0800 (CST)
From: Haiyue Wang <haiyuewa@163.com>
To: io-uring@vger.kernel.org
Cc: Haiyue Wang <haiyuewa@163.com>
Subject: [PATCH liburing v1] register: Remove old API io_uring_register_wait_reg
Date: Sat, 17 May 2025 22:07:21 +0800
Message-ID: <20250517140725.24052-1-haiyuewa@163.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PSgvCgCXq7U0mCho4gjbAg--.18020S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxJr48GF48Kw4kZF1kZr1fZwb_yoW8tr1rp3
	WUKw1rtryI9r409FWDAr48CFy7Kw1q9F4xurWrCw17XrW7AFn3Kr4xKF1UCF1jq3yUCrW7
	tF1SqFZ8ur18A3JanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0JUga9xUUUUU=
X-CM-SenderInfo: 5kdl53xhzdqiywtou0bp/1tbiShRPa2gncIM5KwABsV

The commit b38747291d50 ("queue: break reg wait setup") just left this
API definition with always "-EINVAL" result for building test.

And new API 'io_uring_submit_and_wait_reg' has been implemented.

Signed-off-by: Haiyue Wang <haiyuewa@163.com>
---
 src/include/liburing.h | 2 --
 src/liburing-ffi.map   | 1 -
 src/liburing.map       | 1 -
 src/register.c         | 6 ------
 4 files changed, 10 deletions(-)

diff --git a/src/include/liburing.h b/src/include/liburing.h
index a953a6f..8dfbf31 100644
--- a/src/include/liburing.h
+++ b/src/include/liburing.h
@@ -210,8 +210,6 @@ int io_uring_submit_and_wait_reg(struct io_uring *ring,
 				 struct io_uring_cqe **cqe_ptr, unsigned wait_nr,
 				 int reg_index);
 
-int io_uring_register_wait_reg(struct io_uring *ring,
-			       struct io_uring_reg_wait *reg, int nr);
 int io_uring_resize_rings(struct io_uring *ring, struct io_uring_params *p);
 int io_uring_clone_buffers_offset(struct io_uring *dst, struct io_uring *src,
 				  unsigned int dst_off, unsigned int src_off,
diff --git a/src/liburing-ffi.map b/src/liburing-ffi.map
index 7f6d4af..662840d 100644
--- a/src/liburing-ffi.map
+++ b/src/liburing-ffi.map
@@ -219,7 +219,6 @@ LIBURING_2.8 {
 LIBURING_2.9 {
 	global:
 		io_uring_resize_rings;
-		io_uring_register_wait_reg;
 		io_uring_submit_and_wait_reg;
 		io_uring_clone_buffers_offset;
 		io_uring_register_region;
diff --git a/src/liburing.map b/src/liburing.map
index c946115..84114d2 100644
--- a/src/liburing.map
+++ b/src/liburing.map
@@ -106,7 +106,6 @@ LIBURING_2.8 {
 
 LIBURING_2.9 {
 		io_uring_resize_rings;
-		io_uring_register_wait_reg;
 		io_uring_submit_and_wait_reg;
 		io_uring_clone_buffers_offset;
 		io_uring_register_region;
diff --git a/src/register.c b/src/register.c
index 51667d8..68944ed 100644
--- a/src/register.c
+++ b/src/register.c
@@ -471,12 +471,6 @@ out:
 	return ret;
 }
 
-int io_uring_register_wait_reg(struct io_uring *ring,
-			       struct io_uring_reg_wait *reg, int nr)
-{
-	return -EINVAL;
-}
-
 int io_uring_register_region(struct io_uring *ring,
 			     struct io_uring_mem_region_reg *reg)
 {
-- 
2.49.0


