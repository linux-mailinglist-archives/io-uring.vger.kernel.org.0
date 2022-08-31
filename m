Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 366A85A7399
	for <lists+io-uring@lfdr.de>; Wed, 31 Aug 2022 03:54:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231298AbiHaBx6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 30 Aug 2022 21:53:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229946AbiHaBx4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 30 Aug 2022 21:53:56 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BE30B1B81;
        Tue, 30 Aug 2022 18:53:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
        Message-ID:Sender:Reply-To:Content-ID:Content-Description;
        bh=RhkN3pjenFJ3Z4sU+BUfbopmS9x7erS/IYHXt0Yrgys=; b=QysnhHPVNUGamQ7lXkzW2eGveh
        lrRg3+WUIjKPhlF4vYw9KekYa0WymOeuQ9HZPakLME5p5qV2twe7OuR2cUMRxXRUExVoM9Da2cXco
        yxjaOKLwszB82khEd88lF0vcr9JboUUXxbv1iMGT6e8sXnviYouqPSuJ+bj2WkKHW8IkoHWJTYVAa
        nyEihlkujx5tC79yFjtJBfsR8iMLwz25U0Q5QoAClOCZQUDuPmiYE4b2xfU5PgTlbLr8FZaKX/Pc6
        90hO5RXPljYmishV1MXlptWBpBn7w9xcC6yjahtqPBxuBT6MCskGBWplJNcTqSA8jP2wkHctWyQFF
        e1X2LPNQ==;
Received: from [2601:1c0:6280:3f0::a6b3]
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oTCv3-0036yC-Ja; Wed, 31 Aug 2022 01:53:29 +0000
Message-ID: <241c05a3-52a2-d49f-6962-3af5a94bc3fc@infradead.org>
Date:   Tue, 30 Aug 2022 18:53:26 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.1.2
Subject: Re: [RFC PATCH 27/30] Code tagging based latency tracking
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
 <20220830214919.53220-28-surenb@google.com>
From:   Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20220830214919.53220-28-surenb@google.com>
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
> diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
> index b7d03afbc808..b0f86643b8f0 100644
> --- a/lib/Kconfig.debug
> +++ b/lib/Kconfig.debug
> @@ -1728,6 +1728,14 @@ config LATENCYTOP
>  	  Enable this option if you want to use the LatencyTOP tool
>  	  to find out which userspace is blocking on what kernel operations.
>  
> +config CODETAG_TIME_STATS
> +	bool "Code tagging based latency measuring"
> +	depends on DEBUG_FS
> +	select TIME_STATS
> +	select CODE_TAGGING
> +	help
> +	  Enabling this option makes latency statistics available in debugfs

Missing period at the end of the sentence.

-- 
~Randy
