Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05F3440A2EC
	for <lists+io-uring@lfdr.de>; Tue, 14 Sep 2021 03:55:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231196AbhINB4P (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 13 Sep 2021 21:56:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229778AbhINB4O (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 13 Sep 2021 21:56:14 -0400
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49AD3C061574
        for <io-uring@vger.kernel.org>; Mon, 13 Sep 2021 18:54:58 -0700 (PDT)
Received: by mail-il1-x135.google.com with SMTP id h20so11350031ilj.13
        for <io-uring@vger.kernel.org>; Mon, 13 Sep 2021 18:54:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=0erCkbPikwMLr62Veop0dKdOeXPGtO5lGKpDOfqeSm4=;
        b=jzMs/winVEpIT8tzRmnXNyabIoFzL128yeGXAJc3mXV3/E5QXGYcIMEQCL7OAS6V2n
         pmtF8kewmpoxKo/EOBStEW7wQwzMmgy70jBee9PHUd1hp2s/QZ5ekQQKAvxXGVBUWvvK
         0fv7SS+Bugkk97DZAb6NjOwqYGqQZZR2NozVK3PGfxJvWlpkxOH1OnWLJBYe+51ChO87
         FU3MJs1nKgvb06JahrL1dSPkZgDv28rjoORldUUMqrCAfJCjrNg/my3EoBzX+pKQrYWn
         D8fNE6qF7d+71sJEREWcOKqpxJNkxfP/RCbVVqDtgUpeGM1YhYxtv58nEv6OerGN2d1T
         hUhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0erCkbPikwMLr62Veop0dKdOeXPGtO5lGKpDOfqeSm4=;
        b=6vnRt5ZazRrQyjIWnSJIeBqRWZERebifHXPFiOYQZGMeuzQWquRqpSCwo0X/iyKLOC
         cKH3x4B/5S5R26sy7fIFvbVnXyTWI/hbQ5mMGg13FWR+/vkpmThn4hYsb59mnJS+kL2+
         JcSBdkcOG6oGioNz6T9wfD1ZMAKsIHPen3MjrvlIP+KhkZ+6E2m5QT/f8v/bzgnnN117
         +ho9C5uMU3DfjD5WzhP3l3d6V02t2w4Jv9v4TeJOYhqfp3Vsa7o/yHSPjJNZEmQw8dbx
         6/B+A1IFDW4deY0pkCunlwk615GvYSOVDO6FmVq/5H7qCM5lt/SDeQdwOV524kz68SgQ
         jASw==
X-Gm-Message-State: AOAM530RZAS5GTmRGCd6/ed1VCeRl/voV7hnekQdluP0uhbdPlHfTpQn
        kBf7Gik+CcIM8LV1DVDcO1pPfg==
X-Google-Smtp-Source: ABdhPJyHsx8LbJr1XduO9auKgXhP/9RQ+NAYhME0MGMhFIh0W8h/g37XrvVVYzCmgxQh6HNI2SMq+Q==
X-Received: by 2002:a92:730c:: with SMTP id o12mr10347019ilc.208.1631584497586;
        Mon, 13 Sep 2021 18:54:57 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id s5sm5914403ilq.59.2021.09.13.18.54.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Sep 2021 18:54:57 -0700 (PDT)
Subject: Re: [PATCHSET 0/3] Add ability to save/restore iov_iter state
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
References: <20210910182536.685100-1-axboe@kernel.dk>
 <8a278aa1-81ed-72e0-dec7-b83997e5d801@kernel.dk>
 <CAHk-=wj3Lu=mJ8L7iE0RQXGZVdoSMz6rnPmrWoVNJhTaObOqkA@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <fc6649ca-7700-a8ca-2e37-6f93c8aadb4d@kernel.dk>
Date:   Mon, 13 Sep 2021 19:54:56 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAHk-=wj3Lu=mJ8L7iE0RQXGZVdoSMz6rnPmrWoVNJhTaObOqkA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/13/21 5:23 PM, Linus Torvalds wrote:
> On Mon, Sep 13, 2021 at 3:43 PM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> Al, Linus, are you OK with this? I think we should get this in for 5.15.
>> I didn't resend the whole series, just a v2 of patch 1/3 to fix that bvec
>> vs iovec issue. Let me know if you want the while thing resent.
> 
> So I'm ok with the iov_iter side, but the io_uring side seems still
> positively buggy, and very confused.
> 
> It also messes with the state in bad ways and has internal knowledge.
> And some of it looks completely bogus.
> 
> For example, I see
> 
>         state->count -= ret;
>         rw->bytes_done += ret;
> 
> and I go "that's BS". There's no way it's ok to start messing with the
> byte count inside the state like that. That just means that the state
> is now no longer the saved state, and it's some random garbage.
>
> I also think that the "bytes_done += ret" is a big hint there: any
> time you restore the iovec state, you should then forward it by
> "bytes_done". But that's not what the code does.
> 
> Instead, it will now restore the iovec styate with the *wrong* number
> of bytes remaining, but will start from the beginning of the iovec.
> 
> So I think the fs/io_uring.c use of this state buffer is completely wrong.
> 
> What *may* be the right thing to do is to
> 
>  (a) not mess with state->count
> 
>  (b) when you restore the state you always use
> 
>         iov_iter_restore(iter, state, bytes_done);
> 
> to actually restore the *correct* state.
> 
> Because modifying the iovec save state like that cannot be right, and
> if it's right it's still too ugly and fragile for words. That save
> state should be treated as a snapshot, not as a random buffer that you
> can make arbitrary changes to.
> 
> See what I'm saying?

OK, for the do while loop itself, I do think we should be more
consistent and that would also get rid of the state->count manipulation.
I do agree that messing with that state is not something that should be
done, and we can do this more cleanly and consistently instead. Once we
hit the do {} while loop, state should be &rw->state and we can
consistently handle it that way.

Let me rework that bit and run the tests, and I'll post a v2 tomorrow.
Thanks for taking a closer look.

-- 
Jens Axboe

