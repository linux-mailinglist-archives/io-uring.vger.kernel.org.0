Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C02777649D
	for <lists+io-uring@lfdr.de>; Wed,  9 Aug 2023 18:01:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229706AbjHIQBM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 9 Aug 2023 12:01:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229674AbjHIQBM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 9 Aug 2023 12:01:12 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB8611729
        for <io-uring@vger.kernel.org>; Wed,  9 Aug 2023 09:01:10 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id d2e1a72fcca58-6874a386ec7so1305541b3a.1
        for <io-uring@vger.kernel.org>; Wed, 09 Aug 2023 09:01:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1691596870; x=1692201670;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bJgw4KVSCRA3HAbNj31CO4swaZ93EsEoKH/DCMp81Us=;
        b=0uiy/wdfrYyceTAIDag1uWhPVWkbV76x8+o3rC2dO2S8BNxpSJtX5pPyu4qTDQcQTG
         C66RiqsCzI1H57xnvij+Onjuw5+TEQPDxsHNaVrByK/ecNwSmZYDDPIxoSDd8g9JIb/V
         W9LbNhxRTcMDXHgB2Hv59FDAhZXsItS7rnajOnnmW/tb+d7zjjrt9UNMjNkBK4NHocww
         N9S39JZdNSE4Ksqx1wJUynK252HKzHGAQcwCx5LdQ2Tj+U94g89RF5PU2REi1zWYGi+m
         jozf9IxKTASPD0LrSRiIG3p2gFxzJvraIbphxcW9EUMZD9XLw0aOG0aPeztRYjL83mHi
         GpFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691596870; x=1692201670;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bJgw4KVSCRA3HAbNj31CO4swaZ93EsEoKH/DCMp81Us=;
        b=j7dbeN9XGBq5U+sxNPhakjGHeT1vkOtML6bILKmNatRQ1oTgl8ny9Xk72ZuLacWWzw
         sCVNEI3ngEtWyTWxC5PJpZQWZGWDb/59VOIGsG3NYlRTs0GJSYV1xUi1xweY/MG6+Luq
         BJCGKuQ0Db029z3YhYcT8tYQT0fmbFA9zV4Ixvny0vjbohQ9fMAoc2jH6aMLMtX9qM3q
         OVEbLKZO+Ekq2iPTdJsXc8Lb/qquzqqolVeeQ5ysKsMv6cdMdqeM268pUevwtW4azJw3
         weBu9nMROR8/heyYpzFLvf+0W4K4E0/OyD4Pdog+5Ot5djr/vnIdgGB20NkZ7zxoOVlG
         kCyg==
X-Gm-Message-State: AOJu0Yxof56oHRZHux1cVuzwJVzf6y55Hupnu6QHZ4lx3QiCU2mnMctD
        TEWNMJeB3gZ1csJkrT8rrGxfjQ==
X-Google-Smtp-Source: AGHT+IFuGodaoZY5gqs0TVC7LrY69h5mwk4T6kYmIAcL8wRTQwn+TJMfcDoAf4C2M9riJUywiOQztg==
X-Received: by 2002:a05:6a20:8425:b0:13f:65ca:52a2 with SMTP id c37-20020a056a20842500b0013f65ca52a2mr4325524pzd.5.1691596870196;
        Wed, 09 Aug 2023 09:01:10 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id e8-20020aa78248000000b00686dd062207sm10104521pfn.150.2023.08.09.09.01.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Aug 2023 09:01:09 -0700 (PDT)
Message-ID: <c8415dcd-7b07-4c7e-8f5e-3951bd6d6ca9@kernel.dk>
Date:   Wed, 9 Aug 2023 10:01:08 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] io_uring: break iopolling on signal
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <eeba551e82cad12af30c3220125eb6cb244cc94c.1691594339.git.asml.silence@gmail.com>
 <8d0fcef6-605c-4f67-8fc6-01065eedf725@kernel.dk>
 <b2b63fdc-d683-aaa1-8938-01665f99713a@gmail.com>
 <909349d4-af18-4001-828f-fccfc3f4e0e6@kernel.dk>
 <3dd335d1-74a0-3c76-190e-c6bfb24bf317@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <3dd335d1-74a0-3c76-190e-c6bfb24bf317@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/9/23 9:58 AM, Pavel Begunkov wrote:
> On 8/9/23 16:50, Jens Axboe wrote:
>> On 8/9/23 9:38 AM, Pavel Begunkov wrote:
>>> On 8/9/23 16:30, Jens Axboe wrote:
>>>> On 8/9/23 9:20 AM, Pavel Begunkov wrote:
>>>>> Don't keep spinning iopoll with a signal set. It'll eventually return
>>>>> back, e.g. by virtue of need_resched(), but it's not a nice user
>>>>> experience.
>>>>
>>>> I wonder if we shouldn't clean it up a bit while at it, the ret clearing
>>>> is kind of odd and only used in that one loop? Makes the break
>>>> conditions easier to read too, and makes it clear that we're returning
>>>> 0/-error rather than zero-or-positive/-error as well.
>>>
>>> We can, but if we're backporting, which I suggest, let's better keep
>>> it simple and do all that as a follow up.
>>
>> Sure, that's fine too. But can you turn it into a series of 2 then, with
>> the cleanup following?
> 
> Is there a master plan why it has to be in a patchset? I would prefer to
> apply now if there are not concerns and send the second one later with
> other cleanups, e.g. with the dummy_ubuf series.
> 
> But I can do a series if it has to be this way, I don't really care much.

No reason other than so we don't forget. But I can just do it on top of
this one.

-- 
Jens Axboe

