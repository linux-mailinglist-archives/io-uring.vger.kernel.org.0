Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02D1E5AA3B2
	for <lists+io-uring@lfdr.de>; Fri,  2 Sep 2022 01:27:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234933AbiIAX05 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 1 Sep 2022 19:26:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233034AbiIAX04 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 1 Sep 2022 19:26:56 -0400
Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56FC758B7E;
        Thu,  1 Sep 2022 16:26:53 -0700 (PDT)
Date:   Thu, 1 Sep 2022 19:26:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1662074812;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ziQwyv6CBY5n7ARW4qu86GPnvQN6geI/tFyfrLXQmYY=;
        b=J6csj5dyhB9n57JXIj/oDTNnfDhtPgzehwGStIMJ1Zca26/ME4gYxeDh8PpO+R5AM1uQtx
        AuGPCBQOLiOURlLPfz0PHN++Qv8oJrHnFRvUJhS53h6Xh9/SgubQ1HLN0ij2EQ6piWu6qx
        RwYFCEhuRCegC1FPS7XpHSMhorTcjrw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     Joe Perches <joe@perches.com>
Cc:     Suren Baghdasaryan <surenb@google.com>, akpm@linux-foundation.org,
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
Subject: Re: [RFC PATCH 28/30] Improved symbolic error names
Message-ID: <20220901232645.4dogffr26oisd7p5@moria.home.lan>
References: <20220830214919.53220-1-surenb@google.com>
 <20220830214919.53220-29-surenb@google.com>
 <c3a6e2d86724efd3ac4b94ca1975e23ddb26cc6f.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c3a6e2d86724efd3ac4b94ca1975e23ddb26cc6f.camel@perches.com>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Sep 01, 2022 at 04:19:35PM -0700, Joe Perches wrote:
> On Tue, 2022-08-30 at 14:49 -0700, Suren Baghdasaryan wrote:
> > From: Kent Overstreet <kent.overstreet@linux.dev>
> > 
> > This patch adds per-error-site error codes, with error strings that
> > include their file and line number.
> > 
> > To use, change code that returns an error, e.g.
> >     return -ENOMEM;
> > to
> >     return -ERR(ENOMEM);
> > 
> > Then, errname() will return a string that includes the file and line
> > number of the ERR() call, for example
> >     printk("Got error %s!\n", errname(err));
> > will result in
> >     Got error ENOMEM at foo.c:1234
> 
> Why? Something wrong with just using %pe ?
> 
> 	printk("Got error %pe at %s:%d!\n", ERR_PTR(err), __FILE__, __LINE__);
> 
> Likely __FILE__ and __LINE__ aren't particularly useful.

That doesn't do what this patchset does. If it only did that, it wouldn't make
much sense, would it? :)

With this patchset,
     printk("Got error %pe!\n", ptr);

prints out a file and line number, but it's _not_ the file/line number of the
printk statement - it's the file/line number where the error originated!

:)
