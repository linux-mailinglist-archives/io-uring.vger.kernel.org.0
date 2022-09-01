Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E2C95A9FAF
	for <lists+io-uring@lfdr.de>; Thu,  1 Sep 2022 21:15:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233404AbiIATPo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 1 Sep 2022 15:15:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232887AbiIATPl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 1 Sep 2022 15:15:41 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E23216565E;
        Thu,  1 Sep 2022 12:15:39 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 164EB33749;
        Thu,  1 Sep 2022 19:15:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1662059738; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZXQSRqer3+FtfHBMGJ4s/SGRUTOoWiBwBxr7NnCmrIE=;
        b=HIwU2YpwnrE5NOlkMJL4ArkkguYGM6Uuv9mVzuDeMrV+CL1O1JAjH2PyiZhwzHs5d6Wd1L
        EizrfQTDfPcrC+OaDzCXbjkbXhZ3LjWuJBCYcYu92bDTSWDpbgxXjkuDAaz/tyPrX55oN0
        b8fl7WeD5/bzHreO5sHpMhB/5J3nk9g=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id E01CE13A79;
        Thu,  1 Sep 2022 19:15:37 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id fSsfNtkEEWNbVwAAMHmgww
        (envelope-from <mhocko@suse.com>); Thu, 01 Sep 2022 19:15:37 +0000
Date:   Thu, 1 Sep 2022 21:15:34 +0200
From:   Michal Hocko <mhocko@suse.com>
To:     Suren Baghdasaryan <surenb@google.com>
Cc:     Kent Overstreet <kent.overstreet@linux.dev>,
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
Subject: Re: [RFC PATCH 00/30] Code tagging framework and applications
Message-ID: <YxEE1vOwRPdzKxoq@dhcp22.suse.cz>
References: <20220830214919.53220-1-surenb@google.com>
 <Yw8P8xZ4zqu121xL@hirez.programming.kicks-ass.net>
 <20220831084230.3ti3vitrzhzsu3fs@moria.home.lan>
 <20220831101948.f3etturccmp5ovkl@suse.de>
 <Yw88RFuBgc7yFYxA@dhcp22.suse.cz>
 <20220831190154.qdlsxfamans3ya5j@moria.home.lan>
 <YxBc1xuGbB36f8zC@dhcp22.suse.cz>
 <CAJuCfpGhwPFYdkOLjwwD4ra9JxPqq1T5d1jd41Jy3LJnVnhNdg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJuCfpGhwPFYdkOLjwwD4ra9JxPqq1T5d1jd41Jy3LJnVnhNdg@mail.gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu 01-09-22 08:33:19, Suren Baghdasaryan wrote:
> On Thu, Sep 1, 2022 at 12:18 AM Michal Hocko <mhocko@suse.com> wrote:
[...]
> > So I find Peter's question completely appropriate while your response to
> > that not so much! Maybe ftrace is not the right tool for the intented
> > job. Maybe there are other ways and it would be really great to show
> > that those have been evaluated and they are not suitable for a), b) and
> > c) reasons.
> 
> That's fair.
> For memory tracking I looked into using kmemleak and page_owner which
> can't match the required functionality at an overhead acceptable for
> production and pre-production testing environments.

Being more specific would be really helpful. Especially when your cover
letter suggests that you rely on page_owner/memcg metadata as well to
match allocation and their freeing parts.

> traces + BPF I
> haven't evaluated myself but heard from other members of my team who
> tried using that in production environment with poor results. I'll try
> to get more specific information on that.

That would be helpful as well.

> > E.g. Oscar has been working on extending page_ext to track number of
> > allocations for specific calltrace[1]. Is this 1:1 replacement? No! But
> > it can help in environments where page_ext can be enabled and it is
> > completely non-intrusive to the MM code.
> 
> Thanks for pointing out this work. I'll need to review and maybe
> profile it before making any claims.
> 
> >
> > If the page_ext overhead is not desirable/acceptable then I am sure
> > there are other options. E.g. kprobes/LivePatching framework can hook
> > into functions and alter their behavior. So why not use that for data
> > collection? Has this been evaluated at all?
> 
> I'm not sure how I can hook into say alloc_pages() to find out where
> it was called from without capturing the call stack (which would
> introduce an overhead at every allocation). Would love to discuss this
> or other alternatives if they can be done with low enough overhead.

Yes, tracking back the call trace would be really needed. The question
is whether this is really prohibitively expensive. How much overhead are
we talking about? There is no free lunch here, really.  You either have
the overhead during runtime when the feature is used or on the source
code level for all the future development (with a maze of macros and
wrappers).

Thanks!
-- 
Michal Hocko
SUSE Labs
