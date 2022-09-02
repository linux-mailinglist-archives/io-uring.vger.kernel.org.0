Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A7615AAE02
	for <lists+io-uring@lfdr.de>; Fri,  2 Sep 2022 14:03:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235707AbiIBMCW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 2 Sep 2022 08:02:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235686AbiIBMCU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 2 Sep 2022 08:02:20 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9871BC0B54
        for <io-uring@vger.kernel.org>; Fri,  2 Sep 2022 05:02:18 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id q63so1765711pga.9
        for <io-uring@vger.kernel.org>; Fri, 02 Sep 2022 05:02:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=W8RjYI+n37ofAo9LBQEiCCEo6ndS1LkvyfXGybqsT9Q=;
        b=KJAXAw3+eV100jVcXnx/LqY4g085qYcLfMEFb+CqK4NNPBI9F8q01WkRiTpC9xcqhF
         /4FkKnilu36QUVvPSMq5xoJPqh+oM/ajx5O1Ooz3frF0it9D7UMt8os//kh3KVKuZVb/
         DPPYiXpugkbyENhGTY+/WPxqKyt1jcv2zujzHIJxdB0ew1X0zrJZfMTGT15i+87M0po6
         0/QMZTGU+ePDJ2R+Ec9/I+/IE6Qsct4tdfUfCSODRxCfpDSAWo9ais93dWCx9G+uqlln
         0sE9qiRD9Lz9bZ0YZbv1M1UDvvLW735W+u2JopGKR2Y65g0jVSPYyBMRqlC2d3FYstWU
         49Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=W8RjYI+n37ofAo9LBQEiCCEo6ndS1LkvyfXGybqsT9Q=;
        b=jazgfoMwHyCKsNo2JHU/HvhK8owg74bWsZ8GkBDz2uomqKrkba9hqC8qxFGgQrIeU+
         WEBge423XxK0p1LfMJLUhT/+qb+96gB1pOkkPmeHosnHKJIBxD8PmMxsuVe3FDMa8cXQ
         lrY0WL7Tkyr/cpL34bC+8oZxEGrhZG1MqXEcex69wOhsoQUNWXF+Fq/zOSnoBJaU73OQ
         aWOf4yunGZWPrWwGzi/imfr9O9C0AordwCrppmjCHaUHy00pF82iGWrC5DwafF4D81GF
         tYQ/geOAZ1hdOWmwM+fWCnnL2ufHy/dQeIu2GTIO6TPNl6QGd00XuZsc4YiZV0XA2g1w
         qDeA==
X-Gm-Message-State: ACgBeo2pu1OKEtWOu8yjHXyCewYVQ0ZK3RdDJCAW18RvwarxzNzQ+0uA
        u6hSBfKFTA8/LIF07qn22+55CA==
X-Google-Smtp-Source: AA6agR6oz8BXj0U20tJpMgDuL2EJ/favK/h81yeCR3znK+DwDUa+f211F9QgLE7hKWaq2wOql0pxmg==
X-Received: by 2002:aa7:92d8:0:b0:537:acbf:5e85 with SMTP id k24-20020aa792d8000000b00537acbf5e85mr35570681pfa.61.1662120138036;
        Fri, 02 Sep 2022 05:02:18 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id v65-20020a622f44000000b00539aa7f0b53sm1557339pfv.104.2022.09.02.05.02.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Sep 2022 05:02:17 -0700 (PDT)
Message-ID: <3a41b9fc-05f1-3f56-ecd0-70b9a2912a31@kernel.dk>
Date:   Fri, 2 Sep 2022 06:02:12 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.1.2
Subject: Re: [RFC PATCH 00/30] Code tagging framework and applications
Content-Language: en-US
To:     Roman Gushchin <roman.gushchin@linux.dev>,
        Kent Overstreet <kent.overstreet@linux.dev>
Cc:     Yosry Ahmed <yosryahmed@google.com>,
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
References: <Yw8P8xZ4zqu121xL@hirez.programming.kicks-ass.net>
 <20220831084230.3ti3vitrzhzsu3fs@moria.home.lan>
 <20220831101948.f3etturccmp5ovkl@suse.de> <Yw88RFuBgc7yFYxA@dhcp22.suse.cz>
 <20220831190154.qdlsxfamans3ya5j@moria.home.lan>
 <CAJD7tkaev9B=UDYj2RL6pz-1454J8tv4gEr9y-2dnCksoLK0bw@mail.gmail.com>
 <YxExz+c1k3nbQMh4@P9FQF9L96D.corp.robot.car>
 <20220901223720.e4gudprscjtwltif@moria.home.lan>
 <YxE4BXw5i+BkxxD8@P9FQF9L96D.corp.robot.car>
 <20220902001747.qqsv2lzkuycffuqe@moria.home.lan>
 <YxFWrka+Wx0FfLXU@P9FQF9L96D.lan>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <YxFWrka+Wx0FfLXU@P9FQF9L96D.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/1/22 7:04 PM, Roman Gushchin wrote:
> On Thu, Sep 01, 2022 at 08:17:47PM -0400, Kent Overstreet wrote:
>> On Thu, Sep 01, 2022 at 03:53:57PM -0700, Roman Gushchin wrote:
>>> I'd suggest to run something like iperf on a fast hardware. And maybe some
>>> io_uring stuff too. These are two places which were historically most sensitive
>>> to the (kernel) memory accounting speed.
>>
>> I'm getting wildly inconsistent results with iperf.
>>
>> io_uring-echo-server and rust_echo_bench gets me:
>> Benchmarking: 127.0.0.1:12345
>> 50 clients, running 512 bytes, 60 sec.
>>
>> Without alloc tagging:	120547 request/sec
>> With:			116748 request/sec
>>
>> https://github.com/frevib/io_uring-echo-server
>> https://github.com/haraldh/rust_echo_bench
>>
>> How's that look to you? Close enough? :)
> 
> Yes, this looks good (a bit too good).
> 
> I'm not that familiar with io_uring, Jens and Pavel should have a better idea
> what and how to run (I know they've workarounded the kernel memory accounting
> because of the performance in the past, this is why I suspect it might be an
> issue here as well).

io_uring isn't alloc+free intensive on a per request basis anymore, it
would not be a good benchmark if the goal is to check for regressions in
that area.

-- 
Jens Axboe
