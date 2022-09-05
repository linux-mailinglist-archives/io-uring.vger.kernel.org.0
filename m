Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 594195ACE0E
	for <lists+io-uring@lfdr.de>; Mon,  5 Sep 2022 10:54:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237764AbiIEItp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 5 Sep 2022 04:49:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238214AbiIEItm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 5 Sep 2022 04:49:42 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA7C7DE93;
        Mon,  5 Sep 2022 01:49:40 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 5BCEA38129;
        Mon,  5 Sep 2022 08:49:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1662367779; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xc3ngfTbFfRO12fCwmaAUkvuolnuXfU1jb4qhmTTa9o=;
        b=naI5Af2DTLvKC4tKL0EBn4HU/6OQwcnrc/MJPo/U5PoHZEMiHEK3C1cS+Jz7y89mgJJnMC
        z4jnqVmLLkQjrc+tpmfFOBAXeR1gseGMvPLn7HvDrPqqcrAwnvNF+LnPu4gXLWFn7NidMW
        POtBx+boR1rnp6IBK7NcOwLS94FYp8I=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 2A198139C7;
        Mon,  5 Sep 2022 08:49:39 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id UM+9CSO4FWMqFwAAMHmgww
        (envelope-from <mhocko@suse.com>); Mon, 05 Sep 2022 08:49:39 +0000
Date:   Mon, 5 Sep 2022 10:49:38 +0200
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
Message-ID: <YxW4Ig338d2vQAz3@dhcp22.suse.cz>
References: <Yw8P8xZ4zqu121xL@hirez.programming.kicks-ass.net>
 <20220831084230.3ti3vitrzhzsu3fs@moria.home.lan>
 <20220831101948.f3etturccmp5ovkl@suse.de>
 <Yw88RFuBgc7yFYxA@dhcp22.suse.cz>
 <20220831190154.qdlsxfamans3ya5j@moria.home.lan>
 <YxBc1xuGbB36f8zC@dhcp22.suse.cz>
 <CAJuCfpGhwPFYdkOLjwwD4ra9JxPqq1T5d1jd41Jy3LJnVnhNdg@mail.gmail.com>
 <YxEE1vOwRPdzKxoq@dhcp22.suse.cz>
 <CAJuCfpHuzJGTA_-m0Jfawc7LgJLt4GztUUY4K9N9-7bFqJuXnw@mail.gmail.com>
 <20220901201502.sn6223bayzwferxv@moria.home.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220901201502.sn6223bayzwferxv@moria.home.lan>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu 01-09-22 16:15:02, Kent Overstreet wrote:
> On Thu, Sep 01, 2022 at 12:39:11PM -0700, Suren Baghdasaryan wrote:
> > kmemleak is known to be slow and it's even documented [1], so I hope I
> > can skip that part. For page_owner to provide the comparable
> > information we would have to capture the call stacks for all page
> > allocations unlike our proposal which allows to do that selectively
> > for specific call sites. I'll post the overhead numbers of call stack
> > capturing once I'm finished with profiling the latest code, hopefully
> > sometime tomorrow, in the worst case after the long weekend.
> 
> To expand on this further: we're stashing a pointer to the alloc_tag, which is
> defined at the allocation callsite. That's how we're able to decrement the
> proper counter on free, and why this beats any tracing based approach - with
> tracing you'd instead have to correlate allocate/free events. Ouch.
> 
> > > Yes, tracking back the call trace would be really needed. The question
> > > is whether this is really prohibitively expensive. How much overhead are
> > > we talking about? There is no free lunch here, really.  You either have
> > > the overhead during runtime when the feature is used or on the source
> > > code level for all the future development (with a maze of macros and
> > > wrappers).
> 
> The full call stack is really not what you want in most applications - that's
> what people think they want at first, and why page_owner works the way it does,
> but it turns out that then combining all the different but related stack traces
> _sucks_ (so why were you saving them in the first place?), and then you have to
> do a separate memory allocate for each stack track, which destroys performance.

I do agree that the full stack trace is likely not what you need. But
the portion of the stack that you need is not really clear because the
relevant part might be on a different level of the calltrace depending
on the allocation site. Take this as an example:
{traverse, seq_read_iter, single_open_size}->seq_buf_alloc -> kvmalloc -> kmalloc

This whole part of the stack is not really all that interesting and you
would have to allocate pretty high at the API layer to catch something
useful. And please remember that seq_file interface is heavily used in
throughout the kernel. I wouldn't suspect seq_file itself to be buggy,
that is well exercised code but its users can botch things and that is
where the leak would happen. There are many other examples like that
where the allocation is done at a lib/infrastructure layer (sysfs
framework, mempools network pool allocators and whatnot). We do care
about those users, really. Ad-hoc pool allocators built on top of the
core MM allocators are not really uncommon. And I am really skeptical we
really want to add all the tagging source code level changes to each and
every one of them.

This is really my main concern about this whole work. Not only it adds a
considerable maintenance burden to the core MM because it adds on top of
our existing allocator layers complexity but it would need to spread beyond
MM to be useful because it is usually outside of MM where leaks happen.
-- 
Michal Hocko
SUSE Labs
