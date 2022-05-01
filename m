Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0A88516258
	for <lists+io-uring@lfdr.de>; Sun,  1 May 2022 09:01:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242704AbiEAHE7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 1 May 2022 03:04:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236606AbiEAHE5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 1 May 2022 03:04:57 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A49AB192B1;
        Sun,  1 May 2022 00:01:32 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id o69so9038297pjo.3;
        Sun, 01 May 2022 00:01:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=XJuXYg02F7GZrqi1LIe5DG6ak9PjoEuh2MqhUV/o+CI=;
        b=Y0/jZvPdTwxd5qNAoFtAQjICBif7TP4/uvNGHZ7mCVBNTf5UQZuBLBr192yhB2uGEx
         QDxEeVMT0F6NrYrr+3q/6enzJft2dUL1ybHYpJkquIl2jGDkU1E16YxjlIYESfMePOS5
         AvdLSpWsGU14DMZKwKtUpG28ZbRJ6d8HOsN9+B4h8pmgXfQlTaygGoumWj8cSZdLHBuQ
         j189Wr+YGPwMxr/LZHsw7p5GG0cVQVUq4Zi6Ptbk9wPoIGav4zbZgO9DNG3k4N0sPmhK
         jqMCHNaoESkbaHMdYS/QTUPjd1jZcDSW6IA8wEg5/rrTvUsut5omo0OVMBje4tY/yHD3
         H/8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=XJuXYg02F7GZrqi1LIe5DG6ak9PjoEuh2MqhUV/o+CI=;
        b=JTkc2wnUSsWluesO/3JWCqwt5GhzUbJinGUto1dlVPTXG5+3Pw1bVcXf2JDtLGXz1b
         oA21Uu+AmmWZ88xZ8LA6JdhEHwGiRu0I/JMg7zxsx170c8q4pvlS+oWj++oAgsKCwf7R
         r6qb4pis4spfWy8QYvonJlI/njme88D0cvr7qh7SUranqIfWm5apGaD7NAHPIgJ3BmrL
         h2K6+K+8TV37iHE1l7A0oOwN9U4C3vCyjPmluO0e/t+ecrD6DsZ4L0hQsxgcIuDXsv2j
         a/FUW6wQfS4rAyihcheBlQVOydeV/UMBHid5g8SDt4ndwCmkxe3Y/2ws/2LNqaccUpQG
         QNdg==
X-Gm-Message-State: AOAM531gMwh4AhqL5P8KrYR0MLPOpBjAbGFemEFA2UNcugfeufEDtYJj
        KHWfDDDZT8x/MIe4tvgmEl0=
X-Google-Smtp-Source: ABdhPJxjGACwujXvOQg6H2YQlGoquVq0GFnswroW1iywGoHNo2RXHSHhZT985A1E4HRMufbQD0M0/A==
X-Received: by 2002:a17:902:8644:b0:15a:3b4a:538a with SMTP id y4-20020a170902864400b0015a3b4a538amr6513889plt.146.1651388492197;
        Sun, 01 May 2022 00:01:32 -0700 (PDT)
Received: from [127.0.0.1] ([103.121.210.106])
        by smtp.gmail.com with ESMTPSA id e3-20020a170903240300b0015e8d4eb28fsm2398872plo.217.2022.05.01.00.01.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 01 May 2022 00:01:31 -0700 (PDT)
Message-ID: <b90f96e9-3209-2285-fd1d-9a7660cf5e1a@gmail.com>
Date:   Sun, 1 May 2022 15:00:04 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH 7/9] io-wq: implement fixed worker logic
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220429101858.90282-1-haoxu.linux@gmail.com>
 <20220429101858.90282-8-haoxu.linux@gmail.com>
 <015f58ed-09c1-cd27-064a-b6c0cc5580d2@kernel.dk>
From:   Hao Xu <haoxu.linux@gmail.com>
In-Reply-To: <015f58ed-09c1-cd27-064a-b6c0cc5580d2@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/30/22 21:27, Jens Axboe wrote:
> On 4/29/22 4:18 AM, Hao Xu wrote:
>> @@ -1030,6 +1101,7 @@ static bool io_wq_work_match_item(struct io_wq_work *work, void *data)
>>   static void io_wqe_enqueue(struct io_wqe *wqe, struct io_wq_work *work)
>>   {
>>   	struct io_wqe_acct *acct = io_work_get_acct(wqe, work);
>> +	struct io_wqe_acct *fixed_acct;
>>   	struct io_cb_cancel_data match;
>>   	unsigned work_flags = work->flags;
>>   	bool do_create;
>> @@ -1044,8 +1116,14 @@ static void io_wqe_enqueue(struct io_wqe *wqe, struct io_wq_work *work)
>>   		return;
>>   	}
>>   
>> +	fixed_acct = io_get_acct(wqe, !acct->index, true);
>> +	if (fixed_acct->fixed_worker_registered && !io_wq_is_hashed(work)) {
>> +		if (io_wqe_insert_private_work(wqe, work, fixed_acct))
>> +			return;
>> +	}
>> +
> 
> As per previous email, I was going to comment back saying "why don't we
> just always do hashed work on the non-fixed workers?" - but that's
> already what you are doing. Isn't this fine, does anything else need to
> get done here in terms of hashed work and fixed workers? If you need
> per-iowq serialization, then you don't get a fixed worker.

Hmm, seems we cannot accelerate serialized works with fixed worker. So
Let's make it as it is.
> 

