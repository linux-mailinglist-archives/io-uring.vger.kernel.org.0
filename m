Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 142C85AB901
	for <lists+io-uring@lfdr.de>; Fri,  2 Sep 2022 21:54:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229637AbiIBTyF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 2 Sep 2022 15:54:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229919AbiIBTyB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 2 Sep 2022 15:54:01 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC4BBBA160
        for <io-uring@vger.kernel.org>; Fri,  2 Sep 2022 12:53:58 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id i7-20020a17090adc0700b001fd7ccbec3cso8497935pjv.0
        for <io-uring@vger.kernel.org>; Fri, 02 Sep 2022 12:53:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=BgSQRPeP2vU+fzfPkC5136xUIsrQV+zIPc0zX8WqYvQ=;
        b=4q1ObG8WZYb+BFWPgZh7N7aITtmlNIGPzQtvKE2aYuRrU3oMZQ76tQz2zqxy31cTLt
         d8rIjpGYxzTxBhay1NPxlOw7vaD/UOVOLVL9kTH97EOmLP9jqiD95DNmZFsZ1Ptc8XmN
         SpoCT9nh9ECoUVn4HyZ7Qsn6ksQUfbOmmaLZNC8YNvNZJ0mYksYatinKwvYndzY1XvJm
         nky6nJQ50OCGfppKmlv+KompjFnK/xiaX17J7WZx+2ulxNlRcgnWzxkBWjasiiHjJ4Jl
         WgqrWN7XLOnHrvW9WLg3mCJ+/TAuDw9lCpZSCR3GLv/KhadF9BUUSKQnQ8/gjIX8jzxs
         EhUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=BgSQRPeP2vU+fzfPkC5136xUIsrQV+zIPc0zX8WqYvQ=;
        b=ajuXxeWkDfFbweVh11FNLzfY20DrDVE1H4VRqr/PhbM8WPQ3e6X7gQqr40umL8XbsV
         jh1gkpM7C1MVoZAauo7C9/Dp7B/UjxkkuwxvQ1YhvcC4Qpokbxt71eu5yzlbVe+A96oE
         Yxlafw/rCjoNyfZqICV+FW03kpNJK/J9DROejGHiPpmCmX6uB/TLQV4FfKgztXHNgKB2
         9m6Nzx4SMN/JMWeGcrDaudHMN96Sek6DNc1QOfSHXBrZ62vIYMS+eVunFYE4w/mrh0UH
         HqCqo7J+rALgR/gL9Iveb3KY6nSgYCurtjCgc3SafqKnCmRLw5YIIQBcAg/B7Shrefy9
         Fzjg==
X-Gm-Message-State: ACgBeo2JvPjiDAFkL7Yjetl+NTyncq61mjb6E31hRPKrwFAenWm03OOC
        dee8zJDRGDVGly0YVrtnLdLiBQ==
X-Google-Smtp-Source: AA6agR5BylTPZ3Gegvy/NzTiavEg8hhtbTLj8aGfOurXCnjCbkfIWop802MX5aLKWWzJpm5rxypzOA==
X-Received: by 2002:a17:90b:b16:b0:1fd:b47c:6ab with SMTP id bf22-20020a17090b0b1600b001fdb47c06abmr6698292pjb.203.1662148438176;
        Fri, 02 Sep 2022 12:53:58 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id c6-20020a170902c1c600b00172ccb3f4ebsm2008369plc.160.2022.09.02.12.53.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Sep 2022 12:53:57 -0700 (PDT)
Message-ID: <d5526090-0380-a586-40e1-7b3bb6fe6fb8@kernel.dk>
Date:   Fri, 2 Sep 2022 13:53:53 -0600
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
References: <20220831101948.f3etturccmp5ovkl@suse.de>
 <Yw88RFuBgc7yFYxA@dhcp22.suse.cz>
 <20220831190154.qdlsxfamans3ya5j@moria.home.lan>
 <CAJD7tkaev9B=UDYj2RL6pz-1454J8tv4gEr9y-2dnCksoLK0bw@mail.gmail.com>
 <YxExz+c1k3nbQMh4@P9FQF9L96D.corp.robot.car>
 <20220901223720.e4gudprscjtwltif@moria.home.lan>
 <YxE4BXw5i+BkxxD8@P9FQF9L96D.corp.robot.car>
 <20220902001747.qqsv2lzkuycffuqe@moria.home.lan>
 <YxFWrka+Wx0FfLXU@P9FQF9L96D.lan>
 <3a41b9fc-05f1-3f56-ecd0-70b9a2912a31@kernel.dk>
 <20220902194839.xqzgsoowous72jkz@moria.home.lan>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220902194839.xqzgsoowous72jkz@moria.home.lan>
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

On 9/2/22 1:48 PM, Kent Overstreet wrote:
> On Fri, Sep 02, 2022 at 06:02:12AM -0600, Jens Axboe wrote:
>> On 9/1/22 7:04 PM, Roman Gushchin wrote:
>>> On Thu, Sep 01, 2022 at 08:17:47PM -0400, Kent Overstreet wrote:
>>>> On Thu, Sep 01, 2022 at 03:53:57PM -0700, Roman Gushchin wrote:
>>>>> I'd suggest to run something like iperf on a fast hardware. And maybe some
>>>>> io_uring stuff too. These are two places which were historically most sensitive
>>>>> to the (kernel) memory accounting speed.
>>>>
>>>> I'm getting wildly inconsistent results with iperf.
>>>>
>>>> io_uring-echo-server and rust_echo_bench gets me:
>>>> Benchmarking: 127.0.0.1:12345
>>>> 50 clients, running 512 bytes, 60 sec.
>>>>
>>>> Without alloc tagging:	120547 request/sec
>>>> With:			116748 request/sec
>>>>
>>>> https://github.com/frevib/io_uring-echo-server
>>>> https://github.com/haraldh/rust_echo_bench
>>>>
>>>> How's that look to you? Close enough? :)
>>>
>>> Yes, this looks good (a bit too good).
>>>
>>> I'm not that familiar with io_uring, Jens and Pavel should have a better idea
>>> what and how to run (I know they've workarounded the kernel memory accounting
>>> because of the performance in the past, this is why I suspect it might be an
>>> issue here as well).
>>
>> io_uring isn't alloc+free intensive on a per request basis anymore, it
>> would not be a good benchmark if the goal is to check for regressions in
>> that area.
> 
> Good to know. The benchmark is still a TCP benchmark though, so still useful.
> 
> Matthew suggested
>   while true; do echo 1 >/tmp/foo; rm /tmp/foo; done
> 
> I ran that on tmpfs, and the numbers with and without alloc tagging were
> statistically equal - there was a fair amount of variation, it wasn't a super
> controlled test, anywhere from 38-41 seconds with 100000 iterations (and alloc
> tagging was some of the faster runs).
> 
> But with memcg off, it ran in 32-33 seconds. We're piggybacking on the same
> mechanism memcg uses for stashing per-object pointers, so it looks like that's
> the bigger cost.

I've complained about memcg accounting before, the slowness of it is why
io_uring works around it by caching. Anything we account we try NOT do
in the fast path because of it, the slowdown is considerable.

You care about efficiency now? I thought that was relegated to
irrelevant 10M IOPS cases.

-- 
Jens Axboe
