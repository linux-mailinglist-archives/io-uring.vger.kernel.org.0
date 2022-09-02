Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADEEC5AAE06
	for <lists+io-uring@lfdr.de>; Fri,  2 Sep 2022 14:03:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235728AbiIBMDh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 2 Sep 2022 08:03:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235817AbiIBMDf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 2 Sep 2022 08:03:35 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 855DEC8883
        for <io-uring@vger.kernel.org>; Fri,  2 Sep 2022 05:03:29 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id y1so1677339plb.2
        for <io-uring@vger.kernel.org>; Fri, 02 Sep 2022 05:03:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=ymnnjSJFTR12k/tkBI7K8kYSLW/Kk0VHnoRs60FP4e4=;
        b=btd2wCza5h5L0lNq/cabcPMnXjV53/eE/Hu6qYzzVK5og6lXUhD1USFonF7Y7QtyPJ
         mkT0/6O9RGge3VoUt0IwDc9S3nisl3E/F7JdszqupRz/CfqNNBXYGisNYyVo9oc/JMHV
         tv/nw8iaENzSXHHIZU9QN7kv4UDbhgEoekGSGjlljBe/XPJPg3Iaox/1SDB+aAl3Wm3z
         vc6yaJJuEcsaBPOcLfRWIA5W77rsIrIhNSrChgyk3XTKC2N8QHLfG3LAOL2IM+YMayLx
         y03eZwVU3ULBRJzA1zcgk3uD5+XZM4sQ12xAsint5pjr9ro7yAdK7ragurvgcxKVHemC
         8MYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=ymnnjSJFTR12k/tkBI7K8kYSLW/Kk0VHnoRs60FP4e4=;
        b=BhQf4W7UJeJQDev1dbGtFVyfTs93hgDNx/fDoih6Y5BvYAN99FONACHsKu/EPm2SqP
         hcmgDRA2VJwmrRNOQey0Jzq6hvR2Oh/5TixnCCcIyn+TYJqvTMFhmpL4YKoUr79ZVz3x
         BxRVRMEZxE3b4pE9PQ3YBoW5EBR49hdX8Eh9g+wbNvebqZjW81JDMPYf4e3dEft5JMQX
         TsZa/2kqoDAq3kQU94Ez8u3/6BLiWTAeJ1YBBOPibuc7ksHiU9n6egPDrbbEvut/Mdoa
         qmsf7gUydeGmzXLQjVk3HMa0ioUqwS4zh47Tpg5QQtBy2SYURQriKOENKYEhRs99bCz7
         FNUQ==
X-Gm-Message-State: ACgBeo1p+NIj1VEgihsTMv/uwFv+xWnllK9chv9+erl9CtzUdpmdb5eo
        gsnk1LkchWCO2YD1rDH/DGk0Wg==
X-Google-Smtp-Source: AA6agR6eORGZMzkmBq04OLml1uskgq40MxXuiFJUH3jVsNVnfMuVtF9lQnsd6qyEd7Qk6j3phxOHPw==
X-Received: by 2002:a17:902:ebcb:b0:168:e3ba:4b5a with SMTP id p11-20020a170902ebcb00b00168e3ba4b5amr35251523plg.11.1662120208859;
        Fri, 02 Sep 2022 05:03:28 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id mn22-20020a17090b189600b001fd7cde9990sm5216082pjb.0.2022.09.02.05.03.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Sep 2022 05:03:28 -0700 (PDT)
Message-ID: <6fedd5a1-1353-9e71-6b3e-478810b5fc8a@kernel.dk>
Date:   Fri, 2 Sep 2022 06:03:26 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.1.2
Subject: Re: [PATCH liburing 0/4] zerocopy send API changes
Content-Language: en-US
To:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>
References: <cover.1662116617.git.asml.silence@gmail.com>
 <5aa07bf0-a783-0882-0038-1b02588c7e33@gnuweeb.org>
 <c4958f35-11e5-5dd9-83c5-609d8b16801b@gnuweeb.org>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <c4958f35-11e5-5dd9-83c5-609d8b16801b@gnuweeb.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/2/22 6:01 AM, Ammar Faizi wrote:
> On 9/2/22 6:56 PM, Ammar Faizi wrote:
>> On 9/2/22 6:12 PM, Pavel Begunkov wrote:
>>> Fix up helpers and tests to match API changes and also add some more tests.
>>>
>>> Pavel Begunkov (4):
>>>    tests: verify that send addr is copied when async
>>>    zc: adjust sendzc to the simpler uapi
>>>    test: test iowq zc sends
>>>    examples: adjust zc bench to the new uapi
>>
>> Hi Pavel,
>>
>> Patch #2 and #3 are broken, but after applying patch #4, everything builds
>> just fine. Please resend and avoid breakage in the middle.
>>
>> Thanks!
> 
> Nevermind. It's already upstream now.

Ah shoot, how did I miss that... That's annoying.

-- 
Jens Axboe


