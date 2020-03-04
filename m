Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B2F917999D
	for <lists+io-uring@lfdr.de>; Wed,  4 Mar 2020 21:14:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727137AbgCDUOp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 4 Mar 2020 15:14:45 -0500
Received: from mail-io1-f65.google.com ([209.85.166.65]:39282 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726561AbgCDUOo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 4 Mar 2020 15:14:44 -0500
Received: by mail-io1-f65.google.com with SMTP id h3so3852274ioj.6
        for <io-uring@vger.kernel.org>; Wed, 04 Mar 2020 12:14:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=nAztYb774WsRpkB+kATuYDeAaIxkEfk/WJzTJiyRWW0=;
        b=yGz2amRrTZYm7zqKyq6bbG+n9kOXzqpyGSHZmSlwWip1EMmuT/8oh5Nxs79FLAJJZZ
         HP5KTCGzbG3INvyTt6iVZry1fHVz4D1GG6Efd1Q+K6rbNBxUAmkSAxQkeJLhKgZJUreH
         Isz8o65RH8kPGJU9QlcvFYGOtBjlJZN4T7PBMwU+KM2hSgJW+i338cL/VsEnIu+t7UG0
         V9iuRN0YJXXwQ/eoYaqh/arqzQPpvKaWndldtTQbAk0Mlv6jECaZXj3NgIQIc9zJQ285
         XpfM7FYiqQktu7jRxhbkxx+uESJ6diop7OqrrD/F+aQdbQDboJmq+LuiLzrP52Sg/m66
         qBDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nAztYb774WsRpkB+kATuYDeAaIxkEfk/WJzTJiyRWW0=;
        b=uBU9jNUW/lcjEPedPDapKh2ttXaEH4pValYnc+W3pdrndmOuLm4owJ8ZBDti1blO9U
         b3g8xwVL6uo//6Y1Z1hxV8uOG/cBe5WeBPOObfJaPdhMIxbAqAMDVcv7BIEuzYwpuwkW
         rYkomEkWbP9793EKRBWcWeTKbAIHEGalnxs6WFpYoOrcrjPITQZ7XPdpMJ+C+pkinpdS
         UXsMfHLg+Dy6MZaKReXuGlMEdxowYRTtdHhkCD4hlpwIOk7mEdJlp+A+TyJz1lrr3R7v
         UCIW/a98WxMvGcreOekOSa9w1k+rrpy9oITcbiGf3q2lrpVntv7OE8epQWUXyd2f4V5X
         mkuA==
X-Gm-Message-State: ANhLgQ1ZjFQUQ++MjPYYW+DOcy0DQa7OkaSp26SwCXdRo8pnK8Ecsl0h
        0B8mM2NQKHniX/vP8rPDhIlBVhAczqc=
X-Google-Smtp-Source: ADFU+vtgNRTbQtwuKhfc/c1YvnaaEWydf8K4qxtU62lm/oERdWfqFTnroNhT1pdimLvS+h4VDiO6ww==
X-Received: by 2002:a6b:d117:: with SMTP id l23mr3412035iob.217.1583352882487;
        Wed, 04 Mar 2020 12:14:42 -0800 (PST)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id t28sm5912856ill.19.2020.03.04.12.14.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Mar 2020 12:14:42 -0800 (PST)
Subject: Re: [PATCHSET v2 0/6] Support selectable file descriptors
To:     Josh Triplett <josh@joshtriplett.org>
Cc:     io-uring@vger.kernel.org, jlayton@kernel.org
References: <20200304180016.28212-1-axboe@kernel.dk>
 <20200304190341.GB16251@localhost>
 <121d15a7-4b21-368c-e805-a0660b1c851a@kernel.dk>
 <20200304195642.GB16527@localhost>
 <ed5c490f-4faf-afc7-bfab-d58aed061fc6@kernel.dk>
 <20200304200934.GC16527@localhost>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <c1cbbd5d-2be0-d724-7866-60b08e27852e@kernel.dk>
Date:   Wed, 4 Mar 2020 13:14:40 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200304200934.GC16527@localhost>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/4/20 1:09 PM, Josh Triplett wrote:
> On Wed, Mar 04, 2020 at 01:00:05PM -0700, Jens Axboe wrote:
>> On 3/4/20 12:56 PM, Josh Triplett wrote:
>>> On Wed, Mar 04, 2020 at 12:10:08PM -0700, Jens Axboe wrote:
>>>> On 3/4/20 12:03 PM, Josh Triplett wrote:
>>>>> On Wed, Mar 04, 2020 at 11:00:10AM -0700, Jens Axboe wrote:
>>>>>> One of the fabled features with chains has long been the desire to
>>>>>> support things like:
>>>>>>
>>>>>> <open fileX><read from fileX><close fileX>
>>>>>>
>>>>>> in a single chain. This currently doesn't work, since the read/close
>>>>>> depends on what file descriptor we get on open.
>>>>>>
>>>>>> The original attempt at solving this provided a means to pass
>>>>>> descriptors between chains in a link, this version takes a different
>>>>>> route. Based on Josh's support for O_SPECIFIC_FD, we can instead control
>>>>>> what fd value we're going to get out of open (or accept). With that in
>>>>>> place, we don't need to do any magic to make this work. The above chain
>>>>>> then becomes:
>>>>>>
>>>>>> <open fileX with fd Y><read from fd Y><close fd Y>
>>>>>>
>>>>>> which is a lot more useful, and allows any sort of weird chains without
>>>>>> needing to nest "last open" file descriptors.
>>>>>>
>>>>>> Updated the test program to use this approach:
>>>>>>
>>>>>> https://git.kernel.dk/cgit/liburing/plain/test/orc.c?h=fd-select
>>>>>>
>>>>>> which forces the use of fd==89 for the open, and then uses that for the
>>>>>> read and close.
>>>>>>
>>>>>> Outside of this adaptation, fixed a few bugs and cleaned things up.
>>>>>
>>>>> I posted one comment about an issue in patch 6.
>>>>>
>>>>> Patches 2-5 look great; for those:
>>>>> Reviewed-by: Josh Triplett <josh@joshtriplett.org>
>>>>>
>>>>> Thanks for picking this up and running with it!
>>>>
>>>> Thanks for doing the prep work! I think it turned out that much better
>>>> for it.
>>>>
>>>> Are you going to post your series for general review? I just stole
>>>> your 1 patch that was needed for me.
>>>
>>> Since your patch series depends on mine, please feel free to run with
>>> the series. Would you mind adding my patch 1 and 3 at the end of your
>>> series? You need patch 1 to make this more usable for userspace, and
>>> patch 3 would allow for an OP_PIPE which I'd love to have.
>>
>> Let me add patch 1 to the top of the stack, for the pipe part that
>> probably should be taken in separately. But not a huge deal to me,
>> as long as we can get it reviewed.
> 
> That works for me; I don't mind if the pipe support goes in a bit later.
> And there are many other fd-producing syscalls that need support for
> userspace-selected FDs, including signalfd4, eventfd2, timerfd_create,
> epoll_create1, memfd_create, userfaultfd, and the pidfd family.

Right, at least on the io_uring front, adding IORING_OP_SOCKET and
providing support for SOCK_SPECIFIC_FD through that would be trivial and
a few lines of change. In general, we can more easily do all that
through io_uring, as we have room to shove in that extra 'fd'.

I've queued up patch 1 as well.

>>> Do you plan to submit this during the next merge window?
>>
>> Maybe? In terms of timing, I think we're well within the opportunity
>> to do so, at least.
> 
> I look forward to seeing it go in.

Me too :-)

-- 
Jens Axboe

