Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B2614E7568
	for <lists+io-uring@lfdr.de>; Fri, 25 Mar 2022 15:50:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359371AbiCYOvo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 25 Mar 2022 10:51:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355899AbiCYOvn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 25 Mar 2022 10:51:43 -0400
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88F535A596
        for <io-uring@vger.kernel.org>; Fri, 25 Mar 2022 07:50:09 -0700 (PDT)
Received: by mail-io1-xd2a.google.com with SMTP id b16so9176210ioz.3
        for <io-uring@vger.kernel.org>; Fri, 25 Mar 2022 07:50:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=oGvVgJ6VfJtcZFmqXEnibBEUg8k/w6Xhk/YfvMGYzNQ=;
        b=IP/Zv8sk1z6rwstydVOTacPf9hnAMo0yLwnLQvik3h678A1hHYsL35E6PBaXYKKTYA
         Qr3P5Xfk2o5MmETXZGVc14UU546EtBudaH7n/NOG4fdWPbwalwJU2bi+cAwUq3NzRP+n
         wKJMoJW2pEf2GzmrrHV/D3Ivs2WBrdw3C1hhe0yTIWwKjPi4woN8rBZGJ4sh4+mZf1RD
         ik4ad/p0yGCnIBaSnd1IDd8Jk5WlJTi5+fKKnlefj2zreb4yhlWFF85MARTGF9OgCmDA
         JGTYzEJpNrRcFF6L8QpQxWoWOY5eWteCeo50J2k1lhEyH80Oetld4MlD5hz51UpZKBEv
         faig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=oGvVgJ6VfJtcZFmqXEnibBEUg8k/w6Xhk/YfvMGYzNQ=;
        b=PoR0IAVgxpTFV8JZl+3BbHdx3u/hyTigbQ9eqkfC3/qtjyytA5SuGZdfTOlPr2/iRe
         jFmUxKIt/ZlN7XpplW5u8nAlMF3voVG6EAyPoeRV/Rc94naHsJW3OsEXdIQwcW9aZAiI
         6Om66cl/UJ71dsdmaGCHlV1wK7ry0kvDriHbF0t2ydPKVwIrPB7fJiGeOulOg+K5RZT6
         DNdfzl9NMsCx3fCSi7GkycjXhiTVnMGMaAbhR8pyFCoI4ilS2rP0qjqEgxHSraqfIWLO
         aaHQw8CgYu1bKLm+FJrVwfUVON1+FDf1xB1IAH07XTraFrBvTuK7gq1DHSyQvMF10JLL
         CZIA==
X-Gm-Message-State: AOAM533V9A5GBUuiaqKzKFJHt4ymZaZGpvELb75jingIsmpGeAQLC2fK
        UNx8pR+D7WAz+0p+/t3ajpfhyQ==
X-Google-Smtp-Source: ABdhPJzL7mf/22S4pdm18QKc6Lmq3ujjO8+LXD+aiXG1rVFI3WPe5Z0cfaqKKFPpJ31B6zoFu0y77Q==
X-Received: by 2002:a6b:fb17:0:b0:649:b0dd:e381 with SMTP id h23-20020a6bfb17000000b00649b0dde381mr5799991iog.95.1648219808865;
        Fri, 25 Mar 2022 07:50:08 -0700 (PDT)
Received: from [192.168.1.172] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id l20-20020a927014000000b002c61075e389sm3037534ilc.49.2022.03.25.07.50.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Mar 2022 07:50:08 -0700 (PDT)
Message-ID: <3796a484-0b26-ede5-bfbc-6d0647f0646d@kernel.dk>
Date:   Fri, 25 Mar 2022 08:50:06 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCHSET v2 0/2] Fix MSG_WAITALL for IORING_OP_RECV/RECVMSG
Content-Language: en-US
To:     Constantine Gavrilov <constantine.gavrilov@gmail.com>
Cc:     io-uring@vger.kernel.org
References: <20220323224131.370674-1-axboe@kernel.dk>
 <CAAL3td3smVV+J3167qT5ZX7aKT1JXe4u3_vitk9CFq61giquwA@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CAAL3td3smVV+J3167qT5ZX7aKT1JXe4u3_vitk9CFq61giquwA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/24/22 9:16 PM, Constantine Gavrilov wrote:
> On Thu, Mar 24, 2022 at 12:41 AM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> Hi,
>>
>> If we get a partial receive, we don't retry even if MSG_WAITALL is set.
>> Ensure that we retry for the remainder in that case.
>>
>> The ordering of patches may look a bit odd here, but it's done this way
>> to make it easier to handle for the stable backport.
>>
>> v2:
>> - Only do it for SOCK_STREAM/SOCK_SEQPACKET
>>
>> --
>> Jens Axboe
>>
>>
> 
> Jens:
> 
> I was able to test the patch, after making some minor changes to apply
> to Fedora kernel. I confirm that the patch works.

Great, thanks for testing! It'll go into the current kernel tree next
week and make its way back to stable after that.

-- 
Jens Axboe

