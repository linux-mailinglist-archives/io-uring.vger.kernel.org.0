Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3D10772D75
	for <lists+io-uring@lfdr.de>; Mon,  7 Aug 2023 20:04:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229542AbjHGSEX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 7 Aug 2023 14:04:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229513AbjHGSEW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 7 Aug 2023 14:04:22 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.15.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BF75A6;
        Mon,  7 Aug 2023 11:04:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.de;
 s=s31663417; t=1691431451; x=1692036251; i=deller@gmx.de;
 bh=UePQ6YisLC6M5ceFDhpXVaA0z8FJSbdscI+KWi1SjhM=;
 h=X-UI-Sender-Class:Date:From:To:Cc:Subject:References:In-Reply-To;
 b=scUYL1E+ryZxq7ymBxNb43UV7hwm4L+XW0XqLvxY7A6jHcThcSXicUKThvRynnQWZg0ZdQN
 f+Bo2cryQXQDzrh6WS9NHl98zw8h0fj7hoF0prJTWNFY6e2bDbwo/ZcmPdWmq95ryaCyyu5i8
 dXmTNQmzUfuZrQBfOVfLh0H7+m55zveJOmPw8uLfUCrlZH8d+IgaMei8Dw4MYE6UQ5e62A2Wj
 HgdAyM/eeLMvQ59CbhSVM5TKvXF/JJQ9BxjHjg5FkwWaS/zB0wbTscMUOE4Cy2utr0QnYZQnA
 6giA7/JRMOj/rzE6wOck/Cd6rz1eQHuqfrBMJlrE0dg9ThYSBaiA==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from p100 ([94.134.150.52]) by mail.gmx.net (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1McH5a-1pxKGl1oJo-00ciwa; Mon, 07
 Aug 2023 20:04:11 +0200
Date:   Mon, 7 Aug 2023 20:04:09 +0200
From:   Helge Deller <deller@gmx.de>
To:     Christoph Biedl <linux-kernel.bfrz@manchmal.in-ulm.de>,
        linux-parisc@vger.kernel.org, io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, Mike Rapoport <rppt@kernel.org>,
        Vlastimil Babka <vbabka@suse.cz>
Subject: [PATCH] io_uring/parisc: Adjust pgoff in io_uring mmap() for parisc
Message-ID: <ZNEyGV0jyI8kOOfz@p100>
References: <ZMle513nIspxquF5@mail.manchmal.in-ulm.de>
 <ZMooZAKcm8OtKIfx@kernel.org>
 <1691003952@msgid.manchmal.in-ulm.de>
 <1691349294@msgid.manchmal.in-ulm.de>
 <f361955c-bcea-a424-b3d5-927910ab5f1d@gmx.de>
 <b9a15934-ea29-ef54-a272-671859d2bc02@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b9a15934-ea29-ef54-a272-671859d2bc02@gmx.de>
X-Provags-ID: V03:K1:RIr0yczejNahZJRreaVrjJSiaYCAzr1MxQXFbOzva+3Vp0r+KGZ
 dJt9TXUONsoxu0d3tPR8zV9+A9dE1Kb5Kz29TQ2e8b3Wagx395vJaJq7UjFB9r/mwcPPKay
 lJJGvfSIdQ010CD1HTDxsaVBo+VwXCe1nD09L57pBGbODSfQNhHkdgB2rxEDggwCsN+mBcs
 adJyXHG5CKLz59WMZeu0A==
UI-OutboundReport: notjunk:1;M01:P0:jzpkHDeyaWc=;pQ75fL6FX1c/iHc8+yrIv6qrH2o
 AwEeJxqx8RZ5WaHx1xuLSG1iVSFIaryYh61nmKU9XNhfQ9hgo7R67tFFJ07TvViswvdz9aEgX
 VXJpFUaf17UizBe0zsfefAlP/O7vbirs+8KjR6Uj2kps0nxjogB78McrWjDdwSZSp/F2ubAtu
 Q8vepth96mJQULrCfnLG2n0+GxwfSLz81aZVN/tQAjinaW/zazVBqP6kcaSixue8GS+IHWtVV
 EpMQmb9zCQUZwsAVfgExrV7EZgtYj/fjBy9Xh9/X2tVOa1G/Fjw64Uf2dKPvESAHlyXCIuMOe
 aj5LhaDAFjgYGgouG3wpQ+KJn5kHE5ymdOz0hTxKZBfrX2BL8yRynTmjim35HzJCbrf/JLWPA
 Cei3ie+qujq4j6hfhHc/XpUuUOW5iorogR7r2iGfve2/kRN2XhfH0UKguDlk26xEQAe26apkC
 URwlUcnf3zT7WCZjWFz0vBm/9XUeEJzZU3ky0wm+Kf0ij3+y0gdxU+LFS7vVFjYbRUQ6YpaCN
 O6nY6Q5AEuUyOrqe6cc9RIpxcoxN1uLfnuoFxdIBu5kBGUY7qPRQepvgwPDbA9Q/Kyk6qOoAv
 6niBrXUZV/5R/h0pDMjZR01RvN4cCePPRWaYSBjGsLjHFzX3uRDVI7hHttWcmsicZjccWUEk3
 LZRp1t3nXBoKOnhtEs2TP8Wo8iiRFxWJk4ZeI3fjLOIr6I7mxgrIzNacyUdRuD8EmnCY0oFeD
 BCSyafb/royDstER3gEJWs36mb0e97QTlYAII5lXNu9enUHYnJsL6rSTjci+R1qe0QbhiTgfj
 iTJp1KhbolXBfJ7lqfsJ1W1GL0UbcYNNh/I8FjLwDn5ITyW8xSzFsX6QWgMRtyDyyT3uczlB0
 +rbypvAxatPCPwailaa8qSQI/tEYIdkL564kZxs0DKVO2qNFQQcNwfT0uAoQmAt7oKNlugqnW
 glQ1mA==
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The changes from commit 32832a407a71 ("io_uring: Fix io_uring mmap() by
using architecture-provided get_unmapped_area()") to the parisc
implementation of get_unmapped_area() broke glibc's locale-gen
executable when running on parisc.

This patch reverts those architecture-specific changes, and instead
adjusts in io_uring_mmu_get_unmapped_area() the pgoff offset which is
then given to parisc's get_unmapped_area() function.  This is much
cleaner than the previous approach, and we still will get a coherent
addresss.

This patch has no effect on other architectures (SHM_COLOUR is only
defined on parisc), and the liburing testcase stil passes on parisc.

Signed-off-by: Helge Deller <deller@gmx.de>
Reported-by: Christoph Biedl <linux-kernel.bfrz@manchmal.in-ulm.de>
Fixes: 32832a407a71 ("io_uring: Fix io_uring mmap() by using architecture-=
provided get_unmapped_area()")
Fixes: d808459b2e31 ("io_uring: Adjust mapping wrt architecture aliasing r=
equirements")

diff --git a/arch/parisc/kernel/sys_parisc.c b/arch/parisc/kernel/sys_pari=
sc.c
index ca2d537e25b1..9915062d5243 100644
=2D-- a/arch/parisc/kernel/sys_parisc.c
+++ b/arch/parisc/kernel/sys_parisc.c
@@ -27,17 +27,12 @@
 #include <linux/elf-randomize.h>

 /*
- * Construct an artificial page offset for the mapping based on the virtu=
al
+ * Construct an artificial page offset for the mapping based on the physi=
cal
  * address of the kernel file mapping variable.
- * If filp is zero the calculated pgoff value aliases the memory of the g=
iven
- * address. This is useful for io_uring where the mapping shall alias a k=
ernel
- * address and a userspace adress where both the kernel and the userspace
- * access the same memory region.
  */
-#define GET_FILP_PGOFF(filp, addr)		\
-	((filp ? (((unsigned long) filp->f_mapping) >> 8)	\
-		 & ((SHM_COLOUR-1) >> PAGE_SHIFT) : 0UL)	\
-	  + (addr >> PAGE_SHIFT))
+#define GET_FILP_PGOFF(filp)		\
+	(filp ? (((unsigned long) filp->f_mapping) >> 8)	\
+		 & ((SHM_COLOUR-1) >> PAGE_SHIFT) : 0UL)

 static unsigned long shared_align_offset(unsigned long filp_pgoff,
 					 unsigned long pgoff)
@@ -117,7 +112,7 @@ static unsigned long arch_get_unmapped_area_common(str=
uct file *filp,
 	do_color_align =3D 0;
 	if (filp || (flags & MAP_SHARED))
 		do_color_align =3D 1;
-	filp_pgoff =3D GET_FILP_PGOFF(filp, addr);
+	filp_pgoff =3D GET_FILP_PGOFF(filp);

 	if (flags & MAP_FIXED) {
 		/* Even MAP_FIXED mappings must reside within TASK_SIZE */
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index f4591b912ea8..93db3e4e7b68 100644
=2D-- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3470,6 +3470,8 @@ static unsigned long io_uring_mmu_get_unmapped_area(=
struct file *filp,
 	 * - use the kernel virtual address of the shared io_uring context
 	 *   (instead of the userspace-provided address, which has to be 0UL
 	 *   anyway).
+	 * - use the same pgoff which the get_unmapped_area() uses to
+	 *   calculate the page colouring.
 	 * For architectures without such aliasing requirements, the
 	 * architecture will return any suitable mapping because addr is 0.
 	 */
@@ -3478,6 +3480,7 @@ static unsigned long io_uring_mmu_get_unmapped_area(=
struct file *filp,
 	pgoff =3D 0;	/* has been translated to ptr above */
 #ifdef SHM_COLOUR
 	addr =3D (uintptr_t) ptr;
+	pgoff =3D addr >> PAGE_SHIFT;
 #else
 	addr =3D 0UL;
 #endif
