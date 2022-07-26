Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 831385817DE
	for <lists+io-uring@lfdr.de>; Tue, 26 Jul 2022 18:49:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229996AbiGZQt5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 26 Jul 2022 12:49:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239538AbiGZQt4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 26 Jul 2022 12:49:56 -0400
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF09E2611E
        for <io-uring@vger.kernel.org>; Tue, 26 Jul 2022 09:49:55 -0700 (PDT)
Received: by mail-il1-x132.google.com with SMTP id e12so758394ilu.7
        for <io-uring@vger.kernel.org>; Tue, 26 Jul 2022 09:49:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=XIo5rhB4UyLPB1jWNjiCibp2fivZ9f6GRaRrGMiXovw=;
        b=meArix/KRUMFq7pf4Lx/zl782ky7Iz6Wuvba0Z95P8NxRU0tJ9rg/wnXqWuVY+J3Vz
         W05RQvY/040lJWWdn7KHUy+Z2MCEkV4Y9p0oxTu8Qkc8EtiCIr9TMzLZMSKONiHwZZpz
         or2NRntuWrUQOkPqzFG8vW3aiX0ujwVn071usDSWATNmHOmwVm7p9T0Bcj2rnatCtsrM
         tULm60JQFv51Qp61DNGDRB4UlLRTG0zx50MTMegixmH9m+O/jdztwr3G8n72T/IJdUOw
         jsV3Wr6hxfNFncObdV197smktRlkJyIzaxmcbFKPvBFo1GfQ03x8lWYpaK/rw8LtH/T6
         fyng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=XIo5rhB4UyLPB1jWNjiCibp2fivZ9f6GRaRrGMiXovw=;
        b=ADZy23QpfzthdCWYvS5enkhl7piCRTSprkJ+JZHB779uLj40/gCT64OfqxMNn4XhcP
         gBnC3Ui48go0LdabgdoDCbb53HLQLZ5v5RkV2FKPSfd2l7zf3NlRYzuwNt6bWY1PQClO
         1obAFYUrX1mAgJnKZHFOEl9/RG3Z6z6bgcx9bTkGEZZCLKbmmPnFJHQYnoxZxtzKt1xf
         +2R8VeMZq/1bQZO5s/H8DmwEubNYJpj8yz+EFzDIJmHqHUNAOuAbCaxxZNlOghzVARIl
         gHb7w/2pkclkdUL6R1IHEw33G773t7w97vtMECQJalwq87UfM1r6HL0NTyzaRubcJsjK
         R94A==
X-Gm-Message-State: AJIora+0MNIzTZHAgzBzlL3yugWudRrRf3PXFQBMaaSQ+oT+mpcGSwXj
        KeDHa6llk/SQYBqQ2be4GEz/Wg==
X-Google-Smtp-Source: AGRyM1t0cqp0Korj9rRmVE5nMLNJeyM6SWcSuiwPY6i5oZC0nlYMOd8tCtjRwvjX8CAfdmkeJNRFjw==
X-Received: by 2002:a92:6b10:0:b0:2db:efeb:6a42 with SMTP id g16-20020a926b10000000b002dbefeb6a42mr7095730ilc.40.1658854195256;
        Tue, 26 Jul 2022 09:49:55 -0700 (PDT)
Received: from [192.168.1.172] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id q35-20020a027b23000000b003314d7b59b0sm6794463jac.88.2022.07.26.09.49.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Jul 2022 09:49:54 -0700 (PDT)
Message-ID: <e126981a-c4c1-ca53-b98e-63ba1322f675@kernel.dk>
Date:   Tue, 26 Jul 2022 10:49:53 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH liburing 0/5] multishot recvmsg docs and example
Content-Language: en-US
To:     Ammar Faizi <ammarfaizi2@gnuweeb.org>
Cc:     Dylan Yudaken <dylany@fb.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Facebook Kernel Team <kernel-team@fb.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        Ammar Faizi <ammarfaizi2@gmail.com>
References: <20220726121502.1958288-1-dylany@fb.com>
 <165885259629.1516215.11114286078111026121.b4-ty@kernel.dk>
 <e1d3c53d-6b31-c18b-7259-69467afa8088@gmail.com>
 <d14c5be4-b9d8-a52c-12db-6f697784fd9e@kernel.dk>
 <ce7096fb-0d42-99d7-e7fa-d82251c1934a@gnuweeb.org>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <ce7096fb-0d42-99d7-e7fa-d82251c1934a@gnuweeb.org>
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

On 7/26/22 10:48 AM, Ammar Faizi wrote:
> On 7/26/22 11:40 PM, Jens Axboe wrote:
>> On 7/26/22 10:32 AM, Ammar Faizi wrote:
>>> On 7/26/22 11:23 PM, Jens Axboe wrote:
>>>> [5/5] add an example for a UDP server
>>>>         commit: 61d472b51e761e61cbf46caea40aaf40d8ed1484
>>>
>>> This one breaks clang-13 build, I'll send a patch.
>>
>> Hmm, built fine with clang-13/14 here?
> 
> Not sure what is going on, but clang-13 on my machine is not happy:
> 
>     io_uring-udp.c:134:18: error: incompatible pointer types passing \
>     'struct sockaddr_in6 *' to parameter of type 'const struct sockaddr *' \
>     [-Werror,-Wincompatible-pointer-types
> 
>     io_uring-udp.c:142:18: error: incompatible pointer types passing \
>     'struct sockaddr_in *' to parameter of type 'const struct sockaddr *' \
>     [-Werror,-Wincompatible-pointer-types]
> 
> Changing the compiler to GCC builds just fine. I have fixed something like
> this more than once. Strange indeed.

Regardless, the patch is sane!

-- 
Jens Axboe

