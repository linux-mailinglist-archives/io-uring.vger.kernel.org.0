Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3890520BD9D
	for <lists+io-uring@lfdr.de>; Sat, 27 Jun 2020 03:45:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725997AbgF0BpT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 26 Jun 2020 21:45:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725952AbgF0BpS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 26 Jun 2020 21:45:18 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C228EC03E979
        for <io-uring@vger.kernel.org>; Fri, 26 Jun 2020 18:45:18 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id 35so4954497ple.0
        for <io-uring@vger.kernel.org>; Fri, 26 Jun 2020 18:45:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=QPXEgo7J4Z9e1G1GN/SUEoXmwDaKN1robUkkgHLpseI=;
        b=sv0ahYkwi/L434/tgVXF9dHBkS8kquKF3FF4JZSBkBegXeqM6fNUbzeyDP58W6CLM6
         rK46Vy8pmMnvoQVvYA8kuhfzc8d321uUP02g75BdFMrE2L8x7ulhzDTos9ynzuq8WuDW
         lxvkiiwJshY1VqrcpU9sEYiHtx/jJMIFBr7xBr8QxgunMYSZSmYtc2qPs8r72iEf2Lkf
         3UXcOn9o3NZFVQVt3OECiC376C39foZcYcr9kRmERVqzhkIOxD1/xajiY7MZYW8MNqKv
         FFl4zeH3BaPeBSB9RafR0qH6WU8OFi1A78nKKJSMv0K1BPlGdxqde6ODjbg9BaIbIj/6
         yilQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QPXEgo7J4Z9e1G1GN/SUEoXmwDaKN1robUkkgHLpseI=;
        b=II74BjZwYL/dRhZrQj4sLbkuUUA6ClSwcth2Fr84gYkWwOcL++8Wr6fSByexBYOPpc
         sPpGKx+Kp9dX/DJzIdVOhXeN4Oz9bFrR3kbfYxY7BtcO8vtvFuOVqBdqD+WXNXIPSnsL
         9DKy/Ai/S7V3CL9cSnS9oYOkcbgpKkavX8S4nuVsWq/tQLRdT0t8fb2UdueXFZp423jx
         dYcwauiqRoLb5XDZtiGNwD0tUt/rvTE7ZfZd/Ph5VpGFjyyFvqO/wJkG945h6GzWz36d
         lL+Gy3euBxFiTSAZJq7KFU524QZqH6fhY5+nntWnnO+5NucIuR+efyUJF7N686y+bFuf
         IrRA==
X-Gm-Message-State: AOAM530svW18ipwMPpelz4NrsWG1TLzDAE1ucudVVu1JuUD2jK40Knbj
        5P7y3lIzqC8CiOcI0D1cPJpGSYQEe6OCmg==
X-Google-Smtp-Source: ABdhPJy2ernnENTi/PwIGSIRyKHg9RHIEVTG7PxQvawj8+8gxXK/JXGXxlpUVThTu8LEOy8jeFNxkA==
X-Received: by 2002:a17:90a:de0f:: with SMTP id m15mr5988971pjv.21.1593222317774;
        Fri, 26 Jun 2020 18:45:17 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id v28sm9733673pgc.44.2020.06.26.18.45.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Jun 2020 18:45:17 -0700 (PDT)
Subject: Re: [PATCH] io_uring: use task_work for links if possible
To:     Pavel Begunkov <asml.silence@gmail.com>,
        io-uring <io-uring@vger.kernel.org>
References: <421c3b22-2619-a9a2-a76e-ed8251c7264c@kernel.dk>
 <f6ad4ae4-dc7a-1f39-d4da-40b5d6c04d04@gmail.com>
 <22c72f8a-e80d-67ea-4f89-264238e5810d@kernel.dk>
 <7bfac3fc-22be-0ec7-fb7e-4fa714091ba9@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <9f5cc1b3-637f-2caf-9808-1b11af46bfd3@kernel.dk>
Date:   Fri, 26 Jun 2020 19:45:15 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <7bfac3fc-22be-0ec7-fb7e-4fa714091ba9@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/26/20 3:20 PM, Pavel Begunkov wrote:
>>>> +		tsk = io_wq_get_task(req->ctx->io_wq);
>>>> +		task_work_add(tsk, &req->task_work, true);
>>>> +	}
>>>> +	wake_up_process(tsk);
>>>> +}
>>>> +
>>>>  static void io_free_req(struct io_kiocb *req)
>>>>  {
>>>>  	struct io_kiocb *nxt = NULL;
>>>> @@ -1671,8 +1758,12 @@ static void io_free_req(struct io_kiocb *req)
>>>>  	io_req_find_next(req, &nxt);
>>>>  	__io_free_req(req);
>>>>  
>>>> -	if (nxt)
>>>> -		io_queue_async_work(nxt);
>>>> +	if (nxt) {
>>>> +		if (nxt->flags & REQ_F_WORK_INITIALIZED)
>>>> +			io_queue_async_work(nxt);
>>>
>>> Don't think it will work. E.g. io_close_prep() may have set
>>> REQ_F_WORK_INITIALIZED but without io_req_work_grab_env().
>>
>> This really doesn't change the existing path, it just makes sure we
>> don't do io_req_task_queue() on something that has already modified
>> ->work (and hence, ->task_work). This might miss cases where we have
>> only cleared it and done nothing else, but that just means we'll have
>> cases that we could potentially improve the effiency of down the line.
> 
> Before the patch it was always initialising linked reqs, and that would
> work ok, if not this lazy grab_env().
> 
> E.g. req1 -> close_req
> 
> It calls, io_req_defer_prep(__close_req__, sqe, __false__)
> which doesn't do grab_env() because of for_async=false,
> but calls io_close_prep() which sets REQ_F_WORK_INITIALIZED.
> 
> Then, after completion of req1 it will follow added lines
> 
> if (nxt)
> 	if (nxt->flags & REQ_F_WORK_INITIALIZED)
> 		io_queue_async_work(nxt);
> 
> Ending up in
> 
> io_queue_async_work()
> 	-> grab_env()
> 
> And that's who knows from which context.
> E.g. req1 was an rw completed in an irq.

Hmm yes, good point, that is a problem. I don't have a good immediate
solution for this. Do you have any suggestions on how best to handle
this?

> Not sure it's related, but fallocate shows the log below, and some
> other tests hang the kernel as well.

Yeah, that's indeed that very thing.

>> True, that could be false instead.
>>
>> Since these are just minor things, we can do a fix on top. I don't want
>> to reshuffle this unless I have to.
> 
> Agree, I have a pile on top myself.

Fire away :-)

-- 
Jens Axboe

