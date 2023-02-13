Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 809E16944E5
	for <lists+io-uring@lfdr.de>; Mon, 13 Feb 2023 12:54:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229656AbjBMLys (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 13 Feb 2023 06:54:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229632AbjBMLyr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 13 Feb 2023 06:54:47 -0500
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 477051353E;
        Mon, 13 Feb 2023 03:54:46 -0800 (PST)
Received: by mail-wr1-f52.google.com with SMTP id k3so4268881wrv.5;
        Mon, 13 Feb 2023 03:54:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1676289285;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/CPeRKp2equzjPoiyGuI+L6sOY6qqv2wALvdLjuhPQM=;
        b=EwFemcQDQCZlfLyVdosZqzCrGeshvRHluvCpG9ZDm4V35gQF9HnKHX/r+kahtPvCe0
         cKJPSIXWCYOaSVmKY0qgWROGASkqFoVNM0RtKkOkzgvKPShkgdUyGix2nQlnOguzXIRu
         YmQoTRz2mUaYjpbe/HQCzBfRdJ1jt2hRLj5IjeeoNmMfY/W6Sbm0DDsA5j7/66FbHYgx
         eHDFxG/I2bUR8tWJTNnF8dYtyHYB87hB5MgrXjhlbRcSVWAHW/QVDn/5EZu+aMK8+ehy
         hChYhQqXDXkqjjmFe0vEIn40NLZrmWjM1QuniMrRMGoNAwOBBcHfJvlZuGeHljmFddfr
         aVtg==
X-Gm-Message-State: AO0yUKUZ7PYJXFzCsf7KXswoEmW750/NhEFr42o6O155j6aBktO5hIw2
        rqYLbdYShWQtyc5WtM4+GyQ=
X-Google-Smtp-Source: AK7set+RjIvySbOj6M2sEO16NGkt3ThmcXKJoOTiWW3+yJEoE8M86yMRqBLAjsl4Qf9scHKo75kd8w==
X-Received: by 2002:a5d:5151:0:b0:2c5:5b85:3b43 with SMTP id u17-20020a5d5151000000b002c55b853b43mr1001809wrt.7.1676289284693;
        Mon, 13 Feb 2023 03:54:44 -0800 (PST)
Received: from [192.168.64.80] (bzq-219-42-90.isdn.bezeqint.net. [62.219.42.90])
        by smtp.gmail.com with ESMTPSA id f5-20020adff445000000b002c53f5b13f9sm10035471wrp.0.2023.02.13.03.54.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Feb 2023 03:54:44 -0800 (PST)
Message-ID: <79c1f876-d054-a8ed-8826-e3ad4f9903eb@grimberg.me>
Date:   Mon, 13 Feb 2023 13:54:42 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [LSF/MM/BPF ATTEND][LSF/MM/BPF Topic] Non-block IO
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>, Kanchan Joshi <joshi.k@samsung.com>,
        lsf-pc@lists.linux-foundation.org
Cc:     linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
        io-uring@vger.kernel.org, hch@lst.de, kbusch@kernel.org,
        ming.lei@redhat.com
References: <CGME20230210180226epcas5p1bd2e1150de067f8af61de2bbf571594d@epcas5p1.samsung.com>
 <20230210180033.321377-1-joshi.k@samsung.com>
 <39a543d7-658c-0309-7a68-f07ffe850d0e@kernel.dk>
From:   Sagi Grimberg <sagi@grimberg.me>
In-Reply-To: <39a543d7-658c-0309-7a68-f07ffe850d0e@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



On 2/10/23 21:53, Jens Axboe wrote:
> On 2/10/23 11:00?AM, Kanchan Joshi wrote:
>> is getting more common than it used to be.
>> NVMe is no longer tied to block storage. Command sets in NVMe 2.0 spec
>> opened an excellent way to present non-block interfaces to the Host. ZNS
>> and KV came along with it, and some new command sets are emerging.
>>
>> OTOH, Kernel IO advances historically centered around the block IO path.
>> Passthrough IO path existed, but it stayed far from all the advances, be
>> it new features or performance.
>>
>> Current state & discussion points:
>> ---------------------------------
>> Status-quo changed in the recent past with the new passthrough path (ng
>> char interface + io_uring command). Feature parity does not exist, but
>> performance parity does.
>> Adoption draws asks. I propose a session covering a few voices and
>> finding a path-forward for some ideas too.
>>
>> 1. Command cancellation: while NVMe mandatorily supports the abort
>> command, we do not have a way to trigger that from user-space. There
>> are ways to go about it (with or without the uring-cancel interface) but
>> not without certain tradeoffs. It will be good to discuss the choices in
>> person.

This would require some rework of how the driver handles aborts today.
I'm unsure what the cancellation guarantees that io_uring provides, but
need to understand if it fits with the guarantees that nvme provides.

It is also unclear to me how this would work if different namespaces
are handed to different users, and have them all submit aborts on
the admin queue. How do you even differentiate which user sent which
command?

>>
>> 2. Cgroups: works for only block dev at the moment. Are there outright
>> objections to extending this to char-interface IO?
>>
>> 3. DMA cost: is high in presence of IOMMU. Keith posted the work[1],
>> with block IO path, last year. I imagine plumbing to get a bit simpler
>> with passthrough-only support. But what are the other things that must
>> be sorted out to have progress on moving DMA cost out of the fast path?
> 
> Yeah, this one is still pending... Would be nice to make some progress
> there at some point.
> 
>> 4. Direct NVMe queues - will there be interest in having io_uring
>> managed NVMe queues?  Sort of a new ring, for which I/O is destaged from
>> io_uring SQE to NVMe SQE without having to go through intermediate
>> constructs (i.e., bio/request). Hopefully,that can further amp up the
>> efficiency of IO.
> 
> This is interesting, and I've pondered something like that before too. I
> think it's worth investigating and hacking up a prototype. I recently
> had one user of IOPOLL assume that setting up a ring with IOPOLL would
> automatically create a polled queue on the driver side and that is what
> would be used for IO. And while that's not how it currently works, it
> definitely does make sense and we could make some things faster like
> that.

I also think it can makes sense, I'd use it if it was available.
Though io_uring may need to abstract the fact that the device may be
limited on the number of queues it supports, also this would need to be
an interface needed from the driver that would need to understand how to
coordinate controller reset/teardown in the presence of "alien" queues.

  It would also potentially easier enable cancelation referenced in
> #1 above, if it's restricted to the queue(s) that the ring "owns".
> 

That could be a potential enforcement, correlating the command with
the dedicated queue. Still feels dangerous because if admin abort(s)
time out the driver really needs to reset the entire controller...
So it is not really "isolated" when it comes to aborts/cancellations.
