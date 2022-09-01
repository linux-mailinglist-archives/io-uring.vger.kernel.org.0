Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53E965A955B
	for <lists+io-uring@lfdr.de>; Thu,  1 Sep 2022 13:05:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233484AbiIALFT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 1 Sep 2022 07:05:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233114AbiIALFS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 1 Sep 2022 07:05:18 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFEE0286EF;
        Thu,  1 Sep 2022 04:05:13 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 0601C22679;
        Thu,  1 Sep 2022 11:05:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1662030312; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8Mq+Xr0OI+bfUf9L9MD4E1lYUlcZgNZF3vEeJl7iivY=;
        b=qxrx6Job1q9NhDr8jWgNkmZI/DIOO/4e7B7RmUvgkYmx7g2HD/fgMwo5Yk3h0VlLoTt148
        XYp7yip2SBIiuI+n/MfaQLawKmE1HR8l9pazuynzZByPC2unjCGeYASa4WYFvbNUExE7dA
        7MiaajpJfHroyIAEi/eiNxfkWvr+0Tc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1662030312;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8Mq+Xr0OI+bfUf9L9MD4E1lYUlcZgNZF3vEeJl7iivY=;
        b=aI8rpCPzOEsCk4iUnJ8AJ2D/wDZBIW/Yuzt0mzTQGVVpTTlaSfJwPqq4wfJerDAgBO140w
        J3d/FttUmGmZwoAQ==
Received: from suse.de (unknown [10.163.43.106])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 314B12C142;
        Thu,  1 Sep 2022 11:05:08 +0000 (UTC)
Date:   Thu, 1 Sep 2022 12:05:01 +0100
From:   Mel Gorman <mgorman@suse.de>
To:     Kent Overstreet <kent.overstreet@linux.dev>
Cc:     Peter Zijlstra <peterz@infradead.org>,
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
Message-ID: <20220901110501.o5rq5yzltomirxiw@suse.de>
References: <20220830214919.53220-1-surenb@google.com>
 <Yw8P8xZ4zqu121xL@hirez.programming.kicks-ass.net>
 <20220831084230.3ti3vitrzhzsu3fs@moria.home.lan>
 <20220831101948.f3etturccmp5ovkl@suse.de>
 <20220831155941.q5umplytbx6offku@moria.home.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20220831155941.q5umplytbx6offku@moria.home.lan>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Aug 31, 2022 at 11:59:41AM -0400, Kent Overstreet wrote:
> On Wed, Aug 31, 2022 at 11:19:48AM +0100, Mel Gorman wrote:
> > On Wed, Aug 31, 2022 at 04:42:30AM -0400, Kent Overstreet wrote:
> > > On Wed, Aug 31, 2022 at 09:38:27AM +0200, Peter Zijlstra wrote:
> > > > On Tue, Aug 30, 2022 at 02:48:49PM -0700, Suren Baghdasaryan wrote:
> > > > > ===========================
> > > > > Code tagging framework
> > > > > ===========================
> > > > > Code tag is a structure identifying a specific location in the source code
> > > > > which is generated at compile time and can be embedded in an application-
> > > > > specific structure. Several applications of code tagging are included in
> > > > > this RFC, such as memory allocation tracking, dynamic fault injection,
> > > > > latency tracking and improved error code reporting.
> > > > > Basically, it takes the old trick of "define a special elf section for
> > > > > objects of a given type so that we can iterate over them at runtime" and
> > > > > creates a proper library for it.
> > > > 
> > > > I might be super dense this morning, but what!? I've skimmed through the
> > > > set and I don't think I get it.
> > > > 
> > > > What does this provide that ftrace/kprobes don't already allow?
> > > 
> > > You're kidding, right?
> > 
> > It's a valid question. From the description, it main addition that would
> > be hard to do with ftrace or probes is catching where an error code is
> > returned. A secondary addition would be catching all historical state and
> > not just state since the tracing started.
> 
> Catching all historical state is pretty important in the case of memory
> allocation accounting, don't you think?
> 

Not always. If the intent is to catch a memory leak that gets worse over
time, early boot should be sufficient. Sure, there might be drivers that leak
memory allocated at init but if it's not a growing leak, it doesn't matter.

> Also, ftrace can drop events. Not really ideal if under system load your memory
> accounting numbers start to drift.
> 

As pointed out elsewhere, attaching to the tracepoint and recording relevant
state is an option other than trying to parse a raw ftrace feed. For memory
leaks, there are already tracepoints for page allocation and free that could
be used to track allocations that are not freed at a given point in time.
There is also the kernel memory leak detector although I never had reason
to use it (https://www.kernel.org/doc/html/v6.0-rc3/dev-tools/kmemleak.html)
and it sounds like it would be expensive.

> > It's also unclear *who* would enable this. It looks like it would mostly
> > have value during the development stage of an embedded platform to track
> > kernel memory usage on a per-application basis in an environment where it
> > may be difficult to setup tracing and tracking. Would it ever be enabled
> > in production? Would a distribution ever enable this? If it's enabled, any
> > overhead cannot be disabled/enabled at run or boot time so anyone enabling
> > this would carry the cost without never necessarily consuming the data.
> 
> The whole point of this is to be cheap enough to enable in production -
> especially the latency tracing infrastructure. There's a lot of value to
> always-on system visibility infrastructure, so that when a live machine starts
> to do something wonky the data is already there.
> 

Sure, there is value but nothing stops the tracepoints being attached as
a boot-time service where interested. For latencies, there is already
bpf examples for tracing individual function latency over time e.g.
https://github.com/iovisor/bcc/blob/master/tools/funclatency.py although
I haven't used it recently.

Live parsing of ftrace is possible, albeit expensive.
https://github.com/gormanm/mmtests/blob/master/monitors/watch-highorder.pl
tracks counts of high-order allocations and dumps a report on interrupt as
an example of live parsing ftrace and only recording interesting state. It's
not tracking state you are interested in but it demonstrates it is possible
to rely on ftrace alone and monitor from userspace. It's bit-rotted but
can be fixed with

diff --git a/monitors/watch-highorder.pl b/monitors/watch-highorder.pl
index 8c80ae79e556..fd0d477427df 100755
--- a/monitors/watch-highorder.pl
+++ b/monitors/watch-highorder.pl
@@ -52,7 +52,7 @@ my $regex_pagealloc;
 
 # Static regex used. Specified like this for readability and for use with /o
 #                      (process_pid)     (cpus      )   ( time  )   (tpoint    ) (details)
-my $regex_traceevent = '\s*([a-zA-Z0-9-]*)\s*(\[[0-9]*\])\s*([0-9.]*):\s*([a-zA-Z_]*):\s*(.*)';
+my $regex_traceevent = '\s*([a-zA-Z0-9-]*)\s*(\[[0-9]*\])\s*([0-9. ]*):\s*([a-zA-Z_]*):\s*(.*)';
 my $regex_statname = '[-0-9]*\s\((.*)\).*';
 my $regex_statppid = '[-0-9]*\s\(.*\)\s[A-Za-z]\s([0-9]*).*';
 
@@ -73,6 +73,7 @@ sub generate_traceevent_regex {
 				$regex =~ s/%p/\([0-9a-f]*\)/g;
 				$regex =~ s/%d/\([-0-9]*\)/g;
 				$regex =~ s/%lu/\([0-9]*\)/g;
+				$regex =~ s/%lx/\([0-9a-zA-Z]*\)/g;
 				$regex =~ s/%s/\([A-Z_|]*\)/g;
 				$regex =~ s/\(REC->gfp_flags\).*/REC->gfp_flags/;
 				$regex =~ s/\",.*//;

Example output

3 instances order=2 normal gfp_flags=GFP_KERNEL|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_ZERO
 => trace_event_raw_event_mm_page_alloc+0x7d/0xc0 <ffffffffb1caeccd>
 => __alloc_pages+0x188/0x250 <ffffffffb1cee8a8>
 => kmalloc_large_node+0x3f/0x80 <ffffffffb1d1cd3f>
 => __kmalloc_node+0x321/0x420 <ffffffffb1d22351>
 => kvmalloc_node+0x46/0xe0 <ffffffffb1ca4906>
 => ttm_sg_tt_init+0x88/0xb0 [ttm] <ffffffffc03a02c8>
 => amdgpu_ttm_tt_create+0x4f/0x80 [amdgpu] <ffffffffc04cff0f>
 => ttm_tt_create+0x59/0x90 [ttm] <ffffffffc03a03b9>
 => ttm_bo_handle_move_mem+0x7e/0x1c0 [ttm] <ffffffffc03a0d9e>
 => ttm_bo_validate+0xc5/0x140 [ttm] <ffffffffc03a2095>
 => ttm_bo_init_reserved+0x17b/0x200 [ttm] <ffffffffc03a228b>
 => amdgpu_bo_create+0x1a3/0x470 [amdgpu] <ffffffffc04d36c3>
 => amdgpu_bo_create_user+0x34/0x60 [amdgpu] <ffffffffc04d39c4>
 => amdgpu_gem_create_ioctl+0x131/0x3a0 [amdgpu] <ffffffffc04d94f1>
 => drm_ioctl_kernel+0xb5/0x140 <ffffffffb21652c5>
 => drm_ioctl+0x224/0x3e0 <ffffffffb2165574>
 => amdgpu_drm_ioctl+0x49/0x80 [amdgpu] <ffffffffc04bd2d9>
 => __x64_sys_ioctl+0x8a/0xc0 <ffffffffb1d7c2da>
 => do_syscall_64+0x5c/0x90 <ffffffffb253016c>
 => entry_SYSCALL_64_after_hwframe+0x63/0xcd <ffffffffb260009b>

3 instances order=1 normal gfp_flags=GFP_NOWAIT|__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_COMP|__GFP_ACCOUNT
 => trace_event_raw_event_mm_page_alloc+0x7d/0xc0 <ffffffffb1caeccd>
 => __alloc_pages+0x188/0x250 <ffffffffb1cee8a8>
 => __folio_alloc+0x17/0x50 <ffffffffb1cef1a7>
 => vma_alloc_folio+0x8f/0x350 <ffffffffb1d11e4f>
 => __handle_mm_fault+0xa1e/0x1120 <ffffffffb1cc80ee>
 => handle_mm_fault+0xb2/0x280 <ffffffffb1cc88a2>
 => do_user_addr_fault+0x1b9/0x690 <ffffffffb1a89949>
 => exc_page_fault+0x67/0x150 <ffffffffb2534627>
 => asm_exc_page_fault+0x22/0x30 <ffffffffb2600b62>

It's not tracking leaks because that is not what I was intrested in at
the time but could using the same method and recording PFNs that were
allocated, their call site but not freed. These days, this approach may
be a bit unexpected but it was originally written 13 years ago. It could
have been done with systemtap back then but my recollection was that it
was difficult to keep systemtap working with rc kernels.

> What we've built here this is _far_ cheaper than anything that could be done
> with ftrace.
> 
> > It might be an ease-of-use thing. Gathering the information from traces
> > is tricky and would need combining multiple different elements and that
> > is development effort but not impossible.
> > 
> > Whatever asking for an explanation as to why equivalent functionality
> > cannot not be created from ftrace/kprobe/eBPF/whatever is reasonable.
> 
> I think perhaps some of the expectation should be on the "ftrace for
> everything!" people to explain a: how their alternative could be even built and
> b: how it would compare in terms of performance and ease of use.
> 

The ease of use is a criticism as there is effort required to develop
the state tracking of in-kernel event be it from live parsing ftrace,
attaching to tracepoints with systemtap/bpf/whatever and the like. The
main disadvantage with an in-kernel implementation is three-fold. First,
it doesn't work with older kernels without backports. Second, if something
slightly different it needed then it's a kernel rebuild.  Third, if the
option is not enabled in the deployed kernel config then you are relying
on the end user being willing to deploy a custom kernel.  The initial
investment in doing memory leak tracking or latency tracking by attaching
to tracepoints is significant but it works with older kernels up to a point
and is less sensitive to the kernel config options selected as features
like ftrace are often selected.

-- 
Mel Gorman
SUSE Labs
