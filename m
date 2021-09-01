Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FBF43FD84D
	for <lists+io-uring@lfdr.de>; Wed,  1 Sep 2021 13:00:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237971AbhIALBF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 1 Sep 2021 07:01:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234901AbhIALBE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 1 Sep 2021 07:01:04 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFEBAC061575;
        Wed,  1 Sep 2021 04:00:07 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id z9-20020a7bc149000000b002e8861aff59so4471150wmi.0;
        Wed, 01 Sep 2021 04:00:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=fliK0zqrSXKSE633wrxZ2ziPK0GSUWGjbI2aLPDlS5M=;
        b=j48c7KwnOCW2XuoWH7HSqND7cAXsb78Uq+cWz3aCVJwJwgFQwC1hNCvH6XDqLsw+IY
         nn1Zrb964qouuxpJOuLoKyTL8neO5Bn4JuX7gVZXZIyvzFgQpWv8tnMsK1LAg5rSpCOU
         act6GlBgZWs5rIA0PegmIHfINrruUnBfgLITawWJxwnp1/p4kA821R1rZhtaVvpbBdB7
         QLFr5GXQ6cVmG/L+bJculz6sLPtUCHvJR9JLdOHZCV4kP/ITYs/iNXjDu5htvbpU7hin
         Gmuf4fgWhqkjGGG03W0J7vJEsfcRLw63WFmco1ylQmSRJuFPz9yw5l1ShgQtFUHp8FiU
         nPzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fliK0zqrSXKSE633wrxZ2ziPK0GSUWGjbI2aLPDlS5M=;
        b=lCP3eD4NzHVXAkgOdb3VlCpbMepyjOl5ncK4MIowbvK0vnxvcLQA0Av56ChWCDT9dj
         CRF4rRda3NQtrqNz1yz2h/W2Ip9kecsY2XCWjxHXYv/U/VBIN7e1RgKLLoJJe603KDP2
         sNzBGVY8jl97x6AvT55DQKVSSZVHVQl8qFsqlD1WFlmmDlNuTRZbtwxh2mdzYDgaJwbg
         14dOpfdpc8C2qabYNQo6ThxRgZeL3CyLMwM8dT9nJtU+DcsbGbUR1D+XzMF5CrSXPB3H
         8rwUhM4KYWKyXLoSjSe60oDHk+rXHExQEOgessp0vNiQd350rrNZpihQIye6/BCNwSif
         93+A==
X-Gm-Message-State: AOAM53016uFL3OvRER970kk9JH47hlVWzDmTTRCtQzDE2bk5rerpGshb
        zCgooyEH8ynEnTrzj3+JA+0v6b8PM0A=
X-Google-Smtp-Source: ABdhPJzuhSyGtEQsyxDQzop9Y0kwvim+A/utHWPL/f1IF3ATlAInD4cFJQ63n8RV6tFg8j0tgJGt4A==
X-Received: by 2002:a1c:19c1:: with SMTP id 184mr9189337wmz.98.1630494006222;
        Wed, 01 Sep 2021 04:00:06 -0700 (PDT)
Received: from [192.168.8.197] ([85.255.233.192])
        by smtp.gmail.com with ESMTPSA id p5sm23161161wrd.25.2021.09.01.04.00.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Sep 2021 04:00:05 -0700 (PDT)
Subject: Re: [RFC PATCH] io_uring: stop issue failed request to fix panic
To:     =?UTF-8?B?546L6LSH?= <yun.wang@linux.alibaba.com>,
        Jens Axboe <axboe@kernel.dk>,
        "open list:IO_URING" <io-uring@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
References: <b04adedd-a78a-634f-f28b-5840d5ec01df@linux.alibaba.com>
 <b2bd9fd0-736d-668f-7c32-3dda6f862758@gmail.com>
 <88c0b5ca-134f-85e5-4e25-b2ea558c4061@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <b8868d2c-e7ee-5f20-4561-e5ce1806e482@gmail.com>
Date:   Wed, 1 Sep 2021 11:59:33 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <88c0b5ca-134f-85e5-4e25-b2ea558c4061@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/1/21 10:52 AM, 王贇 wrote:
]> On 2021/9/1 下午5:47, Pavel Begunkov wrote:
>> On 9/1/21 10:39 AM, 王贇 wrote:
>>> We observed panic:
>>>   BUG: kernel NULL pointer dereference, address:0000000000000028
>>>   [skip]
>>>   Oops: 0000 [#1] SMP PTI
>>>   CPU: 1 PID: 737 Comm: a.out Not tainted 5.14.0+ #58
>>>   Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2011
>>>   RIP: 0010:vfs_fadvise+0x1e/0x80
>>>   [skip]
>>>   Call Trace:
>>>    ? tctx_task_work+0x111/0x2a0
>>>    io_issue_sqe+0x524/0x1b90
>>
>> Most likely it was fixed yesterday. Can you try?
>> https://git.kernel.dk/cgit/linux-block/log/?h=for-5.15/io_uring
>>
>> Or these two patches in particular
>>
>> https://git.kernel.dk/cgit/linux-block/commit/?h=for-5.15/io_uring&id=c6d3d9cbd659de8f2176b4e4721149c88ac096d4
>> https://git.kernel.dk/cgit/linux-block/commit/?h=for-5.15/io_uring&id=b8ce1b9d25ccf81e1bbabd45b963ed98b2222df8
> 
> Yup, it no longer panic :-)

awesome, thanks

> 
> Regards,
> Michael Wang
> 
>>
>>> This is caused by io_wq_submit_work() calling io_issue_sqe()
>>> on a failed fadvise request, and the io_init_req() return error
>>> before initialize the file for it, lead into the panic when
>>> vfs_fadvise() try to access 'req->file'.
>>>
>>> This patch add the missing check & handle for failed request
>>> before calling io_issue_sqe().
>>>
>>> Signed-off-by: Michael Wang <yun.wang@linux.alibaba.com>
>>> ---
>>>  fs/io_uring.c | 8 ++++++--
>>>  1 file changed, 6 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>>> index 6f35b12..bfec7bf 100644
>>> --- a/fs/io_uring.c
>>> +++ b/fs/io_uring.c
>>> @@ -2214,7 +2214,8 @@ static void io_req_task_submit(struct io_kiocb *req, bool *locked)
>>>
>>>  	io_tw_lock(ctx, locked);
>>>  	/* req->task == current here, checking PF_EXITING is safe */
>>> -	if (likely(!(req->task->flags & PF_EXITING)))
>>> +	if (likely(!(req->task->flags & PF_EXITING) &&
>>> +		   !(req->flags & REQ_F_FAIL)))
>>>  		__io_queue_sqe(req);
>>>  	else
>>>  		io_req_complete_failed(req, -EFAULT);
>>> @@ -6704,7 +6705,10 @@ static void io_wq_submit_work(struct io_wq_work *work)
>>>
>>>  	if (!ret) {
>>>  		do {
>>> -			ret = io_issue_sqe(req, 0);
>>> +			if (likely(!(req->flags & REQ_F_FAIL)))
>>> +				ret = io_issue_sqe(req, 0);
>>> +			else
>>> +				io_req_complete_failed(req, -EFAULT);
>>>  			/*
>>>  			 * We can get EAGAIN for polled IO even though we're
>>>  			 * forcing a sync submission from here, since we can't
>>>
>>

-- 
Pavel Begunkov
