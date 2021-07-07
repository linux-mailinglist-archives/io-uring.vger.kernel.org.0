Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F9023BE80B
	for <lists+io-uring@lfdr.de>; Wed,  7 Jul 2021 14:34:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231546AbhGGMhD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 7 Jul 2021 08:37:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231784AbhGGMg4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 7 Jul 2021 08:36:56 -0400
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15F68C061764;
        Wed,  7 Jul 2021 05:32:17 -0700 (PDT)
Received: by mail-yb1-xb2b.google.com with SMTP id o139so2848430ybg.9;
        Wed, 07 Jul 2021 05:32:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7tTKmnnet7oGt+w9hkyfqp5x9oq9EgqvN8NAdJCFxts=;
        b=U1FWskDoot3FhiMATVLfs9uec9poosQPlKgS4r4Tsdr04V1we2XX2p//xlh0zqyEjb
         PDRslAvt5d9MgdOuc/qmSvYa5omrOpXEFKbF7dVG0Tbao09t9NLtmSQT4gOIDkpq9SoD
         J247tzfTEJ2YBTf1zmPjmMwRWXmDkWMN5npBKNZrhNSlpYezpqocPsnzmWqBnh3l9Rbi
         gPbjEvPLFPgpkVlM0qMrG0sQA5GMjk7K7K6hfrL2xUzYLCiI7I+bWOa+EXwlmXhRlK+E
         s4q+rPVLZ3G5XNHf046BQdl1LxA4a3s0XboB+FMMxGCXUJL63ksFA7tpriAqHIOhdFZU
         aHPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7tTKmnnet7oGt+w9hkyfqp5x9oq9EgqvN8NAdJCFxts=;
        b=lK/J4yR3omANGVei30pCfJ9HMUf5ozyF/Rjs7IvZGVJr1elOcadXoNZZfE9Kjh5/5d
         6wOVlKwmN51lqBrhIM9IvxzWKQSkVfY/ooYlvWF7KI/VveW4JHV0BjfsMNKpIwaio9K0
         XmbfSzUB7QhCdyYbP2qteglwd6MvudLCZCXYnH7qldQkT5o0+YByGr/oThvfGCiuYtCD
         AFfYHs9a3xG0kUQXBZ9+3e9+hP1d63ugPAgAoc7ZNvqKylQt1U/Jx490xvQcni2tlEcG
         BDYicIdYOtCvHX8l0DAxNEA+9UTZXOWyF5T55GvDm2jg+mS5MAnFjDAbbxip63kF20yu
         romQ==
X-Gm-Message-State: AOAM5323RW4C89m5CU+7l8zSmQQGyZoyD/8WseqMrXJQGZ3riNj7rtnx
        BZ+T0Bs3yAoS9IO1yOIWmfxM2qA1bDKeZvmpPlZncuq58gBLZBqk
X-Google-Smtp-Source: ABdhPJw2xJb0gRP2jvpIA9IQQWpGZJ9okPDfRhhCYuC1YJmjT/3zfgaav+Tq2DNZ4HceTpzmFIO/P5JpYGfgVpkqhv8=
X-Received: by 2002:a25:6c0a:: with SMTP id h10mr30251015ybc.167.1625661137067;
 Wed, 07 Jul 2021 05:32:17 -0700 (PDT)
MIME-Version: 1.0
References: <20210707122747.3292388-1-dkadashev@gmail.com>
In-Reply-To: <20210707122747.3292388-1-dkadashev@gmail.com>
From:   Dmitry Kadashev <dkadashev@gmail.com>
Date:   Wed, 7 Jul 2021 19:32:06 +0700
Message-ID: <CAOKbgA6gpdS97=f3A_=eJKDzmR-wHTJwQR+U0WR95PqSF=2b9w@mail.gmail.com>
Subject: Re: [PATCH v8 00/11] io_uring: add mkdir and [sym]linkat support
To:     Christian Brauner <christian.brauner@ubuntu.com>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        linux-fsdevel@vger.kernel.org, io-uring <io-uring@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Jens Axboe <axboe@kernel.dk>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Jul 7, 2021 at 7:27 PM Dmitry Kadashev <dkadashev@gmail.com> wrote:
>
> This started out as an attempt to add mkdirat support to io_uring which
> is heavily based on renameat() / unlinkat() support.
>
> During the review process more operations were added (linkat, symlinkat,
> mknodat) mainly to keep things uniform internally (in namei.c), and
> with things changed in namei.c adding support for these operations to
> io_uring is trivial, so that was done too (except for mknodat). See
> https://lore.kernel.org/io-uring/20210514145259.wtl4xcsp52woi6ab@wittgenstein/

Christian, I've kept your Acked-by on the old commits, since changes
there are pretty minimal (conditional putname()s are unconditional now,
and with __filename_* functions not consuming their args now some goto
labels changed). Hope that was the right thing to do.

-- 
Dmitry Kadashev
