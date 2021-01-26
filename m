Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1226B304A2F
	for <lists+io-uring@lfdr.de>; Tue, 26 Jan 2021 21:37:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727712AbhAZFK3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 26 Jan 2021 00:10:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729457AbhAZBhB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 25 Jan 2021 20:37:01 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AF00C061A2E
        for <io-uring@vger.kernel.org>; Mon, 25 Jan 2021 17:06:40 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id d4so8755749plh.5
        for <io-uring@vger.kernel.org>; Mon, 25 Jan 2021 17:06:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=msNczVLXjgZZSNqJoDtvCOSNDEGSyBHHraGpFvbxsO8=;
        b=qu8NDQz9VIDYiiE+aX4ycUqTy/qPzyCGH4pAmy3kZ2zMz6MWC6r6cojPzJdHIR3csa
         MaISDZJmS6S2TBiiGBMhJmQZ6ZrPBD3E1O7zf0WneYK1zBOiM2KSHiWx9lIcmYTpNap7
         VnuZBzgYBZ3it6ikTptigMLPEilU8/9wer2z+y6ZOQBp2S4hEUA7App9rv1Vk1vhRhcl
         aOrbzeYSoUDkaBqPgIKnJfd4pSRF44cN6DG7oxegu82S1wBHrhHwzfciulkHpkwkVtaW
         YpVbT/LTn7rujFQaZnDoacr+ggbX1coXmHfuYHQtoNu0veRNBPW9s+JZNn62BzMOzPig
         v6dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=msNczVLXjgZZSNqJoDtvCOSNDEGSyBHHraGpFvbxsO8=;
        b=r3YJ5e4q/a63Bc3TrDAhwMyLIAkBuMuz0m1F8uiX01T6Y+Y+cpltu4zwmHFk7MKNyC
         t5UXIGIiJvAIfd5x9plvDIOBn8ver+PumO/eNUb5ZsMYahCoNXmiBRZZbzstKOvqgH9N
         Xt1Cbv/Jwgr8825QG22DTwiCw4JPREmD5HaRkvAcuBSpndHMYXqmq5PFwuNSeG36Mvh1
         xQreN8V/9P7T1KoM58e7Wg95TQPRaMH/cnI4Q+gP7XwUaphBqfLOjzqzrzU2fKs083/z
         uSsicZ0Nbad1pYvPqc2qbAl5awMqouksBTIG/As1r1u/6iVzfZSAebNj8cvWKCSwRk/8
         hYpg==
X-Gm-Message-State: AOAM532DbsnU0UHMcoMyCOgqLSGd5lz5um2FDLvsKDJLtNuwjx38eS3t
        AoNfrAilSBD3MCCVN39e9nfKLQ==
X-Google-Smtp-Source: ABdhPJxLR4WaVP7ydKbvxGwxKdMW7OWiG7vw/sEckwoQPDiWDTzXBBWQyNj2Y7YPMQW+nDbM5uWJzg==
X-Received: by 2002:a17:902:9d8b:b029:df:fab3:48ef with SMTP id c11-20020a1709029d8bb02900dffab348efmr3179862plq.79.1611623199765;
        Mon, 25 Jan 2021 17:06:39 -0800 (PST)
Received: from [192.168.4.41] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id 6sm7712362pfo.139.2021.01.25.17.06.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Jan 2021 17:06:38 -0800 (PST)
Subject: Re: [PATCHSET RFC] support RESOLVE_CACHED for statx
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        io-uring <io-uring@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
References: <20210125213614.24001-1-axboe@kernel.dk>
 <CAHk-=whh=+nkoZFqb1zztY9kUo-Ua75+zY16HeU_3j1RV4JR0Q@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <4bd713e8-58e7-e961-243e-dbbdc2a1f60c@kernel.dk>
Date:   Mon, 25 Jan 2021 18:06:37 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAHk-=whh=+nkoZFqb1zztY9kUo-Ua75+zY16HeU_3j1RV4JR0Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/25/21 4:39 PM, Linus Torvalds wrote:
> On Mon, Jan 25, 2021 at 1:36 PM Jens Axboe <axboe@kernel.dk> wrote:
>>
>>     Patch 2 is the
>> mostly ugly part, but not sure how we can do this any better - we need
>> to ensure that any sort of revalidation or sync in ->getattr() honors
>> it too.
> 
> Yeah, that's not pretty, but I agree - it looks like this just
> requires the filesystem to check whether it needs to revalidate or
> not.
> 
> But I think that patch could do better than what your patch does. Some
> of them are "filesystems could decide to be more finegrained") -  your
> cifs patch comes to mind - but some of your "return -EAGAIN if cached"
> seem to be just plain pointless.

Which ones in particular? Outside of the afs one you looked a below,
the rest should all be of the "need to do IO of some sort" and hence
-EAGAIN is reasonable.

cifs could be cleaner, but that'd require more checking in there. I
just tried to keep it simple, and leave the harder work for the
file system developers if they care. If not, it'll still work just
like it does today, we're no worse off there than before (at least
from an io_uring POV).

But I can go ahead and makes eg cifs more accurate in that regard,
if that's what you're objecting to.

> In afs, for example, you return -EAGAIN instead of just doing the
> read-seqlock thing. That's a really cheap CPU-only operation. We're
> talking "cheaper than a spinlock" sequence.

Yep agree on that one, that looks silly and should just go away. I've
killed it.

-- 
Jens Axboe

