Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5DDB54CA0B
	for <lists+io-uring@lfdr.de>; Wed, 15 Jun 2022 15:44:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344977AbiFONny (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Jun 2022 09:43:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234848AbiFONnx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Jun 2022 09:43:53 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20E7F286E8
        for <io-uring@vger.kernel.org>; Wed, 15 Jun 2022 06:43:51 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id y19so23332933ejq.6
        for <io-uring@vger.kernel.org>; Wed, 15 Jun 2022 06:43:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=scylladb-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:organization:in-reply-to:content-transfer-encoding;
        bh=CFQ8RN+Hg1IGsxkaaffio3fa6mKwpFL+qwSmBIORXqk=;
        b=L3gmWCbQjyBQZVnOVbeii17W0o0CzZCDleSO/DhsYy/+5aJlOmIthi8nbLmK/YtNcD
         w57Mm+GxMewQdgIfZtuL4p0GzdUGwhiTrijmPRavjm0ZYln1w+2WuhBruDGIEl5H5FH+
         uZYKl6cornf0hBgdPW9QAWqMZytpfXhNXDe1ERitA8MF8bust1N39nGWvABy507VBDqh
         hU5NDxmBuZndkc6C0KE/oIvMgjRgfoIp2DGb6MVAnumTBCGbNlndAy+1f4WABRl/FzFn
         UCEyhXAOnVmW4vt3mig/g9kCg0bAfab9TqOt/j3YYU7/NcqNmPH+jpVbG0k8EnXuHb40
         aj+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=CFQ8RN+Hg1IGsxkaaffio3fa6mKwpFL+qwSmBIORXqk=;
        b=FguLVYnXz+8VPkWx6RcuHQwCUjn/0MSJ8QD/KzYquZLJ7FTx+Eb2l8nST+JyzOuUAQ
         PUHosSPpXbIZ820XqXa39PvZBk1eB7qyprbTqg38BU6Ydq/bIPXK6blC0i7LM52Pmjcl
         4jl01fTIOGqRmNsUlzyzEh+Vdh8PsiqF7+xx5MrPr6W9089DJpNjxeVFmoptFV3lzXhU
         VNoBCYLXSFo7pv2h57b+YH/XKFTbZZyj+IXlDV9q5d6JBUWlNKvHX13SS5giZr8iiWLe
         0/VwjJl4FFVrZCYQHRKVUdwuz0FPMloAcgK+xoBXlq/b3e6N6SoEQnA0PJOee9HFw93f
         xKmg==
X-Gm-Message-State: AOAM531XiVx1EGXL85Ia5ZAuvAs8zEq2lNvR4Z+p402bNB/4GoMKGZ6Q
        umOwoX2yjxvdUJq5j08ssfOZ1VRX+vlqd+0Q
X-Google-Smtp-Source: ABdhPJy0L3Yzx4U6LOok0jdu9XxGaR4vzPXKQbe1mRKTqStOnloaFHy2Doty+awA7VhSaaIZ5naSRA==
X-Received: by 2002:a17:906:38d0:b0:715:8483:e01e with SMTP id r16-20020a17090638d000b007158483e01emr9054583ejd.265.1655300629639;
        Wed, 15 Jun 2022 06:43:49 -0700 (PDT)
Received: from [10.0.0.1] (system.cloudius-systems.com. [199.203.229.89])
        by smtp.gmail.com with ESMTPSA id gx7-20020a170906f1c700b006fe8ec44461sm6332402ejb.101.2022.06.15.06.43.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Jun 2022 06:43:48 -0700 (PDT)
Message-ID: <abd9d8d3-9fc6-75d1-33fa-19571293b426@scylladb.com>
Date:   Wed, 15 Jun 2022 16:43:46 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: IORING_OP_POLL_ADD slower than linux-aio IOCB_CMD_POLL
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org
References: <9b749c99-0126-f9b2-99f5-5c33433c3a08@scylladb.com>
 <9e277a23-84d7-9a90-0d3e-ba09c9437dc4@kernel.dk>
 <e7ffdf1e-b6a8-0e46-5879-30c25446223d@scylladb.com>
 <b585d3b4-42b3-b0db-1cef-5d6c8b815bb7@kernel.dk>
 <e90bfb07-c24f-0e4d-0ac6-bd67176641fb@scylladb.com>
 <8e816c1b-213b-5812-b48a-a815c0fe2b34@kernel.dk>
 <16030f8f-67b1-dbc9-0117-47c16bf78c34@kernel.dk>
 <4008a1db-ee26-92ba-320e-140932e801c1@kernel.dk>
 <1d79b0e6-ee65-6eab-df64-3987a7f7f4e7@scylladb.com>
 <95bfb0d1-224b-7498-952a-ea2464b353d9@gmail.com>
 <991a999b-0f85-c0a3-c364-4b3ecfef9106@scylladb.com>
 <85b5d99e-69b4-15cf-dfd8-a3ea8c120e02@scylladb.com>
 <35a1fca7-a355-afbf-f115-8f154d8bdec6@gmail.com>
 <4612ee3b-a63c-2374-9fc1-db099b2f6d78@kernel.dk>
From:   Avi Kivity <avi@scylladb.com>
Organization: ScyllaDB
In-Reply-To: <4612ee3b-a63c-2374-9fc1-db099b2f6d78@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


On 15/06/2022 15.21, Jens Axboe wrote:
> On 6/15/22 5:38 AM, Pavel Begunkov wrote:
>>>>> Another way is to also set IORING_SETUP_TASKRUN_FLAG, then when
>>>>> there is work that requires to enter the kernel io_uring will
>>>>> set IORING_SQ_TASKRUN in sq_flags.
>>>>> Actually, I'm not mistaken io_uring has some automagic handling
>>>>> of it internally
>>>>>
>>>>> https://github.com/axboe/liburing/blob/master/src/queue.c#L36
>>>>>
>>> Is there documentation about this flag?
>> Unfortunately, I don't see any.
>> Here is a link to the kernel commit if it helps:
>>
>> https://git.kernel.dk/cgit/linux-block/commit/?h=ef060ea9e4fd3b763e7060a3af0a258d2d5d7c0d
>>
>> I think it's more interesting what support liburing has,
>> but would need to look up in the code. Maybe Jens
>> remembers and can tell.
> It is documented, in the io_uring.2 man page in liburing:
>
> https://git.kernel.dk/cgit/liburing/tree/man/io_uring_setup.2#n200
>

Perfect. Thanks!


