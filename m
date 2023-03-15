Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 672AF6BBCFC
	for <lists+io-uring@lfdr.de>; Wed, 15 Mar 2023 20:10:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232625AbjCOTKe (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Mar 2023 15:10:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232237AbjCOTKd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Mar 2023 15:10:33 -0400
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0060B570B7
        for <io-uring@vger.kernel.org>; Wed, 15 Mar 2023 12:10:28 -0700 (PDT)
Received: by mail-il1-x132.google.com with SMTP id l9so7802386iln.1
        for <io-uring@vger.kernel.org>; Wed, 15 Mar 2023 12:10:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1678907428; x=1681499428;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FqIUWL49gOnBQOdYINMYdbzx0C9jJ4cqoE/J1/KRSUw=;
        b=oYYwwldYHC7TBk82xDbOuoDVKGbkRqnhpnQuu8n+RMNqKKKSp08E2HPGYf/yOWHMYq
         MkKlgIvtv5608qyQDds4vvisg0YCh1Bfn+LSZ3uGQ1DVBl9mtgT4Ka3cR4XdaywOeR8f
         YRMf0KBAamjwkOM2rVu2CFKdR4tp2qjkJYraqMT5uYg2kO9dt0ydv792YMY8fPKCraAG
         NfmGVk/lyjAa3xGkGw4ELAXHQF28nvpPj8vnOKmWIBMgqugUPgy6Mg55UP/1zIV4UcCc
         0zlMnhMl9laH6+X+fTJ1DcH0ZRszzJlR13u8gNknffRYpGi2Xs/GoDXdR2lfOQRA0dfl
         N0SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678907428; x=1681499428;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FqIUWL49gOnBQOdYINMYdbzx0C9jJ4cqoE/J1/KRSUw=;
        b=PtDu6iNj+pQ4nrkK+j/tIEkRx1MPR7RifCfAAVm8Cu0L6rYcbhq2sIbu2OsR9XZA2C
         oPv45yICcIFVBHg8sD/M3fcD3yzotzFz30pOkMcfCjtnCq8dywIOdMnG/am+yJSj69a9
         Th0EnLHAC1xzn5Kb5+klLEDhw1R86tam7pOPmKJ3VxffnSw9B33YHAUxlZVHRr6eEb4w
         oV8MK992OucOfF02oeubul1q+3n2jipap+E6YFUy/Wu1x2hohyzqGNyJE4wCzgJkk4QJ
         R+D+9LNKaqkwYQPspH43e81FmD6mGaNmvvx9TxwHUquGfn5DPksKkL97Pi4gTkQGCu1K
         pkxw==
X-Gm-Message-State: AO0yUKVlwmb+ohOCUQ0CZWZgiIWrgHNwZM5jHTfP5DLp3zSLLWHtkSIQ
        2jX9ZoH1POVIK4cbjnS3q2Frrg==
X-Google-Smtp-Source: AK7set8J26niHNh/3V/fslXVnCiDAuLHDWPShiSCV4pJIh9snXib4NM+TeRPcJUNZRJ4X0aDKEosoA==
X-Received: by 2002:a05:6e02:1a88:b0:316:67be:1b99 with SMTP id k8-20020a056e021a8800b0031667be1b99mr2730516ilv.0.1678907428255;
        Wed, 15 Mar 2023 12:10:28 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id v5-20020a02b905000000b003f8765183cesm1892370jan.87.2023.03.15.12.10.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Mar 2023 12:10:27 -0700 (PDT)
Message-ID: <ef3eb817-0851-caa2-785f-1dfe17081841@kernel.dk>
Date:   Wed, 15 Mar 2023 13:10:26 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: Resizing io_uring SQ/CQ?
Content-Language: en-US
To:     Stefan Hajnoczi <stefanha@redhat.com>
Cc:     Ming Lei <ming.lei@redhat.com>, io-uring@vger.kernel.org
References: <20230309134808.GA374376@fedora>
 <ZAqKDen5HtSGSXzd@ovpn-8-16.pek2.redhat.com>
 <2f928d56-a2ff-39ef-f7ae-b6cc1da4fc42@kernel.dk>
 <20230310134400.GB464073@fedora> <ZAtJPG3NDCbhAvZ7@ovpn-8-16.pek2.redhat.com>
 <20230315151524.GA14895@fedora>
 <bc332b16-2ef6-80ea-40c4-27547c3b2ea0@kernel.dk>
 <20230315190147.GA7517@fedora>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20230315190147.GA7517@fedora>
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

On 3/15/23 1:01?PM, Stefan Hajnoczi wrote:
> On Wed, Mar 15, 2023 at 09:19:39AM -0600, Jens Axboe wrote:
>> On 3/15/23 9:15?AM, Stefan Hajnoczi wrote:
>>> Hi Ming and Jens,
>>> It would be great if you have time to clarify whether deadlocks can
>>> occur or not. If you have any questions about the scenario I was
>>> describing, please let me know.
>>
>> I don't believe there is. In anything not ancient, you are always
>> allowed to submit and the documentation should be updated to
>> describe that correctly. We don't return -EBUSY for submits with
>> overflow pending.
> 
> Thank you both for the discussion! It has helped.

Would like to add that while I don't think ring resizing is necessary
because of any potential deadlocks, I do think CQ ring resizing would be
a useful addition to avoid networked applications using giant CQ ring
sizes by default... If we had that, you could start smaller and make it
larger if you ran into overflows.

-- 
Jens Axboe

