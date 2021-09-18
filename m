Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E33B410895
	for <lists+io-uring@lfdr.de>; Sat, 18 Sep 2021 22:38:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236846AbhIRUjn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 18 Sep 2021 16:39:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229568AbhIRUjn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 18 Sep 2021 16:39:43 -0400
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B756C061574
        for <io-uring@vger.kernel.org>; Sat, 18 Sep 2021 13:38:19 -0700 (PDT)
Received: by mail-io1-xd2d.google.com with SMTP id d18so4394301iof.13
        for <io-uring@vger.kernel.org>; Sat, 18 Sep 2021 13:38:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:subject:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=1DKh2brBFwfSJjyRwvQO0wT5634dp7/g+oMXcI/g7+A=;
        b=viYee1f25h0CBizD5i1ebrQ8MzIhl0Jc7cdn1caWuAPFakZ6NvAq85PVb6Kje0eGEF
         1PeH5hH5o/Sg18anfobX5QXNFtsz/WgFIYyy4KgK8JKoVRnZXZwPspngpTpImUpwpuvE
         sZHxSJmIdxsh5KzYxQAMBGXdFpwJYiMK7CqhLWEjL0xo+VmzkmesdJcoaPMj/swv6ard
         2dAVH25wOmEjZdPEG+XQuQ22ehEzhxNvMZOUVgWe1Kb3C6Dl/X0hqRLNsArDxoD9kCMJ
         MZuPQTZ+6GAaq81b172CY+JXycZhCgOz4U/1HaQx1AW649RY22RXqjS97Yl+bxR4JeYq
         6rRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:subject:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1DKh2brBFwfSJjyRwvQO0wT5634dp7/g+oMXcI/g7+A=;
        b=6ylCd5iOfhYtZXetEo/KTx31SzT+97pbmTN+X57F26Tjpl4fqtCNoZbJGyyvgJ7tu2
         aD7hRcULC6eFfuctXwUsFzdNxbIc3WfgHbOd87Ih0ROKJxl6DsF7C9byPTbSpKWK5FGg
         8TsJYs0BCCIMmqKvA0i2eV9rrYTSyWg62ylxlHqM+PO9fjBiPqZh33NtUJ86If9rQ+OQ
         tTioMG3M4o8tq9wqy31xoZpYu5Q4P2a9W7xZGM+kXuMXppll+9cXKbfh0vQHDMpOU97v
         83hQRQYvuzzmagtt2grZYHE0kbXQFsJAaD66OVwfB2UdqTYpWtwW236EvXBky99bw/p1
         7X9A==
X-Gm-Message-State: AOAM531AaKi2uao4nW7sKFzyqbpFvCP/K2XnwKFnUqd/+FkC+Q6uAn0p
        jrflXemsArfqxpkUUm5Ie5TwA3A1Zur0Lg==
X-Google-Smtp-Source: ABdhPJxuNKovOS/+gQrL4i+xLjZwcDA0FtCGyNVEjI/gdC2kFtKUliEVIds+n8mC40zT3f34UJYxUg==
X-Received: by 2002:a05:6638:348e:: with SMTP id t14mr14223959jal.66.1631997498220;
        Sat, 18 Sep 2021 13:38:18 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id b16sm5774043ila.1.2021.09.18.13.38.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 18 Sep 2021 13:38:17 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
Subject: Re: [BUG? liburing] io_uring_register_files_update with liburing 2.0
 on 5.13.17
To:     Victor Stewart <v@nametag.social>
Cc:     io-uring <io-uring@vger.kernel.org>
References: <CAM1kxwjCjo9u5AwAn0UANCWkahkUYz8PwHkWgF0U83ue=KbfTA@mail.gmail.com>
 <a1010b67-d636-9672-7a21-44f7c4376916@kernel.dk>
 <CAM1kxwj2Chak===QoOzNBAUMhymyXM3T6o_zwPdwqN7MzQ25zw@mail.gmail.com>
 <c0de93f7-abf4-d2f9-f64d-376a9c987ac0@kernel.dk>
Message-ID: <7bfd2fdd-15ba-98e3-7acc-cecf2a42e157@kernel.dk>
Date:   Sat, 18 Sep 2021 14:38:16 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <c0de93f7-abf4-d2f9-f64d-376a9c987ac0@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sat, Sep 18, 2021 at 2:26 PM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 9/18/21 2:13 PM, Victor Stewart wrote:
> > On Sat, Sep 18, 2021 at 3:41 PM Jens Axboe <axboe@kernel.dk> wrote:
> >>
> >> On 9/18/21 7:41 AM, Victor Stewart wrote:
> >>> just auto updated from 5.13.16 to 5.13.17, and suddenly my fixed
> >>> file registrations fail with EOPNOTSUPP using liburing 2.0.
> >>>
> >>> static inline struct io_uring ring;
> >>> static inline int *socketfds;
> >>>
> >>> // ...
> >>>
> >>> void enableFD(int fd)
> >>> {
> >>>    int result = io_uring_register_files_update(&ring, fd,
> >>>                       &(socketfds[fd] = fd), 1);
> >>>    printf("enableFD, result = %d\n", result);
> >>> }
> >>>
> >>> maybe this is due to the below and related work that
> >>> occurred at the end of 5.13 and liburing got out of sync?
> >>>
> >>> https://github.com/torvalds/linux/commit/992da01aa932b432ef8dc3885fa76415b5dbe43f#diff-79ffab63f24ef28eec3badbc8769e2a23e0475ab1fbe390207269ece944a0824
> >>>
> >>> and can't use liburing 2.1 because of the api changes since 5.13.
> >>
> >> That's very strange, the -EOPNOTSUPP should only be possible if you
> >> are not passing in the ring fd for the register syscall. You should
> >> be able to mix and match liburing versions just fine, the only exception
> >> is sometimes between releases (of both liburing and the kernel) where we
> >> have the liberty to change the API of something that was added before
> >> release.
> >>
> >> Can you do an strace of it and attach?
> >
> > oh ya the EOPNOTSUPP was my bug introduced trying to debug.
> >
> > here's the real bug...
> >
> > io_uring_register(13, IORING_REGISTER_FILES, [-1, -1, -1, 3, 4, 5, 6, 7,
> > 8, 9, 10, 11, 12, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
> > -1, -1, -1, -1, -1,
> > -1, ...], 32768) = -1 EMFILE (Too many open files)
> >
> > 32,768 is 1U << 15 aka IORING_MAX_FIXED_FILES, but i tried
> > 16,000 just to try and same issue.
> >
> > maybe you're not allowed to have pre-filled (aka non negative 1)
> > entries upon the initial io_uring_register_files call anymore?
> >
> > this was working until the 5.13.16 -> 5.13.17 transition.
>
> Ah yes that makes more sense. You need to up RLIMIT_NOFILE, the
> registered files are under that protection now too. This is also why it
> was brought back to stable. A bit annoying, but it was needed for the
> direct file support to have some sanity there.
>
> So use rlimit(RLIMIT_NOFILE,...) from the app or ulimit -n to bump the
> limit.

BTW, this could be incorporated into io_uring_register_files and
io_uring_register_files_tags(), might not be a bad idea in general. Just
have it check rlim.rlim_cur for RLIMIT_NOFILE, and if it's smaller than
'nr_files', then bump it. That'd hide it nicely, instead of throwing a
failure.

-- 
Jens Axboe
