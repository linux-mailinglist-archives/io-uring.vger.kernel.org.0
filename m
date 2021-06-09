Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55ADB3A1E5B
	for <lists+io-uring@lfdr.de>; Wed,  9 Jun 2021 22:53:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229557AbhFIUzW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 9 Jun 2021 16:55:22 -0400
Received: from mail-lf1-f52.google.com ([209.85.167.52]:46749 "EHLO
        mail-lf1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229527AbhFIUzV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 9 Jun 2021 16:55:21 -0400
Received: by mail-lf1-f52.google.com with SMTP id m21so24464852lfg.13
        for <io-uring@vger.kernel.org>; Wed, 09 Jun 2021 13:53:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XArs7dfKd1jb8KVECknZ5tHK7pCuauc7kNtOU0BuGyQ=;
        b=d2c1kWEJ0AgEydECoXutpmofFDQXFyVtEZ9eA5D5JURcxb31tlEXBtljToI9e7Yp4S
         nnIcfeTgiuCVJKge24fWKsfVzi+rcZe0APlOb5EAnE+y2tUwASVAyuMnEM1BsjngaF8O
         6ZbYHAR2LSXCzqR6zx26XbzDZ2HReHBMouhrY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XArs7dfKd1jb8KVECknZ5tHK7pCuauc7kNtOU0BuGyQ=;
        b=WKR6Kx5daKNe2omY8JYfOC19YmagrIE3m0rHEakOUN/+5shRh0SsLT3yGwuLBO5KRS
         H11ZXjYjomV4yQokGs9zvjDFeDjg9VEtZBCGhTl/h3ghj0J6rJKRhOPaxsZY4KsNkYSH
         BjnpemPZp87zc0DGREF/+tNPG09O+tIOJ8j43m993gF4MkHQr7OmObnN8HDz7bnw9G7U
         3W5L60Xe5R2SoPmogr1JubW6W1rUMbyTm4gWvHpSeXMPY2Sf8sA8Vhvwff1fLSn4+X4q
         Q+Ppboe82dl5hKyOfmp1zaW2QtbBzEWbzhUmXcgwHaebTXr6wla2GdH547BjLxbGitjY
         PWqw==
X-Gm-Message-State: AOAM532hAn6uIIUxIgRaG0zapr4w7FZb7L/pyjo8MSyurqkLYSZDUtiw
        j/9xx8BNymDGKGf/9qdPNCysFEHk1B+65WDkeQE=
X-Google-Smtp-Source: ABdhPJwHnQPXZVx0QarDhLcn2SHUFEGL4ynL1v7naxULeoEtJgHdvQ+8N62xI/wkB4X8fT/zYM1rCg==
X-Received: by 2002:a05:6512:3324:: with SMTP id l4mr792856lfe.273.1623271945357;
        Wed, 09 Jun 2021 13:52:25 -0700 (PDT)
Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com. [209.85.167.51])
        by smtp.gmail.com with ESMTPSA id k35sm96981lfv.260.2021.06.09.13.52.24
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Jun 2021 13:52:24 -0700 (PDT)
Received: by mail-lf1-f51.google.com with SMTP id bp38so4598874lfb.0
        for <io-uring@vger.kernel.org>; Wed, 09 Jun 2021 13:52:24 -0700 (PDT)
X-Received: by 2002:ac2:43b9:: with SMTP id t25mr826068lfl.253.1623271944108;
 Wed, 09 Jun 2021 13:52:24 -0700 (PDT)
MIME-Version: 1.0
References: <192c9697e379bf084636a8213108be6c3b948d0b.camel@trillion01.com>
 <9692dbb420eef43a9775f425cb8f6f33c9ba2db9.camel@trillion01.com>
 <87h7i694ij.fsf_-_@disp2133> <CAHk-=wjC7GmCHTkoz2_CkgSc_Cgy19qwSQgJGXz+v2f=KT3UOw@mail.gmail.com>
 <8735tq9332.fsf@disp2133>
In-Reply-To: <8735tq9332.fsf@disp2133>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 9 Jun 2021 13:52:07 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgXROFSDa6gHei4fNmdU=VppqnBThdCraNpuirriSyKQA@mail.gmail.com>
Message-ID: <CAHk-=wgXROFSDa6gHei4fNmdU=VppqnBThdCraNpuirriSyKQA@mail.gmail.com>
Subject: Re: [RFC] coredump: Do not interrupt dump for TIF_NOTIFY_SIGNAL
To:     "Eric W. Biederman" <ebiederm@xmission.com>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        io-uring <io-uring@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Olivier Langlois <olivier@trillion01.com>,
        Jens Axboe <axboe@kernel.dk>,
        "Pavel Begunkov>" <asml.silence@gmail.com>,
        Oleg Nesterov <oleg@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Jun 9, 2021 at 1:48 PM Eric W. Biederman <ebiederm@xmission.com> wrote:
>
> It looks like it would need to be:
>
> static bool dump_interrupted(void)
> {
>         return fatal_signal_pending() || freezing();
> }
>
> As the original implementation of dump_interrupted 528f827ee0bb
> ("coredump: introduce dump_interrupted()") is deliberately allowing the
> freezer to terminate the core dumps to allow for reliable system
> suspend.

Ack. That would seem to be the right conversion to do.

Now, I'm not sure if system suspend really should abort a core dump,
but it's clearly what we have done in the past.

Maybe we'd like to remove that "|| freezing()" at some point, but
that's a separate discussion, I think. At least having it in that form
makes it all very explicit, instead of the current very subtle exact
interaction with the TIF_NOTIFY_SIGNAL bit (that has other meanings).

Hmm?

             Linus
