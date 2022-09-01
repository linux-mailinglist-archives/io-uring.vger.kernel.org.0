Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97EC15A8F0E
	for <lists+io-uring@lfdr.de>; Thu,  1 Sep 2022 09:02:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233425AbiIAHCG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 1 Sep 2022 03:02:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233440AbiIAHBF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 1 Sep 2022 03:01:05 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4940022515;
        Thu,  1 Sep 2022 00:00:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=lP/axgW6wVbLw99T8GY0xIMHkeiyf6aNs2WovZZWBOY=; b=DsovPIHjiTzLDFEHMUZax6kdiz
        YmrmwM4nfhUlXHU6+jwtzeSmRIqJzuk4utR6vlplHXI5NoTsSiI6NPT6mQ1h/o6UlCxpUVBSYBOGF
        mAwUrbTARvU58QmTx2lzLaDbpKSsvApZwYA684cbuuNFGxM7GOsrIGOTXXVvQaBIhlfCdGZ/9loBM
        L3IgWlK3G+key+g2ORNzZ1jfQX4w6GwCWwHdxGrO4bIeb/Qje5accP3+IyavFM2jCZdaLz1F3Z14t
        Fw+hvjFeYcySCXoo9Bh3TdJ8voxVMcJyDg7RBGMnnwLLPADNOXfsqH/S6AwZDXh9BZoWO7rjOM3mx
        f18fOvcQ==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oTeBY-005ocA-Jf; Thu, 01 Sep 2022 07:00:20 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id CF2673004C7;
        Thu,  1 Sep 2022 09:00:17 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id A749520981381; Thu,  1 Sep 2022 09:00:17 +0200 (CEST)
Date:   Thu, 1 Sep 2022 09:00:17 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Mel Gorman <mgorman@suse.de>
Cc:     Kent Overstreet <kent.overstreet@linux.dev>,
        Suren Baghdasaryan <surenb@google.com>,
        akpm@linux-foundation.org, mhocko@suse.com, vbabka@suse.cz,
        hannes@cmpxchg.org, roman.gushchin@linux.dev, dave@stgolabs.net,
        willy@infradead.org, liam.howlett@oracle.com, void@manifault.com,
        juri.lelli@redhat.com, ldufour@linux.ibm.com, peterx@redhat.com,
        david@redhat.com, axboe@kernel.dk, mcgrof@kernel.org,
        masahiroy@kernel.org, nathan@kernel.org, changbin.du@intel.com,
        ytcoode@gmail.com, vincent.guittot@linaro.org,
        dietmar.eggemann@arm.com, rostedt@goodmis.org, bsegall@google.com,
        bristot@redhat.com, vschneid@redhat.com, cl@linux.com,
        penberg@kernel.org, iamjoonsoo.kim@lge.com, 42.hyeyoo@gmail.com,
        glider@google.com, elver@google.com, dvyukov@google.com,
        shakeelb@google.com, songmuchun@bytedance.com, arnd@arndb.de,
        jbaron@akamai.com, rientjes@google.com, minchan@google.com,
        kaleshsingh@google.com, kernel-team@android.com,
        linux-mm@kvack.org, iommu@lists.linux.dev,
        kasan-dev@googlegroups.com, io-uring@vger.kernel.org,
        linux-arch@vger.kernel.org, xen-devel@lists.xenproject.org,
        linux-bcache@vger.kernel.org, linux-modules@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 00/30] Code tagging framework and applications
Message-ID: <YxBYgcyP7IvMLJwq@hirez.programming.kicks-ass.net>
References: <20220830214919.53220-1-surenb@google.com>
 <Yw8P8xZ4zqu121xL@hirez.programming.kicks-ass.net>
 <20220831084230.3ti3vitrzhzsu3fs@moria.home.lan>
 <20220831101948.f3etturccmp5ovkl@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220831101948.f3etturccmp5ovkl@suse.de>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Aug 31, 2022 at 11:19:48AM +0100, Mel Gorman wrote:

> It's also unclear *who* would enable this. It looks like it would mostly
> have value during the development stage of an embedded platform to track
> kernel memory usage on a per-application basis in an environment where it
> may be difficult to setup tracing and tracking. Would it ever be enabled
> in production? 

Afaict this is developer only; it is all unconditional code.

> Would a distribution ever enable this? 

I would sincerely hope not. Because:

> If it's enabled, any overhead cannot be disabled/enabled at run or
> boot time so anyone enabling this would carry the cost without never
> necessarily consuming the data.

this.
