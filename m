Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D2C973EB4F
	for <lists+io-uring@lfdr.de>; Mon, 26 Jun 2023 21:54:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229482AbjFZTxE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 26 Jun 2023 15:53:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbjFZTxE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 26 Jun 2023 15:53:04 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6E32170A
        for <io-uring@vger.kernel.org>; Mon, 26 Jun 2023 12:53:02 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id d2e1a72fcca58-668842bc50dso866606b3a.1
        for <io-uring@vger.kernel.org>; Mon, 26 Jun 2023 12:53:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1687809182; x=1690401182;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Il2Ebld5dOOrFLvG0yODnGkPmBN1OogyN9rETKNjNk4=;
        b=YwmitLN2nF7S0aVyWyhmCXX3hUUbd+S7oSdQc6S9AuAFYQ4SYgs+7YhvpUOtr4TZ5f
         pAGLKBmTX0Iuu+n8g01LamVq5sLx0b9i+oYpnTmwR2NCKLpPfQJCntLzC7/LIhRHW21x
         fjTP8Q+Hjr0IFsDpe0PcFEqd3wI+w0dkscfkJds4h3rtZt9bpPZvD+PCR7p+8ZXkNz1C
         7m7eq1kUYjC3/x7C6w4DF3yozGXzY2Zx2c2evmbsXLyaSakjLfneH73+iAd6S7/1y302
         eks0ozDyBde9iFRjNF5nSn8Dpqr836RJxD+aL96gxmjO24I9VXjxnjw6dwXH/Z1rqTMl
         1NUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687809182; x=1690401182;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Il2Ebld5dOOrFLvG0yODnGkPmBN1OogyN9rETKNjNk4=;
        b=Xv+LJ4XKe1ZcBRwkh6PSapFyv8sPc5AbxGgSVEW4/fnFucYgyoCmrj5kfdeiFNXv9P
         oYF9qYu1xsPKJon+FQJ6m+tmikHkRQjIY5g2Bbu9XLOqvrDJ4AfjvJICe3Smo7Fp9Tvh
         MHF/2UmNfdKDYA7MJcRKWRi/cRdeWXqYUV+cCIXuxSGhX0C61Wwl8PyeQiPsRFkaZ1Yl
         eX6/I7ba9WTo2JhEraX8+kZOq8CE/QuaEiTOqBzZQEcUuJyTRrVFksMCP6VHAFE5uK35
         R4cHKRfqGOkUWIGwQGmeYQ1JD0HZnYIaEODTDqDguzI5vBDsQPfrNpYdOCN1PbMR0UTE
         zrsQ==
X-Gm-Message-State: AC+VfDw5ET6Z/QZYIjFuH3GppSOHsIpP0YeuQxcy/E9sHLJXKQLV4A0I
        jTmVFkAyFFMERVVgjmS7fI7R6KMSKMSjTPpz070=
X-Google-Smtp-Source: ACHHUZ5RW4Mg8pXxW12HcsUqAJVx0bcGXG5JW4BrVLRCMLO3J/cFAoeHMQHAvW+oz+8eBD5VgAm9xA==
X-Received: by 2002:a17:902:d489:b0:1ae:7ba2:1a7e with SMTP id c9-20020a170902d48900b001ae7ba21a7emr35392597plg.6.1687809182246;
        Mon, 26 Jun 2023 12:53:02 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id gm4-20020a17090b100400b0025023726fc4sm3210418pjb.26.2023.06.26.12.53.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Jun 2023 12:53:01 -0700 (PDT)
Message-ID: <325183cb-a5c8-57cc-cd2e-f84bc5b492fc@kernel.dk>
Date:   Mon, 26 Jun 2023 13:53:00 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [GIT PULL] io_uring updates for 6.5
Content-Language: en-US
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>
References: <6e13b6a5-aa10-75f8-973d-023b7aa7f440@kernel.dk>
 <CAHk-=wjKb24aSe6fE4zDH-eh8hr-FB9BbukObUVSMGOrsBHCRQ@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CAHk-=wjKb24aSe6fE4zDH-eh8hr-FB9BbukObUVSMGOrsBHCRQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/26/23 1:40?PM, Linus Torvalds wrote:
> On Sun, 25 Jun 2023 at 19:39, Jens Axboe <axboe@kernel.dk> wrote:
>>
>> Will throw a minor conflict in io_uring/net.c due to the late fixes in
>> mainline, you'll want to keep the kmsg->msg.msg_inq = -1U; assignment
>> there.
> 
> Can you please share some of those drugs you are on?
> 
> Or, better yet, admit you have a problem, and flush those things down
> the toilet.
> 
> That
> 
>         kmsg->msg.msg_inq = -1U;
> 
> pattern is complete insanity.
> 
> It's truly completely insane, because:
> 
>  (a) the whole concept of "-1U" is broken garbage
> 
>  (b) msg_inq is an 'int', not "unsigned int"
> 
> I want to note that assigning "-1" to an unsigned variable is fine,
> and makes perfect sense. "-1" is signed, so if the unsigned variable
> is larger, then the sign extension means that assigning "-1" is the
> same as setting all bits. Look, no need to worry about the size of the
> end result, it always JustWorks(tm).
> 
> Ergo: -1 is fine - regardless of whether the end result is signed or unsigned.
> 
> But doing the same with "-1U" is *dangerous". Because "-1U" is an
> unsigned int, if you assign it to some larger entity, you basically
> get a random end result that depends on the size of 'int' and the size
> of the destination.
> 
> So any time you see something like "-1U", you should go "those are
> some bad bad drugs".
> 
> It doesn't just look odd - it's actively *WRONG*. It's *STUPID*. And
> it's *DANGEROUS*.
> 
> Lookie here: the same completely bogus pattern exists in some testing too:
> 
> io_uring/net.c:
> 
>         if (msg->msg_inq && msg->msg_inq != -1U)
> 
> and it all happens to work, but it happens to work for all the wrong
> reasons. Because  -1U is unsigned, the "msg->msg_inq != -1U"
> comparison is done as "unsigned int", and msg->msg_inq (which contains
> a *signed* -1) becomes 4294967295, and it all matches.
> 
> But while it happens to work, it's entirely illogical and makes no sense at all.
> 
> And if you ever end up in the situation that something is extended to
> 'long', it will break horribly on 64-bit architectures, since now
> "-1U" will literally be 4294967295, while "msg->msg_inq" will become
> -1l, and the two are *not* the same.

Oops yes, I can get that cleaned up. It doesn't really matter in here,
as all we need to know is "did someone assign this value or not", to
avoid relying on msg_inq _always_ returning something when we ask for
it. The actual value of it is way less interesting. Worst case scenario
here is an extra round trip if the available data just happened to
match, which seems basically impossible.

But do agree that it's confusing and bogus, will just change it to -1
in assignment and test that should be it.

> I'm doing this pull, but I want this idiocy fixed.

Thanks! I'll address it in the pre-rc1 pull.

-- 
Jens Axboe

