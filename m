Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6684D5AE0FC
	for <lists+io-uring@lfdr.de>; Tue,  6 Sep 2022 09:25:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232983AbiIFHZc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 6 Sep 2022 03:25:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238918AbiIFHXf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 6 Sep 2022 03:23:35 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B88B974BAB;
        Tue,  6 Sep 2022 00:23:33 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 4F2371F964;
        Tue,  6 Sep 2022 07:23:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1662449012; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=yWige9mo0MBBtPav5dIlbqrSvO7RJRBpbBUTOf+sq9M=;
        b=WccstuGcN1E1smf3eeXr4m/9pomQg8ST93ACF2vvMP9mGzR6axKEmCztIjBdCY0kE1ePhF
        qp1K5CsZswV66J5NVNekoHzxPlFalOoi6cZRPYDHsBj6ywB2YlS1u9Xkk+KAWE0r4Pl9uD
        W0z/Db1D98aMVW/f++pbHZ2Vb4C25hg=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 2160313A7A;
        Tue,  6 Sep 2022 07:23:32 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id f8r7BnT1FmOCNAAAMHmgww
        (envelope-from <mhocko@suse.com>); Tue, 06 Sep 2022 07:23:32 +0000
Date:   Tue, 6 Sep 2022 09:23:31 +0200
From:   Michal Hocko <mhocko@suse.com>
To:     Kent Overstreet <kent.overstreet@linux.dev>
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
Message-ID: <Yxb1cxDSyte1Ut/F@dhcp22.suse.cz>
References: <20220831101948.f3etturccmp5ovkl@suse.de>
 <Yw88RFuBgc7yFYxA@dhcp22.suse.cz>
 <20220831190154.qdlsxfamans3ya5j@moria.home.lan>
 <YxBc1xuGbB36f8zC@dhcp22.suse.cz>
 <CAJuCfpGhwPFYdkOLjwwD4ra9JxPqq1T5d1jd41Jy3LJnVnhNdg@mail.gmail.com>
 <YxEE1vOwRPdzKxoq@dhcp22.suse.cz>
 <CAJuCfpHuzJGTA_-m0Jfawc7LgJLt4GztUUY4K9N9-7bFqJuXnw@mail.gmail.com>
 <20220901201502.sn6223bayzwferxv@moria.home.lan>
 <YxW4Ig338d2vQAz3@dhcp22.suse.cz>
 <20220905234649.525vorzx27ybypsn@kmo-framework>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220905234649.525vorzx27ybypsn@kmo-framework>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon 05-09-22 19:46:49, Kent Overstreet wrote:
> On Mon, Sep 05, 2022 at 10:49:38AM +0200, Michal Hocko wrote:
> > This is really my main concern about this whole work. Not only it adds a
> > considerable maintenance burden to the core MM because
> 
> [citation needed]

I thought this was clear from the email content (the part you haven't
quoted here). But let me be explicit one more time for you.

I hope we can agree that in order for this kind of tracking to be useful
you need to cover _callers_ of the allocator or in the ideal world
the users/owner of the tracked memory (the later is sometimes much
harder/impossible to track when the memory is handed over from one peer
to another).

It is not particularly useful IMO to see that a large portion of the
memory has been allocated by say vmalloc or kvmalloc, right?  How
much does it really tell you that a lot of memory has been allocated
by kvmalloc or vmalloc? Yet, neither of the two is handled by the
proposed tracking and it would require additional code to be added and
_maintained_ to cover them. But that would be still far from complete,
we have bulk allocator, mempools etc.

If that was not enough some of those allocators are used by library code
like seq_file, networking pools, module loader and whatnot. So this
grows and effectively doubles the API space for many allocators as they
need both normal API and the one which can pass the tracking context
down the path to prevent double tracking. Right?

This in my book is a considerable maintenance burden. And especially for
the MM subsystem this means additional burden because we have a very
rich allocators APIs.

You are absolutely right that processing stack traces is PITA but that
allows to see the actual callers irrespectively how many layers of
indirection or library code it goes.

> > it adds on top of
> > our existing allocator layers complexity but it would need to spread beyond
> > MM to be useful because it is usually outside of MM where leaks happen.
> 
> If you want the tracking to happen at a different level of the call stack, just
> call _kmalloc() directly and call alloc_tag_add()/sub() yourself.

As pointed above this just scales poorly and adds to the API space. Not
to mention that direct use of alloc_tag_add can just confuse layers
below which rely on the same thing.

Hope this makes it clearer.
-- 
Michal Hocko
SUSE Labs
