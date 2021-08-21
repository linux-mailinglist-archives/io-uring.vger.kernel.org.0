Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C78BC3F3B8A
	for <lists+io-uring@lfdr.de>; Sat, 21 Aug 2021 18:51:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229836AbhHUQv4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 21 Aug 2021 12:51:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229744AbhHUQvz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 21 Aug 2021 12:51:55 -0400
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 305CBC061756
        for <io-uring@vger.kernel.org>; Sat, 21 Aug 2021 09:51:16 -0700 (PDT)
Received: by mail-io1-xd2a.google.com with SMTP id b200so16260207iof.13
        for <io-uring@vger.kernel.org>; Sat, 21 Aug 2021 09:51:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=EEkaJRkk7fbk+mpizy2Vd2alX2yC8T1hkBH60Wl8mj4=;
        b=qtIIpE8SBufQLuQamnrSS8zuw+V6BaKXuLbwznif/nkW3WYUpN6PQKVvRLSmh4s0hs
         qOGUBcO1i0eF56zN80pkrvfBfzP4CkmMX6y455hc0xeoL0Yu8v6qZ1B3OSyPlbZTCP7T
         70q8spNeDQ6sICI9Kku+z0VmJZhBNrvh7cuADuqqGqccuBQxDqic+yuSYwSecm6v/uNj
         Er/PjAKAelp30OfRd0SwqWiSxYCBoOp+l7NqAt6JRX3KDvB31+8uSB1V1HEf6rFVC/Yc
         E/5kj9qMM93n4Y5aWcG8P0juniweRu+ftv10itW9au38En+QYjTRFpmASDfAZJ2GQSrw
         nGCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=EEkaJRkk7fbk+mpizy2Vd2alX2yC8T1hkBH60Wl8mj4=;
        b=LVvjPBFNEo0duYHwLp5J9gGVNLhTAGb2YA5fFYwGe257qbJjLdwOlfn2h+gmu8hpUu
         GpGZ0zD6tDJfyYiCJLQ/IIQb2t2UwJZDbiAhEo5ZtzRjF9LQp2iSleXFDGpThdlI9ZwN
         +BlC966WgAu2vekv+T1JAcewS+a5+uBfKHsIMv6tOuiUlNibyPs6dD1GyIOmxITnFjyw
         GO13XY2/qlpdeN9I+atYyNo82C9r9g1qzvoaMu11YTRF5ohYDRH0l8BnlV5D1vtD11zv
         k/v3FrhcZaZA1pawggPPHbWBwdiQJHmFasz2oIe8S+sZKYRt5poRw2jAYhtUxxpP5UVe
         PqwQ==
X-Gm-Message-State: AOAM531bx+JW/rVsth2AeimZrOOAK32Qd8Qp6FlTwFju5P4TpWPdpICl
        +kXUyqJJsAqNBMrNZDGH6DY0gg==
X-Google-Smtp-Source: ABdhPJzRbjW8cYmHY3WuWUeLxspyHeaVk3QR1ggwwbUYZBJeia1nl/6xm7/dBlV8Y8O7RyrOYd7jwA==
X-Received: by 2002:a02:2a07:: with SMTP id w7mr22897119jaw.96.1629564675481;
        Sat, 21 Aug 2021 09:51:15 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id p13sm5305098ils.69.2021.08.21.09.51.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 21 Aug 2021 09:51:15 -0700 (PDT)
Subject: Re: [PATCH] coredump: Limit what can interrupt coredumps
To:     Olivier Langlois <olivier@trillion01.com>,
        Tony Battersby <tonyb@cybernetics.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Oleg Nesterov <oleg@redhat.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        io-uring <io-uring@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "Pavel Begunkov>" <asml.silence@gmail.com>
References: <CAHk-=wjC7GmCHTkoz2_CkgSc_Cgy19qwSQgJGXz+v2f=KT3UOw@mail.gmail.com>
 <CAHk-=wiax83WoS0p5nWvPhU_O+hcjXwv6q3DXV8Ejb62BfynhQ@mail.gmail.com>
 <87y2bh4jg5.fsf@disp2133>
 <CAHk-=wjPiEaXjUp6PTcLZFjT8RrYX+ExtD-RY3NjFWDN7mKLbw@mail.gmail.com>
 <87sg1p4h0g.fsf_-_@disp2133> <20210614141032.GA13677@redhat.com>
 <87pmwmn5m0.fsf@disp2133>
 <4d93d0600e4a9590a48d320c5a7dd4c54d66f095.camel@trillion01.com>
 <8af373ec-9609-35a4-f185-f9bdc63d39b7@cybernetics.com>
 <9d194813-ecb1-2fe4-70aa-75faf4e144ad@kernel.dk>
 <b36eb4a26b6aff564c6ef850a3508c5b40141d46.camel@trillion01.com>
 <0bc38b13-5a7e-8620-6dce-18731f15467e@kernel.dk>
 <24c795c6-4ec4-518e-bf9b-860207eee8c7@kernel.dk>
 <05c0cadc-029e-78af-795d-e09cf3e80087@cybernetics.com>
 <b5ab8ca0-cef5-c9b7-e47f-21c0d395f82e@kernel.dk>
 <84640f18-79ee-d8e4-5204-41a2c2330ed8@kernel.dk>
 <c4578bef-a21a-2435-e75a-d11d13d42923@kernel.dk>
 <70526737949ab3ad2d8fc551531d286e0f3d88f4.camel@trillion01.com>
 <9dfb14c1a9ab686df0eeea553b39246bc5b51ede.camel@trillion01.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <ff80f66c-c364-fad3-4bab-4d4793538702@kernel.dk>
Date:   Sat, 21 Aug 2021 10:51:13 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <9dfb14c1a9ab686df0eeea553b39246bc5b51ede.camel@trillion01.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/21/21 10:47 AM, Olivier Langlois wrote:
> On Sat, 2021-08-21 at 06:08 -0400, Olivier Langlois wrote:
>> On Tue, 2021-08-17 at 20:57 -0600, Jens Axboe wrote:
>>>
>>> Olivier, I sent a 5.10 version for Nathan, any chance you can test
>>> this
>>> one for the current kernels? Basically this one should work for
>>> 5.11+,
>>> and the later 5.10 version is just for 5.10. I'm going to send it
>>> out
>>> separately for review.
>>>
>>> I do think this is the right solution, barring a tweak maybe on
>>> testing
>>> notify == TWA_SIGNAL first before digging into the task struct. But
>>> the
>>> principle is sound, and it'll work for other users of TWA_SIGNAL as
>>> well. None right now as far as I can tell, but the live patching is
>>> switching to TIF_NOTIFY_SIGNAL as well which will also cause issues
>>> with
>>> coredumps potentially.
>>>
>> Ok, I am going to give it a shot. This solution is probably superior
>> to
>> the previous attempt as it does not inject io_uring dependency into
>> the
>> coredump module.
>>
>> The small extra change that I alluded to in my previous reply will
>> still be relevant even if we go with your patch...
>>
>> I'll come back soon with your patch testing result and my small extra
>> change that I keep teasing about.
>>
>> Greetings,
>>
> Jens,
> 
> your patch doesn't compile with 5.12+. AFAIK, the reason is that
> JOBCTL_TASK_WORK is gone.
> 
> Wouldn't just a call to tracehook_notify_signal from do_coredump be
> enough and backward compatible with every possible stable branches?

That version is just for 5.10, the first I posted is applicable to
5.11+

-- 
Jens Axboe

