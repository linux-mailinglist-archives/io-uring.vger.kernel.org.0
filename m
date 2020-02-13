Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5477015C12A
	for <lists+io-uring@lfdr.de>; Thu, 13 Feb 2020 16:14:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727671AbgBMPOu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 13 Feb 2020 10:14:50 -0500
Received: from mail-il1-f171.google.com ([209.85.166.171]:37957 "EHLO
        mail-il1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727742AbgBMPOu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 13 Feb 2020 10:14:50 -0500
Received: by mail-il1-f171.google.com with SMTP id f5so5260795ilq.5
        for <io-uring@vger.kernel.org>; Thu, 13 Feb 2020 07:14:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=IdPuhyh0Vn4sM4f9nVAZGziVd1L1hk6h2JT3aOkHIU8=;
        b=xBg2srfjgYR1seqCLNO9O/m8iOK6ikG+SKo7ezOIF3Xlc9fsj7iIQpuX1yU1T9l2ez
         5iIf20igqnqX1CWv6yH1P33lI3rN0OMTeghn4FtnWWfcCA5SBL9+r59IyoqostqKy20L
         LMJ4IBO5dkvCFb8dhwhZjRRG0DO4juv5Z4YoyoDLw7YfBuoVQnzHalcGhvUqQloOt7bj
         SK1n6a0w/XOb8a+hGJvchE8l5FR565L7pTuk8BWSlGnIMi94oCLk9PWmagiJAytwo1Ja
         i96PizoYcFbCVH5psAUVqwuu8lPgPPHWrL4M/m0xZZrNCVo394m7QBwKwK8jZ9D7+pEP
         rfww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=IdPuhyh0Vn4sM4f9nVAZGziVd1L1hk6h2JT3aOkHIU8=;
        b=dBJbgL0siHcWn3I6GdeOEoPACEizuDYw2yxZWtXjFZkg4pQ2Pj1SAdizBPMsMyr0Fx
         +Jz52UVdwUQXIzQUGCUT+UFC3JJ0benrmSvEeIUPz2d8G14+ph7ctc+J3Y5Ryvwww8PF
         N6n+OuzBsgxUrpYj7mN13VuaPvrLs6CgNAb9MKIRhcjaD6vxgagby3npWBb6rovO3tun
         taKT3geccvZEUIHNO6JMN567JzL5U6NtNprT2I8wITN7/zfvaZLup9rm8HG/Hch54V6Y
         Xs9mIiXfylQeK+mBgD7j3Cd9/7xzPxmKiQd15vK7j0bhii4OwEWygduXuZ7I0WF2XUtl
         v0pg==
X-Gm-Message-State: APjAAAXPJK4Jb3mgE24tD04wNet0DxSSdyNZ30vhw8Xy1NuOtDz3l1hb
        Y3CdvE2Gc+fO5/gf0QyLpuK8cMDOwj8=
X-Google-Smtp-Source: APXvYqwxK1xdC0ojhrQktMz77QArh64y4jUBNzLO8hFzf5MKcHlw9xipwNFQkrc40HYVPDxk7KT6PA==
X-Received: by 2002:a92:4013:: with SMTP id n19mr16316300ila.279.1581606889383;
        Thu, 13 Feb 2020 07:14:49 -0800 (PST)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id m6sm725204ioc.52.2020.02.13.07.14.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Feb 2020 07:14:48 -0800 (PST)
Subject: Re: [ISSUE] The time cost of IOSQE_IO_LINK
To:     Pavel Begunkov <asml.silence@gmail.com>,
        =?UTF-8?B?Q2FydGVyIExpIOadjumAmua0sg==?= <carter.li@eoitek.com>
Cc:     io-uring <io-uring@vger.kernel.org>
References: <9FEF0D34-A012-4505-AA4E-FF97CC302A33@eoitek.com>
 <8a3ee653-77ed-105d-c1c3-87087451914e@kernel.dk>
 <ADF462D7-A381-4314-8931-DDB0A2C18761@eoitek.com>
 <9a8e4c8a-f8b2-900d-92b6-cc69b6adf324@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <5f09d89a-0c6d-47c2-465c-993af0c7ae71@kernel.dk>
Date:   Thu, 13 Feb 2020 08:14:47 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <9a8e4c8a-f8b2-900d-92b6-cc69b6adf324@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/13/20 8:08 AM, Pavel Begunkov wrote:
> On 2/13/2020 3:33 AM, Carter Li 李通洲 wrote:
>> Thanks for your reply.
>>
>> You are right the nop isn't really a good test case. But I actually
>> found this issue when benchmarking my echo server, which didn't use
>> NOP of course.
> 
> If there are no hidden subtle issues in io_uring, your benchmark or the
> used pattern itself, it's probably because of overhead on async punting
> (copying iovecs, several extra switches, refcounts, grabbing mm/fs/etc,
> io-wq itself).
> 
> I was going to tune async/punting stuff anyway, so I'll look into this.
> And of course, there is always a good chance Jens have some bright insights

The main issue here is that if you do the poll->recv, then it'll be
an automatic punt of the recv to async context when the poll completes.
That's regardless of whether or not we can complete the poll inline,
we never attempt to recv inline from that completion. This is in contrast
to doing a separate poll, getting the notification, then doing another
sqe and io_uring_enter to perform the recv. For this case, we end up
doing everything inline, just with the cost of an additional system call
to submit the new recv.

It'd be really cool if we could improve on this situation, as recv (or
read) preceded by a poll is indeed a common use case. Or ditto for the
write side.

> BTW, what's benefit of doing poll(fd)->read(fd), but not directly read()?

If there's no data to begin with, then the read will go async. Hence
it'll be a switch to a worker thread. The above should avoid it, but
it doesn't.

For carter's sake, it's worth nothing that the poll command is special
and normal requests would be more efficient with links. We just need
to work on making the poll linked with read/write perform much better.

-- 
Jens Axboe

