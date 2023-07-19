Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 392AA75A07E
	for <lists+io-uring@lfdr.de>; Wed, 19 Jul 2023 23:21:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229796AbjGSVVF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 19 Jul 2023 17:21:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbjGSVVE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 19 Jul 2023 17:21:04 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB3271FC0;
        Wed, 19 Jul 2023 14:21:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.de;
 s=s31663417; t=1689801660; x=1690406460; i=deller@gmx.de;
 bh=gNkbRbptmMouxYMIBFLEub9MbsRJyCdJnwvjYwKt+kU=;
 h=X-UI-Sender-Class:Date:From:To:Subject;
 b=Cujk2OH2LDXNzPGE88He9x833krzOqBsMRotgg5OHAEJW+u8Bs/+dC1hVR7KHjf7EdFztLn
 1qx5z6XXiQ4B6PpOpij9mC2gO5ZtPH0ZwtGQFBbgcL/mX0RcAptRaIUKc/2IxthjzknY7YMlZ
 CPgO+paD+3JnqJJcTsf8gcxkHAvFTtqKhd0BlkcqEyMrEswFfCUfLok0DqKXJQwr16CgNRqHW
 eNSv7d9GrJL+R/IzRmUBzEpd28GNDSEjrl2Mn66qPi+4whNurA/Z6+V7qRfz0VkHaPih1qd72
 8NrVY1Su430yhNqEIOeZ80S2e5OwBD9cvHGIyTESPo3sPTFzT+AQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from p100 ([94.134.145.157]) by mail.gmx.net (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1M7K3Y-1qGjLz3gAW-007hY2; Wed, 19
 Jul 2023 23:20:59 +0200
Date:   Wed, 19 Jul 2023 23:20:57 +0200
From:   Helge Deller <deller@gmx.de>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-ia64@vger.kernel.org, matoro_mailinglist_kernel@matoro.tk,
        linux-parisc@vger.kernel.org
Subject: [PATCH][RFC] io_uring: Fix io_uring_mmu_get_unmapped_area() for IA-64
Message-ID: <ZLhTuTPecx2fGuH1@p100>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Provags-ID: V03:K1:EwY2RzLk9RKgvSpx5rlHVgjNLlt7RV/3gvc85Mr6EmpWekmzvpv
 M9WWJLWaZNY7J/u8aOu5V39D03C3UedRelbsbJGM4Piz49BZyBMjJktaWYoxvKyqLco56mu
 RW6mnStg0fAEDl/ScAllKzdodxc8vqJRGTL1TVJp81pxb2UZQtLNNHqQA7ZU5JWUU3DggkV
 OTa7HCLztuxNCE9xljziQ==
UI-OutboundReport: notjunk:1;M01:P0:m8fqtvCpf3o=;wIWVYZmPIFx3gkDbiuR17VT4Ky6
 1xDCK1Oldi5pYRJk2uNfwSRzAmcfdQNHrLseqIPv0NqOHHwSIqAsRfmlVxCkrigVT6biL13Jh
 M4/8LEovok4ewliGRKm9DUweI4wywTmvYK8kx48ak5f5NOgQ6/gkJWEuwbojacUJuEzYwOSjA
 kSsgNjJHmXUuazQtqxawBmRbfE0fXQEYHFl8MFgcBHov3YrDhQSPtmknwFboWRSg1KW0zqr2w
 R3tGfDlytdy5ZTQlFNFzmvSajh+iPcG6VyJLUom0cmb5vcUYPpOwGT8JtmOskcBm2YsRwqUMM
 FNNJm10zRtTrBAWXY6ZAp3MxsbG5MyHdcJqCamZiMtyJkH08jzwr8ltlP2jroF3z5Nl1OkUX8
 Xi2rdI1wVmArqM9czGa2329ShU70Dcf1J65Kapi2cj8Igo1RRpyTgsPl72VjGD+OuaL8HU+Py
 qI6Xr+tFMXOkr3/DWHQircJgl0kfNDUCAmsis5zoG9JqLZPIY1Wm2SNjwbMrTJSD4JV0lFgYr
 fH2bO/uterkKRKgGSblGinWDwJFxpq1T77kbkJhO3DyBioIVafsS753mmJYlaPUMMw++AOHR+
 0BiEz7RSawk1Dt2NMs2rY6gQUkTe5oWOBBnHKfIE/Gx0Wtvde6LSbKe5kuQVHOV0Rk4qXFWeO
 W0Je8oT0PBgSoWp5KKvhp8sd5Psr2dhM/m6Dj9Jas8hbzzyt0SAPIF2ch45njtMmiT9jLz8TG
 xfX23ZmCw4CQEJP5FiiSxtbJTdIdWkb7S70skkzqLMZdHtGTeTdw+gEfaW7w2ndJfY56me5ir
 Xa0m38kCUslDZHBaeTleDIZbzESrzj8svoULdbHfX9RO093f6DK4Gn/cwt1TOeFwFog8Uafvp
 1lJ6h3foytqvuv6OC23VyyD//h9q6KISWhv/qDkkpFhUn6bE9tZh9LT9oQda43x8NxrJBvAiM
 wAsOA8pP7JvIW3djT3f4uJ0mUio=
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The io_uring testcase is broken on IA-64 since commit d808459b2e31
("io_uring: Adjust mapping wrt architecture aliasing requirements").

The reason is, that this commit introduced an own architecture
independend get_unmapped_area() search algorithm which doesn't suite the
memory region requirements for IA-64.

To avoid similar problems in the future it's better to switch back to
the architecture-provided get_unmapped_area() function and adjust the
needed input parameters before the call.  Additionally
io_uring_mmu_get_unmapped_area() will now become easier to understand
and maintain.

This patch has been tested on physical IA-64 and PA-RISC machines,
without any failures in the io_uring testcases. On PA-RISC the
LTP mmmap testcases did not report any regressions either.

I don't expect issues for other architectures, but it would be nice if
this patch could be tested on other machines too.

Reported-by: matoro <matoro_mailinglist_kernel@matoro.tk>
Fixes: d808459b2e31 ("io_uring: Adjust mapping wrt architecture aliasing r=
equirements")
Signed-off-by: Helge Deller <deller@gmx.de>

diff --git a/arch/ia64/kernel/sys_ia64.c b/arch/ia64/kernel/sys_ia64.c
index 6e948d015332..eb561cc93632 100644
=2D-- a/arch/ia64/kernel/sys_ia64.c
+++ b/arch/ia64/kernel/sys_ia64.c
@@ -63,7 +63,7 @@ arch_get_unmapped_area (struct file *filp, unsigned long=
 addr, unsigned long len
 	info.low_limit =3D addr;
 	info.high_limit =3D TASK_SIZE;
 	info.align_mask =3D align_mask;
-	info.align_offset =3D 0;
+	info.align_offset =3D pgoff << PAGE_SHIFT;
 	return vm_unmapped_area(&info);
 }

diff --git a/arch/parisc/kernel/sys_parisc.c b/arch/parisc/kernel/sys_pari=
sc.c
index 39acccabf2ed..465b7cb9d44f 100644
=2D-- a/arch/parisc/kernel/sys_parisc.c
+++ b/arch/parisc/kernel/sys_parisc.c
@@ -26,12 +26,17 @@
 #include <linux/compat.h>

 /*
- * Construct an artificial page offset for the mapping based on the physi=
cal
+ * Construct an artificial page offset for the mapping based on the virtu=
al
  * address of the kernel file mapping variable.
+ * If filp is zero the calculated pgoff value aliases the memory of the g=
iven
+ * address. This is useful for io_uring where the mapping shall alias a k=
ernel
+ * address and a userspace adress where both the kernel and the userspace
+ * access the same memory region.
  */
-#define GET_FILP_PGOFF(filp)		\
-	(filp ? (((unsigned long) filp->f_mapping) >> 8)	\
-		 & ((SHM_COLOUR-1) >> PAGE_SHIFT) : 0UL)
+#define GET_FILP_PGOFF(filp, addr)		\
+	((filp ? (((unsigned long) filp->f_mapping) >> 8)	\
+		 & ((SHM_COLOUR-1) >> PAGE_SHIFT) : 0UL)	\
+	  + (addr >> PAGE_SHIFT))

 static unsigned long shared_align_offset(unsigned long filp_pgoff,
 					 unsigned long pgoff)
@@ -111,7 +116,7 @@ static unsigned long arch_get_unmapped_area_common(str=
uct file *filp,
 	do_color_align =3D 0;
 	if (filp || (flags & MAP_SHARED))
 		do_color_align =3D 1;
-	filp_pgoff =3D GET_FILP_PGOFF(filp);
+	filp_pgoff =3D GET_FILP_PGOFF(filp, addr);

 	if (flags & MAP_FIXED) {
 		/* Even MAP_FIXED mappings must reside within TASK_SIZE */
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index f1b79959d1c1..70eb01faf15f 100644
=2D-- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3425,8 +3425,6 @@ static unsigned long io_uring_mmu_get_unmapped_area(=
struct file *filp,
 			unsigned long addr, unsigned long len,
 			unsigned long pgoff, unsigned long flags)
 {
-	const unsigned long mmap_end =3D arch_get_mmap_end(addr, len, flags);
-	struct vm_unmapped_area_info info;
 	void *ptr;

 	/*
@@ -3441,32 +3439,26 @@ static unsigned long io_uring_mmu_get_unmapped_are=
a(struct file *filp,
 	if (IS_ERR(ptr))
 		return -ENOMEM;

-	info.flags =3D VM_UNMAPPED_AREA_TOPDOWN;
-	info.length =3D len;
-	info.low_limit =3D max(PAGE_SIZE, mmap_min_addr);
-	info.high_limit =3D arch_get_mmap_base(addr, current->mm->mmap_base);
+	/*
+	 * Some architectures have strong cache aliasing requirements.
+	 * For such architectures we need a coherent mapping which aliases
+	 * kernel memory *and* userspace memory. To achieve that:
+	 * - use a NULL file pointer to reference physical memory, and
+	 * - use the kernel virtual address of the shared io_uring context
+	 *   (instead of the userspace-provided address, which has to be 0UL
+	 *   anyway).
+	 * For architectures without such aliasing requirements, the
+	 * architecture will return any suitable mapping because addr is 0.
+	 */
+	filp =3D NULL;
+	flags |=3D MAP_SHARED;
+	pgoff =3D 0;	/* has been translated to ptr above */
 #ifdef SHM_COLOUR
-	info.align_mask =3D PAGE_MASK & (SHM_COLOUR - 1UL);
+	addr =3D (uintptr_t) ptr;
 #else
-	info.align_mask =3D PAGE_MASK & (SHMLBA - 1UL);
+	addr =3D 0UL;
 #endif
-	info.align_offset =3D (unsigned long) ptr;
-
-	/*
-	 * A failed mmap() very likely causes application failure,
-	 * so fall back to the bottom-up function here. This scenario
-	 * can happen with large stack limits and large mmap()
-	 * allocations.
-	 */
-	addr =3D vm_unmapped_area(&info);
-	if (offset_in_page(addr)) {
-		info.flags =3D 0;
-		info.low_limit =3D TASK_UNMAPPED_BASE;
-		info.high_limit =3D mmap_end;
-		addr =3D vm_unmapped_area(&info);
-	}
-
-	return addr;
+	return current->mm->get_unmapped_area(filp, addr, len, pgoff, flags);
 }

 #else /* !CONFIG_MMU */
