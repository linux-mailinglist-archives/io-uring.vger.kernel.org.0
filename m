Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0647C5A8F6F
	for <lists+io-uring@lfdr.de>; Thu,  1 Sep 2022 09:13:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233454AbiIAHND (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 1 Sep 2022 03:13:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233464AbiIAHM5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 1 Sep 2022 03:12:57 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 410751243C1;
        Thu,  1 Sep 2022 00:11:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=0alPrNIyXUGsDd/lDjKfjoAzSlLEpkpL3yJZZ94RPpk=; b=neTNuYxorlf1E6lqksEri7ob9s
        +fOEKml0dypX1VPsk71Al83+X/wCWVLA2v8MAkyhFFTF2iv7nIDbg8DLeKDx/Rohb0D/WGiowcdyF
        0922P6Ye6aFkRzhuFME6aeUZzKEon4H+p5J4aJUsUfyeUn3pphhfCCpeODAoqUXD8D3vBJsTb3KKg
        i0elKtC2iCCloFyRF8muS9N3Uom/PTE/NlgZ/EuB/5pL3cvoO8AeT2wg/ELDQb4daJgt/gZxAtlcx
        +BB0kImmBciB+hA72jxFiegxOnV9t9ymgmWDAn4pa1ntPYvLXdkppEVbVbS9dT3KZirOXj99594dd
        nqw0a9fg==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oTeMD-005p99-An; Thu, 01 Sep 2022 07:11:21 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id D2B58300431;
        Thu,  1 Sep 2022 09:11:17 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id B51EF20981381; Thu,  1 Sep 2022 09:11:17 +0200 (CEST)
Date:   Thu, 1 Sep 2022 09:11:17 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Suren Baghdasaryan <surenb@google.com>
Cc:     akpm@linux-foundation.org, kent.overstreet@linux.dev,
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
Subject: Re: [RFC PATCH 27/30] Code tagging based latency tracking
Message-ID: <YxBbFUirdlbXDaZA@hirez.programming.kicks-ass.net>
References: <20220830214919.53220-1-surenb@google.com>
 <20220830214919.53220-28-surenb@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220830214919.53220-28-surenb@google.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Aug 30, 2022 at 02:49:16PM -0700, Suren Baghdasaryan wrote:
> From: Kent Overstreet <kent.overstreet@linux.dev>
> 
> This adds the ability to easily instrument code for measuring latency.
> To use, add the following to calls to your code, at the start and end of
> the event you wish to measure:
> 
>   code_tag_time_stats_start(start_time);
>   code_tag_time_stats_finish(start_time);
> 
> Stastistics will then show up in debugfs under
> /sys/kernel/debug/time_stats, listed by file and line number.
> 
> Stastics measured include weighted averages of frequency, duration, max
> duration, as well as quantiles.
> 
> This patch also instruments all calls to init_wait and finish_wait,
> which includes all calls to wait_event. Example debugfs output:

How can't you do this with a simple eBPF script on top of
trace_sched_stat_* and friends?
