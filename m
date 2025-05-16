Return-Path: <io-uring+bounces-7986-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 897C9AB9861
	for <lists+io-uring@lfdr.de>; Fri, 16 May 2025 11:11:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E9E333A2134
	for <lists+io-uring@lfdr.de>; Fri, 16 May 2025 09:10:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13263224223;
	Fri, 16 May 2025 09:11:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="ayk3FiGi"
X-Original-To: io-uring@vger.kernel.org
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.2])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6101B1A704B
	for <io-uring@vger.kernel.org>; Fri, 16 May 2025 09:11:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747386677; cv=none; b=ArS04uQIIjtTOsUAH7AIp7zDbGrbrlDqdfB7Y+jZNgNy7zDgj3X7T45Ftak8pq9CzN37rcm4e7vbKYQ4tKT0QCzSjYgPjlhjWhBcfhktIcdww0w1sNY3SpqflnFlhkUz89UhwqPfhMh+18IL1l6v45Ad0naWzYw4iZHf9ee7/30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747386677; c=relaxed/simple;
	bh=9zXV0itF6oy9LGPStON5x84kJRINcjwVu1LvHtDWHtE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=MyKsQgrY5hxam4KbcfNhUeZEQmcA4tm4RrN7FkWwkQtwx/+G0PbInPPGeM3VY+wG8+jQsZQOBeHhO+Xgrtr1EZYySihslt5DpzqI/mP+CkVbRdlL6DcQfdctrAlDOOcoAwSgOrfOzkWuhCjmLTgo4FvaofCdk6SXm5+Hnv0xXIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=ayk3FiGi; arc=none smtp.client-ip=117.135.210.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=t7
	XmIkqH2PNIoQQKA9gfJkfEMFWEfyhFxH5dwxvKkaI=; b=ayk3FiGihl+temcCic
	/4KUtMc5E5wXcV8PWR30rFYsMBFuamrk+jsGzjxoTe9NVFghkeW+AVvMlLxauVyd
	YZQsZMsS4EBCJaiqIfkz3W6LSIK+n77cALG2AlokjRXpSl4H19a/mExYDlk8HHZI
	Z36arp6bvXBTawlrRZGzDOels=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g0-2 (Coremail) with SMTP id _____wBniGwmASdo+NlHBw--.2674S2;
	Fri, 16 May 2025 17:11:03 +0800 (CST)
From: Haiyue Wang <haiyuewa@163.com>
To: io-uring@vger.kernel.org
Cc: Haiyue Wang <haiyuewa@163.com>
Subject: [PATCH liburing v2] register: Remove deprecated io_uring_cqwait_reg_arg
Date: Fri, 16 May 2025 17:09:32 +0800
Message-ID: <20250516091040.32374-1-haiyuewa@163.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wBniGwmASdo+NlHBw--.2674S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxKF1kJw4UXr1kKFWrZw1UZFb_yoW7Xw45pF
	W3Kw13GrWDZF1j9ayDCF4UuFyYyw4rCFsrCrW5Ar1xZryY9FnIgr48KrW0kFyjvrWUAr4j
	vrnaqwnrZw4DAaUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0JUylkxUUUUU=
X-CM-SenderInfo: 5kdl53xhzdqiywtou0bp/1tbiYAdPa2gm-y1RXQAAsT

The opcode IORING_REGISTER_CQWAIT_REG and its argument io_uring_cqwait_reg_arg
have been removed by [1] and [2].

And a more generic opcode IORING_REGISTER_MEM_REGION has been introduced by [3]
since Linux 6.13.

[1]: https://git.kernel.org/torvalds/c/83e041522eb9
[2]: https://git.kernel.org/torvalds/c/c750629caeca
[3]: https://git.kernel.org/torvalds/c/93238e661855

Signed-off-by: Haiyue Wang <haiyuewa@163.com>
---
v2:
 - Correct the commit message about the IORING_REGISTER_CQWAIT_REG which
   is really removed.
v1: https://lore.kernel.org/io-uring/20250516090704.32220-1-haiyuewa@163.com/
---
 man/io_uring_enter.2            |  4 +-
 man/io_uring_register.2         | 94 ---------------------------------
 src/include/liburing/io_uring.h | 14 -----
 3 files changed, 2 insertions(+), 110 deletions(-)

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
index a81d950..32473a2 100644
--- a/man/io_uring_register.2
+++ b/man/io_uring_register.2
@@ -950,100 +950,6 @@ structure will get the necessary offsets copied back upon successful completion
 of this system call, which can be used to memory map the ring just like how
 a new ring would've been mapped. Available since kernel 6.13.
 
-.TP
-.B IORING_REGISTER_CQWAIT_REG
-Supports registering fixed wait regions, avoiding unnecessary copying in
-of
-.IR struct io_uring_getevents_arg
-for wait operations that specify a timeout or minimum timeout. Takes a pointer
-to a
-.IR struct io_uring_cqwait_reg_arg
-structure, which looks as follows:
-.PP
-.in +12n
-.EX
-struct io_uring_cqwait_reg_arg {
-    __u32 flags;
-    __u32 struct_size;
-    __u32 nr_entries;
-    __u32 pad;
-    __u64 user_addr;
-    __u64 pad2[2];
-};
-.EE
-.in
-.TP
-.PP
-where
-.IR flags
-specifies modifier flags (must currently be
-.B 0 ),
-.IR struct_size
-must be set to the size of the struct, and
-.IR user_addr
-must be set to the region being registered as wait regions. The pad fields
-must all be cleared to
-.B 0 .
-Each wait regions looks as follows:
-.PP
-.in +12n
-.EX
-struct io_uring_reg_wait {
-    struct __kernel_timespec ts;
-    __u32                    min_wait_usec;
-    __u32                    flags;
-    __u64                    sigmask;
-    __u32                    sigmask_sz;
-    __u32                    pad[3];
-    __u64                    pad2[2];
-};
-.EE
-.in
-.TP
-.PP
-where
-.IR ts
-holds the timeout information for this region
-.IR flags
-holds information about the timeout region,
-.IR sigmask
-is a pointer to a signal mask, if used, and
-.IR sigmask_sz
-is the size of that signal mask. The pad fields must all be cleared to
-.B 0 .
-Currently the only valid flag is
-.B IORING_REG_WAIT_TS ,
-which, if set, says that the values in
-.IR ts
-are valid and should be used for a timeout operation. The
-.IR user_addr
-field of
-.IR struct io_uring_cqwait_reg_arg
-must be set to an address of
-.IR struct io_uring_cqwait_reg
-members, an up to a page size can be mapped. At the size of 64 bytes per
-region, that allows at least 64 individual regions on a 4k page size system.
-The offsets of these regions are used for an
-.BR io_uring_enter (2)
-system call, with the first one being 0, second one 1, and so forth. After
-registration of the wait regions,
-.BR io_uring_enter (2)
-may be used with the enter flag of
-.B IORING_ENTER_EXT_ARG_REG and an
-.IR argp
-set to the wait region offset, rather than a pointer to a
-.IR struct io_uring_getevent_arg
-structure. If used with
-.B IORING_ENTER_GETEVENTS ,
-then the wait operation will use the information in the registered wait
-region rather than needing a io_uring_getevent_arg structure copied for each
-operation. For high frequency waits, this can save considerable CPU cycles.
-Note: once a region has been registered, it cannot get unregistered. It lives
-for the life of the ring. Individual wait region offset may be modified before
-any
-.BR io_uring_enter (2)
-system call. Available since kernel 6.13.
-
 .SH RETURN VALUE
 On success,
 .BR io_uring_register (2)
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


