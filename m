Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBC3431FFEB
	for <lists+io-uring@lfdr.de>; Fri, 19 Feb 2021 21:40:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229771AbhBSUih (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 19 Feb 2021 15:38:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229752AbhBSUi1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 19 Feb 2021 15:38:27 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26DE7C06178B
        for <io-uring@vger.kernel.org>; Fri, 19 Feb 2021 12:37:47 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id kr16so4370486pjb.2
        for <io-uring@vger.kernel.org>; Fri, 19 Feb 2021 12:37:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=QoI5VTMjU96+Zh72UnaYrIGGKk0avSmGOKsbZitoNKQ=;
        b=SIkmOLP10UOrUQUSj6trg8ghJQTR0tlLaiRtRSl24jU8Z2dVNDOyMdwg3iJhPl26VN
         x+fRQCf/OKdywD3XKJbMdT+9cfGZCjMv1wQQJm2WEANnH5jgFj0DGhPMpZLm+PFprNCf
         Fj9TAJ7xvaMLFRIV6nxYVpTuAev04hRy0fjhqHe+0yrSDq093/XKTCq0SpXBNRZG9yiv
         3KIn/Pqu1HwfyHx2uTCEAcHXFirNJ7EmyV+mZXSONKMEccTsuepW8Nk4OHgZms9iSQMP
         xaeu5SFSpp2wbY2sbv6nQPOirz90Cs7tNKAkMX5YyaMA5wK6y/hFyjflwdoKwrR792FV
         12ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QoI5VTMjU96+Zh72UnaYrIGGKk0avSmGOKsbZitoNKQ=;
        b=nwUqV+NeIWQoz3vfs+zyPVOCjXJAi2dTImDE7ZNDhm38O7dRJJfV3LAcq+accYrnts
         LYVjb7W+Ov0Y/ZQD+FGmi+J4LScD7Pntw/OcjqaLikfW/lVMn1ymwgq5PLOwYqxhYcuQ
         hoR8sBTSiQ4mLNj4ad+F2XC4J+PjfMuEQzSIKeEbUAfwAeBOc9FSALse+hH4wx6JU3PO
         UGjh0H2Noov7JxW77yVRGq7XrzCudJJYNcTyEjZeEoQDFcjEF/CcCljDVxEMi7iU+HZy
         u0SkYgknsyfsejtCp3auzdSfxaM+LGw0oRlL27TkANmf1L3UW6T1JhLcmqDvuRGTMHsS
         4SnA==
X-Gm-Message-State: AOAM532ZwQuzdxyd9UOKj/BQYTX1cBm0ebfyGU9igqOZ+QowTrL/7m75
        Hjyvbg+uq9Xxj9+MtBvLupNQgg==
X-Google-Smtp-Source: ABdhPJzbb2fCgcVU9Qy7pv4xi5lGfpk1bfpN7VYl/9iXOVtWg0FI21/+6KhKXwZE3B1hnrvHdN6OBA==
X-Received: by 2002:a17:902:d698:b029:e3:d279:c0ae with SMTP id v24-20020a170902d698b02900e3d279c0aemr1223350ply.67.1613767066463;
        Fri, 19 Feb 2021 12:37:46 -0800 (PST)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id dw23sm9262228pjb.3.2021.02.19.12.37.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Feb 2021 12:37:45 -0800 (PST)
Subject: Re: [PATCH 01/18] io_uring: remove the need for relying on an io-wq
 fallback worker
To:     "Eric W. Biederman" <ebiederm@xmission.com>
Cc:     io-uring@vger.kernel.org, viro@zeniv.linux.org.uk,
        torvalds@linux-foundation.org
References: <20210219171010.281878-1-axboe@kernel.dk>
 <20210219171010.281878-2-axboe@kernel.dk> <m1czwvoldy.fsf@fess.ebiederm.org>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <b64836d0-8afd-dc4a-430c-db91f0aebfba@kernel.dk>
Date:   Fri, 19 Feb 2021 13:37:44 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <m1czwvoldy.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/19/21 1:25 PM, Eric W. Biederman wrote:
>> @@ -2313,11 +2316,14 @@ static int io_req_task_work_add(struct io_kiocb *req)
>>  static void io_req_task_work_add_fallback(struct io_kiocb *req,
>>  					  task_work_func_t cb)
>>  {
>> -	struct task_struct *tsk = io_wq_get_task(req->ctx->io_wq);
>> +	struct io_ring_ctx *ctx = req->ctx;
>> +	struct callback_head *head;
>>  
>>  	init_task_work(&req->task_work, cb);
>> -	task_work_add(tsk, &req->task_work, TWA_NONE);
>> -	wake_up_process(tsk);
>> +	do {
>> +		head = ctx->exit_task_work;
>                        ^^^^^^^^^^^^^^^^^^^^
> This feels like this should be READ_ONCE to prevent tearing reads.
> 
> You use READ_ONCE on this same variable below which really suggests
> this should be a READ_ONCE.

It should, added.

>> +		req->task_work.next = head;
>> +	} while (cmpxchg(&ctx->exit_task_work, head, &req->task_work) != head);
>>  }
>>  
>>  static void __io_req_task_cancel(struct io_kiocb *req, int error)
>> @@ -9258,6 +9264,30 @@ void __io_uring_task_cancel(void)
>>  	io_uring_remove_task_files(tctx);
>>  }
>>  
>> +static void io_run_ctx_fallback(struct io_ring_ctx *ctx)
>> +{
>> +	struct callback_head *work, *head, *next;
>> +
>> +	do {
>> +		do {
>> +			head = NULL;
>> +			work = READ_ONCE(ctx->exit_task_work);
>> +			if (!work)
>> +				break;
>> +		} while (cmpxchg(&ctx->exit_task_work, work, head) != work);
>> +
>> +		if (!work)
>> +			break;
> 
> Why the double break on "!work"?  It seems like either the first should
> be goto out, or only the second should be here.

Yes good point, the first one should go away. I've made that change,
thanks.

-- 
Jens Axboe

