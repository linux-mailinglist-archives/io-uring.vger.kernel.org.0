Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC20B5F6F2E
	for <lists+io-uring@lfdr.de>; Thu,  6 Oct 2022 22:31:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231879AbiJFUb6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 6 Oct 2022 16:31:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230226AbiJFUb4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 6 Oct 2022 16:31:56 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B86B1BB07A
        for <io-uring@vger.kernel.org>; Thu,  6 Oct 2022 13:31:52 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id bu30so4367775wrb.8
        for <io-uring@vger.kernel.org>; Thu, 06 Oct 2022 13:31:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5hpxWTj5k+4DfozeSHnllc7/rNDh9VyJMmxvliT6CZg=;
        b=Fsi2dUaMnBoYk5En1Gi5pEJl4l1vK2J5Q8EYYj6DlqlTGLpVQrNzCHTQ/RH45zlqZJ
         YNrA8hv5QE7m3wAvk8HiBnfo6t2AUZ1XV0lo6GeygRHrPeJdZQg9sMjVcpei8iTDPX0/
         65tLoBcVFCJ1GKQegZQYjQwM8XWDYm40gtly0pGf1bQFWbOSk32AL46tUN+z53PjipQw
         lf/NQA4ZSZebdZpfetdVZOv9FISi/7k43pywkN7VfiXpR/SYs/y94ZCclj1z6T19M5W5
         f2YwV7gMMOxQUh/3jSMTZCa5OGavlHeeEE0WmG7DYgVojSHNeCIGpXdbeR9zDUJ68hi4
         2YEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5hpxWTj5k+4DfozeSHnllc7/rNDh9VyJMmxvliT6CZg=;
        b=ZXh746hgPrz5yjnxS3wmnZGEMnUH/afQWg+ISP/WNdN2R8ESA/c80ER8XkA37IpaQZ
         sIi/38A6PqBwRHINoYjfMYukXV3b9I8UgC+WtU2uj3e/ndi7dXo5aYkFOSQRwrdaXAct
         u8ZhRwscr6n5RD04C4XXOlD6432k0armyzKIZm61EBKTzQmiKGrhsTPvH2uW/PgXTAi6
         KjT84MLygQw00cZBgGGpztT2D67uZ0zhFhASCXaVp7pNHzB/rbsKwIQYzjWJiA079AOn
         eGgbbfWE70sWMqlsFgSA+E6hu5ld2gHXo6YEI7a8U9bb+4KznmGFSXJbBJivRUTAVUoT
         besA==
X-Gm-Message-State: ACrzQf06RES1JHjV6rIsuTZ31VfYl0oxy2G6n9WlsrpuKGq22iYgHVOb
        IGBBYnsN01CB6Xwc4TMULf1h/JXwtAk=
X-Google-Smtp-Source: AMsMyM4kb+nkjs2hEqV2XBLGJz6JpKcSUpPPGLtTdjZPMBIXawfyXjwD54C25aaZ4bTCiemHZdEXNw==
X-Received: by 2002:a05:6000:18a2:b0:22e:72fd:c5d0 with SMTP id b2-20020a05600018a200b0022e72fdc5d0mr1066746wri.682.1665088311098;
        Thu, 06 Oct 2022 13:31:51 -0700 (PDT)
Received: from [192.168.8.100] (94.196.209.4.threembb.co.uk. [94.196.209.4])
        by smtp.gmail.com with ESMTPSA id o19-20020a05600c511300b003b95ed78275sm384606wms.20.2022.10.06.13.31.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Oct 2022 13:31:50 -0700 (PDT)
Message-ID: <27c5613c-6333-c908-0c73-02904a8e5c37@gmail.com>
Date:   Thu, 6 Oct 2022 21:30:50 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [PATCH for-next 0/2] net fixes
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <cover.1664486545.git.asml.silence@gmail.com>
 <166449523995.2986.3987117149082797841.b4-ty@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <166449523995.2986.3987117149082797841.b4-ty@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/30/22 00:47, Jens Axboe wrote:
> On Thu, 29 Sep 2022 22:23:17 +0100, Pavel Begunkov wrote:
>> two extra io_uring/net fixes
>>
>> Pavel Begunkov (2):
>>    io_uring/net: don't update msg_name if not provided
>>    io_uring/net: fix notif cqe reordering
>>
>> io_uring/net.c | 27 +++++++++++++++++++++------
>>   1 file changed, 21 insertions(+), 6 deletions(-)
>>
>> [...]
> 
> Applied, thanks!

Hmm, where did these go? Don't see neither in for-6.1
nor 6.1-late


> [1/2] io_uring/net: don't update msg_name if not provided
>        commit: 6f10ae8a155446248055c7ddd480ef40139af788
> [2/2] io_uring/net: fix notif cqe reordering
>        commit: 108893ddcc4d3aa0a4a02aeb02d478e997001227
> 
> Best regards,

-- 
Pavel Begunkov
