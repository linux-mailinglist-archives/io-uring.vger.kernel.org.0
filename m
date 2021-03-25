Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5D02349A99
	for <lists+io-uring@lfdr.de>; Thu, 25 Mar 2021 20:43:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230085AbhCYTnZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 25 Mar 2021 15:43:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229614AbhCYTnS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 25 Mar 2021 15:43:18 -0400
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B07CBC06175F
        for <io-uring@vger.kernel.org>; Thu, 25 Mar 2021 12:43:17 -0700 (PDT)
Received: by mail-lj1-x231.google.com with SMTP id y1so4633867ljm.10
        for <io-uring@vger.kernel.org>; Thu, 25 Mar 2021 12:43:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+rfCXMw7Ia35+MkG3YYSaEH5EyHrXL8XWZ5oML2YGPk=;
        b=Z84KI+gMz+ZuXDkBZLxeBsccvBv9x7Itvz6gYVLR5i/AiRsr1eRwDbto63Hft8YF2F
         dfvVQJuY5GdhrM3hTV1dbPh3VhCsWJZaPM4Mc7Aco3XAThjwpvbocKfJM7KDJE3RvLet
         w3UQqtNeYquPsnW4WlBmyK2PqnIMvsMs1aNBs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+rfCXMw7Ia35+MkG3YYSaEH5EyHrXL8XWZ5oML2YGPk=;
        b=EP31WipP4Uohr3Vu6wf7Lh7QcrnMiNgHcr1YauDEZCWNbFUVs1GE7Q2NN6NxrWOmo3
         3KsCnquIRqE83lldS2KVhs7h5nW5QPNYdyKOIU8rU/pOfyaZeAayHGpWfXv2zgvMJl1g
         Jp1s22lXm4LixPL0T0/zO1faQ9bpP8YlUhaCvGVxBS+vUKjLJhf6Lf3wEhzQIKiZ/G3E
         waJazr1dsyOqH7KcIj/yPICAaxr1zbj9sjN0yh0SLdX10hKCp587KSEpSJ2Y55wZ7rga
         S27tA41t4HxS5WG30ZOtHySxHoW9wkDOsly8XcBPXQyfHLJEZDJFNNP37/r/XIKaQSnO
         9cTg==
X-Gm-Message-State: AOAM533RGK5iPkJNTF4ZJfK90xfPo4qmQXYn3LAIMVXaH97C+OKnwDlP
        0KfT8/zAvmpBCekWNDgSmFDl+LXxzm2IpQ==
X-Google-Smtp-Source: ABdhPJz1OsYFA4GFwTBDanIKiw12oOVattZ7Hq8gtWe6AXUQj5fq6cQzkn8X8D7GXl3HJgK6U9srPg==
X-Received: by 2002:a2e:bc13:: with SMTP id b19mr6823861ljf.381.1616701395914;
        Thu, 25 Mar 2021 12:43:15 -0700 (PDT)
Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com. [209.85.167.43])
        by smtp.gmail.com with ESMTPSA id m16sm637074lfo.17.2021.03.25.12.43.15
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Mar 2021 12:43:15 -0700 (PDT)
Received: by mail-lf1-f43.google.com with SMTP id i26so4249321lfl.1
        for <io-uring@vger.kernel.org>; Thu, 25 Mar 2021 12:43:15 -0700 (PDT)
X-Received: by 2002:a05:6512:25a:: with SMTP id b26mr5948990lfo.253.1616701394782;
 Thu, 25 Mar 2021 12:43:14 -0700 (PDT)
MIME-Version: 1.0
References: <20210325164343.807498-1-axboe@kernel.dk> <m1ft0j3u5k.fsf@fess.ebiederm.org>
 <CAHk-=wjOXiEAjGLbn2mWRsxqpAYUPcwCj2x5WgEAh=gj+o0t4Q@mail.gmail.com>
In-Reply-To: <CAHk-=wjOXiEAjGLbn2mWRsxqpAYUPcwCj2x5WgEAh=gj+o0t4Q@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 25 Mar 2021 12:42:58 -0700
X-Gmail-Original-Message-ID: <CAHk-=wg1XpX=iAv=1HCUReMbEgeN5UogZ4_tbi+ehaHZG6d==g@mail.gmail.com>
Message-ID: <CAHk-=wg1XpX=iAv=1HCUReMbEgeN5UogZ4_tbi+ehaHZG6d==g@mail.gmail.com>
Subject: Re: [PATCH 0/2] Don't show PF_IO_WORKER in /proc/<pid>/task/
To:     "Eric W. Biederman" <ebiederm@xmission.com>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Stefan Metzmacher <metze@samba.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Mar 25, 2021 at 12:38 PM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> I don't know what the gdb logic is, but maybe there's some other
> option that makes gdb not react to them?

.. maybe we could have a different name for them under the task/
subdirectory, for example (not  just the pid)? Although that probably
messes up 'ps' too..

          Linus
