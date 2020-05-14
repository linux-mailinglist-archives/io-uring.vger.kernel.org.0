Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6617D1D373A
	for <lists+io-uring@lfdr.de>; Thu, 14 May 2020 19:01:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726046AbgENRBa (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 14 May 2020 13:01:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725975AbgENRBa (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 14 May 2020 13:01:30 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C74DC061A0C
        for <io-uring@vger.kernel.org>; Thu, 14 May 2020 10:01:30 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id x15so1579614pfa.1
        for <io-uring@vger.kernel.org>; Thu, 14 May 2020 10:01:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=B4Xid7zd+OkoEiYFDS+IytAyt2vdZy4eGyUqIxC+QWE=;
        b=iU/DpwkkOZqWPcTdJEI/UhKLwMiyYlsytOfGZYi4LBktt6gl/FdhrxaE1RZ8LZEEbr
         pw1sm82IiPD2MEkicgBKNVs0KOZ+xcuX/2FmNSE2HmKZF1H2vpCC8aVFPySW8lJGE3IP
         hDKAAuWGvSjLOaTk+an9G1MQUiZJpxvFEmvs6YTyRfuEzHOeodgN3fPAaRCxCMyvTWIq
         5Kn33STT32buxDWjreGs2WWzC718Ax5kIf/aM+dqAeLcu0uFewaDh6S9+ZJti0AZWx1z
         B8QYVbVsEA8oHEJ/L+EHRX3Ulxgezx+ZXV4xWFXzfM7+AJrso3d3l/fd0gyfR7Fn2/2x
         hbDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=B4Xid7zd+OkoEiYFDS+IytAyt2vdZy4eGyUqIxC+QWE=;
        b=LwhoP8nnvDMApo8drCXOXmKzNR1tNMoyp6j2O7Wf5Wnur9WNBTTaateU2XbXrmN4Z+
         3y53b1DnhwIBWRYsXr2cdMELPpX0G56T3mptBtH8FtrxHx8DtEMv660EFW4raEM1V/Oi
         Ap1PAkEXJbL6yKMKZqpPCsUuYTthfUws1gTx4e/Z3Y5Pe+d0cnHENNR+czhsIV/VO5Lp
         taV/ztZ1fIvU94hekb/eNa1tKYgooYoPQFVW/kqOavr1vZyqBOY2IPywM/faEIQE9Gdp
         C/GMGFshNSbZ+d1tJuO8q9o9H0Qq4r1v3hmv4n/fUYaMVShaooizUvDkqNa+VkN/zEG/
         ynyg==
X-Gm-Message-State: AOAM5322KNN6yEBh0PIhqe3Rv0ygr7YMwTR8qD99piI7sZ7zTmaGCUCk
        Bh/HEzIc5xT16GXJRpALvxJZaJAhWl4=
X-Google-Smtp-Source: ABdhPJySIt64LySKWlsEVptoeY+ro3GKcZGf842NjS35HX9pEw8pfOeXeSRki4MUPLgi0itmFVqEbQ==
X-Received: by 2002:a63:f709:: with SMTP id x9mr4804045pgh.330.1589475689652;
        Thu, 14 May 2020 10:01:29 -0700 (PDT)
Received: from ?IPv6:2605:e000:100e:8c61:85e7:ddeb:bb07:3741? ([2605:e000:100e:8c61:85e7:ddeb:bb07:3741])
        by smtp.gmail.com with ESMTPSA id w14sm2378604pgo.75.2020.05.14.10.01.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 May 2020 10:01:29 -0700 (PDT)
Subject: Re: [PATCH RFC} io_uring: io_kiocb alloc cache
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring <io-uring@vger.kernel.org>
Cc:     joseph qi <joseph.qi@linux.alibaba.com>,
        Jiufei Xue <jiufei.xue@linux.alibaba.com>
References: <492bb956-a670-8730-a35f-1d878c27175f@kernel.dk>
 <dc5a0caf-0ba4-bfd7-4b6e-cbcb3e6fde10@linux.alibaba.com>
 <70602a13-f6c9-e8a8-1035-6f148ba2d6d7@kernel.dk>
 <a68bbc0a-5bd7-06b6-1616-2704512228b8@kernel.dk>
 <0ec1b33d-893f-1b10-128e-f8a8950b0384@gmail.com>
 <a2b5e500-316d-dc06-1a25-72aaf67ac227@kernel.dk>
 <d6206c24-8b4d-37d3-56bd-eac752151de9@gmail.com>
 <b7e7eb5e-cbea-0c59-38b1-1043b5352e4d@kernel.dk>
 <8ddf1d04-aa4a-ee91-72fa-59cb0081695c@gmail.com>
 <642c24dd-19e7-1332-f31e-04a8f0f81c3a@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <73b95bff-6f08-16f7-7fa8-7552a8dadb63@kernel.dk>
Date:   Thu, 14 May 2020 11:01:27 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <642c24dd-19e7-1332-f31e-04a8f0f81c3a@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/14/20 10:25 AM, Pavel Begunkov wrote:
> On 14/05/2020 19:18, Pavel Begunkov wrote:
>> On 14/05/2020 18:53, Jens Axboe wrote:
>>> On 5/14/20 9:37 AM, Pavel Begunkov wrote:
>>> Hmm yes good point, it should work pretty easily, barring the use cases
>>> that do IRQ complete. But that was also a special case with the other
>>> cache.
>>>
>>>> BTW, there will be a lot of problems to make either work properly with
>>>> IORING_FEAT_SUBMIT_STABLE.
>>>
>>> How so? Once the request is setup, any state should be retained there.
>>
>> If a late alloc fails (e.g. in __io_queue_sqe()), you'd need to file a CQE with
>> an error. If there is no place in CQ, to postpone the completion it'd require an
>> allocated req. Of course it can be dropped, but I'd prefer to have strict
>> guarantees.
> 
> I know how to do it right for my version.
> Is it still just for fun thing, or you think it'll be useful for real I/O?

We're definitely spending quite a bit of time on alloc+free and the atomics
for the refcount. Considering we're core limited on some workloads, any
cycles we can get back will ultimately increase the performance. So yeah,
definitely worth exploring and finding something that works.

-- 
Jens Axboe

