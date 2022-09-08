Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87E8D5B155E
	for <lists+io-uring@lfdr.de>; Thu,  8 Sep 2022 09:07:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231135AbiIHHHh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 8 Sep 2022 03:07:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231246AbiIHHHf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 8 Sep 2022 03:07:35 -0400
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8F219FAB8;
        Thu,  8 Sep 2022 00:07:33 -0700 (PDT)
Date:   Thu, 8 Sep 2022 03:07:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1662620851;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wTEYgGZ5tSon77wS7vl2ROsEnkkCO0gsMgQptW+CPqI=;
        b=iJA14xapCDtkxxFZ191Tkejngxj1CUcv4kW7CKzkjsz7ATcaQDWEu0NFSqx3I6BQdf18/S
        WTbuPmJUiio1UduO89kjDWGE8I/TqqMPK7/HJWAK+mBPhtt24ufrZC9OZJmb5VRtm8xK61
        6ZzGjTRW6DZ8SglZivSmm0qDFb8PFdY=
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
Message-ID: <20220908070719.ootyzzbd47dd5rkv@kmo-framework>
References: <20220901201502.sn6223bayzwferxv@moria.home.lan>
 <YxW4Ig338d2vQAz3@dhcp22.suse.cz>
 <20220905234649.525vorzx27ybypsn@kmo-framework>
 <Yxb1cxDSyte1Ut/F@dhcp22.suse.cz>
 <20220906182058.iijmpzu4rtxowy37@kmo-framework>
 <Yxh5ueDTAOcwEmCQ@dhcp22.suse.cz>
 <20220907130323.rwycrntnckc6h43n@kmo-framework>
 <20220907094306.3383dac2@gandalf.local.home>
 <20220908063548.u4lqkhquuvkwzvda@kmo-framework>
 <CAJuCfpEQG3+d-45PXhS=pD6ktrmqNQQnpf_-3+c2CG7rzuz+2g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJuCfpEQG3+d-45PXhS=pD6ktrmqNQQnpf_-3+c2CG7rzuz+2g@mail.gmail.com>
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

On Wed, Sep 07, 2022 at 11:49:37PM -0700, Suren Baghdasaryan wrote:
> I would really appreciate if everyone could please stick to the
> technical side of the conversation. That way we can get some
> constructive feedback. Everything else is not helpful and at best is a
> distraction.
> Maintenance burden is a price we pay and I think it's the prerogative
> of the maintainers to take that into account. Our job is to prove that
> the price is worth paying.

Well said.

I'd also like to add - slab.h does look pretty overgrown and messy. We've grown
a _lot_ of special purpose memory allocation interfaces, and I think it probably
is time to try and wrangle that back.

The API complexity isn't just an issue for this patch - it's an issue for
anything that has to wrap and plumb through memory allocation interfaces. It's a
pain point for the Rust people, and also comes in e.g. the mempool API.

I think we should keep going with the memalloc_no*_save()/restore() approach,
and extend it to other things:

 - memalloc_nowait_save()
 - memalloc_highpri_save()

(these two get you GFP_ATOMIC).

Also, I don't think these all need to be separate functions, we could have

memalloc_gfp_apply()
memalloc_gfp_restore()

which simply takes a gfp flags argument and applies it to the current
PF_MEMALLOC flags.

We've had long standing bugs where vmalloc() can't correctly take gfp flags
because some of the allocations it does for page tables don't have it correctly
plumbed through; switching to the memalloc_*_(save|restore) is something people
have been wanting in order to fix this - for years. Actually following through
and completing this would let us kill the gfp flags arguments to our various
memory allocators entirely.

I think we can do the same thing with the numa node parameter - kill
kmalloc_node() et. all, move it to task_struct with a set of save/restore
functions.

There's probably other things we can do to simplify slab.h if we look more. I've
been hoping to start pushing patches for some of this stuff - it's going to be
some time before I can get to it though, can only handle so many projects in
flight at a time :)
