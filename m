Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98A87698778
	for <lists+io-uring@lfdr.de>; Wed, 15 Feb 2023 22:40:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229644AbjBOVkg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Feb 2023 16:40:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbjBOVkf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Feb 2023 16:40:35 -0500
Received: from mout.gmx.net (mout.gmx.net [212.227.15.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0024D2B0BA
        for <io-uring@vger.kernel.org>; Wed, 15 Feb 2023 13:40:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.de; s=s31663417;
        t=1676497227; i=deller@gmx.de;
        bh=Xp6ApsCgs+9C7q/qmnyCkM0AmU92HcZ/RIaroGIOeog=;
        h=X-UI-Sender-Class:Date:From:To:Cc:Subject:References:In-Reply-To;
        b=k0q9G/lkGtsY0fS9EurUo6WnPw79yLF55AeBZOE7N2/NY5XWfleXMcedfUGEfrEmZ
         yWiFmQqOaxRcmAxyo+aK1hxbQnfhWvTExQJnTlzWdoewVImrv57hPcMU2uTTicz6jn
         jITCpH4Ke9pcE7hyfmF+3Gafy7wJHPRtlUVGolCHt9i8DI8rmgVQwosSPGq7fA3185
         pNsmIpvKXNF9cRsMD3GAvkHoCgNLSImn3F7Yfy3t3mht122WzO26vEZbJttgN6lLui
         J2YFwXrgj1NPkMqsUk8cGe2sbbzQ49ar1zPwdZbpGV9IGAlJTPNEr35+ETJzemQCaf
         LFjbVWkgxVDBA==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from p100 ([92.116.136.89]) by mail.gmx.net (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1Md6Mj-1otcvQ0eah-00aGaR; Wed, 15
 Feb 2023 22:40:27 +0100
Date:   Wed, 15 Feb 2023 22:40:25 +0100
From:   Helge Deller <deller@gmx.de>
To:     Jens Axboe <axboe@kernel.dk>,
        John David Anglin <dave.anglin@bell.net>
Cc:     io-uring@vger.kernel.org
Subject: Re: io_uring failure on parisc with VIPT caches
Message-ID: <Y+1RSYoZqZvqH/cb@p100>
References: <Y+wUwVxeN87gqN6o@p100>
 <006e8db4-336f-6717-ecb0-d01a0e9bc483@kernel.dk>
 <626cee6f-f542-b7eb-16ca-1cf4e3808ca6@bell.net>
 <5f02fa8b-7fd8-d98f-4876-f1a89024b888@kernel.dk>
 <2b89f252-c430-1c44-7b30-02d927d2c7cb@gmx.de>
 <f7c3ef57-f16c-7fe3-30b7-8ca6a9ef00ee@kernel.dk>
 <1e77c848-5f8d-9300-8496-6c13a625a15c@gmx.de>
 <759bc2f7-5f9e-2a62-aa37-361dea902af5@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <759bc2f7-5f9e-2a62-aa37-361dea902af5@kernel.dk>
X-Provags-ID: V03:K1:/FMh14jA55/sGrUyEWwDOjppb9pY446JzaWaK7IadbytDEoKH1T
 s4ppkpFLYtn6NnfIcX9wuR+521urNWRHwmrMjJ3o/ok0T6UiI4ruKwyd39UM6tYj/RvL4sw
 BxL8krmZxyjx8WKpefC+qksCTraK+C7nPk666ts12FnoIt0YGnWD/wvupRTMcvsnoXBAzIo
 yyVL2aML3PReZjRu+TYgw==
UI-OutboundReport: notjunk:1;M01:P0:m+NyuWDF3VM=;OwHliZAh5sGjCiaePurAdvYznQ8
 iKAJg5X2xRHCOSAXCAzrA430Q6DsO+gyhvXTH1vKcjk2KX/Sssn/8XlmoRxNe6KITGppdEGpB
 YjKsaHP3ujy1yxoPqPtSSWDpegbJupajwQdXmfmIBxLQ3NplKiXXZDz0yxxo0QFmxgZ0VageB
 rw0hfw10hd+gcyEWY8Y9cEKetCNBH+z3GiDnSgsrnoWQE/Iry1bQg0RANbSkZ/7BziLbGpQIn
 gfS3G8Fh1T+y/mGzFnCPWbORkSlZUnv+ZPYzggSZPLknFtnQcKam6iI7N/XgRSkfgty2hf2EY
 9sXVuE7CoLk6eztLOFbVZ53lLl9YwWj3C4jYkZ//McjbabUCEIy5//EY4ycmnLVhTQv348Ye+
 wehakLLKlWYwcvfmXoWB3/bM6mMMLBLpR4VFbUzpXGwEkbXzPgZULjO3d3sZaRpd2e3OMBXoB
 G1xak3obT4wVZ/h3JXl0IBbxeEj6s3MalSyR7SZPGwqUGpXP4Cx+FNv9uza3CIWv8jgOCk4iO
 +6FKVo8TvQzYNviUa8fnV4HbvM2KiA6CK/tFiCeee6SjiuLYT22ipl5RXUAe/HGxIT1OD5o9k
 T/yanW7/BIbAWXRz2BNAI1pvu1PCGKEaJFiL8/hqQpvrCM2oIDYtaFW7PPJflLJD05qFeBoU2
 OtEW3p4u9/v+55bRElQ8aTGbzudLkWWvJbB7BVv8DmKKhA54IaMnaLr4afKc01QceN0S1Aphz
 3wQ5+tVEa08bcx/TW/v0r3Vrx1sZ4Ic/OA3Xkwj40BGLuxdV+oagKVkkYXfBlz+AXleVb/7Om
 lNcYWbfqHCPr44/W6BBHiJd1A8uMeFsyuCdOCtuzyq3BSsgR7pILy4NkbdzTRKYokq+vrC/W8
 pnTfhCVD2Sc4E2x/lHujgoRvZheyth4sfNH/dqrOL0oV5MN6yO3EAR1cScdYX4qDcXhXhlucG
 /1/p6mB3yXS71kISQ+bjXmIiIak=
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Here is an updated patch which
- should support other platforms which needs aliasing
- allows users to pass in an address in mmap(). This is checked
  and returned -EINVAL if it does not fullfill the aliasing.
  (this part is untested up to now!)


Jens, I think you need to add the "_FILE_OFFSET_BITS=3D64" define
when compiling your testsuite, e.g. for lfs-openat.t and lfs-openat-write.=
t

Helge


diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 862e05e6691d..d89fe16878dc 100644
=2D-- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -72,6 +72,7 @@
 #include <linux/io_uring.h>
 #include <linux/audit.h>
 #include <linux/security.h>
+#include <asm/shmparam.h>

 #define CREATE_TRACE_POINTS
 #include <trace/events/io_uring.h>
@@ -3059,6 +3060,63 @@ static __cold int io_uring_mmap(struct file *file, =
struct vm_area_struct *vma)
 	return remap_pfn_range(vma, vma->vm_start, pfn, sz, vma->vm_page_prot);
 }

+static unsigned long io_uring_mmu_get_unmapped_area(struct file *filp,
+			unsigned long addr0, unsigned long len,
+			unsigned long pgoff, unsigned long flags)
+{
+	const unsigned long mmap_end =3D arch_get_mmap_end(addr, len, flags);
+	struct vm_unmapped_area_info info;
+	unsigned long addr;
+	void *ptr;
+
+	ptr =3D io_uring_validate_mmap_request(filp, pgoff, len);
+	if (IS_ERR(ptr))
+		return -ENOMEM;
+
+	info.flags =3D VM_UNMAPPED_AREA_TOPDOWN;
+	info.length =3D len;
+	info.low_limit =3D max(PAGE_SIZE, mmap_min_addr);
+	info.high_limit =3D arch_get_mmap_base(addr, current->mm->mmap_base);
+#ifdef SHM_COLOUR
+	info.align_mask =3D PAGE_MASK & (SHM_COLOUR - 1UL);;
+#else
+	info.align_mask =3D PAGE_MASK & (SHMLBA - 1UL);
+#endif
+	info.align_offset =3D (unsigned long) ptr;
+
+	if (addr0) {
+		/* check page alignment and shm aliasing */
+		if ((addr0 & (PAGE_SIZE - 1UL) ||
+		    ((addr0 & info.align_mask) !=3D
+			(info.align_offset & info.align_mask))))
+			return -EINVAL;
+		info.low_limit =3D max(addr0, info.low_limit);
+		info.high_limit =3D min(addr0 + len, info.high_limit);
+	}
+
+	/*
+	 * A failed mmap() very likely causes application failure,
+	 * so fall back to the bottom-up function here. This scenario
+	 * can happen with large stack limits and large mmap()
+	 * allocations.
+	 */
+	addr =3D vm_unmapped_area(&info);
+
+	/* if address was given, check against found address */
+	if (addr0 && addr !=3D addr0)
+		return -EINVAL;
+
+	if (offset_in_page(addr)) {
+		VM_BUG_ON(addr !=3D -ENOMEM);
+		info.flags =3D 0;
+		info.low_limit =3D TASK_UNMAPPED_BASE;
+		info.high_limit =3D mmap_end;
+		addr =3D vm_unmapped_area(&info);
+	}
+
+	return addr;
+}
+
 #else /* !CONFIG_MMU */

 static int io_uring_mmap(struct file *file, struct vm_area_struct *vma)
@@ -3273,6 +3331,8 @@ static const struct file_operations io_uring_fops =
=3D {
 #ifndef CONFIG_MMU
 	.get_unmapped_area =3D io_uring_nommu_get_unmapped_area,
 	.mmap_capabilities =3D io_uring_nommu_mmap_capabilities,
+#else
+	.get_unmapped_area =3D io_uring_mmu_get_unmapped_area,
 #endif
 	.poll		=3D io_uring_poll,
 #ifdef CONFIG_PROC_FS

