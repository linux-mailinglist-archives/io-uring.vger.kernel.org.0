Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 754145709E0
	for <lists+io-uring@lfdr.de>; Mon, 11 Jul 2022 20:24:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230327AbiGKSYq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 11 Jul 2022 14:24:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229635AbiGKSYp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 11 Jul 2022 14:24:45 -0400
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE68441D2A
        for <io-uring@vger.kernel.org>; Mon, 11 Jul 2022 11:24:44 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id u20so5698641iob.8
        for <io-uring@vger.kernel.org>; Mon, 11 Jul 2022 11:24:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=Z5h98asAviTsgox7FrNAfOD5W+jbBJwdVEYAEoeHiOU=;
        b=uKF7ARNiK2yhXk78RqwF9dIBQUUgi/K++tRmFiHfMCl6ho5oxLfNu/XJSmdsnbs5Uc
         vs4p4uGROfJ83bVKzshZUi275Yht1gTiImT8NVM5cGdr1ZFjjAmC+DV3wJHPvqyfMHt1
         KfX87DGYsQafD3VUik3A1YlHBrFG6sAbnIncfzK4bem/g8nRJgKJtkW69SKmQDV9ah6f
         bqBZ2N5fwGFXLv/ernuxFTqNcCfcX5D7Ea9pkzWQM8T2DLuo/f+iNcsBiUyKrBI0GAqP
         RW9rgPBzCIomVbjvKtfJQgTvKwo9u6XKmVxUIwSAQO2htjtCpAX89YBCHzwA4sxnodnY
         u3Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Z5h98asAviTsgox7FrNAfOD5W+jbBJwdVEYAEoeHiOU=;
        b=bpfsxGp06mkK0PQKnvvtDDUl4KLIllFY2BFCz+LksGgQ/m8Hwxx1FbZo0T6qxQLo2M
         5DT6z0cf4dy8wzfU4VkgBDAMFhPahoj1NQpYqzK5s4jt7D9SPJKJ8lOykTHEYpOJJF9P
         gFzP2sZuEYir+9yYBFXIQ37laX4OEder+hEjMKBBiwnw75L0q+FidbwtJEp+zShjyVJm
         2O6XY9PamH6AcHSIK1MGmSv9BSh0802rM1gNOO3QoWfFDHbJYnbH6e4QVR4otBC2yHCs
         jX2bjHC+JUoMMsGZzlbXddv6y5JQWpwtdXv5fCkAwc2sF1nH/aI0sOBg09cL9xDpzbhR
         vEFg==
X-Gm-Message-State: AJIora/qXdA+ahFMqiLw6XfJ1+MVMtaeIIxxTAL0t937EFVDMzOYl90T
        8RN17bKeo6DWPtxBrEZMLxaWZQ==
X-Google-Smtp-Source: AGRyM1t+fqlUsfNSDzwk3ZkCWeIF6sarX69ZJp7fa7jQjkhx5B7+S4naLX97nZzjMJootHnA/lSzsw==
X-Received: by 2002:a05:6602:29d0:b0:669:1723:c249 with SMTP id z16-20020a05660229d000b006691723c249mr10314526ioq.208.1657563883999;
        Mon, 11 Jul 2022 11:24:43 -0700 (PDT)
Received: from [192.168.1.172] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id f1-20020a02a101000000b0033f3b201d1dsm3168416jag.21.2022.07.11.11.24.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Jul 2022 11:24:43 -0700 (PDT)
Message-ID: <7fb16d2a-21f4-3380-75f3-c8e8c08fd318@kernel.dk>
Date:   Mon, 11 Jul 2022 12:24:42 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH for-next 3/4] io_uring: grow a field in struct
 io_uring_cmd
Content-Language: en-US
To:     Sagi Grimberg <sagi@grimberg.me>,
        Kanchan Joshi <joshi.k@samsung.com>, hch@lst.de,
        kbusch@kernel.org
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, asml.silence@gmail.com,
        joshiiitr@gmail.com, anuj20.g@samsung.com, gost.dev@samsung.com
References: <20220711110155.649153-1-joshi.k@samsung.com>
 <CGME20220711110824epcas5p22c8e945cb8c3c3ac46c8c2b5ab55db9b@epcas5p2.samsung.com>
 <20220711110155.649153-4-joshi.k@samsung.com>
 <2b644543-9a54-c6c4-fd94-f2a64d0701fa@kernel.dk>
 <43955a42-7185-2afc-9a55-80cc2de53bf9@grimberg.me>
 <96fcba9a-76ad-8e04-e94e-b6ec5934f84e@grimberg.me>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <96fcba9a-76ad-8e04-e94e-b6ec5934f84e@grimberg.me>
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

On 7/11/22 12:22 PM, Sagi Grimberg wrote:
> 
>>>> Use the leftover space to carve 'next' field that enables linking of
>>>> io_uring_cmd structs. Also introduce a list head and few helpers.
>>>>
>>>> This is in preparation to support nvme-mulitpath, allowing multiple
>>>> uring passthrough commands to be queued.
>>>
>>> It's not clear to me why we need linking at that level?
>>
>> I think the attempt is to allow something like blk_steal_bios that
>> nvme leverages for io_uring_cmd(s).
> 
> I'll rephrase because now that I read it, I think my phrasing is
> confusing.
> 
> I think the attempt is to allow something like blk_steal_bios that
> nvme leverages, but for io_uring_cmd(s). Essentially allow io_uring_cmd
> to be linked in a requeue_list.

I see. I wonder if there's some other way we can accomplish that, so we
don't have to shrink the current space. io_kiocb already support
linking, so seems like that should be workable.

>> nvme failover steals all the bios from requests that fail (and should
>> failover) and puts them on a requeue list, and then schedules
>> a work that takes these bios one-by-one and submits them on a different
>> bottom namespace (see nvme_failover_req/nvme_requeue_work).
> 
> Maybe if io_kiocb could exposed to nvme, and it had some generic space
> that nvme could use, that would work as well...

It will be more exposed in 5.20, but passthrough is already using the
per-op allotted space in the io_kiocb. But as mentioned above, there's
already linking support between io_kiocbs, and that is likely what
should be used here too.

-- 
Jens Axboe

