Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C6F9570A34
	for <lists+io-uring@lfdr.de>; Mon, 11 Jul 2022 20:58:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229690AbiGKS6Q (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 11 Jul 2022 14:58:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229618AbiGKS6P (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 11 Jul 2022 14:58:15 -0400
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 412D72981D;
        Mon, 11 Jul 2022 11:58:14 -0700 (PDT)
Received: by mail-wr1-f54.google.com with SMTP id d16so8181084wrv.10;
        Mon, 11 Jul 2022 11:58:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=2j3XSLAEiPG8zbDWGsooYqPI2DkCsxM8IRL9IlmyISo=;
        b=bfuvH9Ln4Ui6UtTm5WQURTe3sIDNZSkBlBNDMZQbrVIm79TJ+YDWKlpG7V+qCaXk0k
         p08i96YHhVkAFYXPgaVSVPBWBnBQu6AlKdGHB+g5M/nR38Hgd2fvOuViIPl/YtWELL3U
         SBNkumyIW8boKUEI7gw5uFZu//NVo2uFWz006AoYZjyH/ZlMr+0DHoVLz28QEsqHdOws
         aeZDkWeu5WC43LkEEFSDjo8eRu2Y76m5+6G949JLaQASYWN1vsmjZG97BaSV2pENhCaL
         g4h+fMHLsig2t9AX1jKl6Wv/BTNoEDnk1kcDd170+ijIB4/DjZintko1gfwq2llfHAt2
         V5dw==
X-Gm-Message-State: AJIora9ChVwe3Qz9zVWVnbxuZ8z4vimLAdw5ySLc9mfOjXVKdprLUzUP
        MW4lG0ZlUbiVrhIF/G8Qw0c=
X-Google-Smtp-Source: AGRyM1uSN6+c9RwIsoZsZxFpEMndlkJzBtm/pGf9nH2yMuHqqVcX8CbL/p+gBklnUxsP/kRuIPQI2Q==
X-Received: by 2002:a5d:67c4:0:b0:21d:6d91:7b1a with SMTP id n4-20020a5d67c4000000b0021d6d917b1amr18384998wrw.313.1657565892805;
        Mon, 11 Jul 2022 11:58:12 -0700 (PDT)
Received: from [10.100.102.14] (46-117-125-14.bb.netvision.net.il. [46.117.125.14])
        by smtp.gmail.com with ESMTPSA id p129-20020a1c2987000000b003a17ab4e7c8sm11109872wmp.39.2022.07.11.11.58.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Jul 2022 11:58:12 -0700 (PDT)
Message-ID: <28ccfab7-eb0f-c4fc-2bc2-fb1268cc844f@grimberg.me>
Date:   Mon, 11 Jul 2022 21:58:10 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH for-next 3/4] io_uring: grow a field in struct
 io_uring_cmd
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>, Kanchan Joshi <joshi.k@samsung.com>,
        hch@lst.de, kbusch@kernel.org
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, asml.silence@gmail.com,
        joshiiitr@gmail.com, anuj20.g@samsung.com, gost.dev@samsung.com
References: <20220711110155.649153-1-joshi.k@samsung.com>
 <CGME20220711110824epcas5p22c8e945cb8c3c3ac46c8c2b5ab55db9b@epcas5p2.samsung.com>
 <20220711110155.649153-4-joshi.k@samsung.com>
 <2b644543-9a54-c6c4-fd94-f2a64d0701fa@kernel.dk>
 <43955a42-7185-2afc-9a55-80cc2de53bf9@grimberg.me>
 <96fcba9a-76ad-8e04-e94e-b6ec5934f84e@grimberg.me>
 <7fb16d2a-21f4-3380-75f3-c8e8c08fd318@kernel.dk>
From:   Sagi Grimberg <sagi@grimberg.me>
In-Reply-To: <7fb16d2a-21f4-3380-75f3-c8e8c08fd318@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


>>>>> Use the leftover space to carve 'next' field that enables linking of
>>>>> io_uring_cmd structs. Also introduce a list head and few helpers.
>>>>>
>>>>> This is in preparation to support nvme-mulitpath, allowing multiple
>>>>> uring passthrough commands to be queued.
>>>>
>>>> It's not clear to me why we need linking at that level?
>>>
>>> I think the attempt is to allow something like blk_steal_bios that
>>> nvme leverages for io_uring_cmd(s).
>>
>> I'll rephrase because now that I read it, I think my phrasing is
>> confusing.
>>
>> I think the attempt is to allow something like blk_steal_bios that
>> nvme leverages, but for io_uring_cmd(s). Essentially allow io_uring_cmd
>> to be linked in a requeue_list.
> 
> I see. I wonder if there's some other way we can accomplish that, so we
> don't have to shrink the current space. io_kiocb already support
> linking, so seems like that should be workable.
> 
>>> nvme failover steals all the bios from requests that fail (and should
>>> failover) and puts them on a requeue list, and then schedules
>>> a work that takes these bios one-by-one and submits them on a different
>>> bottom namespace (see nvme_failover_req/nvme_requeue_work).
>>
>> Maybe if io_kiocb could exposed to nvme, and it had some generic space
>> that nvme could use, that would work as well...
> 
> It will be more exposed in 5.20, but passthrough is already using the
> per-op allotted space in the io_kiocb. But as mentioned above, there's
> already linking support between io_kiocbs, and that is likely what
> should be used here too.

Agree. I don't think there is an issue with passing uring_cmd() an
io_kiocb instead of a io_uring_cmd which is less space strict.
