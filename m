Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06AC6697F4C
	for <lists+io-uring@lfdr.de>; Wed, 15 Feb 2023 16:16:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230121AbjBOPQ1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Feb 2023 10:16:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229907AbjBOPQ0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Feb 2023 10:16:26 -0500
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13A3F392BB
        for <io-uring@vger.kernel.org>; Wed, 15 Feb 2023 07:16:03 -0800 (PST)
Received: by mail-io1-xd2a.google.com with SMTP id z5so4488327iow.1
        for <io-uring@vger.kernel.org>; Wed, 15 Feb 2023 07:16:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1676474162;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=a+kkzf0UWHNPl+5naiodtaW1TD7S43liDP2k5jIkWrk=;
        b=0whkR+ubiX4T5Logt95QBOfye98nq/f0PuZYAkVfJWTR4vt2FPZdOVWA3imbnC6Byz
         Gsf5+ydoxU82uPI/xNvaFnxLlrK1NhJQtuM9RPKqB2SMDqBhepH0PpDe2Q6MlW12d+TY
         klZj/8fCxteQAcsICVmSBLVNjf8FKpD2+51mOvWDgwmEb5wAVjE8J9t320tQw7csWu8b
         idJBttcnOX8B+fTsKIet+nNARi+19BnBMPev3QKl+ltQSMY5m0gTmmeWllRlu1WX1MnN
         LKoVbpj3o1x8rm33sCKu/1Cg5WjYQ1+9khHw8/mVN+ybUL5hM6S9SxDhz7pL6R+fWjyk
         842g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1676474162;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=a+kkzf0UWHNPl+5naiodtaW1TD7S43liDP2k5jIkWrk=;
        b=aJBZXqG5RYwDcGQY46GMnTzpHIzcIF+mf1ShMOtgFI1ygFxx5Jj/FTRycIVZ8HcJbC
         MoGqRk3KAtJLpFzOYbFCajXDaZU6ldP1tce7D5KflxRO2gfY7oQ3M8EI2fgZIRQVrD3A
         PT4jJVBTyjLgIVNQdp0ki1NE6dkGZYWzcPgtX9VuCpxDMEMMfQCozurquO0JQLKW3nrl
         +JmMGIuuq3IP2sMQxfCG2+cxmGGAe1fPj3rGW/5nCtZ4752tzUzTRkYR2+DUAD0vVRB/
         /9I3519KDrY2vkSMGNB4tqveL8+ezdvx23vMX3GNt5ZMZ+bY7Btr/YyqMScV/WMlwb1/
         NC6g==
X-Gm-Message-State: AO0yUKWrC2OfEMfqxg3CfOkavD03tDMupqbbc+5qbpsQ06j8kQfnrcVL
        hSm4BJFOZuzPgJQYr7VQwkwNxbV/nIug9sBv
X-Google-Smtp-Source: AK7set8TQPQxK38MX+KZm1NcpNZlSvqYA18slrj0+3c+PzO1IqkapAsMyaA3P+FcMos1Ss4NNt83kQ==
X-Received: by 2002:a05:6602:17ce:b0:73a:397b:e311 with SMTP id z14-20020a05660217ce00b0073a397be311mr1896247iox.0.1676474162295;
        Wed, 15 Feb 2023 07:16:02 -0800 (PST)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id l9-20020a02cce9000000b003c4860eb853sm5975547jaq.109.2023.02.15.07.16.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Feb 2023 07:16:01 -0800 (PST)
Message-ID: <5f02fa8b-7fd8-d98f-4876-f1a89024b888@kernel.dk>
Date:   Wed, 15 Feb 2023 08:16:00 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.2
Subject: Re: io_uring failure on parisc with VIPT caches
Content-Language: en-US
To:     John David Anglin <dave.anglin@bell.net>,
        Helge Deller <deller@gmx.de>, io-uring@vger.kernel.org,
        linux-parisc@vger.kernel.org,
        James Bottomley <James.Bottomley@hansenpartnership.com>
References: <Y+wUwVxeN87gqN6o@p100>
 <006e8db4-336f-6717-ecb0-d01a0e9bc483@kernel.dk>
 <626cee6f-f542-b7eb-16ca-1cf4e3808ca6@bell.net>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <626cee6f-f542-b7eb-16ca-1cf4e3808ca6@bell.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/14/23 7:12?PM, John David Anglin wrote:
> On 2023-02-14 6:29 p.m., Jens Axboe wrote:
>> On 2/14/23 4:09?PM, Helge Deller wrote:
>>> * John David Anglin<dave.anglin@bell.net>:
>>>> On 2023-02-13 5:05 p.m., Helge Deller wrote:
>>>>> On 2/13/23 22:05, Jens Axboe wrote:
>>>>>> On 2/13/23 1:59?PM, Helge Deller wrote:
>>>>>>>> Yep sounds like it. What's the caching architecture of parisc?
>>>>>>> parisc is Virtually Indexed, Physically Tagged (VIPT).
>>>>>> That's what I assumed, so virtual aliasing is what we're dealing with
>>>>>> here.
>>>>>>
>>>>>>> Thanks for the patch!
>>>>>>> Sadly it doesn't fix the problem, as the kernel still sees
>>>>>>> ctx->rings->sq.tail as being 0.
>>>>>>> Interestingly it worked once (not reproduceable) directly after bootup,
>>>>>>> which indicates that we at least look at the right address from kernel side.
>>>>>>>
>>>>>>> So, still needs more debugging/testing.
>>>>>> It's not like this is untested stuff, so yeah it'll generally be
>>>>>> correct, it just seems that parisc is a bit odd in that the virtual
>>>>>> aliasing occurs between the kernel and userspace addresses too. At least
>>>>>> that's what it seems like.
>>>>> True.
>>>>>
>>>>>> But I wonder if what needs flushing is the user side, not the kernel
>>>>>> side? Either that, or my patch is not flushing the right thing on the
>>>>>> kernel side.
>>> The patch below seems to fix the issue.
>>>
>>> I've successfuly tested it with the io_uring-test testcase on
>>> physical parisc machines with 32- and 64-bit 6.1.11 kernels.
>>>
>>> The idea is similiar on how a file is mmapped shared by two
>>> userspace processes by keeping the lower bits of the virtual address
>>> the same.
>>>
>>> Cache flushes from userspace don't seem to be needed.
>> Are they from the kernel side, if the lower bits mean we end up
>> with the same coloring? Because I think this is a bit of a big
>> hammer, in terms of overhead for flushing. As an example, on arm64
>> that is perfectly fine with the existing code, it's about a 20-25%
>> performance hit.
>
> The io_uring-test testcase still works on rp3440 with the kernel
> flushes removed.

That's what I suspected, the important bit here is just aligning it for
identical coloring. Can you confirm if the below works for you? Had to
fiddle it a bit to get it to work without coloring.


diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index db623b3185c8..1d4562067949 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -72,6 +72,7 @@
 #include <linux/io_uring.h>
 #include <linux/audit.h>
 #include <linux/security.h>
+#include <asm/shmparam.h>
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/io_uring.h>
@@ -3200,6 +3201,51 @@ static __cold int io_uring_mmap(struct file *file, struct vm_area_struct *vma)
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
+	ptr = io_uring_validate_mmap_request(filp, pgoff, len);
+	if (IS_ERR(ptr))
+		return -ENOMEM;
+
+	/* we do not support requesting a specific address */
+	if (addr)
+		return -EINVAL;
+
+	info.flags = VM_UNMAPPED_AREA_TOPDOWN;
+	info.length = len;
+	info.low_limit = max(PAGE_SIZE, mmap_min_addr);
+	info.high_limit = arch_get_mmap_base(addr, current->mm->mmap_base);
+	info.align_mask = PAGE_MASK;
+	info.align_offset = (unsigned long) ptr;
+#ifdef SHM_COLOUR
+	info.align_mask &= (SHM_COLOUR - 1);
+	info.align_offset &= (SHM_COLOUR - 1)
+#endif
+
+	/*
+	 * A failed mmap() very likely causes application failure,
+	 * so fall back to the bottom-up function here. This scenario
+	 * can happen with large stack limits and large mmap()
+	 * allocations.
+	 */
+	addr = vm_unmapped_area(&info);
+	if (offset_in_page(addr)) {
+		VM_BUG_ON(addr != -ENOMEM);
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
@@ -3414,6 +3460,8 @@ static const struct file_operations io_uring_fops = {
 #ifndef CONFIG_MMU
 	.get_unmapped_area = io_uring_nommu_get_unmapped_area,
 	.mmap_capabilities = io_uring_nommu_mmap_capabilities,
+#else
+	.get_unmapped_area = io_uring_mmu_get_unmapped_area,
 #endif
 	.poll		= io_uring_poll,
 #ifdef CONFIG_PROC_FS

-- 
Jens Axboe

