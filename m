Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 495911AF965
	for <lists+io-uring@lfdr.de>; Sun, 19 Apr 2020 12:43:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725953AbgDSKnh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 19 Apr 2020 06:43:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725923AbgDSKnh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 19 Apr 2020 06:43:37 -0400
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96DE7C061A0C
        for <io-uring@vger.kernel.org>; Sun, 19 Apr 2020 03:43:36 -0700 (PDT)
Received: by mail-lf1-x143.google.com with SMTP id u10so5453892lfo.8
        for <io-uring@vger.kernel.org>; Sun, 19 Apr 2020 03:43:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=mB7EZrlUMco0QSZSdfWaB+75U08p5ClmgWgjUWoqeYk=;
        b=tks19YF3z7U1oEk/PspmHEtA4bm+6M0LKj7h7Ml8f+Z4StJG6kk3/nhEWFP5Rbwoqp
         yvJFKELsoNS4IOHdxybcDWUSJ1cZcP2Hsm3pbUmpvZORqcX89ORNOYnTsXbU01Mml8nu
         2432PK7k5ylbRyyzcZSBAyUZZgG2f3KDiYnV9QjjFVnHOjndozYJq3wLRYfdq/mWUN7+
         tL9jpIYhih4mL0eam+DOP1X8NvgZAQ3YZJLqmo09ZqEQ5Wg8EYPYyqFy5UI90mrJBT53
         tx9EN/PmlYbG1foxl67zTnnEdqeoJwAKC2OJCnVVwvcnSLri5AGmwDlH3JRUodyYB/8J
         7eCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mB7EZrlUMco0QSZSdfWaB+75U08p5ClmgWgjUWoqeYk=;
        b=Wh8WcSIHuvgJ8CKK7CblOAmvsRwXz/j+vUd1lbJeDxrYdBSXbHQTrfZmZlxprEWqA8
         WCBbhNNsvDf0Z7/3uVxP6Jz4oZAPBSOox0GZ4XxjtHWi1rgbVTAFj1qy7GY9mk8BTWZ6
         fK64SV0fpGbE8TPcDRioytprbpx671trFtso07h4Pbj3Dvx13wvgyOE5soK5Rv0gYknw
         RTLhSPr0E8fAH14IU8R3CGxyva6CcNBafYbrXZKtYVp8VwmwW4kXTDT3Jt/2VkzF7xpp
         d/qanknlYvg7btVRkXbYtJ03h+aXfp8vNhvMl1ejsSQz09nBiQ/4jBUZB/WFr4aLQFf9
         O7lw==
X-Gm-Message-State: AGi0PuY9kXBYRUsVZycbNb1+7aeLXRHfh/w9r60Rpftf5whnHpAmNKM/
        hR2qmm1ZSokJ6EFgKCGqN6U=
X-Google-Smtp-Source: APiQypKXfiDEsdVEadEtQoY24ld4a9g8XVRe+n7hau1OGFAcmzOhTbVJh5jRtYHsNySjA+n/vMI4Ng==
X-Received: by 2002:a05:6512:52c:: with SMTP id o12mr7076534lfc.217.1587293014975;
        Sun, 19 Apr 2020 03:43:34 -0700 (PDT)
Received: from [172.31.190.83] ([86.57.146.226])
        by smtp.gmail.com with ESMTPSA id x29sm22945861lfn.64.2020.04.19.03.43.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 19 Apr 2020 03:43:34 -0700 (PDT)
Subject: Re: Suggestion: chain SQEs - single CQE for N chained SQEs
To:     "H. de Vries" <hdevries@fastmail.com>,
        io-uring <io-uring@vger.kernel.org>
Cc:     axboe@kernel.dk
References: <08ef10c8-90f3-4777-89ab-f9245dc03466@www.fastmail.com>
 <50567b86-fa5d-b8a7-863d-978420b3e0f8@gmail.com>
 <44ccd560-e00a-47d9-a728-89380f2ba2e3@www.fastmail.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <9832ea7d-342e-fdef-5465-c1a1291300d7@gmail.com>
Date:   Sun, 19 Apr 2020 13:43:33 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <44ccd560-e00a-47d9-a728-89380f2ba2e3@www.fastmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/18/2020 9:18 PM, H. de Vries wrote:
> Hi Pavel,
> 
> Yes, [1] is what I mean. In an event loop every CQE is handled by a new iteration in the loop, this is the "expensive" part. Less CQEs, less iterations. It is nice to see possible kernel performance gains [2] as well, but I suggested this specifically in the case of event loops.
> 
> Can you elaborate on “handling links from the user side”? 

Long story short, fail recovery and tracking of links in the userspace
would be easier if having 1 cqe per link.

TL;DR;
Applications usually want to do some action, which is represented by a
ordered (linked) set of requests. And it should be common to have
similar code structure

e.g. cqe->user_data points to struct request, which are kept in a list.
Possibly with request->action pointing to a common "action" struct
instance tracking current stage (i.e. state machine), etc. And with that
you can do fail recovery (e.g. re-submitting failed ones) / rollback,
etc. That's especially useful for hi-level libraries.


And now let's see what an application should consider in case of a
failure. I'll use the following example:
SQ: req_n, (linked) req0 -> req1 -> req2

1. it should reap the failure event + all -ECANCELED. And they can lie
in CQ not sequentially, but with other events in between.
e.g. CQ: req0(failed), req_n, req1(-CANCELED), req2(-CANCELED)

2. CQEs can get there out of order (only when failed during submission).
e.g. CQ: req2(failed), req0(-ECANCELED), req1(-ECANCELED)

3. io_uring may have not consumed all SQEs of the link, so it needs to
do some cleanup there as well.
e.g. CQ: req0(failed), SQ after submit: req1 -> req2


It's just hell to handle it right. I was lifting them with recent
patches and 1 yet stashed, but still with the feature it could be as
simple as:

req = cqe->user_data;
act = req->action;
while (act->stage != req->num) {
    complete_and_remove_req(&act->request_list_head);
    act->stage++;
}

> [2] 
> https://lore.kernel.org/io-uring/56a18348-2949-e9da-b036-600b5bb4dad2@kernel.dk/#t
> 
> --
> Hielke de Vries
> 
> 
> On Sat, Apr 18, 2020, at 15:50, Pavel Begunkov wrote:
>> On 4/18/2020 3:49 PM, H. de Vries wrote:
>>> Hi,
>>>
>>> Following up on the discussion from here: https://twitter.com/i/status/1234135064323280897 and https://twitter.com/hielkedv/status/1250445647565729793
>>>
>>> Using io_uring in event loops with IORING_FEAT_FAST_POLL can give a performance boost compared to epoll (https://twitter.com/hielkedv/status/1234135064323280897). However we need some way to manage 'in-flight' buffers, and IOSQE_BUFFER_SELECT is a solution for this. 
>>>
>>> After a buffer has been used, it can be re-registered using IOSQE_BUFFER_SELECT by giving it a buffer ID (BID). We can also initially register a range of buffers, with e.g. BIDs 0-1000 . When buffer registration for this range is completed, this will result in a single CQE. 
>>>
>>> However, because (network) events complete quite random, we cannot re-register a range of buffers. Maybe BIDs 3, 7, 39 and 420 are ready to be reused, but the rest of the buffers is still in-flight. So in each iteration of the event loop we need to re-register the buffer, which will result in one additional CQE for each event. The amount of CQEs to be handled in the event loop now becomes 2 times as much. If you're dealing with 200k requests per second, this can result in quite some performance loss.
>>>
>>> If it would be possible to register multiple buffers by e.g. chaining multiple SQEs that would result in a single CQE, we could save many event loop iterations and increase performance of the event loop.
>>
>> I've played with the idea before [1], it always returns only one CQE per
>> link, (for the last request on success, or for a failed one otherwise).
>> Looks like what you're suggesting. Is that so? As for me, it's just
>> simpler to deal with links on the user side.
>>
>> It's actually in my TODO for 5.8, but depends on some changes for
>> sequences/drains/timeouts, that hopefully we'll push soon. We just need
>> to be careful to e.g. not lose CQEs with BIDs for IOSQE_BUFFER_SELECT
>> requests.
>>
>> [1]
>> https://lore.kernel.org/io-uring/1a9a6022-7175-8ed3-4668-e4de3a2b9ff7@gmail.com/
>>
>> -- 
>> Pavel Begunkov
>>

-- 
Pavel Begunkov
