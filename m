Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 647855A15E8
	for <lists+io-uring@lfdr.de>; Thu, 25 Aug 2022 17:38:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236857AbiHYPiU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 25 Aug 2022 11:38:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233199AbiHYPiT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 25 Aug 2022 11:38:19 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 497D4B7EC4
        for <io-uring@vger.kernel.org>; Thu, 25 Aug 2022 08:38:18 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id n17so506320wrm.4
        for <io-uring@vger.kernel.org>; Thu, 25 Aug 2022 08:38:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=JCFXzljAH4yeFMAv85o1Oh4m1O0naqGeJsOmAk9rEjg=;
        b=AllZBJ00oGrsLm0pd3z5mHsgLlQdiRbhD/Cu929wyvUYqtkk+h+e88n7cN6RdvBSMT
         QoBGZjD25lVsQudeaVww9T41h8EdcA6U+kHk09w34bNVvTUifBd/Hdwig/qeQiBKweak
         wu9J06iRBfV9x61kXKCAGGld4SAm5oxubGArWgqlTd/MM7rAvPjfNbLyZ6eTDGDRlJge
         ZnBFgo0OuAaEyUHE9G9ojD8q/JeXsE0aUDhvsmSB+nBNyt68Y3a2bRaXduGdvdftxbX6
         KymJebjPrcvPHD1ulsKlCYP5EtHlGlp8O8hJ0yeuXH+kBbtIcmDE8dnTp5t4jfuZ0Wyc
         UF/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=JCFXzljAH4yeFMAv85o1Oh4m1O0naqGeJsOmAk9rEjg=;
        b=DNVCmhfmrxwT4yvSyvAtw3QChJdcRly1rumOrrrG05BNZKJOgEcDEL30Hb0JK+aOsN
         v5W70my/Tzy8sH3Aa8EVYj4IHVkhdf0cHj1//Xc5Wnx0MRf+zi+IXKR/pQvles6hPMgN
         DMkniNagkmA1K0EJxJxKjKKKeoi1e0Yux7DPItRl5ndPuJDM2oOUnzdnQSmQLR6ADHN3
         v75OnSXW3T9dvs8mDbmeSknOXa8/U0InlzwUu1A0yObswuJQIGV0tctHCCJRlrK51moM
         z2k6FTM8TdcEI6WHTEYWZKw8NuLik+3M/THWqre8HhJGs/yBb5dCTXSi4g6hn3dtyOhx
         VJCg==
X-Gm-Message-State: ACgBeo2/W4PkkBx213fFBwqc4UElcifSFbND7ziATQl/2ICr33IUqZmb
        WzUM5XFgYzvoxyP50bXYKyzjNwyAEwnUQw==
X-Google-Smtp-Source: AA6agR66Nyi74mwbGxQAV4x1RJmfeK5Z3omaUnWiK7Dxuu/0xhelfE2dnDHVIAjfy1aVKLlL8gA77w==
X-Received: by 2002:adf:e58d:0:b0:225:6ba2:3a2a with SMTP id l13-20020adfe58d000000b002256ba23a2amr2778013wrm.250.1661441896813;
        Thu, 25 Aug 2022 08:38:16 -0700 (PDT)
Received: from [192.168.8.198] (188.28.126.24.threembb.co.uk. [188.28.126.24])
        by smtp.gmail.com with ESMTPSA id bh19-20020a05600c3d1300b003a2f6367049sm6030396wmb.48.2022.08.25.08.38.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Aug 2022 08:38:16 -0700 (PDT)
Message-ID: <4bd4f1f9-eb9d-1b0b-a9e6-293249b481c7@gmail.com>
Date:   Thu, 25 Aug 2022 16:37:15 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH] io_uring/net: fix uninitialised addr
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <52763f964626ec61f78c66d4d757331d62311a5b.1661421007.git.asml.silence@gmail.com>
 <e77d4686-6a2d-fabf-0e25-b10bd9262984@gmail.com>
 <1784b4f3-a66a-50e3-4105-6897c4803f58@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <1784b4f3-a66a-50e3-4105-6897c4803f58@kernel.dk>
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

On 8/25/22 14:52, Jens Axboe wrote:
> On 8/25/22 4:13 AM, Pavel Begunkov wrote:
>> On 8/25/22 11:11, Pavel Begunkov wrote:
>>> Don't forget to initialise and set addr in io_sendzc(), so if it goes
>>> async we can copy it.
>>
>> Jens, can you amend it into the last commit?
>> ("io_uring/net: save address for sendzc async execution")
> 
> Yes, I'll amend it. But do we have a test case that hits this path?
> Because it seems like that would've blown up immediately.

Apparently a test I have only hits io_sendzc_prep_async() callback
and the large buffer test doesn't trigger it. Hard to trigger it
with udp and addresses don't make sense with tcp.

-- 
Pavel Begunkov
