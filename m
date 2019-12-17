Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 202F9123488
	for <lists+io-uring@lfdr.de>; Tue, 17 Dec 2019 19:15:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727743AbfLQSPh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 17 Dec 2019 13:15:37 -0500
Received: from mail-il1-f193.google.com ([209.85.166.193]:35443 "EHLO
        mail-il1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727594AbfLQSPh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 17 Dec 2019 13:15:37 -0500
Received: by mail-il1-f193.google.com with SMTP id g12so9186832ild.2
        for <io-uring@vger.kernel.org>; Tue, 17 Dec 2019 10:15:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=vbw5CKL4CuxmghTAEu89nJMJ7GBT8QILyPuP8AESCZ0=;
        b=tf3Q7OgNZOPZ4NDDsUxqjoaRcpTtJDgOZYTvcOxAY8UnzPsci2cILboXMjiIqdNhpW
         VZa6PWPVRuTZDlnt86t7iSC2XGzbSO6QTLdfl4QE7hPH9Gi/0i2ergax5BYIr6cAQPH8
         MFYq2vcHA6qc8mdjdEZReyhMKCgcJldcBzJh+x8KpK+P13kPG29IRReN9OlUcHTvsYlV
         K2/x8m7RHf60TqQbQHOQQZkpTVkTeiWIElgip7Lu1EZuIuF3g/kjsp2THSZge0uE0af2
         9tjWECj4HJI1WqeHnzVxAtsIJdhrV3F1VPAkUYVwfXBdgrS/IlByZnxV4EfH9FvrgQK0
         QZow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vbw5CKL4CuxmghTAEu89nJMJ7GBT8QILyPuP8AESCZ0=;
        b=cAsnDdbXr69NBRCLfE/RJZRuGVcJ688lghAerN20/+kpMXCpC5+6z8GNuHUTRZ5rZI
         8uWeaUCy1yOtFknrpNV+6vDhNaWg7hJRd9xhefP2ZA/KAAyfPfSuJqxwRjw8JQ4BdPfO
         O/0y1APMkIcRtgxzosU08+/nI769/+mHCtdyBrgQuCGbnzGKQvBvzOaSFq+d+M1Uv8nj
         X/GyfUze6fbmYSKWUB5aGpY6irJzD/7WM8HIMbLIqdEdN/z/sFZeNo46L+DZedtJ4URa
         Bj2yMdRf7t2sVsWHfO54Yhnkai3FrgagKAAP6BJk+idRTN44lzcEjOrJIerkmqiaJLLG
         WiqQ==
X-Gm-Message-State: APjAAAXUN4LvLXShMT7NiQ3lfsDzfXHvFHhYc8EJntN/yp3K7+zpWEml
        vQ3toJ3oCoQ1rlM1pArtQa5M6Q==
X-Google-Smtp-Source: APXvYqyCKqstdVdqsEJn1eduTswJB3O6bkzviOdb5G48axJzjFdv/+/LjwLGFULY9U6NBy22rHLqQQ==
X-Received: by 2002:a92:499b:: with SMTP id k27mr18755063ilg.25.1576606536408;
        Tue, 17 Dec 2019 10:15:36 -0800 (PST)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id f72sm5076794ilg.84.2019.12.17.10.15.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Dec 2019 10:15:35 -0800 (PST)
Subject: Re: [PATCH 3/3] io_uring: move *queue_link_head() from common path
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1576538176.git.asml.silence@gmail.com>
 <eda17f0736faff0876c580f1cd841b61c92d7e39.1576538176.git.asml.silence@gmail.com>
 <17f7900c-385f-0dfa-11bf-af99d080f894@gmail.com>
 <76917820-052d-9597-133d-424fee3edade@kernel.dk>
 <5d4af2f6-26a2-b241-5131-3a0155cbbf22@kernel.dk>
 <3b5100a7-2922-a9f2-e4e2-76252318959d@gmail.com>
 <7edd6631-326c-ac9c-7c5b-fa4bab3932d3@kernel.dk>
 <4f3f9b65-6e9f-b650-65b8-1e0844321697@gmail.com>
 <69cb864c-9fa9-2d5a-7b75-f72633cb32f5@kernel.dk>
 <e7bb74e8-0cbe-40f8-9d10-192a8512e1f7@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <812da023-1ebe-fa5c-cd1c-266c9708b881@kernel.dk>
Date:   Tue, 17 Dec 2019 11:15:35 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <e7bb74e8-0cbe-40f8-9d10-192a8512e1f7@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/17/19 11:12 AM, Pavel Begunkov wrote:
> On 17/12/2019 21:07, Jens Axboe wrote:
>> On 12/17/19 11:05 AM, Pavel Begunkov wrote:
>>> On 17/12/2019 21:01, Jens Axboe wrote:
>>>> On 12/17/19 10:52 AM, Pavel Begunkov wrote:
>>>>> On 17/12/2019 20:37, Jens Axboe wrote:
>>>>>> On 12/17/19 9:45 AM, Jens Axboe wrote:
>>>>>>> On 12/16/19 4:38 PM, Pavel Begunkov wrote:
>>>>>>>> On 17/12/2019 02:22, Pavel Begunkov wrote:
>>>>>>>>> -	} else if (req->sqe->flags & (IOSQE_IO_LINK|IOSQE_IO_HARDLINK)) {
>>>>>>>>> +
>>>>>>>>> +		/* last request of a link, enqueue the link */
>>>>>>>>> +		if (!(sqe_flags & IOSQE_IO_LINK)) {
>>>>>>>>
>>>>>>>> This looks suspicious (as well as in the current revision). Returning back
>>>>>>>> to my questions a few days ago can sqe->flags have IOSQE_IO_HARDLINK, but not
>>>>>>>> IOSQE_IO_LINK? I don't find any check.
>>>>>>>>
>>>>>>>> In other words, should it be as follows?
>>>>>>>> !(sqe_flags & (IOSQE_IO_LINK|IOSQE_IO_HARDLINK))
>>>>>>>
>>>>>>> Yeah, I think that should check for both. I'm fine with either approach
>>>>>>> in general:
>>>>>>>
>>>>>>> - IOSQE_IO_HARDLINK must have IOSQE_IO_LINK set
>>>>>>>
>>>>>>> or
>>>>>>>
>>>>>>> - IOSQE_IO_HARDLINK implies IOSQE_IO_LINK
>>>>>>>
>>>>>>> Seems like the former is easier to verify in terms of functionality,
>>>>>>> since we can rest easy if we check this early and -EINVAL if that isn't
>>>>>>> the case.
>>>>>>>
>>>>>>> What do you think?
>>>>>>
>>>>>> If you agree, want to send in a patch for that for 5.5? Then I can respin
>>>>>> for-5.6/io_uring on top of that, and we can apply your cleanups there.
>>>>>>
>>>>> Yes, that's the idea. Already got a patch, if you haven't done it yet.
>>>>
>>>> I haven't.
>>>>
>>>>> Just was thinking, whether to add a check for not setting both flags
>>>>> at the same moment in the "imply" case. Would give us 1 state in 2 bits
>>>>> for future use.
>>>>
>>>> Not sure I follow what you're saying here, can you elaborate?
>>>>
>>>
>>> Sure
>>>
>>> #define IOSQE_IO_LINK		(1U << 2)	/* links next sqe */
>>> #define IOSQE_IO_HARDLINK	(1U << 3)	/* like LINK, but stronger */
>>>
>>> That's 2 consequent bits, so 4 states:
>>> 0,0 -> not a link
>>> 1,0 -> common link
>>> 0,1 -> hard link
>>> 1,1 -> reserved, space for another link-quirk type
>>>
>>> But that would require additional check, i.e.
>>>
>>> if (flags&(LINK|HARDLINK) == (LINK|HARDLINK)) ...
>>
>> Ah, I see. In terms of usability, I think it makes more sense to have
>>
>> IOSQE_LINK | IOSQE_HARDLINK
>>
>> be the same as just IOSQE_LINK. It would be nice to retain that for
> 
> Probably, you meant it to be the same as __IOSQE_HARDLINK__
> 
>> something else, but I think it'll be more confusing to users.
>>
> 
> Yeah, and it's easier for something like:
> 
> sqe->flags |= IOSQE_LINK;
> [some code]
> if (timer_or_whatever())
> 	sqe->flags |= IOSQE_HARDLINK;

Precisely. So let's keep it as-is.


-- 
Jens Axboe

