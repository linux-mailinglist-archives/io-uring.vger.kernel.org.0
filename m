Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9594B5AF376
	for <lists+io-uring@lfdr.de>; Tue,  6 Sep 2022 20:21:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229759AbiIFSVy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 6 Sep 2022 14:21:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229693AbiIFSVx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 6 Sep 2022 14:21:53 -0400
Received: from out1.migadu.com (out1.migadu.com [91.121.223.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F60D98352;
        Tue,  6 Sep 2022 11:21:52 -0700 (PDT)
Date:   Tue, 6 Sep 2022 14:20:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1662488510;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/bRlcVcrWdQKJLJipKk17c91ZfuMwNoEsJqygzANM10=;
        b=e2VD/HcikFLJhe0V11ErS/Oin4ybn/TXkbGiMkiUOxLxKEWpdcoX4otQ2quaeh2xN9tkEz
        gJSSZJlOcx5MH/FwRLBQM+nMzvd03D3L1jInmtTiFs1YUwF1FG/7tFAS2gRVdaASeb5tb9
        7SVVXyTQbLTanYnVJHubYmXd6a/lpqA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     Michal Hocko <mhocko@suse.com>
Cc:     Suren Baghdasaryan <surenb@google.com>,
        Mel Gorman <mgorman@suse.de>,
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
Message-ID: <20220906182058.iijmpzu4rtxowy37@kmo-framework>
References: <Yw88RFuBgc7yFYxA@dhcp22.suse.cz>
 <20220831190154.qdlsxfamans3ya5j@moria.home.lan>
 <YxBc1xuGbB36f8zC@dhcp22.suse.cz>
 <CAJuCfpGhwPFYdkOLjwwD4ra9JxPqq1T5d1jd41Jy3LJnVnhNdg@mail.gmail.com>
 <YxEE1vOwRPdzKxoq@dhcp22.suse.cz>
 <CAJuCfpHuzJGTA_-m0Jfawc7LgJLt4GztUUY4K9N9-7bFqJuXnw@mail.gmail.com>
 <20220901201502.sn6223bayzwferxv@moria.home.lan>
 <YxW4Ig338d2vQAz3@dhcp22.suse.cz>
 <20220905234649.525vorzx27ybypsn@kmo-framework>
 <Yxb1cxDSyte1Ut/F@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yxb1cxDSyte1Ut/F@dhcp22.suse.cz>
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

On Tue, Sep 06, 2022 at 09:23:31AM +0200, Michal Hocko wrote:
> On Mon 05-09-22 19:46:49, Kent Overstreet wrote:
> > On Mon, Sep 05, 2022 at 10:49:38AM +0200, Michal Hocko wrote:
> > > This is really my main concern about this whole work. Not only it adds a
> > > considerable maintenance burden to the core MM because
> > 
> > [citation needed]
> 
> I thought this was clear from the email content (the part you haven't
> quoted here). But let me be explicit one more time for you.
> 
> I hope we can agree that in order for this kind of tracking to be useful
> you need to cover _callers_ of the allocator or in the ideal world
> the users/owner of the tracked memory (the later is sometimes much
> harder/impossible to track when the memory is handed over from one peer
> to another).
> 
> It is not particularly useful IMO to see that a large portion of the
> memory has been allocated by say vmalloc or kvmalloc, right?  How
> much does it really tell you that a lot of memory has been allocated
> by kvmalloc or vmalloc? Yet, neither of the two is handled by the
> proposed tracking and it would require additional code to be added and
> _maintained_ to cover them. But that would be still far from complete,
> we have bulk allocator, mempools etc.

Of course - and even a light skimming of the patch set would see it does indeed
address this. We still have to do vmalloc and percpu memory allocations, but
slab is certainly handled and that's the big one.

> As pointed above this just scales poorly and adds to the API space. Not
> to mention that direct use of alloc_tag_add can just confuse layers
> below which rely on the same thing.

It might help you make your case if you'd say something about what you'd like
better.

Otherwise, saying "code has to be maintained" is a little bit like saying water
is wet, and we're all engineers here, I think we know that :)
