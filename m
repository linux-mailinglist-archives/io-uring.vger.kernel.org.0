Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09A515B156C
	for <lists+io-uring@lfdr.de>; Thu,  8 Sep 2022 09:12:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229911AbiIHHMt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 8 Sep 2022 03:12:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229708AbiIHHMs (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 8 Sep 2022 03:12:48 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C18ED474F;
        Thu,  8 Sep 2022 00:12:47 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id A735433D05;
        Thu,  8 Sep 2022 07:12:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1662621165; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wQxYLHyDLglTrc96Dwo9w9RPNpsCq3XWN1HyAjbRYNs=;
        b=tzO1hqg8Cf+V3DOldPoJ0tAbfrcHQ/buUKHG+8XEIMml22acom6ipoa6KJxfv7pXLWnzPb
        dvicd90Pr+rF+mf7X8aPjxI/j/QR3x9TEVgZ2XHIm66QAHuxOs5AWnjVv3I99n9b6GSa8l
        ClarGp9lNgYGmVJgqD7angv+UmF6LpU=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 7F64713A6D;
        Thu,  8 Sep 2022 07:12:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id Rg4TH+2VGWOnDAAAMHmgww
        (envelope-from <mhocko@suse.com>); Thu, 08 Sep 2022 07:12:45 +0000
Date:   Thu, 8 Sep 2022 09:12:45 +0200
From:   Michal Hocko <mhocko@suse.com>
To:     Kent Overstreet <kent.overstreet@linux.dev>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Suren Baghdasaryan <surenb@google.com>,
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
Message-ID: <YxmV7a2pnj1Kldzi@dhcp22.suse.cz>
References: <CAJuCfpHuzJGTA_-m0Jfawc7LgJLt4GztUUY4K9N9-7bFqJuXnw@mail.gmail.com>
 <20220901201502.sn6223bayzwferxv@moria.home.lan>
 <YxW4Ig338d2vQAz3@dhcp22.suse.cz>
 <20220905234649.525vorzx27ybypsn@kmo-framework>
 <Yxb1cxDSyte1Ut/F@dhcp22.suse.cz>
 <20220906182058.iijmpzu4rtxowy37@kmo-framework>
 <Yxh5ueDTAOcwEmCQ@dhcp22.suse.cz>
 <20220907130323.rwycrntnckc6h43n@kmo-framework>
 <20220907094306.3383dac2@gandalf.local.home>
 <20220908063548.u4lqkhquuvkwzvda@kmo-framework>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220908063548.u4lqkhquuvkwzvda@kmo-framework>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu 08-09-22 02:35:48, Kent Overstreet wrote:
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

Then you have probably missed a huge part of my emails. Please
re-read. If those arguments are not clear, feel free to ask for
clarification. Reducing the whole my reasoning and objections to the
sentence above and calling that vapid and lazy is not only unfair but
also disrespectful.

-- 
Michal Hocko
SUSE Labs
