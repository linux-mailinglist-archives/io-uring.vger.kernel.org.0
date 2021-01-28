Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE743307C6F
	for <lists+io-uring@lfdr.de>; Thu, 28 Jan 2021 18:31:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233071AbhA1R3E (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 28 Jan 2021 12:29:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233122AbhA1R0u (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 28 Jan 2021 12:26:50 -0500
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C126C061756;
        Thu, 28 Jan 2021 09:26:10 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id j18so4948089wmi.3;
        Thu, 28 Jan 2021 09:26:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FspasjBdvOyQr6r45W+eIjHtBw+6zev/SfrwICE1x+E=;
        b=M4blj2lAzwljc11390CinZGBi0ydd5QI0CCu45Tj5PhQGdcUSCE8b2Tc9hoho3g22S
         agCTwHalauhPkOOxRsPCf91BAO9tmGmA/SPZQXHPrsx3lrcVzOgxJSBI06BgHSLIKqkZ
         Dh6cZ681hcvvWJVnqkqgYmVWj+MM5j0Wn5guMLjWQNAUlE+IMTAVybQPWQlbkA+iyGnf
         vCEX7rU+XsJtbzZZBrTi6jE9d4GwdNcrmAr3ntZo3y7xjfaHWIGJKSGYzA7xJdBRHKvQ
         NDyUWpmzSLCeF3Rcsl/iA+jdu2koTbJ6CPFhUgaBSxBs07wvqL1GwORoM1SsETsq9cg0
         Tcrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FspasjBdvOyQr6r45W+eIjHtBw+6zev/SfrwICE1x+E=;
        b=CJniC295G5wb6EFAy3VSSvUKW7EWf1CFHiLhvgHZiTIphHJKRVzVWJGf+lITnZrVw0
         Uz136kp/BBtRYbm+GNWMGrt0DD72qCm+r04KgmJy5qPT//e2MC7XaXXMaLFXe11FyJ9N
         CgJEGWp4PAYXSX5z/9TZAYi4aSf/3pGdprQecWbEbD+VmiYFYPJw6JcfITndJ6dOZ86f
         8YyZ8KFlktd35Ge1hb/ynV4DFKOiNqdGo4cd5h2Tq8lhwk+xG0mwN1jHXiZH9SGa2dKz
         z5ZG02gsG07cipIzqcrCJ4oKm8eizoe2jGT11aaY0BZpGA4e4XyjGtwaOFxI1gNHU+ac
         RiZQ==
X-Gm-Message-State: AOAM533KTRO1AyL1ZJtGD2Dss+BjUP8/GErpDpgvGalQCIRzZZqEjCAs
        0bsj/UnrDff53pCWkIn14QtuHyYc+Hx+FzttOFM=
X-Google-Smtp-Source: ABdhPJzRZk3KfSDLq5r5eXz0qggXIiZNjt0V4LKZlF2sNSCmYLPS1wUhBg/Xdhnxvq7cEiQQ12TOE410aFGwN0dZUdo=
X-Received: by 2002:a1c:5f54:: with SMTP id t81mr283428wmb.25.1611854769125;
 Thu, 28 Jan 2021 09:26:09 -0800 (PST)
MIME-Version: 1.0
References: <CGME20210127150134epcas5p251fc1de3ff3581dd4c68b3fbe0b9dd91@epcas5p2.samsung.com>
 <20210127150029.13766-1-joshi.k@samsung.com> <489691ce-3b1e-30ce-9f72-d32389e33901@gmail.com>
 <a287bd9e-3474-83a4-e5c2-98df17214dc7@gmail.com> <CA+1E3rJHHFyjwv7Kp32E9H-cf5ksh0pOHSVdGoTpktQrB8SE6A@mail.gmail.com>
 <6d847f4a-65a5-bc62-1d36-52e222e3d142@kernel.dk>
In-Reply-To: <6d847f4a-65a5-bc62-1d36-52e222e3d142@kernel.dk>
From:   Kanchan Joshi <joshiiitr@gmail.com>
Date:   Thu, 28 Jan 2021 22:55:41 +0530
Message-ID: <CA+1E3rLD2e4yFsA-gxPGtp2Fg2Z0sdfpS3Rz+WsUC4i5aF43LA@mail.gmail.com>
Subject: Re: [RFC PATCH 0/4] Asynchronous passthrough ioctl
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        Kanchan Joshi <joshi.k@samsung.com>,
        Keith Busch <kbusch@kernel.org>,
        Christoph Hellwig <hch@lst.de>, sagi@grimberg.me,
        linux-nvme@lists.infradead.org, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Javier Gonzalez <javier.gonz@samsung.com>,
        Nitesh Shetty <nj.shetty@samsung.com>, anuj20.g@samsung.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Jan 28, 2021 at 8:20 PM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 1/28/21 5:04 AM, Kanchan Joshi wrote:
> > And for some ioctls, driver may still need to use task-work to update
> > the user-space pointers (embedded in uring/ioctl cmd) during
> > completion.
>
> For this use case, we should ensure that just io_uring handles this
> part. It's already got everything setup for it, and I'd rather avoid
> having drivers touch any of those parts. Could be done by having an
> io_uring helper ala:
>
> io_uring_cmd_complete_in_task(cmd, handler);
>
> which takes care of the nitty gritty details.

Ah right. With that, I can do away with exporting task-work.
NVMe completion can invoke (depending on ioctl) this uring-helper with
a handler that does the ioctl-specific update in task context.



-- 
Kanchan
