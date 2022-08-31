Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C62155A87CC
	for <lists+io-uring@lfdr.de>; Wed, 31 Aug 2022 22:56:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231920AbiHaU4w (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 31 Aug 2022 16:56:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231829AbiHaU4u (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 31 Aug 2022 16:56:50 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB641DB7F9
        for <io-uring@vger.kernel.org>; Wed, 31 Aug 2022 13:56:46 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id u17so531232wrp.3
        for <io-uring@vger.kernel.org>; Wed, 31 Aug 2022 13:56:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=Q+TlttOrTWNB3q3o6Zbb04N1wsFemMMzZbBDHk1hdbY=;
        b=VyP3SbNsuyxc5blP2FoCVyjA1CBQu5fk1qPBiWwHnsN7KbhALhPVRs+hdxfauKkrjN
         HjpFIvR9qflpc5b/NaZbUp4Qe+yoyJx8jmIG71feNwOicipxd4Z45zOK95SSSmFlFqg1
         JlDxmSa+dos6d565oincRG6QsILc3r0lbpSqflqmVfv9TWNY+mQW2VINkINO6wGxloda
         V9BbsnXdjx9TWnVhm9AxW/SNuwlNLiahxr1xh25VEX0zm/Rv6sxPCVqP3nUxZGj48fmq
         8freUAXARJQoL1m1MzSBuxjvucYwjbHks6tBHAAViJ2OqT1E6YeDUp+dfTHOL3fNg2CJ
         OS0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=Q+TlttOrTWNB3q3o6Zbb04N1wsFemMMzZbBDHk1hdbY=;
        b=0Zxg562JhZDkeoSJlB4H1rmq7KtSUDDunAaPFwtWYmYZHxt64lwac3NpqHjpeNvkRS
         7YGDsrXSEpuMRYhghpII/EQ3xw2Lm87pvI37GXG7cp0dkdWzTx3mThjwDtmwB+va8SZV
         a6P4xij/uj4rNi/Lc9eCzrvTky8fznkfsqlN1kBIHAxriLiRixT/YG38WGhR5CWdfKA5
         sKU9i4vPu5a0R2D2xdGSbakuNfMkT4dDymqotFAsCtQew11Cx13ZARdL2vNBlCqLlR8i
         eKZ4DfUwko7vxSODDS0fwkrgtSceDnwAjuP1WV09P17Ap4XrcSlILn+01TvJ1JRNaFgg
         TbFw==
X-Gm-Message-State: ACgBeo29Iy4xUHA32pb8uCN8j0NKUo4eyhFLpus2cEQMb7jH/ndFbEdE
        cn85NnnTZi0SSUca+qgcb4CNyWBE8hAeX9LwsRE2pw==
X-Google-Smtp-Source: AA6agR7XK78VXHUjktIpBA+ayr5Wvv6QyZC54NZbTQlygRhYLtBkkgViGprvNovg9YVhzd6mrhctznnyhI9ADAmQ4D4=
X-Received: by 2002:a05:6000:1188:b0:220:6c20:fbf6 with SMTP id
 g8-20020a056000118800b002206c20fbf6mr13193874wrx.372.1661979404912; Wed, 31
 Aug 2022 13:56:44 -0700 (PDT)
MIME-Version: 1.0
References: <20220830214919.53220-1-surenb@google.com> <Yw8P8xZ4zqu121xL@hirez.programming.kicks-ass.net>
 <20220831084230.3ti3vitrzhzsu3fs@moria.home.lan> <20220831101948.f3etturccmp5ovkl@suse.de>
 <Yw88RFuBgc7yFYxA@dhcp22.suse.cz> <20220831190154.qdlsxfamans3ya5j@moria.home.lan>
In-Reply-To: <20220831190154.qdlsxfamans3ya5j@moria.home.lan>
From:   Yosry Ahmed <yosryahmed@google.com>
Date:   Wed, 31 Aug 2022 13:56:08 -0700
Message-ID: <CAJD7tkaev9B=UDYj2RL6pz-1454J8tv4gEr9y-2dnCksoLK0bw@mail.gmail.com>
Subject: Re: [RFC PATCH 00/30] Code tagging framework and applications
To:     Kent Overstreet <kent.overstreet@linux.dev>
Cc:     Michal Hocko <mhocko@suse.com>, Mel Gorman <mgorman@suse.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Suren Baghdasaryan <surenb@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Roman Gushchin <roman.gushchin@linux.dev>, dave@stgolabs.net,
        Matthew Wilcox <willy@infradead.org>, liam.howlett@oracle.com,
        void@manifault.com, juri.lelli@redhat.com, ldufour@linux.ibm.com,
        Peter Xu <peterx@redhat.com>,
        David Hildenbrand <david@redhat.com>, axboe@kernel.dk,
        mcgrof@kernel.org, masahiroy@kernel.org, nathan@kernel.org,
        changbin.du@intel.com, ytcoode@gmail.com,
        vincent.guittot@linaro.org, dietmar.eggemann@arm.com,
        Steven Rostedt <rostedt@goodmis.org>, bsegall@google.com,
        bristot@redhat.com, vschneid@redhat.com,
        Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>, 42.hyeyoo@gmail.com,
        glider@google.com, elver@google.com, dvyukov@google.com,
        Shakeel Butt <shakeelb@google.com>,
        Muchun Song <songmuchun@bytedance.com>, arnd@arndb.de,
        jbaron@akamai.com, David Rientjes <rientjes@google.com>,
        minchan@google.com, kaleshsingh@google.com,
        kernel-team@android.com, Linux-MM <linux-mm@kvack.org>,
        iommu@lists.linux.dev, kasan-dev@googlegroups.com,
        io-uring@vger.kernel.org, linux-arch@vger.kernel.org,
        xen-devel@lists.xenproject.org, linux-bcache@vger.kernel.org,
        linux-modules@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Aug 31, 2022 at 12:02 PM Kent Overstreet
<kent.overstreet@linux.dev> wrote:
>
> On Wed, Aug 31, 2022 at 12:47:32PM +0200, Michal Hocko wrote:
> > On Wed 31-08-22 11:19:48, Mel Gorman wrote:
> > > Whatever asking for an explanation as to why equivalent functionality
> > > cannot not be created from ftrace/kprobe/eBPF/whatever is reasonable.
> >
> > Fully agreed and this is especially true for a change this size
> > 77 files changed, 3406 insertions(+), 703 deletions(-)
>
> In the case of memory allocation accounting, you flat cannot do this with ftrace
> - you could maybe do a janky version that isn't fully accurate, much slower,
> more complicated for the developer to understand and debug and more complicated
> for the end user.
>
> But please, I invite anyone who's actually been doing this with ftrace to
> demonstrate otherwise.
>
> Ftrace just isn't the right tool for the job here - we're talking about adding
> per callsite accounting to some of the fastest fast paths in the kernel.
>
> And the size of the changes for memory allocation accounting are much more
> reasonable:
>  33 files changed, 623 insertions(+), 99 deletions(-)
>
> The code tagging library should exist anyways, it's been open coded half a dozen
> times in the kernel already.
>
> And once we've got that, the time stats code is _also_ far simpler than doing it
> with ftrace would be. If anyone here has successfully debugged latency issues
> with ftrace, I'd really like to hear it. Again, for debugging latency issues you
> want something that can always be on, and that's not cheap with ftrace - and
> never mind the hassle of correlating start and end wait trace events, builting
> up histograms, etc. - that's all handled here.
>
> Cheap, simple, easy to use. What more could you want?
>

This is very interesting work! Do you have any data about the overhead
this introduces, especially in a production environment? I am
especially interested in memory allocations tracking and detecting
leaks.
(Sorry if you already posted this kind of data somewhere that I missed)
