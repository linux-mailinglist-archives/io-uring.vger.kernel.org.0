Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C92051E826
	for <lists+io-uring@lfdr.de>; Sat,  7 May 2022 17:31:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240302AbiEGPes (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 7 May 2022 11:34:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiEGPer (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 7 May 2022 11:34:47 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D20041323;
        Sat,  7 May 2022 08:30:59 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id x12so8465240pgj.7;
        Sat, 07 May 2022 08:30:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:to:cc:references
         :from:in-reply-to:content-transfer-encoding;
        bh=2tvdUcnG5Au0Lj5Vu9lLKQv90nWuCPTdSrNS6yusCzM=;
        b=Bzg0KMic/HwRJRl02t9zT2w8W0hTfvAnPMJ7sF+bVBxy7dUf/xA9YsxoC4+cLGuWsY
         DXEhG2zGgJFfQaVOoWAPSXOvLS4FxEG+NyxDox9IAGvqur99Mrnz/ETmmzbOX9D3YUX1
         7XtJi2rAE9L3ZsXBy34wpEn525u//0k8ikZEJIxn5OO/RFOH+06LbIY2Y6WVXgGmAV8L
         +5X+FgY3EpzJ2ruZzaimz2Z1hiIjv2rS/2Ob3eass0yDA8hdhJiUXwh5xQ7xZNptkZcT
         aQmzwi/YFF2SBlaPfq5pXXOQabLfhP04ZIjvAr38LqU0HtztJ8Gd976Pzny0vt1lp9w5
         KyJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :to:cc:references:from:in-reply-to:content-transfer-encoding;
        bh=2tvdUcnG5Au0Lj5Vu9lLKQv90nWuCPTdSrNS6yusCzM=;
        b=OWPb7sYbK9V3MV/8KIqp7mH2ZLzEIBB3K8p+oDJSiq/Z3BCSTPsOW5DtfiF2aW9/uI
         nkclxHuSvC5pL4QK81YjXWaiC2qSpq000j3VA9QSwTANORlXpJk41iBBdYEZr6p3t+6y
         bIwss/Ug0vQH2snJUtyLzcFbNPWpgQS088KMVO5FkyPiaugyjG9DrHOq8qVP+GSkvFwk
         xFdpF7d8BmTN3exaEuWTnZkRbi6TcC44p5a0VOe1anDawZpEZ5ke6ljFlSfa+p33qmzS
         AERrVQCiN+LhILApykTIipFMnPYrIb0DYwEqpE/keVU4w5fdLbaipnO+um1C4kjowiLC
         xA/Q==
X-Gm-Message-State: AOAM530iqQHAhZezCKMLVj0vb9xisH6vmqyLpqwMRoILfsRT38BT7cWe
        aolJljOf5fN/k3mUeeIRxy7CecPHphAueB+MzBc=
X-Google-Smtp-Source: ABdhPJzfz9vZV85+eBTF/syz0Bi8qzinx98fWpfxWd8ODXT6rWRHbhpivNP/k13RhAM4lDIsGUmeoQ==
X-Received: by 2002:a63:2b0a:0:b0:3c1:c906:47f with SMTP id r10-20020a632b0a000000b003c1c906047fmr6981042pgr.122.1651937459124;
        Sat, 07 May 2022 08:30:59 -0700 (PDT)
Received: from [192.168.255.10] ([203.205.141.117])
        by smtp.gmail.com with ESMTPSA id e7-20020a656bc7000000b003c14af5060fsm5394279pgw.39.2022.05.07.08.30.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 07 May 2022 08:30:58 -0700 (PDT)
Message-ID: <c55de4df-a1a8-b169-8a96-3db99fa516bb@gmail.com>
Date:   Sat, 7 May 2022 23:31:09 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.0
Subject: Re: [PATCH 1/4] io_uring: add IORING_ACCEPT_MULTISHOT for accept
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        linux-kernel@vger.kernel.org
References: <20220507140620.85871-1-haoxu.linux@gmail.com>
 <20220507140620.85871-2-haoxu.linux@gmail.com>
 <21e1f932-f5fd-9b7e-2b34-fc3a82bbb297@kernel.dk>
From:   Hao Xu <haoxu.linux@gmail.com>
In-Reply-To: <21e1f932-f5fd-9b7e-2b34-fc3a82bbb297@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SCC_BODY_URI_ONLY,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

在 2022/5/7 下午10:16, Jens Axboe 写道:
> On 5/7/22 8:06 AM, Hao Xu wrote:
>> From: Hao Xu <howeyxu@tencent.com>
>>
>> add an accept_flag IORING_ACCEPT_MULTISHOT for accept, which is to
>> support multishot.
>>
>> Signed-off-by: Hao Xu <howeyxu@tencent.com>
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> 
> Heh, don't add my SOB. Guessing this came from the folding in?Nop, It is in your fastpoll-mshot branch
https://git.kernel.dk/cgit/linux-block/commit/?h=fastpoll-mshot&id=e37527e6b4ac60e1effdc8aaa1058e931930af01
> 
>> ---
>>   include/uapi/linux/io_uring.h | 5 +++++
>>   1 file changed, 5 insertions(+)
>>
>> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
>> index 06621a278cb6..f4d9ca62a5a6 100644
>> --- a/include/uapi/linux/io_uring.h
>> +++ b/include/uapi/linux/io_uring.h
>> @@ -223,6 +223,11 @@ enum {
>>    */
>>   #define IORING_RECVSEND_POLL_FIRST	(1U << 0)
>>   
>> +/*
>> + * accept flags stored in accept_flags
>> + */
>> +#define IORING_ACCEPT_MULTISHOT	(1U << 15)
> 
> Looks like the git send-email is still acting up, this looks like
> v2?
> 

