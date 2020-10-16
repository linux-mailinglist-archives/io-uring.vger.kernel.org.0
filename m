Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0DF32908FF
	for <lists+io-uring@lfdr.de>; Fri, 16 Oct 2020 17:57:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409074AbgJPP52 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 16 Oct 2020 11:57:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2408916AbgJPP51 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 16 Oct 2020 11:57:27 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD16FC061755
        for <io-uring@vger.kernel.org>; Fri, 16 Oct 2020 08:57:26 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id c6so1503479plr.9
        for <io-uring@vger.kernel.org>; Fri, 16 Oct 2020 08:57:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=y3zyQD1oZ6nZSGLlgSpYoYP+dUXkQUi0W/fAaordKOE=;
        b=xRSca9lpG2RA4/tzFbuZ4JNhHW6GpDoikHSIDlW6keDOYsevR63Psz4kylc4+clkpx
         2wYWrNexjhb5O6WdwevAcHKwgXxKaczMB0QOUjmghwqfZmnlXvsZ8cRGuwqAygOHPYjH
         O22XhT+bnsS5RAKA7VVejzzhNubsaFhcPvCYy/mBXPmbZjMoeGDIB+c/SwHStHjU/B9C
         oMrNe5A/hRSz5KtVOgypW4qKGTWgCVc/oBlXt8ldjwWHcpG0eUBui7otynojmYJCaceb
         zC4rXQlnUCZa9o6Uor2KTK8vMn+gWRVfxEa/SJkhxMhD8BrpmzDibKspFI1aHtPst2od
         kjag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=y3zyQD1oZ6nZSGLlgSpYoYP+dUXkQUi0W/fAaordKOE=;
        b=H4pLribyZ6AzMvR+xBbqW5RvCFXTFJ6gHGE3GQLtryunW574JAPebJhDDppVUgapQ8
         QIaQ3qMwHZzbtAx6xdWuZ/ZCaCJk7eEtbgvPiiMVPVmktvj/alSLZcXnSgpkkoR7pNU/
         UMl6iyyNL9LbGDWGmozFPRAn4vNXonlzCrmHgeRbOvWeKwHnZV9dWsOPX9EeEE1Yw0tu
         73GVxedspoHhp68CcJSGtlS9SKsf6mDaJOhGIy0ABuBVIv8u39AXvEXiufUAYIWasNjW
         g9h0jFdV6zd4S0QqT2m6wG1y0eFaTdKaT4bdYnxTmWa6hEI00vV3sSGIX9fd9VfsUjnV
         1Wfg==
X-Gm-Message-State: AOAM532Aiw9wd0Q1bbmkORlAy/r60VH43Cyqccq0hFBJfSz+Rx14LHCy
        nFZxkp0mENET68Ly+niUw31GtMBY6mHLJEEF
X-Google-Smtp-Source: ABdhPJzp4kwGjI5H+Q0hATkqinnIwe1oMvo4YSYNKkQDbmLAqCqSKmaE3fBeMLvQCGA2TxvnMtK4uQ==
X-Received: by 2002:a17:90a:c796:: with SMTP id gn22mr4838629pjb.224.1602863845915;
        Fri, 16 Oct 2020 08:57:25 -0700 (PDT)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id u14sm3412531pjf.53.2020.10.16.08.57.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Oct 2020 08:57:25 -0700 (PDT)
Subject: Re: Samba with multichannel and io_uring
To:     Stefan Metzmacher <metze@samba.org>,
        Samba Technical <samba-technical@lists.samba.org>,
        io-uring <io-uring@vger.kernel.org>
References: <53d63041-5931-c5f2-2f31-50b5cbe09ec8@samba.org>
 <efb8b619-ca06-5c6b-e052-0c40b64b9904@kernel.dk>
 <6e7ea4e7-8ef7-9ad4-1377-08749f9bae0b@samba.org>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <18e153db-5ee9-f286-58ae-30065feda737@kernel.dk>
Date:   Fri, 16 Oct 2020 09:57:24 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <6e7ea4e7-8ef7-9ad4-1377-08749f9bae0b@samba.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/16/20 5:49 AM, Stefan Metzmacher wrote:
> Hi Jens,
> 
>> Thanks for sending this, very interesting! As per this email, I took a
>> look at the NUMA bindings. If you can, please try this one-liner below.
>> I'd be interested to know if that removes the fluctuations you're seeing
>> due to bad locality.
>>
>> Looks like kthread_create_on_node() doesn't actually do anything (at
>> least in terms of binding).
>>
>>
>> diff --git a/fs/io-wq.c b/fs/io-wq.c
>> index 74b84e8562fb..7bebb198b3df 100644
>> --- a/fs/io-wq.c
>> +++ b/fs/io-wq.c
>> @@ -676,6 +676,7 @@ static bool create_io_worker(struct io_wq *wq, struct io_wqe *wqe, int index)
>>  		kfree(worker);
>>  		return false;
>>  	}
>> +	kthread_bind_mask(worker->task, cpumask_of_node(wqe->node));
>>  
>>  	raw_spin_lock_irq(&wqe->lock);
>>  	hlist_nulls_add_head_rcu(&worker->nulls_node, &wqe->free_list);
>>
> 
> I no longer have access to that system, but I guess it will help, thanks!

I queued up it when I sent it out, and it'll go into stable as well.
I since verified on NUMA here that it does the right thing, and that
things weren't affinitized properly before. So pretty confident that it
will indeed solve this issue!

> With this:
> 
>         worker->task = kthread_create_on_node(io_wqe_worker, worker, wqe->node,
>                                 "io_wqe_worker-%d/%d", index, wqe->node);
> 
> I see only "io_wqe_worker-0" and "io_wqe_worker-1" in top, without '/0' or '/1' at the end,
> this is because set_task_comm() truncates to 15 characters.
> 
> As developer I think 'io_wqe' is really confusing, just from reading I thought it
> means "work queue entry", but it's a per numa node worker pool container...
> 'struct io_wq_node *wqn' would be easier to understand for me...
> 
> Would it make sense to give each io_wq a unique identifier and use names like this:
> (fdinfo of the io_uring fd could also include the io_wq id)
> 
>  "io_wq-%u-%u%c", wq->id, wqn->node, index == IO_WQ_ACCT_BOUND ? 'B' : 'U')
> 
>  io_wq-500-M
>  io_wq-500-0B
>  io_wq-500-0B
>  io_wq-500-1B
>  io_wq-500-0U
>  io_wq-200-M
>  io_wq-200-0B
>  io_wq-200-0B
>  io_wq-200-1B
>  io_wq-200-0U
> 
> I'm not sure how this interacts with workers moving between bound and unbound
> and maybe a worker id might also be useful (or we rely on their pid)

I don't think that's too important, as it's just a snapshot in time. So
it'll fluctuate based on the role of the worker.

> I just found that proc_task_name() handles PF_WQ_WORKER special
> and cat /proc/$pid/comm can expose something like:
>   kworker/u17:2-btrfs-worker-high

Yep, that's how they do fancier names. It's been on my agenda for a while
to do something about this, I'll try and cook something up for 5.11.

-- 
Jens Axboe

