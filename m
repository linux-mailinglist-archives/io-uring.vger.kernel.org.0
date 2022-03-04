Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5718F4CCBCB
	for <lists+io-uring@lfdr.de>; Fri,  4 Mar 2022 03:40:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232858AbiCDCky (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 3 Mar 2022 21:40:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232738AbiCDCky (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 3 Mar 2022 21:40:54 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A83F4579F
        for <io-uring@vger.kernel.org>; Thu,  3 Mar 2022 18:40:07 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id dr20so14563932ejc.6
        for <io-uring@vger.kernel.org>; Thu, 03 Mar 2022 18:40:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:references:in-reply-to:content-transfer-encoding;
        bh=n+7hfJGHFK3tcklKMnhllQjek8ThgfflqXtYyBPdZ08=;
        b=R0cMmlmjetHFKvw8twXsxHlLYNlTNFoZfaF2eHEsZx0iY+ek8pGufbPZ95Njv0fSKi
         qPvKxDukjw6lnGl6uJF1Sy/JwSRx/HV23iLvT/BH/nQLRAJHi7wEl8w7eBHqftRgjNf9
         KDTWgLo2nuRQ9cRWEwxzBxWtLguBVgORBuz6hDKmyCIiNgr7HiVMdu20nC6BNkabL58Z
         EhcxZbZ3pmVa3UMiessI4fNTGggoPxCN13uZszUKfW51ZCTYrBEF52MTVjiMcDnZnPaO
         m6dvDWWuuYtByyezInN9q03FBJrEmVexOQXvFzXkGIbMZxTnw+6yZ9B4StsqaVpeWO5x
         aW7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:references:in-reply-to
         :content-transfer-encoding;
        bh=n+7hfJGHFK3tcklKMnhllQjek8ThgfflqXtYyBPdZ08=;
        b=y75BskXSD1vaMpK441tddjAhVCTCBVVzYNWjqy8DI6DhA1584zZf/8fHzI9CsbWGfi
         GHCCPUdsMpEIN7ccru4ovbSm85vuQTa3AMgoslib8UxCun6+8R2eM+2ukZV3PjQ9yXic
         RbPXc16ZOGxm+jTFLN+kU/l/RzIdzESWm2OJ2R+RVezuj6VrBnAG8D2Re17CcocIMiKO
         YrVyMSs8jH3DlwnP6xGKlIifhgawftFSs0LKMwACFlSgq2bNroUbPXZvRQi4nTrh848a
         ldawPlvvxayYMpnQHSMbiGlVpLafslDn+MRT/8eI40EghJQbHNBpGbWhj99oTP3usACD
         0zRg==
X-Gm-Message-State: AOAM532IHUJaGSZqNvJyaECcXraBl6fWX6w945vkrIogR5SJw4qgLOnQ
        4NxAoqK/w3IDaZFTzNf/OA0=
X-Google-Smtp-Source: ABdhPJxWHL3SLL8QdSeq8UYPLxHRAplFg7GiRJF8xoeKPDOjr0HudTi0NXJTUsE5zARiAC3prclxQg==
X-Received: by 2002:a17:906:2ed1:b0:6b6:bb09:178c with SMTP id s17-20020a1709062ed100b006b6bb09178cmr29877302eji.382.1646361606096;
        Thu, 03 Mar 2022 18:40:06 -0800 (PST)
Received: from [192.168.8.198] ([85.255.236.114])
        by smtp.gmail.com with ESMTPSA id a21-20020a1709062b1500b006da814b08c6sm1251205ejg.94.2022.03.03.18.40.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Mar 2022 18:40:05 -0800 (PST)
Message-ID: <c7ef14ff-a58b-e21e-365f-324fb620f127@gmail.com>
Date:   Fri, 4 Mar 2022 02:35:30 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [PATCH] io_uring: add io_uring_enter(2) fixed file support
Content-Language: en-US
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org
References: <20220303052811.31470-1-xiaoguang.wang@linux.alibaba.com>
 <4f197b0e-6066-b59e-aae0-2218e9c1b643@kernel.dk>
 <528ce414-c0fe-3318-483a-f51aa8a407b9@kernel.dk>
 <040e9262-4ebb-8505-5a14-6f399e40332c@kernel.dk>
 <951ea55c-b6a3-59e4-1011-4f46fae547b3@kernel.dk>
 <559685fd-c8aa-d2d4-d659-f4b0ffc840d4@gmail.com>
 <bf325a86-91a4-aa70-dbda-9b12b3677a8c@kernel.dk>
 <5a0f0fe0-e180-90fc-aa23-4e0faa9896bc@gmail.com>
In-Reply-To: <5a0f0fe0-e180-90fc-aa23-4e0faa9896bc@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/4/22 02:28, Pavel Begunkov wrote:
> On 3/4/22 02:18, Jens Axboe wrote:
>> On 3/3/22 6:49 PM, Pavel Begunkov wrote:
>>> On 3/3/22 16:31, Jens Axboe wrote:
>>>> On 3/3/22 7:40 AM, Jens Axboe wrote:
>>>>> On 3/3/22 7:36 AM, Jens Axboe wrote:
>>>>>> The only potential oddity here is that the fd passed back is not a
>>>>>> legitimate fd. io_uring does support poll(2) on its file descriptor, so
>>>>>> that could cause some confusion even if I don't think anyone actually
>>>>>> does poll(2) on io_uring.
>>>>>
> [...]
>>>> which is about a 15% improvement, pretty massive...
>>>
>>> Is the bench single threaded (including io-wq)? Because if it
>>> is, get/put shouldn't do any atomics and I don't see where the
>>> result comes from.
>>
>> Yes, it has a main thread and IO threads. Which is not uncommon, most
>> things are multithreaded these days...
> 
> They definitely are, just was confused by the bench as I can't
> recall t/io_uring having >1 threads for nops and/or direct bdev I/O

fwiw, not trying to say it doesn't use threads

-- 
Pavel Begunkov
