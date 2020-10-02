Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5226228172D
	for <lists+io-uring@lfdr.de>; Fri,  2 Oct 2020 17:53:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387965AbgJBPxy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 2 Oct 2020 11:53:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726090AbgJBPxu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 2 Oct 2020 11:53:50 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D3C8C0613D0
        for <io-uring@vger.kernel.org>; Fri,  2 Oct 2020 08:53:49 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id b12so1651486ilh.12
        for <io-uring@vger.kernel.org>; Fri, 02 Oct 2020 08:53:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=FbzYt+1lqJQv+Lx05+RRyPDz9iRfh2zyAaBiUET49Dc=;
        b=BdiF/jQHkXOGJ5tGB7XMAQY3DWt9p2gn//KwbsXishc37at0GxMGsz3BqaHq+6Tb+Z
         lavVukWvQu9yruLKDUNeCt0bCIHftctaFyTEsaW4XvB95yKWABJbP0V8pxt5hL7qeWLl
         YNLp/bHplcCa+IIqog1ljsc82OJEejzY40f4h40IzjYHXq4LYpOniRMPu7NvnSPTCA40
         itljo27NycITPYXMd4G8VMwPXbw2VXgS5Iy1Ow0kTuJZ1P62zxm4faMz/hDxeo49+xan
         9TFFLXKMe0vGQdFEE+pyHucsWA+r7xlT4GFuAYukfv8D/0HfwAUStaX9xVBNDNQ6Luqj
         9+Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FbzYt+1lqJQv+Lx05+RRyPDz9iRfh2zyAaBiUET49Dc=;
        b=nnluawqHw1gTtJFk09AqIwgTrHGuPoxreFoU/Vro+2RvxWzuRU0KsMRDRdfNL1os/s
         KvJcSQEmw+nh0mVN8Efj8dBaQB0RfdSik8pf8fjPahBoia0oYuYbr+ZDLzuTBJR/gQLX
         rvaBgui4Ppi2/+anOjo/xI14YXUaZJflBS85fu2EoBhBThqO+nIElQCyamoAAEKsNPri
         3f12wYJDT+ijW9GUy/pUm9mH8qvytKgfmXngczoF5DRDnuYWrIGeo/l5GxDfUhgOI7D9
         IJlJNUuctuiaZh2QcL5PMBufdSz9f0pJHtJuU/SMrRJ9wex7BWUDgZNnCpgDBZGYL22Z
         Y4Bw==
X-Gm-Message-State: AOAM531XsarTTfWN3ZfqY6QEhN0pT4lZuoB9maAOvsyQNDAV5AzSdpgc
        M60Hwm8DpJk1VA4SONAJikXmng==
X-Google-Smtp-Source: ABdhPJwNMa0GiYKCdyEnbZDrl+NAj5pyHSFmIKe53+DJgSLqdjRwXMzubUGSmi/zc+E0oYxtNBibzg==
X-Received: by 2002:a92:c148:: with SMTP id b8mr1843075ilh.269.1601654028568;
        Fri, 02 Oct 2020 08:53:48 -0700 (PDT)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id y28sm962240ilk.13.2020.10.02.08.53.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Oct 2020 08:53:47 -0700 (PDT)
Subject: Re: [PATCH 3/3] task_work: use TIF_TASKWORK if available
To:     Oleg Nesterov <oleg@redhat.com>
Cc:     linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de
References: <20201001194208.1153522-1-axboe@kernel.dk>
 <20201001194208.1153522-4-axboe@kernel.dk>
 <20201002151415.GA29066@redhat.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <fb15a44f-3fdf-2f12-ee85-f229bd261419@kernel.dk>
Date:   Fri, 2 Oct 2020 09:53:47 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201002151415.GA29066@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/2/20 9:14 AM, Oleg Nesterov wrote:
> Heh. To be honest I don't really like 1-2 ;)
> 
> Unfortunately, I do not see a better approach right now. Let me think
> until Monday, it is not that I think I will find a better solution, but
> I'd like to try anyway.
> 
> Let me comment 3/3 for now.

Thanks, appreciate your time on this!

>> +static void task_work_signal(struct task_struct *task)
>> +{
>> +#ifndef TIF_TASKWORK
>> +	unsigned long flags;
>> +
>> +	/*
>> +	 * Only grab the sighand lock if we don't already have some
>> +	 * task_work pending. This pairs with the smp_store_mb()
>> +	 * in get_signal(), see comment there.
>> +	 */
>> +	if (!(READ_ONCE(task->jobctl) & JOBCTL_TASK_WORK) &&
>> +	    lock_task_sighand(task, &flags)) {
>> +		task->jobctl |= JOBCTL_TASK_WORK;
>> +		signal_wake_up(task, 0);
>> +		unlock_task_sighand(task, &flags);
>> +	}
>> +#else
>> +	set_tsk_thread_flag(task, TIF_TASKWORK);
>> +	set_notify_resume(task);
>> +#endif
> 
> Again, I can't understand. task_work_signal(task) should set TIF_TASKWORK
> to make signal_pending() = T _and_ wake/kick the target up, just like
> signal_wake_up() does. Why do we set TIF_NOTIFY_RESUME ?
> 
> So I think that if we are going to add TIF_TASKWORK we should generalize
> this logic and turn it into TIF_NOTIFY_SIGNAL. Similar to TIF_NOTIFY_RESUME
> but implies signal_pending().
> 
> IOW, something like
> 
> 	void set_notify_signal(task)
> 	{
> 		if (!test_and_set_tsk_thread_flag(task, TIF_NOTIFY_SIGNAL)) {
> 			if (!wake_up_state(task, TASK_INTERRUPTIBLE))
> 				kick_process(t);
> 		}
> 	}
> 
> 	// called by exit_to_user_mode_loop() if ti_work & _TIF_NOTIFY_SIGNAL
> 	void tracehook_notify_signal(regs)
> 	{
> 		clear_thread_flag(TIF_NOTIFY_SIGNAL);
> 		smp_mb__after_atomic();
> 		if (unlikely(current->task_works))
> 			task_work_run();
> 	}
> 
> This way task_work_run() doesn't need to clear TIF_NOTIFY_SIGNAL and it can
> have more users.
> 
> What do you think?

I like that. It'll achieve the same thing as far as I'm concerned, but not
tie the functionality to task_work. Not that we have anything that'd use
it right now, but it still seems like a better base.

I'll adapt patch 2+3 for this, thanks Oleg.

-- 
Jens Axboe

