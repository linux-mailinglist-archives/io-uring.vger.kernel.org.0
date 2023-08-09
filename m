Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49E3E7764A0
	for <lists+io-uring@lfdr.de>; Wed,  9 Aug 2023 18:03:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229929AbjHIQDP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 9 Aug 2023 12:03:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229674AbjHIQDO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 9 Aug 2023 12:03:14 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B542B1736
        for <io-uring@vger.kernel.org>; Wed,  9 Aug 2023 09:03:12 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id a640c23a62f3a-99c0290f0a8so4013166b.1
        for <io-uring@vger.kernel.org>; Wed, 09 Aug 2023 09:03:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1691596991; x=1692201791;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5qpowmlUhGvqd/9WtcxEefI0RdtBtq4R4YE4/Dc6HAs=;
        b=V25sTvyXG4Qp5XRnJ6rTDqGAJlIDOwWm5Yp0RXPvd5kDBtb+KERbEwhSvfOiTdOKRB
         yABuFmEBHSFMXNODE8sEMVRugiHzOflbQnAnmZcnsOEMi8svecJxMMkzS5ByBCcjRbgo
         ostinjPv/lYoHnZbrjtRTOG5N06UTiygQkF+2dUbOXicXDd6ZBxTLWUjUIkvDqj5iMgM
         zBel/MRXDZvWMMN9LggzAxBydiQS0JABhJZgpTDymB8bS8+mz/nIGD8yMmA5IYTExMJ3
         eyPH/Qqlyq5gNV5ROWQballJPthHePlZ7JCQW10gkT/fjzG0YBuQKWar2ruu4Ytd1Cnn
         pUrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691596991; x=1692201791;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5qpowmlUhGvqd/9WtcxEefI0RdtBtq4R4YE4/Dc6HAs=;
        b=hoe0hJGmf1DkzqZJ7Xy7d5XPkRo1zlvQumPS5cKmgD7SxBR7ExhxI+YVb4CFEdiIZl
         TN5L6sl9RBV278/MF3ZiM6CEfWFoqtxL2RC9XLENDFaHhD/YiwhDjz8NNVzkM0IDVPVI
         juN5Quc/8Jxsg3WYomCCUiYClibk8ZhVIwLlhnnts3T95mait7jYmPrmxznqm4Q4dKgp
         ZwqZbCYdMo6sOp7IFtGzye4cYanoB6MseZZusUqQ0Eb/H6WUDPA9MJADLkHi1PYv3PqO
         hr1fUBp1NEpbKkM7tQzJbXol0W7xn8xlZf5EKwGGjjcUZsfuBt5bjsnXjDwq6mI397X/
         5jUA==
X-Gm-Message-State: AOJu0Yz+92G4ssNRqNCn/YokxPMkj8oqNA4O2OJ1jDutCNBJ6Xb50oQF
        uQmkK5KtQL8HAPTZ/59LhBCnHjnpVKQ=
X-Google-Smtp-Source: AGHT+IEBOmqbu5YhTXF3E0HMImVn8fpWYU+DObM6S9kDqihudADwpSAmUdMgxFtlXHy7WZBRzATzEg==
X-Received: by 2002:a17:906:5a45:b0:99b:cb7a:c164 with SMTP id my5-20020a1709065a4500b0099bcb7ac164mr2265329ejc.62.1691596991122;
        Wed, 09 Aug 2023 09:03:11 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:310::26ef? ([2620:10d:c092:600::2:c27f])
        by smtp.gmail.com with ESMTPSA id bw5-20020a170906c1c500b00988f168811bsm8252154ejb.135.2023.08.09.09.03.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Aug 2023 09:03:10 -0700 (PDT)
Message-ID: <d75ee4c8-8751-f122-c620-edf056d048c9@gmail.com>
Date:   Wed, 9 Aug 2023 17:01:52 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] io_uring: break iopolling on signal
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <eeba551e82cad12af30c3220125eb6cb244cc94c.1691594339.git.asml.silence@gmail.com>
 <8d0fcef6-605c-4f67-8fc6-01065eedf725@kernel.dk>
 <b2b63fdc-d683-aaa1-8938-01665f99713a@gmail.com>
 <909349d4-af18-4001-828f-fccfc3f4e0e6@kernel.dk>
 <3dd335d1-74a0-3c76-190e-c6bfb24bf317@gmail.com>
 <c8415dcd-7b07-4c7e-8f5e-3951bd6d6ca9@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <c8415dcd-7b07-4c7e-8f5e-3951bd6d6ca9@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/9/23 17:01, Jens Axboe wrote:
> On 8/9/23 9:58 AM, Pavel Begunkov wrote:
>> On 8/9/23 16:50, Jens Axboe wrote:
>>> On 8/9/23 9:38 AM, Pavel Begunkov wrote:
>>>> On 8/9/23 16:30, Jens Axboe wrote:
>>>>> On 8/9/23 9:20 AM, Pavel Begunkov wrote:
>>>>>> Don't keep spinning iopoll with a signal set. It'll eventually return
>>>>>> back, e.g. by virtue of need_resched(), but it's not a nice user
>>>>>> experience.
>>>>>
>>>>> I wonder if we shouldn't clean it up a bit while at it, the ret clearing
>>>>> is kind of odd and only used in that one loop? Makes the break
>>>>> conditions easier to read too, and makes it clear that we're returning
>>>>> 0/-error rather than zero-or-positive/-error as well.
>>>>
>>>> We can, but if we're backporting, which I suggest, let's better keep
>>>> it simple and do all that as a follow up.
>>>
>>> Sure, that's fine too. But can you turn it into a series of 2 then, with
>>> the cleanup following?
>>
>> Is there a master plan why it has to be in a patchset? I would prefer to
>> apply now if there are not concerns and send the second one later with
>> other cleanups, e.g. with the dummy_ubuf series.
>>
>> But I can do a series if it has to be this way, I don't really care much.
> 
> No reason other than so we don't forget. But I can just do it on top of
> this one.

Let me know whichever way you decide to take, or I'll just pull
and see when I get back to it.

-- 
Pavel Begunkov
