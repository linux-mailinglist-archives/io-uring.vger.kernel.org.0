Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FFBE5B151C
	for <lists+io-uring@lfdr.de>; Thu,  8 Sep 2022 08:50:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229936AbiIHGub (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 8 Sep 2022 02:50:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231181AbiIHGtw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 8 Sep 2022 02:49:52 -0400
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3409A543CE
        for <io-uring@vger.kernel.org>; Wed,  7 Sep 2022 23:49:50 -0700 (PDT)
Received: by mail-yb1-xb32.google.com with SMTP id a67so13264948ybb.3
        for <io-uring@vger.kernel.org>; Wed, 07 Sep 2022 23:49:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=6UU7RPsFxQr+5ujpTkN8WcG542NNzl57+boNHvVA5zY=;
        b=JG/SHVRfqPRHCrjuBmlApXDX/0abpJphKrT6tyZKJBPfjdSoDudABKV77zHlEN88Fn
         gauZaKg028mQXz4IhYxWZ6Al32CCP7yJWGueoM6BfqmIyFGbhNHc42e0XX3fkUwzZeB7
         iahq4zbGmhiQP33NCZ4T4eKaA3vZuTmEr9lnFAypcBd+txISnaxXaWXjTNPPmjg9GajS
         6tRoG+4jxmfz1oriGaY/Kn1wnCqhPvgpDkXyvbhPKfNgBFNHlvzvS89+D7eIK/a1Yl6T
         kxR18XZMyg4CCoy23A8LpUnI5xLUkeiu/ZUM9+hqU3uz7MWOC86ALqrtypYUZ97mcz9b
         OvFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=6UU7RPsFxQr+5ujpTkN8WcG542NNzl57+boNHvVA5zY=;
        b=fF2z223d2+IVSGgWaXIcnnDEV7Hite0Y37K8Ik4jaa2ZYZV+3r4CiC3rw8T2ZM/vn8
         Gi6XaIygCy+02KxhJy+/5MwkV2mqAqfGFJARKDy7YTn28d79a6z8o7xCfc3pdVZYWtzg
         1WO5/BTXkeZJ2s/MiCWJz6ZDldjmoAsUIH2eB3vakxWITfxEOUkN7P4cDblrbVTTnoR2
         6KBMO3+gIqBMs/quRnTLvkC775sQLR7XPlN4KDxYwYl0SU/xJn3Wuqs/k8qr1tpcuPUY
         qbHxqYENoDFWSDmJiGKwMUucwqT09j2TMirN8/UavDoUnBI4BeUBD/LIGX1A43Ifsjf4
         d2Gg==
X-Gm-Message-State: ACgBeo3OLKf3eXIng6Ka90irG/LbJfbyM0/M4O8zLYo9s0Vl9aQVjYrz
        ykGviWHJUd/Bdi35RuNryDARhJ70+0+AjI7Je12IEg==
X-Google-Smtp-Source: AA6agR5jgN0SarKose7cXaAc78GK8TgcCf+kCWZDJ6j/hZNw94xbAsDdKa9I2VH+YZqtbSZxUJOMS41d9AU0E7sKk2c=
X-Received: by 2002:a5b:cc4:0:b0:6ae:2a6c:59e6 with SMTP id
 e4-20020a5b0cc4000000b006ae2a6c59e6mr1980963ybr.59.1662619789134; Wed, 07 Sep
 2022 23:49:49 -0700 (PDT)
MIME-Version: 1.0
References: <YxEE1vOwRPdzKxoq@dhcp22.suse.cz> <CAJuCfpHuzJGTA_-m0Jfawc7LgJLt4GztUUY4K9N9-7bFqJuXnw@mail.gmail.com>
 <20220901201502.sn6223bayzwferxv@moria.home.lan> <YxW4Ig338d2vQAz3@dhcp22.suse.cz>
 <20220905234649.525vorzx27ybypsn@kmo-framework> <Yxb1cxDSyte1Ut/F@dhcp22.suse.cz>
 <20220906182058.iijmpzu4rtxowy37@kmo-framework> <Yxh5ueDTAOcwEmCQ@dhcp22.suse.cz>
 <20220907130323.rwycrntnckc6h43n@kmo-framework> <20220907094306.3383dac2@gandalf.local.home>
 <20220908063548.u4lqkhquuvkwzvda@kmo-framework>
In-Reply-To: <20220908063548.u4lqkhquuvkwzvda@kmo-framework>
From:   Suren Baghdasaryan <surenb@google.com>
Date:   Wed, 7 Sep 2022 23:49:37 -0700
Message-ID: <CAJuCfpEQG3+d-45PXhS=pD6ktrmqNQQnpf_-3+c2CG7rzuz+2g@mail.gmail.com>
Subject: Re: [RFC PATCH 00/30] Code tagging framework and applications
To:     Kent Overstreet <kent.overstreet@linux.dev>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Michal Hocko <mhocko@suse.com>, Mel Gorman <mgorman@suse.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Davidlohr Bueso <dave@stgolabs.net>,
        Matthew Wilcox <willy@infradead.org>,
        "Liam R. Howlett" <liam.howlett@oracle.com>,
        David Vernet <void@manifault.com>,
        Juri Lelli <juri.lelli@redhat.com>,
        Laurent Dufour <ldufour@linux.ibm.com>,
        Peter Xu <peterx@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, mcgrof@kernel.org,
        masahiroy@kernel.org, nathan@kernel.org, changbin.du@intel.com,
        ytcoode@gmail.com, Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Benjamin Segall <bsegall@google.com>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Valentin Schneider <vschneid@redhat.com>,
        Christopher Lameter <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>, 42.hyeyoo@gmail.com,
        Alexander Potapenko <glider@google.com>,
        Marco Elver <elver@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Shakeel Butt <shakeelb@google.com>,
        Muchun Song <songmuchun@bytedance.com>, arnd@arndb.de,
        jbaron@akamai.com, David Rientjes <rientjes@google.com>,
        Minchan Kim <minchan@google.com>,
        Kalesh Singh <kaleshsingh@google.com>,
        kernel-team <kernel-team@android.com>,
        linux-mm <linux-mm@kvack.org>, iommu@lists.linux.dev,
        kasan-dev@googlegroups.com, io-uring@vger.kernel.org,
        linux-arch@vger.kernel.org, xen-devel@lists.xenproject.org,
        linux-bcache@vger.kernel.org, linux-modules@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Sep 7, 2022 at 11:35 PM Kent Overstreet
<kent.overstreet@linux.dev> wrote:
>
> On Wed, Sep 07, 2022 at 09:45:18AM -0400, Steven Rostedt wrote:
> > On Wed, 7 Sep 2022 09:04:28 -0400
> > Kent Overstreet <kent.overstreet@linux.dev> wrote:
> >
> > > On Wed, Sep 07, 2022 at 01:00:09PM +0200, Michal Hocko wrote:
> > > > Hmm, it seems that further discussion doesn't really make much sense
> > > > here. I know how to use my time better.
> > >
> > > Just a thought, but I generally find it more productive to propose ideas than to
> > > just be disparaging.
> > >
> >
> > But it's not Michal's job to do so. He's just telling you that the given
> > feature is not worth the burden. He's telling you the issues that he has
> > with the patch set. It's the submitter's job to address those concerns and
> > not the maintainer's to tell you how to make it better.
> >
> > When Linus tells us that a submission is crap, we don't ask him how to make
> > it less crap, we listen to why he called it crap, and then rewrite to be
> > not so crappy. If we cannot figure it out, it doesn't get in.
>
> When Linus tells someone a submission is crap, he _always_ has a sound, and
> _specific_ technical justification for doing so.
>
> "This code is going to be a considerable maintenance burden" is vapid, and lazy.
> It's the kind of feedback made by someone who has looked at the number of lines
> of code a patch touches and not much more.

I would really appreciate if everyone could please stick to the
technical side of the conversation. That way we can get some
constructive feedback. Everything else is not helpful and at best is a
distraction.
Maintenance burden is a price we pay and I think it's the prerogative
of the maintainers to take that into account. Our job is to prove that
the price is worth paying.

>
> --
> To unsubscribe from this group and stop receiving emails from it, send an email to kernel-team+unsubscribe@android.com.
>
