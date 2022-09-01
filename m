Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C0CD5A9F82
	for <lists+io-uring@lfdr.de>; Thu,  1 Sep 2022 21:00:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232418AbiIATAT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 1 Sep 2022 15:00:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231281AbiIATAP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 1 Sep 2022 15:00:15 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEF5D1AF20;
        Thu,  1 Sep 2022 12:00:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=qo1Y7wjVRM1IPrvgDfwSP6kiSpx5CHm6THH/U/nXDvQ=; b=Cn40tdhd1E1TwjC2GqnrK/VMBS
        bok5IW5dPqC9b0Puyc5kB0GIPwBvnyb6nAzkLqRz8cvGe+hZxxiWfH5MRjXqCuiD8wRV3vAuxJP+J
        rBin1pHHm0PdKxLBfMtFhMb+NWLGsCy4r7eBzhOiR3RJwsipcHoCKo1LbfkIAxXUeO3hEsfIiXhrq
        k8QoRcUNeRFsus+I7Ba6wWsVhV63eeopBg9ahpU9S/Ox/FDoVHSGM37kZ29behPJVXZzWay4XLu5T
        q0+gdXxrW0zeerMoRET2yGibvMP6RcQg1rpJRDmnkL9WKUV+AjGLfBnI/ialwweB0bUk0PRwtZdkh
        fjN9qgsg==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oTpPP-008Swy-VE; Thu, 01 Sep 2022 18:59:24 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 8F5993002C7;
        Thu,  1 Sep 2022 20:59:20 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 729172B8B840F; Thu,  1 Sep 2022 20:59:20 +0200 (CEST)
Date:   Thu, 1 Sep 2022 20:59:20 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Kent Overstreet <kent.overstreet@linux.dev>
Cc:     Suren Baghdasaryan <surenb@google.com>, akpm@linux-foundation.org,
        mhocko@suse.com, vbabka@suse.cz, hannes@cmpxchg.org,
        roman.gushchin@linux.dev, mgorman@suse.de, dave@stgolabs.net,
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
Subject: Re: [RFC PATCH 03/30] Lazy percpu counters
Message-ID: <YxEBCCA4qaMbbKYA@hirez.programming.kicks-ass.net>
References: <20220830214919.53220-1-surenb@google.com>
 <20220830214919.53220-4-surenb@google.com>
 <YxBWczNCbZbj+reQ@hirez.programming.kicks-ass.net>
 <20220901143219.n7jg7cbp47agqnwn@moria.home.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220901143219.n7jg7cbp47agqnwn@moria.home.lan>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Sep 01, 2022 at 10:32:19AM -0400, Kent Overstreet wrote:
> On Thu, Sep 01, 2022 at 08:51:31AM +0200, Peter Zijlstra wrote:
> > On Tue, Aug 30, 2022 at 02:48:52PM -0700, Suren Baghdasaryan wrote:
> > > +static void lazy_percpu_counter_switch_to_pcpu(struct raw_lazy_percpu_counter *c)
> > > +{
> > > +	u64 __percpu *pcpu_v = alloc_percpu_gfp(u64, GFP_ATOMIC|__GFP_NOWARN);
> > 
> > Realize that this is incorrect when used under a raw_spinlock_t.
> 
> Can you elaborate?

required lock order: raw_spinlock_t < spinlock_t < mutex

allocators lives at spinlock_t.

Also see CONFIG_PROVE_RAW_LOCK_NESTING and there might be a document
mentioning all this somewhere.

Additionally, this (obviously) also isn't NMI safe.
