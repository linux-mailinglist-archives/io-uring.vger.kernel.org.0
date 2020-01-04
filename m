Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 112D81303A3
	for <lists+io-uring@lfdr.de>; Sat,  4 Jan 2020 17:42:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726016AbgADQmD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 4 Jan 2020 11:42:03 -0500
Received: from mail-lf1-f50.google.com ([209.85.167.50]:41917 "EHLO
        mail-lf1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726004AbgADQmD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 4 Jan 2020 11:42:03 -0500
Received: by mail-lf1-f50.google.com with SMTP id m30so33783166lfp.8
        for <io-uring@vger.kernel.org>; Sat, 04 Jan 2020 08:42:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=q0ceMoCPztD9uTw7IE7HZ0U64QBBiKyEpyIeEKtrKlk=;
        b=FNV05je6bqXENfvcwCw5YpitnPtNivG5ELdiDBrPCQTWP2IioLgPt0JCO4It4bPWTL
         td2Wvfr4rlaz5tlY/PAMEoxOsGPzEgWHwZME4LOBuJ1xU06x/iRTrDUx2RZlHEjHbTFo
         OW0J5KlluvOQC0Prru349fjk1YyYamnSielhWSxhhttiYI+4MTjQ2cwN7rDK5zT9i1uP
         ESmNMIL34S0B5o6hVTVmF5YwP4pKOQ3nooDbJMyoEkVsl55E9aEAVfA5otquh7w/63FP
         J2Kykr/ol2f90QGUYsfB+VREiL8hQX7BjOAGBWuwWnORWuW3I/U1E6EHCmPRr6n/GUDZ
         Mpkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=q0ceMoCPztD9uTw7IE7HZ0U64QBBiKyEpyIeEKtrKlk=;
        b=h/e8dbe8Xg9yoX0+kkmtDdfNGHDSUuCcLXX7S8xIj167Ja8h+qzSF79DLPXv/vR/SY
         3oMglR+kimcIVOkf4YlShE4fEKRR+R4D078A/Bi4S/Pb7eXqMiKtQedHwfr+VUa8vJZC
         Lm+ETP/LrgBNS08vpv7nrzlFBxQBjMrsb+0fB/7ZojxlnE62nSebdCO7HUXSl40nA7Fy
         zO+JtjTh6dFcXw4+SYbmsbd81il92bW3yEbenpYO6NdvlbzGJ6TMUGOI0k/f8EviaN9y
         cQWrGlMtqrOq6yYB8ocnyQO9hUqFUppFlMw0r4MxUGGxG9yuqMNM7DJ279sw/yXNt+AI
         vdiQ==
X-Gm-Message-State: APjAAAXGpuY4KXP682HYMsTA/i/1as/BpxEV/V2z2+S1oVdKOEgGKsy8
        QzSjT/ZKkr2GeBFDXrzQO6CAWUFd+YR29WRZ0aEUhnC8
X-Google-Smtp-Source: APXvYqy37FNl5UPNwI6lSWGYqRX2FVHn8G7o1QlKfOqiWzrTvhT7t9N3jl5HnmtqRrHu+SeCen5Mh+hHhGABb/MTL3c=
X-Received: by 2002:a19:f701:: with SMTP id z1mr52056588lfe.13.1578156121008;
 Sat, 04 Jan 2020 08:42:01 -0800 (PST)
MIME-Version: 1.0
References: <20200104162211.9008-1-wdauchy@gmail.com> <fad9c723-88ed-355f-6938-71db6db948b4@kernel.dk>
In-Reply-To: <fad9c723-88ed-355f-6938-71db6db948b4@kernel.dk>
From:   William Dauchy <wdauchy@gmail.com>
Date:   Sat, 4 Jan 2020 17:41:50 +0100
Message-ID: <CAJ75kXZdwF4x0Od9BE5OD0vxbkuKR2UDHSfjaQ-yhjUkpx=r2A@mail.gmail.com>
Subject: Re: SQPOLL behaviour with openat
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello Jens,

Thank you for the quick answer.

On Sat, Jan 4, 2020 at 5:28 PM Jens Axboe <axboe@kernel.dk> wrote:
> sqpoll requires the use of fixed files for any sqe, at least for now.
> That's why it returns -EBADF if the request doesn't have fixed files
> specified.

 I indeed forgot sqe->flags |= IOSQE_FIXED_FILE; in my modified test.

> So it cannot be used with opcodes that create (or close) file
> descriptors either.

ok, I thought `dirfd` could have been the index of my registered fd
for `openat` call. It was not very clear to me this was not possible
to use fixed files for those opcodes.

Thanks,
-- 
William
