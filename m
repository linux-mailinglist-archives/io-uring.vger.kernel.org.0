Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A4A760FC84
	for <lists+io-uring@lfdr.de>; Thu, 27 Oct 2022 17:57:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234985AbiJ0P5x (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 27 Oct 2022 11:57:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235771AbiJ0P5w (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 27 Oct 2022 11:57:52 -0400
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29EC01958DB
        for <io-uring@vger.kernel.org>; Thu, 27 Oct 2022 08:57:49 -0700 (PDT)
Received: by mail-io1-xd31.google.com with SMTP id e15so1925722iof.2
        for <io-uring@vger.kernel.org>; Thu, 27 Oct 2022 08:57:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Pas1WX3H87fXF5p+UUEQ5NJ3TGbI2xsm6zyaQAYIQ6I=;
        b=xjQhiK0DEoToHfXjqX9YjCXTSfCsJ0SVw7FOEHY+nphVOmvsiMCsEf4o29oEA8GtKh
         Q3+inBPn5QRN8Jz1NN9I2Qxo1pAY5IA+jWc+Fv6Chbu2XZdlOQWMMIzJbYLnMw92OgqN
         tLspPtx/RRYRIANeO5K0+xVLQP1WLAC4gDrXzBulRGPjx/OcPocrpac83MK1wOOmWqMu
         Zt52ajrYXUiKC2NGPkDQHNkhWqrDNPaQts4dXGkfcSstJL8dFabqcacJDrKhUcgnR+ah
         8JBL/AKGon1wQc1i2Mliw3hMg/h0G2ahrFwfNw1wTAJ0Qig8eHBOLMlfc53jL0uCxxQy
         dYcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Pas1WX3H87fXF5p+UUEQ5NJ3TGbI2xsm6zyaQAYIQ6I=;
        b=tSP2ls8n5u1hjCy/seWIEgmxq4wnWQP5MWk2BwcXjNsdBN5nriFGujmAoH5XcUkBfj
         jyd/KuZPKZl5jMP3w98P2HA1OAQebF4qytm4mxwElpN2fqY7mcAW3E4Tp1qutQH2OKsX
         /nm8MdzLudtN05KvN6d+4LIZP22qOuRwy+1bDvrpR9KWwFbZHacTxHNTCCac0wuqZPln
         w+ESGHPuD7O6ThRLgQYnwmRrE1IOXf1XXbkkgWWdlW7zhRdjS6VGaKpFni9W7Nh2FKRC
         4DgcKxo18VszGaqvMw7RabNkaXaCrtjfxY6Ygd/Y/s3/oxIMsop3hMBrrOs5g7OudV5O
         5yOQ==
X-Gm-Message-State: ACrzQf2jYEVXUuXX25l/ddlHNo7Uz68rJiXAgQxF2CF7UgAYy4TtujOj
        5E5K+gcDmZix4FyoJomjQfjlz4puNFu1tch2
X-Google-Smtp-Source: AMsMyM7LOO0Yhe6ZaozallFvBhy/HdhXil4761fxAmoWBkdG8uhEHzsSW4dFtxKQ2Z+dIDzIYEhS0w==
X-Received: by 2002:a05:6602:2ccf:b0:6bc:d52f:a323 with SMTP id j15-20020a0566022ccf00b006bcd52fa323mr30253401iow.152.1666886268446;
        Thu, 27 Oct 2022 08:57:48 -0700 (PDT)
Received: from [192.168.1.94] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id c96-20020a029669000000b00363dbee10b1sm698714jai.78.2022.10.27.08.57.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Oct 2022 08:57:47 -0700 (PDT)
Message-ID: <d968faa4-a25c-3bc5-abd4-9016fcb3cc2f@kernel.dk>
Date:   Thu, 27 Oct 2022 09:57:46 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.3
Subject: Re: [PATCH 0/2] io_uring: fix locking in __io_run_local_work
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Dylan Yudaken <dylany@meta.com>
Cc:     kernel-team@fb.com, io-uring@vger.kernel.org
References: <20221027144429.3971400-1-dylany@meta.com>
 <166688596303.4196.7993542008383265110.b4-ty@kernel.dk>
In-Reply-To: <166688596303.4196.7993542008383265110.b4-ty@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/27/22 9:52 AM, Jens Axboe wrote:
> On Thu, 27 Oct 2022 07:44:27 -0700, Dylan Yudaken wrote:
>> If locked was not set in __io_run_local_work, but some task work managed
>> to lock the context, it would leave things locked indefinitely.  Fix that
>> by passing the pointer in.
>>
>> Patch 1 is a tiny cleanup to simplify things
>> Patch 2 is the fix
>>
>> [...]
> 
> Applied, thanks!
> 
> [1/2] io_uring: use io_run_local_work_locked helper
>       commit: 8de11cdc96bf58b324c59a28512eb9513fd02553
> [2/2] io_uring: unlock if __io_run_local_work locked inside
>       commit: b3026767e15b488860d4bbf1649d69612bab2c25

I made the WARN_ON() -> WARN_ON_ONCE() edit and added a small
comment as well, while applying.

-- 
Jens Axboe


