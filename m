Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F23F57089B
	for <lists+io-uring@lfdr.de>; Mon, 11 Jul 2022 18:58:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229629AbiGKQ6N (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 11 Jul 2022 12:58:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbiGKQ6M (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 11 Jul 2022 12:58:12 -0400
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFD34422EE;
        Mon, 11 Jul 2022 09:58:11 -0700 (PDT)
Received: by mail-wm1-f51.google.com with SMTP id i128-20020a1c3b86000000b003a2ce31b4f8so5358281wma.1;
        Mon, 11 Jul 2022 09:58:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=0U5+IilDXsW3BQxwBvuwuzwwHS2jIXKuQyNc4QZoJgE=;
        b=kZlLvWIjtFAtSMonjLdIsOu31jvFzCaKC5egtI0J94f2MTmceNAkf49zpgh2XyGHYu
         56VZdFUy/PFjit+hot2jp6UAJA9tOH+3/Q7Wm63qV5wxXFwHV7oJix66yI2gbhhKWeBf
         VWWa0UBoev5Sjy2ZZSRksPoVVmgx/iwuOudEvu0yCfDJgpp6oIHszHbvR2D78y0P/C8s
         oqxV2kSuY/5DHdxntGYB2fdQ2QVsGGVLT4b7/ooJ6AntxysciVwVz9v9m6bt3tu1n0g1
         lM1DjIiznM/fEZhu08eZYG1RJVbMrp1rvE/FDrFHWq3IG7Vzq9KyXMZSSyO2PzDS+ffL
         nuBQ==
X-Gm-Message-State: AJIora9RUCGUmVKhq9bS9x/FJ+G6QH32kAlfjyf5/Z2LrsD/r5OqnLiF
        zxphbgh53Ga2/C3f6m27+jE=
X-Google-Smtp-Source: AGRyM1tDTW2pN9aXI0tb3raSr2YbZRwwOSx9Vn1KdSvNg5gxK9sQ5xn3fSv9QJoTVdTn9JzqblCltg==
X-Received: by 2002:a7b:cb07:0:b0:3a2:e524:4117 with SMTP id u7-20020a7bcb07000000b003a2e5244117mr9881392wmj.54.1657558690142;
        Mon, 11 Jul 2022 09:58:10 -0700 (PDT)
Received: from [10.100.102.14] (46-117-125-14.bb.netvision.net.il. [46.117.125.14])
        by smtp.gmail.com with ESMTPSA id c8-20020a7bc848000000b003a2e7c13a3asm3450777wml.42.2022.07.11.09.58.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Jul 2022 09:58:09 -0700 (PDT)
Message-ID: <2dde0a5b-e4ce-dd44-0f4b-661c860dd5bd@grimberg.me>
Date:   Mon, 11 Jul 2022 19:58:07 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH for-next 4/4] nvme-multipath: add multipathing for
 uring-passthrough commands
Content-Language: en-US
To:     Stefan Metzmacher <metze@samba.org>,
        Kanchan Joshi <joshi.k@samsung.com>, hch@lst.de,
        kbusch@kernel.org, axboe@kernel.dk
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, asml.silence@gmail.com,
        joshiiitr@gmail.com, anuj20.g@samsung.com, gost.dev@samsung.com
References: <20220711110155.649153-1-joshi.k@samsung.com>
 <CGME20220711110827epcas5p3fd81f142f55ca3048abc38a9ef0d0089@epcas5p3.samsung.com>
 <20220711110155.649153-5-joshi.k@samsung.com>
 <3fc68482-fb24-1f39-5428-faa3a8db9ecb@grimberg.me>
 <5c71b8f6-afec-8ef6-0a70-d13e71ded79c@samba.org>
From:   Sagi Grimberg <sagi@grimberg.me>
In-Reply-To: <5c71b8f6-afec-8ef6-0a70-d13e71ded79c@samba.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
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


>>> +static inline struct nvme_uring_cmd_pdu *nvme_uring_cmd_pdu(
>>> +        struct io_uring_cmd *ioucmd)
>>> +{
> 
> Shouldn't we have a BUILD_BUG_ON(sizeof(struct nvme_uring_cmd_pdu) > 
> sizeof(ioucmd->pdu));
> here?

Probably...

>>> +    return (struct nvme_uring_cmd_pdu *)&ioucmd->pdu;
>>> +}
>>> +
> 
>>> diff --git a/include/linux/io_uring.h b/include/linux/io_uring.h
>>> index d734599cbcd7..57f4dfc83316 100644
>>> --- a/include/linux/io_uring.h
>>> +++ b/include/linux/io_uring.h
>>> @@ -15,6 +15,8 @@ enum io_uring_cmd_flags {
>>>       IO_URING_F_SQE128        = 4,
>>>       IO_URING_F_CQE32        = 8,
>>>       IO_URING_F_IOPOLL        = 16,
>>> +    /* to indicate that it is a MPATH req*/
>>> +    IO_URING_F_MPATH        = 32,
> 
> Isn't that nvme specific? If so I don't think it belongs in io_uring.h 
> at all...

Yes, it doesn't, it should be completely internal to nvme.
