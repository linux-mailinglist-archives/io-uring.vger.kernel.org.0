Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 730D86B9CD4
	for <lists+io-uring@lfdr.de>; Tue, 14 Mar 2023 18:17:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230146AbjCNRR0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Mar 2023 13:17:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229656AbjCNRRY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 14 Mar 2023 13:17:24 -0400
Received: from mail-il1-x133.google.com (mail-il1-x133.google.com [IPv6:2607:f8b0:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34EEFACE03
        for <io-uring@vger.kernel.org>; Tue, 14 Mar 2023 10:17:06 -0700 (PDT)
Received: by mail-il1-x133.google.com with SMTP id l9so5889305iln.1
        for <io-uring@vger.kernel.org>; Tue, 14 Mar 2023 10:17:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1678814225; x=1681406225;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+qwZGpQsRUQQpglMl71LgfSE4H69vr4wHZy+TpuOCFA=;
        b=zMaJk3+DVZns+NBGtgLoeWmXuDSTZwD7h7bSfRbfvjy0OIW8YX27cniVkEuGmNX9Ge
         lHSsOvANhWi9aAmstcgOz/KpproTMSijIWmhVLr12Huf0dmSC0XRP2c6qLt27+VtNIZU
         kx2tbfINOHIpFBuKGUkP7JDDQpDIjMcS1c5LJAvCp5BwpQtf8TtvwG2AFUQPbe+CVK2D
         3Vh4zkSKEN9PVOaRwykt2Rl0RdNhu8gyXoYI7cSPY4qgzRcpT1wMuJhg4ZdrSEjVMipQ
         LDbePcMfNRpk7Z4NTuw54URTsfR2A4QyX7WuxLSV3RcLan9XuDO4yF23tmyZwvgiCF/J
         33EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678814225; x=1681406225;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+qwZGpQsRUQQpglMl71LgfSE4H69vr4wHZy+TpuOCFA=;
        b=Qw/NDUuh6tf44r026YuuGgntc9LQn6QB52zIpn2pd2OaFDddpZsVwFRa9Bf5L3y5kQ
         B+PNNHa6VirRcG8ruTCcmDqcXwj9IL58DGwJdrOEzZRraWF1DSxtJNrHGw9PD2Xb7Dvq
         1lBpyx8CJW0y4MqcgDkceXr8e8HOaQxKEQqmF6OzoYFEhlkIfl2TgnMIVf8jwBB3vyes
         6RGz8hM+l9l8En80k6Laa4vAXO4UlJY1TKR81+5GDiHRI4t37Y2wxh4edRCvNvVhJGHl
         sVApTaZMEP/Smvdo58K40D0VtlHyJ4vy+amcAU3IvymKLukDMBw2vWUbhh2qEE1HBF/Q
         1mqw==
X-Gm-Message-State: AO0yUKUJ1/hW1/wJSq5Itpuup+g1u0PIZqesHu8G0GNDQ5dYygcp6Txv
        cSftgap7Rl/TYkTXb9MiFKHuAg4mkqWTafuTjCEcdA==
X-Google-Smtp-Source: AK7set/YiwOJLppmyM/dwU1LYGWLO9YymDJCWqgxEWlTJwBACHPtOYawGfDaPDyhinUfAfT3FbfZbw==
X-Received: by 2002:a92:d64c:0:b0:319:5431:5d5b with SMTP id x12-20020a92d64c000000b0031954315d5bmr8598080ilp.1.1678814225074;
        Tue, 14 Mar 2023 10:17:05 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id o12-20020a056e02068c00b003179b81610csm948950ils.17.2023.03.14.10.17.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Mar 2023 10:17:04 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     deller@gmx.de, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/5] io_uring: Adjust mapping wrt architecture aliasing requirements
Date:   Tue, 14 Mar 2023 11:16:38 -0600
Message-Id: <20230314171641.10542-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230314171641.10542-1-axboe@kernel.dk>
References: <20230314171641.10542-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Helge Deller <deller@gmx.de>

Some architectures have memory cache aliasing requirements (e.g. parisc)
if memory is shared between userspace and kernel. This patch fixes the
kernel to return an aliased address when asked by userspace via mmap().

Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/io_uring.c | 51 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 51 insertions(+)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 722624b6d0dc..3adecebbac71 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -72,6 +72,7 @@
 #include <linux/io_uring.h>
 #include <linux/audit.h>
 #include <linux/security.h>
+#include <asm/shmparam.h>
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/io_uring.h>
@@ -3317,6 +3318,54 @@ static __cold int io_uring_mmap(struct file *file, struct vm_area_struct *vma)
 	return remap_pfn_range(vma, vma->vm_start, pfn, sz, vma->vm_page_prot);
 }
 
+static unsigned long io_uring_mmu_get_unmapped_area(struct file *filp,
+			unsigned long addr, unsigned long len,
+			unsigned long pgoff, unsigned long flags)
+{
+	const unsigned long mmap_end = arch_get_mmap_end(addr, len, flags);
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
+	ptr = io_uring_validate_mmap_request(filp, pgoff, len);
+	if (IS_ERR(ptr))
+		return -ENOMEM;
+
+	info.flags = VM_UNMAPPED_AREA_TOPDOWN;
+	info.length = len;
+	info.low_limit = max(PAGE_SIZE, mmap_min_addr);
+	info.high_limit = arch_get_mmap_base(addr, current->mm->mmap_base);
+#ifdef SHM_COLOUR
+	info.align_mask = PAGE_MASK & (SHM_COLOUR - 1UL);
+#else
+	info.align_mask = PAGE_MASK & (SHMLBA - 1UL);
+#endif
+	info.align_offset = (unsigned long) ptr;
+
+	/*
+	 * A failed mmap() very likely causes application failure,
+	 * so fall back to the bottom-up function here. This scenario
+	 * can happen with large stack limits and large mmap()
+	 * allocations.
+	 */
+	addr = vm_unmapped_area(&info);
+	if (offset_in_page(addr)) {
+		info.flags = 0;
+		info.low_limit = TASK_UNMAPPED_BASE;
+		info.high_limit = mmap_end;
+		addr = vm_unmapped_area(&info);
+	}
+
+	return addr;
+}
+
 #else /* !CONFIG_MMU */
 
 static int io_uring_mmap(struct file *file, struct vm_area_struct *vma)
@@ -3529,6 +3578,8 @@ static const struct file_operations io_uring_fops = {
 #ifndef CONFIG_MMU
 	.get_unmapped_area = io_uring_nommu_get_unmapped_area,
 	.mmap_capabilities = io_uring_nommu_mmap_capabilities,
+#else
+	.get_unmapped_area = io_uring_mmu_get_unmapped_area,
 #endif
 	.poll		= io_uring_poll,
 #ifdef CONFIG_PROC_FS
-- 
2.39.2

