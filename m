Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 501E5521579
	for <lists+io-uring@lfdr.de>; Tue, 10 May 2022 14:29:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241854AbiEJMcP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 10 May 2022 08:32:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241846AbiEJMbs (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 10 May 2022 08:31:48 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FF922B1672
        for <io-uring@vger.kernel.org>; Tue, 10 May 2022 05:27:50 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id q4so13709277plr.11
        for <io-uring@vger.kernel.org>; Tue, 10 May 2022 05:27:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=du4yDhodnHEyOIi1r8m2oQkXy8cXPywIx5QJzp7QBk4=;
        b=tkE4/z2gC7hFJqFppZPwkaKuBkepHya0U9Ez6A4l5FftlsAF9KmRcbsjejg8bt3pF7
         iiWYTWuCbp6AJHljsCQ/vOzqH8eElrkPPhhqt/mBf4J/nnD3jmPHrTslpwSk9h54RD1A
         iLYohAFY1yUg0aoCNcsFYcaNsmnAs6RNZ+wWGruQnUnsdDqXNiJS4aGiEH/x/9g8mBtF
         5FkQCESrihZ1sL2LqIe2Fbq9yXJk+VUo9rrJcVXAKatS58uWxGch06W08OwUOt3uDTD3
         7/bpYj8RHinUi275nNkbSKf61VrkndIN2FNu+CnRxGqDNM9E0GkIM8Bz5L4ngplFhYv1
         EkKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=du4yDhodnHEyOIi1r8m2oQkXy8cXPywIx5QJzp7QBk4=;
        b=ax4A88iWPKEQIwd+bwGYo8yYfFaMpauO58hHFujpVDI6andHfSWHzK8mmySiBVjpxw
         qb/CSZk3cmPXTCZP3SIRW9adFncM3ecJVlJQ90bVmBuDadupJVbRyBYIDQkhrbDMUQGE
         xGRBM+Jjk/d5YgKe/EHQOxfvAaZZgbW4XZwgg2T20UTPRvf/30HBiJPEtGI1RF8X9chn
         z8fPSKVe+xXP1S1W1LTUKk28iuvG2AKCPk5qg807quuh0IS4SQpYM5OtH1pFOQ4NYYDt
         pXjHlJYMNCghZM2hqw+VLdyAYDstKJNqq0GzzmqI83D7QEwQdSD9zVRUXh64PypEwR0g
         NlIg==
X-Gm-Message-State: AOAM533AVp4qttlwEIMrThv47MmvANxE3gmImcyrPd6u7HxbyqsrtjFC
        m38wkvRBTCa8KTY5kAhzm+Ic5w==
X-Google-Smtp-Source: ABdhPJwLQMY9/jSpEWFONr6GwWKBRQGkyKWRCMc3XOhrgzP/qYOsnwuMKPsFVyWLZFO3J2qErhXVTA==
X-Received: by 2002:a17:90b:180d:b0:1dc:6c19:afd3 with SMTP id lw13-20020a17090b180d00b001dc6c19afd3mr31172370pjb.84.1652185669511;
        Tue, 10 May 2022 05:27:49 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id a2-20020a170903100200b0015ef27092aasm1851269plb.190.2022.05.10.05.27.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 May 2022 05:27:49 -0700 (PDT)
Message-ID: <518a88d2-19bc-db02-1577-b0512ec0265f@kernel.dk>
Date:   Tue, 10 May 2022 06:27:48 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH 6/6] io_uring: add flag for allocating a fully sparse
 direct descriptor space
Content-Language: en-US
To:     Hao Xu <haoxu.linux@gmail.com>, io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com
References: <20220509155055.72735-1-axboe@kernel.dk>
 <20220509155055.72735-7-axboe@kernel.dk>
 <7bd84712-bff8-be4f-f4d2-8403678d8495@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <7bd84712-bff8-be4f-f4d2-8403678d8495@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/9/22 10:44 PM, Hao Xu wrote:
>> @@ -11931,6 +11937,9 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
>>           ret = io_sqe_buffers_unregister(ctx);
>>           break;
>>       case IORING_REGISTER_FILES:
>> +        ret = -EFAULT;
>> +        if (!arg)
>> +            break;
>>           ret = io_sqe_files_register(ctx, arg, nr_args, NULL);
>>           break;
>>       case IORING_UNREGISTER_FILES:
>> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
>> index b7f02a55032a..d09cf7c0d1fe 100644
>> --- a/include/uapi/linux/io_uring.h
>> +++ b/include/uapi/linux/io_uring.h
>> @@ -396,9 +396,15 @@ struct io_uring_files_update {
>>       __aligned_u64 /* __s32 * */ fds;
>>   };
>>   +/*
>> + * Register a fully sparse file sparse, rather than pass in an array of all
> 
>                                     ^space

Thanks, fixed.

>> + * -1 file descriptors.
>> + */
>> +#define IORING_RSRC_REGISTER_SPARSE    (1U << 0)
>> +
>>   struct io_uring_rsrc_register {
>>       __u32 nr;
>> -    __u32 resv;
>> +    __u32 flags;
>>       __u64 resv2;
>>       __aligned_u64 data;
>>       __aligned_u64 tags;
> 
> This looks promising, we may eliminate cqes for open/accept_direct reqs.
> 
> feel free to add,
> Reviewed-by: Hao Xu <howeyxu@tencent.com>

Added, thanks. Did you review the other ones too?

-- 
Jens Axboe

