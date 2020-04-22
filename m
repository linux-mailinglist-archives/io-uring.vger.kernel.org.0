Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5ED321B5011
	for <lists+io-uring@lfdr.de>; Thu, 23 Apr 2020 00:23:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726002AbgDVWX4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 22 Apr 2020 18:23:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726030AbgDVWXz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 22 Apr 2020 18:23:55 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 492C0C03C1A9
        for <io-uring@vger.kernel.org>; Wed, 22 Apr 2020 15:23:55 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id fu13so1004882pjb.5
        for <io-uring@vger.kernel.org>; Wed, 22 Apr 2020 15:23:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=nJjueSqKaycAkbU/QeLo79It2/9MkdVtrHxJylCNtHA=;
        b=V/DI0eZyaff2SdHJOwpy4lNTt+lYuohYpPpzle0s07NW3CIBK9Tsqn1Gj4xlwy9zgE
         ICIVH7VFSSiQH12+3T7V1yvUSgnsBibhHWmR4DIk9+0IWjkAFs38PyfxAAGIcqZTWIZ2
         aqYEmfSHBm0t+8UYfebChUuVTWmJASsrCHu7ATV333buc4cor9/4KP0lKrlUpRch9SYi
         UAkzyqo8QfspZNAMaw+sfTs7PibefZ92Xv+Sdga8N4r6hoLDcGO8gPoiOz0EdlCwyDay
         57PriSFEFbi95sibjkIxZfpGsSgbJQidCRkTbdw/wpbUOc8pZ+ti+HENL+CfI0u5vuS0
         uHAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nJjueSqKaycAkbU/QeLo79It2/9MkdVtrHxJylCNtHA=;
        b=rmzePGRWP2CrS+0boYLQRNmHBK2PhiFZ2a8U2zcCY/nA1rbOMyesdSyzs2gQlCAlAN
         +EBUs3lc8fxHgZK3TcHtcI+jDvUWiPM6QitYD0+y8luRchTzi801GjZVfK923JZNLqp/
         7f0A3UoIQ7LrQpGkqBqasgqYeHFHFYwcdcopIu/m7f5o+UGHjQLkZy8pXxzAmytflLkm
         EVJXrIfGMNTnQHVHyVZBR8fHdtr61gfQxgSW2ziGYmVioAuXWB4OPiuWGu0V9ZoAGj82
         XtjPrzSR9sAsmNtMEutnDaXJKRnuyy3UMoEvcfnt+edeK4TSVhg4YLzCs5x1c0HRGbEY
         s7Ig==
X-Gm-Message-State: AGi0PuYAkrZppS4K7eIkt4yz5Xe3Rnbrh1VZmFsSkYIMXqoSIoQY9er4
        h/vyn3j1nhjW4GirhHaZ3GBPLg==
X-Google-Smtp-Source: APiQypKNd9aDShs9EFFLolO6JJr/78vKYJ1BLet/EOPtuNK8PD4fhP/G9+4fl9Ro+00V+T2B1RsIfw==
X-Received: by 2002:a17:902:8641:: with SMTP id y1mr883430plt.27.1587594234715;
        Wed, 22 Apr 2020 15:23:54 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id s66sm230396pgb.84.2020.04.22.15.23.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Apr 2020 15:23:53 -0700 (PDT)
Subject: Re: [PATCH 1/2] io_uring: trigger timeout after any sqe->off CQEs
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1587229607.git.asml.silence@gmail.com>
 <28005ea0de63e15dbffd87a49fe9b671f1afa87e.1587229607.git.asml.silence@gmail.com>
 <88cbde3c-52a1-7fb3-c4a7-b548beaa5502@kernel.dk>
 <f9c1492c-a0f6-c6ec-ec2e-82a5894060f6@gmail.com>
 <3fe32d07-10e6-4a5a-1390-f03ec4a09c6f@gmail.com>
 <cf991f17-ad5f-c80a-d993-544d8746ac72@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <c4bb1251-4ad5-0218-690f-c1be09908e67@kernel.dk>
Date:   Wed, 22 Apr 2020 16:23:51 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <cf991f17-ad5f-c80a-d993-544d8746ac72@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/22/20 4:20 PM, Pavel Begunkov wrote:
> On 20/04/2020 23:15, Pavel Begunkov wrote:
>> On 20/04/2020 23:12, Pavel Begunkov wrote:
>>> On 20/04/2020 22:40, Jens Axboe wrote:
>>>> On 4/18/20 11:20 AM, Pavel Begunkov wrote:
>>>>> +static void __io_flush_timeouts(struct io_ring_ctx *ctx)
>>>>> +{
>>>>> +	u32 end, start;
>>>>> +
>>>>> +	start = end = ctx->cached_cq_tail;
>>>>> +	do {
>>>>> +		struct io_kiocb *req = list_first_entry(&ctx->timeout_list,
>>>>> +							struct io_kiocb, list);
>>>>> +
>>>>> +		if (req->flags & REQ_F_TIMEOUT_NOSEQ)
>>>>> +			break;
>>>>> +		/*
>>>>> +		 * multiple timeouts may have the same target,
>>>>> +		 * check that @req is in [first_tail, cur_tail]
>>>>> +		 */
>>>>> +		if (!io_check_in_range(req->timeout.target_cq, start, end))
>>>>> +			break;
>>>>> +
>>>>> +		list_del_init(&req->list);
>>>>> +		io_kill_timeout(req);
>>>>> +		end = ctx->cached_cq_tail;
>>>>> +	} while (!list_empty(&ctx->timeout_list));
>>>>> +}
>>>>> +
>>>>>  static void io_commit_cqring(struct io_ring_ctx *ctx)
>>>>>  {
>>>>>  	struct io_kiocb *req;
>>>>>  
>>>>> -	while ((req = io_get_timeout_req(ctx)) != NULL)
>>>>> -		io_kill_timeout(req);
>>>>> +	if (!list_empty(&ctx->timeout_list))
>>>>> +		__io_flush_timeouts(ctx);
>>>>>  
>>>>>  	__io_commit_cqring(ctx);
>>>>>  
>>>>
>>>> Any chance we can do this without having to iterate timeouts on the
>>>> completion path?
>>>>
>>>
>>> If you mean the one in __io_flush_timeouts(), then no, unless we forbid timeouts
>>> with identical target sequences + some extra constraints. The loop there is not
>>> new, it iterates only over timeouts, that need to be completed, and removes
>>> them. That's amortised O(1).
>>
>> We can think about adding unlock/lock, if that's what you are thinking about.
>>
>>
>>> On the other hand, there was a loop in io_timeout_fn() doing in
>>> total O(n^2), and it was killed by this patch.
>>
> 
> Any thoughts on this?
> 
> I'll return fixing the last timeout bug I saw, but I'd prefer to know
> on top of what to do that.

I think it's fine, but also likely something that we should defer to
5.8. So if there are minor fixes to be done for 5.7, it should be
arranged as such.

-- 
Jens Axboe

