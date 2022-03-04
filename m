Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E52234CCBC4
	for <lists+io-uring@lfdr.de>; Fri,  4 Mar 2022 03:33:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233102AbiCDCeO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 3 Mar 2022 21:34:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233036AbiCDCeO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 3 Mar 2022 21:34:14 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B45E7093D
        for <io-uring@vger.kernel.org>; Thu,  3 Mar 2022 18:33:27 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id qx21so14511047ejb.13
        for <io-uring@vger.kernel.org>; Thu, 03 Mar 2022 18:33:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=lvGXZEhxU1i/b+biwj5r+yYhWtgV3DXPIVaHQaTF82g=;
        b=kBr8nnoqRg32lf1Zrl3okpm4jk4sCuu31S03WNRnTb5SAsnze9LSDMAxidhuzoXdRP
         vVHHfpYBejivQBuIxr4FtcQFLUvBlOMF7PvSF/CNeWOrVqOSsgA1sFtncBz2RRGiY2I+
         dkf3rQ3XzASBXRA/QcpDunSiURLp8Bt4kGeon6Vsos+24Fvc+FLGf4UKYoLm23s310Pb
         l2c3gpoYr+kmxcnoQ5Khgp60TknoWBzmmXkRDe66wNrHhx0wAqnG8P0InKv8D8pCMo8y
         MwsIFUhk+0HleOYXHtplkq8i8DMWmryZE71SJIaYU6WGiQO0Vfs/K6y9K1rEXZDYZ+7g
         A47Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=lvGXZEhxU1i/b+biwj5r+yYhWtgV3DXPIVaHQaTF82g=;
        b=uakwEfFYHLMrqx50H4Wh16D3PIyIblp4g/MmGMViJMJJSnNQT/9JR6Q7wy8CoV8S10
         pAg4v+ELbkZKFjVgbwZxrNU8+rGVAOeiNsEd3supRZt+0YqjNF6CZz+cFGdo9kHs8tXA
         LELptvMmbRPDApTcvDIQEBoWxuBzM2TSvSF7wbYsHAMsVGtFru6UJQFsYY4hgi5Nj570
         RWxDfPcg5QFJqgG/GYh1llPR8H4aWEtm/1PUE3Y4xcwriQyamygfSrhoqTiZfOjSMSKs
         U9+scnEUalEb//QNcZdJfu7TTZ9XRHW7fBPiYeVIixMfqWyr1qXQ5YKIoY+qdRDUmbN9
         F4QQ==
X-Gm-Message-State: AOAM532oUhK5QKP/TuuokO0169g14qRrSlzJoC10C2HkLkpgrTYFUkSH
        elq7HzIVZrxPvWp20Yukiog=
X-Google-Smtp-Source: ABdhPJyOHJOEdBHXUVgMi5K/X3BxVIMPWhbKXQCxBpF+W6nYlEhkX+sWSiyduAgU8Ip1yqcEKFV4dQ==
X-Received: by 2002:a17:907:16a5:b0:6d7:cdc:9591 with SMTP id hc37-20020a17090716a500b006d70cdc9591mr11270181ejc.243.1646361204478;
        Thu, 03 Mar 2022 18:33:24 -0800 (PST)
Received: from [192.168.8.198] ([85.255.236.114])
        by smtp.gmail.com with ESMTPSA id o7-20020a17090608c700b006cef23cf158sm1257444eje.175.2022.03.03.18.33.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Mar 2022 18:33:24 -0800 (PST)
Message-ID: <5a0f0fe0-e180-90fc-aa23-4e0faa9896bc@gmail.com>
Date:   Fri, 4 Mar 2022 02:28:48 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [PATCH] io_uring: add io_uring_enter(2) fixed file support
Content-Language: en-US
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
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <bf325a86-91a4-aa70-dbda-9b12b3677a8c@kernel.dk>
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

On 3/4/22 02:18, Jens Axboe wrote:
> On 3/3/22 6:49 PM, Pavel Begunkov wrote:
>> On 3/3/22 16:31, Jens Axboe wrote:
>>> On 3/3/22 7:40 AM, Jens Axboe wrote:
>>>> On 3/3/22 7:36 AM, Jens Axboe wrote:
>>>>> The only potential oddity here is that the fd passed back is not a
>>>>> legitimate fd. io_uring does support poll(2) on its file descriptor, so
>>>>> that could cause some confusion even if I don't think anyone actually
>>>>> does poll(2) on io_uring.
>>>>
[...]
>>> which is about a 15% improvement, pretty massive...
>>
>> Is the bench single threaded (including io-wq)? Because if it
>> is, get/put shouldn't do any atomics and I don't see where the
>> result comes from.
> 
> Yes, it has a main thread and IO threads. Which is not uncommon, most
> things are multithreaded these days...

They definitely are, just was confused by the bench as I can't
recall t/io_uring having >1 threads for nops and/or direct bdev I/O

-- 
Pavel Begunkov
