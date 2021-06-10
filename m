Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAD973A3567
	for <lists+io-uring@lfdr.de>; Thu, 10 Jun 2021 23:05:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230280AbhFJVHe (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 10 Jun 2021 17:07:34 -0400
Received: from mail-lf1-f54.google.com ([209.85.167.54]:41783 "EHLO
        mail-lf1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230035AbhFJVHe (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 10 Jun 2021 17:07:34 -0400
Received: by mail-lf1-f54.google.com with SMTP id j20so5299028lfe.8
        for <io-uring@vger.kernel.org>; Thu, 10 Jun 2021 14:05:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hvL3lGwbeiN7MBxmsi5XUSzTl5bywBkq1SiXoFH9p/Y=;
        b=h5msG03u/H4hnhe+y6dZRvJGZM7Z1bjF9rSXqXZFXISpshwR35XOKKkNfFcU03dOQZ
         UOuf4TEMF1JPT/M4VVo37xPOjNyCt/8oZXgGCHZDs4SCE2xITO/oY8+2Ss+oKPbfETpd
         Q1u/byu5sVQ5jFQU3+ukI40pjUCqgaobqASIg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hvL3lGwbeiN7MBxmsi5XUSzTl5bywBkq1SiXoFH9p/Y=;
        b=aaK/AtTuuSFYvAQ7gc6o1mNHomeoRGc98/hmhu9axtekjWxOIiR19qnVqr9diNNrEG
         eAoq1fpYkGnHA17MfMoZtWse2/wk4ofnFwXesi3gpEYJMyj3Pt5aeb+QhRNZjx4gEhd6
         LGMZTqFAFjs5tXPPMv4U49kMtP+HGf/8yvPFEhujeCPgVKBBEjk7VO31/jjBw5xQVlcY
         Sy0sJh5AU0EtVd0NfUq5odEOo/O60YYBicnrSrOqJL+1VbFeyqS0N8Tv+pr0NsfR8UM7
         s+7i/kWKQcKZudoir/14eMxNAUF/6iZ/9+vdwKaiU9IhrarmuB2fJouaBdQmAeQwLgBe
         Mxlw==
X-Gm-Message-State: AOAM533hPy76C1Y/UCkZ3eGu/TPEJJd/eKmqQgYOOo4h4ozQr/zfjNtP
        Q/9bIbrbhu2EBmcg+i033L7dUO5XaRV08/zI1CA=
X-Google-Smtp-Source: ABdhPJwHi3Jsm/3frUrYXBWAHHaebiIN4i1C5kjKNfti3oz0gDLUWWkYv9xSJs5POMEHhpRnqIzXZA==
X-Received: by 2002:a05:6512:1152:: with SMTP id m18mr431336lfg.559.1623359062038;
        Thu, 10 Jun 2021 14:04:22 -0700 (PDT)
Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com. [209.85.167.45])
        by smtp.gmail.com with ESMTPSA id c17sm400923lfr.56.2021.06.10.14.04.20
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Jun 2021 14:04:20 -0700 (PDT)
Received: by mail-lf1-f45.google.com with SMTP id r5so5329772lfr.5
        for <io-uring@vger.kernel.org>; Thu, 10 Jun 2021 14:04:20 -0700 (PDT)
X-Received: by 2002:a05:6512:3d13:: with SMTP id d19mr433821lfv.41.1623359060330;
 Thu, 10 Jun 2021 14:04:20 -0700 (PDT)
MIME-Version: 1.0
References: <192c9697e379bf084636a8213108be6c3b948d0b.camel@trillion01.com>
 <9692dbb420eef43a9775f425cb8f6f33c9ba2db9.camel@trillion01.com>
 <87h7i694ij.fsf_-_@disp2133> <CAHk-=wjC7GmCHTkoz2_CkgSc_Cgy19qwSQgJGXz+v2f=KT3UOw@mail.gmail.com>
 <198e912402486f66214146d4eabad8cb3f010a8e.camel@trillion01.com>
 <87eeda7nqe.fsf@disp2133> <b8434a8987672ab16f9fb755c1fc4d51e0f4004a.camel@trillion01.com>
 <87pmwt6biw.fsf@disp2133> <87czst5yxh.fsf_-_@disp2133> <CAHk-=wiax83WoS0p5nWvPhU_O+hcjXwv6q3DXV8Ejb62BfynhQ@mail.gmail.com>
 <87y2bh4jg5.fsf@disp2133> <CAHk-=wjPiEaXjUp6PTcLZFjT8RrYX+ExtD-RY3NjFWDN7mKLbw@mail.gmail.com>
 <87sg1p4h0g.fsf_-_@disp2133>
In-Reply-To: <87sg1p4h0g.fsf_-_@disp2133>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 10 Jun 2021 14:04:04 -0700
X-Gmail-Original-Message-ID: <CAHk-=wj5_=m4DyZ=8==bfL2UCnWU=UDjQu-XCq_b92oDJh1i-Q@mail.gmail.com>
Message-ID: <CAHk-=wj5_=m4DyZ=8==bfL2UCnWU=UDjQu-XCq_b92oDJh1i-Q@mail.gmail.com>
Subject: Re: [PATCH] coredump: Limit what can interrupt coredumps
To:     "Eric W. Biederman" <ebiederm@xmission.com>
Cc:     Olivier Langlois <olivier@trillion01.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        io-uring <io-uring@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Jens Axboe <axboe@kernel.dk>,
        "Pavel Begunkov>" <asml.silence@gmail.com>,
        Oleg Nesterov <oleg@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Jun 10, 2021 at 1:11 PM Eric W. Biederman <ebiederm@xmission.com> wrote:
>
> Make the coredump code more robust by explicitly testing for all of
> the wakeup conditions the coredump code supports.  This prevents
> new wakeup conditions from breaking the coredump code, as well
> as fixing the current issue.

Thanks, applied.

And lots of thanks to Olivier who kept debugging the odd coredump
behavior he saw.

            Linus
