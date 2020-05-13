Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3402C1D1C7E
	for <lists+io-uring@lfdr.de>; Wed, 13 May 2020 19:42:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732694AbgEMRmf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 13 May 2020 13:42:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732435AbgEMRmf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 13 May 2020 13:42:35 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3174FC061A0C
        for <io-uring@vger.kernel.org>; Wed, 13 May 2020 10:42:35 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id w10so565830ljo.0
        for <io-uring@vger.kernel.org>; Wed, 13 May 2020 10:42:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pQS9PZSZkC7J4FQkV4xe75LJQYCCMj17Z0oYFTEHPAg=;
        b=CuNHH4dtXsRN1EAJPY6PDuqYboQGoRqGyFQeIKled0eFTwTjnqRO8hPh+XtFI8pLKe
         PvVnJ1iMi2tr/lQ0jytjS5UFXtomk896SeiJJyJ84jTl+75H9tAOAeaBylYcdzNdhEvt
         FjJKbe8B4hccHFVGQ3h5oEYjUI1bJeIuzrgC0NkX7qyEXxl/MgoB9t0uq2618qIgXxZx
         dRk04iTv7iKcfzfo7TqtNb17hsuwh/KQYPnE1FCebmt/nIy8iIPXzZCukM+2zNFEsnbe
         R42fMBIfkcOlF4iSwKE7leE2cr70zuMXFzgk1v8BmZwVxzGo2Zw6WDiDGMtrxFnIiiLY
         +L9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pQS9PZSZkC7J4FQkV4xe75LJQYCCMj17Z0oYFTEHPAg=;
        b=sXGC55cAKm+G0MgvWT78hyKZFe9tcnXsyI6ztLZWU80QimMbFgGyR7DAgu2Xqlf0/z
         4Sc1jiSnGRfGll/TkNzckz/DuEZrU5744qTgG2moprJF04u4RL79UFhzuR82u0BjJFo8
         e5nZVFcwW2ESZ8CJjRB2zFUaOJHTJS+KZC8/WUulHgxQEGK3Y5EdlbdsmxP/DbZKBEgn
         y4FJdYRkwg6d8rEl5a0G6wwT3DpDqWT2BP1XYhnTAjLfP5EI3LPm8VrrKIUNidVJGRCN
         2YgCv2CViZmz800HercomodlGapZK2XUp9Zp1LDLseDVyHmCztsucO0gUIlp7LP5IEId
         oPXA==
X-Gm-Message-State: AOAM531Z6ElpMOoQGWzJFltRuW0zqeyCZhbxVDqNBfeGhDhm1/Qd1gzv
        XHiX0FstwoOZT9zuINDEbuouxUfu/Ot0OeSNFkVVNw==
X-Google-Smtp-Source: ABdhPJxpFDG22Y809iXjpQMHfUixwp4Zg6FEPmzfikjpGdIc/OC7MzvC4yQr1nPLFLkafaeIxQrxrSP8aIMPO7qNl2g=
X-Received: by 2002:a2e:87d3:: with SMTP id v19mr145416ljj.176.1589391753304;
 Wed, 13 May 2020 10:42:33 -0700 (PDT)
MIME-Version: 1.0
References: <492bb956-a670-8730-a35f-1d878c27175f@kernel.dk>
In-Reply-To: <492bb956-a670-8730-a35f-1d878c27175f@kernel.dk>
From:   Jann Horn <jannh@google.com>
Date:   Wed, 13 May 2020 19:42:07 +0200
Message-ID: <CAG48ez0eGT60a50GAkL3FVvRzpXwhufdr+68k_X_qTgxyZ-oQQ@mail.gmail.com>
Subject: Re: [PATCH RFC} io_uring: io_kiocb alloc cache
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring <io-uring@vger.kernel.org>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        joseph qi <joseph.qi@linux.alibaba.com>,
        Jiufei Xue <jiufei.xue@linux.alibaba.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux-MM <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

+slab allocator people

On Wed, May 13, 2020 at 6:30 PM Jens Axboe <axboe@kernel.dk> wrote:
> I turned the quick'n dirty from the other day into something a bit
> more done. Would be great if someone else could run some performance
> testing with this, I get about a 10% boost on the pure NOP benchmark
> with this. But that's just on my laptop in qemu, so some real iron
> testing would be awesome.

10% boost compared to which allocator? Are you using CONFIG_SLUB?

> The idea here is to have a percpu alloc cache. There's two sets of
> state:
>
> 1) Requests that have IRQ completion. preempt disable is not enough
>    there, we need to disable local irqs. This is a lot slower in
>    certain setups, so we keep this separate.
>
> 2) No IRQ completion, we can get by with just disabling preempt.

The SLUB allocator has percpu caching, too, and as long as you don't
enable any SLUB debugging or ASAN or such, and you're not hitting any
slowpath processing, it doesn't even have to disable interrupts, it
gets away with cmpxchg_double.

Have you profiled what the actual problem is when using SLUB? Have you
tested with CONFIG_SLAB_FREELIST_HARDENED turned off,
CONFIG_SLUB_DEBUG turned off, CONFIG_TRACING turned off,
CONFIG_FAILSLAB turned off, and so on? As far as I know, if you
disable all hardening and debugging infrastructure, SLUB's
kmem_cache_alloc()/kmem_cache_free() on the fastpaths should be really
straightforward. And if you don't turn those off, the comparison is
kinda unfair, because your custom freelist won't respect those flags.

When you build custom allocators like this, it interferes with
infrastructure meant to catch memory safety issues and such (both pure
debugging code and safety checks meant for production use) - for
example, ASAN and memory tagging will no longer be able to detect
use-after-free issues in objects managed by your custom allocator
cache.

So please, don't implement custom one-off allocators in random
subsystems. And if you do see a way to actually improve the
performance of memory allocation, add that to the generic SLUB
infrastructure.

> Outside of that, any freed requests goes to the ce->alloc_list.
> Attempting to alloc a request will check there first. When freeing
> a request, if we're over some threshold, move requests to the
> ce->free_list. This list can be browsed by the shrinker to free
> up memory. If a CPU goes offline, all requests are reaped.
>
> That's about it. If we go further with this, it'll be split into
> a few separate patches. For now, just throwing this out there
> for testing. The patch is against my for-5.8/io_uring branch.

That branch doesn't seem to exist on
<https://git.kernel.dk/cgit/linux-block/>...
