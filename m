Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59EC05A906D
	for <lists+io-uring@lfdr.de>; Thu,  1 Sep 2022 09:37:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233849AbiIAHhI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 1 Sep 2022 03:37:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233834AbiIAHhH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 1 Sep 2022 03:37:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9A48FCA23
        for <io-uring@vger.kernel.org>; Thu,  1 Sep 2022 00:37:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662017823;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=w/uTT8lnpogUVhwkYNDxdhGZzOyBXG3eWWImkgPiyoM=;
        b=DgayC5dyfaeGXWgqcGu/YcLeWOxlSxKhLpPoQminM/M3pGbY73WxztkrhpaiegTmoZhNJ8
        izs+WXb28e8YU80Odx6KsPd3FU1KYrTVx+iSPIcqidvGBQAiflWSAlmYLqzBNBPGWuxK7P
        3MPhtjSRmJCu6jTPnEFblE1h4PJh5q8=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-634-vtowHTXUOEmhcNToemhyKw-1; Thu, 01 Sep 2022 03:37:02 -0400
X-MC-Unique: vtowHTXUOEmhcNToemhyKw-1
Received: by mail-ed1-f71.google.com with SMTP id b13-20020a056402350d00b0043dfc84c533so11020200edd.5
        for <io-uring@vger.kernel.org>; Thu, 01 Sep 2022 00:37:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=w/uTT8lnpogUVhwkYNDxdhGZzOyBXG3eWWImkgPiyoM=;
        b=IKBUsdbBS5TO1YwMPx/dpvvytzTclh+2wOTi/I39ND0EoXBdg3C2DHOVaXNrx/Fs2p
         jmCxIU9k09xSaSteW9+qSpmtSgW9Vp1FOUAljBfTyQ0DgCk9K3PItvasOfSD1UEJXXw7
         eFtgW1bLeEgh0fd0AU7MfTzWd1gbaxuKtieQeRCqVbADphuBjwS/Cn/WXB2v2IQBhFhq
         HcO5brFa22Qdr7ivnPcf+exW09NOErYRlgB+WDuA+YI1azzrhnFam4OuVIdS0QyOJe+r
         W1FPqI4WtTIvxdfo4YD1QFATkv1EeKZc5wKIwfTJA8v2L0oqVHXUE+cQ+Bp9dOY0N4Lg
         EN7w==
X-Gm-Message-State: ACgBeo1KvpaPcJ6fg6olS6eYactKJrEFVFit4TxmowzI+yN+y6AEqQ4r
        dtyyvgCCfIIzk2v0GF6A3FVaig9Z9S7RDx6VIeZ5Oq4qr8COTC7i2E34cAgr0QYFd2GZj/LGQTH
        oRwXjALdRUBcwA1ZQgPM=
X-Received: by 2002:aa7:d90e:0:b0:447:986d:b71e with SMTP id a14-20020aa7d90e000000b00447986db71emr27210691edr.235.1662017821488;
        Thu, 01 Sep 2022 00:37:01 -0700 (PDT)
X-Google-Smtp-Source: AA6agR6JkW4ed1WqDsotybL6CAAiG40VbkLtzaIPBaAypGnjlWDX5j26Jhqen11PzZwUzZ8Rc1KOjQ==
X-Received: by 2002:aa7:d90e:0:b0:447:986d:b71e with SMTP id a14-20020aa7d90e000000b00447986db71emr27210669edr.235.1662017821253;
        Thu, 01 Sep 2022 00:37:01 -0700 (PDT)
Received: from [192.168.0.198] (host-87-8-60-205.retail.telecomitalia.it. [87.8.60.205])
        by smtp.gmail.com with ESMTPSA id u24-20020aa7d998000000b0043a61f6c389sm898086eds.4.2022.09.01.00.36.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Sep 2022 00:37:00 -0700 (PDT)
Message-ID: <37a66a8d-859d-5a8b-e298-d0c32e2028e7@redhat.com>
Date:   Thu, 1 Sep 2022 09:36:58 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.0
Subject: Re: [RFC PATCH 00/30] Code tagging framework and applications
Content-Language: en-US
To:     Peter Zijlstra <peterz@infradead.org>,
        Kent Overstreet <kent.overstreet@linux.dev>
Cc:     Mel Gorman <mgorman@suse.de>,
        Suren Baghdasaryan <surenb@google.com>,
        akpm@linux-foundation.org, mhocko@suse.com, vbabka@suse.cz,
        hannes@cmpxchg.org, roman.gushchin@linux.dev, dave@stgolabs.net,
        willy@infradead.org, liam.howlett@oracle.com, void@manifault.com,
        juri.lelli@redhat.com, ldufour@linux.ibm.com, peterx@redhat.com,
        david@redhat.com, axboe@kernel.dk, mcgrof@kernel.org,
        masahiroy@kernel.org, nathan@kernel.org, changbin.du@intel.com,
        ytcoode@gmail.com, vincent.guittot@linaro.org,
        dietmar.eggemann@arm.com, rostedt@goodmis.org, bsegall@google.com,
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
 <Yw8P8xZ4zqu121xL@hirez.programming.kicks-ass.net>
 <20220831084230.3ti3vitrzhzsu3fs@moria.home.lan>
 <20220831101948.f3etturccmp5ovkl@suse.de>
 <20220831155941.q5umplytbx6offku@moria.home.lan>
 <YxBZv1pZ6N2vwcP3@hirez.programming.kicks-ass.net>
From:   Daniel Bristot de Oliveira <bristot@redhat.com>
In-Reply-To: <YxBZv1pZ6N2vwcP3@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/1/22 09:05, Peter Zijlstra wrote:
>> Also, ftrace can drop events. Not really ideal if under system load your memory
>> accounting numbers start to drift.
> You could attach custom handlers to tracepoints. If you were to replace
> these unconditional code hooks of yours with tracepoints then you could
> conditionally (say at boot) register custom handlers that do the
> accounting you want.

That is strategy in RV (kernel/trace/rv/). It is in C, but I am also
adding support for monitors in bpf. The osnoise/timerlat tracers work this
way too, and they are enabled on Fedora/Red Hat/SUSE... production. They
will also be enabled in Ubuntu and Debian (the interwebs say).

The overhead of attaching code to tracepoints (or any "attachable thing") and
processing data in kernel is often lower than consuming it in user-space.
Obviously, when it is possible, e.g., when you respect locking rules, etc.

This paper (the basis for RV) shows a little comparison:
https://bristot.me/wp-content/uploads/2019/09/paper.pdf

By doing so, we also avoid problems of losing events... and you can also
generate other events from your attached code.

(It is also way easier to convince a maintainer to add a tracepoints or a trace
events than to add arbitrary code... ;-)

-- Daniel

