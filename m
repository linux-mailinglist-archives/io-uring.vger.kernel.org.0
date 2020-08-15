Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED4032452A9
	for <lists+io-uring@lfdr.de>; Sat, 15 Aug 2020 23:54:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728134AbgHOVyH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 15 Aug 2020 17:54:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729124AbgHOVwg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 15 Aug 2020 17:52:36 -0400
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16A12C03B3C2
        for <io-uring@vger.kernel.org>; Sat, 15 Aug 2020 00:47:45 -0700 (PDT)
Received: by mail-lf1-x142.google.com with SMTP id d2so5952007lfj.1
        for <io-uring@vger.kernel.org>; Sat, 15 Aug 2020 00:47:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=220DrzWX9UQIkTlyPkMIogTDHSukHbACTMIrhyE83U4=;
        b=UfHv4pxfUgDjhu939fYAo4POSpGawt6WGT0fWt68XVSg7ol4SIw013wDwtrPPXt0WN
         vK9d982A5/xCDsuXmNsRKwBTCN5HOpuT2MiXNTtDCzNe6Gbp3xV0MgoyotHxEQ09PTgC
         n01ZkHcH0Dus32/AXkZPYVUsDijXNY/mMbeByDKuUECENfZrT35cGjw8Tt84rxhOm47l
         e4o21UdeSR1z1H+uOpGvxRXAUKPuyCuLLSYYvlXpKXy6C11r2AnQ+ll94r4yGZDos7Lu
         rmGnTmqXIGap6MYWp4Kp4Jbm4/L3xdWi4JkRDF/W7j15WGL0/KjcxvpWcpoKtAvD+7wh
         dH6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=220DrzWX9UQIkTlyPkMIogTDHSukHbACTMIrhyE83U4=;
        b=fo5wAMZ/HwgqwFJk+NloCk95oTuY3brmYD9SL9ll0J5bjDNQU1fuuzj1tJb2Ak0OO8
         6bMF/pYPUBfbCUFsZ7pdebZj+qnYz3v31M545yBq3GECnSPeU3sfvBkuJy+I601hGzdN
         poRfNlpEdkztdhkuScCXFEDM6CwoHpzYYmrh0/ACI9nEu6elqO/3SO2U0tI8hu/be8FT
         G0fwSoU1bRz38BM1zs5wRgse/lIrLe8iN1kuvK6YV5dXzNUWctt3/sjqPewZzuNU6QpE
         AcQAsP8ecJdOQ/yJhRSNrgpJnNgxEWM8/HWOCM0PW8h/1f9mIYctKIhyOITkhyyr3NoP
         pCbg==
X-Gm-Message-State: AOAM533G325PudX1kOPN1I3p3x1sz98BhvX+bhhqO27LjfKiD0Vy4CcJ
        ju4/q2Kuqs2n2VBt6BgR6J0=
X-Google-Smtp-Source: ABdhPJwwOe9or2VHYCfxB++q3HSp7vkqdMP6tcSrQvxp6S+dKEc32WAR3rJCwGpFPZeh0rsmkCRDLQ==
X-Received: by 2002:a19:c3d0:: with SMTP id t199mr2898990lff.56.1597477662837;
        Sat, 15 Aug 2020 00:47:42 -0700 (PDT)
Received: from [10.101.3.10] (h86-62-88-107.ln.rinet.ru. [86.62.88.107])
        by smtp.gmail.com with ESMTPSA id s12sm2240202ljd.116.2020.08.15.00.47.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 15 Aug 2020 00:47:42 -0700 (PDT)
To:     Jens Axboe <axboe@kernel.dk>, Josef <josef.grieb@gmail.com>,
        io-uring@vger.kernel.org
Cc:     norman@apache.org
References: <CAAss7+pf+CGQiSDM8_fhsHRwjWUxESPcJMhOOsDOitqePQxCrg@mail.gmail.com>
 <dc3562d8-dc67-c623-36ee-38885b4c1682@kernel.dk>
 <8e734ada-7f28-22df-5f30-027aca3695d1@gmail.com>
 <5fa9e01f-137d-b0f8-211a-975c7ed56419@gmail.com>
 <d0d1f797-c958-ac17-1f11-96f6ba6dbf37@gmail.com>
 <d0621b79-4277-a9ad-208e-b60153c08d15@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: io_uring process termination/killing is not working
Message-ID: <bb45665c-1311-807d-5a03-459cf3cbd103@gmail.com>
Date:   Sat, 15 Aug 2020 10:45:36 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <d0621b79-4277-a9ad-208e-b60153c08d15@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 13/08/2020 02:32, Jens Axboe wrote:
> On 8/12/20 12:28 PM, Pavel Begunkov wrote:
>> On 12/08/2020 21:22, Pavel Begunkov wrote:
>>> On 12/08/2020 21:20, Pavel Begunkov wrote:
>>>> On 12/08/2020 21:05, Jens Axboe wrote:
>>>>> On 8/12/20 11:58 AM, Josef wrote:
>>>>>> Hi,
>>>>>>
>>>>>> I have a weird issue on kernel 5.8.0/5.8.1, SIGINT even SIGKILL
>>>>>> doesn't work to kill this process(always state D or D+), literally I
>>>>>> have to terminate my VM because even the kernel can't kill the process
>>>>>> and no issue on 5.7.12-201, however if IOSQE_IO_LINK is not set, it
>>>>>> works
>>>>>>
>>>>>> I've attached a file to reproduce it
>>>>>> or here
>>>>>> https://gist.github.com/1Jo1/15cb3c63439d0c08e3589cfa98418b2c
>>>>>
>>>>> Thanks, I'll take a look at this. It's stuck in uninterruptible
>>>>> state, which is why you can't kill it.
>>>>
>>>> It looks like one of the hangs I've been talking about a few days ago,
>>>> an accept is inflight but can't be found by cancel_files() because it's
>>>> in a link.
>>>
>>> BTW, I described it a month ago, there were more details.
>>
>> https://lore.kernel.org/io-uring/34eb5e5a-8d37-0cae-be6c-c6ac4d85b5d4@gmail.com
> 
> Yeah I think you're right. How about something like the below? That'll
> potentially cancel more than just the one we're looking for, but seems
> kind of silly to only cancel from the file table holding request and to
> the end.

The bug is not poll/t-out related, IIRC my test reproduces it with
read(pipe)->open(). See the previously sent link.

As mentioned, I'm going to patch that up, if you won't beat me on that.

> 
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 8a2afd8c33c9..0630a9622baa 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -4937,6 +5003,7 @@ static bool io_poll_remove_one(struct io_kiocb *req)
>  		io_cqring_fill_event(req, -ECANCELED);
>  		io_commit_cqring(req->ctx);
>  		req->flags |= REQ_F_COMP_LOCKED;
> +		req_set_fail_links(req);
>  		io_put_req(req);
>  	}
>  
> @@ -7935,6 +8002,47 @@ static bool io_wq_files_match(struct io_wq_work *work, void *data)
>  	return work->files == files;
>  }
>  
> +static bool __io_poll_remove_link(struct io_kiocb *preq, struct io_kiocb *req)
> +{
> +	struct io_kiocb *link;
> +
> +	if (!(preq->flags & REQ_F_LINK_HEAD))
> +		return false;
> +
> +	list_for_each_entry(link, &preq->link_list, link_list) {
> +		if (link != req)
> +			break;
> +		io_poll_remove_one(preq);
> +		return true;
> +	}
> +
> +	return false;
> +}
> +
> +/*
> + * We're looking to cancel 'req' because it's holding on to our files, but
> + * 'req' could be a link to another request. See if it is, and cancel that
> + * parent request if so.
> + */
> +static void io_poll_remove_link(struct io_ring_ctx *ctx, struct io_kiocb *req)
> +{
> +	struct hlist_node *tmp;
> +	struct io_kiocb *preq;
> +	int i;
> +
> +	spin_lock_irq(&ctx->completion_lock);
> +	for (i = 0; i < (1U << ctx->cancel_hash_bits); i++) {
> +		struct hlist_head *list;
> +
> +		list = &ctx->cancel_hash[i];
> +		hlist_for_each_entry_safe(preq, tmp, list, hash_node) {
> +			if (__io_poll_remove_link(preq, req))
> +				break;
> +		}
> +	}
> +	spin_unlock_irq(&ctx->completion_lock);
> +}
> +
>  static void io_uring_cancel_files(struct io_ring_ctx *ctx,
>  				  struct files_struct *files)
>  {
> @@ -7989,6 +8097,8 @@ static void io_uring_cancel_files(struct io_ring_ctx *ctx,
>  			}
>  		} else {
>  			io_wq_cancel_work(ctx->io_wq, &cancel_req->work);
> +			/* could be a link, check and remove if it is */
> +			io_poll_remove_link(ctx, cancel_req);
>  			io_put_req(cancel_req);
>  		}
>  
> 

-- 
Pavel Begunkov
