Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 456BF5A9D27
	for <lists+io-uring@lfdr.de>; Thu,  1 Sep 2022 18:32:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234634AbiIAQcH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 1 Sep 2022 12:32:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232156AbiIAQcG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 1 Sep 2022 12:32:06 -0400
Received: from out1.migadu.com (out1.migadu.com [IPv6:2001:41d0:2:863f::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC2D183F13;
        Thu,  1 Sep 2022 09:32:04 -0700 (PDT)
Date:   Thu, 1 Sep 2022 12:31:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1662049922;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lF0nzK0I3dkKY+VmvooE06KpjT5GF7za7apoY2ziCzA=;
        b=b+mGQz7e+S8nXflcP/Umq6k8mCFjCcajhS+oAKrOSAu3dWGCTZFUhafPBFCwtky43SVO1A
        9liE+TRIsb/HqXx3Llx9NtT4cCnU5G225wc5/aVXkK7HBe0kN/DeWe/oPRR6yMuknOrEyX
        Th1UnEJvMcgJF/T8At8EC/TVB4d1otU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     Mel Gorman <mgorman@suse.de>
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
Message-ID: <20220901163155.sz4dqtubicdvzmsw@moria.home.lan>
References: <20220830214919.53220-1-surenb@google.com>
 <Yw8P8xZ4zqu121xL@hirez.programming.kicks-ass.net>
 <20220831084230.3ti3vitrzhzsu3fs@moria.home.lan>
 <20220831101948.f3etturccmp5ovkl@suse.de>
 <20220831155941.q5umplytbx6offku@moria.home.lan>
 <20220901110501.o5rq5yzltomirxiw@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220901110501.o5rq5yzltomirxiw@suse.de>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Sep 01, 2022 at 12:05:01PM +0100, Mel Gorman wrote:
> As pointed out elsewhere, attaching to the tracepoint and recording relevant
> state is an option other than trying to parse a raw ftrace feed. For memory
> leaks, there are already tracepoints for page allocation and free that could
> be used to track allocations that are not freed at a given point in time.

Page allocation tracepoints are not sufficient for what we're trying to do here,
and a substantial amount of effort in this patchset has gone into just getting
the hooking locations right - our memory allocation interfaces are not trivial.

That's something people should keep in mind when commenting on the size of this
patchset, since that's effort that would have to be spent for /any/ complete
solution, be in tracepoint based or no.

Additionally, we need to be able to write assertions that verify that our hook
locations are correct, that allocations or frees aren't getting double counted
or missed - highly necessary given the maze of nested memory allocation
interfaces we have (i.e. slab.h), and it's something a tracepoint based
implementation would have to account for - otherwise, a tool isn't very useful
if you can't trust the numbers it's giving you.

And then you have to correlate the allocate and free events, so that you know
which allocate callsite to decrement the amount freed from.

How would you plan on doing that with tracepoints?

> There is also the kernel memory leak detector although I never had reason
> to use it (https://www.kernel.org/doc/html/v6.0-rc3/dev-tools/kmemleak.html)
> and it sounds like it would be expensive.

Kmemleak is indeed expensive, and in the past I've had issues with it not
catching everything (I've noticed the kmemleak annotations growing, so maybe
this is less of an issue than it was).

And this is a more complete solution (though not something that could strictly
replace kmemleak): strict memory leaks aren't the only issue, it's also drivers
unexpectedly consuming more memory than expected.

I'll bet you a beer that when people have had this awhile, we're going to have a
bunch of bugs discovered and fixed along the lines of "oh hey, this driver
wasn't supposed to be using this 1 MB of memory, I never noticed that before".

> > > It's also unclear *who* would enable this. It looks like it would mostly
> > > have value during the development stage of an embedded platform to track
> > > kernel memory usage on a per-application basis in an environment where it
> > > may be difficult to setup tracing and tracking. Would it ever be enabled
> > > in production? Would a distribution ever enable this? If it's enabled, any
> > > overhead cannot be disabled/enabled at run or boot time so anyone enabling
> > > this would carry the cost without never necessarily consuming the data.
> > 
> > The whole point of this is to be cheap enough to enable in production -
> > especially the latency tracing infrastructure. There's a lot of value to
> > always-on system visibility infrastructure, so that when a live machine starts
> > to do something wonky the data is already there.
> > 
> 
> Sure, there is value but nothing stops the tracepoints being attached as
> a boot-time service where interested. For latencies, there is already
> bpf examples for tracing individual function latency over time e.g.
> https://github.com/iovisor/bcc/blob/master/tools/funclatency.py although
> I haven't used it recently.

So this is cool, I'll check it out today.

Tracing of /function/ latency is definitely something you'd want tracing/kprobes
for - that's way more practical than any code tagging-based approach. And if the
output is reliable and useful I could definitely see myself using this, thank
you.

But for data collection where it makes sense to annotate in the source code
where the data collection points are, I see the code-tagging based approach as
simpler - it cuts out a whole bunch of indirection. The diffstat on the code
tagging time stats patch is

 8 files changed, 233 insertions(+), 6 deletions(-)

And that includes hooking wait.h - this is really simple, easy stuff.

The memory allocation tracking patches are more complicated because we've got a
ton of memory allocation interfaces and we're aiming for strict correctness
there - because that tool needs strict correctness in order to be useful.

> Live parsing of ftrace is possible, albeit expensive.
> https://github.com/gormanm/mmtests/blob/master/monitors/watch-highorder.pl
> tracks counts of high-order allocations and dumps a report on interrupt as
> an example of live parsing ftrace and only recording interesting state. It's
> not tracking state you are interested in but it demonstrates it is possible
> to rely on ftrace alone and monitor from userspace. It's bit-rotted but
> can be fixed with

Yeah, if this is as far as people have gotten with ftrace on memory allocations
than I don't think tracing is credible here, sorry.

> The ease of use is a criticism as there is effort required to develop
> the state tracking of in-kernel event be it from live parsing ftrace,
> attaching to tracepoints with systemtap/bpf/whatever and the like. The
> main disadvantage with an in-kernel implementation is three-fold. First,
> it doesn't work with older kernels without backports. Second, if something
> slightly different it needed then it's a kernel rebuild.  Third, if the
> option is not enabled in the deployed kernel config then you are relying
> on the end user being willing to deploy a custom kernel.  The initial
> investment in doing memory leak tracking or latency tracking by attaching
> to tracepoints is significant but it works with older kernels up to a point
> and is less sensitive to the kernel config options selected as features
> like ftrace are often selected.

The next version of this patch set is going to use the alternatives mechanism to
add a boot parameter.

I'm not interested in backporting to older kernels - eesh. People on old
enterprise kernels don't always get all the new shiny things :)
