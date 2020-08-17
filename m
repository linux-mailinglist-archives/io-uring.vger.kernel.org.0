Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01CE7246442
	for <lists+io-uring@lfdr.de>; Mon, 17 Aug 2020 12:18:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726165AbgHQKSb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 17 Aug 2020 06:18:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726151AbgHQKSa (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 17 Aug 2020 06:18:30 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11CDFC061389
        for <io-uring@vger.kernel.org>; Mon, 17 Aug 2020 03:18:30 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id y2so7822552ljc.1
        for <io-uring@vger.kernel.org>; Mon, 17 Aug 2020 03:18:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=FLZ6yy+AH0nRQ/vomkC4UgMlQ0hHNtJQiswclyu94eg=;
        b=g498kPSKAVPw6kM2hFmMIiHV70e0bNxyyHoko2VMAcrxJwn82BIpQknfymIb5vzRfC
         QlDpYxTh1giFXbV20psgPQVi22lo9tnXQXtOoa7G2lww/a28GgR5VRS+hRe6dZ6Lh7Al
         pd6I7ENd0vwUlE6+5x8v9eostkroudCsYQq6AAIBiy9kYbG3UzLqWPF58g8HQ0tyxxhw
         GPqCpam2HcIxzH4P7RyyBKp4QmLDEF8gptxfL/MYluQQ/esOdADlJkeb2I6vJ/umUA47
         cuXSHSgU4Qk9+EH6Ovr2aEVnn6KpCx3IdbzUL16WZR/AiDJetzlYyrxxYJqMyePMkbT0
         O+fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=FLZ6yy+AH0nRQ/vomkC4UgMlQ0hHNtJQiswclyu94eg=;
        b=ObK6ThZWwQb9TWRcXu2FVuNeipi33q/nMrR4qR2Z39ujXl1OO6B8SE6E3Wz8YGcIRi
         iI9K1OAmeVjYTCiyYIvvJxyvFXe12fSjSesDQCKsbkV64W7szElO0GN5RQMTyVFWAhQ1
         Bz6/xKEeyevrnX5xgrkW0tlmU1eVovJAzm3SBBNs1kpGoqmMI1ihGbRvubysmqQIOCoV
         fimP6BQsW5o+/IngiYCLr6jAO2AcYM0BO+rnixilkZX9a3rYcK9aKFCzc5l6kCT1GQ5/
         fGfInJIOJYCscYiLiqOJMDeKNZLa7N4UeSo13HBlXzZzWlNXayqdwNKE9T2NCAKrxx8Q
         uB3g==
X-Gm-Message-State: AOAM5303HRDPJAdvkjRYvbdYRyZL1xRdLzXkD+T77o0kpsoqZivop4MN
        NycH8RVsC5X78uaF+jL8W1BHVt+BLuO7nw==
X-Google-Smtp-Source: ABdhPJzdqtrRgzUPdaouqyOVU3RtB6VkW48G18FhKFdOdHSaPdxDhYjsIwg1qIctYp5bS1AEJ0PnnA==
X-Received: by 2002:a2e:504a:: with SMTP id v10mr7423270ljd.428.1597659508470;
        Mon, 17 Aug 2020 03:18:28 -0700 (PDT)
Received: from [192.168.88.252] (n146-194.tmp.edunet.ru. [213.184.146.194])
        by smtp.gmail.com with ESMTPSA id k84sm5510787lfd.90.2020.08.17.03.18.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Aug 2020 03:18:28 -0700 (PDT)
To:     Jens Axboe <axboe@kernel.dk>, Josef <josef.grieb@gmail.com>,
        io-uring@vger.kernel.org
Cc:     norman@apache.org
References: <CAAss7+pf+CGQiSDM8_fhsHRwjWUxESPcJMhOOsDOitqePQxCrg@mail.gmail.com>
 <dc3562d8-dc67-c623-36ee-38885b4c1682@kernel.dk>
 <8e734ada-7f28-22df-5f30-027aca3695d1@gmail.com>
 <5fa9e01f-137d-b0f8-211a-975c7ed56419@gmail.com>
 <d0d1f797-c958-ac17-1f11-96f6ba6dbf37@gmail.com>
 <d0621b79-4277-a9ad-208e-b60153c08d15@kernel.dk>
 <bb45665c-1311-807d-5a03-459cf3cbd103@gmail.com>
 <d06c7f29-726b-d46a-8c51-0dc47ef374ad@kernel.dk>
 <63024e23-2b71-937a-6759-17916743c16c@gmail.com>
 <86295255-567d-e756-5ca3-138d349a5ea1@kernel.dk>
 <d2341bc7-e7c8-110f-e60c-39fc03c62160@kernel.dk>
 <67cf568c-27fc-d298-5267-1212f9421b74@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: io_uring process termination/killing is not working
Message-ID: <c416ed54-67d8-6f55-53e3-bad43e60b379@gmail.com>
Date:   Mon, 17 Aug 2020 13:16:21 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <67cf568c-27fc-d298-5267-1212f9421b74@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 16/08/2020 18:22, Jens Axboe wrote:
> On 8/16/20 7:53 AM, Jens Axboe wrote:
>> On 8/16/20 6:45 AM, Jens Axboe wrote:
>>> On 8/15/20 9:48 AM, Pavel Begunkov wrote:
>>>> On 15/08/2020 18:12, Jens Axboe wrote:
>>>>> On 8/15/20 12:45 AM, Pavel Begunkov wrote:
>>>>>> On 13/08/2020 02:32, Jens Axboe wrote:
>>>>>>> On 8/12/20 12:28 PM, Pavel Begunkov wrote:
>>>>>>>> On 12/08/2020 21:22, Pavel Begunkov wrote:
>>>>>>>>> On 12/08/2020 21:20, Pavel Begunkov wrote:
>>>>>>>>>> On 12/08/2020 21:05, Jens Axboe wrote:
>>>>>>>>>>> On 8/12/20 11:58 AM, Josef wrote:
>>>>>>>>>>>> Hi,
>>>>>>>>>>>>
>>>>>>>>>>>> I have a weird issue on kernel 5.8.0/5.8.1, SIGINT even SIGKILL
>>>>>>>>>>>> doesn't work to kill this process(always state D or D+), literally I
>>>>>>>>>>>> have to terminate my VM because even the kernel can't kill the process
>>>>>>>>>>>> and no issue on 5.7.12-201, however if IOSQE_IO_LINK is not set, it
>>>>>>>>>>>> works
>>>>>>>>>>>>
>>>>>>>>>>>> I've attached a file to reproduce it
>>>>>>>>>>>> or here
>>>>>>>>>>>> https://gist.github.com/1Jo1/15cb3c63439d0c08e3589cfa98418b2c
>>>>>>>>>>>
>>>>>>>>>>> Thanks, I'll take a look at this. It's stuck in uninterruptible
>>>>>>>>>>> state, which is why you can't kill it.
>>>>>>>>>>
>>>>>>>>>> It looks like one of the hangs I've been talking about a few days ago,
>>>>>>>>>> an accept is inflight but can't be found by cancel_files() because it's
>>>>>>>>>> in a link.
>>>>>>>>>
>>>>>>>>> BTW, I described it a month ago, there were more details.
>>>>>>>>
>>>>>>>> https://lore.kernel.org/io-uring/34eb5e5a-8d37-0cae-be6c-c6ac4d85b5d4@gmail.com
>>>>>>>
>>>>>>> Yeah I think you're right. How about something like the below? That'll
>>>>>>> potentially cancel more than just the one we're looking for, but seems
>>>>>>> kind of silly to only cancel from the file table holding request and to
>>>>>>> the end.
>>>>>>
>>>>>> The bug is not poll/t-out related, IIRC my test reproduces it with
>>>>>> read(pipe)->open(). See the previously sent link.
>>>>>
>>>>> Right, but in this context for poll, I just mean any request that has a
>>>>> poll handler armed. Not necessarily only a pure poll. The patch should
>>>>> fix your case, too.
>>>>
>>>> Ok. I was thinking about sleeping in io_read(), etc. from io-wq context.
>>>> That should have the same effect.
>>>
>>> We already cancel any blocking work for the exiting task - but we do
>>> that _after_ trying to cancel files, so we should probably just swap
>>> those around in io_uring_flush(). That'll remove any need to find and
>>> cancel those explicitly in io_uring_cancel_files().
>>
>> I guess there's still the case of the task just closing the fd, not
>> necessarily exiting. So I do agree with you that the io-wq case is still
>> unhandled. I'll take a look...

Right. It should be in the cancel code itself.
Thanks for dealing with this. It seems, you had a busy week with all
these syzkaller reports.


> 
> The below should do it.
> 
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index dc506b75659c..346a3eb84785 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -8063,6 +8063,33 @@ static bool io_timeout_remove_link(struct io_ring_ctx *ctx,
>  	return found;
>  }
>  
> +static bool io_cancel_link_cb(struct io_wq_work *work, void *data)
> +{
> +	return io_match_link(container_of(work, struct io_kiocb, work), data);
> +}
> +
> +static void io_attempt_cancel(struct io_ring_ctx *ctx, struct io_kiocb *req)
> +{
> +	enum io_wq_cancel cret;
> +
> +	/* cancel this particular work, if it's running */
> +	cret = io_wq_cancel_work(ctx->io_wq, &req->work);
> +	if (cret != IO_WQ_CANCEL_NOTFOUND)
> +		return;
> +
> +	/* find links that hold this pending, cancel those */
> +	cret = io_wq_cancel_cb(ctx->io_wq, io_cancel_link_cb, req, true);
> +	if (cret != IO_WQ_CANCEL_NOTFOUND)
> +		return;
> +
> +	/* if we have a poll link holding this pending, cancel that */
> +	if (io_poll_remove_link(ctx, req))
> +		return;
> +
> +	/* final option, timeout link is holding this req pending */
> +	io_timeout_remove_link(ctx, req);
> +}
> +
>  static void io_uring_cancel_files(struct io_ring_ctx *ctx,
>  				  struct files_struct *files)
>  {
> @@ -8116,10 +8143,8 @@ static void io_uring_cancel_files(struct io_ring_ctx *ctx,
>  				continue;
>  			}
>  		} else {
> -			io_wq_cancel_work(ctx->io_wq, &cancel_req->work);
> -			/* could be a link, check and remove if it is */
> -			if (!io_poll_remove_link(ctx, cancel_req))
> -				io_timeout_remove_link(ctx, cancel_req);
> +			/* cancel this request, or head link requests */
> +			io_attempt_cancel(ctx, cancel_req);
>  			io_put_req(cancel_req);
>  		}
>  
> 

-- 
Pavel Begunkov
