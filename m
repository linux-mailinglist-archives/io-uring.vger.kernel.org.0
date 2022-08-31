Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF6DB5A8377
	for <lists+io-uring@lfdr.de>; Wed, 31 Aug 2022 18:48:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232319AbiHaQsg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 31 Aug 2022 12:48:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231926AbiHaQsb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 31 Aug 2022 12:48:31 -0400
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B11BD83E7
        for <io-uring@vger.kernel.org>; Wed, 31 Aug 2022 09:48:29 -0700 (PDT)
Received: by mail-yb1-xb30.google.com with SMTP id y197so5006846yby.13
        for <io-uring@vger.kernel.org>; Wed, 31 Aug 2022 09:48:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=6n1zc63jDuzyjKJX97Ppd3P3cpaKkA3xHe9Swtr7rxY=;
        b=VIdq+RErxf0PvdNDjrVGs2xPK3B0rNLymMqmwIf/bH5QaRKd3T3TPNaSejCRtao3kK
         KXPLbmwg5LRzFYtF5BuBFJiwK/+mPBjKO/MlQ27xXQf8k4L7vWPckSKFmWQP7Dfsp6Sl
         M5hXBIs6T8rqHUTvYskZOH6CC+dXw6Lm4bBWXUwBF1eDWO7eNfIGjAEigAV+0s81txPn
         Fz0URG4E8J5Lj4s98oD61ddGJEDNPlbl1qKyb3s4bDCN9GbA0+acWByl//DGVqlqSYLa
         B+9EEskkUFezCj8PiDfqv37B3qhmrr/PjuX9xcNxSUscGYuyFBYe2yRfMi3mBikEte0+
         ygEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=6n1zc63jDuzyjKJX97Ppd3P3cpaKkA3xHe9Swtr7rxY=;
        b=vr0QKDU5eS/eIybEWkGRx7amr7aCC5RSz8ZsV4LRYXHBPbOUJ1MYsDilTD8LxOXaL9
         OyBpNR3YGVGDcrTmiKaKsOWrZOdUJL44uIe+fTX33FOS0KQ/BNr6+JD+eUaNOd5efnRv
         l7aNCpXSWu9YQmH6AOWHt4WaU5Jpb9h+eO2F2sb2utXTpzaz8cg4onLOnEUrnHA/wEea
         3q55kONhY2yWTGYcNsWYWNo/S1EjrP4cbQcmzFaoXqO8RkWwDWKIIwhncGUjKcGddNCB
         SzTzQnO16/cRqmI9f3iCQV9WFsN/wMx5xBOGy7R7ORC7F1H+2TuOTX1jE4JskrVr7UOL
         pvPQ==
X-Gm-Message-State: ACgBeo3MV1u/8mR6s2HyfA030wCFbXep5PLjoh7+6o7ex0bkXGQtuNVy
        bVmHKN+qPQ+QxlQ2tREEkuOojs7zJMu9QBz5ScBCog==
X-Google-Smtp-Source: AA6agR4yhCoLDamoorLSfffIdQAWE2JXv8ZvTcRtyX3MuCW3iMDBbPaNi4yGEiRj94PMg+OOUK3k3jnByRFyc9VhtmY=
X-Received: by 2002:a05:6902:1366:b0:691:4335:455b with SMTP id
 bt6-20020a056902136600b006914335455bmr15675462ybb.282.1661964508623; Wed, 31
 Aug 2022 09:48:28 -0700 (PDT)
MIME-Version: 1.0
References: <20220830214919.53220-1-surenb@google.com> <Yw8P8xZ4zqu121xL@hirez.programming.kicks-ass.net>
 <20220831084230.3ti3vitrzhzsu3fs@moria.home.lan> <20220831101948.f3etturccmp5ovkl@suse.de>
 <Yw88RFuBgc7yFYxA@dhcp22.suse.cz> <CAJuCfpGZ==v0HGWBzZzHTgbo4B_ZBe6V6U4T_788LVWj8HhCRQ@mail.gmail.com>
In-Reply-To: <CAJuCfpGZ==v0HGWBzZzHTgbo4B_ZBe6V6U4T_788LVWj8HhCRQ@mail.gmail.com>
From:   Suren Baghdasaryan <surenb@google.com>
Date:   Wed, 31 Aug 2022 09:48:17 -0700
Message-ID: <CAJuCfpEuLjd+FJ7MQQ+y=ghVnYQP-WDcXxLCcy07JQ0VFweLEg@mail.gmail.com>
Subject: Re: [RFC PATCH 00/30] Code tagging framework and applications
To:     Michal Hocko <mhocko@suse.com>
Cc:     Mel Gorman <mgorman@suse.de>,
        Kent Overstreet <kent.overstreet@linux.dev>,
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
        Steven Rostedt <rostedt@goodmis.org>,
        Benjamin Segall <bsegall@google.com>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Valentin Schneider <vschneid@redhat.com>,
        Christopher Lameter <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>, 42.hyeyoo@gmail.com,
        Alexander Potapenko <glider@google.com>,
        Marco Elver <elver@google.com>, dvyukov@google.com,
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

On Wed, Aug 31, 2022 at 8:28 AM Suren Baghdasaryan <surenb@google.com> wrote:
>
> On Wed, Aug 31, 2022 at 3:47 AM Michal Hocko <mhocko@suse.com> wrote:
> >
> > On Wed 31-08-22 11:19:48, Mel Gorman wrote:
> > > On Wed, Aug 31, 2022 at 04:42:30AM -0400, Kent Overstreet wrote:
> > > > On Wed, Aug 31, 2022 at 09:38:27AM +0200, Peter Zijlstra wrote:
> > > > > On Tue, Aug 30, 2022 at 02:48:49PM -0700, Suren Baghdasaryan wrote:
> > > > > > ===========================
> > > > > > Code tagging framework
> > > > > > ===========================
> > > > > > Code tag is a structure identifying a specific location in the source code
> > > > > > which is generated at compile time and can be embedded in an application-
> > > > > > specific structure. Several applications of code tagging are included in
> > > > > > this RFC, such as memory allocation tracking, dynamic fault injection,
> > > > > > latency tracking and improved error code reporting.
> > > > > > Basically, it takes the old trick of "define a special elf section for
> > > > > > objects of a given type so that we can iterate over them at runtime" and
> > > > > > creates a proper library for it.
> > > > >
> > > > > I might be super dense this morning, but what!? I've skimmed through the
> > > > > set and I don't think I get it.
> > > > >
> > > > > What does this provide that ftrace/kprobes don't already allow?
> > > >
> > > > You're kidding, right?
> > >
> > > It's a valid question. From the description, it main addition that would
> > > be hard to do with ftrace or probes is catching where an error code is
> > > returned. A secondary addition would be catching all historical state and
> > > not just state since the tracing started.
> > >
> > > It's also unclear *who* would enable this. It looks like it would mostly
> > > have value during the development stage of an embedded platform to track
> > > kernel memory usage on a per-application basis in an environment where it
> > > may be difficult to setup tracing and tracking. Would it ever be enabled
> > > in production? Would a distribution ever enable this? If it's enabled, any
> > > overhead cannot be disabled/enabled at run or boot time so anyone enabling
> > > this would carry the cost without never necessarily consuming the data.
>
> Thank you for the question.
> For memory tracking my intent is to have a mechanism that can be enabled in
> the field testing (pre-production testing on a large population of
> internal users).
> The issue that we are often facing is when some memory leaks are happening
> in the field but very hard to reproduce locally. We get a bugreport
> from the user
> which indicates it but often has not enough information to track it. Note that
> quite often these leaks/issues happen in the drivers, so even simply finding out
> where they came from is a big help.
> The way I envision this mechanism to be used is to enable the basic memory
> tracking in the field tests and have a user space process collecting
> the allocation
> statistics periodically (say once an hour). Once it detects some counter growing
> infinitely or atypically (the definition of this is left to the user
> space) it can enable
> context capturing only for that specific location, still keeping the
> overhead to the
> minimum but getting more information about potential issues. Collected stats and
> contexts are then attached to the bugreport and we get more visibility
> into the issue
> when we receive it.
> The goal is to provide a mechanism with low enough overhead that it
> can be enabled
> all the time during these field tests without affecting the device's
> performance profiles.
> Tracing is very cheap when it's disabled but having it enabled all the
> time would
> introduce higher overhead than the counter manipulations.
> My apologies, I should have clarified all this in this cover letter
> from the beginning.
>
> As for other applications, maybe I'm not such an advanced user of
> tracing but I think only
> the latency tracking application might be done with tracing, assuming
> we have all the
> right tracepoints but I don't see how we would use tracing for fault
> injections and
> descriptive error codes. Again, I might be mistaken.

Sorry about the formatting of my reply. Forgot to reconfigure the editor on
the new machine.

>
> Thanks,
> Suren.
>
> > >
> > > It might be an ease-of-use thing. Gathering the information from traces
> > > is tricky and would need combining multiple different elements and that
> > > is development effort but not impossible.
> > >
> > > Whatever asking for an explanation as to why equivalent functionality
> > > cannot not be created from ftrace/kprobe/eBPF/whatever is reasonable.
> >
> > Fully agreed and this is especially true for a change this size
> > 77 files changed, 3406 insertions(+), 703 deletions(-)
> >
> > --
> > Michal Hocko
> > SUSE Labs
