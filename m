Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0ABF25ADA5A
	for <lists+io-uring@lfdr.de>; Mon,  5 Sep 2022 22:42:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231318AbiIEUmk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 5 Sep 2022 16:42:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229546AbiIEUmj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 5 Sep 2022 16:42:39 -0400
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75E9A65645;
        Mon,  5 Sep 2022 13:42:38 -0700 (PDT)
Date:   Mon, 5 Sep 2022 16:42:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1662410556;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WiGoaCLsrAtGX5WjZ54R9ZEwhVpr8CfiS3GHCMjFnnI=;
        b=hnmt3aHZjiqk4ERDUnjQhKqTOVd36AXDvGfghBFkI6MlG+YAV38zdha6mLi0wPB8rg9d9p
        f+XQ8HrbJOiH4ZgK5Kz3JWnaEEtobK791M/A4ImHaFUKx2pGDzECdjOHQ8Ioeny6lWxRc5
        3ffslWYfmfssKDR8OUSYZcd0xfFRct0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     Suren Baghdasaryan <surenb@google.com>
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
Subject: Re: [RFC PATCH 00/30] Code tagging framework and applications
Message-ID: <20220905204229.xqrqxmaax37n3ody@moria.home.lan>
References: <20220831084230.3ti3vitrzhzsu3fs@moria.home.lan>
 <20220831101948.f3etturccmp5ovkl@suse.de>
 <Yw88RFuBgc7yFYxA@dhcp22.suse.cz>
 <20220831190154.qdlsxfamans3ya5j@moria.home.lan>
 <YxBc1xuGbB36f8zC@dhcp22.suse.cz>
 <CAJuCfpGhwPFYdkOLjwwD4ra9JxPqq1T5d1jd41Jy3LJnVnhNdg@mail.gmail.com>
 <YxEE1vOwRPdzKxoq@dhcp22.suse.cz>
 <CAJuCfpFrRwXXQ=wAvZ-oUNKXUJ=uUA=fiDrkhRu5VGXcM+=cuA@mail.gmail.com>
 <20220905110713.27304149@gandalf.local.home>
 <CAJuCfpF-O6Gz2o7YqCgFHV+KEFuzC-PTUoBHj25DNRkkSmhbUg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJuCfpF-O6Gz2o7YqCgFHV+KEFuzC-PTUoBHj25DNRkkSmhbUg@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Sep 05, 2022 at 11:08:21AM -0700, Suren Baghdasaryan wrote:
> On Mon, Sep 5, 2022 at 8:06 AM Steven Rostedt <rostedt@goodmis.org> wrote:
> >
> > On Sun, 4 Sep 2022 18:32:58 -0700
> > Suren Baghdasaryan <surenb@google.com> wrote:
> >
> > > Page allocations (overheads are compared to get_free_pages() duration):
> > > 6.8% Codetag counter manipulations (__lazy_percpu_counter_add + __alloc_tag_add)
> > > 8.8% lookup_page_ext
> > > 1237% call stack capture
> > > 139% tracepoint with attached empty BPF program
> >
> > Have you tried tracepoint with custom callback?
> >
> > static void my_callback(void *data, unsigned long call_site,
> >                         const void *ptr, struct kmem_cache *s,
> >                         size_t bytes_req, size_t bytes_alloc,
> >                         gfp_t gfp_flags)
> > {
> >         struct my_data_struct *my_data = data;
> >
> >         { do whatever }
> > }
> >
> > [..]
> >         register_trace_kmem_alloc(my_callback, my_data);
> >
> > Now the my_callback function will be called directly every time the
> > kmem_alloc tracepoint is hit.
> >
> > This avoids that perf and BPF overhead.
> 
> Haven't tried that yet but will do. Thanks for the reference code!

Is it really worth the effort of benchmarking tracing API overhead here?

The main cost of a tracing based approach is going to to be the data structure
for remembering outstanding allocations so that free events can be matched to
the appropriate callsite. Regardless of whether it's done with BFP or by
attaching to the tracepoints directly, that's going to be the main overhead.
