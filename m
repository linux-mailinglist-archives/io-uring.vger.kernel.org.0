Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FB041F7D20
	for <lists+io-uring@lfdr.de>; Fri, 12 Jun 2020 20:48:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726286AbgFLSsX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 12 Jun 2020 14:48:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726268AbgFLSsX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 12 Jun 2020 14:48:23 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE8B6C03E96F
        for <io-uring@vger.kernel.org>; Fri, 12 Jun 2020 11:48:22 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id f7so11095677ejq.6
        for <io-uring@vger.kernel.org>; Fri, 12 Jun 2020 11:48:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:references:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=uiLF5rezdeianvYy1YWUJTNFWX4DwWDd279UOnYQuYg=;
        b=s1Y9wpYzYa+8OnIi1waFkXWlBFvVzOrXJRqWGw3TOhXCidnfiuVa+txFaIwrqLGWxx
         Gd1OXBLIgka74d5OusmwkaJGFfP1x5XQgFO/KEgHXTvjfs3eYZCMjIG0pqq5+9J1pWaQ
         3BW2ei3IZj58WJFoIj+cFT5goICG2yYPwGtxySyJcBwNK7ruddn0eYUKdfBfM3VW5w+s
         yzAb8LPqbo8gK0e/04puaKgRLmKE5+yy80a62q3wljXyTG9a7EeYSqldb3MR9vvzqrPo
         sBUm5sX0sJgLV9K0oRVj8UGgECKjpiEc+Y+NWY60C8oD+QG8OdAIe32vA68dxW9BZFhK
         c20w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:references:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=uiLF5rezdeianvYy1YWUJTNFWX4DwWDd279UOnYQuYg=;
        b=VJMLALACnRTFDhvs5n9bj4GHOb7Q/i7Y5rc8XXeDkBXUgtgNAgJoNzIP4cmkmnQiEb
         +K88JoMfnuEP5M81D8jyH1phGOtluCUsr3dBUPT5/QI5GHkaRCldNLu2C+HifkMVGEsn
         BxO18nqOKWgJTytH4jqxI8tnUFmGI5ZGecd+0IlO1/1/RGq7DYnzp/XxkKfK32yxmQNj
         y4Ic7cubPMWUliDsHKtMewS6UMtLZ0VxoE3iFcMyZ22XYGjk8XtX7l724xvOcO0hrycQ
         Vq5ixCrQ8tSoBq2GT0+BVViIvLHxTt8QgIzDQ38XZfbGpzIsMX88GBdDlsFVADOiJYTD
         Fesg==
X-Gm-Message-State: AOAM531ZO5WpIsgehfM1RlH+HnIy6SAP7K3utHc//57sTV5TNv4LinaC
        /Qtqt6DWFkO2F8E2+Homj/SvfLyG
X-Google-Smtp-Source: ABdhPJz9TPzdbMAufVL2J7A7cXo+pRLucKklZtMKLkcxQYwAuXDJ2wV5E9NoKceYDG7E+HGKzYKfgA==
X-Received: by 2002:a17:906:b207:: with SMTP id p7mr1945560ejz.23.1591987700955;
        Fri, 12 Jun 2020 11:48:20 -0700 (PDT)
Received: from [192.168.43.114] ([5.100.193.151])
        by smtp.gmail.com with ESMTPSA id j31sm3615822edb.12.2020.06.12.11.48.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Jun 2020 11:48:20 -0700 (PDT)
Subject: Re: [RFC] do_iopoll() and *grab_env()
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>
References: <12b44e81-332e-e53c-b5fa-09b7bf9cc082@gmail.com>
 <6f6e1aa2-87f6-b853-5009-bf0961065036@kernel.dk>
 <5347123a-a0d5-62cf-acdf-6b64083bdc74@gmail.com>
 <c93fa05c-18ef-2ebe-2d8a-ca578bd648da@kernel.dk>
 <868c9ef4-ab31-8c63-cace-9fd99c58cbb2@kernel.dk>
 <3688a25e-c405-309f-cc87-96596a5d0ed2@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <cac2fead-cd42-28a2-0454-35923028651d@gmail.com>
Date:   Fri, 12 Jun 2020 21:46:56 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <3688a25e-c405-309f-cc87-96596a5d0ed2@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/06/2020 21:33, Pavel Begunkov wrote:
> On 12/06/2020 21:02, Jens Axboe wrote:
>> On 6/12/20 11:55 AM, Jens Axboe wrote:
>>> On 6/12/20 11:30 AM, Pavel Begunkov wrote:
>>>> On 12/06/2020 20:02, Jens Axboe wrote:
>>>>> On 6/11/20 9:54 AM, Pavel Begunkov wrote:
>>>>>> io_do_iopoll() can async punt a request with io_queue_async_work(),
>>>>>> so doing io_req_work_grab_env(). The problem is that iopoll() can
>>>>>> be called from who knows what context, e.g. from a completely
>>>>>> different process with its own memory space, creds, etc.
>>>>>>
>>>>>> io_do_iopoll() {
>>>>>> 	ret = req->poll();
>>>>>> 	if (ret == -EAGAIN)
>>>>>> 		io_queue_async_work()
>>>>>> 	...
>>>>>> }
>>>>>>
>>>>>>
>>>>>> I can't find it handled in io_uring. Can this even happen?
>>>>>> Wouldn't it be better to complete them with -EAGAIN?
>>>>>
>>>>> I don't think a plain -EAGAIN complete would be very useful, it's kind
>>>>> of a shitty thing to pass back to userspace when it can be avoided. For
>>>>> polled IO, we know we're doing O_DIRECT, or using fixed buffers. For the
>>>>> latter, there's no problem in retrying, regardless of context. For the
>>>>> former, I think we'd get -EFAULT mapping the IO at that point, which is
>>>>> probably reasonable. I'd need to double check, though.
>>>>
>>>> It's shitty, but -EFAULT is the best outcome. I care more about not
>>>> corrupting another process' memory if addresses coincide. AFAIK it can
>>>> happen because io_{read,write} will use iovecs for punted re-submission.
>>>>
>>>>
>>>> Unconditional in advance async_prep() is too heavy to be good. I'd love to
>>>> see something more clever, but with -EAGAIN users at least can handle it.
>>>
>>> So how about we just grab ->task for the initial issue, and retry if we
>>> find it through -EAGAIN and ->task == current. That'll be the most
>>> common case, by far, and it'll prevent passes back -EAGAIN when we
>>> really don't have to. If the task is different, then -EAGAIN makes more
>>> sense, because at that point we're passing back -EAGAIN because we
>>> really cannot feasibly handle it rather than just as a convenience.
> 
> Yeah, I was even thinking to drag it through task_work just to call
> *grab_env() there. Looks reasonable to me.

edit: *Yours looks reasonable*.
task_work is too cumbersome for such a small nuisance.

> 
>> Something like this, totally untested. And wants a comment too.
> 
> Looks like it. Would you leave this to me? There is another issue with
> cancellation requiring ->task, It'd be easier to keep them together.
> 

-- 
Pavel Begunkov
