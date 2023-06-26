Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A25A573EB3D
	for <lists+io-uring@lfdr.de>; Mon, 26 Jun 2023 21:40:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229610AbjFZTkg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 26 Jun 2023 15:40:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbjFZTkf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 26 Jun 2023 15:40:35 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A31E10E4
        for <io-uring@vger.kernel.org>; Mon, 26 Jun 2023 12:40:34 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id a640c23a62f3a-991fee3a6b1so43764866b.0
        for <io-uring@vger.kernel.org>; Mon, 26 Jun 2023 12:40:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1687808432; x=1690400432;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=L4y9ZBGrQE8/wi7YGbNA0VoG+Zz7t6nS8ucVRvGnxug=;
        b=hLe+fW7D4O9Ea5scddC6gEoX+eVuSRzdSMz/lrw+O932xvoe2NnNxlQ+HbvK0QV6o2
         PpuuqQkmd/9k0qN7KkD8h08X+Tw11D6Q+oAmkngetJfdt5XZj3QxHuTutXpSEB8ODqMX
         TbAgTAGIfIV8MJw9OHEXF0WFFSecwHvtzhNfg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687808432; x=1690400432;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=L4y9ZBGrQE8/wi7YGbNA0VoG+Zz7t6nS8ucVRvGnxug=;
        b=N9zxdOdY/EPfD006jGiVhBBoz58yFiDBw68XDxcYLfYcxo1j2CEUOEo5bNECD4W3ce
         DA9xSRXfZw9cHoSZypKUIjopOnFetjX6SVNSdv8NOphxFYpTRvgHZFrFt6+nYi0CIYNc
         I5lcyIrypNMzaqqkHYcYUrpVwrRbzBikwFQ2WLzbY8TdtITe+j0rU0pCk40SySXjAgvs
         HVAeL7icosUeGDE3+6xljM7RlOyn3MGATt8N/IiF7qM863e4/lPXoovmZ16NKP99ySSI
         aWJtq7BnHdQqNe+IaWn41CiEhXKWa3Q8LZcy42pDNoEHFYStkLaDwwSd13I10G5acbsy
         bPyw==
X-Gm-Message-State: AC+VfDyIswYwW2bov4UuWG8uso1sNt01L+SZH0Km0xCm5u2FBiaP7kjj
        p5o4L8+fB1Z5tkkOkdDLNm3bX+oEUm7uqJeE0ZAXRVZ5
X-Google-Smtp-Source: ACHHUZ59RovRN2te1dWNbZxI8RXpZnxW2yIOGZS77PNk+a4U+EDPKHwmIIM7q9k14MX/iEECqHOp+g==
X-Received: by 2002:a17:906:4fd1:b0:974:1c98:d2d9 with SMTP id i17-20020a1709064fd100b009741c98d2d9mr27123779ejw.3.1687808432459;
        Mon, 26 Jun 2023 12:40:32 -0700 (PDT)
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com. [209.85.208.42])
        by smtp.gmail.com with ESMTPSA id l9-20020a1709060e0900b0098de7d28c34sm3535354eji.193.2023.06.26.12.40.31
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Jun 2023 12:40:31 -0700 (PDT)
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-51d7f350758so3782753a12.3
        for <io-uring@vger.kernel.org>; Mon, 26 Jun 2023 12:40:31 -0700 (PDT)
X-Received: by 2002:a05:6402:2d1:b0:51c:d01d:ce7 with SMTP id
 b17-20020a05640202d100b0051cd01d0ce7mr5668689edx.33.1687808431435; Mon, 26
 Jun 2023 12:40:31 -0700 (PDT)
MIME-Version: 1.0
References: <6e13b6a5-aa10-75f8-973d-023b7aa7f440@kernel.dk>
In-Reply-To: <6e13b6a5-aa10-75f8-973d-023b7aa7f440@kernel.dk>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 26 Jun 2023 12:40:14 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjKb24aSe6fE4zDH-eh8hr-FB9BbukObUVSMGOrsBHCRQ@mail.gmail.com>
Message-ID: <CAHk-=wjKb24aSe6fE4zDH-eh8hr-FB9BbukObUVSMGOrsBHCRQ@mail.gmail.com>
Subject: Re: [GIT PULL] io_uring updates for 6.5
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sun, 25 Jun 2023 at 19:39, Jens Axboe <axboe@kernel.dk> wrote:
>
> Will throw a minor conflict in io_uring/net.c due to the late fixes in
> mainline, you'll want to keep the kmsg->msg.msg_inq = -1U; assignment
> there.

Can you please share some of those drugs you are on?

Or, better yet, admit you have a problem, and flush those things down
the toilet.

That

        kmsg->msg.msg_inq = -1U;

pattern is complete insanity.

It's truly completely insane, because:

 (a) the whole concept of "-1U" is broken garbage

 (b) msg_inq is an 'int', not "unsigned int"

I want to note that assigning "-1" to an unsigned variable is fine,
and makes perfect sense. "-1" is signed, so if the unsigned variable
is larger, then the sign extension means that assigning "-1" is the
same as setting all bits. Look, no need to worry about the size of the
end result, it always JustWorks(tm).

Ergo: -1 is fine - regardless of whether the end result is signed or unsigned.

But doing the same with "-1U" is *dangerous". Because "-1U" is an
unsigned int, if you assign it to some larger entity, you basically
get a random end result that depends on the size of 'int' and the size
of the destination.

So any time you see something like "-1U", you should go "those are
some bad bad drugs".

It doesn't just look odd - it's actively *WRONG*. It's *STUPID*. And
it's *DANGEROUS*.

Lookie here: the same completely bogus pattern exists in some testing too:

io_uring/net.c:

        if (msg->msg_inq && msg->msg_inq != -1U)

and it all happens to work, but it happens to work for all the wrong
reasons. Because  -1U is unsigned, the "msg->msg_inq != -1U"
comparison is done as "unsigned int", and msg->msg_inq (which contains
a *signed* -1) becomes 4294967295, and it all matches.

But while it happens to work, it's entirely illogical and makes no sense at all.

And if you ever end up in the situation that something is extended to
'long', it will break horribly on 64-bit architectures, since now
"-1U" will literally be 4294967295, while "msg->msg_inq" will become
-1l, and the two are *not* the same.

I don't know who came up with this crazy pattern, but it must die.
"-1U" is garbage. Yes, it means "all bits set in an 'unsigned int'",
so it does have real semantics, but dammit, those semantics are very
seldom the ones you want.

They most *definitely* aren't the ones you want if you then mix things
with a signed type.

And yes, greping for this I found some truly disgusting things elsewhere too:

mm/zsmalloc.c:
        set_freeobj(zspage, (unsigned int)(-1UL));

net/core/rtnetlink.c:
        filters->mask[i] = -1U;

both of which are impressively confused. There's sadly a number of
other cases too.

That zsmalloc.c case is impressively crazy. First you use the wrong
type, then you use the wrong operation, and then you use a cast to fix
it all up. Absolutely none of which makes any sense, and it should
just have used "-1".

The rtnetlink case is also impressive, since mask[] isn't even an
array of 'unsigned int', but a 'u32'. They may be the same thing in
the end, but it's a sign of true confusion to think that "-1u" is
somehow fine.

Again, if you want to assign "all bits set" to a random unsigned type,
just use "-1". Sign extension is _literally_ your friend, the whole
world is 2's complement, and it's the only reason "-1" works in the
first place.

And if what you want is a particular unsigned type with all bits set
(say, unsigned long), I suggest you use "~0ul" to indicate that.

Because if you don't want to rely on sign extension, just use the
actual bit operation, for chrissake!

Ok, that was a rant about code that happens to work, but that is crap
regardless.

I'm doing this pull, but I want this idiocy fixed.

Writing illogical code, and then relying (probably without realizing
it) on some of the stranger parts of the implicit integer type
conversions in C to make that code work, that is just not good.

           Linus
