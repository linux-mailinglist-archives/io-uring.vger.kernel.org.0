Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D70B66668F5
	for <lists+io-uring@lfdr.de>; Thu, 12 Jan 2023 03:38:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231803AbjALCh7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 11 Jan 2023 21:37:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230270AbjALCh6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 11 Jan 2023 21:37:58 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F30ED40871
        for <io-uring@vger.kernel.org>; Wed, 11 Jan 2023 18:37:57 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id d3so18785219plr.10
        for <io-uring@vger.kernel.org>; Wed, 11 Jan 2023 18:37:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+xNIzBPTtTRx2kuPODk3rAgC3nOVwzXC63nsQ3n3Zy0=;
        b=P8DZemtB5yYpewZqD7SRrdG6XBZ8xBDTHFzZ03Eo7eX5nu6iFg9rkJUc6OQ1aBw86v
         78BYK1TxZLvQHCpCTpwGoxkWp7mDtt10JqqbPtC8IzhqQLYMzgd+ZAqS4+a5Y4EUZBzO
         RnAGEjEiIKCSIHauu6Sc6IP7G8DSyLdfDmmLR/pw5vQAfQWZ25koGExzqDlhbIOCHikG
         OQJgyl3Wgt3zJ9rjgF2fa5BsXnaDljrtKa4Wnyo2rTao3HeAtrXKxBWHbRyx4BWWmkYl
         FOKLxv27/TopFzzCLp7kZwREmHOSsvzMfMw8K1/2Tfg8OOTnEpTNEzx/iKcHcjXU0mCT
         1WEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+xNIzBPTtTRx2kuPODk3rAgC3nOVwzXC63nsQ3n3Zy0=;
        b=0XitQRyDcbxXAF4G8K2P/+15ks3fKKvopN57V4yf/eip1l5gWO3kxWP4/5IHdXhfEI
         CffDOExdNglgZ+a2ohKFLrRF0nl+HxPpkOR1+BFkcoQLE4EbU4yPcvzJYPp6gIfjo351
         w2l1vFz6prJvHgnrwKS99sFAzvCwUSDzh7sAzGXdikTw5Fn14EB6MA8d81kLL0e7i75g
         HcMYoZoZUxvPmnlW2GKYmSFPQGaTDnvo/rUxuRdR2WDCV7olg8DWGY5tpSLKQHXWuKV5
         0yxz16GfviHhanDynRCKN0/RPa6xj3gngHzdeZ/V6djqk+qhTuCSD4rfGoydUqZPAnAb
         8cxA==
X-Gm-Message-State: AFqh2krJtjYE8plrCQirAUdfM0eK3asTvxNX2UPsieADXWU3EHSd5wqV
        q/0QhSxSbS2vusoNkKjwefDwGw==
X-Google-Smtp-Source: AMrXdXsUpZ7y8YaSgT5qCgYTFjwHKNNGRlg6WzrgVx9MxHH54c947yP/WZpRfcpeclE7Cwzb9nOFdQ==
X-Received: by 2002:a05:6a20:54a1:b0:a5:170:9acf with SMTP id i33-20020a056a2054a100b000a501709acfmr26441538pzk.3.1673491077430;
        Wed, 11 Jan 2023 18:37:57 -0800 (PST)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id t16-20020a170902b21000b0018996404dd5sm10900316plr.109.2023.01.11.18.37.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Jan 2023 18:37:56 -0800 (PST)
Message-ID: <ce641595-afb7-e134-5721-ffb4730ea4aa@kernel.dk>
Date:   Wed, 11 Jan 2023 19:37:55 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH] io_uring: Add NULL checks for current->io_uring
Content-Language: en-US
To:     Jia-Ju Bai <baijiaju1990@gmail.com>, asml.silence@gmail.com
Cc:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        TOTE Robot <oslab@tsinghua.edu.cn>
References: <20230111101907.600820-1-baijiaju1990@gmail.com>
 <63d8e95e-894c-4268-648e-35e504ea80b6@kernel.dk>
 <a2d622dc-a28e-acf7-2863-a2a0310c8697@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <a2d622dc-a28e-acf7-2863-a2a0310c8697@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/11/23 7:10 PM, Jia-Ju Bai wrote:
> 
> 
> On 2023/1/11 22:49, Jens Axboe wrote:
>> On 1/11/23 3:19 AM, Jia-Ju Bai wrote:
>>> As described in a previous commit 998b30c3948e, current->io_uring could
>>> be NULL, and thus a NULL check is required for this variable.
>>>
>>> In the same way, other functions that access current->io_uring also
>>> require NULL checks of this variable.
>> This seems odd. Have you actually seen traces of this, or is it just
>> based on "guess it can be NULL sometimes, check it in all spots"?
>>
> 
> Thanks for the reply!
> I checked the previous commit and inferred that there may be some problems.
> I am not quite sure of this, and thus want to listen to your opinions :)

I'd invite you to look over each of them separately, and see if that path
could potentially lead to current->io_uring == NULL and thus being an
issue. I think that'd be a useful exercise, and you never know that you
might find :-)

-- 
Jens Axboe


