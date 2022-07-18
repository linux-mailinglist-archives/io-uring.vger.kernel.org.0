Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE809577927
	for <lists+io-uring@lfdr.de>; Mon, 18 Jul 2022 03:15:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231939AbiGRBOv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 17 Jul 2022 21:14:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbiGRBOu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 17 Jul 2022 21:14:50 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEBBC1147C
        for <io-uring@vger.kernel.org>; Sun, 17 Jul 2022 18:14:49 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id 70so9394694pfx.1
        for <io-uring@vger.kernel.org>; Sun, 17 Jul 2022 18:14:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=eQAZ3O9SzuCt/F9lSSXScWHLuD4SVMp78IGm0SPE7gQ=;
        b=oplNe3eVsGFmxpjamcsvfXuQqB7bMOQRGp/li++QcwqHYxmFMSLV0Gz2ek12DfzTCH
         dyVKQYtS8ih5zzNKciGS9xdwrHQsKqmHV2d8BjA1zyhWkNvLedUeetol1/nqFiSXjEzQ
         yqm17R1y80pDN++tZqvONJEH0mQjcAPVRcQJEjGetn97Ob9mBW1wZVhQvx+/gLDzvJyn
         2dQYhWwimrteU97C+76r0DzVpc8341eBvZ/duATnloMMu1VhfS53iHdHQio1n5WaHsIY
         UPPPUvM2BPPHbMwVsA8MhurbI4a6dItxgaFtleFGNKTiIRB++3jG6bOeX0fs43Kmz2L9
         wRLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=eQAZ3O9SzuCt/F9lSSXScWHLuD4SVMp78IGm0SPE7gQ=;
        b=j20ooiG/uidX/7oVNITvn24rosMQMEur1HqBQUnZ8TOPnAzEaaep4rWJH+Dq9ZPsRs
         8fYcx7WMMqa4XmE8LOiPelrynaKrytAWDtVLCDJjw3ifXbSdd8YBs/gwobA+zF1rxxvQ
         pzG7wrpZ0wo3V1zibLnI/FYTWCBJqwCAAUUD+2KN68t5IsCIghOJu5WkFK4hiEqrd2RM
         ZtK8w+DM4/Tp8Cy/lR7gVrMrw1EAdRZS4bGHxKK6QnJfhhPlPElRDESHC0BcYcG5FuO7
         /+L6sTKoYBzi7A1EYdEwEgdkUUKUFwQhtMzpaz8m5/3fpPy/WXrA4OY/YpjjA6a12VqU
         pPCg==
X-Gm-Message-State: AJIora/ogDC3a5h4WRXAjKrNMf8MhKhlc1DJH28eiiJayYsAeyMJeETj
        lENT5PX/aZvnYzBw9jB/vPN7tQ==
X-Google-Smtp-Source: AGRyM1shEIaF4JG2n1WJHxPYM2A5LlhrO1uNTpcJbBZRIunLUiGHuqOG+hHn3pUqz4eltbC0PK4HrQ==
X-Received: by 2002:a05:6a00:b4d:b0:52b:1eb1:218e with SMTP id p13-20020a056a000b4d00b0052b1eb1218emr20375015pfo.33.1658106889133;
        Sun, 17 Jul 2022 18:14:49 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id t13-20020a62d14d000000b00528a4238eadsm8076255pfl.13.2022.07.17.18.14.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 17 Jul 2022 18:14:48 -0700 (PDT)
Message-ID: <2769e603-613e-0d61-0942-511bfb97760d@kernel.dk>
Date:   Sun, 17 Jul 2022 19:14:47 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [LKP] Re: [io_uring] 584b0180f0:
 phoronix-test-suite.fio.SequentialWrite.IO_uring.Yes.Yes.1MB.DefaultTestDirectory.mb_s
 -10.2% regression
Content-Language: en-US
To:     Yin Fengwei <fengwei.yin@intel.com>,
        kernel test robot <oliver.sang@intel.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, io-uring@vger.kernel.org,
        lkp@lists.01.org, lkp@intel.com
References: <20220527092432.GE11731@xsang-OptiPlex-9020>
 <2085bfef-a91c-8adb-402b-242e8c5d5c55@kernel.dk>
 <0d60aa42-a519-12ad-3c69-72ed12398865@intel.com>
 <26d913ea-7aa0-467d-4caf-a93f8ca5b3ff@kernel.dk>
 <6d70460d-0a85-4104-9abc-dd100af99e6f@intel.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <6d70460d-0a85-4104-9abc-dd100af99e6f@intel.com>
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

On 7/17/22 6:58 PM, Yin Fengwei wrote:
> 
> 
> On 7/15/2022 11:58 PM, Jens Axboe wrote:
>> I can't really explain that either, at least not immediately. I tried
>> running with and without that patch, and don't see any difference here.
>> In terms of making this more obvious, does the below also fix it for
>> you?
> I will try the fix and let you know the result.
> 
>>
>> And what filesystem is this being run on?
> I am using ext4 and LKP are also using ext4. Thanks.

Thanks, I'll try ext4 as well (was on XFS).

-- 
Jens Axboe

