Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B29E50A89D
	for <lists+io-uring@lfdr.de>; Thu, 21 Apr 2022 21:00:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232313AbiDUTC5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 21 Apr 2022 15:02:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1391685AbiDUTCe (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 21 Apr 2022 15:02:34 -0400
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 247BF2194
        for <io-uring@vger.kernel.org>; Thu, 21 Apr 2022 11:59:44 -0700 (PDT)
Received: by mail-io1-xd29.google.com with SMTP id p21so6316799ioj.4
        for <io-uring@vger.kernel.org>; Thu, 21 Apr 2022 11:59:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=F+/pYxMIMO+XYDJLn0b7DiBpg4CTsPc86PI/nDnbc5I=;
        b=ESljfVlp87BYxMWgVdTKaTflNIXcQlB38sW/8rK6QRmhEq7NEMTUEQoPav7Ai8umxV
         LCf4H2Jgk5pDxnhzBE+lHlyNpuQckWGwl0mUfuWQzSQ2y5uwTT6asdnp4rjjLtPNQF3b
         HHr49Hj2zD4oBm8Q3YZdxsiocOcGYMARxvoAIaJyxn7ZuRAEYwQN8SI6VK6Kam4Luhx9
         6ZaXk3owFsjVTmikYdpG4M81ndumU/08GI7RY9RpL/lMnkJDMotiUlVMqzvwY2f4CHN6
         GzAirf5D29V/U3upT8HycFXLnauYFxg8bep496qxEELt5QtahyBRl4ZCc+NblPVNTjtX
         yhpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=F+/pYxMIMO+XYDJLn0b7DiBpg4CTsPc86PI/nDnbc5I=;
        b=Qceey5ypjA9s4HDxWLxIeTxb/RSgKT8LQ/Uvjeh+T0jLQsisOJ624Z7e96PYI1/Zqg
         vTXMo+6Q195fjQo18NA9WD0U8DPZAjutJ74CKE5IShpIFLkEoigRdF0lCbL6RRRSpaHE
         7jNZ3mZmMK3m3Q2BHiZvc2b6wPfK9I9ZewJRHRs5HB0p4608+d2MRkMR6RzR/ntKeSzi
         hq1NfRW6nUcuCZc5dT88INL/JpOMkowKKu41+P5OFUI/XVM6AiSLwJ1Io9uYMlWzmDoq
         PiqWxjHVfShZC0pKxIYG9PLi6lN4qQRv+2FenoXMYNXzTl22EOpx9XpdB6u/Gd+pB08b
         Yn+Q==
X-Gm-Message-State: AOAM5336fCdc4YrYC9U+y194Q4YpJsEP22fnnjugsutkLq710ZpuY+n7
        ZcPetl6v9hhE0LkUFFNbIx6dQg+rHivq6w==
X-Google-Smtp-Source: ABdhPJxdvBOPieszcqWVUwHrlFEMSRSJh8KuU50AaVmPU6ep9ayxhs++nGDbOjWDcrvoJyjmvHbngg==
X-Received: by 2002:a6b:7e03:0:b0:654:9a7e:e382 with SMTP id i3-20020a6b7e03000000b006549a7ee382mr544680iom.126.1650567583498;
        Thu, 21 Apr 2022 11:59:43 -0700 (PDT)
Received: from [192.168.1.172] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id q7-20020a92d407000000b002cabbe6e295sm12799965ilm.4.2022.04.21.11.59.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Apr 2022 11:59:43 -0700 (PDT)
Message-ID: <7dfcf6e8-ac16-5ab1-cb71-6ef81849af82@kernel.dk>
Date:   Thu, 21 Apr 2022 12:59:42 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH v2 00/12] add large CQE support for io-uring
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Stefan Roesch <shr@fb.com>, kernel-team@fb.com,
        io-uring@vger.kernel.org
References: <20220420191451.2904439-1-shr@fb.com>
 <165049508483.559887.15785156729960849643.b4-ty@kernel.dk>
 <5676b135-b159-02c3-21f8-9bf25bd4e2c9@gmail.com>
 <2fa5238c-6617-5053-7661-f2c1a6d70356@fb.com>
 <5008091b-c0c7-548b-bfd4-af33870b8886@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <5008091b-c0c7-548b-bfd4-af33870b8886@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/21/22 12:57 PM, Pavel Begunkov wrote:
> On 4/21/22 19:49, Stefan Roesch wrote:
>> On 4/21/22 11:42 AM, Pavel Begunkov wrote:
>>> On 4/20/22 23:51, Jens Axboe wrote:
>>>> On Wed, 20 Apr 2022 12:14:39 -0700, Stefan Roesch wrote:
>>>>> This adds the large CQE support for io-uring. Large CQE's are 16 bytes longer.
>>>>> To support the longer CQE's the allocation part is changed and when the CQE is
>>>>> accessed.
>>>>>
>>>>> The allocation of the large CQE's is twice as big, so the allocation size is
>>>>> doubled. The ring size calculation needs to take this into account.
>>>
>>> I'm missing something here, do we have a user for it apart
>>> from no-op requests?
>>>
>>
>> Pavel, what started this work is the patch series "io_uring passthru over nvme" from samsung.
>> (https://lore.kernel.org/io-uring/20220308152105.309618-1-joshi.k@samsung.com/)
>>
>> They will use the large SQE and CQE support.
> 
> I see, thanks for clarifying. I saw it used in passthrough
> patches, but it only got me more confused why it's applied
> aforehand separately from the io_uring-cmd and passthrough

It's just applied to a branch so the passthrough folks have something to
base on, io_uring-big-sqe. It's not queued for 5.19 or anything like
that yet.

-- 
Jens Axboe

