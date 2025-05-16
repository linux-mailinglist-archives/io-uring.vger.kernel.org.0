Return-Path: <io-uring+bounces-8002-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 385F6ABA1B8
	for <lists+io-uring@lfdr.de>; Fri, 16 May 2025 19:14:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A6706A054AF
	for <lists+io-uring@lfdr.de>; Fri, 16 May 2025 17:14:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 631B32505C5;
	Fri, 16 May 2025 17:14:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="aCE0TGSw"
X-Original-To: io-uring@vger.kernel.org
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.5])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1149274667
	for <io-uring@vger.kernel.org>; Fri, 16 May 2025 17:14:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747415665; cv=none; b=YHlKgH3otCzO5B5I7kXgE1LRNH6l24bSQA20Jd5Jjh7YrEcW7J9svJFAF1Q3zjJOx28iJrJz2yzH3dx5Q8grU8tpaUHhO05XfK77I8qmHg+UsGfdRLmCNsJEdaIw9riBfcjehLJv6giG0Iyq3/NTjYDMXRJ6Mq8p79JeS0kikVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747415665; c=relaxed/simple;
	bh=VNCHMd4sUwJjyvJAGt3zNw+sCT2nY7BKCx2RDnTBeDY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=udDpyvHEjXZbu30O+5Ww2erR9I9eshczmNZmRbefm1RbtXQD0l+8j2RIQBJNKorpQ2F9zCu9kQgPLHKnxrWjppccQmtue2Inyxp+gwfTONzT0d8N1FpOmZkkaAep5KyFVO1AgJhyzp+vQsymXEvf7BTb4jE9u+XTZSQ25Zr3Xjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=aCE0TGSw; arc=none smtp.client-ip=220.197.31.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=Wd
	uh8JyWy11VVn4hwJM7a+avCmPoopwOQDe+fs/YZDY=; b=aCE0TGSwbi9A0WA6TJ
	LlHglYUcwvLj0AQYoKS+/dFcb5yFrtsYclD+VzhFcFMyU+t2/LC7qci3woij56Np
	19bmyTkf5zLv8tNmy+f9X3U0W5GstphvibBjPVohWM5PiXQ5ySVCNBczXI5an1Ls
	GYfvMSACZNLRs7RU4nL2AYVf0=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g1-1 (Coremail) with SMTP id _____wB3tOxmcidoMHqOBw--.62835S2;
	Sat, 17 May 2025 01:14:14 +0800 (CST)
From: Haiyue Wang <haiyuewa@163.com>
To: io-uring@vger.kernel.org
Cc: Haiyue Wang <haiyuewa@163.com>
Subject: [PATCH liburing v3] register: Remove deprecated io_uring_cqwait_reg_arg
Date: Sat, 17 May 2025 01:12:25 +0800
Message-ID: <20250516171351.1735-1-haiyuewa@163.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wB3tOxmcidoMHqOBw--.62835S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxAr48Kr4kKw1ftr4DurW7Jwb_yoW7JrWUpa
	yFkw13GrWjvF129ayDCF4UuF98A3yfJF47CrZxAw13ZFyavFnIkr40krWFkFyjqrW7Ar4j
	vrsaq39rZw4DAaUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0JUgyCdUUUUU=
X-CM-SenderInfo: 5kdl53xhzdqiywtou0bp/1tbiERlPa2gna4msOwAAsW

The opcode IORING_REGISTER_CQWAIT_REG and its argument io_uring_cqwait_reg_arg
have been removed by [1] and [2].

And a more generic opcode IORING_REGISTER_MEM_REGION has been introduced by [3]
since Linux 6.13.

Update the document about IORING_REGISTER_MEM_REGION based on [4] and [5].

[1]: https://git.kernel.org/torvalds/c/83e041522eb9
[2]: https://git.kernel.org/torvalds/c/c750629caeca
[3]: https://git.kernel.org/torvalds/c/93238e661855
[4]: https://git.kernel.org/torvalds/c/dfbbfbf19187
[5]: https://git.kernel.org/torvalds/c/d617b3147d54

Signed-off-by: Haiyue Wang <haiyuewa@163.com>
---
v3:
 - Replace the document CQWAIT_REG with MEM_REGION.
v2: https://lore.kernel.org/io-uring/20250516091040.32374-1-haiyuewa@163.com/
 - Correct the commit message about the IORING_REGISTER_CQWAIT_REG which
   is really removed.
v1: https://lore.kernel.org/io-uring/20250516090704.32220-1-haiyuewa@163.com/
---
 man/io_uring_enter.2            |  4 +--
 man/io_uring_register.2         | 55 +++++++++++++++++++++------------
 src/include/liburing/io_uring.h | 14 ---------
 3 files changed, 37 insertions(+), 36 deletions(-)

diff --git a/man/io_uring_enter.2 b/man/io_uring_enter.2
index bbae6fb..99c0ab2 100644
--- a/man/io_uring_enter.2
+++ b/man/io_uring_enter.2
@@ -133,8 +133,8 @@ is not a pointer to a
 but merely an offset into an area of wait regions previously registered with
 .BR io_uring_register (2)
 using the
-.B IORING_REGISTER_CQWAIT_REG
-operation. Available since 6.12
+.B IORING_REGISTER_MEM_REGION
+operation. Available since 6.13
 
 .PP
 .PP
diff --git a/man/io_uring_register.2 b/man/io_uring_register.2
index a81d950..75112d0 100644
--- a/man/io_uring_register.2
+++ b/man/io_uring_register.2
@@ -951,40 +951,55 @@ of this system call, which can be used to memory map the ring just like how
 a new ring would've been mapped. Available since kernel 6.13.
 
 .TP
-.B IORING_REGISTER_CQWAIT_REG
-Supports registering fixed wait regions, avoiding unnecessary copying in
-of
+.B IORING_REGISTER_MEM_REGION
+Supports registering multiple purposes memory regions, avoiding unnecessary
+copying in of
 .IR struct io_uring_getevents_arg
 for wait operations that specify a timeout or minimum timeout. Takes a pointer
 to a
-.IR struct io_uring_cqwait_reg_arg
+.IR struct io_uring_mem_region_reg
 structure, which looks as follows:
 .PP
 .in +12n
 .EX
-struct io_uring_cqwait_reg_arg {
-    __u32 flags;
-    __u32 struct_size;
-    __u32 nr_entries;
-    __u32 pad;
-    __u64 user_addr;
-    __u64 pad2[2];
+struct io_uring_mem_region_reg {
+    __u64 region_uptr;
+    __u64 flags;
+    __u64 __resv[2];
 };
 .EE
 .in
 .TP
 .PP
 where
+.IR region_uptr
+must be set to the region being registered as memory regions,
 .IR flags
 specifies modifier flags (must currently be
-.B 0 ),
-.IR struct_size
-must be set to the size of the struct, and
-.IR user_addr
-must be set to the region being registered as wait regions. The pad fields
-must all be cleared to
+.B IORING_MEM_REGION_REG_WAIT_ARG ). The pad fields must all be cleared to
 .B 0 .
-Each wait regions looks as follows:
+Each memory regions looks as follows:
+.PP
+.in +12n
+.EX
+struct io_uring_region_desc {
+    __u64 user_addr;
+    __u64 size;
+    __u32 flags;
+    __u32 id;
+    __u64 mmap_offset;
+    __u64 __resv[4];
+};
+.EE
+.in
+.TP
+.PP
+where
+.IR user_addr
+points to userspace memory mappings,
+.IR size
+is the size of userspace memory. Current supported userspace memory regions
+looks as follows:
 .PP
 .in +12n
 .EX
@@ -1018,9 +1033,9 @@ which, if set, says that the values in
 are valid and should be used for a timeout operation. The
 .IR user_addr
 field of
-.IR struct io_uring_cqwait_reg_arg
+.IR struct io_uring_region_desc
 must be set to an address of
-.IR struct io_uring_cqwait_reg
+.IR struct io_uring_reg_wait
 members, an up to a page size can be mapped. At the size of 64 bytes per
 region, that allows at least 64 individual regions on a 4k page size system.
 The offsets of these regions are used for an
diff --git a/src/include/liburing/io_uring.h b/src/include/liburing/io_uring.h
index a89d0d1..73d2997 100644
--- a/src/include/liburing/io_uring.h
+++ b/src/include/liburing/io_uring.h
@@ -851,20 +851,6 @@ enum {
 	IORING_REG_WAIT_TS		= (1U << 0),
 };
 
-/*
- * Argument for IORING_REGISTER_CQWAIT_REG, registering a region of
- * struct io_uring_reg_wait that can be indexed when io_uring_enter(2) is
- * called rather than pass in a wait argument structure separately.
- */
-struct io_uring_cqwait_reg_arg {
-	__u32		flags;
-	__u32		struct_size;
-	__u32		nr_entries;
-	__u32		pad;
-	__u64		user_addr;
-	__u64		pad2[3];
-};
-
 /*
  * Argument for io_uring_enter(2) with
  * IORING_GETEVENTS | IORING_ENTER_EXT_ARG_REG set, where the actual argument
-- 
2.49.0


