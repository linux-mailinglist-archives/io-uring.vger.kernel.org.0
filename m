Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 996695709DB
	for <lists+io-uring@lfdr.de>; Mon, 11 Jul 2022 20:23:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229795AbiGKSW7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 11 Jul 2022 14:22:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229635AbiGKSW7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 11 Jul 2022 14:22:59 -0400
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 206E632470;
        Mon, 11 Jul 2022 11:22:58 -0700 (PDT)
Received: by mail-wr1-f54.google.com with SMTP id d16so8073685wrv.10;
        Mon, 11 Jul 2022 11:22:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=Y0P+4h7ySBU/z8rjGZsOBQC8EJ5TjD4canO3eG4CCIM=;
        b=gt0p9fXEff8IVTOG9Fk7wH7HQrwV5yg3aX+vj5LCY3117psGFbGiNccpfGdiKbULfh
         oS1A5+/1397S7YhTcIssvK1uCPTW/S2h16xbTzVCSKYx+SvJg0C+d+IZD7l0FEf5bZCi
         H6v26jxLgk9ozNvaJOeg4D6cL++S6Vy8ZZCB/+ws8Lzgya5YPjXTVUcbJwuwrvMmc9NF
         SCCIIMC6ceECxrLl7Jww7QZz6okmrePGAc8Y5SE9tsD23hIefaxVThT6kiVOhxY3yPrI
         ZoaiZdhtj7LqEIGyKPpsnorD26AB4zW27AE3Uuiodf5mfoyqGHvnCPZTOzurARzMkQbM
         gnqw==
X-Gm-Message-State: AJIora+O4AucmLHlW3JW2GpUOncaRc9jRcIeLdmKAOGiCYH24/2wAQZL
        q6yJvL55SiaP+pZ9J5tI2x0=
X-Google-Smtp-Source: AGRyM1v/8JwGwAd1zYxp9kSiFFeDIrbV06UmhKleUuhUnwMbqwvaZOddWVcI+DiLLnS0X4vWWUT+gw==
X-Received: by 2002:a5d:440f:0:b0:21d:888b:a65b with SMTP id z15-20020a5d440f000000b0021d888ba65bmr18507485wrq.655.1657563776628;
        Mon, 11 Jul 2022 11:22:56 -0700 (PDT)
Received: from [10.100.102.14] (46-117-125-14.bb.netvision.net.il. [46.117.125.14])
        by smtp.gmail.com with ESMTPSA id b13-20020a056000054d00b0021d7d251c76sm6318193wrf.46.2022.07.11.11.22.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Jul 2022 11:22:56 -0700 (PDT)
Message-ID: <96fcba9a-76ad-8e04-e94e-b6ec5934f84e@grimberg.me>
Date:   Mon, 11 Jul 2022 21:22:54 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH for-next 3/4] io_uring: grow a field in struct
 io_uring_cmd
Content-Language: en-US
From:   Sagi Grimberg <sagi@grimberg.me>
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
In-Reply-To: <43955a42-7185-2afc-9a55-80cc2de53bf9@grimberg.me>
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


>>> Use the leftover space to carve 'next' field that enables linking of
>>> io_uring_cmd structs. Also introduce a list head and few helpers.
>>>
>>> This is in preparation to support nvme-mulitpath, allowing multiple
>>> uring passthrough commands to be queued.
>>
>> It's not clear to me why we need linking at that level?
> 
> I think the attempt is to allow something like blk_steal_bios that
> nvme leverages for io_uring_cmd(s).

I'll rephrase because now that I read it, I think my phrasing is
confusing.

I think the attempt is to allow something like blk_steal_bios that
nvme leverages, but for io_uring_cmd(s). Essentially allow io_uring_cmd
to be linked in a requeue_list.

> 
> nvme failover steals all the bios from requests that fail (and should
> failover) and puts them on a requeue list, and then schedules
> a work that takes these bios one-by-one and submits them on a different
> bottom namespace (see nvme_failover_req/nvme_requeue_work).

Maybe if io_kiocb could exposed to nvme, and it had some generic space
that nvme could use, that would work as well...
