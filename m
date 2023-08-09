Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF6DF7764A9
	for <lists+io-uring@lfdr.de>; Wed,  9 Aug 2023 18:05:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229707AbjHIQF3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 9 Aug 2023 12:05:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229588AbjHIQF2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 9 Aug 2023 12:05:28 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D9701FCC
        for <io-uring@vger.kernel.org>; Wed,  9 Aug 2023 09:05:27 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id d2e1a72fcca58-686f6231bdeso1813701b3a.1
        for <io-uring@vger.kernel.org>; Wed, 09 Aug 2023 09:05:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1691597127; x=1692201927;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=E9QTy9dr8+ZNn1bHJ1hCX8mOhjwLecwjkQCix/vK4XQ=;
        b=l8tGOqDHbt95zr8nEtLN3UVQf5+KFxRkuToc5WGG24+wViik7Ce5XhPk1GoPVxvVhk
         7wa8grKmuvK28Px7qazqXDlY6Tj4OouoU/Dw2noYfmc8Bh7aaUqeuKx9jBLkOqRZYzl4
         j2d96PjMKrrGlRpl0L1EPLR3o+eZ5Y6wzKnVdalU4j3eExkt8ktRqVc5tAAAVR+hflo/
         ou3GXQ7nyF2uXZtW2Rr0MkSrLi4quWRhq65IS7VDUuQGsdkCc14uWpR+r7MV6ySpWvX7
         kCI7f2gcBmCygFqrS3BXie7uh7hbFur9slliONhyHKQRG0r0uiqdW/CK1U7kW4Xz6pVZ
         ac5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691597127; x=1692201927;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=E9QTy9dr8+ZNn1bHJ1hCX8mOhjwLecwjkQCix/vK4XQ=;
        b=jMqz6bhPruU4QPmOSWHau1PnEuYMaLty3ySbpbmEsM5UqeLrcCPU7XdNpdBL7h9WVI
         UxVzqdprQoJN4E7TxX2G/xKtwh5KgME9A0PXKFWOkMiu20pdGUaiSJzxGkPz/fpsuM9S
         7MMeJ5FR0zQgpIu3Ea1ijq1IWlQBniYb7zYcX29bzt6bESLUj3N8eQ7IHlcCeJJ9oc4h
         /HNIfY4FxsA8j/V2PA6kjwSldlbt8B5JTuxUkpMocx96klwlmNP2Lcz2J3mfUwYcKL4F
         GjmjN8nYWm8MeSJ/C31FvYM2Yljsw4sEb9aBa5xVNUv2CqVHhgO1shsN4u9NHeL3vyU/
         hvAQ==
X-Gm-Message-State: AOJu0Yx2WV3zVsOMaV+NLgltOBEkSuB8xI37ocUArgIY3eCGRjAd+zEq
        7BlGT6Y+/WLxXEIhRpy/J+g7Y7wyKfcCAC5dWTA=
X-Google-Smtp-Source: AGHT+IFuJj7ONByNo1vQ+RWfNXnrO6X6FquAzOd2xjVrVK9C+v2O5b527J2WemKdCWfy5GHwKNQQSw==
X-Received: by 2002:a17:902:d486:b0:1b8:a469:53d8 with SMTP id c6-20020a170902d48600b001b8a46953d8mr3920298plg.0.1691597126944;
        Wed, 09 Aug 2023 09:05:26 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id y23-20020a17090264d700b001bb24cb9a40sm11536087pli.39.2023.08.09.09.05.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Aug 2023 09:05:26 -0700 (PDT)
Message-ID: <6f9ba65b-218b-4f6a-b856-aaed8c9f6e93@kernel.dk>
Date:   Wed, 9 Aug 2023 10:05:24 -0600
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
 <c8415dcd-7b07-4c7e-8f5e-3951bd6d6ca9@kernel.dk>
 <d75ee4c8-8751-f122-c620-edf056d048c9@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <d75ee4c8-8751-f122-c620-edf056d048c9@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/9/23 10:01 AM, Pavel Begunkov wrote:
> On 8/9/23 17:01, Jens Axboe wrote:
>> On 8/9/23 9:58 AM, Pavel Begunkov wrote:
>>> On 8/9/23 16:50, Jens Axboe wrote:
>>>> On 8/9/23 9:38 AM, Pavel Begunkov wrote:
>>>>> On 8/9/23 16:30, Jens Axboe wrote:
>>>>>> On 8/9/23 9:20 AM, Pavel Begunkov wrote:
>>>>>>> Don't keep spinning iopoll with a signal set. It'll eventually return
>>>>>>> back, e.g. by virtue of need_resched(), but it's not a nice user
>>>>>>> experience.
>>>>>>
>>>>>> I wonder if we shouldn't clean it up a bit while at it, the ret clearing
>>>>>> is kind of odd and only used in that one loop? Makes the break
>>>>>> conditions easier to read too, and makes it clear that we're returning
>>>>>> 0/-error rather than zero-or-positive/-error as well.
>>>>>
>>>>> We can, but if we're backporting, which I suggest, let's better keep
>>>>> it simple and do all that as a follow up.
>>>>
>>>> Sure, that's fine too. But can you turn it into a series of 2 then, with
>>>> the cleanup following?
>>>
>>> Is there a master plan why it has to be in a patchset? I would prefer to
>>> apply now if there are not concerns and send the second one later with
>>> other cleanups, e.g. with the dummy_ubuf series.
>>>
>>> But I can do a series if it has to be this way, I don't really care much.
>>
>> No reason other than so we don't forget. But I can just do it on top of
>> this one.
> 
> Let me know whichever way you decide to take, or I'll just pull
> and see when I get back to it.

I applied yours and did the cleanup on top, running it through the usual
testing and will send it out. So all good on this one.

-- 
Jens Axboe

