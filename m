Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1172F51E3E9
	for <lists+io-uring@lfdr.de>; Sat,  7 May 2022 06:06:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1445495AbiEGEJM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 7 May 2022 00:09:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230269AbiEGEIv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 7 May 2022 00:08:51 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 112884D24E;
        Fri,  6 May 2022 21:05:05 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id x18so9197480plg.6;
        Fri, 06 May 2022 21:05:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:to:cc:references
         :from:in-reply-to:content-transfer-encoding;
        bh=2uSGBx/x9mOPYWvPzmpH4OCNKtIh5ITYrncfGU0t68U=;
        b=OJn6x0xlPQJmxi61DlEijhdyX+U8xCh1N3mzJwFSm/QblR/h8SvUwR0e+7IDM6OHwi
         lIRz9hpU8jR/ZXzAZqnQX0IuEnxNvJCaXJW7yXnInK4ipFRF08k4BMeh0ojAfOwYNM6/
         mFiPTu/lcybyHA8QNF7lHf98JFege9omT02ZqJF3KX7i29W3uJRGHMOPshoK0mvTik6t
         yn40kldUEh/Un1y6lvvPP9Rc/Fq7FdWm0TiEgWR9mza1DPAh97wI9pOdeP5diwyUlcT3
         c40RMuT7jpGpQJ5Xh/CdLjsA2uXdbKBws3+xh4muAeNKFcUbU4Bq0HgQu8yZ5LXaBHpU
         vqDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :to:cc:references:from:in-reply-to:content-transfer-encoding;
        bh=2uSGBx/x9mOPYWvPzmpH4OCNKtIh5ITYrncfGU0t68U=;
        b=O0o+FCyqbDUO3KJpuqqDw8jl3vE/o9hco8srjfVJsctbBhSHrAMWUDH8sl0TrSdoWC
         ir0gSh+PrhdwsPyUkiwXAEbMSiO6ORMDxvNEHsflFh7yvOS42Y68azipVUqCeKM1BTua
         z5+pF9IxFsOSJF+ZWWvkTsevcWFiMiJQKn7yi0EN5mQobpZmpGs/o4nUCKxw8Z4VEWIx
         kJpa14vbA18qorv84RhjMRb7cEtcHkVAhjJlC1rHo+v9cV1NRMQjht0t9xJsASm+88kf
         iJQGqRJ9EMc3ZH3MycXlZ+FwGoIBy+dgqG9DHFmZguCs3wyQyD75gXiOfKJiMwRdeRUA
         9HCg==
X-Gm-Message-State: AOAM531xJSKfdfrtewUHQsE/6jCSW6tWeNNDl4VAwz391eFUmxXXOFvt
        vnXrJKBldChchscMAVvJb+g=
X-Google-Smtp-Source: ABdhPJxMMSqNOk2BOOld8R+euDj52ODM+s8lfIhjVju//yigkG0BCH8SZh+UapfmTeKrUaOaU3RmmQ==
X-Received: by 2002:a17:902:ce0a:b0:156:72e2:f191 with SMTP id k10-20020a170902ce0a00b0015672e2f191mr6711375plg.76.1651896304517;
        Fri, 06 May 2022 21:05:04 -0700 (PDT)
Received: from [192.168.255.10] ([106.53.33.166])
        by smtp.gmail.com with ESMTPSA id z1-20020a170902834100b0015e8d4eb1e4sm2562330pln.46.2022.05.06.21.05.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 May 2022 21:05:04 -0700 (PDT)
Message-ID: <3011998b-74b0-3a33-9ed9-f7d4d9cb2906@gmail.com>
Date:   Sat, 7 May 2022 12:05:13 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.8.1
Subject: Re: [PATCH 1/5] io_uring: add IORING_ACCEPT_MULTISHOT for accept
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        linux-kernel@vger.kernel.org
References: <20220506070102.26032-1-haoxu.linux@gmail.com>
 <20220506070102.26032-2-haoxu.linux@gmail.com>
 <b60eb1c5-4836-5f62-315e-211a0fe03362@kernel.dk>
From:   Hao Xu <haoxu.linux@gmail.com>
In-Reply-To: <b60eb1c5-4836-5f62-315e-211a0fe03362@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

在 5/6/22 10:32 PM, Jens Axboe 写道:
> On 5/6/22 1:00 AM, Hao Xu wrote:
>> From: Hao Xu <howeyxu@tencent.com>
>>
>> add an accept_flag IORING_ACCEPT_MULTISHOT for accept, which is to
>> support multishot.
>>
>> Signed-off-by: Hao Xu <howeyxu@tencent.com>
>> ---
>>   include/uapi/linux/io_uring.h | 5 +++++
>>   1 file changed, 5 insertions(+)
>>
>> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
>> index fad63564678a..73bc7e54ac18 100644
>> --- a/include/uapi/linux/io_uring.h
>> +++ b/include/uapi/linux/io_uring.h
>> @@ -213,6 +213,11 @@ enum {
>>   #define IORING_ASYNC_CANCEL_FD	(1U << 1)
>>   #define IORING_ASYNC_CANCEL_ANY	(1U << 2)
>>   
>> +/*
>> + * accept flags stored in accept_flags
>> + */
>> +#define IORING_ACCEPT_MULTISHOT	(1U << 15)
> 
> It isn't stored in accept_flags, is it? This is an io_uring private
> flag, and it's in ioprio. Which is honestly a good place for per-op
> private flags, since nobody really uses ioprio outside of read/write
> style requests. But the comment is wrong :-)

Ah, yes, thanks for pointing it out, I forgot to update the comment
> 

