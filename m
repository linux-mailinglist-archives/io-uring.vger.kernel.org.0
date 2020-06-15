Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABB691F9B4E
	for <lists+io-uring@lfdr.de>; Mon, 15 Jun 2020 17:02:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730886AbgFOPCl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 15 Jun 2020 11:02:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730836AbgFOPCk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 15 Jun 2020 11:02:40 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB9CAC061A0E
        for <io-uring@vger.kernel.org>; Mon, 15 Jun 2020 08:02:40 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id s88so7260745pjb.5
        for <io-uring@vger.kernel.org>; Mon, 15 Jun 2020 08:02:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=4UePqOyLZBpic7de4aDREJkkyarfeopIWIEnoD002bo=;
        b=cdYp+tOJIy/pDNWjbnWEQVtsDwbfNNyhASftdX/7O/N7oT4F38KgpW4LIy2fmiPTh6
         5mn3v0bN++u5Hjlls0grvcU1GxkN5CYb5axyzp6S6e5844ibpIQNRp344eFpQHocONSq
         IwbjoWI6SBpHLR1Jh1+226TUqME3iBC7HFGqgglR+NJ5zwIZxU0veVJBiM9xoZbzLH0s
         /KCNa4sJEq7Xfp7LVVOx8v7xZtiNmtY2TACwV7pGurBByz0ptAGwEQAl0BMepTIKC6GP
         bB9JksCupsjmDfMX9sp0WRFCPhqCE4hEGMrjAurbgQgqfojCyCH/JKNZ3TGIitJ/nG9x
         cibA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4UePqOyLZBpic7de4aDREJkkyarfeopIWIEnoD002bo=;
        b=JAMk0/H1FMt+7oZ/jHSBYbqnor02cWfcXOeZENF7a6C/wrfUDl+6eYCuNBhtxW1uGp
         yxoEtrAdZH+9oCbd+SdBjkdwj0HTZbaHlzbs9SFdcflSwfOajm9K+XUAmpQo5yJi2rII
         SpeoNCPswqlgVs19aLPltnUT7LYn/Vegzi6tJQU3asFrXUL7Vc8qBxrEICokdvzpOfC2
         QvVrHCTu/54mm/vYQcNpf3+TB9+KoHSYQcGFqgwanqwkxPLMidqMpYd1bcT2MaW6e4WY
         d8RcfghnxnEjsEDPgM41yTTk3GYiVGxaBJgTfophMFapUM0uYEogD3rawkO8FwTQBFM7
         Efng==
X-Gm-Message-State: AOAM530uNBW9TWxhAGBsxEb7kRK9gQol+NpbGVeGKJo3a5+B0Ze/pB92
        1Z0ubdDCQsAdtgHhfi9NFVw+zw==
X-Google-Smtp-Source: ABdhPJwVPk6ZYjuxHG7YcYYsxuJpTNpt5GnysQFOw7rFKm5uy2/IOQiLxcw2qhqCHcznZnDUss0CbA==
X-Received: by 2002:a17:90a:ed8f:: with SMTP id k15mr11340514pjy.63.1592233359895;
        Mon, 15 Jun 2020 08:02:39 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id p30sm12076081pgn.58.2020.06.15.08.02.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Jun 2020 08:02:39 -0700 (PDT)
Subject: Re: [PATCH 2/2] io_uring: add memory barrier to synchronize
 io_kiocb's result and iopoll_completed
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org
Cc:     joseph.qi@linux.alibaba.com
References: <20200615092450.3241-1-xiaoguang.wang@linux.alibaba.com>
 <20200615092450.3241-3-xiaoguang.wang@linux.alibaba.com>
 <a11acc23-1ad6-2281-4712-e78e46f414d7@kernel.dk>
 <e47dd9c1-60a6-8365-6754-88437cf828f5@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <97cfe28d-cbbe-680a-2f4f-8794d4f90728@kernel.dk>
Date:   Mon, 15 Jun 2020 09:02:38 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <e47dd9c1-60a6-8365-6754-88437cf828f5@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/15/20 8:48 AM, Xiaoguang Wang wrote:
> hi,
> 
>> On 6/15/20 3:24 AM, Xiaoguang Wang wrote:
>>> In io_complete_rw_iopoll(), stores to io_kiocb's result and iopoll
>>> completed are two independent store operations, to ensure that once
>>> iopoll_completed is ture and then req->result must been perceived by
>>> the cpu executing io_do_iopoll(), proper memory barrier should be used.
>>>
>>> And in io_do_iopoll(), we check whether req->result is EAGAIN, if it is,
>>> we'll need to issue this io request using io-wq again. In order to just
>>> issue a single smp_rmb() on the completion side, move the re-submit work
>>> to io_iopoll_complete().
>>
>> Did you actually test this one?
> I only run test cases in liburing/test in a vm.
> 
>>
>>> @@ -1736,11 +1748,20 @@ static void io_iopoll_complete(struct io_ring_ctx *ctx, unsigned int *nr_events,
>>>   {
>>>   	struct req_batch rb;
>>>   	struct io_kiocb *req;
>>> +	LIST_HEAD(again);
>>> +
>>> +	/* order with ->result store in io_complete_rw_iopoll() */
>>> +	smp_rmb();
>>>   
>>>   	rb.to_free = rb.need_iter = 0;
>>>   	while (!list_empty(done)) {
>>>   		int cflags = 0;
>>>   
>>> +		if (READ_ONCE(req->result) == -EAGAIN) {
>>> +			req->iopoll_completed = 0;
>>> +			list_move_tail(&req->list, &again);
>>> +			continue;
>>> +		}
>>>   		req = list_first_entry(done, struct io_kiocb, list);
>>>   		list_del(&req->list);
>>>   
>>
>> You're using 'req' here before you initialize it...
> Sorry, next time when I submit patches, I'll construct test cases which
> will cover my codes changes.

I'm surprised the compiler didn't complain, or that the regular testing
didn't barf on it.

Don't think you need a new test case for this, the iopoll test case
should cover it, if you limit the queue depth on the device by
setting /sys/block/<dev>/queue/nr_requests to 2 or something like
that.

-- 
Jens Axboe

