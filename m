Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63A685AB96A
	for <lists+io-uring@lfdr.de>; Fri,  2 Sep 2022 22:24:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230137AbiIBUXp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 2 Sep 2022 16:23:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230499AbiIBUXn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 2 Sep 2022 16:23:43 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3122DF8FC9
        for <io-uring@vger.kernel.org>; Fri,  2 Sep 2022 13:23:41 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id f12so2874976plb.11
        for <io-uring@vger.kernel.org>; Fri, 02 Sep 2022 13:23:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=k6pQn9EMMlV6BZtQiNF0XvMyejT4MeXWM0SLMVDUfUA=;
        b=atNBwFgIt7igHl+/QHLrFlJtFVTsSH/kJfYVSiBHiTvpkch9s3+zAthZGB6A5YDXlS
         v71QG7O0GohvTTqFSZ7hQ4jR7KHFNnmgxFUC6YUXp3eVqkrlZqyPHMxKdRrsK3hC7WJ+
         ratf09sB7a22OqVWFFXLzBVLXIay3MBLrlzBsi890YvKl53SP/bZRFwgW9WLVQrECS+k
         e6/tO13lZyqAPIynEcJMUR9e2fBT2mJferk6/Xl8AJzVAjPmCX/MyAk+37HMrw2I7UDI
         9l1WHpQ97YwZWMNi7XR5oEpipq812loh43BTSSYGw8QqCLvIufzr2WYkCLPG0vPEjTfE
         HLbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=k6pQn9EMMlV6BZtQiNF0XvMyejT4MeXWM0SLMVDUfUA=;
        b=y4WIBzdmlorvY35x8tOMGzYWTy5J7428PNt/PPpIwkT5VJiTNXKJkPWyxtjPvCJh2P
         JxXkbWKAxS+P9u3VVKYcQXxN+uGYazSYp4NTo9QFTTibnMlt2HAirdpdUvJ5VIdIO3nS
         hCNOSurCvZwJXmmylQsfGNhPU35ZqO/31fMmMeJKJEDFfU/PDMJRfCPZYiBMu5scIgfM
         /NKH40aOT4S6NvvppV6Lks/OiOaQEfku+fDPa7B6fRsVaFjXffhJ2gA7r8C2O43mvufU
         13IcgOdqz5hw2h2pXkFYvhGlYWw2SR6AciLbJxCzn6l2Uk/AyfY/avJufYqOAO9qZMRu
         NIqQ==
X-Gm-Message-State: ACgBeo0Z8Yhh1KuJA3TC7GLvZW5HIoxxAfvMb6ksu4cUoPhNyugXSey2
        hJfZkEYvn5Anp9nG0fHl6OOmGA==
X-Google-Smtp-Source: AA6agR5AqhuPnCBKUHnmMMoOWG9kI43vIem/phxzSs6gDhTM24/CuEkLWk7/yQtSZJLhY720RHeSVw==
X-Received: by 2002:a17:902:c94d:b0:16d:c10a:650e with SMTP id i13-20020a170902c94d00b0016dc10a650emr36139251pla.29.1662150220589;
        Fri, 02 Sep 2022 13:23:40 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id z10-20020a62d10a000000b00535d094d6ecsm2197822pfg.108.2022.09.02.13.23.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Sep 2022 13:23:38 -0700 (PDT)
Message-ID: <002ab1f2-078e-2bce-83a0-257a573b1f95@kernel.dk>
Date:   Fri, 2 Sep 2022 14:23:34 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.1.2
Subject: Re: [RFC PATCH 00/30] Code tagging framework and applications
Content-Language: en-US
To:     Kent Overstreet <kent.overstreet@linux.dev>
Cc:     Roman Gushchin <roman.gushchin@linux.dev>,
        Yosry Ahmed <yosryahmed@google.com>,
        Michal Hocko <mhocko@suse.com>, Mel Gorman <mgorman@suse.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Suren Baghdasaryan <surenb@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>, dave@stgolabs.net,
        Matthew Wilcox <willy@infradead.org>, liam.howlett@oracle.com,
        void@manifault.com, juri.lelli@redhat.com, ldufour@linux.ibm.com,
        Peter Xu <peterx@redhat.com>,
        David Hildenbrand <david@redhat.com>, mcgrof@kernel.org,
        masahiroy@kernel.org, nathan@kernel.org, changbin.du@intel.com,
        ytcoode@gmail.com, vincent.guittot@linaro.org,
        dietmar.eggemann@arm.com, Steven Rostedt <rostedt@goodmis.org>,
        bsegall@google.com, bristot@redhat.com, vschneid@redhat.com,
        Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>, 42.hyeyoo@gmail.com,
        glider@google.com, elver@google.com, dvyukov@google.com,
        Shakeel Butt <shakeelb@google.com>,
        Muchun Song <songmuchun@bytedance.com>, arnd@arndb.de,
        jbaron@akamai.com, David Rientjes <rientjes@google.com>,
        minchan@google.com, kaleshsingh@google.com,
        kernel-team@android.com, Linux-MM <linux-mm@kvack.org>,
        iommu@lists.linux.dev, kasan-dev@googlegroups.com,
        io-uring@vger.kernel.org, linux-arch@vger.kernel.org,
        xen-devel@lists.xenproject.org, linux-bcache@vger.kernel.org,
        linux-modules@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20220831190154.qdlsxfamans3ya5j@moria.home.lan>
 <CAJD7tkaev9B=UDYj2RL6pz-1454J8tv4gEr9y-2dnCksoLK0bw@mail.gmail.com>
 <YxExz+c1k3nbQMh4@P9FQF9L96D.corp.robot.car>
 <20220901223720.e4gudprscjtwltif@moria.home.lan>
 <YxE4BXw5i+BkxxD8@P9FQF9L96D.corp.robot.car>
 <20220902001747.qqsv2lzkuycffuqe@moria.home.lan>
 <YxFWrka+Wx0FfLXU@P9FQF9L96D.lan>
 <3a41b9fc-05f1-3f56-ecd0-70b9a2912a31@kernel.dk>
 <20220902194839.xqzgsoowous72jkz@moria.home.lan>
 <d5526090-0380-a586-40e1-7b3bb6fe6fb8@kernel.dk>
 <20220902200555.h5fyamst6lyamjnw@moria.home.lan>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220902200555.h5fyamst6lyamjnw@moria.home.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/2/22 2:05 PM, Kent Overstreet wrote:
> On Fri, Sep 02, 2022 at 01:53:53PM -0600, Jens Axboe wrote:
>> I've complained about memcg accounting before, the slowness of it is why
>> io_uring works around it by caching. Anything we account we try NOT do
>> in the fast path because of it, the slowdown is considerable.
> 
> I'm with you on that, it definitely raises an eyebrow.
> 
>> You care about efficiency now? I thought that was relegated to
>> irrelevant 10M IOPS cases.
> 
> I always did, it's just not the only thing I care about.

It's not the only thing anyone cares about.

-- 
Jens Axboe
