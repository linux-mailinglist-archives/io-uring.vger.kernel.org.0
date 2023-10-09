Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E76C17BD83A
	for <lists+io-uring@lfdr.de>; Mon,  9 Oct 2023 12:11:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346048AbjJIKLs (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 9 Oct 2023 06:11:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346099AbjJIKLr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 9 Oct 2023 06:11:47 -0400
Received: from mail-vs1-xe34.google.com (mail-vs1-xe34.google.com [IPv6:2607:f8b0:4864:20::e34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5103CF;
        Mon,  9 Oct 2023 03:11:42 -0700 (PDT)
Received: by mail-vs1-xe34.google.com with SMTP id ada2fe7eead31-45260b91a29so1605374137.2;
        Mon, 09 Oct 2023 03:11:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1696846301; x=1697451101; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JUzeNqXLaaK5niHZagSjVNk/fZkBVBIUEPMvh8M2SQE=;
        b=ENZ7CXHnJiD1vn2bGsqxeExGcBuaXJ7ZLomisKu1HKbeXRYSK4BmkR6Mb0wK74pXu/
         keikOpuVGjrc2yhRkApq+8ddtf9h7xKjDW2Rnq4H4b0Z9sDRPxu5TUhxiGMPAlxJ8mZl
         L+Prj1emV4fiA74hQt/HIbv1ZnWpLr9c1ooVhfCz1ZFGgOo6b6GKIu3Xn8cG1fGT59iK
         fuKD1GC+qRdpVNN7SqIKLCWutXg4oqOQ/CWAm7WMsiXnsLB/EhHl2+VK1ruZw7OVg1cU
         cTk3itzgMSLtbXAt88VOupp51sM8RwnCM3/U9d2Smd43EKK2YMsYUbui3846RYJAm3Yb
         oo6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696846301; x=1697451101;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JUzeNqXLaaK5niHZagSjVNk/fZkBVBIUEPMvh8M2SQE=;
        b=qyu1pvmpItGwiOMbBd654Q8ypTFjfwBvnSvCmpEqe8AIH+Ur1hrXUAwTfHTdk58VsA
         eGcAzh03T8wvomEzDC2AbuU6AJnU1rvd1PzyqfZdqyD9mPfiXlf+JlEezjx/QJaAjOup
         MS7WWz88BSi/LlYl8iYt1IvzZlT+LqgHxjxYzFrFJ0k1jAnFgx+BoglxZ1tVSUuaxSiY
         pq8umDbR3Am6AZwJQwtN0XFyt01tFcX9t+OANnhYhpmNxkzim8stR/u/Sv96WFjUjl90
         lYX0rHhnnDb4Hh0rkWoBoNcZsAzuRcDSayVV/zVbKjRo+8GYYfgT5VEnzyb+FrniagxI
         eZFA==
X-Gm-Message-State: AOJu0YwlJvA8ubkUzEPp3p1LT2tc18LfTUg02NsoaRgKuFb8NjQNdEY4
        b4xmIvO1gt418xSbg7D9V89ToQCM+aHtVp4qmvM=
X-Google-Smtp-Source: AGHT+IFfKt7rhAld5ba1A6Tt3iiSG6hva5HsfJYyiYTBqzOf6MFDYJ0x5tJ/nwBO3nl3NArAiioUQwhCR7BI9zV64Fo=
X-Received: by 2002:a67:b142:0:b0:452:5b2d:7787 with SMTP id
 z2-20020a67b142000000b004525b2d7787mr11446793vsl.0.1696846301611; Mon, 09 Oct
 2023 03:11:41 -0700 (PDT)
MIME-Version: 1.0
References: <20230904162504.1356068-1-leitao@debian.org> <20230905154951.0d0d3962@kernel.org>
 <ZSArfLaaGcfd8LH8@gmail.com>
In-Reply-To: <ZSArfLaaGcfd8LH8@gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Mon, 9 Oct 2023 03:11:05 -0700
Message-ID: <CAF=yD-Lr3238obe-_omnPBvgdv2NLvdK5be-5F7YyV3H7BkhSg@mail.gmail.com>
Subject: Re: [PATCH v4 00/10] io_uring: Initial support for {s,g}etsockopt commands
To:     Breno Leitao <leitao@debian.org>
Cc:     Jakub Kicinski <kuba@kernel.org>, sdf@google.com, axboe@kernel.dk,
        asml.silence@gmail.com, martin.lau@linux.dev, krisman@suse.de,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, io-uring@vger.kernel.org, pabeni@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Oct 6, 2023 at 10:45=E2=80=AFAM Breno Leitao <leitao@debian.org> wr=
ote:
>
> Hello Jakub,
>
> On Tue, Sep 05, 2023 at 03:49:51PM -0700, Jakub Kicinski wrote:
> > On Mon,  4 Sep 2023 09:24:53 -0700 Breno Leitao wrote:
> > > Patches 1-2: Modify the BPF hooks to support sockptr_t, so, these fun=
ctions
> > > become flexible enough to accept user or kernel pointers for optval/o=
ptlen.
> >
> > Have you seen:
> >
> > https://lore.kernel.org/all/CAHk-=3DwgGV61xrG=3DgO0=3DdXH64o2TDWWrXn1mx=
-CX885JZ7h84Og@mail.gmail.com/
> >
> > ? I wasn't aware that Linus felt this way, now I wonder if having
> > sockptr_t spread will raise any red flags as this code flows back
> > to him.
>
> Thanks for the heads-up. I've been thinking about it for a while and I'd
> like to hear what are the next steps here.
>
> Let me first back up and state where we are, and what is the current
> situation:
>
> 1) __sys_getsockopt() uses __user pointers for both optval and optlen
> 2) For io_uring command, Jens[1] suggested we get optlen from the io_urin=
g
> sqe, which is a kernel pointer/value.
>
> Thus, we need to make the common code (callbacks) able to handle __user
> and kernel pointers (for optlen, at least).
>
> From a proto_ops callback perspective, ->setsockopt() uses sockptr.
>
>           int             (*setsockopt)(struct socket *sock, int level,
>                                         int optname, sockptr_t optval,
>                                         unsigned int optlen);
>
> Getsockopt() uses sockptr() for level=3DSOL_SOCKET:
>
>         int sk_getsockopt(struct sock *sk, int level, int optname,
>                     sockptr_t optval, sockptr_t optlen)
>
> But not for the other levels:
>
>         int             (*getsockopt)(struct socket *sock, int level,
>                                       int optname, char __user *optval, i=
nt __user *optlen);
>
>
> That said, if this patchset shouldn't use sockptr anymore, what is the
> recommendation?
>
> If we move this patchset to use iov_iter instead of sockptr, then I
> understand we want to move *all* these callbacks to use iov_vec. Is this
> the right direction?
>
> Thanks for the guidance!
>
> [1] https://lore.kernel.org/all/efe602f1-8e72-466c-b796-0083fd1c6d82@kern=
el.dk/

Since sockptr_t is already used by __sys_setsockopt and
__sys_setsockopt, patches 1 and 2 don't introduce any new sockptr code
paths.

setsockopt callbacks also already use sockptr as of commit
a7b75c5a8c41 ("net: pass a sockptr_t into ->setsockopt").

getsockopt callbacks do take user pointers, just not sockptr.

Is the only issue right now the optlen kernel pointer?
