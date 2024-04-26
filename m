Return-Path: <io-uring+bounces-1651-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D88118B3CD4
	for <lists+io-uring@lfdr.de>; Fri, 26 Apr 2024 18:32:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 087BF1C227E3
	for <lists+io-uring@lfdr.de>; Fri, 26 Apr 2024 16:32:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ADDBE157A48;
	Fri, 26 Apr 2024 16:32:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=seltendoof.de header.i=@seltendoof.de header.b="NNLzwoGz"
X-Original-To: io-uring@vger.kernel.org
Received: from server02.seltendoof.de (server02.seltendoof.de [168.119.48.163])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 553A244377;
	Fri, 26 Apr 2024 16:32:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.48.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714149131; cv=none; b=cUuzck/VTg0rfEeoLZB3TkspI5t0ive9+o9d/ScsswgusBcNSfE5tyHylHDsMcWaaOi88L7TEHPEUomeWDQyyYrscNjWFdvjXLZhcWqiUtIJ7YtTV/p5WC24uo/7oCNWjpdtgQcg4xrP7a4cirP6xxCuyDVEDX7aqf3S9SydYJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714149131; c=relaxed/simple;
	bh=pwUbf0CJzfzTif6FLawW1Ntu8PXv55PrXwYHbALlKBY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=oeekLRsEUuMb7WoZOZc+LdaaDF4xHIhDw0wxggYmqL98wmLioVmSIa8rr6MnA49kU2RzyDZhHpDGJZUyZ3vqBJiOu1XWnyBMnKpFYKrkvtwcrybmlAWaVV00iavaDR344T7oDlYv3KbQTQZ0ul+di5wHW82j6BMhw5OeKGiQI3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=seltendoof.de; spf=pass smtp.mailfrom=seltendoof.de; dkim=pass (2048-bit key) header.d=seltendoof.de header.i=@seltendoof.de header.b=NNLzwoGz; arc=none smtp.client-ip=168.119.48.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=seltendoof.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=seltendoof.de
From: =?UTF-8?q?Christian=20G=C3=B6ttsche?= <cgoettsche@seltendoof.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seltendoof.de;
	s=2023072701; t=1714148461;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:  content-transfer-encoding:content-transfer-encoding;
	bh=z5JmHtkLiQ57ZBKXVrmaKQ/XqCOuY5zjpycUDX8wsGM=;
	b=NNLzwoGzbnLH2jZw966e6jSsnimzqSiNByTgO/pFKf0ZK61KJa0cuDMUYUEuU8US4QgmN1
	ybO2yMl69Hwe51SIfxWCrbXu60CN2cfiBzGtAva23gNgdHEi2vRz00QY3rtH5c3VzczrL6
	lG8hFYIHVmeYNCtTQKvguCpepTLU/cS8krVayViHJao1raPqNEXp6e4WUtWi+SS2oq9fL/
	+kgF2MbSrJahOa0C+8gmy0je2nALPVdg1tKH4kx0Ud44+qG32mdg2p3nEd6QaiOxcBeYNJ
	4GYAHh4NZbzeGImOZL0DWJJTIuVlGAuN+utdWTECAZwe/yvoTgA49SXphmXdcg==
To: cgzones@googlemail.com
Cc: x86@kernel.org,
	linux-alpha@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-ia64@vger.kernel.org,
	linux-m68k@lists.linux-m68k.org,
	linux-mips@vger.kernel.org,
	linux-parisc@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-s390@vger.kernel.org,
	linux-sh@vger.kernel.org,
	sparclinux@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	audit@vger.kernel.org,
	linux-arch@vger.kernel.org,
	linux-api@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	selinux@vger.kernel.org,
	Richard Henderson <richard.henderson@linaro.org>,
	Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
	Matt Turner <mattst88@gmail.com>,
	Russell King <linux@armlinux.org.uk>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Michal Simek <monstr@monstr.eu>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Helge Deller <deller@gmx.de>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
	"Naveen N. Rao" <naveen.n.rao@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Yoshinori Sato <ysato@users.sourceforge.jp>,
	Rich Felker <dalias@libc.org>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	"David S. Miller" <davem@davemloft.net>,
	Andreas Larsson <andreas@gaisler.com>,
	Andy Lutomirski <luto@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Chris Zankel <chris@zankel.net>,
	Max Filippov <jcmvbkbc@gmail.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Paul Moore <paul@paul-moore.com>,
	Eric Paris <eparis@redhat.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Sohil Mehta <sohil.mehta@intel.com>,
	Palmer Dabbelt <palmer@sifive.com>,
	Miklos Szeredi <mszeredi@redhat.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Casey Schaufler <casey@schaufler-ca.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Kees Cook <keescook@chromium.org>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Mark Rutland <mark.rutland@arm.com>,
	io-uring@vger.kernel.org
Subject: [PATCH v3 2/2] fs/xattr: add *at family syscalls
Date: Fri, 26 Apr 2024 18:20:14 +0200
Message-ID: <20240426162042.191916-1-cgoettsche@seltendoof.de>
Reply-To: cgzones@googlemail.com
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Christian Göttsche <cgzones@googlemail.com>

Add the four syscalls setxattrat(), getxattrat(), listxattrat() and
removexattrat().  Those can be used to operate on extended attributes,
especially security related ones, either relative to a pinned directory
or on a file descriptor without read access, avoiding a
/proc/<pid>/fd/<fd> detour, requiring a mounted procfs.

One use case will be setfiles(8) setting SELinux file contexts
("security.selinux") without race conditions and without a file
descriptor opened with read access requiring SELinux read permission.

Use the do_{name}at() pattern from fs/open.c.

Pass the value of the extended attribute, its length, and for
setxattrat(2) the command (XATTR_CREATE or XATTR_REPLACE) via an added
struct xattr_args to not exceed six syscall arguments and not
merging the AT_* and XATTR_* flags.

Signed-off-by: Christian Göttsche <cgzones@googlemail.com>
CC: x86@kernel.org
CC: linux-alpha@vger.kernel.org
CC: linux-kernel@vger.kernel.org
CC: linux-arm-kernel@lists.infradead.org
CC: linux-ia64@vger.kernel.org
CC: linux-m68k@lists.linux-m68k.org
CC: linux-mips@vger.kernel.org
CC: linux-parisc@vger.kernel.org
CC: linuxppc-dev@lists.ozlabs.org
CC: linux-s390@vger.kernel.org
CC: linux-sh@vger.kernel.org
CC: sparclinux@vger.kernel.org
CC: linux-fsdevel@vger.kernel.org
CC: audit@vger.kernel.org
CC: linux-arch@vger.kernel.org
CC: linux-api@vger.kernel.org
CC: linux-security-module@vger.kernel.org
CC: selinux@vger.kernel.org
---
v3:
  - pass value, size and xattr_flags via new struct xattr_args to
    split AT_* and XATTR_* flags

v2: https://lore.kernel.org/lkml/20230511150802.737477-1-cgzones@googlemail.com/
  - squash syscall introduction and wire up commits
  - add AT_XATTR_CREATE and AT_XATTR_REPLACE constants

v1 discussion: https://lore.kernel.org/all/20220830152858.14866-2-cgzones@googlemail.com/

Previous approach ("f*xattr: allow O_PATH descriptors"): https://lore.kernel.org/all/20220607153139.35588-1-cgzones@googlemail.com/
---
 arch/alpha/kernel/syscalls/syscall.tbl      |   4 +
 arch/arm/tools/syscall.tbl                  |   4 +
 arch/arm64/include/asm/unistd.h             |   2 +-
 arch/arm64/include/asm/unistd32.h           |   8 ++
 arch/m68k/kernel/syscalls/syscall.tbl       |   4 +
 arch/microblaze/kernel/syscalls/syscall.tbl |   4 +
 arch/mips/kernel/syscalls/syscall_n32.tbl   |   4 +
 arch/mips/kernel/syscalls/syscall_n64.tbl   |   4 +
 arch/mips/kernel/syscalls/syscall_o32.tbl   |   4 +
 arch/parisc/kernel/syscalls/syscall.tbl     |   4 +
 arch/powerpc/kernel/syscalls/syscall.tbl    |   4 +
 arch/s390/kernel/syscalls/syscall.tbl       |   4 +
 arch/sh/kernel/syscalls/syscall.tbl         |   4 +
 arch/sparc/kernel/syscalls/syscall.tbl      |   4 +
 arch/x86/entry/syscalls/syscall_32.tbl      |   4 +
 arch/x86/entry/syscalls/syscall_64.tbl      |   4 +
 arch/xtensa/kernel/syscalls/syscall.tbl     |   4 +
 fs/xattr.c                                  | 128 ++++++++++++++++----
 include/asm-generic/audit_change_attr.h     |   6 +
 include/linux/syscalls.h                    |  10 ++
 include/uapi/asm-generic/unistd.h           |  12 +-
 include/uapi/linux/xattr.h                  |   6 +
 22 files changed, 208 insertions(+), 24 deletions(-)

diff --git a/arch/alpha/kernel/syscalls/syscall.tbl b/arch/alpha/kernel/syscalls/syscall.tbl
index 8ff110826ce2..fdc11249f1b8 100644
--- a/arch/alpha/kernel/syscalls/syscall.tbl
+++ b/arch/alpha/kernel/syscalls/syscall.tbl
@@ -501,3 +501,7 @@
 569	common	lsm_get_self_attr		sys_lsm_get_self_attr
 570	common	lsm_set_self_attr		sys_lsm_set_self_attr
 571	common	lsm_list_modules		sys_lsm_list_modules
+572	common	setxattrat			sys_setxattrat
+573	common	getxattrat			sys_getxattrat
+574	common	listxattrat			sys_listxattrat
+575	common	removexattrat			sys_removexattrat
diff --git a/arch/arm/tools/syscall.tbl b/arch/arm/tools/syscall.tbl
index b6c9e01e14f5..22fbbcd8e2b5 100644
--- a/arch/arm/tools/syscall.tbl
+++ b/arch/arm/tools/syscall.tbl
@@ -475,3 +475,7 @@
 459	common	lsm_get_self_attr		sys_lsm_get_self_attr
 460	common	lsm_set_self_attr		sys_lsm_set_self_attr
 461	common	lsm_list_modules		sys_lsm_list_modules
+462	common	setxattrat			sys_setxattrat
+463	common	getxattrat			sys_getxattrat
+464	common	listxattrat			sys_listxattrat
+465	common	removexattrat			sys_removexattrat
diff --git a/arch/arm64/include/asm/unistd.h b/arch/arm64/include/asm/unistd.h
index 491b2b9bd553..f3a77719eb05 100644
--- a/arch/arm64/include/asm/unistd.h
+++ b/arch/arm64/include/asm/unistd.h
@@ -39,7 +39,7 @@
 #define __ARM_NR_compat_set_tls		(__ARM_NR_COMPAT_BASE + 5)
 #define __ARM_NR_COMPAT_END		(__ARM_NR_COMPAT_BASE + 0x800)
 
-#define __NR_compat_syscalls		462
+#define __NR_compat_syscalls		466
 #endif
 
 #define __ARCH_WANT_SYS_CLONE
diff --git a/arch/arm64/include/asm/unistd32.h b/arch/arm64/include/asm/unistd32.h
index 7118282d1c79..963c999b8d2e 100644
--- a/arch/arm64/include/asm/unistd32.h
+++ b/arch/arm64/include/asm/unistd32.h
@@ -929,6 +929,14 @@ __SYSCALL(__NR_lsm_get_self_attr, sys_lsm_get_self_attr)
 __SYSCALL(__NR_lsm_set_self_attr, sys_lsm_set_self_attr)
 #define __NR_lsm_list_modules 461
 __SYSCALL(__NR_lsm_list_modules, sys_lsm_list_modules)
+#define __NR_setxattrat 462
+__SYSCALL(__NR_setxattrat, sys_setxattrat)
+#define __NR_getxattrat 463
+__SYSCALL(__NR_getxattrat, sys_getxattrat)
+#define __NR_listxattrat 464
+__SYSCALL(__NR_listxattrat, sys_listxattrat)
+#define __NR_removexattrat 465
+__SYSCALL(__NR_removexattrat, sys_removexattrat)
 
 /*
  * Please add new compat syscalls above this comment and update
diff --git a/arch/m68k/kernel/syscalls/syscall.tbl b/arch/m68k/kernel/syscalls/syscall.tbl
index 7fd43fd4c9f2..7e8e2d9c3b81 100644
--- a/arch/m68k/kernel/syscalls/syscall.tbl
+++ b/arch/m68k/kernel/syscalls/syscall.tbl
@@ -461,3 +461,7 @@
 459	common	lsm_get_self_attr		sys_lsm_get_self_attr
 460	common	lsm_set_self_attr		sys_lsm_set_self_attr
 461	common	lsm_list_modules		sys_lsm_list_modules
+462	common	setxattrat			sys_setxattrat
+463	common	getxattrat			sys_getxattrat
+464	common	listxattrat			sys_listxattrat
+465	common	removexattrat			sys_removexattrat
diff --git a/arch/microblaze/kernel/syscalls/syscall.tbl b/arch/microblaze/kernel/syscalls/syscall.tbl
index b00ab2cabab9..7df7fc7c0528 100644
--- a/arch/microblaze/kernel/syscalls/syscall.tbl
+++ b/arch/microblaze/kernel/syscalls/syscall.tbl
@@ -467,3 +467,7 @@
 459	common	lsm_get_self_attr		sys_lsm_get_self_attr
 460	common	lsm_set_self_attr		sys_lsm_set_self_attr
 461	common	lsm_list_modules		sys_lsm_list_modules
+462	common	setxattrat			sys_setxattrat
+463	common	getxattrat			sys_getxattrat
+464	common	listxattrat			sys_listxattrat
+465	common	removexattrat			sys_removexattrat
diff --git a/arch/mips/kernel/syscalls/syscall_n32.tbl b/arch/mips/kernel/syscalls/syscall_n32.tbl
index 83cfc9eb6b88..07141274f9ff 100644
--- a/arch/mips/kernel/syscalls/syscall_n32.tbl
+++ b/arch/mips/kernel/syscalls/syscall_n32.tbl
@@ -400,3 +400,7 @@
 459	n32	lsm_get_self_attr		sys_lsm_get_self_attr
 460	n32	lsm_set_self_attr		sys_lsm_set_self_attr
 461	n32	lsm_list_modules		sys_lsm_list_modules
+462	n32	setxattrat			sys_setxattrat
+463	n32	getxattrat			sys_getxattrat
+464	n32	listxattrat			sys_listxattrat
+465	n32	removexattrat			sys_removexattrat
diff --git a/arch/mips/kernel/syscalls/syscall_n64.tbl b/arch/mips/kernel/syscalls/syscall_n64.tbl
index 532b855df589..9773412f2812 100644
--- a/arch/mips/kernel/syscalls/syscall_n64.tbl
+++ b/arch/mips/kernel/syscalls/syscall_n64.tbl
@@ -376,3 +376,7 @@
 459	n64	lsm_get_self_attr		sys_lsm_get_self_attr
 460	n64	lsm_set_self_attr		sys_lsm_set_self_attr
 461	n64	lsm_list_modules		sys_lsm_list_modules
+462	n64	setxattrat			sys_setxattrat
+463	n64	getxattrat			sys_getxattrat
+464	n64	listxattrat			sys_listxattrat
+465	n64	removexattrat			sys_removexattrat
diff --git a/arch/mips/kernel/syscalls/syscall_o32.tbl b/arch/mips/kernel/syscalls/syscall_o32.tbl
index f45c9530ea93..8b5fec66ec18 100644
--- a/arch/mips/kernel/syscalls/syscall_o32.tbl
+++ b/arch/mips/kernel/syscalls/syscall_o32.tbl
@@ -449,3 +449,7 @@
 459	o32	lsm_get_self_attr		sys_lsm_get_self_attr
 460	o32	lsm_set_self_attr		sys_lsm_set_self_attr
 461	o32	lsm_list_modules		sys_lsm_list_modules
+462	o32	setxattrat			sys_setxattrat
+463	o32	getxattrat			sys_getxattrat
+464	o32	listxattrat			sys_listxattrat
+465	o32	removexattrat			sys_removexattrat
diff --git a/arch/parisc/kernel/syscalls/syscall.tbl b/arch/parisc/kernel/syscalls/syscall.tbl
index b236a84c4e12..b6ebcaadd460 100644
--- a/arch/parisc/kernel/syscalls/syscall.tbl
+++ b/arch/parisc/kernel/syscalls/syscall.tbl
@@ -460,3 +460,7 @@
 459	common	lsm_get_self_attr		sys_lsm_get_self_attr
 460	common	lsm_set_self_attr		sys_lsm_set_self_attr
 461	common	lsm_list_modules		sys_lsm_list_modules
+462	common	setxattrat			sys_setxattrat
+463	common	getxattrat			sys_getxattrat
+464	common	listxattrat			sys_listxattrat
+465	common	removexattrat			sys_removexattrat
diff --git a/arch/powerpc/kernel/syscalls/syscall.tbl b/arch/powerpc/kernel/syscalls/syscall.tbl
index 17173b82ca21..7e522a720e1a 100644
--- a/arch/powerpc/kernel/syscalls/syscall.tbl
+++ b/arch/powerpc/kernel/syscalls/syscall.tbl
@@ -548,3 +548,7 @@
 459	common	lsm_get_self_attr		sys_lsm_get_self_attr
 460	common	lsm_set_self_attr		sys_lsm_set_self_attr
 461	common	lsm_list_modules		sys_lsm_list_modules
+462	common	setxattrat			sys_setxattrat
+463	common	getxattrat			sys_getxattrat
+464	common	listxattrat			sys_listxattrat
+465	common	removexattrat			sys_removexattrat
diff --git a/arch/s390/kernel/syscalls/syscall.tbl b/arch/s390/kernel/syscalls/syscall.tbl
index 095bb86339a7..71afa1eb35fb 100644
--- a/arch/s390/kernel/syscalls/syscall.tbl
+++ b/arch/s390/kernel/syscalls/syscall.tbl
@@ -464,3 +464,7 @@
 459  common	lsm_get_self_attr	sys_lsm_get_self_attr		sys_lsm_get_self_attr
 460  common	lsm_set_self_attr	sys_lsm_set_self_attr		sys_lsm_set_self_attr
 461  common	lsm_list_modules	sys_lsm_list_modules		sys_lsm_list_modules
+462  common	setxattrat		sys_setxattrat			sys_setxattrat
+463  common	getxattrat		sys_getxattrat			sys_getxattrat
+464  common	listxattrat		sys_listxattrat			sys_listxattrat
+465  common	removexattrat		sys_removexattrat		sys_removexattrat
diff --git a/arch/sh/kernel/syscalls/syscall.tbl b/arch/sh/kernel/syscalls/syscall.tbl
index 86fe269f0220..1fb0ac9f6c58 100644
--- a/arch/sh/kernel/syscalls/syscall.tbl
+++ b/arch/sh/kernel/syscalls/syscall.tbl
@@ -464,3 +464,7 @@
 459	common	lsm_get_self_attr		sys_lsm_get_self_attr
 460	common	lsm_set_self_attr		sys_lsm_set_self_attr
 461	common	lsm_list_modules		sys_lsm_list_modules
+462	common	setxattrat			sys_setxattrat
+463	common	getxattrat			sys_getxattrat
+464	common	listxattrat			sys_listxattrat
+465	common	removexattrat			sys_removexattrat
diff --git a/arch/sparc/kernel/syscalls/syscall.tbl b/arch/sparc/kernel/syscalls/syscall.tbl
index b23d59313589..bdd90010c8d1 100644
--- a/arch/sparc/kernel/syscalls/syscall.tbl
+++ b/arch/sparc/kernel/syscalls/syscall.tbl
@@ -507,3 +507,7 @@
 459	common	lsm_get_self_attr		sys_lsm_get_self_attr
 460	common	lsm_set_self_attr		sys_lsm_set_self_attr
 461	common	lsm_list_modules		sys_lsm_list_modules
+462	common	setxattrat			sys_setxattrat
+463	common	getxattrat			sys_getxattrat
+464	common	listxattrat			sys_listxattrat
+465	common	removexattrat			sys_removexattrat
diff --git a/arch/x86/entry/syscalls/syscall_32.tbl b/arch/x86/entry/syscalls/syscall_32.tbl
index 5f8591ce7f25..779dd1a9835d 100644
--- a/arch/x86/entry/syscalls/syscall_32.tbl
+++ b/arch/x86/entry/syscalls/syscall_32.tbl
@@ -466,3 +466,7 @@
 459	i386	lsm_get_self_attr	sys_lsm_get_self_attr
 460	i386	lsm_set_self_attr	sys_lsm_set_self_attr
 461	i386	lsm_list_modules	sys_lsm_list_modules
+462	i386	setxattrat		sys_setxattrat
+463	i386	getxattrat		sys_getxattrat
+464	i386	listxattrat		sys_listxattrat
+465	i386	removexattrat		sys_removexattrat
diff --git a/arch/x86/entry/syscalls/syscall_64.tbl b/arch/x86/entry/syscalls/syscall_64.tbl
index 7e8d46f4147f..819c90564f82 100644
--- a/arch/x86/entry/syscalls/syscall_64.tbl
+++ b/arch/x86/entry/syscalls/syscall_64.tbl
@@ -383,6 +383,10 @@
 459	common	lsm_get_self_attr	sys_lsm_get_self_attr
 460	common	lsm_set_self_attr	sys_lsm_set_self_attr
 461	common	lsm_list_modules	sys_lsm_list_modules
+462	common	setxattrat		sys_setxattrat
+463	common	getxattrat		sys_getxattrat
+464	common	listxattrat		sys_listxattrat
+465	common	removexattrat		sys_removexattrat
 
 #
 # Due to a historical design error, certain syscalls are numbered differently
diff --git a/arch/xtensa/kernel/syscalls/syscall.tbl b/arch/xtensa/kernel/syscalls/syscall.tbl
index dd116598fb25..36bdfe759878 100644
--- a/arch/xtensa/kernel/syscalls/syscall.tbl
+++ b/arch/xtensa/kernel/syscalls/syscall.tbl
@@ -432,3 +432,7 @@
 459	common	lsm_get_self_attr		sys_lsm_get_self_attr
 460	common	lsm_set_self_attr		sys_lsm_set_self_attr
 461	common	lsm_list_modules		sys_lsm_list_modules
+462	common	setxattrat			sys_setxattrat
+463	common	getxattrat			sys_getxattrat
+464	common	listxattrat			sys_listxattrat
+465	common	removexattrat			sys_removexattrat
diff --git a/fs/xattr.c b/fs/xattr.c
index 941aab719da0..d45e83224a7c 100644
--- a/fs/xattr.c
+++ b/fs/xattr.c
@@ -655,21 +655,28 @@ setxattr(struct mnt_idmap *idmap, struct dentry *d,
 	return error;
 }
 
-static int path_setxattr(const char __user *pathname,
+static int do_setxattrat(int dfd, const char __user *pathname, unsigned int at_flags,
 			 const char __user *name, const void __user *value,
-			 size_t size, int flags, unsigned int lookup_flags)
+			 size_t size, int xattr_flags)
 {
 	struct path path;
 	int error;
+	int lookup_flags;
 
+	if ((at_flags & ~(AT_SYMLINK_NOFOLLOW | AT_EMPTY_PATH)) != 0)
+		return -EINVAL;
+
+	lookup_flags = (at_flags & AT_SYMLINK_NOFOLLOW) ? 0 : LOOKUP_FOLLOW;
+	if (at_flags & AT_EMPTY_PATH)
+		lookup_flags |= LOOKUP_EMPTY;
 retry:
-	error = user_path_at(AT_FDCWD, pathname, lookup_flags, &path);
+	error = user_path_at(dfd, pathname, lookup_flags, &path);
 	if (error)
 		return error;
 	error = mnt_want_write(path.mnt);
 	if (!error) {
 		error = setxattr(mnt_idmap(path.mnt), path.dentry, name,
-				 value, size, flags);
+				 value, size, xattr_flags);
 		mnt_drop_write(path.mnt);
 	}
 	path_put(&path);
@@ -680,18 +687,38 @@ static int path_setxattr(const char __user *pathname,
 	return error;
 }
 
+SYSCALL_DEFINE6(setxattrat, int, dfd, const char __user *, pathname, unsigned int, at_flags,
+		const char __user *, name, const struct xattr_args __user *, uargs,
+		size_t, usize)
+{
+	struct xattr_args args = {};
+	int error;
+
+	if (usize > PAGE_SIZE)
+		return -E2BIG;
+	if (usize < sizeof(args))
+		return -EINVAL;
+
+	error = copy_struct_from_user(&args, sizeof(args), uargs, usize);
+	if (error)
+		return error;
+
+	return do_setxattrat(dfd, pathname, at_flags, name, (const void __user *)args.value,
+			     args.size, args.flags);
+}
+
 SYSCALL_DEFINE5(setxattr, const char __user *, pathname,
 		const char __user *, name, const void __user *, value,
 		size_t, size, int, flags)
 {
-	return path_setxattr(pathname, name, value, size, flags, LOOKUP_FOLLOW);
+	return do_setxattrat(AT_FDCWD, pathname, 0, name, value, size, flags);
 }
 
 SYSCALL_DEFINE5(lsetxattr, const char __user *, pathname,
 		const char __user *, name, const void __user *, value,
 		size_t, size, int, flags)
 {
-	return path_setxattr(pathname, name, value, size, flags, 0);
+	return do_setxattrat(AT_FDCWD, pathname, AT_SYMLINK_NOFOLLOW, name, value, size, flags);
 }
 
 SYSCALL_DEFINE5(fsetxattr, int, fd, const char __user *, name,
@@ -774,14 +801,22 @@ getxattr(struct mnt_idmap *idmap, struct dentry *d,
 	return error;
 }
 
-static ssize_t path_getxattr(const char __user *pathname,
+static ssize_t do_getxattrat(int dfd, const char __user *pathname, unsigned int at_flags,
 			     const char __user *name, void __user *value,
-			     size_t size, unsigned int lookup_flags)
+			     size_t size)
 {
 	struct path path;
 	ssize_t error;
+	int lookup_flags;
+
+	if ((at_flags & ~(AT_SYMLINK_NOFOLLOW | AT_EMPTY_PATH)) != 0)
+		return -EINVAL;
+
+	lookup_flags = (at_flags & AT_SYMLINK_NOFOLLOW) ? 0 : LOOKUP_FOLLOW;
+	if (at_flags & AT_EMPTY_PATH)
+		lookup_flags |= LOOKUP_EMPTY;
 retry:
-	error = user_path_at(AT_FDCWD, pathname, lookup_flags, &path);
+	error = user_path_at(dfd, pathname, lookup_flags, &path);
 	if (error)
 		return error;
 	error = getxattr(mnt_idmap(path.mnt), path.dentry, name, value, size);
@@ -793,16 +828,37 @@ static ssize_t path_getxattr(const char __user *pathname,
 	return error;
 }
 
+SYSCALL_DEFINE6(getxattrat, int, dfd, const char __user *, pathname, unsigned int, at_flags,
+		const char __user *, name, struct xattr_args __user *, uargs, size_t, usize)
+{
+	struct xattr_args args = {};
+	int error;
+
+	if (usize > PAGE_SIZE)
+		return -E2BIG;
+	if (usize < sizeof(args))
+		return -EINVAL;
+
+	error = copy_struct_from_user(&args, sizeof(args), uargs, usize);
+	if (error)
+		return error;
+
+	if (args.flags != 0)
+		return -EINVAL;
+
+	return do_getxattrat(dfd, pathname, at_flags, name, (void __user *)args.value, args.size);
+}
+
 SYSCALL_DEFINE4(getxattr, const char __user *, pathname,
 		const char __user *, name, void __user *, value, size_t, size)
 {
-	return path_getxattr(pathname, name, value, size, LOOKUP_FOLLOW);
+	return do_getxattrat(AT_FDCWD, pathname, 0, name, value, size);
 }
 
 SYSCALL_DEFINE4(lgetxattr, const char __user *, pathname,
 		const char __user *, name, void __user *, value, size_t, size)
 {
-	return path_getxattr(pathname, name, value, size, 0);
+	return do_getxattrat(AT_FDCWD, pathname, AT_SYMLINK_NOFOLLOW, name, value, size);
 }
 
 SYSCALL_DEFINE4(fgetxattr, int, fd, const char __user *, name,
@@ -852,13 +908,21 @@ listxattr(struct dentry *d, char __user *list, size_t size)
 	return error;
 }
 
-static ssize_t path_listxattr(const char __user *pathname, char __user *list,
-			      size_t size, unsigned int lookup_flags)
+static ssize_t do_listxattrat(int dfd, const char __user *pathname, char __user *list,
+			      size_t size, int flags)
 {
 	struct path path;
 	ssize_t error;
+	int lookup_flags;
+
+	if ((flags & ~(AT_SYMLINK_NOFOLLOW | AT_EMPTY_PATH)) != 0)
+		return -EINVAL;
+
+	lookup_flags = (flags & AT_SYMLINK_NOFOLLOW) ? 0 : LOOKUP_FOLLOW;
+	if (flags & AT_EMPTY_PATH)
+		lookup_flags |= LOOKUP_EMPTY;
 retry:
-	error = user_path_at(AT_FDCWD, pathname, lookup_flags, &path);
+	error = user_path_at(dfd, pathname, lookup_flags, &path);
 	if (error)
 		return error;
 	error = listxattr(path.dentry, list, size);
@@ -870,16 +934,22 @@ static ssize_t path_listxattr(const char __user *pathname, char __user *list,
 	return error;
 }
 
+SYSCALL_DEFINE5(listxattrat, int, dfd, const char __user *, pathname, char __user *, list,
+		size_t, size, int, flags)
+{
+	return do_listxattrat(dfd, pathname, list, size, flags);
+}
+
 SYSCALL_DEFINE3(listxattr, const char __user *, pathname, char __user *, list,
 		size_t, size)
 {
-	return path_listxattr(pathname, list, size, LOOKUP_FOLLOW);
+	return do_listxattrat(AT_FDCWD, pathname, list, size, 0);
 }
 
 SYSCALL_DEFINE3(llistxattr, const char __user *, pathname, char __user *, list,
 		size_t, size)
 {
-	return path_listxattr(pathname, list, size, 0);
+	return do_listxattrat(AT_FDCWD, pathname, list, size, AT_SYMLINK_NOFOLLOW);
 }
 
 SYSCALL_DEFINE3(flistxattr, int, fd, char __user *, list, size_t, size)
@@ -898,7 +968,7 @@ SYSCALL_DEFINE3(flistxattr, int, fd, char __user *, list, size_t, size)
 /*
  * Extended attribute REMOVE operations
  */
-static long
+static int
 removexattr(struct mnt_idmap *idmap, struct dentry *d,
 	    const char __user *name)
 {
@@ -917,13 +987,21 @@ removexattr(struct mnt_idmap *idmap, struct dentry *d,
 	return vfs_removexattr(idmap, d, kname);
 }
 
-static int path_removexattr(const char __user *pathname,
-			    const char __user *name, unsigned int lookup_flags)
+static int do_removexattrat(int dfd, const char __user *pathname,
+			    const char __user *name, int flags)
 {
 	struct path path;
 	int error;
+	int lookup_flags;
+
+	if ((flags & ~(AT_SYMLINK_NOFOLLOW | AT_EMPTY_PATH)) != 0)
+		return -EINVAL;
+
+	lookup_flags = (flags & AT_SYMLINK_NOFOLLOW) ? 0 : LOOKUP_FOLLOW;
+	if (flags & AT_EMPTY_PATH)
+		lookup_flags |= LOOKUP_EMPTY;
 retry:
-	error = user_path_at(AT_FDCWD, pathname, lookup_flags, &path);
+	error = user_path_at(dfd, pathname, lookup_flags, &path);
 	if (error)
 		return error;
 	error = mnt_want_write(path.mnt);
@@ -939,16 +1017,22 @@ static int path_removexattr(const char __user *pathname,
 	return error;
 }
 
+SYSCALL_DEFINE4(removexattrat, int, dfd, const char __user *, pathname,
+		const char __user *, name, int, flags)
+{
+	return do_removexattrat(dfd, pathname, name, flags);
+}
+
 SYSCALL_DEFINE2(removexattr, const char __user *, pathname,
 		const char __user *, name)
 {
-	return path_removexattr(pathname, name, LOOKUP_FOLLOW);
+	return do_removexattrat(AT_FDCWD, pathname, name, 0);
 }
 
 SYSCALL_DEFINE2(lremovexattr, const char __user *, pathname,
 		const char __user *, name)
 {
-	return path_removexattr(pathname, name, 0);
+	return do_removexattrat(AT_FDCWD, pathname, name, AT_SYMLINK_NOFOLLOW);
 }
 
 SYSCALL_DEFINE2(fremovexattr, int, fd, const char __user *, name)
diff --git a/include/asm-generic/audit_change_attr.h b/include/asm-generic/audit_change_attr.h
index 331670807cf0..cc840537885f 100644
--- a/include/asm-generic/audit_change_attr.h
+++ b/include/asm-generic/audit_change_attr.h
@@ -11,9 +11,15 @@ __NR_lchown,
 __NR_fchown,
 #endif
 __NR_setxattr,
+#ifdef __NR_setxattrat
+__NR_setxattrat,
+#endif
 __NR_lsetxattr,
 __NR_fsetxattr,
 __NR_removexattr,
+#ifdef __NR_removexattrat
+__NR_removexattrat,
+#endif
 __NR_lremovexattr,
 __NR_fremovexattr,
 #ifdef __NR_fchownat
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index e619ac10cd23..e06fffc48535 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -338,23 +338,33 @@ asmlinkage long sys_io_uring_register(unsigned int fd, unsigned int op,
 				void __user *arg, unsigned int nr_args);
 asmlinkage long sys_setxattr(const char __user *path, const char __user *name,
 			     const void __user *value, size_t size, int flags);
+asmlinkage long sys_setxattrat(int dfd, const char __user *path, unsigned int at_flags,
+			       const char __user *name,
+			       const struct xattr_args __user *args, size_t size);
 asmlinkage long sys_lsetxattr(const char __user *path, const char __user *name,
 			      const void __user *value, size_t size, int flags);
 asmlinkage long sys_fsetxattr(int fd, const char __user *name,
 			      const void __user *value, size_t size, int flags);
 asmlinkage long sys_getxattr(const char __user *path, const char __user *name,
 			     void __user *value, size_t size);
+asmlinkage long sys_getxattrat(int dfd, const char __user *path, unsigned int at_flags,
+			       const char __user *name,
+			       struct xattr_args __user *args, size_t size);
 asmlinkage long sys_lgetxattr(const char __user *path, const char __user *name,
 			      void __user *value, size_t size);
 asmlinkage long sys_fgetxattr(int fd, const char __user *name,
 			      void __user *value, size_t size);
 asmlinkage long sys_listxattr(const char __user *path, char __user *list,
 			      size_t size);
+asmlinkage long sys_listxattrat(int dfd, const char __user *path, char __user *list,
+			      size_t size, int flags);
 asmlinkage long sys_llistxattr(const char __user *path, char __user *list,
 			       size_t size);
 asmlinkage long sys_flistxattr(int fd, char __user *list, size_t size);
 asmlinkage long sys_removexattr(const char __user *path,
 				const char __user *name);
+asmlinkage long sys_removexattrat(int dfd, const char __user *path,
+				const char __user *name, int flags);
 asmlinkage long sys_lremovexattr(const char __user *path,
 				 const char __user *name);
 asmlinkage long sys_fremovexattr(int fd, const char __user *name);
diff --git a/include/uapi/asm-generic/unistd.h b/include/uapi/asm-generic/unistd.h
index 75f00965ab15..21b275a8dcd6 100644
--- a/include/uapi/asm-generic/unistd.h
+++ b/include/uapi/asm-generic/unistd.h
@@ -842,8 +842,18 @@ __SYSCALL(__NR_lsm_set_self_attr, sys_lsm_set_self_attr)
 #define __NR_lsm_list_modules 461
 __SYSCALL(__NR_lsm_list_modules, sys_lsm_list_modules)
 
+/* fs/xattr.c */
+#define __NR_setxattrat 462
+__SYSCALL(__NR_setxattrat, sys_setxattrat)
+#define __NR_getxattrat 463
+__SYSCALL(__NR_getxattrat, sys_getxattrat)
+#define __NR_listxattrat 464
+__SYSCALL(__NR_listxattrat, sys_listxattrat)
+#define __NR_removexattrat 465
+__SYSCALL(__NR_removexattrat, sys_removexattrat)
+
 #undef __NR_syscalls
-#define __NR_syscalls 462
+#define __NR_syscalls 466
 
 /*
  * 32 bit systems traditionally used different
diff --git a/include/uapi/linux/xattr.h b/include/uapi/linux/xattr.h
index 9463db2dfa9d..e9ac2acc40c3 100644
--- a/include/uapi/linux/xattr.h
+++ b/include/uapi/linux/xattr.h
@@ -20,6 +20,12 @@
 
 #define XATTR_CREATE	0x1	/* set value, fail if attr already exists */
 #define XATTR_REPLACE	0x2	/* set value, fail if attr does not exist */
+
+struct xattr_args {
+	__aligned_u64 __user value;
+	__u32 size;
+	__u32 flags;
+};
 #endif
 
 /* Namespaces */
-- 
2.43.0


