Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F0C3652240
	for <lists+io-uring@lfdr.de>; Tue, 20 Dec 2022 15:15:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233792AbiLTOP4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 20 Dec 2022 09:15:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233853AbiLTOPs (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 20 Dec 2022 09:15:48 -0500
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B783E0B2
        for <io-uring@vger.kernel.org>; Tue, 20 Dec 2022 06:15:34 -0800 (PST)
Received: by mail-io1-xd29.google.com with SMTP id b192so6400051iof.8
        for <io-uring@vger.kernel.org>; Tue, 20 Dec 2022 06:15:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Q2rQqrM1gcfP+sGxUIf219tgb1pJxwug3t54uBGAQvU=;
        b=6Ia0kGilZu5LoGOXPB/jDbQXow+wo/TehEOZqpd/hSoCPtGXrmC5SLvASq2Zx9tsYl
         Pjaf7Xt0NpzCmisEVXNLdc5bBIdrMMYIwaCjy8XST6UNPJB4giK0JNz5RNOXAa8KV0Ed
         4v/dcYeR0XF2tBq9uU0NdACzgJnwcjK+kBNrkRpj6VTNFctBpYlw8PvgB78w8BkJghCi
         /9bbzYayRJgm4TWQ9S6HDMsoKW9dpUR7Rs8+ICruJuax3et/8syJh9MUlLRqMf4ieNwj
         bIIDeribB0kmk3hBWa4PRTybXBxGTVWitVt43TDJbR0ZZCq/xNVPEN2YDJsPaTurnJZn
         M+AQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Q2rQqrM1gcfP+sGxUIf219tgb1pJxwug3t54uBGAQvU=;
        b=oXjYnbswhaG/4n5/OvAoLk0t5jIKh8pC67sIEBwnCLUZQSJqFN3YGEZbwqzJisdaX7
         uKFefBc5naS4CAhb5b/X2pp+Ak+sNcA2mf9rQSaG3ODj/8698uTyGk9pZU6Sk9CP/5bC
         7OVCyJa91lv+kaTXOt/nZUNM5hRo+15WD8CBQ/Nk1cFx/KIcB/2ueAx1FXDUiWq/sY2R
         DyjB4xsFNOiBZcpYu9lz7b8nq7xfCe7z4pdeCnQ5KTGT0sZkoWc1scOfL1yC9LUkY/lp
         hIjLRK9OBP+R7kKkvfqiKkIpyAz+IFo0mdEaOXmyXVxEP0eCUVuWtqDoj1nOkwIzAICD
         u96Q==
X-Gm-Message-State: ANoB5plIacTvL1MSKdTO+NeJhWi2ZF/5+rbDCeHiOKiuOXxOnOoV4Nn4
        t+flSMioI1l03q34qUZeMXUVs81kgI1yKfjAI2s=
X-Google-Smtp-Source: AA0mqf5j1vK+/SR4rP/VpfLDUEPzV+0X+DmGaAtsgZHQkwejs7JtM5d2ooMTZ7wQJj2cVMKiOiFw2Q==
X-Received: by 2002:a05:6602:3283:b0:6dd:f251:caf7 with SMTP id d3-20020a056602328300b006ddf251caf7mr5106482ioz.0.1671545734064;
        Tue, 20 Dec 2022 06:15:34 -0800 (PST)
Received: from [192.168.1.94] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id x16-20020a029710000000b0038a53fb3911sm4709978jai.97.2022.12.20.06.15.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Dec 2022 06:15:33 -0800 (PST)
Message-ID: <1377994b-8280-0142-c018-9e7ceec01964@kernel.dk>
Date:   Tue, 20 Dec 2022 07:15:31 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH v2] io_uring/net: ensure compat import handlers clear
 free_iov
Content-Language: en-US
To:     Jiri Slaby <jirislaby@kernel.org>,
        io-uring <io-uring@vger.kernel.org>
Cc:     Pavel Begunkov <asml.silence@gmail.com>
References: <1fcaa6f3-6dc7-0685-1cb3-3b1179409609@kernel.dk>
 <bf44714f-cdc9-7b07-dff1-a0c1e2b8e437@kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <bf44714f-cdc9-7b07-dff1-a0c1e2b8e437@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/19/22 11:45 PM, Jiri Slaby wrote:
> On 19. 12. 22, 15:36, Jens Axboe wrote:
>> If we're not allocating the vectors because the count is below
>> UIO_FASTIOV, we still do need to properly clear ->free_iov to prevent
>> an erronous free of on-stack data.
>>
>> Reported-by: Jiri Slaby <jirislaby@gmail.com>
>> Fixes: 4c17a496a7a0 ("io_uring/net: fix cleanup double free free_iov init")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> 
> Tested-by: Jiri Slaby <jirislaby@kernel.org>

Thanks for testing (and reporting).

-- 
Jens Axboe


