Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2CE5A158DAC
	for <lists+io-uring@lfdr.de>; Tue, 11 Feb 2020 12:44:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728392AbgBKLn7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 11 Feb 2020 06:43:59 -0500
Received: from mail-lf1-f68.google.com ([209.85.167.68]:46880 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727821AbgBKLn6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 11 Feb 2020 06:43:58 -0500
Received: by mail-lf1-f68.google.com with SMTP id z26so6720135lfg.13;
        Tue, 11 Feb 2020 03:43:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=UKY2yNx98f0wrxQO2HifQLDDgPXF2YxanFOgdecaNyI=;
        b=r0EBCoAccyjLPKtQMY0NTREF8UT8hrsi5GEnZgNbFh1YavxNM/H8Ak40cXs/BzFSFC
         IaOs1dQxW322nSC9V5zU/roamH07Lp9XCSRSQ0fQIEiK4CN7OTWiivZgDMmiD/lw1WAj
         9KIraaVm5R5fdtxvzZnvvgSGhRgUFH5gVRVFzY28KFjpAn8R07ltm0QLa5UFo1/9qH92
         T/c5swV32IgZb5Ms7HGN+0c35bWoOhsbf+HJixcyeIVlzzs9IYHOTCgUJEHBa9MTCxmN
         Dpv43snYl0pvee0ddBRbpwJ/cs/BLOxzDvD4q5ksq9jpd+/fNs9zz2a33v+5/P4ahdsw
         OUkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=UKY2yNx98f0wrxQO2HifQLDDgPXF2YxanFOgdecaNyI=;
        b=ENCwCacfkB9u3ejDCwXzgy7coTZ7jIhrkI5okUiT4ybcSRUp/f0rXByctSQ1FUMF3L
         4LlO3x8mZUTHVpscc3xO8iVJ3zzjlnsO30o1SQWSlZfobl3es780ks8dZO2fEqMHu22Y
         lpdDAAz4JgCq4w1vfVKUytjSaxmkTmT3tK8Rjv/eNSem5c/6/BgpF2rKvx8p/mYGF229
         2osmBvpzI582jE+q/MunKgJXIsrPp0IZwCu8ctEJnbPfCgxwlagZJOgf4IxBeAF3EXJY
         fekpi12FYHNgdYes/fP1NKFWDrBAhd0OKgGErjpWwOacmVW7TdL1TuBWxGJBTY0171Z/
         5JnQ==
X-Gm-Message-State: APjAAAWQfagL33EFoj0mERHJ4f15+aF8LT6u7YF9DLiXc99zBm+l4aTq
        +C0MN5WumBLtNiCaTRvz8HP7LVyp8To=
X-Google-Smtp-Source: APXvYqzWuAJpq72GudvR3+/Z4gnGDgUTpVbNIlhzZ9v/jc676ulj40rkir7Tq0UAL125Doa9s2hTpg==
X-Received: by 2002:a05:6512:15d:: with SMTP id m29mr3501323lfo.51.1581421435240;
        Tue, 11 Feb 2020 03:43:55 -0800 (PST)
Received: from [172.31.190.83] ([86.57.146.226])
        by smtp.gmail.com with ESMTPSA id v9sm2038325lfe.18.2020.02.11.03.43.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Feb 2020 03:43:54 -0800 (PST)
Subject: Re: [PATCH] io_uring: fix iovec leaks
To:     David Laight <David.Laight@ACULAB.COM>,
        Jens Axboe <axboe@kernel.dk>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <03aa734fcea29805635689cc2f1aa648f23b5cd3.1581102250.git.asml.silence@gmail.com>
 <1255e56851a54c8c805695f1160bec9f@AcuMS.aculab.com>
 <045f6c04-a6d8-146c-75f3-2c0d65e482d6@gmail.com>
 <0d61cafdb0b040ac8bb3542b6022d0fc@AcuMS.aculab.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <ff8ab9da-6548-647a-a375-4aab13e86c74@gmail.com>
Date:   Tue, 11 Feb 2020 14:43:53 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <0d61cafdb0b040ac8bb3542b6022d0fc@AcuMS.aculab.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/11/2020 2:16 PM, David Laight wrote:
> From: Pavel Begunkov
>> Sent: 11 February 2020 11:05
>> On 2/11/2020 1:07 PM, David Laight wrote:
>>> From: Pavel Begunkov
>>>> Sent: 07 February 2020 19:05
>>>> Allocated iovec is freed only in io_{read,write,send,recv)(), and just
>>>> leaves it if an error occured. There are plenty of such cases:
>>>> - cancellation of non-head requests
>>>> - fail grabbing files in __io_queue_sqe()
>>>> - set REQ_F_NOWAIT and returning in __io_queue_sqe()
>>>> - etc.
>>>>
>>>> Add REQ_F_NEED_CLEANUP, which will force such requests with custom
>>>> allocated resourses go through cleanup handlers on put.
>>>
>>> This looks horribly fragile.
>>
>> Well, not as horrible as it may appear -- set the flag, whenever you
>> want the corresponding destructor to be called, and clear it when is not
>> needed anymore.
>>
>> I'd love to have something better, maybe even something more intrusive
>> for-next, but that shouldn't hurt the hot path. Any ideas?
> 
> Given all the 'cud chewing' that happens in code paths
> like the one that read iov from userspace just adding:
> 
> 	if (unlikely(foo->ptr))
> 		kfree(foo->ptr);
> 
> before 'foo' goes out of scope (or is reused) is probably
> not measurable.

There are a bunch of problems with it:

1. "out of scope" may end up in the generic code, but not opcode
handler, so the deallocation should be in the generic path, otherwise
it'll leak.

2. @iovec is an opcode-specific thing, so you would need to call a
proper destructor. And that's an indirect call or a switch (as in the
cleanup()) in the hot path.

2. we may need several such resources and/or other resource types (e.g.
struct file, which is needed for splice(2).

4. such fields are not initialised until custom opcode handler came to
the scene. And I'm not sure zeroing will solve all cases and won't hurt
performance. Workarounds with something like REQ_F_INITIALISED are not
much better.

That's why I think it's good enough for an immediate fix, it solves the
issue and is easy to be backported. It'd be great to look for a more
gracious approach, but that's most probably for 5.7

> 
> 	David
> 
> -
> Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
> Registration No: 1397386 (Wales)
> 

-- 
Pavel Begunkov
