Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B43B41088B
	for <lists+io-uring@lfdr.de>; Sat, 18 Sep 2021 22:26:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234502AbhIRU16 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 18 Sep 2021 16:27:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234491AbhIRU15 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 18 Sep 2021 16:27:57 -0400
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 900D2C061574
        for <io-uring@vger.kernel.org>; Sat, 18 Sep 2021 13:26:33 -0700 (PDT)
Received: by mail-il1-x136.google.com with SMTP id q14so14147368ils.5
        for <io-uring@vger.kernel.org>; Sat, 18 Sep 2021 13:26:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=KP5gOwoh0J6TdETGgYDxvykIoCxRmI6FYNIi9HDHosg=;
        b=UGN0gK3/R1IU9QZBbfz3rUlGDgzn5prCMnXKJPI/CbswBgJudk4wg7GpuZ3OGSz/oI
         F3979cOd9BOi/6/ExVsZYx2r7dvtfF1MJCZZ2OPVLdX4MbLfja1+0vwR08gtMgPap62/
         wRZ2IqCUDS+B7f4SvNGyabYptvBn0b9nQGvC1i7np13pcDS3xbU4G17M6sYzpuq0PGV3
         UCEPMMVQ8OHvV95fpqiMv86gLoKxX684jzKKBiJAMU+3pGL9fhRKbWIa5g3XVZpyrQ+Q
         XR+bOkLfH2Sija4j+wm5e+NObB1EWoNEXgQqMIxMEzMJfki8yotflIARK3LljfUkgDyI
         PYEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KP5gOwoh0J6TdETGgYDxvykIoCxRmI6FYNIi9HDHosg=;
        b=TRs2IhjaaAED5jVReTv++OL58kzVGy46zAbX+VC0N2ZL6QfpVcApfz36Hp3O/zHqxS
         GhTxJMIBSmKQc5IJpb9t+44yS3oU5TSy5REx2LI4Y8OwRe/3VKzyPVdFHz3A0cmwGjb5
         ArBPkq5lC2khPFehjoqD868AKJPHs4kFK9vldFl1f4KCYezhyxPK8ujvEUL9kwIBMuQ4
         GNKLJIcVakCVoGvVd3A7o7boM08j4dgF5kO86QqOV6Fvib1UJ84H4njJ6sHxUdjMZ7Ag
         w2eUiL6z9/tmfNwVAWpU36QaQi3KYh3J5pqDU56I1aWR/Yd3Cm2wrCvyAIInd79rqaoA
         gRYA==
X-Gm-Message-State: AOAM530nEAzOP7P4BgMq2CLQWm57W7GXLWmYf11JCkGO6kwIcD3Fh18z
        aMsQuo5oVP1fVa4+fcGg/+xbJ9cHZU+XcQ==
X-Google-Smtp-Source: ABdhPJywEFUY0yUclXPBEQDP+LemPeoENnjgxiFmNRJlVwjLgp9LeXqRF2Z1TkTXSS3OzHWYFNqeVQ==
X-Received: by 2002:a92:1306:: with SMTP id 6mr11957636ilt.183.1631996786744;
        Sat, 18 Sep 2021 13:26:26 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id a11sm6298355ilm.36.2021.09.18.13.26.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 18 Sep 2021 13:26:26 -0700 (PDT)
Subject: Re: [BUG? liburing] io_uring_register_files_update with liburing 2.0
 on 5.13.17
To:     Victor Stewart <v@nametag.social>
Cc:     io-uring <io-uring@vger.kernel.org>
References: <CAM1kxwjCjo9u5AwAn0UANCWkahkUYz8PwHkWgF0U83ue=KbfTA@mail.gmail.com>
 <a1010b67-d636-9672-7a21-44f7c4376916@kernel.dk>
 <CAM1kxwj2Chak===QoOzNBAUMhymyXM3T6o_zwPdwqN7MzQ25zw@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <c0de93f7-abf4-d2f9-f64d-376a9c987ac0@kernel.dk>
Date:   Sat, 18 Sep 2021 14:26:24 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAM1kxwj2Chak===QoOzNBAUMhymyXM3T6o_zwPdwqN7MzQ25zw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/18/21 2:13 PM, Victor Stewart wrote:
> On Sat, Sep 18, 2021 at 3:41 PM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> On 9/18/21 7:41 AM, Victor Stewart wrote:
>>> just auto updated from 5.13.16 to 5.13.17, and suddenly my fixed
>>> file registrations fail with EOPNOTSUPP using liburing 2.0.
>>>
>>> static inline struct io_uring ring;
>>> static inline int *socketfds;
>>>
>>> // ...
>>>
>>> void enableFD(int fd)
>>> {
>>>    int result = io_uring_register_files_update(&ring, fd,
>>>                       &(socketfds[fd] = fd), 1);
>>>    printf("enableFD, result = %d\n", result);
>>> }
>>>
>>> maybe this is due to the below and related work that
>>> occurred at the end of 5.13 and liburing got out of sync?
>>>
>>> https://github.com/torvalds/linux/commit/992da01aa932b432ef8dc3885fa76415b5dbe43f#diff-79ffab63f24ef28eec3badbc8769e2a23e0475ab1fbe390207269ece944a0824
>>>
>>> and can't use liburing 2.1 because of the api changes since 5.13.
>>
>> That's very strange, the -EOPNOTSUPP should only be possible if you
>> are not passing in the ring fd for the register syscall. You should
>> be able to mix and match liburing versions just fine, the only exception
>> is sometimes between releases (of both liburing and the kernel) where we
>> have the liberty to change the API of something that was added before
>> release.
>>
>> Can you do an strace of it and attach?
> 
> oh ya the EOPNOTSUPP was my bug introduced trying to debug.
> 
> here's the real bug...
> 
> io_uring_register(13, IORING_REGISTER_FILES, [-1, -1, -1, 3, 4, 5, 6, 7,
> 8, 9, 10, 11, 12, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
> -1, -1, -1, -1, -1,
> -1, ...], 32768) = -1 EMFILE (Too many open files)
> 
> 32,768 is 1U << 15 aka IORING_MAX_FIXED_FILES, but i tried
> 16,000 just to try and same issue.
> 
> maybe you're not allowed to have pre-filled (aka non negative 1)
> entries upon the initial io_uring_register_files call anymore?
> 
> this was working until the 5.13.16 -> 5.13.17 transition.

Ah yes that makes more sense. You need to up RLIMIT_NOFILE, the
registered files are under that protection now too. This is also why it
was brought back to stable. A bit annoying, but it was needed for the
direct file support to have some sanity there.

So use rlimit(RLIMIT_NOFILE,...) from the app or ulimit -n to bump the
limit.

-- 
Jens Axboe

