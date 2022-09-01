Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 549925AA19B
	for <lists+io-uring@lfdr.de>; Thu,  1 Sep 2022 23:46:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229584AbiIAVqR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 1 Sep 2022 17:46:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231304AbiIAVqP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 1 Sep 2022 17:46:15 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4AA96113F;
        Thu,  1 Sep 2022 14:46:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 01DCFCE2600;
        Thu,  1 Sep 2022 21:46:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58693C433C1;
        Thu,  1 Sep 2022 21:45:56 +0000 (UTC)
Date:   Thu, 1 Sep 2022 17:46:27 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
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
        bsegall@google.com, bristot@redhat.com, vschneid@redhat.com,
        cl@linux.com, penberg@kernel.org, iamjoonsoo.kim@lge.com,
        42.hyeyoo@gmail.com, glider@google.com, elver@google.com,
        dvyukov@google.com, shakeelb@google.com, songmuchun@bytedance.com,
        arnd@arndb.de, jbaron@akamai.com, rientjes@google.com,
        minchan@google.com, kaleshsingh@google.com,
        kernel-team@android.com, linux-mm@kvack.org, iommu@lists.linux.dev,
        kasan-dev@googlegroups.com, io-uring@vger.kernel.org,
        linux-arch@vger.kernel.org, xen-devel@lists.xenproject.org,
        linux-bcache@vger.kernel.org, linux-modules@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 27/30] Code tagging based latency tracking
Message-ID: <20220901174627.27c7e23d@gandalf.local.home>
In-Reply-To: <20220901173844.36e1683c@gandalf.local.home>
References: <20220830214919.53220-1-surenb@google.com>
        <20220830214919.53220-28-surenb@google.com>
        <20220901173844.36e1683c@gandalf.local.home>
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

On Thu, 1 Sep 2022 17:38:44 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

>  # echo 'hist:keys=comm,prio,delta.buckets=10:sort=delta' > /sys/kernel/tracing/events/synthetic/wakeup_lat/trigger

The above could almost be done with sqlhist (but I haven't implemented
"buckets=10" yet because that's a new feature. But for now, let's do log2):

 # sqlhist -e 'select comm,prio,cast(delta as log2) from wakeup_lat'

("-e" is to execute the command, as it normally only displays what commands
need to be run to create the synthetic events and histograms)

# cat /sys/kernel/tracing/events/synthetic/wakeup_lat/hist
# event histogram
#
# trigger info: hist:keys=comm,prio,delta.log2:vals=hitcount:sort=hitcount:size=2048 [active]
#

{ comm: migration/4                                       , prio:          0, delta: ~ 2^5  } hitcount:          1
{ comm: migration/0                                       , prio:          0, delta: ~ 2^4  } hitcount:          2
{ comm: rtkit-daemon                                      , prio:          0, delta: ~ 2^7  } hitcount:          2
{ comm: rtkit-daemon                                      , prio:          0, delta: ~ 2^6  } hitcount:          4
{ comm: migration/0                                       , prio:          0, delta: ~ 2^5  } hitcount:          8
{ comm: migration/4                                       , prio:          0, delta: ~ 2^4  } hitcount:          9
{ comm: migration/2                                       , prio:          0, delta: ~ 2^4  } hitcount:         10
{ comm: migration/5                                       , prio:          0, delta: ~ 2^4  } hitcount:         10
{ comm: migration/7                                       , prio:          0, delta: ~ 2^4  } hitcount:         10
{ comm: migration/1                                       , prio:          0, delta: ~ 2^4  } hitcount:         10
{ comm: migration/6                                       , prio:          0, delta: ~ 2^4  } hitcount:         10

Totals:
    Hits: 76
    Entries: 11
    Dropped: 0


-- Steve
