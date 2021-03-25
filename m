Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B811349C62
	for <lists+io-uring@lfdr.de>; Thu, 25 Mar 2021 23:38:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231258AbhCYWi0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 25 Mar 2021 18:38:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230341AbhCYWiA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 25 Mar 2021 18:38:00 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A01B0C06175F
        for <io-uring@vger.kernel.org>; Thu, 25 Mar 2021 15:37:59 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id n138so4875384lfa.3
        for <io-uring@vger.kernel.org>; Thu, 25 Mar 2021 15:37:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5e4oQJs7D+v1Fp3qOgnpvnuKs8stkr9RsHaAFeuS1Fc=;
        b=ZFU9nYcCw1i1YZLwUD9j6hzdpJn7J4V1dZU6rfkkC0CTqlwogXdIkiC/7xKG04aIBY
         PA92xy40DUv5AHeYhyJTT93+bTuuKfpRfF5xBzIpvKm63s6OjulKUT/Cp/9KZOQC72Hw
         QdfoxCxgbz5pWPRCuETEw+RkR53XEtwLJFTq4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5e4oQJs7D+v1Fp3qOgnpvnuKs8stkr9RsHaAFeuS1Fc=;
        b=EZDtCf4b+IAaPDIUojCTWdT6lGVmqhj201q68HRGfagD5VhPwkw3ry8zF0gVFtxz9J
         R+V+YpZUBLGMbZs4cxmKRZTvsuPegAkYXALAjdgEJXqUeWhNT9qETOoL5iujHMg7uGgv
         ThXmWZOYUPG9LHlMh+qRbUYI+VtUJ58ZhFWApoB+yjeLKXE71syS7dc6Z7S3EBbuMBtP
         fTObzl+TKSmrfyZ9hufFDbiYDpi86wWiSC+PXIJxoSray7UsAMVk9hP/aD4nS4bwuA27
         72Rpz8zoGi7RAF6jAEGifD0RTtaq6/1Pqycx6D8B5JYEUuuo6WJ9GzeAzknjcmgFViKB
         am8g==
X-Gm-Message-State: AOAM5314W1xrbt9YBd8coobAHn7DOCdOt/N2BFTuvfeEZnFg/2OoXoIt
        wNvXoLqRqiDfHeJZaiSUsrQOWixFWN5QsA==
X-Google-Smtp-Source: ABdhPJzJvzNTozhcVMg4mRLPTxhjneEpuMiGVwvOsKLRypqWwpkjtAHUe7v5CThoPbpwJMyArSiPtA==
X-Received: by 2002:ac2:5617:: with SMTP id v23mr6360263lfd.123.1616711877949;
        Thu, 25 Mar 2021 15:37:57 -0700 (PDT)
Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com. [209.85.167.41])
        by smtp.gmail.com with ESMTPSA id g24sm665163lfv.257.2021.03.25.15.37.56
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Mar 2021 15:37:56 -0700 (PDT)
Received: by mail-lf1-f41.google.com with SMTP id q29so4846578lfb.4
        for <io-uring@vger.kernel.org>; Thu, 25 Mar 2021 15:37:56 -0700 (PDT)
X-Received: by 2002:a05:6512:3ba9:: with SMTP id g41mr5979179lfv.421.1616711875760;
 Thu, 25 Mar 2021 15:37:55 -0700 (PDT)
MIME-Version: 1.0
References: <20210325164343.807498-1-axboe@kernel.dk> <m1ft0j3u5k.fsf@fess.ebiederm.org>
 <CAHk-=wjOXiEAjGLbn2mWRsxqpAYUPcwCj2x5WgEAh=gj+o0t4Q@mail.gmail.com>
 <CAHk-=wg1XpX=iAv=1HCUReMbEgeN5UogZ4_tbi+ehaHZG6d==g@mail.gmail.com>
 <CAHk-=wgUcVeaKhtBgJO3TfE69miJq-krtL8r_Wf_=LBTJw6WSg@mail.gmail.com>
 <ad21da2b-01ea-e77c-70b2-0401059e322b@kernel.dk> <f9bc0bac-2ad9-827e-7360-099e1e310df5@kernel.dk>
In-Reply-To: <f9bc0bac-2ad9-827e-7360-099e1e310df5@kernel.dk>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 25 Mar 2021 15:37:39 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgmHRvoYdsA2ZL4aEOYvNx-5c7typsUbFcqq+GmOMcoDQ@mail.gmail.com>
Message-ID: <CAHk-=wgmHRvoYdsA2ZL4aEOYvNx-5c7typsUbFcqq+GmOMcoDQ@mail.gmail.com>
Subject: Re: [PATCH 0/2] Don't show PF_IO_WORKER in /proc/<pid>/task/
To:     Jens Axboe <axboe@kernel.dk>
Cc:     "Eric W. Biederman" <ebiederm@xmission.com>,
        io-uring <io-uring@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Stefan Metzmacher <metze@samba.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Mar 25, 2021 at 2:44 PM Jens Axboe <axboe@kernel.dk> wrote:
>
> In the spirit of "let's just try it", I ran with the below patch. With
> that, I can gdb attach just fine to a test case that creates an io_uring
> and a regular thread with pthread_create(). The regular thread uses
> the ring, so you end up with two iou-mgr threads. Attach:
>
> [root@archlinux ~]# gdb -p 360
> [snip gdb noise]
> Attaching to process 360
> [New LWP 361]
> [New LWP 362]
> [New LWP 363]
[..]

Looks fairly sane to me.

I think this ends up being the right approach - just the final part
(famous last words) of "io_uring threads act like normal threads".

Doing it for VM and FS got rid of all the special cases there, and now
doing it for signal handling gets rid of all these ptrace etc issues.

And the fact that a noticeable part of the patch was removing the
PF_IO_WORKER tests again looks like a very good sign to me.

In fact, I think you could now remove all the freezer hacks too -
because get_signal() will now do the proper try_to_freeze(), so all
those freezer things are stale as well.

Yeah, it's still going to be different in that there's no real user
space return, and so it will never look _entirely_ like a normal
thread, but on the whole I really like how this does seem to get rid
of another batch of special cases.

               Linus
