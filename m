Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4E7732D3E3
	for <lists+io-uring@lfdr.de>; Thu,  4 Mar 2021 14:06:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241084AbhCDNG1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 4 Mar 2021 08:06:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241118AbhCDNGO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 4 Mar 2021 08:06:14 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B40D1C061574
        for <io-uring@vger.kernel.org>; Thu,  4 Mar 2021 05:05:34 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id i14so6525917pjz.4
        for <io-uring@vger.kernel.org>; Thu, 04 Mar 2021 05:05:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=JYw+iVdfzI+PGsu/X5b9IHOC61BfgNcaDuhAef+tI2w=;
        b=UDr9B/IRFoxXq1v5CLilgxm7e03g8VxN5+zbAu0tIqPXBEuUvFckXRpredjwc0HYe4
         /pRGc+jEIFhWd/v+Sm1D3fKbCYVOq+NiYaFeRWSLG8ax1v2UCufxW0/DARjgdH9ySUtf
         oE3mm9ITyfKTuPJpzuoXL8fiXZ3DCCeKOciy6fEz7K3bQPSHE4f8VQXde7weBpsijJOf
         c9tPsyynw7mKAQ9RkDQLyc6++sOLFHrHkH1gP+7jFShJbE7CCA8Dk41gNg7XvHoRZ/Wa
         ZhnCaktDUt2NCZDmFSmvhgNpqKUomKJOJVvqSgeMIgQPm/KZLI7Eygk0zaJW/FUJPYZ7
         /gcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JYw+iVdfzI+PGsu/X5b9IHOC61BfgNcaDuhAef+tI2w=;
        b=IOWh06eIdCc8xI5zw1cCTaqn7D4cj0fpHD5QmZcw9Y6FdTYZAQ+WzdOosLs7nzPcMN
         bl2sYpS/we02muPWCjt2GmEdLTicf2gDS46f0vYVqwFtF0aHhm52wsKghGsKQQ8L00de
         JoXsol+K1ged2a63rj0uCccP/SdjzuskgMhqXRLyVfv3ypHuSfIjjL7HA0MDFWGSVvAG
         JgUnqmk3cnh09iCca4cDvMMPvGpEkTuRBjyRRS1b+JqxEoVkbPasr0gUsZINcgIAIcXU
         v9mePZ4UgMf4B5aJT6bCTcj+MdH2BlvFOq96/FD2+h8uukrNYD/5zLgGwaki3lEdpkPQ
         72Aw==
X-Gm-Message-State: AOAM531b/vR/rHbhb46+0Sfm8e/7hrhyzPcrLGx08OwhZQAg0wxCybJY
        OXX8eoIPpRVbV2e9fhisjxpCaA==
X-Google-Smtp-Source: ABdhPJwrFuq8AHM1l+Gyb9PlRE90/kXEedl9pD46prQdNiPHqm0TuVULyryA4yRj4wp82raL9JaXQA==
X-Received: by 2002:a17:90a:7e0a:: with SMTP id i10mr4286623pjl.152.1614863134045;
        Thu, 04 Mar 2021 05:05:34 -0800 (PST)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id z4sm26857219pgv.73.2021.03.04.05.05.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Mar 2021 05:05:33 -0800 (PST)
Subject: Re: [PATCH 09/18] io-wq: fork worker threads from original task
To:     Stefan Metzmacher <metze@samba.org>, io-uring@vger.kernel.org
Cc:     ebiederm@xmission.com, viro@zeniv.linux.org.uk,
        torvalds@linux-foundation.org
References: <20210219171010.281878-1-axboe@kernel.dk>
 <20210219171010.281878-10-axboe@kernel.dk>
 <85bc236d-94af-6878-928b-c69dbdcd46f9@samba.org>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <d9704b9e-ae5e-0795-ba2e-029293f89616@kernel.dk>
Date:   Thu, 4 Mar 2021 06:05:31 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <85bc236d-94af-6878-928b-c69dbdcd46f9@samba.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/4/21 5:23 AM, Stefan Metzmacher wrote:
> 
> Hi Jens,
> 
>> +static pid_t fork_thread(int (*fn)(void *), void *arg)
>> +{
>> +	unsigned long flags = CLONE_FS|CLONE_FILES|CLONE_SIGHAND|CLONE_THREAD|
>> +				CLONE_IO|SIGCHLD;
>> +	struct kernel_clone_args args = {
>> +		.flags		= ((lower_32_bits(flags) | CLONE_VM |
>> +				    CLONE_UNTRACED) & ~CSIGNAL),
>> +		.exit_signal	= (lower_32_bits(flags) & CSIGNAL),
>> +		.stack		= (unsigned long)fn,
>> +		.stack_size	= (unsigned long)arg,
>> +	};
>> +
>> +	return kernel_clone(&args);
>> +}
> 
> Can you please explain why CLONE_SIGHAND is used here?

We can't have CLONE_THREAD without CLONE_SIGHAND... The io-wq workers
don't really care about signals, we don't use them internally.

> Will the userspace signal handlers executed from the kernel thread?

No

> Will SIGCHLD be posted to the userspace signal handlers in a userspace
> process? Will wait() from userspace see the exit of a thread?

Currently actually it does, but I think that's just an oversight. As far
as I can tell, we want to add something like the below. Untested... I'll
give this a spin in a bit.

diff --git a/kernel/signal.c b/kernel/signal.c
index ba4d1ef39a9e..e5db1d8f18e5 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1912,6 +1912,10 @@ bool do_notify_parent(struct task_struct *tsk, int sig)
 	bool autoreap = false;
 	u64 utime, stime;
 
+	/* Don't notify a parent task if an io_uring worker exits */
+	if (tsk->flags & PF_IO_WORKER)
+		return true;
+
 	BUG_ON(sig == -1);
 
  	/* do_notify_parent_cldstop should have been called instead.  */

-- 
Jens Axboe

