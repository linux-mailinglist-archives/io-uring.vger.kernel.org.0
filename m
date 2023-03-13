Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D8206B7A22
	for <lists+io-uring@lfdr.de>; Mon, 13 Mar 2023 15:17:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230301AbjCMORG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 13 Mar 2023 10:17:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230372AbjCMORF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 13 Mar 2023 10:17:05 -0400
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B925339BAB
        for <io-uring@vger.kernel.org>; Mon, 13 Mar 2023 07:16:53 -0700 (PDT)
Received: by mail-il1-x12f.google.com with SMTP id x10so6988921ill.12
        for <io-uring@vger.kernel.org>; Mon, 13 Mar 2023 07:16:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1678717013;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XNEL4l0swnCTQCDn63hdWZ9w/KZETPh/ZiDh0JjJWl4=;
        b=dujQrmUscRtPXqCMzGkLrUJflRptzP3oZ4l9Jy9IFEpstO+QcbjbTR1kTWKoMYQmOL
         fkDdUxWSvBpQ34Hy+PYuiRZIQg6R2KjV9EpJynnZWO3D1rJcJA7s1hRpS+J6aF78lAoZ
         XVTmHIPZXdWI6hIVdCSQBo6qHgDItcpVugi3IoMpy3aMnSQbehS3soa0bgxRjT+oFSPj
         s1O3tks45MbPI2KMJgjkqF7rREolk9iY3ZFYUj9bSf8ixVl4qamWZ0s2Ru9OEt/ltF3i
         wfEI/yWSn++lUrMKBpQtXQYYxUz0TIcYk6efoCex95f7Tg6LIZ1VRynR00CJrw0l2L6W
         lduQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678717013;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XNEL4l0swnCTQCDn63hdWZ9w/KZETPh/ZiDh0JjJWl4=;
        b=WaBjGeO24oUME4XvuW47vKNePDwxC3Wx9DqrIqEMXwC59HWEqM1mn0z73zt/ja3xqq
         ieLVAI5L0A0BYhmIOV2ApqqGUjAFvaIPjFNLINuWBwohsY33fOqEbtNFrR8ilmqvlz21
         qxJznm/fSpG+HihpBAKfdo1wEFw4U5kCdcfUCuobTmp1Q0Ou/8HmuWzUZBgdDsBb439O
         /6rg03eLS5FJE3Z5J8PYciQc+4IBrLz3I4xw8/DMCVKp+FCzUKtmiwc9UlijSUhLez/V
         DQ91cKurVczxkGWw+QRcz9T0YLVP77rk26iio5y/aZlSKeodff0C5ZyJYIjiFMW7wU/G
         tUfQ==
X-Gm-Message-State: AO0yUKXrreMtOQQiDeyzPOu1Qx7YkfbttuU1OMIK0SlQBAQObW4JE82B
        F75aO4l1vUVLdGxke661cdbAK+YbDaCUNbeo4ZCGZg==
X-Google-Smtp-Source: AK7set9OkGE0IqOxTpWpX3T6cDY1p5xgwzk9FvMsrJTtaOFh25r+LM3UfsbnfS3L6sKZb6XO6FdNSA==
X-Received: by 2002:a92:d186:0:b0:323:504:cff6 with SMTP id z6-20020a92d186000000b003230504cff6mr2137669ilz.3.1678717013026;
        Mon, 13 Mar 2023 07:16:53 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id b21-20020a029a15000000b003f1929b34f2sm2515143jal.68.2023.03.13.07.16.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Mar 2023 07:16:52 -0700 (PDT)
Message-ID: <c433f8cf-57dc-52c9-9959-f6a21297d1b0@kernel.dk>
Date:   Mon, 13 Mar 2023 08:16:51 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [RFC 0/2] optimise local-tw task resheduling
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
References: <cover.1678474375.git.asml.silence@gmail.com>
 <9250606d-4998-96f6-aeaf-a5904d7027e3@kernel.dk>
 <ee962f58-1074-0480-333b-67b360ea8b87@gmail.com>
 <9322c9ab-6bf5-b717-9f25-f5e55954db7b@kernel.dk>
 <4ed9ee1e-db0f-b164-4558-f3afa279dd4f@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <4ed9ee1e-db0f-b164-4558-f3afa279dd4f@gmail.com>
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

On 3/12/23 9:45?PM, Pavel Begunkov wrote:
>>>> Didn't take a closer look just yet, but I grok the concept. One
>>>> immediate thing I'd want to change is the FACILE part of it. Let's call
>>>> it something a bit more straightforward, perhaps LIGHT? Or LIGHTWEIGHT?
>>>
>>> I don't really care, will change, but let me also ask why?
>>> They're more or less synonyms, though facile is much less
>>> popular. Is that your reasoning?
>>
>> Yep, it's not very common and the name should be self-explanatory
>> immediately for most people.
> 
> That's exactly the problem. Someone will think that it's
> like normal tw but "better" and blindly apply it. Same happened
> before with priority tw lists.

But the way to fix that is not through obscure naming, it's through
better and more frequent review. Naming is hard, but naming should be
basically self-explanatory in terms of why it differs from not setting
that flag. LIGHTWEIGHT and friends isn't great either, maybe it should
just be explicit in that this task_work just posts a CQE and hence it's
pointless to wake the task to run it unless it'll then meet the criteria
of having that task exit its wait loop as it now has enough CQEs
available. IO_UF_TWQ_CQE_POST or something like that. Then if it at some
point gets modified to also encompass different types of task_work that
should not cause wakes, then it can change again. Just tossing
suggestions out there...

-- 
Jens Axboe

