Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 109403758F4
	for <lists+io-uring@lfdr.de>; Thu,  6 May 2021 19:09:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236101AbhEFRKk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 6 May 2021 13:10:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236042AbhEFRKj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 6 May 2021 13:10:39 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC4F4C061574
        for <io-uring@vger.kernel.org>; Thu,  6 May 2021 10:09:40 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id l2so6398863wrm.9
        for <io-uring@vger.kernel.org>; Thu, 06 May 2021 10:09:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=clJ3bCg9yus33maNyP2n0C+PtxvqKG4QG3EIHeSD4vg=;
        b=K/vGJPsTaOIGCM+Dwaci0SGdVLQQI8exONxx84e/2bo63rjgucyVnrjzgZF2zGOyma
         jghtDtxVaINQ/e46jgac1S/gu0xfUugG340nhDajEy8I/Cr5fjFRHxV1+s6t+XJBIQW2
         LfZxt0LH1ZjnT3pJ+/qJG7pdWplw5jpTUEZ1SMRgDqWGuLfNNj8QyaDjzYSlKt5sitpy
         7/mjyQI+HGxucBA/JOhfSHA4uTZWU2QQopltr7yPmfZzWl/NJXKdzPl28cSAxbApQyhy
         L6yZe77F6hSquKg0PxsHcbU/83Kw8QDJLWBmlELlbJUMtOdWbOWcVttdDFVWXtuNp+fy
         i/8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=clJ3bCg9yus33maNyP2n0C+PtxvqKG4QG3EIHeSD4vg=;
        b=j+0VddDB10Bwotr4P8HVM+g06v3FIu9mz4V5Jp4L4jCCDjC456kLPYSk2LG+mkIoW9
         iUK1YanCTYbhhpRFWQsbk2zzDiqYnx4B6tsEU7/euWQFhI4sy/MqtBWfqNQI5mZ52pdB
         20GA5Rfa8Dfufb+9wOve8Z1YHV5xjGpPQE2m0rzl/kWcF077yv9NFp4D6FhuJP5jhniP
         qpm1HjFt5q9oH8J57dKgM21LLX8nIZusa+HK1hgbLq6+stPOpQs6VPkjCnqIiHFMTfaj
         mp/S4lcUvOEPqhr5yoAal0HRYqIRpujDSrYQ9rtlVxwxp2KaIvKQWWdcalODr6xif41W
         aSYA==
X-Gm-Message-State: AOAM533NX2mJh5jlGfjtkbPcNFuxrxgORIY11523C5rPLD5slrWwbIK8
        KqG1N6zKEDkMTASy6FdvkLrzw2YSngw=
X-Google-Smtp-Source: ABdhPJzhb4JGHfbI8x/JwZzjK+j+Irb0GOL12W7QuWb5eXWgd5MgzOhjG/LOf2olajkqL8RQuIpEew==
X-Received: by 2002:adf:fb43:: with SMTP id c3mr6693826wrs.360.1620320979253;
        Thu, 06 May 2021 10:09:39 -0700 (PDT)
Received: from [192.168.8.197] ([185.69.144.215])
        by smtp.gmail.com with ESMTPSA id f18sm9454277wmg.26.2021.05.06.10.09.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 May 2021 10:09:38 -0700 (PDT)
Subject: Re: IORING_OP_POLL_ADD/IORING_OP_POLL_REMOVE questions
To:     Olivier Langlois <olivier@trillion01.com>,
        io-uring <io-uring@vger.kernel.org>
References: <8992f5f989808798ad2666b0a3ef8ae8d777b7de.camel@trillion01.com>
 <db4d01cc-9f58-c04d-d1b6-1208f8fb7220@gmail.com>
 <0a12170604cfcbce61259661f579fe5640cc7ffb.camel@trillion01.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <44491721-56a0-3188-a1ba-5a0920881ac2@gmail.com>
Date:   Thu, 6 May 2021 18:09:33 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <0a12170604cfcbce61259661f579fe5640cc7ffb.camel@trillion01.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/6/21 4:17 AM, Olivier Langlois wrote:
> Hi Pavel,
> 
> On Wed, 2021-05-05 at 18:56 +0100, Pavel Begunkov wrote:
>> On 5/4/21 7:06 PM, Olivier Langlois wrote:
>>>
>>>
>>> 2. I don't understand what I am looking at. Why am I receiving a
>>> completion notification for a POLL request that has just been
>>> cancelled? What is the logic behind silently discarding a
>>> IORING_OP_POLL_ADD sqe meant to replace an existing one?
>>
>> I'm lost in your message, so let's start with simple reasons. All
>> requests post one CQE (almost true), including poll_remove requests.
>>
>> io_uring_prep_poll_remove(sqe, iouring_build_user_data(IOURING_POLL,
>> fd, anfds [fd].egen));
>> // io_uring_sqe_set_data(sqe, iouring_build_user_data(IOURING_POLL, fd,
>> anfds [fd].egen));
>>
>> If poll remove and poll requests have identical user_data, as in
>> the second (commented?) line you'll get two CQEs with that user_data.
>>
>> Did you check return value (in CQE) of poll remove? I'd recommend
>> set its user_data to something unique. Did you consider that it
>> may fail?
> 
> Your comments does help me to see clearer!
> 
> You are correct that setting the poll remove user_data is not done.
> (hence the commented out statement for that purpose but I must have
> entertain the idea to set it at some point to see what good it would
> do)
> 
> The reason being that I do not care about whether or not it succeeds
> because the very next thing that I do is to rearm the poll for the same
> fd with a different event mask.
> 
> Beside, the removed poll original sqe is reported back as ECANCELED (-
> 125):
> 85 gen 1 res -125

That's why I mentioned setting user_data, so can distinguish cqes.

> This appear to be the code returned in io_poll_remove_one()
> 
> Does the poll remove operation generates 2 cqes?
> 1 for the canceled sqe and and 1 for the poll remove sqe itself?

No, only one.

> 
> I am not too sure what good setting a distinct user_data to the poll
> remove sqe could do but I will definitely give it a shot to perhaps see
> clearer.

again to be able to distinguish cqes, at least for debugging,
but I don't see how it can be not racy without it.

> Note that the poll remove sqe and the following poll add sqe don't have
> exactly the same user_data.

Right, I noticed. Was concerned about gen1 poll and its poll
remove.

 
> I have this statement in between:
> /* increment generation counter to avoid handling old events */
>           ++anfds [fd].egen;
> 
> poll remove cancel the previous poll add having gen 1 in its user data.
> the next poll add has it user_data storing gen var set to 2:
> 
> 1 3 remove 85 1
> 1 3 add 85 2
> 
> 85 gen 1 res -125
> 85 gen 1 res 4
> 
> I'll try to be more succinct this time.
> 
> If the poll add sqe having gen 1 in its user_data is cancelled, how can
> its completion can be reported in the very next cqe?
> 
> and I never hear back about the poll add gen 2 sqe...

This one sounds like that "85 gen 1 res 4"
is actually gen2 but with screwed user_data. I'd rather
double check that you set it right, and don't race
with multiple threads.

FWIW, submission queue filling is not synchronised by
liburing, users should do that.

> 
> I'll try to get more familiar with the fs/io_uring.c code but it feels
> like it could be some optimization done where because the cancelled
> poll result is available while inside io_uring_enter(), instead of
> discarding it to immediately rearm it for the new poll add request,
> io_uring_enter() instead decide to return it back to reply to the gen 2
> request but it forgets to update the user_data field before doing so...

There definitely may be a bug, but it's much more likely
lurking in your code.

> Maybe what is confusing is that the heading "1 3" in my traces is the
> EV_READ EV_WRITE bitmask which values are:
> 
> EV_READ  = 1
> EV_WRITE = 2
> 
> while
> 
> POLLIN  = 1
> POLLOUT = 4
> 
> So my poll add gen 1 request was for be notified for POLLIN. This is
> what I got with the question #1 "195" result.
> 
> Therefore the:
> 85 gen 1 res 4
> 
> can only be for my poll add gen 2 requesting for POLLIN|POLLOUT. Yet,
> it is reported with the previous request user_data...
> 
> I feel the mystery is almost solved with your help... I'll continue my
> investigation and I'll report back if I finally solve the mystery.
>>  
>>> 3. As I am writing this email, I have just noticed that it was
>>> possible
>>> to update an existing POLL entry with IORING_OP_POLL_REMOVE through
>>> io_uring_prep_poll_update(). Is this what I should do to eliminate my
>>> problems? What are the possible race conditions scenarios that I
>>> should
>>> be prepared to handle by using io_uring_prep_poll_update() (ie:
>>> completion of the poll entry to update while my process is inside
>>> io_uring_enter() to update it...)?
>>
>> Update is preferable, but it's Linux kernel 5.13.
>> Both remove and update may fail. e.g. with -EALREADY
>>
> I am just about to install 5.12 on my system and this and the new
> multishot poll feature makes me already crave 5.13!

-- 
Pavel Begunkov
