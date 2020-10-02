Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23E32281729
	for <lists+io-uring@lfdr.de>; Fri,  2 Oct 2020 17:52:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388028AbgJBPwa (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 2 Oct 2020 11:52:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726090AbgJBPw1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 2 Oct 2020 11:52:27 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB7DFC0613E2
        for <io-uring@vger.kernel.org>; Fri,  2 Oct 2020 08:52:25 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id v8so2035529iom.6
        for <io-uring@vger.kernel.org>; Fri, 02 Oct 2020 08:52:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ShMcDvXeEkCRoyhlDuy9K5fYLcZiHQgXh+0uj+Ohgxg=;
        b=xo6idNonJ34cYdZi7p0oAgxL/XqyAmr+dTYsxxvTIa9nraeuTbEQgGKJUwxRTkDl2G
         kwNKaKoNhk32fPhft8AXdx+huCB7jN9bGxKL2K3fOQb5S3eV7UBgfPgfR9x+MxEALe8t
         qeI9OfSf6EXLESTsF8oy2rG5j/t8IX1DohXieOo898zvNAbC1i9UyYMzqFFT7Kuca1th
         InW18uWhZx8LS6ps3u65Q95nN3nsiPs40JqgWJ2oMxxDFEjw30lbuTiotNn/IISicpFJ
         BGggnunjxKlKkswxFZDaZtf720oHEoHdIMxriAzeaVA8hisID9A0mCCKX9CA3hLYEzyK
         lllw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ShMcDvXeEkCRoyhlDuy9K5fYLcZiHQgXh+0uj+Ohgxg=;
        b=mD4+qR46sV6+NzoqtcdcEFW5gZIkSRn6Zo5Z05Uqpo6+tWU67itRzOCPX3AMVQyxD7
         JIhwOZLXVRxwv4PFzon5EScu2njtSiOTZwX5fLqiLAwu2mgIOg0mTWc/tHa+93ddO7OR
         WUaSoBwW5abygkNkbKDA14JzoAt5YsYmPAK/LhK4KscZN08zT4+xhkKTydo+U/rLAHGl
         pRTZX2k71AGZi5C+lKKomj4X6K+IxegoBAuibDzma/3QbalT4DngfpcFYe5xZZztYZyv
         1vChUQm5+5LeiiLKGJ5woOb/IVf0U7LkO8yS+5JjD1JmeEzkJE11+ZsRyM7LldfQlxQ7
         O2uQ==
X-Gm-Message-State: AOAM530nTXdhUWx3EKJcAgo1ylX3QnVKtymQ3Zfa4Y6tvFKYJtQmM94S
        Ukt5HeKJCOzc1ZIX2DsN1NIwjA==
X-Google-Smtp-Source: ABdhPJzsABw7VR67E0uItDylj6BzqZIfExHx8JTfR+CTEnrrwolhL379Ma+d8qAziBAeU+6jG8LeUg==
X-Received: by 2002:a02:8805:: with SMTP id r5mr2972176jai.52.1601653945179;
        Fri, 02 Oct 2020 08:52:25 -0700 (PDT)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id w13sm876380iox.10.2020.10.02.08.52.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Oct 2020 08:52:24 -0700 (PDT)
Subject: Re: [PATCH 3/3] task_work: use TIF_TASKWORK if available
To:     Thomas Gleixner <tglx@linutronix.de>,
        Oleg Nesterov <oleg@redhat.com>
Cc:     linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
        peterz@infradead.org
References: <20201001194208.1153522-1-axboe@kernel.dk>
 <20201001194208.1153522-4-axboe@kernel.dk>
 <20201002151415.GA29066@redhat.com> <871rigejb8.fsf@nanos.tec.linutronix.de>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <4c9dbcc4-cae7-c7ad-8066-31d49239750a@kernel.dk>
Date:   Fri, 2 Oct 2020 09:52:24 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <871rigejb8.fsf@nanos.tec.linutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/2/20 9:31 AM, Thomas Gleixner wrote:
> On Fri, Oct 02 2020 at 17:14, Oleg Nesterov wrote:
>> Heh. To be honest I don't really like 1-2 ;)
> 
> I do not like any of this :)
> 
>> So I think that if we are going to add TIF_TASKWORK we should generalize
>> this logic and turn it into TIF_NOTIFY_SIGNAL. Similar to TIF_NOTIFY_RESUME
>> but implies signal_pending().
>>
>> IOW, something like
>>
>> 	void set_notify_signal(task)
>> 	{
>> 		if (!test_and_set_tsk_thread_flag(task, TIF_NOTIFY_SIGNAL)) {
>> 			if (!wake_up_state(task, TASK_INTERRUPTIBLE))
>> 				kick_process(t);
>> 		}
>> 	}
>>
>> 	// called by exit_to_user_mode_loop() if ti_work & _TIF_NOTIFY_SIGNAL
>> 	void tracehook_notify_signal(regs)
>> 	{
>> 		clear_thread_flag(TIF_NOTIFY_SIGNAL);
>> 		smp_mb__after_atomic();
>> 		if (unlikely(current->task_works))
>> 			task_work_run();
>> 	}
>>
>> This way task_work_run() doesn't need to clear TIF_NOTIFY_SIGNAL and it can
>> have more users.
> 
> I think it's fundamentaly wrong that we have several places and several
> flags which handle task_work_run() instead of having exactly one place
> and one flag.

I don't disagree with that. I know it's not happening in this series, but
if we to the TIF_NOTIFY_SIGNAL route and get all archs supporting that,
then we can kill the signal and notify resume part of running task_work.
And that leaves us with exactly one place that runs it.

So we can potentially improve the current situation in that regard.

-- 
Jens Axboe

