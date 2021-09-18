Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F5434108D2
	for <lists+io-uring@lfdr.de>; Sun, 19 Sep 2021 00:21:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236828AbhIRWXP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 18 Sep 2021 18:23:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235704AbhIRWXO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 18 Sep 2021 18:23:14 -0400
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF9C3C061574
        for <io-uring@vger.kernel.org>; Sat, 18 Sep 2021 15:21:50 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id j18so16808051ioj.8
        for <io-uring@vger.kernel.org>; Sat, 18 Sep 2021 15:21:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=pEBJUr1bamRjoLKSW5s6UTvZak2d74zv+RvnOUtkX6c=;
        b=BGbULKOxhZmYsX5f6FGsC58E/SsgEEQXtAo6G4wEWKCoaArEUgM0o9vO+pC+l37KYc
         nrnxunLCVuFJ2vvZ0Ju0fzElCS8UbycfuGwQ3jioMGpBZXLRp05EpEq9jDGHUizMV0QK
         4DOkZBiWCJlCi/Pntrn8+pOwqzRokQEhUmoxDrNBR4hy0gJ/36LX9abK/86/QsDpxe4H
         CKLBLQVkUjH71fk9BgnEWtg8Vqi3bQEEsHTsA93qjz5bz3dyRSv/FVIaQqWu6O1wEptT
         Jy3yPzT5PnZPUc5nLAUdtBk4Hc+Dk1clTA7N/3NBvlJXaApTakuVZRA7QLU4i09BtLJE
         OVtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pEBJUr1bamRjoLKSW5s6UTvZak2d74zv+RvnOUtkX6c=;
        b=oRhR0spr2bZsgzMUKSEsxlp5eCqJ5iu2/Cht3FcD8bSMzHbgJLR+DiXC87mXJmrz8y
         AnU/2vM4AgcwqUsXQ7SvQwTx1GyLAu/8AbJBDQBgPNjCSr2pJAc+eGeKd8Y08SCj7Mbx
         xH9kvc8X+/2nbiIvjGCJ5DH6/gqMHFbMJAPhmn/Mj+8AgJAJtNsks2XBui3E7PEbXJjv
         Q4K6gFCvlyxRkVYUjxaYX6r7uXVmdOZApOEfPU0USpPlcRKIhNxcoyb75FDSMP/hMgxK
         yVTiT9ryrSVTcCaXYb/hQVYwAiGE8izGBtHyICtIlhODnP07pxN57KyUQA6O0AhY1G4t
         41XA==
X-Gm-Message-State: AOAM532VUoEoRRA1UIl69VsiBLaA16ISvrN3ab0TvKhED91zV4KsP/q8
        RFFemrzC8WgHvarQ/sBDQeXsOj4iYp2oVg==
X-Google-Smtp-Source: ABdhPJzISsBX0WbJjZiP/3u0JSicLUSOd/NlmMhjndrxyt4xCv3vpvyLWoXWIWk6z/BUrhZ3bxHSSA==
X-Received: by 2002:a6b:c3ce:: with SMTP id t197mr13410604iof.159.1632003709784;
        Sat, 18 Sep 2021 15:21:49 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id d17sm5985319ilf.49.2021.09.18.15.21.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 18 Sep 2021 15:21:49 -0700 (PDT)
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
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <36866fef-a38f-9d7d-0c85-b4c37a8279ce@kernel.dk>
Date:   Sat, 18 Sep 2021 16:21:48 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAM1kxwi6EMGZeNW_imNZq4jMkJ3NeuDdkeGBkRMKpwJPQ8Rxmw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/18/21 3:55 PM, Victor Stewart wrote:
> On Sat, Sep 18, 2021 at 9:38 PM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> On Sat, Sep 18, 2021 at 2:26 PM Jens Axboe <axboe@kernel.dk> wrote:
>>>
>>> On 9/18/21 2:13 PM, Victor Stewart wrote:
>>>> On Sat, Sep 18, 2021 at 3:41 PM Jens Axboe <axboe@kernel.dk> wrote:
>>>>>
>>>>> On 9/18/21 7:41 AM, Victor Stewart wrote:
>>>>>> just auto updated from 5.13.16 to 5.13.17, and suddenly my fixed
>>>>>> file registrations fail with EOPNOTSUPP using liburing 2.0.
>>>>>>
>>>>>> static inline struct io_uring ring;
>>>>>> static inline int *socketfds;
>>>>>>
>>>>>> // ...
>>>>>>
>>>>>> void enableFD(int fd)
>>>>>> {
>>>>>>    int result = io_uring_register_files_update(&ring, fd,
>>>>>>                       &(socketfds[fd] = fd), 1);
>>>>>>    printf("enableFD, result = %d\n", result);
>>>>>> }
>>>>>>
>>>>>> maybe this is due to the below and related work that
>>>>>> occurred at the end of 5.13 and liburing got out of sync?
>>>>>>
>>>>>> https://github.com/torvalds/linux/commit/992da01aa932b432ef8dc3885fa76415b5dbe43f#diff-79ffab63f24ef28eec3badbc8769e2a23e0475ab1fbe390207269ece944a0824
>>>>>>
>>>>>> and can't use liburing 2.1 because of the api changes since 5.13.
>>>>>
>>>>> That's very strange, the -EOPNOTSUPP should only be possible if you
>>>>> are not passing in the ring fd for the register syscall. You should
>>>>> be able to mix and match liburing versions just fine, the only exception
>>>>> is sometimes between releases (of both liburing and the kernel) where we
>>>>> have the liberty to change the API of something that was added before
>>>>> release.
>>>>>
>>>>> Can you do an strace of it and attach?
>>>>
>>>> oh ya the EOPNOTSUPP was my bug introduced trying to debug.
>>>>
>>>> here's the real bug...
>>>>
>>>> io_uring_register(13, IORING_REGISTER_FILES, [-1, -1, -1, 3, 4, 5, 6, 7,
>>>> 8, 9, 10, 11, 12, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
>>>> -1, -1, -1, -1, -1,
>>>> -1, ...], 32768) = -1 EMFILE (Too many open files)
>>>>
>>>> 32,768 is 1U << 15 aka IORING_MAX_FIXED_FILES, but i tried
>>>> 16,000 just to try and same issue.
>>>>
>>>> maybe you're not allowed to have pre-filled (aka non negative 1)
>>>> entries upon the initial io_uring_register_files call anymore?
>>>>
>>>> this was working until the 5.13.16 -> 5.13.17 transition.
>>>
>>> Ah yes that makes more sense. You need to up RLIMIT_NOFILE, the
>>> registered files are under that protection now too. This is also why it
>>> was brought back to stable. A bit annoying, but it was needed for the
>>> direct file support to have some sanity there.
>>>
>>> So use rlimit(RLIMIT_NOFILE,...) from the app or ulimit -n to bump the
>>> limit.
>>
> 
> perfect got it working with..
> 
> struct rlimit maxFilesLimit = {N_IOURING_MAX_FIXED_FILES,
> N_IOURING_MAX_FIXED_FILES};
> setrlimit(RLIMIT_NOFILE, &maxFilesLimit);

Good!

>> BTW, this could be incorporated into io_uring_register_files and
>> io_uring_register_files_tags(), might not be a bad idea in general. Just
>> have it check rlim.rlim_cur for RLIMIT_NOFILE, and if it's smaller than
>> 'nr_files', then bump it. That'd hide it nicely, instead of throwing a
>> failure.
> 
> the implicit bump sounds like a good idea (at least in theory?).

Can you try current liburing -git? Remove your own RLIMIT_NOFILE and
just verify that it works. I pushed a change for it.

> another thing i think might be a good idea is an io_uring
> change/migration log that we update with every kernel release covering
> new features but also new restrictions/requirements/tweaks etc.

Yes, that is a good idea. The man pages do tend to reference what
version included what, but a highlight per release would be a great idea
to have without having to dig for it.

> something that would take 1 minute to skim and see if relevant.
> 
> because at this point to stay fully updated requires reading all of the
> mailing list or checking pulls on your branch + running to binaries
> to see if anything breaks.

Question is where to post it? Because I would post it here anyway...

-- 
Jens Axboe

