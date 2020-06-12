Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 029C11F7CF1
	for <lists+io-uring@lfdr.de>; Fri, 12 Jun 2020 20:34:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726314AbgFLSe4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 12 Jun 2020 14:34:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726309AbgFLSez (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 12 Jun 2020 14:34:55 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D242C03E96F
        for <io-uring@vger.kernel.org>; Fri, 12 Jun 2020 11:34:54 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id e1so10714594wrt.5
        for <io-uring@vger.kernel.org>; Fri, 12 Jun 2020 11:34:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=l/dB+QWgc+Fdxa7qes7DhUkU3dSA3wAC+6M2XGNbzsc=;
        b=XhnEHA/Gr2AdxgP3nrG9ZIfgQHYSTbGMSi0uPrY8wFlIX1TGHGBijIxLo/eNrP/AUJ
         pfr//RCn1nt5eFCgRfsmRnwR+QfOyy1odrz81BFK7co/Ja3XguFpPshceg6nAG81RTjq
         Cj3w1WSduhGKdP6ynsue3NjTaAS+QsvpW3pws8M52h8H7kBw+HSgRE2MxYWDiW5BR4ks
         hJjUS6o/t82ekrRWgcoIc3jynqgSzI8T50HE3HZtMJhllJKReHiXFUjOIlfIODpEZEqQ
         4bhwGcA63hnsUoupG0Z5vhu5EiX9Cqd5Qazvze6KJVfmqM/uBoVbDyinfpmwWAvKlKmj
         VqDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:autocrypt:subject:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=l/dB+QWgc+Fdxa7qes7DhUkU3dSA3wAC+6M2XGNbzsc=;
        b=tjarf4mCmqzhE/Rk/WmrmzgMJt2ovuBiYWdRCb9SXKkxgfax6M6k6G7a+PKll9xdCY
         3k9CMAOwmZyMS0YB/zAFBA81syg5VDc6S+MMK8Fah2V3Q1gBS7JA2M3cTr6WoN2e7mfe
         aDbj0/CIOVU3jykAL57aIZv9iBMBfTywmYmrCyFi7tuOUYKAIuGIkUZlyLNIdI+omYxw
         YAbEmj6WMxEvxw32nie/6JBRIXDWuV5vSDw13BDchm4R7vyLL0Mqaq01NcQqz+Br59eX
         57bMb5X+rHdfoeQu4MK1Cw2LL0jhdGdN1oRgcqhKftXzR8kYk/ZuqdQe7DCPXBQO0IWU
         R/Vg==
X-Gm-Message-State: AOAM532pPOtrpiYkF7+pYcJV4MPsmuHGedlzxRV/PjCrZDDaxoMKEkov
        VdfKLzTRnxf5Ne44FnciYxCf0rqo
X-Google-Smtp-Source: ABdhPJyaBLCs5zLYJ2/tFUtj85zqw0aBXjV6Lcbq2DyTOBlBWuIlUnhmKBAHFiCFaSYqT5186rljVw==
X-Received: by 2002:adf:b34e:: with SMTP id k14mr16384258wrd.109.1591986892620;
        Fri, 12 Jun 2020 11:34:52 -0700 (PDT)
Received: from [192.168.43.114] ([5.100.193.151])
        by smtp.gmail.com with ESMTPSA id z7sm11261276wrt.6.2020.06.12.11.34.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Jun 2020 11:34:52 -0700 (PDT)
To:     Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>
References: <12b44e81-332e-e53c-b5fa-09b7bf9cc082@gmail.com>
 <6f6e1aa2-87f6-b853-5009-bf0961065036@kernel.dk>
 <5347123a-a0d5-62cf-acdf-6b64083bdc74@gmail.com>
 <c93fa05c-18ef-2ebe-2d8a-ca578bd648da@kernel.dk>
 <868c9ef4-ab31-8c63-cace-9fd99c58cbb2@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [RFC] do_iopoll() and *grab_env()
Message-ID: <3688a25e-c405-309f-cc87-96596a5d0ed2@gmail.com>
Date:   Fri, 12 Jun 2020 21:33:28 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <868c9ef4-ab31-8c63-cace-9fd99c58cbb2@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/06/2020 21:02, Jens Axboe wrote:
> On 6/12/20 11:55 AM, Jens Axboe wrote:
>> On 6/12/20 11:30 AM, Pavel Begunkov wrote:
>>> On 12/06/2020 20:02, Jens Axboe wrote:
>>>> On 6/11/20 9:54 AM, Pavel Begunkov wrote:
>>>>> io_do_iopoll() can async punt a request with io_queue_async_work(),
>>>>> so doing io_req_work_grab_env(). The problem is that iopoll() can
>>>>> be called from who knows what context, e.g. from a completely
>>>>> different process with its own memory space, creds, etc.
>>>>>
>>>>> io_do_iopoll() {
>>>>> 	ret = req->poll();
>>>>> 	if (ret == -EAGAIN)
>>>>> 		io_queue_async_work()
>>>>> 	...
>>>>> }
>>>>>
>>>>>
>>>>> I can't find it handled in io_uring. Can this even happen?
>>>>> Wouldn't it be better to complete them with -EAGAIN?
>>>>
>>>> I don't think a plain -EAGAIN complete would be very useful, it's kind
>>>> of a shitty thing to pass back to userspace when it can be avoided. For
>>>> polled IO, we know we're doing O_DIRECT, or using fixed buffers. For the
>>>> latter, there's no problem in retrying, regardless of context. For the
>>>> former, I think we'd get -EFAULT mapping the IO at that point, which is
>>>> probably reasonable. I'd need to double check, though.
>>>
>>> It's shitty, but -EFAULT is the best outcome. I care more about not
>>> corrupting another process' memory if addresses coincide. AFAIK it can
>>> happen because io_{read,write} will use iovecs for punted re-submission.
>>>
>>>
>>> Unconditional in advance async_prep() is too heavy to be good. I'd love to
>>> see something more clever, but with -EAGAIN users at least can handle it.
>>
>> So how about we just grab ->task for the initial issue, and retry if we
>> find it through -EAGAIN and ->task == current. That'll be the most
>> common case, by far, and it'll prevent passes back -EAGAIN when we
>> really don't have to. If the task is different, then -EAGAIN makes more
>> sense, because at that point we're passing back -EAGAIN because we
>> really cannot feasibly handle it rather than just as a convenience.

Yeah, I was even thinking to drag it through task_work just to call
*grab_env() there. Looks reasonable to me.

> Something like this, totally untested. And wants a comment too.

Looks like it. Would you leave this to me? There is another issue with
cancellation requiring ->task, It'd be easier to keep them together.

> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 155f3d830ddb..15806f71b33e 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -1727,6 +1728,12 @@ static int io_put_kbuf(struct io_kiocb *req)
>  	return cflags;
>  }
>  
> +static inline void req_set_fail_links(struct io_kiocb *req)
> +{
> +	if ((req->flags & (REQ_F_LINK | REQ_F_HARDLINK)) == REQ_F_LINK)
> +		req->flags |= REQ_F_FAIL_LINK;
> +}
> +
>  /*
>   * Find and free completed poll iocbs
>   */
> @@ -1767,8 +1774,14 @@ static void io_iopoll_queue(struct list_head *again)
>  	do {
>  		req = list_first_entry(again, struct io_kiocb, list);
>  		list_del(&req->list);
> -		refcount_inc(&req->refs);
> -		io_queue_async_work(req);
> +		if (req->task == current) {
> +			refcount_inc(&req->refs);
> +			io_queue_async_work(req);
> +		} else {
> +			io_cqring_add_event(req, -EAGAIN);
> +			req_set_fail_links(req);
> +			io_put_req(req);
> +		}
>  	} while (!list_empty(again));
>  }
>  
> @@ -1937,12 +1950,6 @@ static void kiocb_end_write(struct io_kiocb *req)
>  	file_end_write(req->file);
>  }
>  
> -static inline void req_set_fail_links(struct io_kiocb *req)
> -{
> -	if ((req->flags & (REQ_F_LINK | REQ_F_HARDLINK)) == REQ_F_LINK)
> -		req->flags |= REQ_F_FAIL_LINK;
> -}
> -
>  static void io_complete_rw_common(struct kiocb *kiocb, long res)
>  {
>  	struct io_kiocb *req = container_of(kiocb, struct io_kiocb, rw.kiocb);
> @@ -2137,6 +2144,8 @@ static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe,
>  
>  		kiocb->ki_flags |= IOCB_HIPRI;
>  		kiocb->ki_complete = io_complete_rw_iopoll;
> +		req->task = current;
> +		get_task_struct(current);
>  		req->result = 0;
>  		req->iopoll_completed = 0;
>  	} else {
> 

-- 
Pavel Begunkov
