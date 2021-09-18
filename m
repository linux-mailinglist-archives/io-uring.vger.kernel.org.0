Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78A0D410883
	for <lists+io-uring@lfdr.de>; Sat, 18 Sep 2021 22:13:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230051AbhIRUPP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 18 Sep 2021 16:15:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229793AbhIRUPP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 18 Sep 2021 16:15:15 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDACBC061574
        for <io-uring@vger.kernel.org>; Sat, 18 Sep 2021 13:13:50 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id c21so43406993edj.0
        for <io-uring@vger.kernel.org>; Sat, 18 Sep 2021 13:13:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nametag.social; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dqWsMEcihFNZ81kBvY7yFW0OnZrmUf+ybzb5JxlPkog=;
        b=H6dqYMP0g3YefAKT57ES3hxcL+Q1MWukklbOZTDyhIIHOdCMrN2fAn2HFOA272hyUi
         87UU0/eqJs2bMYTuHwLsHeH7REBbTzx+QZJRAVBZTV0SUN4yhsx70GR10cxiop57rxtU
         oaMcA5TRkdF5h6OH/vEKVnMVNGTZUIFLcwjvd/ZORIeoSMjY687/TTPndmyrwWjEUkn4
         yD0Sj5hkT1Qc+jLG5bPtTnEw8gAlRYZ9yDYcqNtO8KLhdjNE3EfnNiF1gCmYQYt5ETlx
         adT+uMqyHaR37RsAPd1Do2QejDz7ISfR/bTMKPcr2aCGpVDvtlxjeqrZfjBMW414mCXC
         Kl/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dqWsMEcihFNZ81kBvY7yFW0OnZrmUf+ybzb5JxlPkog=;
        b=OSuUZGwLfeKPjbu9WLbh8P0i5YF8G/WYp0mrnITrg//hkmK/WPW0jEyBypV4Mkp7kb
         K1CMzUIkF0eL3+/JqHXgbJf0xbBim5wZ6r5J4ZZ/39WZ2vyCCaEXJwVSxwvgw3y7KDOH
         jIbEXQ5Sm95V//w//1j2DxJIqvvqkL9iGOuVoILP2POSh4SFKR99sC9OHvbd0oBT9JyC
         xYJq8SN9ThgjdsikFMOyZkUoMvbPa0MO2w+XIm8ZPM+jL66FVBxq8hOs87tKV8vJMXcw
         XQl0ZheyQEg6xilFewES9ZgKFNUVjNl0zU0tCr1gU+yCX2CXsUCW6YtvDPT32thkoNSs
         OiRg==
X-Gm-Message-State: AOAM532ReGs19heAX0wjYP2b2UbwyDWUviwEimqWEzL9BWhW6wPWlJQl
        MzGJ5dREhYaMclZBFcc+y5slHixaAlHm7bYZ7NR0DwEdX69LipHTngk=
X-Google-Smtp-Source: ABdhPJw5RURxhwPD5FygX4tdCuBTx4CU3elsBG2B7KrrrPFqHLwKbyWYnzNstELxUxXa9KgeeiJuuHzIoqTg8KuLOe0=
X-Received: by 2002:a17:906:9811:: with SMTP id lm17mr10933059ejb.334.1631996029371;
 Sat, 18 Sep 2021 13:13:49 -0700 (PDT)
MIME-Version: 1.0
References: <CAM1kxwjCjo9u5AwAn0UANCWkahkUYz8PwHkWgF0U83ue=KbfTA@mail.gmail.com>
 <a1010b67-d636-9672-7a21-44f7c4376916@kernel.dk>
In-Reply-To: <a1010b67-d636-9672-7a21-44f7c4376916@kernel.dk>
From:   Victor Stewart <v@nametag.social>
Date:   Sat, 18 Sep 2021 21:13:38 +0100
Message-ID: <CAM1kxwj2Chak===QoOzNBAUMhymyXM3T6o_zwPdwqN7MzQ25zw@mail.gmail.com>
Subject: Re: [BUG? liburing] io_uring_register_files_update with liburing 2.0
 on 5.13.17
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sat, Sep 18, 2021 at 3:41 PM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 9/18/21 7:41 AM, Victor Stewart wrote:
> > just auto updated from 5.13.16 to 5.13.17, and suddenly my fixed
> > file registrations fail with EOPNOTSUPP using liburing 2.0.
> >
> > static inline struct io_uring ring;
> > static inline int *socketfds;
> >
> > // ...
> >
> > void enableFD(int fd)
> > {
> >    int result = io_uring_register_files_update(&ring, fd,
> >                       &(socketfds[fd] = fd), 1);
> >    printf("enableFD, result = %d\n", result);
> > }
> >
> > maybe this is due to the below and related work that
> > occurred at the end of 5.13 and liburing got out of sync?
> >
> > https://github.com/torvalds/linux/commit/992da01aa932b432ef8dc3885fa76415b5dbe43f#diff-79ffab63f24ef28eec3badbc8769e2a23e0475ab1fbe390207269ece944a0824
> >
> > and can't use liburing 2.1 because of the api changes since 5.13.
>
> That's very strange, the -EOPNOTSUPP should only be possible if you
> are not passing in the ring fd for the register syscall. You should
> be able to mix and match liburing versions just fine, the only exception
> is sometimes between releases (of both liburing and the kernel) where we
> have the liberty to change the API of something that was added before
> release.
>
> Can you do an strace of it and attach?

oh ya the EOPNOTSUPP was my bug introduced trying to debug.

here's the real bug...

io_uring_register(13, IORING_REGISTER_FILES, [-1, -1, -1, 3, 4, 5, 6, 7,
8, 9, 10, 11, 12, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
-1, -1, -1, -1, -1,
-1, ...], 32768) = -1 EMFILE (Too many open files)

32,768 is 1U << 15 aka IORING_MAX_FIXED_FILES, but i tried
16,000 just to try and same issue.

maybe you're not allowed to have pre-filled (aka non negative 1)
entries upon the initial io_uring_register_files call anymore?

this was working until the 5.13.16 -> 5.13.17 transition.
>
> --
> Jens Axboe
>
