Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6A3753EAEA
	for <lists+io-uring@lfdr.de>; Mon,  6 Jun 2022 19:09:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236452AbiFFMJs (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 6 Jun 2022 08:09:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236432AbiFFMJp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 6 Jun 2022 08:09:45 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8762523176
        for <io-uring@vger.kernel.org>; Mon,  6 Jun 2022 05:09:43 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id k16so19598993wrg.7
        for <io-uring@vger.kernel.org>; Mon, 06 Jun 2022 05:09:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:cc:references:in-reply-to:content-transfer-encoding;
        bh=/YJQUC2MZamlL+wqt+XQbiSl5Zw4wgvwIZNfE53wfkk=;
        b=W4nMeWe3jnIm2FZPpIRIKl9L2bC7hmnoLnTEWmd94EnijcIl+rGh+353k2AfEyT1J1
         sen4VmQhqmSRgOBXKPRclvkNOHz6ubM7DjG+ymugW0EorTM1rCLJs49CRudQqF2rdfFa
         gMOebOniz1CII2i/Ud7V4em/vVUQffnMoMiJGj/LXtKjuAq7VO1uETZ8Z/62DcNDYwVD
         rWNGj6KXA1Nmai+Owxgaf3SvBmM2bimGQhKHEg1RLSfPWWgsiyyQrgbUsR6ff8Dztkha
         yZIqq2ZQOv9j77dNFd7PRQX7v70osArMrOizPbTjMgE7LVjvugzUEq0uc3aGeIx3qDuG
         9l1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=/YJQUC2MZamlL+wqt+XQbiSl5Zw4wgvwIZNfE53wfkk=;
        b=mfBs6c8MhKquZtZSsdqg6Wz74M0QeWV/lbfMpQFOQQIQoxAHbAyIe1rx1X8AT+qPgt
         X9aZwLT+KyHAAPWL7OF0Am5BfxgUFCsovzO1nZFTgJ9/QcDcfcjH6Vxpeu3kUW4RTrZl
         4enyHHM98E+GTfHc2l6B/n42AV2J3SZxydni7D2XbYHJe7EOBfN+BvZzUkT38GnJAJ7q
         33vRESjv8FQ54adr/qbI8spK75Y7kbQYbZCLcG2cXWN4ESlLjY9qYB9EUaUZjblU4biC
         x8k2ytTDWSYmB4F/LKkdnHlKQqk2a+VqcefZiwoPM7nC2HSpsVWmGh8ZoQ92QrM6Qorp
         BFyQ==
X-Gm-Message-State: AOAM531DHnP3dr+r503y8c+w8VnZTuPaCdn4PJ40W1thPdFMkkqDYw6Z
        3hD1cEqyEZsmEDph1yhIzOo=
X-Google-Smtp-Source: ABdhPJxE/PoAsXIuywaP9dvY/QJClb4K6GIvO3F35JfU/7+I438JrNnbDBjpd+MDk/cRZgG5aR3BWw==
X-Received: by 2002:a5d:6c64:0:b0:20f:f413:8af8 with SMTP id r4-20020a5d6c64000000b0020ff4138af8mr21154611wrz.129.1654517381974;
        Mon, 06 Jun 2022 05:09:41 -0700 (PDT)
Received: from [192.168.43.77] (82-132-232-174.dab.02.net. [82.132.232.174])
        by smtp.gmail.com with ESMTPSA id bi11-20020a05600c3d8b00b0039c3ecdca66sm10305551wmb.23.2022.06.06.05.09.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Jun 2022 05:09:41 -0700 (PDT)
Message-ID: <b8cd94c1-155b-b222-b690-ddfe58900bff@gmail.com>
Date:   Mon, 6 Jun 2022 13:09:22 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH v2 0/3] cancel_hash per entry lock
Content-Language: en-US
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Hao Xu <haoxu.linux@icloud.com>, io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
References: <20220606065716.270879-1-haoxu.linux@icloud.com>
 <da7624f0-ed08-eb94-621e-ed3e0751dfed@icloud.com>
 <0316d33e-4d72-7afb-ba9a-127e3427a228@gmail.com>
In-Reply-To: <0316d33e-4d72-7afb-ba9a-127e3427a228@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/6/22 13:02, Pavel Begunkov wrote:
> On 6/6/22 08:06, Hao Xu wrote:
>> On 6/6/22 14:57, Hao Xu wrote:
>>> From: Hao Xu <howeyxu@tencent.com>
>>>
>>> Make per entry lock for cancel_hash array, this reduces usage of
>>> completion_lock and contension between cancel_hash entries.
>>>
>>> v1->v2:
>>>   - Add per entry lock for poll/apoll task work code which was missed
>>>     in v1
>>>   - add an member in io_kiocb to track req's indice in cancel_hash
>>
>> Tried to test it with many poll_add IOSQQE_ASYNC requests but turned out
>> that there is little conpletion_lock contention, so no visible change in
>> data. But I still think this may be good for cancel_hash access in some
>> real cases where completion lock matters.
> 
> Conceptually I don't mind it, but let me ask in what
> circumstances you expect it to make a difference? And
> what can we do to get favourable numbers? For instance,
> how many CPUs io-wq was using?

Btw, I couldn't find ____cacheline_aligned_in_smp anywhere,
which I expect around those new spinlocks to avoid them sharing
cache lines
  
-- 
Pavel Begunkov
