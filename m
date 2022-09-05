Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EC6C5AD978
	for <lists+io-uring@lfdr.de>; Mon,  5 Sep 2022 21:16:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231887AbiIETQI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 5 Sep 2022 15:16:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229866AbiIETQH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 5 Sep 2022 15:16:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B83EC46202;
        Mon,  5 Sep 2022 12:16:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4B0DC6146C;
        Mon,  5 Sep 2022 19:16:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7168DC433C1;
        Mon,  5 Sep 2022 19:15:56 +0000 (UTC)
Date:   Mon, 5 Sep 2022 15:16:33 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Nadav Amit <nadav.amit@gmail.com>
Cc:     Mel Gorman <mgorman@suse.de>,
        Kent Overstreet <kent.overstreet@linux.dev>,
        Peter Zijlstra <peterz@infradead.org>,
        Suren Baghdasaryan <surenb@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>, roman.gushchin@linux.dev,
        dave@stgolabs.net, Matthew Wilcox <willy@infradead.org>,
        liam.howlett@oracle.com, void@manifault.com, juri.lelli@redhat.com,
        ldufour@linux.ibm.com, Peter Xu <peterx@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, mcgrof@kernel.org,
        masahiroy@kernel.org, nathan@kernel.org, changbin.du@intel.com,
        ytcoode@gmail.com, vincent.guittot@linaro.org,
        dietmar.eggemann@arm.com, bsegall@google.com, bristot@redhat.com,
        vschneid@redhat.com, cl@linux.com, penberg@kernel.org,
        iamjoonsoo.kim@lge.com, 42.hyeyoo@gmail.com, glider@google.com,
        Marco Elver <elver@google.com>, dvyukov@google.com,
        Shakeel Butt <shakeelb@google.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Arnd Bergmann <arnd@arndb.de>, jbaron@akamai.com,
        David Rientjes <rientjes@google.com>, minchan@google.com,
        kaleshsingh@google.com, kernel-team@android.com,
        Linux MM <linux-mm@kvack.org>, iommu@lists.linux.dev,
        kasan-dev@googlegroups.com, io-uring@vger.kernel.org,
        linux-arch <linux-arch@vger.kernel.org>,
        xen-devel@lists.xenproject.org, linux-bcache@vger.kernel.org,
        linux-modules@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 00/30] Code tagging framework and applications
Message-ID: <20220905151633.04081816@gandalf.local.home>
In-Reply-To: <8EB7F2CE-2C8E-47EA-817F-6DE2D95F0A8B@gmail.com>
References: <20220830214919.53220-1-surenb@google.com>
        <Yw8P8xZ4zqu121xL@hirez.programming.kicks-ass.net>
        <20220831084230.3ti3vitrzhzsu3fs@moria.home.lan>
        <20220831101948.f3etturccmp5ovkl@suse.de>
        <8EB7F2CE-2C8E-47EA-817F-6DE2D95F0A8B@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, 5 Sep 2022 11:44:55 -0700
Nadav Amit <nadav.amit@gmail.com> wrote:

> I would note that I have a solution in the making (which pretty much works)
> for this matter, and does not require any kernel changes. It produces a
> call stack that leads to the code that lead to syscall failure.
> 
> The way it works is by using seccomp to trap syscall failures, and then
> setting ftrace function filters and kprobes on conditional branches,
> indirect branch targets and function returns.

Ooh nifty!

> 
> Using symbolic execution, backtracking is performed and the condition that
> lead to the failure is then pin-pointed.
> 
> I hope to share the code soon.

Looking forward to it.

-- Steve
