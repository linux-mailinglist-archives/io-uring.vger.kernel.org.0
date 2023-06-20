Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40D32736CB6
	for <lists+io-uring@lfdr.de>; Tue, 20 Jun 2023 15:05:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231825AbjFTNFN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 20 Jun 2023 09:05:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230146AbjFTNFL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 20 Jun 2023 09:05:11 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30409A1
        for <io-uring@vger.kernel.org>; Tue, 20 Jun 2023 06:05:10 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id d2e1a72fcca58-656bc570a05so1263037b3a.0
        for <io-uring@vger.kernel.org>; Tue, 20 Jun 2023 06:05:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1687266309; x=1689858309;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PTTJqhi7zGH0EwSjay56BwzxC7Umxi8EklN60Rq/4/I=;
        b=b416HFs3kTACxO95Ddt1t+J9x/nhz1oxJVWwXLBK4Wsf9tj/MdSwIXh8CfXdV+eW8x
         nHFRDax4N823A4hYi3drCf3Ti4gcbP58t6wkf/RDwUW+yMi7LuGgno3ZzuKCFnPLFXS1
         EQhDe+EbQTb07A0D0OqLdEV3by1404NgZskntwZ/25ppbXC0Qg399tPkRj73K9jm/zZo
         wbWS6kMa9oPdTeJrdT6sOFft142fr5wRjp9gvL9fN/phKlD/74rCGjugQxKuBFJo9Mmc
         OVVqXPFqQjd3Yveav+61XLnFLaeE7fqT7ZnXVxsDI8LdsmPuhREDIUqjMPRu3vReyy/q
         OxlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687266309; x=1689858309;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PTTJqhi7zGH0EwSjay56BwzxC7Umxi8EklN60Rq/4/I=;
        b=UY/UOWVwRLahyIDn1TT9c1jO/m+ef8nTfee8CXOl4Jfnkq940H1yWzB4VkQUNfppgI
         1GgyBKRscU2qdltZicK4FuO5yXkVSpOn/QkKFaLZXQouqyxCqlZDf0kktLs8tPH5Ie1q
         8tBJHZVYWt6Kywier5cmMNa5CGrm2iabDOPF3Wfyu6LfBKZ9ziNpxQRZv8+v428leaNb
         TwXZpPFOoxQ1Spi/zB3tQszP5B7lugpGr78ReaRNc07QqVnWMr+DAW94Kris/xj0C46n
         97ZL04SzOZ3ckjIvdxyz/hNB522HFgWwViEr170D0nMO2PmAcOtfHpZ1ckPKg3BkAnfI
         o6lQ==
X-Gm-Message-State: AC+VfDw4fVXc7TLhzt0EUExiS+eWzu+TOQZJryFTJdHWaOIEfkT5DvYt
        /UeXqCFX3m8zptHiFzXebnRM7AikrkzYUtYR0h8=
X-Google-Smtp-Source: ACHHUZ55cjY9yPbgqhjzLgGOAzlHZr7CyNOwA31a2gBdbWhMX8mTUSy7t3CkgxkfuMk6IlBXw9MRCw==
X-Received: by 2002:a05:6a00:339a:b0:666:ed27:2b96 with SMTP id cm26-20020a056a00339a00b00666ed272b96mr11481400pfb.1.1687266309553;
        Tue, 20 Jun 2023 06:05:09 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id x42-20020a056a000bea00b00640f1e4a811sm1321772pfu.22.2023.06.20.06.05.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Jun 2023 06:05:08 -0700 (PDT)
Message-ID: <b556ffe0-59ff-8e9a-b26f-3678269b00dd@kernel.dk>
Date:   Tue, 20 Jun 2023 07:05:07 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH] io_uring/net: disable partial retries for recvmsg with
 cmsg
Content-Language: en-US
To:     Stefan Metzmacher <metze@samba.org>,
        io-uring <io-uring@vger.kernel.org>
References: <472c1b08-0409-bd55-7c4a-6d33f07efced@kernel.dk>
 <2a7309e2-1f1e-f1a5-0b89-2b1431fc331c@samba.org>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <2a7309e2-1f1e-f1a5-0b89-2b1431fc331c@samba.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/20/23 2:26?AM, Stefan Metzmacher wrote:
> Hi Jens,
> 
>> We cannot sanely handle partial retries for recvmsg if we have cmsg
>> attached. If we don't, then we'd just be overwriting the initial cmsg
>> header on retries. Alternatively we could increment and handle this
>> appropriately, but it doesn't seem worth the complication.
>>
>> Link: https://lore.kernel.org/io-uring/0b0d4411-c8fd-4272-770b-e030af6919a0@kernel.dk/
>> Cc: stable@vger.kernel.org # 5.10+
>> Reported-by: Stefan Metzmacher <metze@samba.org>
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>
>> ---
>>
>> diff --git a/io_uring/net.c b/io_uring/net.c
>> index fe1c478c7dec..6674a0759390 100644
>> --- a/io_uring/net.c
>> +++ b/io_uring/net.c
>> @@ -788,7 +788,8 @@ int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags)
>>       flags = sr->msg_flags;
>>       if (force_nonblock)
>>           flags |= MSG_DONTWAIT;
>> -    if (flags & MSG_WAITALL)
>> +    /* disable partial retry for recvmsg with cmsg attached */
>> +    if (flags & MSG_WAITALL && !kmsg->controllen)
>>           min_ret = iov_iter_count(&kmsg->msg.msg_iter);
> 
> Isn't kmsg->controllen only used for REQ_F_APOLL_MULTISHOT?
> 
> I guess the correct value would be kmsg->msg.msg_controllen?

Gah, yes indeed it should!

> Maybe the safest change would be something like this (completely untested!):
> 
> diff --git a/io_uring/net.c b/io_uring/net.c
> index 89e839013837..1dd5322fb732 100644
> --- a/io_uring/net.c
> +++ b/io_uring/net.c
> @@ -781,14 +781,14 @@ int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags)
>      flags = sr->msg_flags;
>      if (force_nonblock)
>          flags |= MSG_DONTWAIT;
> -    if (flags & MSG_WAITALL)
> -        min_ret = iov_iter_count(&kmsg->msg.msg_iter);
> 
>      kmsg->msg.msg_get_inq = 1;
>      if (req->flags & REQ_F_APOLL_MULTISHOT)
>          ret = io_recvmsg_multishot(sock, sr, kmsg, flags,
>                         &mshot_finished);
>      else
> +        if (flags & MSG_WAITALL && !kmsg->msg.msg_controllen)
> +            min_ret = iov_iter_count(&kmsg->msg.msg_iter);
>          ret = __sys_recvmsg_sock(sock, &kmsg->msg, sr->umsg,
>                       kmsg->uaddr, flags);

I like putting it there, as MSG_WAITALL is explicitly disallowed for
multishot anyway. The check belongs in that branch rather than as a
whole.

-- 
Jens Axboe

