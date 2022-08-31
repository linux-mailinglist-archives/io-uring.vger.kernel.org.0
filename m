Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D8695A738B
	for <lists+io-uring@lfdr.de>; Wed, 31 Aug 2022 03:52:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230043AbiHaBwk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 30 Aug 2022 21:52:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229723AbiHaBwj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 30 Aug 2022 21:52:39 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF788B02A9;
        Tue, 30 Aug 2022 18:52:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
        Message-ID:Sender:Reply-To:Content-ID:Content-Description;
        bh=/x61W8ECxcYp6VApa7rbgykWRp7/DFT2S0h+uIWuEt0=; b=fE7O2deJ1RanMKunrQ/zfTMOSf
        ifOEdubrRjpQzwW+wZCnCsaWL1H+dWIVEswSHglWXF4cq19WX45jSAEjFPyZFK2LXQ/wijSM7tb6W
        k+uKJo3mowcOZdAppnjeLHiYp6lzcRvVqvUVCdEqW0pqgaFiMUCu5tCvL+up2/ud0wrXHAYStgD5a
        X7gktDpA97ofBU/rvHf3O939oo9TWrRT3CvpoipMffjAPkcPIWHeNYHzqspR3VsERhUOHNzx430Z/
        qd7jFqLKUOEu/+8WZcmicWNgLbhaqj0Z+mtdiwHRaBjVj4sH29gTT/fbGsv85v6mNxd4VsF6MswZB
        9lmrzOIw==;
Received: from [2601:1c0:6280:3f0::a6b3]
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oTCtd-0036Mt-9k; Wed, 31 Aug 2022 01:52:01 +0000
Message-ID: <b252a4e0-57a1-0f27-f4b0-598e851b47ea@infradead.org>
Date:   Tue, 30 Aug 2022 18:51:56 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.1.2
Subject: Re: [RFC PATCH 22/30] Code tagging based fault injection
Content-Language: en-US
To:     Suren Baghdasaryan <surenb@google.com>, akpm@linux-foundation.org
Cc:     kent.overstreet@linux.dev, mhocko@suse.com, vbabka@suse.cz,
        hannes@cmpxchg.org, roman.gushchin@linux.dev, mgorman@suse.de,
        dave@stgolabs.net, willy@infradead.org, liam.howlett@oracle.com,
        void@manifault.com, peterz@infradead.org, juri.lelli@redhat.com,
        ldufour@linux.ibm.com, peterx@redhat.com, david@redhat.com,
        axboe@kernel.dk, mcgrof@kernel.org, masahiroy@kernel.org,
        nathan@kernel.org, changbin.du@intel.com, ytcoode@gmail.com,
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
References: <20220830214919.53220-1-surenb@google.com>
 <20220830214919.53220-23-surenb@google.com>
From:   Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20220830214919.53220-23-surenb@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



On 8/30/22 14:49, Suren Baghdasaryan wrote:
> From: Kent Overstreet <kent.overstreet@linux.dev>
> 
> This adds a new fault injection capability, based on code tagging.
> 
> To use, simply insert somewhere in your code
> 
>   dynamic_fault("fault_class_name")
> 
> and check whether it returns true - if so, inject the error.
> For example
> 
>   if (dynamic_fault("init"))
>       return -EINVAL;
> 
> There's no need to define faults elsewhere, as with
> include/linux/fault-injection.h. Faults show up in debugfs, under
> /sys/kernel/debug/dynamic_faults, and can be selected based on
> file/module/function/line number/class, and enabled permanently, or in
> oneshot mode, or with a specified frequency.
> 
> Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>

Missing Signed-off-by: from Suren.
See Documentation/process/submitting-patches.rst:

When to use Acked-by:, Cc:, and Co-developed-by:
------------------------------------------------

The Signed-off-by: tag indicates that the signer was involved in the
development of the patch, or that he/she was in the patch's delivery path.


-- 
~Randy
