Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 196A631A5E6
	for <lists+io-uring@lfdr.de>; Fri, 12 Feb 2021 21:17:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231289AbhBLUQy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 12 Feb 2021 15:16:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229957AbhBLUQt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 12 Feb 2021 15:16:49 -0500
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEBF1C061574
        for <io-uring@vger.kernel.org>; Fri, 12 Feb 2021 12:16:08 -0800 (PST)
Received: by mail-lj1-x233.google.com with SMTP id a17so543335ljq.2
        for <io-uring@vger.kernel.org>; Fri, 12 Feb 2021 12:16:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2zr87bmMh7RY80ToTKvmmYWZr2nKADqCYJnVNenpNJk=;
        b=KLuRnOqcc6P/A1Te5YMxDIKcZqJL6LMIdTmhiVNdbsRJpCcr8qbxsXYRTVOyGGLQW4
         5EWvyMwtvDdx+8bWGlNCIqiuUpiU6FOpgcIRoCaKWfiig0vEh5SD9NFdNYtDKTHHplp6
         Aaz6d+8PK2kEMeSRB64yZNdPoclYcxv3+8vag=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2zr87bmMh7RY80ToTKvmmYWZr2nKADqCYJnVNenpNJk=;
        b=B5ZREEYCbEMDB3gxFuCA4tWV8dOxA3wIfXQtcceHHVFTMhkiTwXyDp/LHMFXEWcY99
         8Rqzy57JvqsvZqVJlwqrMS+kbRs05QAohKAxb0bm0J5MzmCeM0tUFEjZvK4BNe+PL525
         fXEeDQx/aO8N81ormralK4zpufMEyqlXWhAzyLvsP2Jc3UmVA6GFwY+J5qzlFiXR12jS
         wAoqrfKy/iI6rlqInzSvJ4yWLke2MqYfbEs+omVSURUisHbVE5RZzJUcxDO81huMx0eb
         Zr3HU/IfWFQ/BVgdDIiKIGA7MW7+K3XCbWlU10wAZTsm50KIGqwya/9dDOxiQltWG81/
         rURQ==
X-Gm-Message-State: AOAM531/LFJcD7Qbr1iBSAQ1Jh3dVmh0+4JxBrKyKB4q7kVzL5YqtX4T
        0pj8PGAhoXXTr4iaVPsI4XjjQqdQwp9aCw==
X-Google-Smtp-Source: ABdhPJzpZ+tqt1n+pcmr9EjW5m52KKlGF/GbU7BVuZPZ+IepCUtAK1FTUgyxtcrWdtWnvpLCFKsWcQ==
X-Received: by 2002:a2e:9a8c:: with SMTP id p12mr2729151lji.196.1613160967107;
        Fri, 12 Feb 2021 12:16:07 -0800 (PST)
Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com. [209.85.208.172])
        by smtp.gmail.com with ESMTPSA id l9sm1256850lfp.209.2021.02.12.12.16.05
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Feb 2021 12:16:06 -0800 (PST)
Received: by mail-lj1-f172.google.com with SMTP id e18so468712lja.12
        for <io-uring@vger.kernel.org>; Fri, 12 Feb 2021 12:16:05 -0800 (PST)
X-Received: by 2002:a2e:8116:: with SMTP id d22mr2520275ljg.48.1613160965588;
 Fri, 12 Feb 2021 12:16:05 -0800 (PST)
MIME-Version: 1.0
References: <a1f5c4b9-5c5d-a184-7ede-78739e1c01c6@kernel.dk>
 <CAHk-=wicH60LB9sENxT95mE_LY-EPruphMc-wRRXc97KVER2vQ@mail.gmail.com>
 <1b7b68bd-80d4-8be8-cf6d-26df28e334ce@kernel.dk> <CAHk-=wjEuDEVBM+3SMStLC8Jh8iaDe4JY5hKg4SRGR5G6HuCtg@mail.gmail.com>
 <0c813cc8-142e-15a4-de6a-ebdcf1f03b13@kernel.dk>
In-Reply-To: <0c813cc8-142e-15a4-de6a-ebdcf1f03b13@kernel.dk>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 12 Feb 2021 12:15:49 -0800
X-Gmail-Original-Message-ID: <CAHk-=whB_gY_ex5CKXeVU28V-EajfRSWpAJ4aFQWrQBAC+Lc0w@mail.gmail.com>
Message-ID: <CAHk-=whB_gY_ex5CKXeVU28V-EajfRSWpAJ4aFQWrQBAC+Lc0w@mail.gmail.com>
Subject: Re: [GIT PULL] io_uring fix for 5.11 final
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Feb 12, 2021 at 12:10 PM Jens Axboe <axboe@kernel.dk> wrote:
>
> Right, it's exactly the AF_UNIX dgram case. Working on adding some checks
> that means we'll catch this sort of thing upfront while testing.

You might also just add a comment to the IORING_OP_{SEND,RECV}MSG
cases to the work-flags.

It doesn't hurt to just mention those kinds of things explicitly.

Because maybe somebody decides that IO_WQ_WORK_FS is very expensive
for their workload. With the comment they might then be able to say
"let's set it only for the AF_UNIX case" or some similar optimization.

Yeah, it probably doesn't matter, but just as a policy, I think "we
got this wrong, so let's clarify" is a good idea.

              Linus
