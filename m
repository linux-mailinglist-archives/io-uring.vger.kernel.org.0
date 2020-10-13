Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB4C728DCB8
	for <lists+io-uring@lfdr.de>; Wed, 14 Oct 2020 11:20:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729767AbgJNJTo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 14 Oct 2020 05:19:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730487AbgJNJTl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 14 Oct 2020 05:19:41 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CE59C08EC6B
        for <io-uring@vger.kernel.org>; Tue, 13 Oct 2020 16:55:09 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id b26so861079pff.3
        for <io-uring@vger.kernel.org>; Tue, 13 Oct 2020 16:55:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Uyn4u4zPT8lCRqg3mtYpVMsvS3nHHp0bUhsCfjjwdnM=;
        b=uOqY26raeWXXsabUh4iq3GWqbPhntX2jAw7WlXzsOsk1n27PMJ5XJutG5KRN8kpgh4
         uBXOZZgEQzOYxWRyhfzSTpfaqf2ehc07tSXXDCwOwm96YrAYmLN5jIyodmnumluJGMPw
         ek0W14+MO48kiv4kacCmEdZyiVkwTKY2Z5tfvNfB4vumTwwF6wXMC320mXF849uRgiQm
         mjEnrvex9U+gb1Qw1gXtnpBVRVX8qdDIU+R7VfWqv6kmfmuH50332RTpwCQNFc3EWxc2
         /qsyslm6ElprPvEqQ1zYX9pWXh3KSNdu6mR4xkFE3fNBWHa/1oI6TqeMrovc6CqYZ3Db
         OmRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Uyn4u4zPT8lCRqg3mtYpVMsvS3nHHp0bUhsCfjjwdnM=;
        b=eG/F2m7dCKeevrOGQCNnK7ki0yONZHmoW1SJ/fHlV033yU2gtshLi+nkXi5Z2ShC9i
         Tmg6XtF5anN370n0H6QvldKrICjV+nUC6X5MhbDuH66obQa+aOUCaaHxvBWlP0RE6vsq
         UW/B6VbVEX7A24bWBcHdsh1QHrQfZySNNNdxV/ZLLaEkEZN9VPKJJ85fN4XM8lOR7lSW
         CHAIvZbRMWUiAPyWn9iDSg/yHB43bepCgnwxkTP3tObJrh00Lh8Ujn2TV+Ydhx2Jc2UG
         4L2MUN+aiY0X4LVG2FdqeanWdiBPXG4Y5bZer4iL/POV3F3+AiOqbFgSjl1cGRzDsWbB
         615w==
X-Gm-Message-State: AOAM530HjDKgr+iONLo1ryV+eiUhhYjLil2QwpQkiv/bGVCO2UmxUfpv
        WbW+0Fw9QqEPdG49nN/yv4nbfw==
X-Google-Smtp-Source: ABdhPJwkIugXOlFj9UVfpNEKI0rUdxNVw1kYx+fvcOyjUsYkM61oloagp+EJB75HV4kKo4QGhnJ3Cw==
X-Received: by 2002:a63:ec4c:: with SMTP id r12mr1598153pgj.74.1602633309170;
        Tue, 13 Oct 2020 16:55:09 -0700 (PDT)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id s24sm368443pjp.53.2020.10.13.16.55.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Oct 2020 16:55:08 -0700 (PDT)
Subject: Re: [PATCH 4/4] task_work: use TIF_NOTIFY_SIGNAL if available
To:     Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        io-uring@vger.kernel.org
Cc:     peterz@infradead.org, oleg@redhat.com,
        Roman Gershman <romger@amazon.com>
References: <20201008152752.218889-1-axboe@kernel.dk>
 <20201008152752.218889-5-axboe@kernel.dk>
 <87362hd6ta.fsf@nanos.tec.linutronix.de>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <327d0ab5-a77e-8f9c-95da-d0dccece6ad8@kernel.dk>
Date:   Tue, 13 Oct 2020 17:55:07 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <87362hd6ta.fsf@nanos.tec.linutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/13/20 5:50 PM, Thomas Gleixner wrote:
> On Thu, Oct 08 2020 at 09:27, Jens Axboe wrote:
>> +/*
>> + * TWA_SIGNAL signaling - use TIF_NOTIFY_SIGNAL, if available, as it's faster
>> + * than TIF_SIGPENDING as there's no dependency on ->sighand. The latter is
>> + * shared for threads, and can cause contention on sighand->lock. Even for
>> + * the non-threaded case TIF_NOTIFY_SIGNAL is more efficient, as no locking
>> + * or IRQ disabling is involved for notification (or running) purposes.
>> + */
>> +static void task_work_notify_signal(struct task_struct *task)
>> +{
>> +#ifdef TIF_NOTIFY_SIGNAL
>> +	set_notify_signal(task);
>> +#else
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
>> +#endif
> 
> Same #ifdeffery comment as before.

Fixed up.

-- 
Jens Axboe

