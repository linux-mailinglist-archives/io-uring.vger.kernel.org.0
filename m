Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF37820C0E4
	for <lists+io-uring@lfdr.de>; Sat, 27 Jun 2020 12:58:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726175AbgF0K6l (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 27 Jun 2020 06:58:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725991AbgF0K6k (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 27 Jun 2020 06:58:40 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 834D3C03E979
        for <io-uring@vger.kernel.org>; Sat, 27 Jun 2020 03:58:40 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id 22so11045442wmg.1
        for <io-uring@vger.kernel.org>; Sat, 27 Jun 2020 03:58:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=7UfT8vRr8nN2ABkR0koW/MElPZV6OqGnVD4r4ZDbjrE=;
        b=Ei1D6gydKSCAqtg6uMWwuNsvUpTXMGXi4+t7ybXFTYDetexp8gwYXon9CJI8LHxDFo
         arlXgjTPQXCZLQVgwVCWXiv7vRbQAyRrXMNS2iEaR+/FUOIvvatPaxfVLK1mckbduQQA
         hYrjy1DVwSaP9BQ65GTaDRE3j69yuw1zTOPPQn/mWqzcl829Mhk4kpSsOSlj46RFoA+I
         W9tiyHErE81Ih2Hw6bTPIGd2A3GpcvW/JALA2B8LYYSAZ+Tjwc5wZsop8A6cGZtujCqJ
         oSQ5L5mNVt0hWD2Jt/hMCA7j3sy1BM5Zm5mnMW4zpSOfAytxoPPHFfPXgQDUygmpzrWK
         nRog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:autocrypt:subject:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7UfT8vRr8nN2ABkR0koW/MElPZV6OqGnVD4r4ZDbjrE=;
        b=fQbc18fzTY3KoR29ZXQJmvwJlnVMrDhB8uWP2qzJlSBhdrFSshSn+2/sK7wt2Z03S/
         fcNgVTG81JY7xR+oaXv5E2pzqS+/ippVWAZn7xXKkkzyeP0I0+kY2nE/Xkj7LcD3vI1b
         hOmuYxi2gJzJowIlEt/u3nAyDyxLUlr7xw0OzNHByRQFmjs/0z90qeolNCArrxqzwtdN
         F8g9eubx1lQT4it/cwN42Xsgy8v5poanAryX+Ykz+gECZRpHb9tBoIkMo+49K4zRe1w1
         25ioidDYt5cnv7/0lP+13zjztpzmRsK+XoPIsrRIY7dzw+/demmyrFjxc7A4It+E2/yK
         AVgg==
X-Gm-Message-State: AOAM5325Ucu4yMUFAHcNzxIMjGUA3Yd4dxGkV7CO5z5vbNuwvMh7DNAS
        1sYFOTmN+3ZoFK7IMYpgV//89MyK
X-Google-Smtp-Source: ABdhPJxq8Wh7mBAZJH1WY1zoJfLNnzZP6uSpPVRS+7Zo0crUMtS0DwrO8EfEUuZqvZ7dqksNqbXhAA==
X-Received: by 2002:a1c:cc03:: with SMTP id h3mr7719362wmb.87.1593255518737;
        Sat, 27 Jun 2020 03:58:38 -0700 (PDT)
Received: from [192.168.43.84] ([5.100.193.85])
        by smtp.gmail.com with ESMTPSA id r1sm31647358wrt.73.2020.06.27.03.58.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 27 Jun 2020 03:58:38 -0700 (PDT)
To:     Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>
References: <421c3b22-2619-a9a2-a76e-ed8251c7264c@kernel.dk>
 <f6ad4ae4-dc7a-1f39-d4da-40b5d6c04d04@gmail.com>
 <22c72f8a-e80d-67ea-4f89-264238e5810d@kernel.dk>
 <7bfac3fc-22be-0ec7-fb7e-4fa714091ba9@gmail.com>
 <9f5cc1b3-637f-2caf-9808-1b11af46bfd3@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH] io_uring: use task_work for links if possible
Message-ID: <04acee78-83fb-5b24-07d5-a7d9b0a90133@gmail.com>
Date:   Sat, 27 Jun 2020 13:57:04 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <9f5cc1b3-637f-2caf-9808-1b11af46bfd3@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 27/06/2020 04:45, Jens Axboe wrote:
> On 6/26/20 3:20 PM, Pavel Begunkov wrote:
>>>>> +		tsk = io_wq_get_task(req->ctx->io_wq);
>>>>> +		task_work_add(tsk, &req->task_work, true);
>>>>> +	}
>>>>> +	wake_up_process(tsk);
>>>>> +}
>>>>> +
>>>>>  static void io_free_req(struct io_kiocb *req)
>>>>>  {
>>>>>  	struct io_kiocb *nxt = NULL;
>>>>> @@ -1671,8 +1758,12 @@ static void io_free_req(struct io_kiocb *req)
>>>>>  	io_req_find_next(req, &nxt);
>>>>>  	__io_free_req(req);
>>>>>  
>>>>> -	if (nxt)
>>>>> -		io_queue_async_work(nxt);
>>>>> +	if (nxt) {
>>>>> +		if (nxt->flags & REQ_F_WORK_INITIALIZED)
>>>>> +			io_queue_async_work(nxt);
>>>>
>>>> Don't think it will work. E.g. io_close_prep() may have set
>>>> REQ_F_WORK_INITIALIZED but without io_req_work_grab_env().
>>>
>>> This really doesn't change the existing path, it just makes sure we
>>> don't do io_req_task_queue() on something that has already modified
>>> ->work (and hence, ->task_work). This might miss cases where we have
>>> only cleared it and done nothing else, but that just means we'll have
>>> cases that we could potentially improve the effiency of down the line.
>>
>> Before the patch it was always initialising linked reqs, and that would
>> work ok, if not this lazy grab_env().
>>
>> E.g. req1 -> close_req
>>
>> It calls, io_req_defer_prep(__close_req__, sqe, __false__)
>> which doesn't do grab_env() because of for_async=false,
>> but calls io_close_prep() which sets REQ_F_WORK_INITIALIZED.
>>
>> Then, after completion of req1 it will follow added lines
>>
>> if (nxt)
>> 	if (nxt->flags & REQ_F_WORK_INITIALIZED)
>> 		io_queue_async_work(nxt);
>>
>> Ending up in
>>
>> io_queue_async_work()
>> 	-> grab_env()
>>
>> And that's who knows from which context.
>> E.g. req1 was an rw completed in an irq.
> 
> Hmm yes, good point, that is a problem. I don't have a good immediate
> solution for this. Do you have any suggestions on how best to handle
> this?

I certainly don't want another REQ_F_GRABBED_ENV flag :)

From the start I was planning to move all grab_env() calls to
io_queue_async_work() just before we're doing punting. like

io_queue_async_work(req) {
	// simplified
	for_each_in_link(req)
		grab_env();
	...
}

If done right, this can solve a lot of problems and simplify
lifetime management. There are much more problems, I'll send
a patchset with quick fixes, and then we can do it right
without hurry.

> 
>> Not sure it's related, but fallocate shows the log below, and some
>> other tests hang the kernel as well.
> 
> Yeah, that's indeed that very thing.

Turns out it's not.

> 
>>> True, that could be false instead.
>>>
>>> Since these are just minor things, we can do a fix on top. I don't want
>>> to reshuffle this unless I have to.
>>
>> Agree, I have a pile on top myself.
> 
> Fire away :-)

I prefer to have a working branch first.


-- 
Pavel Begunkov
