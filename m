Return-Path: <io-uring+bounces-7672-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C8E6A994E9
	for <lists+io-uring@lfdr.de>; Wed, 23 Apr 2025 18:25:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3FA345A7F3F
	for <lists+io-uring@lfdr.de>; Wed, 23 Apr 2025 16:15:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF5A927F751;
	Wed, 23 Apr 2025 16:15:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JVQxBQt5"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A4771386DA;
	Wed, 23 Apr 2025 16:15:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745424955; cv=none; b=tUvvmeFgz08ljgJdQIeIgHBH8ppUTYy9Ew99QYdyAGjOAKkAb9DSFvM58DeBWF+vbX+slqblKXBUJiRw0FBFJmSIjHX81reABuKafQv3sgamQdESJoqvlWZeY632QtOiwkbATYl1pWgXiKdLVpNXPreK+o1O3dT4J5ccQJWH8zU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745424955; c=relaxed/simple;
	bh=3O54AdMXyFJUsCTNzkxNemYyExj2+PNhpJrfpMB69CU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tnBstX2zKwy0CL4ywolUy5+H0M3k+7osu3aEopVItt0Nam51pI4xbL28x5lxKqsDCV1/EN7XsGrqdgcrJUkjtHkH7noGenvcOqTcXylJi9XYBXrRrMI3byn+cYdMWU3iGuz3dRCgypG3RhEESCoXIdF29liI9JUjycxxKhC6Lbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JVQxBQt5; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-aaecf50578eso6082666b.2;
        Wed, 23 Apr 2025 09:15:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745424952; x=1746029752; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hkXQF6L07fq9JaRv1rocvcWtopuXJMouDQ2Qzy0VLAM=;
        b=JVQxBQt5JjTXuV5LDHNNRfpU5JR0NLcNkAA4wXmRR8NYYmYzMD5YtYkBkdfE/DfjWH
         b6LF09HULH5adh442KvMBpF5EUZguITuAGTsX6R4tG0o8TZ8LGM4H70A/Mv0sPBnDv50
         UlGai9gO/snm+SQ0D24PQ3XRqomNvXRHpkWgjlLIHZqx0vmSy7ka7/f8CnNJXdnEqgjd
         4bojNEZfj8+vq7WtMUc4BVnimKB4Nde7uxh0EPbDgtFMdQKWISyyhP/PdBdG5XeqNhIN
         OZxSpyHqHI61ftUI+awNhdAte40o1BqB03lZEMRte/vOrkulHFA/R5X6BoW3knk3eTU9
         xg+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745424952; x=1746029752;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hkXQF6L07fq9JaRv1rocvcWtopuXJMouDQ2Qzy0VLAM=;
        b=Tt9fI2Pjm0nlK5a2MrDoiJt17zTDqebyc0GwRAKFUXY02fm/fpn3jX9jqFESfs8EnX
         iaxEHOGCR1EBc9YrM+SiZsxQS2tBOYuQScGjnDX6U8eBLiNE5u92XH8o25B8RoE6HSyx
         hNO/7i9oOXewWOQcFsLklTypNv64/1uY2sIEcEf5pss13HluLNEnpamUd6LOm70oBRoU
         e2CBjZC06gvqhhYC9P2VIOfL+HNaDmURwPH88pERVJF3cNLkvoOXPKHusKfXJbZKTloq
         2IBavmAlZyCD4P6A+rckz25QbOIDQl8SI++o/PF0flxbq9a9nCsE38YmHEEw0WMlDlOh
         a/lQ==
X-Forwarded-Encrypted: i=1; AJvYcCU9Y6tbq6QTNrkgrTCAzAzqUTqjpp7FluDD41fvX4U8nubLz8ylbg+BHuVcl1M+FylwD10cXYAUfw==@vger.kernel.org, AJvYcCUNell9BidibWnfPWTGSFyhXYoOllXgqm4XuKced0Z0O7KD6uqf/4ycCoScHh45x64bRqHZD1xTdmhYiukU@vger.kernel.org, AJvYcCUZBXLFBE4rR3hoYLMN5IvWxZ4ICCnbfgWK20xJaBZY9WSNl3oZWCfI+6UID+WYD4+hucMz0Ee9c4BN1LwWZA==@vger.kernel.org
X-Gm-Message-State: AOJu0YxSZtbdotnQ+br9O/gOhjDlZU/oTcMzYounh38GbghiWpwkLzy8
	THJtbujlyPavoCanGjOcp7K3fGD5low8SdYX2D1gmJZ8Yo5FawMt
X-Gm-Gg: ASbGncvOnnhcv7CdbAdv2gHGhb1Le4/wA1WDN30BC4N1GaPgeI1xHCSc8JIOJEX4RBu
	f5Psfh8CKnkblFB7K49ohvGCr6w84MuIe/OZYWy3p8mneSJI5GSdlgNEjAJC+6z7FlazhzID9W9
	XpK799H8krVg87BI1kClEkonIlEz8SzqUH9Fy2JFozeY1XQfkdnU4dQUmWOqt0s4wdQUXPtWJiF
	dWzR37CEdxH5KBXG/NDhnYiZdYAkd8lYDZjRKvtcj4y5Mxzxc9+5nBbBvbfqlMLAdr5E6d7zCbs
	E4POpmXESBJROa1WMVNQBtJ+7Q+NYZZobJ1zUQ6SxYwHhZQ8yRk=
X-Google-Smtp-Source: AGHT+IGfjA59Ii1TRUVdhru/QpbvQvwRewAB73t3x7AzZ7MY4Efy5K3RpjCp5vGmws3XKlb0bIOUGw==
X-Received: by 2002:a17:906:abd3:b0:acb:b1be:4873 with SMTP id a640c23a62f3a-acbb1be490fmr773691766b.2.1745424952134;
        Wed, 23 Apr 2025 09:15:52 -0700 (PDT)
Received: from [192.168.8.100] ([148.252.133.217])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-acb6ec92a36sm811629366b.81.2025.04.23.09.15.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Apr 2025 09:15:51 -0700 (PDT)
Message-ID: <00c7d434-d923-4b91-8ad0-5f3c8e0c6465@gmail.com>
Date: Wed, 23 Apr 2025 17:17:05 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] io_uring: Add new functions to handle user fault
 scenarios
To: Jens Axboe <axboe@kernel.dk>, =?UTF-8?B?5aec5pm65Lyf?=
 <qq282012236@gmail.com>
Cc: viro@zeniv.linux.org.uk, brauner@kernel.org, jack@suse.cz,
 akpm@linux-foundation.org, peterx@redhat.com, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
References: <20250422162913.1242057-1-qq282012236@gmail.com>
 <20250422162913.1242057-2-qq282012236@gmail.com>
 <14195206-47b1-4483-996d-3315aa7c33aa@kernel.dk>
 <CANHzP_uW4+-M1yTg-GPdPzYWAmvqP5vh6+s1uBhrMZ3eBusLug@mail.gmail.com>
 <b61ac651-fafe-449a-82ed-7239123844e1@kernel.dk>
 <CANHzP_tLV29_uk2gcRAjT9sJNVPH3rMyVuQP07q+c_TWWgsfDg@mail.gmail.com>
 <7bea9c74-7551-4312-bece-86c4ad5c982f@kernel.dk>
 <52d55891-36e3-43e7-9726-a2cd113f5327@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <52d55891-36e3-43e7-9726-a2cd113f5327@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/23/25 16:55, Jens Axboe wrote:
> Something like this, perhaps - it'll ensure that io-wq workers get a
> chance to flush out pending work, which should prevent the looping. I've
> attached a basic test case. It'll issue a write that will fault, and
> then try and cancel that as a way to trigger the TIF_NOTIFY_SIGNAL based
> looping.
> 
> diff --git a/fs/userfaultfd.c b/fs/userfaultfd.c
> index d80f94346199..e18926dbf20a 100644
> --- a/fs/userfaultfd.c
> +++ b/fs/userfaultfd.c
> @@ -32,6 +32,7 @@
>   #include <linux/swapops.h>
>   #include <linux/miscdevice.h>
>   #include <linux/uio.h>
> +#include <linux/io_uring.h>
>   
>   static int sysctl_unprivileged_userfaultfd __read_mostly;
>   
> @@ -376,6 +377,8 @@ vm_fault_t handle_userfault(struct vm_fault *vmf, unsigned long reason)
>   	 */
>   	if (current->flags & (PF_EXITING|PF_DUMPCORE))
>   		goto out;
> +	else if (current->flags & PF_IO_WORKER)
> +		io_worker_fault();
>   
>   	assert_fault_locked(vmf);
>   
> diff --git a/include/linux/io_uring.h b/include/linux/io_uring.h
> index 85fe4e6b275c..d93dd7402a28 100644
> --- a/include/linux/io_uring.h
> +++ b/include/linux/io_uring.h
> @@ -28,6 +28,7 @@ static inline void io_uring_free(struct task_struct *tsk)
>   	if (tsk->io_uring)
>   		__io_uring_free(tsk);
>   }
> +void io_worker_fault(void);
>   #else
>   static inline void io_uring_task_cancel(void)
>   {
> @@ -46,6 +47,9 @@ static inline bool io_is_uring_fops(struct file *file)
>   {
>   	return false;
>   }
> +static inline void io_worker_fault(void)
> +{
> +}
>   #endif
>   
>   #endif
> diff --git a/io_uring/io-wq.c b/io_uring/io-wq.c
> index d52069b1177b..f74bea028ec7 100644
> --- a/io_uring/io-wq.c
> +++ b/io_uring/io-wq.c
> @@ -1438,3 +1438,13 @@ static __init int io_wq_init(void)
>   	return 0;
>   }
>   subsys_initcall(io_wq_init);
> +
> +void io_worker_fault(void)
> +{
> +	if (test_thread_flag(TIF_NOTIFY_SIGNAL))
> +		clear_notify_signal();
> +	if (test_thread_flag(TIF_NOTIFY_RESUME))
> +		resume_user_mode_work(NULL);
> +	if (task_work_pending(current))
> +		task_work_run();

Looking at the stacktrace, that sounds dangerous

iou-wrk-44588  [kernel.kallsyms]  [k] io_wq_worker
iou-wrk-44588  [kernel.kallsyms]  [k] io_worker_handle_work
iou-wrk-44588  [kernel.kallsyms]  [k] io_wq_submit_work
iou-wrk-44588  [kernel.kallsyms]  [k] io_issue_sqe
iou-wrk-44588  [kernel.kallsyms]  [k] io_write
iou-wrk-44588  [kernel.kallsyms]  [k] blkdev_write_iter
iou-wrk-44588  [kernel.kallsyms]  [k] iomap_file_buffered_write
iou-wrk-44588  [kernel.kallsyms]  [k] iomap_write_iter
iou-wrk-44588  [kernel.kallsyms]  [k] fault_in_iov_iter_readable
iou-wrk-44588  [kernel.kallsyms]  [k] fault_in_readable
iou-wrk-44588  [kernel.kallsyms]  [k] asm_exc_page_fault
iou-wrk-44588  [kernel.kallsyms]  [k] exc_page_fault
iou-wrk-44588  [kernel.kallsyms]  [k] do_user_addr_fault
iou-wrk-44588  [kernel.kallsyms]  [k] handle_mm_fault
iou-wrk-44588  [kernel.kallsyms]  [k] hugetlb_fault
iou-wrk-44588  [kernel.kallsyms]  [k] hugetlb_no_page
iou-wrk-44588  [kernel.kallsyms]  [k] hugetlb_handle_userfault
iou-wrk-44588  [kernel.kallsyms]  [k] handle_userfault

It might be holding a good bunch of locks, and then it's trapped
in a page fault handler. Do normal / non-PF_IO_WORKER tasks run
task_work from handle_userfault?

-- 
Pavel Begunkov


