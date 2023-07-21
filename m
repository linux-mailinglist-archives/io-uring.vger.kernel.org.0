Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D25EC75CBA1
	for <lists+io-uring@lfdr.de>; Fri, 21 Jul 2023 17:24:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231279AbjGUPYt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 21 Jul 2023 11:24:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231124AbjGUPYn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 21 Jul 2023 11:24:43 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAD9C30DF;
        Fri, 21 Jul 2023 08:24:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.de;
 s=s31663417; t=1689953074; x=1690557874; i=deller@gmx.de;
 bh=dc9kWra9ypygI1Is19IALpuSbGOBe3lX2QdPVOp/v9s=;
 h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
 b=kEGesIdm30Ffy2+8IJH8B0kNiqfLnoJ+El+teymShR95a9ipVPFKB+E2Qwb6DK5cVb/0+lc
 FyApxSS3xTXNLLJ9KjGo41qua6lbYoaOZPllvmuHVqrlpct+DxKB/WAAkMA/kUfE6BiQg83E7
 Kt0xCn7D1Dg5/RGzfnKkZnoowLQJIhZ6DpRCpPvu3i0ORKXajtStORMk204iRnwwEOtQaBrfR
 5ILLpsrzJi9BUL4l5js+UB2VVLjKKI7Oj5y/6hbw/fwH6tvLLeAJGG1ac7DUEJ1x6B06zd+vZ
 HCLB+K5h5pESlt/NnZPqx+ov+fNtVY2h4ly398YBGMBg/lUPdsZQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from p100.fritz.box ([94.134.144.189]) by mail.gmx.net (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1N6bjy-1pqLbI0UhS-0185JI; Fri, 21
 Jul 2023 17:24:34 +0200
From:   Helge Deller <deller@gmx.de>
To:     linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>, linux-ia64@vger.kernel.org,
        Jiri Slaby <jirislaby@kernel.org>, linux-parisc@vger.kernel.org
Cc:     Helge Deller <deller@gmx.de>,
        matoro <matoro_mailinglist_kernel@matoro.tk>
Subject: [PATCH 1/2] io_uring: Fix io_uring mmap() by using architecture-provided get_unmapped_area()
Date:   Fri, 21 Jul 2023 17:24:31 +0200
Message-ID: <20230721152432.196382-2-deller@gmx.de>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721152432.196382-1-deller@gmx.de>
References: <20230721152432.196382-1-deller@gmx.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:kzPNfBubwIAm6jIU5x6btA4ZDwGK76xM124wZLXWVQgpeipS7tt
 V6B0QnlOj4xGHa+h/F4yPu/XeG+TU0Q2XC1Hz2ibjmbbI+pAF1c1TkXstQ7vVLyiRY/o6bi
 DWisgLSUiKjHQwT/v5ZR8gyaQ1R1OflBcQtMIGqQJmDE33Ka4u/iZLzzr7TsmjOT8rmL7yb
 htP5pUPZLpy1sRSm/rIDw==
UI-OutboundReport: notjunk:1;M01:P0:9tu16ombaCA=;2zqAQ/W++1GcM2Vdx2AGC1WGpMb
 TLOz/kD34B/esUBUKS4B8S3SXoo3ekfNnZ7Utq/KVd+gLPdtz6GRsVhdJVyNYo8ZiLmVtf04q
 R78ojvTz5Gji0Q1blkEy+EYN6DwuIWq5yQUWAKskLx4YJh9N76YWGQ+eGawjltTC218rBq0Cu
 K6QBBYIKTTmIbkgSL4XuCT6npkm++tiUiY/SCAZWd49R5oF0+ZqRPTQIRiiKwrMfAPBwAe3SG
 xlAyXgKFyvhwmBY/2vXnr+98Yr3N1uzUuMq2T8Tx2sCl/uL0dDlWSlx5qbCchkShiCHfpsGWS
 k/wSAqtFSpdDgZCLEv8rrb65rsv+q7tUzPgrypBB64IKuOSmuYrM1cvKx98HDo+FtEQFzP4Zd
 YzgknjaQgF3uN2wWnu+vg96QIBDZ9tYSTJ3QOIIQ3jW4OEq0aFeayjIyxsm+KX2ba0Z9AOyM+
 VnVMoFiCDjMdbMRb7Mw2kmpeWYAb+mZrfwn+1knB1SP1RlOqLtGEntvslo7quxNZOjDuhNTAr
 3bjqYnnPDVPyvPxcpRY+xJiDjj9yLXiXjdWvA+ygbB43SZimIDbDxznSO+I7dwAAOa4uqYRU0
 ZJKJYZ11uniRHeMwDL9NAsRFNKpP5mv+cZkjad9/yXSVagmXEULI2EkIrOYwKEZyM82bHz3OX
 9vqXk+9/6KtweWwC/r0kk3xQBR5xbbpb+Yp2V9m9sW4d6Bap00Gj/sZfPUS8ZbPgadyZuIAbh
 +ALE9N/GC1QgmUnaignDPsRx+3y5TiB0IBazpb+BjZjxLUv8mY5WTuMqVG2z/6UCeJUf/8S6y
 +etfQkNiyM01J0UuDNRwZz/VkHaxK0e3w4xqqWcQ86Ap0G6FATB0X9MDy0xCMBNbYzq/xkGjB
 8a35hL/ABjMc/IAUMH5q4H/NuQpVa+OD3U+hkN2YP6AqIiw9uSaPT6l6OzqppmVj0mGqlcl4a
 NFtUug==
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
independend get_unmapped_area() search algorithm which finds on IA-64 a
memory region which is outside of the regular memory region used for
shared userspace mappings and which can't be used on that platform
due to aliasing.

To avoid similar problems on IA-64 and other platforms in the future,
it's better to switch back to the architecture-provided
get_unmapped_area() function and adjust the needed input parameters
before the call. Beside fixing the issue, the function now becomes
easier to understand and maintain.

This patch has been successfully tested with the io_uring testcase on
physical x86-64, ppc64le, IA-64 and PA-RISC machines. On PA-RISC the LTP
mmmap testcases did not report any regressions.

Signed-off-by: Helge Deller <deller@gmx.de>
Cc: Jens Axboe <axboe@kernel.dk>
Reported-by: matoro <matoro_mailinglist_kernel@matoro.tk>
Fixes: d808459b2e31 ("io_uring: Adjust mapping wrt architecture aliasing r=
equirements")
=2D--
 arch/parisc/kernel/sys_parisc.c | 15 ++++++++----
 io_uring/io_uring.c             | 42 +++++++++++++--------------------
 2 files changed, 27 insertions(+), 30 deletions(-)

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
index 3bca7a79efda..227e50aa9af0 100644
=2D-- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3398,8 +3398,6 @@ static unsigned long io_uring_mmu_get_unmapped_area(=
struct file *filp,
 			unsigned long addr, unsigned long len,
 			unsigned long pgoff, unsigned long flags)
 {
-	const unsigned long mmap_end =3D arch_get_mmap_end(addr, len, flags);
-	struct vm_unmapped_area_info info;
 	void *ptr;

 	/*
@@ -3414,32 +3412,26 @@ static unsigned long io_uring_mmu_get_unmapped_are=
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
=2D-
2.41.0

