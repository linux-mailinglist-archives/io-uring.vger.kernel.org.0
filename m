Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C362446C15
	for <lists+io-uring@lfdr.de>; Sat,  6 Nov 2021 03:41:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232537AbhKFCoE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 5 Nov 2021 22:44:04 -0400
Received: from [103.31.38.59] ([103.31.38.59]:52178 "EHLO gnuweeb.org"
        rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S229728AbhKFCoE (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Fri, 5 Nov 2021 22:44:04 -0400
X-Greylist: delayed 469 seconds by postgrey-1.27 at vger.kernel.org; Fri, 05 Nov 2021 22:44:03 EDT
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
        by gnuweeb.org (Postfix) with ESMTPSA id 5CB99C16F9;
        Sat,  6 Nov 2021 02:33:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=gnuweeb.org;
        s=default; t=1636166011;
        bh=k0/6s4y+RBoxmpT5WkQ6jb4QqMqTeCNGaGkp8JX8AVY=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=TqtjXN3JOi9xmIKPm9AqtMyYDlpNl9NeW6O3XA3lEt44lDGFzdwDVQSQNcFgbl/TN
         8pkzqXU8aAzSEbsDgAQ2dE5wyEE16dWIid1NO10Zb/8JFVmqLhyepecDBOjdJMdvou
         MrSM+mQr+v9oeLbZm5/eQ7rimyDbPv4VliqyttXpkg4DnTSalP9RlNadu8WD4kPNsK
         NZMLcKvUZl0UvHg9yqKS/eKMySfr+38Dnhb0p+Oa/AVFo9sQmKzPxHCJn8Pax0QrDb
         MbKOyhCnPhRvLUpbGS76N+ujtm9x33IUYddWDZ3T7Wd/PupKvy82409BGflPI8cy3A
         nFTtartUT0piA==
Received: by mail-ed1-f48.google.com with SMTP id x15so7987989edv.1;
        Fri, 05 Nov 2021 19:33:31 -0700 (PDT)
X-Gm-Message-State: AOAM5331RX7iQEIDZAOjNTbWPFGheklCNWlm6bLOsyAYJrvJwy0HhKGa
        s1bHJ1sq3/jvAh40Q/o3wMYf2HrNhdK62eC70PM=
X-Google-Smtp-Source: ABdhPJxtkbOsW/2Ug/FYaW6pK+5ujBYgjiTikPPgmCbAXXN3OwUzEHzyARJwHiTezHlXA3PVCUKqTbA4VIyigKwKhuc=
X-Received: by 2002:aa7:c391:: with SMTP id k17mr60290762edq.263.1636166008005;
 Fri, 05 Nov 2021 19:33:28 -0700 (PDT)
MIME-Version: 1.0
References: <20211028080813.15966-1-sir@cmpwn.com>
In-Reply-To: <20211028080813.15966-1-sir@cmpwn.com>
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
Date:   Sat, 6 Nov 2021 09:33:10 +0700
X-Gmail-Original-Message-ID: <CAFBCWQ+=2T4U7iNQz_vsBsGVQ72s+QiECndy_3AMFV98bMOLow@mail.gmail.com>
Message-ID: <CAFBCWQ+=2T4U7iNQz_vsBsGVQ72s+QiECndy_3AMFV98bMOLow@mail.gmail.com>
Subject: Re: [PATCH] Increase default MLOCK_LIMIT to 8 MiB
To:     Drew DeVault <sir@cmpwn.com>
Cc:     linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        io_uring Mailing List <io-uring@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Oct 28, 2021 at 3:08 PM Drew DeVault wrote:
>
> This limit has not been updated since 2008, when it was increased to 64
> KiB at the request of GnuPG. Until recently, the main use-cases for this
> feature were (1) preventing sensitive memory from being swapped, as in
> GnuPG's use-case; and (2) real-time use-cases. In the first case, little
> memory is called for, and in the second case, the user is generally in a
> position to increase it if they need more.
>
> The introduction of IOURING_REGISTER_BUFFERS adds a third use-case:
> preparing fixed buffers for high-performance I/O. This use-case will
> take as much of this memory as it can get, but is still limited to 64
> KiB by default, which is very little. This increases the limit to 8 MB,
> which was chosen fairly arbitrarily as a more generous, but still
> conservative, default value.
> ---
> It is also possible to raise this limit in userspace. This is easily
> done, for example, in the use-case of a network daemon: systemd, for
> instance, provides for this via LimitMEMLOCK in the service file; OpenRC
> via the rc_ulimit variables. However, there is no established userspace
> facility for configuring this outside of daemons: end-user applications
> do not presently have access to a convenient means of raising their
> limits.
>
> The buck, as it were, stops with the kernel. It's much easier to address
> it here than it is to bring it to hundreds of distributions, and it can
> only realistically be relied upon to be high-enough by end-user software
> if it is more-or-less ubiquitous. Most distros don't change this
> particular rlimit from the kernel-supplied default value, so a change
> here will easily provide that ubiquity.
>
>  include/uapi/linux/resource.h | 13 ++++++++++---
>  1 file changed, 10 insertions(+), 3 deletions(-)

Forgot to add Signed-off-by tag from the author?

-- 
Ammar Faizi
