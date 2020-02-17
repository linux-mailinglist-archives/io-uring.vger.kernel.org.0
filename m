Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5692916176D
	for <lists+io-uring@lfdr.de>; Mon, 17 Feb 2020 17:13:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729843AbgBQQNV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 17 Feb 2020 11:13:21 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:44735 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728724AbgBQQMe (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 17 Feb 2020 11:12:34 -0500
Received: by mail-pg1-f193.google.com with SMTP id g3so9293229pgs.11
        for <io-uring@vger.kernel.org>; Mon, 17 Feb 2020 08:12:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=kPpig8IRi/CLfAtGdQe/df39YbJ3zPSWq4pnX8V1f9k=;
        b=tF89O2ytyC2ZOIV9TzgymUjKt5eJaqOYs1EvSea+Ude5zAYVRtEAFmFSmwEIoHs69V
         DVnuEBlk28J8qgNqOtA72fTlsj23ZSL8O0KqBYSK/752tq2NlxVJIeAL9H0v8Ugceklz
         n+Qud4hFdBCql7zK2/NbuZcVpSqEr+6b2jLtnHy/McfeIByOyzYa5as6V4s2aK6aKjDM
         NF4r1iGHo1ocw8+wXBOHRtUHM5qB6Dh5u8++Q3AxI2C68mVreAm0sq4y6u5ZSKqJwTle
         5B8W3/PC53EdBxNSMe0YQPt1XlAIZE9am2edf/WPfCdSrBtLiJhMIcLgjSFYO5P/huPe
         DLnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kPpig8IRi/CLfAtGdQe/df39YbJ3zPSWq4pnX8V1f9k=;
        b=Qx9OGXCKWXXKVXwJFVAe4IXBuE8unwY4BONpiaxvwqEEusFR1FAElw5Q+6VaTA0g2T
         hZqjiyA2CCiTr5MY6tMNB61EwNWVU1eDn5t/kk9am7j4hhZVrptLupmXtkDDsAFs/gq4
         shVQ80W5O5Bsh5OOwORud+Ezp/HZev0fGRxZhJJaTcr89qGkwRiWZ99uplsTRNT3iHRq
         cOxLvcV1K0gWHTAZ4HOS8URpP6P3MxDmjhlxqvC29QMzkH/DEHB6lDNplkUqEzyJndwx
         kCSsawmHrOxI9ZAMStGIykTyvivuiY7PYR/PYIl+YTY26SHGJnVLG5sD+PXS2Lb5To4H
         aK+Q==
X-Gm-Message-State: APjAAAXeGiAB52FnL9h6czLKoLDFgLVxLF4x4P9nS7JIWhhAVLMi+Ny1
        K8byqLHEM9UMqvZmXE4otKwnxoRP4Qg=
X-Google-Smtp-Source: APXvYqzj8CXgh8HdEbMNxbB5MV2zbGs0A+AAAR0p5lxh1opoh82KLiSIsUPcBwmJnwZcyDk2NVOLrA==
X-Received: by 2002:a63:1044:: with SMTP id 4mr19029691pgq.412.1581955953433;
        Mon, 17 Feb 2020 08:12:33 -0800 (PST)
Received: from ?IPv6:2605:e000:100e:8c61:2c5c:f8ef:ba20:d218? ([2605:e000:100e:8c61:2c5c:f8ef:ba20:d218])
        by smtp.gmail.com with ESMTPSA id y18sm988571pfe.19.2020.02.17.08.12.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Feb 2020 08:12:32 -0800 (PST)
Subject: Re: [ISSUE] The time cost of IOSQE_IO_LINK
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     =?UTF-8?B?Q2FydGVyIExpIOadjumAmua0sg==?= <carter.li@eoitek.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring <io-uring@vger.kernel.org>
References: <5f09d89a-0c6d-47c2-465c-993af0c7ae71@kernel.dk>
 <7E66D70C-BE4E-4236-A49B-9843F66EA322@eoitek.com>
 <671A3FE3-FA12-43D8-ADF0-D1DB463B053F@eoitek.com>
 <217eda7b-3742-a50b-7d6a-c1294a85c8e0@kernel.dk>
 <1b9a7390-7539-a8bc-d437-493253b13d77@kernel.dk>
 <20200214153218.GM14914@hirez.programming.kicks-ass.net>
 <5995f84e-8a6c-e774-6bb5-5b9b87a9cd3c@kernel.dk>
 <7c4c3996-4886-eb58-cdee-fe0951907ab5@kernel.dk>
 <addcd44e-ed9b-5f82-517d-c1ed3ee2d85c@kernel.dk>
 <b8069e62-7ea4-c7f3-55a3-838241951068@kernel.dk>
 <20200217120920.GQ14914@hirez.programming.kicks-ass.net>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <53de3581-b902-89ba-3f53-fd46b052df40@kernel.dk>
Date:   Mon, 17 Feb 2020 08:12:30 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200217120920.GQ14914@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/17/20 5:09 AM, Peter Zijlstra wrote:
> On Fri, Feb 14, 2020 at 01:44:32PM -0700, Jens Axboe wrote:
> 
> I've not looked at git trees yet, but the below doesn't apply to
> anything I have at hand.
> 
> Anyway, I think I can still make sense of it -- just a rename or two
> seems to be missing.
> 
> A few notes on the below...

Thanks for continuing to look at it, while we both try and make sense of
it :-)

>> diff --git a/include/linux/sched.h b/include/linux/sched.h
>> index 04278493bf15..447b06c6bed0 100644
>> --- a/include/linux/sched.h
>> +++ b/include/linux/sched.h
>> @@ -685,6 +685,11 @@ struct task_struct {
>>  #endif
>>  	struct sched_dl_entity		dl;
>>  
>> +#ifdef CONFIG_IO_URING
>> +	struct list_head		uring_work;
>> +	raw_spinlock_t			uring_lock;
>> +#endif
>> +
> 
> Could we pretty please use struct callback_head for this, just like
> task_work() and RCU ? Look at task_work_add() for inspiration.

Sure, so add a new one, sched_work, and have it get this sched-in or
sched-out behavior.

Only potential hitch I see there is related to ordering, which is more
of a fairness thab correctness issue. I'm going to ignore that for now,
and we can always revisit later.

> And maybe remove the uring naming form this.

No problem

>>  #ifdef CONFIG_UCLAMP_TASK
>>  	/* Clamp values requested for a scheduling entity */
>>  	struct uclamp_se		uclamp_req[UCLAMP_CNT];
>> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
>> index 51ca491d99ed..170fefa1caf8 100644
>> --- a/kernel/sched/core.c
>> +++ b/kernel/sched/core.c
>> @@ -2717,6 +2717,11 @@ static void __sched_fork(unsigned long clone_flags, struct task_struct *p)
>>  	INIT_HLIST_HEAD(&p->preempt_notifiers);
>>  #endif
>>  
>> +#ifdef CONFIG_IO_URING
>> +	INIT_LIST_HEAD(&p->uring_work);
>> +	raw_spin_lock_init(&p->uring_lock);
>> +#endif
>> +
>>  #ifdef CONFIG_COMPACTION
>>  	p->capture_control = NULL;
>>  #endif
>> @@ -4104,6 +4109,20 @@ void __noreturn do_task_dead(void)
>>  		cpu_relax();
>>  }
>>  
>> +#ifdef CONFIG_IO_URING
>> +extern void io_uring_task_handler(struct task_struct *tsk);
>> +
>> +static inline void io_uring_handler(struct task_struct *tsk)
>> +{
>> +	if (!list_empty(&tsk->uring_work))
>> +		io_uring_task_handler(tsk);
>> +}
>> +#else /* !CONFIG_IO_URING */
>> +static inline void io_uring_handler(struct task_struct *tsk)
>> +{
>> +}
>> +#endif
>> +
>>  static void sched_out_update(struct task_struct *tsk)
>>  {
>>  	/*
>> @@ -4121,6 +4140,7 @@ static void sched_out_update(struct task_struct *tsk)
>>  			io_wq_worker_sleeping(tsk);
>>  		preempt_enable_no_resched();
>>  	}
>> +	io_uring_handler(tsk);
>>  }
>>  
>>  static void sched_in_update(struct task_struct *tsk)
>> @@ -4131,6 +4151,7 @@ static void sched_in_update(struct task_struct *tsk)
>>  		else
>>  			io_wq_worker_running(tsk);
>>  	}
>> +	io_uring_handler(tsk);
>>  }
> 
> The problem I have here is that we have an unconditional load of the
> cacheline that has ->uring_work in.
> 
> /me curses about how nobody seems interested in building useful
> cacheline analyis tools :/
> 
> Lemme see if I can find a spot for this... perhaps something like so?
> 
> 
> 
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 0918904c939d..4fba93293fa1 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -649,6 +649,7 @@ struct task_struct {
>  	/* Per task flags (PF_*), defined further below: */
>  	unsigned int			flags;
>  	unsigned int			ptrace;
> +	int				on_rq;
>  
>  #ifdef CONFIG_SMP
>  	struct llist_node		wake_entry;
> @@ -671,14 +672,16 @@ struct task_struct {
>  	int				recent_used_cpu;
>  	int				wake_cpu;
>  #endif
> -	int				on_rq;
>  
>  	int				prio;
>  	int				static_prio;
>  	int				normal_prio;
>  	unsigned int			rt_priority;
>  
> +	struct callbach_head		*sched_work;
> +
>  	const struct sched_class	*sched_class;
> +
>  	struct sched_entity		se;
>  	struct sched_rt_entity		rt;
>  #ifdef CONFIG_CGROUP_SCHED

Thanks, I'll kick off the series with doing it based on this instead.

-- 
Jens Axboe

