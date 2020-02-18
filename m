Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A908162AFC
	for <lists+io-uring@lfdr.de>; Tue, 18 Feb 2020 17:46:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726411AbgBRQqt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 18 Feb 2020 11:46:49 -0500
Received: from mail-pj1-f50.google.com ([209.85.216.50]:50521 "EHLO
        mail-pj1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726399AbgBRQqt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 18 Feb 2020 11:46:49 -0500
Received: by mail-pj1-f50.google.com with SMTP id r67so1274798pjb.0
        for <io-uring@vger.kernel.org>; Tue, 18 Feb 2020 08:46:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+zInuGD/hleCN8Um3b8/r71THudZp1sch3iFenLpVHs=;
        b=VXmtUxcxkMfslBwvuKClPxAkWbMAhjmJm9uLWj5tvdzTCAqeLFfuLPCgCifmNJRWvU
         X1+aCuEHX/dzaGnLd92vQ2ktLRPIcvLFcSmvpBKJTGtM3FLxZ+ruk68jkNCpinmuB3tx
         YW3bqvk+SPGxfZbRAwVY/IOq14ySi4bPWfRKili/mTF3sBcTAgSwJB3OA2DU2DuGrmsH
         gl75Nbihqtl4cpcFD3XFLdqZ4yUhcEKQ207spAURJmm6XHtGh4wEr6UCxT7HCfvsDzJ2
         Ico6iPO9BqjeXyTcZzaF2RhGYOvtF9rB3jvGnzvvPWTmH1LpxjwoS4865b+zJl0OPDN7
         NgHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+zInuGD/hleCN8Um3b8/r71THudZp1sch3iFenLpVHs=;
        b=izchlBk5gPsfkXJtwyLKPt/zhdMRVPdcToTiXr5i9F/qX0sb2peII6PeCY+EVOKFNT
         KAP8I+RySVijKFpdA/ylbXQy77ul27W471Mzl7Co/LBfH/cli0uSy4WJa0tx3a9NZrRm
         C1Y9g58d9JB12HnF8ksCv8Y2mL2Pt9RAkCoYpYm1nrJqMZtLBRwfRvHfAn+G770iESn8
         3D5HXx3YfsrEBgjGfgEfDjGrkdvgl5aLCBCLj/VYFYxn4yPYMG7+r6hZqnD4nwh1aIXK
         2mRUepeoCNz5vVy5Kf4SBE9XKtB5nRGdbU8azMQC70q4SCUn1r5IOt3ZyAtvUDoDoRDe
         zsqw==
X-Gm-Message-State: APjAAAVJR7LuQWBgfnHrjoUfu5P+yS0miQG19F/I6YRa8PiI1lxaVZej
        fZHOmqrmOW0LrPqvNmBNIwR2Rg==
X-Google-Smtp-Source: APXvYqx5epH+GwvGe8TUB7iUftNjKyGr99GbtjgVYPJuu7ylJXZs1WbpwVUyTt0mlArCzDWwpvKdMw==
X-Received: by 2002:a17:90a:2545:: with SMTP id j63mr3808899pje.128.1582044407111;
        Tue, 18 Feb 2020 08:46:47 -0800 (PST)
Received: from ?IPv6:2605:e000:100e:8c61:5924:648b:19a7:c9d0? ([2605:e000:100e:8c61:5924:648b:19a7:c9d0])
        by smtp.gmail.com with ESMTPSA id d69sm5022781pfd.72.2020.02.18.08.46.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Feb 2020 08:46:46 -0800 (PST)
Subject: Re: [ISSUE] The time cost of IOSQE_IO_LINK
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     =?UTF-8?B?Q2FydGVyIExpIOadjumAmua0sg==?= <carter.li@eoitek.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring <io-uring@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>
References: <20200214153218.GM14914@hirez.programming.kicks-ass.net>
 <5995f84e-8a6c-e774-6bb5-5b9b87a9cd3c@kernel.dk>
 <7c4c3996-4886-eb58-cdee-fe0951907ab5@kernel.dk>
 <addcd44e-ed9b-5f82-517d-c1ed3ee2d85c@kernel.dk>
 <b8069e62-7ea4-c7f3-55a3-838241951068@kernel.dk>
 <20200217120920.GQ14914@hirez.programming.kicks-ass.net>
 <53de3581-b902-89ba-3f53-fd46b052df40@kernel.dk>
 <43c066d1-a892-6a02-82e7-7be850d9454d@kernel.dk>
 <20200217174610.GU14897@hirez.programming.kicks-ass.net>
 <592cf069-41ee-0bc1-1f83-e058e5dd53ff@kernel.dk>
 <20200218131310.GZ14914@hirez.programming.kicks-ass.net>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <4f5bdc83-b308-34f4-61fd-54480f84b5f3@kernel.dk>
Date:   Tue, 18 Feb 2020 08:46:45 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200218131310.GZ14914@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/18/20 6:13 AM, Peter Zijlstra wrote:
> Jens, I think you want something like this on top of what you have,
> mostly it is adding sched_work_run() to exit_task_work().

It also makes it a bit cleaner, I don't like the implied task == current
we have in a bunch of spots. Folded this in (thanks!) with minor edit:

> @@ -157,10 +157,10 @@ static void __task_work_run(struct task_struct *task,
>   */
>  void task_work_run(void)
>  {
> -	__task_work_run(current, &current->task_works);
> +	__task_work_run(&current->task_works);
>  }
>  
> -void sched_work_run(struct task_struct *task)
> +void sched_work_run()
>  {
> -	__task_work_run(task, &task->sched_work);
> +	__task_work_run(&task->sched_work);
>  }

s/task/current for this last one.

-- 
Jens Axboe

