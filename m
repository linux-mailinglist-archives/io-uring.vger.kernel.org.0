Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FF8028187C
	for <lists+io-uring@lfdr.de>; Fri,  2 Oct 2020 19:01:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726051AbgJBRBy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 2 Oct 2020 13:01:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725991AbgJBRBy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 2 Oct 2020 13:01:54 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19A1BC0613D0
        for <io-uring@vger.kernel.org>; Fri,  2 Oct 2020 10:01:53 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id u9so1872443ilj.7
        for <io-uring@vger.kernel.org>; Fri, 02 Oct 2020 10:01:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=jxMBZgPUpHeZ3jLSKcbP6oTN8G4npLJG4TcX7eHr1mo=;
        b=DUqXuQiqpBqOZOJ2uIi08Qi+r6QLTXMfrhIdXChXwCKR7i61CGWZxDmjOOZ7fsCotl
         5bmblC918XDz4GVk0PCCsgjh3qnAZPCMOrJU3cR4DrksPWsLs+FerWm9GkTjsGw+lvVj
         naxZYFQvJW5JHfZZ+6TqrnQPIJvul1/xK9KS+d3jG69D5UKOT8hJjmmk2+9gB7NpmRvZ
         DMYuBtfpiimPoPhLHOvBvD3DnQvRwDVpQnQJ9wUcRLjCU2nGNPbxO5Iw6hQ4l8pvt6qt
         CrgP2KAygrw5TCKLnaaGBMc/IVnprAUzE4StQzS8WIgGG1aF0U8ZnJK32CI6jiTh+vmK
         smoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jxMBZgPUpHeZ3jLSKcbP6oTN8G4npLJG4TcX7eHr1mo=;
        b=sExHX26hrj9mxXHkno7ZVkCDZit/x00A1+9Ex67YFrFld7p2//orm6lEXRggg6Ylr7
         mh1boG4r5xY42UOvUDwVJB7CqwPTbHrzlS1fluZFIleMjnqJ3It5MoZP7LaFyLmM7+Tm
         6SPUgiIxuxQqcezCQ5u6LWJPma80NdASEpl9ktgvylsUsjTXrLdRADRhjD654XbFuf45
         f+tqr0dm+xVzoleZzGGfF3Ydpiw3Qh/ZHqorHdGbKRESAVEMFGrYmZ3Pcgo7XvAHIC/D
         tHHZhKd8mht/egXNPWmwVAI+3D+sdRYWSAuiOGxg0N6RNxLmz3s0Bon1X5aDPjTL+WPg
         9Y0A==
X-Gm-Message-State: AOAM531AACF+lTMeE1D9zZIZJKVB6F6MxcHfM+0kilIi0Fj7ho9dmKr3
        Org3P470VPB0UmICro37JjBNF9OVxhdvJg==
X-Google-Smtp-Source: ABdhPJw12OWt3US5ZY4Qw9iCSzE/G7wGfaHJmxQfjpf4XVn7mag+gBEwZcqfceMQZwI7qQovFeLz0Q==
X-Received: by 2002:a05:6e02:249:: with SMTP id w9mr2428172ilr.188.1601658111162;
        Fri, 02 Oct 2020 10:01:51 -0700 (PDT)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id i19sm1068213ile.72.2020.10.02.10.01.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Oct 2020 10:01:50 -0700 (PDT)
Subject: Re: [PATCH 1/5] io_uring: grab any needed state during defer prep
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <20200914162555.1502094-1-axboe@kernel.dk>
 <20200914162555.1502094-2-axboe@kernel.dk>
 <77283ddd-77d9-41e1-31d2-2b9734ee2388@gmail.com>
 <79e9d619-882b-8915-32df-ced1886e1eb3@gmail.com>
 <f61a349a-8348-04a3-fc4d-0a15344664fd@gmail.com>
 <6f514236-a584-e333-3ce2-8fd63c69c9c3@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <f95eb757-795a-adcc-e4ea-e0a783d62a29@kernel.dk>
Date:   Fri, 2 Oct 2020 11:01:50 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <6f514236-a584-e333-3ce2-8fd63c69c9c3@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/2/20 10:34 AM, Pavel Begunkov wrote:
> On 02/10/2020 19:14, Pavel Begunkov wrote:
>> On 19/09/2020 19:56, Pavel Begunkov wrote:
>>> On 19/09/2020 18:27, Pavel Begunkov wrote:
>>>> On 14/09/2020 19:25, Jens Axboe wrote:
>>>>> Always grab work environment for deferred links. The assumption that we
>>>>> will be running it always from the task in question is false, as exiting
>>>>> tasks may mean that we're deferring this one to a thread helper. And at
>>>>> that point it's too late to grab the work environment.
>>> Forgot that they will be cancelled there. So, how it could happen?
>>> Is that the initial thread will run task_work but loosing
>>> some resources like mm prior to that? e.g. in do_exit()
>>
>> Jens, please let me know when you get time for that. I was thinking that
>> you were meaning do_exit(), which does task_work_run() after killing mm,
>> etc., but you mentioned a thread helper in the description... Which one
>> do you mean?
> 
> Either it refers to stuff after io_ring_ctx_wait_and_kill(), which
> delegates the rest to io_ring_exit_work() via @system_unbound_wq.

We punt the request to task_work. task_work is run, we're still in the
right context. We fail with -EAGAIN, and then call io_queue_async_work()
and we're not doing async prep at that point.

-- 
Jens Axboe

