Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9D0F5708C4
	for <lists+io-uring@lfdr.de>; Mon, 11 Jul 2022 19:19:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229654AbiGKRTL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 11 Jul 2022 13:19:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231453AbiGKRTJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 11 Jul 2022 13:19:09 -0400
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA62727160
        for <io-uring@vger.kernel.org>; Mon, 11 Jul 2022 10:19:08 -0700 (PDT)
Received: by mail-io1-xd31.google.com with SMTP id l24so5518794ion.13
        for <io-uring@vger.kernel.org>; Mon, 11 Jul 2022 10:19:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=P/ZbOGRCMUCwsXJG1pP78JzJo4IAGqfVhKppLMaFBWM=;
        b=ZvTDraTPKziHCNOQfWr+33ekuim54lUPDbYxXKWE2zr0fyQjO4WKqYkf3iF4BtILw0
         VCqoW7E1KY3LOO1pTxYJ0SYrEUR++FL1cvVe+wvPBQUMYBFLPamH0VxWeH9EjxJVFNBm
         PJqUZtKL31NeUDwxCf4YJALbx4UYvgc3qfGgp3KqsclFq1wYPD5OWXhJUDvHkZgJoyaa
         NLbfin+YjfJAljGQ+F/veGiiTsDFYJccaJb7kWBNbd5aixAPtSoR/njWyKYmHVromzCI
         skH31e9ZZVQsBAVszOxqpFPqGMXXBwvnQlmSCASQEpzMStCHzL9g8lqUV8hcJBu9uDD+
         xnew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=P/ZbOGRCMUCwsXJG1pP78JzJo4IAGqfVhKppLMaFBWM=;
        b=pnlhC3fUjeLmVBHiyVfL6wVwIgonHm4xvHUB5AIMt9Ttc/6r66QKAZZfgZxSTIedV3
         NZ1SIgRnyJFlggdfPE92vVHiXAjTocSztesijE2Xq+jjsMMNiYfd8GP5Kolcx163hzZe
         v92cvrOmls7ALiwrjDJNi/pDm8mDIKaBTmU1b6aj1DVFxxAJQmBc9Ygn12Y2ETIict7P
         NbbqAU7e/zArmsITxM0uICepxejRMFRgBeRvJmNvWU43ejtMab/lQ8gdB57ozi9ZDPAQ
         wTZCkYJuHxLPTevuXem/uzIQE7IG0JekvZO6rc8DiIaq3ERLsB5FJMFlxB1a2t7lK34h
         kbYQ==
X-Gm-Message-State: AJIora8swKOqxNgS2U1RbolYEeP4bzyESb02Po4WbyNbNJLHYs7qZQTv
        Z7NpvQiqH4BrCL1bj7SfdmcynA==
X-Google-Smtp-Source: AGRyM1u0yeGaTkXY9HASGmsozNj1TOs2lYBlJZY0JUhajLVF/LQwTS5mu+PGSzQEJeHVH30LiVqwJg==
X-Received: by 2002:a02:c942:0:b0:339:ec11:d04e with SMTP id u2-20020a02c942000000b00339ec11d04emr10943258jao.174.1657559948356;
        Mon, 11 Jul 2022 10:19:08 -0700 (PDT)
Received: from [192.168.1.172] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id 11-20020a92180b000000b002dc3a66b4b7sm2923791ily.33.2022.07.11.10.19.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Jul 2022 10:19:07 -0700 (PDT)
Message-ID: <7ce5175e-c4dc-3af1-e47a-5966a999fdfe@kernel.dk>
Date:   Mon, 11 Jul 2022 11:19:07 -0600
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
 <11db8ab2-b41a-967e-8653-7a84b8a984c0@grimberg.me>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <11db8ab2-b41a-967e-8653-7a84b8a984c0@grimberg.me>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/11/22 11:00 AM, Sagi Grimberg wrote:
> 
>> Use the leftover space to carve 'next' field that enables linking of
>> io_uring_cmd structs. Also introduce a list head and few helpers.
>>
>> This is in preparation to support nvme-mulitpath, allowing multiple
>> uring passthrough commands to be queued.
>>
>> Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
>> Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
>> ---
>>   include/linux/io_uring.h | 38 ++++++++++++++++++++++++++++++++++++--
>>   1 file changed, 36 insertions(+), 2 deletions(-)
>>
>> diff --git a/include/linux/io_uring.h b/include/linux/io_uring.h
>> index 54063d67506b..d734599cbcd7 100644
>> --- a/include/linux/io_uring.h
>> +++ b/include/linux/io_uring.h
>> @@ -22,9 +22,14 @@ struct io_uring_cmd {
>>       const void    *cmd;
>>       /* callback to defer completions to task context */
>>       void (*task_work_cb)(struct io_uring_cmd *cmd);
>> +    struct io_uring_cmd    *next;
>>       u32        cmd_op;
>> -    u32        pad;
>> -    u8        pdu[32]; /* available inline for free use */
>> +    u8        pdu[28]; /* available inline for free use */
>> +};
> 
> I think io_uring_cmd will at some point become two cachelines and may
> not be worth the effort to limit a pdu to 28 bytes...


-- 
Jens Axboe

