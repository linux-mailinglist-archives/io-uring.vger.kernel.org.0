Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FAED698E4E
	for <lists+io-uring@lfdr.de>; Thu, 16 Feb 2023 09:09:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229770AbjBPIJr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 16 Feb 2023 03:09:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbjBPIJq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 16 Feb 2023 03:09:46 -0500
Received: from mout.gmx.net (mout.gmx.net [212.227.15.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E12C32366B;
        Thu, 16 Feb 2023 00:09:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.de; s=s31663417;
        t=1676534980; i=deller@gmx.de;
        bh=VXuq6M/jcXpKTzmIaMHBMtYSC4LLAn7eTneX1IbXWDY=;
        h=X-UI-Sender-Class:Date:From:To:Subject;
        b=Yz95HRk+ZJZ9hi0NSGqYol2pFtS/iaT4BjnzH0bJ0MgxYHgQwxxAUU/O/WMuWXwEY
         8AGncPYIG+qOUNkdV66jnU1DEbz686ZNZlop/puOgl8MfYMY2awMEA4xxftYlHoyLx
         eQl4/OF3lfjwLIsVwDc5L2MMQhlripKONd6ZuQr2WskOaYBU+GxJtquWerUL7zMVBg
         7LFyD1hQh0KYxpf5pO832veJ3Pgt7Mz7l/SH2vjlN1H4fnApB+ViTDfrTfOs1j8bzI
         l1zVBjIfhz35JFNq7H1o/jYk4t8U/4dfL1O6OTADVyCLq0/2LhMEshmUii73XlwjQk
         zxz/tQ5XGSkXA==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from p100 ([92.116.164.173]) by mail.gmx.net (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MgNcz-1oudIZ2f8R-00hzM5; Thu, 16
 Feb 2023 09:09:40 +0100
Date:   Thu, 16 Feb 2023 09:09:38 +0100
From:   Helge Deller <deller@gmx.de>
To:     io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-parisc@vger.kernel.org,
        John David Anglin <dave.anglin@bell.net>
Subject: [PATCH v2] io_uring: Adjust mapping wrt architecture aliasing
 requirements
Message-ID: <Y+3kwh8BokobVl6o@p100>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Provags-ID: V03:K1:HuRly+6I2ZVZxgRB37kwF/0rTbMdOwk6HjZWbTNF149OfHHIval
 Mo9d9hOV7pHzUGr7xqtMFR9GsaDJmCpO0jkSlSuBDMet7cPzQYb+P9teF7T5vt01qfZDtW4
 FRZwAmaOlc4KmVRa8trkZE8uJY24QWbHTJMiBlRDIS0AwBxgreR2Z+v84jITd9Wrhz92eNh
 osdDMQ/Na+tYliy32EYKg==
UI-OutboundReport: notjunk:1;M01:P0:053D7Zbs3vc=;bMk1zaqtbqyi0IgUECRK20p6NsX
 Z/8se2PEPQlKVmehP1xDTJunM90D139EQrhgbW7r1EaIwxpeCpcSmbYuGuHAm/EnxZpUayAp7
 qtRkNpg+2a4V9eQsTKysk3B36HrqV9jNm/5MQH+Uk9dDGvLC2+TPrZByACPvDrD8eWK5Uy1lx
 9/XX5Ee1zDHm5FLTO4LHARlBrq8euIw+eoYwcnZrYDRb5ybuNT3zcBCwpcGRHvr6CK8ACwIAd
 Vx59npCR843qFEHsnQHOde/FP0ePx7eoG1pq6sy5lmJKwtzfXNGhkNKrHnoCiv8F8+oo7UZUW
 q+NjxRwYd4hLLr/g8oG06H2SpbdnpXatDxOCQd0AEVOe3wxI0azcopnM75uZDzPEiJxXmeQVz
 vOjg+P9J76ByziDoexIegfeFeY3A71trY5bjkmLH5mEoPvCYz7FNPzKuFKbKwcLQmlfcYIWyE
 TWvaVjG4hf3lxDp2XVqbo21oMNJ9918v0lqDmJVm4onxxySQC9WYa84QJe2bkRuvFC3mfa0cq
 2VfNg3LzkhLDWnYzcpjbQmo6HZymQMvyxvs6F8QUYE6zaJF+bIjNX78BF7OTExy3YMJhj/JWf
 fW0XLExTAjd+wfOXsaPV++rcidQgzZua4/50TbdPJrRCfO5Wipb/9j5rmHDL50eLez7ZDV+Mt
 wUCUqcABYUeKxNg8TfDnl1vSEJpeOnLY6vsUX3YpDjHEGsGUPsmG1Dvnz58jFX1ve338JfGjj
 3+zhKD4koPx+PrYlReqf2NCi+c3CAJeQvx8F4tIO8H1fkHIHWZCesrf94qXMb83SneyqJw1f/
 tpnNS5NJ+9SielPdvyor4VrFU96g92mmWLXa19V89oi3JeFxf/rocitr1rifOIMvqj9md8nOg
 UYiYtyEIP7BP/ElVPkBUcMlYExJnP9iQcjcHObMYbaThiI39A1cW1vODiCPDrZFXoB+j6UtDP
 071xgQ==
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

Some architectures have memory cache aliasing requirements (e.g. parisc)
if memory is shared between userspace and kernel. This patch fixes the
kernel to return an aliased address when asked by userspace via mmap().

Signed-off-by: Helge Deller <deller@gmx.de>
=2D--
v2: Do not allow to map to a user-provided addresss. This forces
programs to write portable code, as usually on x86 mapping to any
address will succeed, while it will fail for most provided address if
used on stricter architectures.

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 862e05e6691d..01fe7437a071 100644
=2D-- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -72,6 +72,7 @@
 #include <linux/io_uring.h>
 #include <linux/audit.h>
 #include <linux/security.h>
+#include <asm/shmparam.h>

 #define CREATE_TRACE_POINTS
 #include <trace/events/io_uring.h>
@@ -3059,6 +3060,54 @@ static __cold int io_uring_mmap(struct file *file, =
struct vm_area_struct *vma)
 	return remap_pfn_range(vma, vma->vm_start, pfn, sz, vma->vm_page_prot);
 }

+static unsigned long io_uring_mmu_get_unmapped_area(struct file *filp,
+			unsigned long addr, unsigned long len,
+			unsigned long pgoff, unsigned long flags)
+{
+	const unsigned long mmap_end =3D arch_get_mmap_end(addr, len, flags);
+	struct vm_unmapped_area_info info;
+	void *ptr;
+
+	/*
+	 * Do not allow to map to user-provided address to avoid breaking the
+	 * aliasing rules. Userspace is not able to guess the offset address of
+	 * kernel kmalloc()ed memory area.
+	 */
+	if (addr)
+		return -EINVAL;
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
+	info.align_mask =3D PAGE_MASK & (SHM_COLOUR - 1UL);
+#else
+	info.align_mask =3D PAGE_MASK & (SHMLBA - 1UL);
+#endif
+	info.align_offset =3D (unsigned long) ptr;
+
+	/*
+	 * A failed mmap() very likely causes application failure,
+	 * so fall back to the bottom-up function here. This scenario
+	 * can happen with large stack limits and large mmap()
+	 * allocations.
+	 */
+	addr =3D vm_unmapped_area(&info);
+	if (offset_in_page(addr)) {
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
@@ -3273,6 +3322,8 @@ static const struct file_operations io_uring_fops =
=3D {
 #ifndef CONFIG_MMU
 	.get_unmapped_area =3D io_uring_nommu_get_unmapped_area,
 	.mmap_capabilities =3D io_uring_nommu_mmap_capabilities,
+#else
+	.get_unmapped_area =3D io_uring_mmu_get_unmapped_area,
 #endif
 	.poll		=3D io_uring_poll,
 #ifdef CONFIG_PROC_FS
