Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0AF9723382
	for <lists+io-uring@lfdr.de>; Tue,  6 Jun 2023 01:05:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231360AbjFEXFH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 5 Jun 2023 19:05:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229740AbjFEXFG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 5 Jun 2023 19:05:06 -0400
Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9582F10B;
        Mon,  5 Jun 2023 16:05:00 -0700 (PDT)
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-4f14e14dc00so827607e87.1;
        Mon, 05 Jun 2023 16:05:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686006299; x=1688598299;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CCrWbhU4kEcfY652bfVS5L1eCaIUS1TtdSbSuvq6gTo=;
        b=UaKwmRB/NRXr4uV5zaiXLUrOnpMs1XS8WKGTXMJKK9mkfYxCm9R6Kgcxa8yRBP6ykd
         3sMZ8GdNc5Fns9ohx0k/i7gSCTtdODYBYvgXItQDmfa2nX57Zv23Tm+e+DnvPjE5O957
         ZsxFJkNGsvjwDWtwEa7f1FKGEYJUycYyVfdIOm4nsnR3OgI/kVPCBMpAfMUCJ76xrjrR
         f9LycAkHkwwDT5C+6ISTRcKwV7uE+b7FoCbB42f2M7yTbMtTfQD/s8pAEbk5imoUHvNv
         r51La0y0z/yrUoQPHVzK9ont2WWI1yRXXfmKJ8quae3aZE/GQSyJi39Wpos1QLQ9skoF
         MmLA==
X-Gm-Message-State: AC+VfDwjf0DQ36gIiDjqMe3VhZXMqsZvvZ+VesfeEKmxe34PxptCiCa4
        x8nHmZrMjAQi5N+X+H3s4c4mpZzjX2k=
X-Google-Smtp-Source: ACHHUZ6asdsWa+E7QgS0377yLsLLAEZv6NA67XW+1AAwmRpliqB/AZG5eZ1cJ51D0mDHSlvWxPDHxQ==
X-Received: by 2002:a05:6512:407:b0:4f6:a2f:beb with SMTP id u7-20020a056512040700b004f60a2f0bebmr148655lfk.5.1686006298631;
        Mon, 05 Jun 2023 16:04:58 -0700 (PDT)
Received: from [10.100.102.14] (46-117-190-200.bb.netvision.net.il. [46.117.190.200])
        by smtp.gmail.com with ESMTPSA id c27-20020ac2531b000000b004f61a57797fsm985305lfh.60.2023.06.05.16.04.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Jun 2023 16:04:58 -0700 (PDT)
Message-ID: <fe8be97e-ac6e-50fa-edde-59ac647f01a2@grimberg.me>
Date:   Tue, 6 Jun 2023 02:04:56 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH 2/2] nvme: improved uring polling
Content-Language: en-US
To:     Keith Busch <kbusch@meta.com>, linux-block@vger.kernel.org,
        io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        hch@lst.de, axboe@kernel.dk
Cc:     joshi.k@samsung.com, Keith Busch <kbusch@kernel.org>
References: <20230530172343.3250958-1-kbusch@meta.com>
 <20230530172343.3250958-2-kbusch@meta.com>
From:   Sagi Grimberg <sagi@grimberg.me>
In-Reply-To: <20230530172343.3250958-2-kbusch@meta.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Looks nice,

Reviewed-by: Sagi Grimberg <sagi@grimberg.me>

I'll look again after the rebase.
