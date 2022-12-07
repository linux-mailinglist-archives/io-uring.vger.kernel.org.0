Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8343646327
	for <lists+io-uring@lfdr.de>; Wed,  7 Dec 2022 22:19:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229636AbiLGVTb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 7 Dec 2022 16:19:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229635AbiLGVTa (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 7 Dec 2022 16:19:30 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7BA55435B
        for <io-uring@vger.kernel.org>; Wed,  7 Dec 2022 13:19:28 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id vv4so17041191ejc.2
        for <io-uring@vger.kernel.org>; Wed, 07 Dec 2022 13:19:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LaQPWHdhAMu48Zy1Yy0GhINmV850ffyIBPcVSvfG788=;
        b=Fly/azRxMtl4hROoliNmUsyW0hEYn9mmtm2RHBOX7IjZGDcgtnfGix95vt8viB0pVg
         dvNqnaWyfWK66lareeADOOupduNa1S1W7B0UO3x/4i6vbXXpW+NnrGsSvNGT/mn5weXO
         z0c0UJ9z1KC0azogAXzEwvHGGwb8sUBHkbm/4WH/ftvEddYpDib9hxwuec+djY/xWR+V
         m69dZI03le1MW+sLNX25KmjQp6kemI2YLa+cE/0QEghmpjMSr6jp5IMKxSJ7eDe1JBaQ
         h0mzI/B0EoKRqWhFeIX8qt1poZaDj8YabHcLWypnOhPlkXNxqH7N7IajGxe5j5P6MNpu
         czSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LaQPWHdhAMu48Zy1Yy0GhINmV850ffyIBPcVSvfG788=;
        b=5arsWSuIyOaCwGEQf9cPlj/WL26UQFV+L7qb9cBLZbfcz1w7mydZiIDf3sg+jvVyI6
         nxiiNu8qFkwRBBrbqF0iZYGKRZsCSBHBEW0UfbqavJ3HqlCwNRX/20U0hE5zmjvPQS5R
         EuKcbw3gPiL/MePmPhpVl9OYqbNipN60LiuRYF0KfNbfTtArJQF8t/1V0k7Sb6lNdfnt
         riz8fI5WYmszIUS82x/VNj6tlzGHJibr/Sx02o2eSw9FRzuJOYxAOaglHd4AkaJj9tCB
         lyDEwvecKbZZTm9vLVehl/E0F8UXiuDTloeNUlmJ899PZGZl4npLlprG49uqApj1AumG
         yBFA==
X-Gm-Message-State: ANoB5plprJrA9YSMFAMD7+oT/ZZrOabgBffRumfGCcx6FiXJ7lelQu33
        Bn2HuJSJMjy3L9AwCi3oDpOKhJBv35M=
X-Google-Smtp-Source: AA0mqf61iau8qzZ1/v9v9VzyntJT/ajJkrzWO3qumEcpCZ24Cb6OEK8U52WibTToCsr5E3SWG6lI8Q==
X-Received: by 2002:a17:906:5784:b0:7c0:e987:cd6d with SMTP id k4-20020a170906578400b007c0e987cd6dmr13513575ejq.429.1670447967231;
        Wed, 07 Dec 2022 13:19:27 -0800 (PST)
Received: from [192.168.8.100] (94.196.241.58.threembb.co.uk. [94.196.241.58])
        by smtp.gmail.com with ESMTPSA id sg43-20020a170907a42b00b007bdf4340129sm1869654ejc.14.2022.12.07.13.19.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Dec 2022 13:19:26 -0800 (PST)
Message-ID: <aafe218a-4d94-7126-b11d-5abd0161fe6d@gmail.com>
Date:   Wed, 7 Dec 2022 21:18:26 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH for-next v2 11/12] io_uring: do msg_ring in target task
 via tw
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <cover.1670384893.git.asml.silence@gmail.com>
 <4d76c7b28ed5d71b520de4482fbb7f660f21cd80.1670384893.git.asml.silence@gmail.com>
 <3957b426-2391-eeaa-9e02-c8e90169ec2e@kernel.dk>
 <f36043e9-cda3-3275-d945-26d121255d2f@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <f36043e9-cda3-3275-d945-26d121255d2f@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/7/22 15:51, Jens Axboe wrote:
> On 12/7/22 8:31 AM, Jens Axboe wrote:
>> On 12/6/22 8:53?PM, Pavel Begunkov wrote:
>>> @@ -43,6 +61,15 @@ static int io_msg_ring_data(struct io_kiocb *req)
>>>   	if (msg->src_fd || msg->dst_fd || msg->flags)
>>>   		return -EINVAL;
>>>   
>>> +	if (target_ctx->task_complete && current != target_ctx->submitter_task) {
>>> +		init_task_work(&msg->tw, io_msg_tw_complete);
>>> +		if (task_work_add(target_ctx->submitter_task, &msg->tw,
>>> +				  TWA_SIGNAL))
>>> +			return -EOWNERDEAD;
>>> +
>>> +		return IOU_ISSUE_SKIP_COMPLETE;
>>> +	}
>>> +
>>
>> We should probably be able to get by with TWA_SIGNAL_NO_IPI here, no?
> 
> Considering we didn't even wake before, I'd say that's a solid yes.

I'm not so sure. It'll work, but a naive approach would also lack
IORING_SETUP_TASKRUN_FLAG and so mess with latencies when it's not
desirable.

option 1)

method = TWA_SIGNAL;
if (flags & IORING_SETUP_TASKRUN_FLAG)
	method = NO_IPI;

option 2)

task_work_add(NO_IPI);
atomic_or(IORING_SQ_TASKRUN, &ctx->rings->sq_flags);


Might be better to have one of those.

-- 
Pavel Begunkov
