Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B3AD692A89
	for <lists+io-uring@lfdr.de>; Fri, 10 Feb 2023 23:51:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234003AbjBJWvO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 10 Feb 2023 17:51:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233987AbjBJWvM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 10 Feb 2023 17:51:12 -0500
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D56D46081
        for <io-uring@vger.kernel.org>; Fri, 10 Feb 2023 14:51:11 -0800 (PST)
Received: by mail-pg1-x532.google.com with SMTP id x10so4760481pgx.3
        for <io-uring@vger.kernel.org>; Fri, 10 Feb 2023 14:51:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1676069470;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fb0hD2Is8tutzPK+FUgjJONSqvcKdsnxAi3Fd+q9FbI=;
        b=gkumRTQSpGTg1Kqk07BCblcvpz+kIS0Whxwm0RF9IhQRDH7wkfO3l8yye1TRollGbB
         Hq1V4lOJX3TAwP11uiv+z3P/yi3g5dTsVW/hLWuEw/+ow8uJ209kOmB3FV3oReUd9M8C
         cb3pDM3CZEEWZezA/Zvtw8/qQ1OOCKjhBrTsRnnymRki0layjIjTH0LDcoxCi4x/J3vN
         vMsCzYCCZ3t1/DMQtj0njviLxiZ2tU9+lUzwjgLwAhx1j1ocgIVJwU3pQF7s6er1krg6
         +O65C1zrlQZIReQoTSKNK8fqePu7aXE5Yu/08tbpiMAvWZoPIhRK78w5shdrpwba/pnF
         Er+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1676069470;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fb0hD2Is8tutzPK+FUgjJONSqvcKdsnxAi3Fd+q9FbI=;
        b=BWDakAO+ezuIf9iCYzhVl0KyYkzirab5jPXcdaC5ZKjibCeQ6uHmL1gEYeCWQVhwpL
         vEHAUIBJtM/yw897HdDI9+AiU12rPk7wlTsTQB6GEE46qQLvWVeXmKhrq8ajcUyqSRlz
         AqNSROmIWgT67R7jJ5tpjkYIeu6KX7BX25eSf9PhF/53Vtr7C5Nf6FJOYVHjvYJinzo/
         koOLXHYBnt15tWDjG3YqgS6M5A/P0TOsOgrGYo0z/b+C1BtSlUE/JHWGk+WR7L8qIPKf
         27pO7qrISm9bLb+1AZL6ENXDY1a0+e6tlMbgjqPRYg8Pez1iOcV5IxRN19VB4Q1/l+PQ
         CTmQ==
X-Gm-Message-State: AO0yUKVCL1F8KT5zHq4oN9g5MBOrvofQUPfxZBp9jkRVr8GKYNw4fZot
        oZDPiV1UIz6Od/6IC2+hci4YsA==
X-Google-Smtp-Source: AK7set9QlYq/MSDUz7QhtZ618g3YDbVybvJOz+1kV8etdZ6/r0TOGrNahZypoZavFHpy28vDf9oNWA==
X-Received: by 2002:a62:82c6:0:b0:5a8:4c4e:fc01 with SMTP id w189-20020a6282c6000000b005a84c4efc01mr8503622pfd.2.1676069470503;
        Fri, 10 Feb 2023 14:51:10 -0800 (PST)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id e13-20020a62aa0d000000b00582388bd80csm3729845pff.83.2023.02.10.14.51.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Feb 2023 14:51:10 -0800 (PST)
Message-ID: <70a61a9a-f5a3-09d6-91b6-bf2355d3919c@kernel.dk>
Date:   Fri, 10 Feb 2023 15:51:08 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: copy on write for splice() from file to pipe?
Content-Language: en-US
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Ming Lei <ming.lei@redhat.com>, Andy Lutomirski <luto@kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        Matthew Wilcox <willy@infradead.org>,
        Stefan Metzmacher <metze@samba.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux API Mailing List <linux-api@vger.kernel.org>,
        io-uring <io-uring@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Samba Technical <samba-technical@lists.samba.org>
References: <0cfd9f02-dea7-90e2-e932-c8129b6013c7@samba.org>
 <CAHk-=wjuXvF1cA=gJod=-6k4ypbEmOczFFDKriUpOVKy9dTJWQ@mail.gmail.com>
 <CALCETrUXYts5BRZKb25MVaWPk2mz34fKSqCR++SM382kSYLnJw@mail.gmail.com>
 <CAHk-=wgA=rB=7M_Fe3n9UkoW_7dqdUT2D=yb94=6GiGXEuAHDA@mail.gmail.com>
 <1dd85095-c18c-ed3e-38b7-02f4d13d9bd6@kernel.dk>
 <CAHk-=wiszt6btMPeT5UFcS=0=EVr=0injTR75KsvN8WetwQwkA@mail.gmail.com>
 <fe8252bd-17bd-850d-dcd0-d799443681e9@kernel.dk>
 <CAHk-=wiJ0QKKiORkVr8n345sPp=aHbrLTLu6CQ-S0XqWJ-kJ1A@mail.gmail.com>
 <7a2e5b7f-c213-09ff-ef35-d6c2967b31a7@kernel.dk>
 <CALCETrVx4cj7KrhaevtFN19rf=A6kauFTr7UPzQVage0MsBLrg@mail.gmail.com>
 <b44783e6-3da2-85dd-a482-5d9aeb018e9c@kernel.dk>
 <2bb12591-9d24-6b26-178f-05e939bf3251@kernel.dk>
 <CAHk-=wjzqrD5wrfeaU390bXEEBY2JF-oKmFN4fREzgyXsbQRTQ@mail.gmail.com>
 <CAHk-=wjUjtLjLbdTz=AzvGekyU1xiSL-wAAb7_j_XoT9t4o1vQ@mail.gmail.com>
 <824fa356-7d6e-6733-8848-ab84d850c27a@kernel.dk>
 <CAHk-=wg3gLL-f6XkQo4vw42Q+ySPrMdprNL1dxNrr3RGHzhnrw@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CAHk-=wg3gLL-f6XkQo4vw42Q+ySPrMdprNL1dxNrr3RGHzhnrw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/10/23 3:35?PM, Linus Torvalds wrote:
> On Fri, Feb 10, 2023 at 2:26 PM Jens Axboe <axboe@kernel.dk> wrote:
>>>
>>> (I actually suspect that /dev/zero no longer works as a splice source,
>>> since we disabled the whole "fall back to regular IO" that Christoph
>>> did in 36e2c7421f02 "fs: don't allow splice read/write without
>>> explicit ops").
>>
>> Yet another one... Since it has a read_iter, should be fixable with just
>> adding the generic splice_read.
> 
> I actually very consciously did *not* want to add cases of
> generic_splice_read() "just because we can".
> 
> I've been on a "let's minimize the reach of splice" thing for a while.
> I really loved Christoph's patches, even if I may not have been hugely
> vocal about it. His getting rid of set/get_fs() got rid of a *lot* of
> splice pain.
> 
> And rather than try to make everything work with splice that used to
> work just because it fell back on read/write, I was waiting for actual
> regression reports.
> 
> Even when splice fails, a lot of user space then falls back on
> read/write, and unless there is some really fundamental reason not to,
> I think that's always the right thing to do.
> 
> So we do have a number of "add splice_write/splice_read" commits, but
> they are hopefully all the result of people actually noticing
> breakage.
> 
> You can do
> 
>      git log --grep=36e2c7421f02
> 
> to see at least some of them, and I really don't want to see them
> without a "Reported-by" and an actual issue.

Oh I already did that the last few times (and there's quite a bit). And
while I agree that getting rid of the ancient set/get_fs bits was great,
it is still annoying to knowingly have regressions. The problem with
this approach is that the time from when you start the "experiment" to
when the first report comes in, it'll take a while as most don't run
-git kernels at all. And the ones that do are generally just standard
distro setups on their workstation/laptop.

The time is my main concern, it takes many years before you're fully
covered. Maybe if that series had been pushed to stable as well we'd
have a better shot at weeding them out.

> Exactly because I'm not all that enamoured with splice any more.

I don't think anyone has been for years, I sure have not and haven't
worked on it in decades outside of exposing some for io_uring.The
latter was probably a mistake and we should've done something else, but
there is something to be said for the devil you know... Outside of that,
looks like the last real change was support for bigger pipes in 2010.
But:

1) Interesting bits do come up. Some of these, as this discussion has
   highlighted, are probably better served somewhere else, especially if
   they require changes/additions. Some may be valid and fine.

2) Knowingly breaking things isn't very nice, and if anyone else did
   that, they'd have you screaming at them.

So while I do kind of agree with you on some points, I don't think it
was done very well from that perspective. And when we spot things like
zero not working with splice, we should probably add the patch to make
it work rather than wait for someone to complain. I just recently had to
fixup random/urandom for that because of a report, and I'd like to think
I have better things to do than deal with known fallout.

-- 
Jens Axboe

