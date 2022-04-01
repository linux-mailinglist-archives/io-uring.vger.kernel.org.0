Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 846534EF819
	for <lists+io-uring@lfdr.de>; Fri,  1 Apr 2022 18:38:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231529AbiDAQkM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 1 Apr 2022 12:40:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348671AbiDAQjf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 1 Apr 2022 12:39:35 -0400
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30DC028EA05
        for <io-uring@vger.kernel.org>; Fri,  1 Apr 2022 09:21:03 -0700 (PDT)
Received: by mail-io1-xd2a.google.com with SMTP id e22so3720991ioe.11
        for <io-uring@vger.kernel.org>; Fri, 01 Apr 2022 09:21:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=/HH/PAInUk6n2UQ7RqhKbjnQADQYlVyhHiIB6k6oxuw=;
        b=BuL0euf7AJJPvRX0xMbhUCHu1Cs7r4R0CA+g9ZdKJMNmMM9dbj43+yYcLm26xTkE4K
         ZUNjy3EehwR4FstvgIoBA9tU5lnBig4xKgrHLr70BP/bBglMgnFEDPnQ3hpiWETUAk6I
         TflPgqg0+D8EFz5epjYR0H73mx+nwqIWkMh3cKx8qm9CHqg/YNnf6n6WSzkB+M3f+is7
         OACc3duxhFW0xqgH5IYcVwKH4JcZRVzJXySeElJDxwJOJVS5BrlDavgSGZMFDIjChcxO
         5wyhmdif5j7RUGJhn+6srKJhPkDD3qVREdoyDIcyjSj0/Kz/uoWKDaWVb7FC+cMbBBxt
         5GhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=/HH/PAInUk6n2UQ7RqhKbjnQADQYlVyhHiIB6k6oxuw=;
        b=iFNW4wi8xwsZFkLYlQQr4etEFFkry+fdrKbB6xLsNq7rnkmp7Ij32vDt44Ir3cI+57
         PMDU7VtYWQs4y3Gfwi+kbEaIab7r6F30HEYZ4CZd02jcCE7YX+80AFOFu002YTv9q5p8
         xshLsAdV1x85qqskZoJKNbiYD15WEWM9Fo4Ny9kiLVsh3rji2qVzyVOnj1nK3dRbykPi
         4ihJUUjYGRAs4y0fCgc1oJERlAg8I7wrOSinRuenhZllbTVikIqegGvpnOn4KX4rawfh
         CZdr44zO9ILOmcU6mGAnSQGyF6A7gClVTQnW5zHOJBDFWxiD34vOXDgeLDHBp/9wGWGr
         MgLQ==
X-Gm-Message-State: AOAM533+iDv/PVzvpcgHYq1fLTUEE6LlASRrSKWDLBKlpY6u+ha1uLqS
        a2nrTh/1b6KVSjsNITT/uIGmevZtIL0bI7CI
X-Google-Smtp-Source: ABdhPJysN7NnKpU48JP9WcuIovctzxNWt+qfpt4oZlVoPnXCNyDsdvBjBHfab43mzv+0K0wb2j4fhw==
X-Received: by 2002:a02:c9d0:0:b0:323:6e14:8da3 with SMTP id c16-20020a02c9d0000000b003236e148da3mr5616703jap.196.1648830062322;
        Fri, 01 Apr 2022 09:21:02 -0700 (PDT)
Received: from [192.168.1.172] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id o15-20020a6bcf0f000000b00649c4056879sm1631457ioa.50.2022.04.01.09.21.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Apr 2022 09:21:01 -0700 (PDT)
Message-ID: <b9964d20-1c87-502b-a1b6-1deb538b7842@kernel.dk>
Date:   Fri, 1 Apr 2022 10:21:01 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: io_uring_prep_openat_direct() and link/drain
Content-Language: en-US
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     io-uring@vger.kernel.org
References: <CAJfpegvVpFbDX5so8EVaHxubZLNQ4bo=myAYopWeRtMs0wa6nA@mail.gmail.com>
 <0c5745ab-5d3d-52c1-6a1d-e5e33d4078b5@kernel.dk>
 <CAJfpegtob8ZWU1TDBoUf7SRMQJhEcEo2sPUumzpNd3Mcg+1aog@mail.gmail.com>
 <52dca413-61b3-8ded-c4cc-dd6c8e8de1ed@kernel.dk>
 <CAJfpegtEG2c3H8ZyOWPT69HJN2UWU1es-n9P+CSgV7jiZMPtGg@mail.gmail.com>
 <23b62cca-8ec5-f250-e5a3-7e9ed983e190@kernel.dk>
 <CAJfpeguZji8x+zXSADJ4m6VKbdmTb6ZQd5zA=HCt8acxvGSr3w@mail.gmail.com>
 <CAJfpegsADrdURSUOrGTjbu1DoRr7-8itGx23Tn0wf6gNdO5dWA@mail.gmail.com>
 <77229971-72cd-7d78-d790-3ef4789acc9e@kernel.dk>
 <CAJfpeguiZ7U=YQhgGa-oPWO07tpBL6sf3zM=xtAk66njb1p2cw@mail.gmail.com>
 <c5f27130-b4ad-3f4c-ce98-4414227db4fd@kernel.dk>
 <61c2336f-0315-5f76-3022-18c80f79e0b5@kernel.dk>
 <38436a44-5048-2062-c339-66679ae1e282@kernel.dk>
 <CAJfpegvM3LQ8nsJf=LsWjQznpOzC+mZFXB5xkZgZHR2tXXjxLQ@mail.gmail.com>
 <fbf3b195-7415-7f84-c0e6-bdfebf9692f2@kernel.dk>
 <CAJfpeguq1bBDa9-gbk6tutME1kH4SdHvkUdLGKzfdmhpCtCt6g@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CAJfpeguq1bBDa9-gbk6tutME1kH4SdHvkUdLGKzfdmhpCtCt6g@mail.gmail.com>
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

On 4/1/22 10:02 AM, Miklos Szeredi wrote:
> On Fri, 1 Apr 2022 at 17:36, Jens Axboe <axboe@kernel.dk> wrote:
> 
>> I take it you're continually reusing those slots?
> 
> Yes.
> 
>>  If you have a test
>> case that'd be ideal. Agree that it sounds like we just need an
>> appropriate breather to allow fput/task_work to run. Or it could be the
>> deferral free of the fixed slot.
> 
> Adding a breather could make the worst case latency be large.  I think
> doing the fput synchronously would be better in general.

fput() isn't sync, it'll just offload to task_work. There are some
dependencies there that would need to be checked. But we'll find a way
to deal with it.

> I test this on an VM with 8G of memory and run the following:
> 
> ./forkbomb 14 &
> # wait till 16k processes are forked
> for i in `seq 1 100`; do ./procreads u; done
> 
> You can compare performance with plain reads (./procreads p), the
> other tests don't work on public kernels.

OK, I'll check up on this, but probably won't have time to do so before
early next week.

-- 
Jens Axboe

