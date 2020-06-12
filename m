Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13F671F7CAF
	for <lists+io-uring@lfdr.de>; Fri, 12 Jun 2020 19:56:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726108AbgFLR4B (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 12 Jun 2020 13:56:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726085AbgFLR4B (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 12 Jun 2020 13:56:01 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 523BAC08C5C2
        for <io-uring@vger.kernel.org>; Fri, 12 Jun 2020 10:56:00 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id t16so4034987plo.7
        for <io-uring@vger.kernel.org>; Fri, 12 Jun 2020 10:56:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=gLo2x0x2rDdl3zXnE1zVbqgoGUm71mosiD7Tv2fmqXo=;
        b=gQSjvqVZS1HQw6i8oasZdQbHhEAs/LKmLAed8vzHohJiOTmftuqLAnttc1ei6HpbvC
         EEhQVJeWJ5QYTvM2lFhlXE9n8Xrwh66Y+jauj5LH55yMVJ55uQU/4nyfVPyrk1kED2DK
         +PQOxjrXH0T3LO0T7weEUXJFx6s+/XT8Uki40tV0IIoqoF6Pr9wZDIPyIDOaDvra/3X2
         XcxXuxL+58060MfhAInxCMfOKFBiSgTTAq35klKUJo2jz4MzsA/BdOSeDLQ+OgCXzNqa
         wEtDsw/YALkvgyfVacUZEZtx+bMhW+sNVZuzKS6aAZmDUncVrCdVbyADVa4QZR9Y5oLM
         PcAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gLo2x0x2rDdl3zXnE1zVbqgoGUm71mosiD7Tv2fmqXo=;
        b=AOlQdqUtcDqaHAx0fd9QKwFwgoGYrS4VesIWpT0wuHgr+svvaVYh+OOKAwf2VYYh4D
         Owfwzn5kH1W4Q4Wr99ieJlzGin9akVz/1bBUiD15DxtEe74y+F1OsNC3vSOVu+Kp5W26
         ERfXjN+7v4YVRETXH75IL91vQW8xLZHdQF7g18j5sWdG8fvNY95dGscAvqpQsyRZ+owi
         9ITzc55ZpauUkunpjNAirDaDYniOI5XyfBzcn99r24kRFo+AFpEvuo6g5WisvjJa4FmT
         AoY+Fp6o/B9zh13/bc+L5A/svEU1RbQYEQEffzt+kM5lKegGg0XCptjrShCg2R4ZMm7b
         WSng==
X-Gm-Message-State: AOAM531HNAQKiGtg4M5ZpCIL7Al+WU5Rn1drF6N+q8dS/DihX8V0MJTG
        jlwTPFz4+t/s+qwCgwdaJ6IdCRZBtf5HCA==
X-Google-Smtp-Source: ABdhPJyLBfL/ZyPSgFVXMm/7OufmPV2Z6CRwPhXG9pS6GS7pZoVn/8lFdiU3STmssh0pWuctxQuQRw==
X-Received: by 2002:a17:902:fe95:: with SMTP id x21mr12617041plm.17.1591984559283;
        Fri, 12 Jun 2020 10:55:59 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id 9sm6820251pfu.181.2020.06.12.10.55.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Jun 2020 10:55:58 -0700 (PDT)
Subject: Re: [RFC] do_iopoll() and *grab_env()
To:     Pavel Begunkov <asml.silence@gmail.com>,
        io-uring <io-uring@vger.kernel.org>
References: <12b44e81-332e-e53c-b5fa-09b7bf9cc082@gmail.com>
 <6f6e1aa2-87f6-b853-5009-bf0961065036@kernel.dk>
 <5347123a-a0d5-62cf-acdf-6b64083bdc74@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <c93fa05c-18ef-2ebe-2d8a-ca578bd648da@kernel.dk>
Date:   Fri, 12 Jun 2020 11:55:57 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <5347123a-a0d5-62cf-acdf-6b64083bdc74@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/12/20 11:30 AM, Pavel Begunkov wrote:
> On 12/06/2020 20:02, Jens Axboe wrote:
>> On 6/11/20 9:54 AM, Pavel Begunkov wrote:
>>> io_do_iopoll() can async punt a request with io_queue_async_work(),
>>> so doing io_req_work_grab_env(). The problem is that iopoll() can
>>> be called from who knows what context, e.g. from a completely
>>> different process with its own memory space, creds, etc.
>>>
>>> io_do_iopoll() {
>>> 	ret = req->poll();
>>> 	if (ret == -EAGAIN)
>>> 		io_queue_async_work()
>>> 	...
>>> }
>>>
>>>
>>> I can't find it handled in io_uring. Can this even happen?
>>> Wouldn't it be better to complete them with -EAGAIN?
>>
>> I don't think a plain -EAGAIN complete would be very useful, it's kind
>> of a shitty thing to pass back to userspace when it can be avoided. For
>> polled IO, we know we're doing O_DIRECT, or using fixed buffers. For the
>> latter, there's no problem in retrying, regardless of context. For the
>> former, I think we'd get -EFAULT mapping the IO at that point, which is
>> probably reasonable. I'd need to double check, though.
> 
> It's shitty, but -EFAULT is the best outcome. I care more about not
> corrupting another process' memory if addresses coincide. AFAIK it can
> happen because io_{read,write} will use iovecs for punted re-submission.
>
> 
> Unconditional in advance async_prep() is too heavy to be good. I'd love to
> see something more clever, but with -EAGAIN users at least can handle it.

So how about we just grab ->task for the initial issue, and retry if we
find it through -EAGAIN and ->task == current. That'll be the most
common case, by far, and it'll prevent passes back -EAGAIN when we
really don't have to. If the task is different, then -EAGAIN makes more
sense, because at that point we're passing back -EAGAIN because we
really cannot feasibly handle it rather than just as a convenience.

-- 
Jens Axboe

