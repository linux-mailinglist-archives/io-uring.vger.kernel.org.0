Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 430D35A8CF5
	for <lists+io-uring@lfdr.de>; Thu,  1 Sep 2022 06:53:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232666AbiIAExB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 1 Sep 2022 00:53:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232635AbiIAEw7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 1 Sep 2022 00:52:59 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A7D0114C6E;
        Wed, 31 Aug 2022 21:52:59 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 4811C221FE;
        Thu,  1 Sep 2022 04:52:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1662007977; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=eTDe59i5UNhXbLPqqFo4WrMbXbqRlxGLfSkkAQ8Fk/c=;
        b=MXuVo2yVstAVCBS1varMecEXswz7FuXIDAQoWezwenAAYl9Y3PpRhbQ5He3NmYqXLh+xPX
        jn8EotqxdKlpoHsOLAGA9/hldaOwN5qgNQ9dGNBfKhsAkMyZOy8dG2wdiqd/dEPEUn2GH3
        2GWaydR4UCkectkbjmLF+pOVJTedvZg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1662007977;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=eTDe59i5UNhXbLPqqFo4WrMbXbqRlxGLfSkkAQ8Fk/c=;
        b=g2uWhOe8Agl2O5OiQ5uOLDZi7V4xateLoucVNLb1+2O63J77RwR9Dmx9Wxfg3YF3VCD9bc
        vcZMMEi8r2KuRXCg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 67DE3139C4;
        Thu,  1 Sep 2022 04:52:54 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id E7aqFqY6EGPsewAAMHmgww
        (envelope-from <osalvador@suse.de>); Thu, 01 Sep 2022 04:52:54 +0000
Date:   Thu, 1 Sep 2022 06:52:52 +0200
From:   Oscar Salvador <osalvador@suse.de>
To:     Suren Baghdasaryan <surenb@google.com>
Cc:     akpm@linux-foundation.org, kent.overstreet@linux.dev,
        mhocko@suse.com, vbabka@suse.cz, hannes@cmpxchg.org,
        roman.gushchin@linux.dev, mgorman@suse.de, dave@stgolabs.net,
        willy@infradead.org, liam.howlett@oracle.com, void@manifault.com,
        peterz@infradead.org, juri.lelli@redhat.com, ldufour@linux.ibm.com,
        peterx@redhat.com, david@redhat.com, axboe@kernel.dk,
        mcgrof@kernel.org, masahiroy@kernel.org, nathan@kernel.org,
        changbin.du@intel.com, ytcoode@gmail.com,
        vincent.guittot@linaro.org, dietmar.eggemann@arm.com,
        rostedt@goodmis.org, bsegall@google.com, bristot@redhat.com,
        vschneid@redhat.com, cl@linux.com, penberg@kernel.org,
        iamjoonsoo.kim@lge.com, 42.hyeyoo@gmail.com, glider@google.com,
        elver@google.com, dvyukov@google.com, shakeelb@google.com,
        songmuchun@bytedance.com, arnd@arndb.de, jbaron@akamai.com,
        rientjes@google.com, minchan@google.com, kaleshsingh@google.com,
        kernel-team@android.com, linux-mm@kvack.org, iommu@lists.linux.dev,
        kasan-dev@googlegroups.com, io-uring@vger.kernel.org,
        linux-arch@vger.kernel.org, xen-devel@lists.xenproject.org,
        linux-bcache@vger.kernel.org, linux-modules@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 00/30] Code tagging framework and applications
Message-ID: <YxA6pCu0YNIiXkHf@localhost.localdomain>
References: <20220830214919.53220-1-surenb@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220830214919.53220-1-surenb@google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Aug 30, 2022 at 02:48:49PM -0700, Suren Baghdasaryan wrote:
> ===========================
> Code tagging framework
> ===========================
> Code tag is a structure identifying a specific location in the source code
> which is generated at compile time and can be embedded in an application-
> specific structure. Several applications of code tagging are included in
> this RFC, such as memory allocation tracking, dynamic fault injection,
> latency tracking and improved error code reporting.
> Basically, it takes the old trick of "define a special elf section for
> objects of a given type so that we can iterate over them at runtime" and
> creates a proper library for it.
> 
> ===========================
> Memory allocation tracking
> ===========================
> The goal for using codetags for memory allocation tracking is to minimize
> performance and memory overhead. By recording only the call count and
> allocation size, the required operations are kept at the minimum while
> collecting statistics for every allocation in the codebase. With that
> information, if users are interested in mode detailed context for a
> specific allocation, they can enable more in-depth context tracking,
> which includes capturing the pid, tgid, task name, allocation size,
> timestamp and call stack for every allocation at the specified code
> location.
> Memory allocation tracking is implemented in two parts:
> 
> part1: instruments page and slab allocators to record call count and total
> memory allocated at every allocation in the source code. Every time an
> allocation is performed by an instrumented allocator, the codetag at that
> location increments its call and size counters. Every time the memory is
> freed these counters are decremented. To decrement the counters upon free,
> allocated object needs a reference to its codetag. Page allocators use
> page_ext to record this reference while slab allocators use memcg_data of
> the slab page.
> The data is exposed to the user space via a read-only debugfs file called
> alloc_tags.

Hi Suren,

I just posted a patch [1] and reading through your changelog and seeing your PoC,
I think we have some kind of overlap.
My patchset aims to give you the stacktrace <-> relationship information and it is
achieved by a little amount of extra code mostly in page_owner.c/ and lib/stackdepot.

Of course, your works seems to be more complete wrt. the information you get.

I CCed you in case you want to have a look

[1] https://lkml.org/lkml/2022/9/1/36

Thanks


-- 
Oscar Salvador
SUSE Labs
