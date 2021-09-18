Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 302784108EC
	for <lists+io-uring@lfdr.de>; Sun, 19 Sep 2021 01:37:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240475AbhIRXjP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 18 Sep 2021 19:39:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240331AbhIRXjO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 18 Sep 2021 19:39:14 -0400
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2860C061574
        for <io-uring@vger.kernel.org>; Sat, 18 Sep 2021 16:37:49 -0700 (PDT)
Received: by mail-il1-x12b.google.com with SMTP id a20so14387612ilq.7
        for <io-uring@vger.kernel.org>; Sat, 18 Sep 2021 16:37:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=tIQX0777OQ9UGJXW33BtrAtn/vWhfapuaGFMPJUmsIA=;
        b=Xyog45M1eo46qnJRs1Huj2EvXl5h9yMvz+VvSzjeQp6kqUPuLN+L+3RJ4h7zIDrT5D
         pt8AQNfuQnWi7NaJaULYv3l0a0LXZbGrSmllf+ObuMofH0sydjDtYQ1nf1yvM7Nr3Zgc
         L44/z966PK3dSKmFRTSZ1xmATlakIA1xJLYxiKMjLX2P688HPFK9UiKumnWPuj/sarIk
         Nxyrtjsvmc9KFRcwu1CIr80Mx06yI9j0vKC2KqOSDFTOQqZLRgOgVWvQSNb1hRjmGhQY
         xgN7oBVa461nAtUK9WF1Rg9oZLFiDbyfAwvEQWEIP5+uBEraJytOeg1lfPP6FUfLw3hh
         qGNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tIQX0777OQ9UGJXW33BtrAtn/vWhfapuaGFMPJUmsIA=;
        b=K807JnNnMGoJm1l7jKELCa1ygtDc/wyZcfkbJ8Tgu2GLGE1DbrQTz/HNtL/xQ27Kc3
         IzWMcy6YTHz23IX6FcFXeBFP6coyBkxzGo48XVqvnLSYvyMglA6hojeH6wkmTyTIBKTB
         xwd0WLIq6iBFztDs8ix0MGM+vs/J6Tlr6/Q0buPM8N0pb3Ga01zBkWZCLV4ci8jmHGWL
         Wxua0i6EcG+nUBBt6+o1puwn5Knv4/Wd8j6fO3731zmPcXMJgM9SpIHn9/vbGxgvWkgc
         CVxxFznWPYXeV6NXwDn2Vub4UIL/l2Y1LSjRDfVppSCTrX5zjlA3gYX9XaKwK/i+44JN
         cwKQ==
X-Gm-Message-State: AOAM530yiYchRxDCYYjV4KYQr7nmCl3CG/2JuSZ4ykNkg8zl0Oy72JNR
        eht8KtA7e1fe3Jq06IjAwuN8XwFzkwT2/Q==
X-Google-Smtp-Source: ABdhPJwsFO19pQFEuOYv63U6BmIF+9ZZ/8euRBcupEmvGTLc5Pydcy7AHeuIrFfJ0G/aW1oZHfpLiw==
X-Received: by 2002:a92:440c:: with SMTP id r12mr12690560ila.174.1632008267722;
        Sat, 18 Sep 2021 16:37:47 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id c13sm5840011iod.25.2021.09.18.16.37.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 18 Sep 2021 16:37:47 -0700 (PDT)
Subject: Re: [BUG? liburing] io_uring_register_files_update with liburing 2.0
 on 5.13.17
To:     Victor Stewart <v@nametag.social>
Cc:     io-uring <io-uring@vger.kernel.org>
References: <CAM1kxwjCjo9u5AwAn0UANCWkahkUYz8PwHkWgF0U83ue=KbfTA@mail.gmail.com>
 <a1010b67-d636-9672-7a21-44f7c4376916@kernel.dk>
 <CAM1kxwj2Chak===QoOzNBAUMhymyXM3T6o_zwPdwqN7MzQ25zw@mail.gmail.com>
 <c0de93f7-abf4-d2f9-f64d-376a9c987ac0@kernel.dk>
 <7bfd2fdd-15ba-98e3-7acc-cecf2a42e157@kernel.dk>
 <CAM1kxwi6EMGZeNW_imNZq4jMkJ3NeuDdkeGBkRMKpwJPQ8Rxmw@mail.gmail.com>
 <36866fef-a38f-9d7d-0c85-b4c37a8279ce@kernel.dk>
 <CAM1kxwgA7BtaPYhkeHFnqrgLHs31LrOCiXcMEiO9Y8GU22KNfQ@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <d0cbd186-b721-c7ca-f304-430e272a78f4@kernel.dk>
Date:   Sat, 18 Sep 2021 17:37:46 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAM1kxwgA7BtaPYhkeHFnqrgLHs31LrOCiXcMEiO9Y8GU22KNfQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/18/21 5:19 PM, Victor Stewart wrote:
> On Sat, Sep 18, 2021 at 11:21 PM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> On 9/18/21 3:55 PM, Victor Stewart wrote:
>>> On Sat, Sep 18, 2021 at 9:38 PM Jens Axboe <axboe@kernel.dk> wrote:
>>>>
>>>> On Sat, Sep 18, 2021 at 2:26 PM Jens Axboe <axboe@kernel.dk> wrote:
>>>>>
>>>>> On 9/18/21 2:13 PM, Victor Stewart wrote:
>>>>>> On Sat, Sep 18, 2021 at 3:41 PM Jens Axboe <axboe@kernel.dk> wrote:
>>>>>>>
>>>>>>> On 9/18/21 7:41 AM, Victor Stewart wrote:
>>>>>>>> just auto updated from 5.13.16 to 5.13.17, and suddenly my fixed
>>>>>>>> file registrations fail with EOPNOTSUPP using liburing 2.0.
>>>>>>>>
>>>>>>>> static inline struct io_uring ring;
>>>>>>>> static inline int *socketfds;
>>>>>>>>
>>>>>>>> // ...
>>>>>>>>
>>>>>>>> void enableFD(int fd)
>>>>>>>> {
>>>>>>>>    int result = io_uring_register_files_update(&ring, fd,
>>>>>>>>                       &(socketfds[fd] = fd), 1);
>>>>>>>>    printf("enableFD, result = %d\n", result);
>>>>>>>> }
>>>>>>>>
>>>>>>>> maybe this is due to the below and related work that
>>>>>>>> occurred at the end of 5.13 and liburing got out of sync?
>>>>>>>>
>>>>>>>> https://github.com/torvalds/linux/commit/992da01aa932b432ef8dc3885fa76415b5dbe43f#diff-79ffab63f24ef28eec3badbc8769e2a23e0475ab1fbe390207269ece944a0824
>>>>>>>>
>>>>>>>> and can't use liburing 2.1 because of the api changes since 5.13.
>>>>>>>
>>>>>>> That's very strange, the -EOPNOTSUPP should only be possible if you
>>>>>>> are not passing in the ring fd for the register syscall. You should
>>>>>>> be able to mix and match liburing versions just fine, the only exception
>>>>>>> is sometimes between releases (of both liburing and the kernel) where we
>>>>>>> have the liberty to change the API of something that was added before
>>>>>>> release.
>>>>>>>
>>>>>>> Can you do an strace of it and attach?
>>>>>>
>>>>>> oh ya the EOPNOTSUPP was my bug introduced trying to debug.
>>>>>>
>>>>>> here's the real bug...
>>>>>>
>>>>>> io_uring_register(13, IORING_REGISTER_FILES, [-1, -1, -1, 3, 4, 5, 6, 7,
>>>>>> 8, 9, 10, 11, 12, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
>>>>>> -1, -1, -1, -1, -1,
>>>>>> -1, ...], 32768) = -1 EMFILE (Too many open files)
>>>>>>
>>>>>> 32,768 is 1U << 15 aka IORING_MAX_FIXED_FILES, but i tried
>>>>>> 16,000 just to try and same issue.
>>>>>>
>>>>>> maybe you're not allowed to have pre-filled (aka non negative 1)
>>>>>> entries upon the initial io_uring_register_files call anymore?
>>>>>>
>>>>>> this was working until the 5.13.16 -> 5.13.17 transition.
>>>>>
>>>>> Ah yes that makes more sense. You need to up RLIMIT_NOFILE, the
>>>>> registered files are under that protection now too. This is also why it
>>>>> was brought back to stable. A bit annoying, but it was needed for the
>>>>> direct file support to have some sanity there.
>>>>>
>>>>> So use rlimit(RLIMIT_NOFILE,...) from the app or ulimit -n to bump the
>>>>> limit.
>>>>
>>>
>>> perfect got it working with..
>>>
>>> struct rlimit maxFilesLimit = {N_IOURING_MAX_FIXED_FILES,
>>> N_IOURING_MAX_FIXED_FILES};
>>> setrlimit(RLIMIT_NOFILE, &maxFilesLimit);
>>
>> Good!
>>
>>>> BTW, this could be incorporated into io_uring_register_files and
>>>> io_uring_register_files_tags(), might not be a bad idea in general. Just
>>>> have it check rlim.rlim_cur for RLIMIT_NOFILE, and if it's smaller than
>>>> 'nr_files', then bump it. That'd hide it nicely, instead of throwing a
>>>> failure.
>>>
>>> the implicit bump sounds like a good idea (at least in theory?).
>>
>> Can you try current liburing -git? Remove your own RLIMIT_NOFILE and
>> just verify that it works. I pushed a change for it.
> 
> i don't have a dev box up right now, but i applied the below changes to 2.0
> sans the tags bit...
> 
> diff --git a/src/register.c b/src/register.c
> index 994aaff..495216a 100644
> --- a/src/register.c
> +++ b/src/register.c
> @@ -7,6 +7,7 @@
>  #include <unistd.h>
>  #include <errno.h>
>  #include <string.h>
> +#include <sys/resource.h>
> 
>  #include "liburing/compat.h"
>  #include "liburing/io_uring.h"
> @@ -14,6 +15,22 @@
> 
>  #include "syscall.h"
> 
> +static int bump_rlimit_nofile(unsigned nr)
> +{
> +       struct rlimit rlim;
> +
> +       if (getrlimit(RLIMIT_NOFILE, &rlim) < 0)
> +               return -errno;
> +       if (rlim.rlim_cur < nr) {
> +               if (nr > rlim.rlim_max)
> +                       return -EMFILE;
> +               rlim.rlim_cur = nr;
> +               setrlimit(RLIMIT_NOFILE, &rlim);
> +       }
> +
> +       return 0;
> +}
> +
>  int io_uring_register_buffers(struct io_uring *ring, const struct
> iovec *iovecs,
>                               unsigned nr_iovecs)
>  {
> @@ -55,6 +72,10 @@ int io_uring_register_files_update(struct io_uring
> *ring, unsigned off,
>         };
>         int ret;
> 
> +       ret = bump_rlimit_nofile(nr_files);
> +       if (ret)
> +               return ret;
> +
> 
> and it failed with the same as before...
> 
> io_uring_register(13, IORING_REGISTER_FILES, [-1, -1, -1, 3, 4, 5, 6, 7, 8,
> 9, 10, 11, 12, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
> -1, -1, -1, -1,
> -1, ...], 32768) = -1 EMFILE (Too many open files)
> 
> if you want i can debug it for you tomorrow? (in london)

Nah that's fine, I think it's just because you have other files opened
too. We bump the cur limit _to_ 'nr', but that leaves no room for anyone
else. Would be my guess. It works fine for the test case I ran here, but
your case may be different. Does it work if you just make it:

rlim.rlim_cur += nr;

instead?

>>> something that would take 1 minute to skim and see if relevant.
>>>
>>> because at this point to stay fully updated requires reading all of the
>>> mailing list or checking pulls on your branch + running to binaries
>>> to see if anything breaks.
>>
>> Question is where to post it? Because I would post it here anyway...
> 
> i think a txt file in liburing might be the perfect place given the audience
> for it is solely application developers? could start with 5.15 and maintain
> it forward.

Yes, maybe just have a ChangeLog kind of file in there and add a section
for each new release.

-- 
Jens Axboe

