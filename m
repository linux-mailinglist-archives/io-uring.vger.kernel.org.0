Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4852851A167
	for <lists+io-uring@lfdr.de>; Wed,  4 May 2022 15:54:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241958AbiEDN5p (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 4 May 2022 09:57:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230519AbiEDN5o (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 4 May 2022 09:57:44 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F52E3E5EC
        for <io-uring@vger.kernel.org>; Wed,  4 May 2022 06:54:08 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id n18so1473986plg.5
        for <io-uring@vger.kernel.org>; Wed, 04 May 2022 06:54:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=z5Cmzb2AUsI3Hv9UIXaoHVhLuwVS6gI+5ZJtgM6TeWw=;
        b=s4V4U9g3jSBoCaUEWIIdFvxi+8zzsTK2xPJMM9HnaAwAfeqPECc2OAJV4PetuRpzjA
         ZutrnCBKVv5Huegi8O/n6V4xXdcJTQOltDe8Uo4ax/TRFclqCHJ+E+PC2zBW9L12WDIP
         v0/RA3xk4mXFmcRFUlkjxVkmFyuwjx9T37XvgA6EY4llAC16aNyKIFqwqMWXT5QaTX1k
         iDDo1KJ/0s55knh7wSZqifr999GspxmUpy5K4lhL/T0ZRnG3eC4Ye+LPns7I61RGHK+F
         YR0OscxuGDIp05ashEhlwRQBHBXOPTS02rt9iMRAVRjaCS1/caON3UIvJOfgEt8eb+Ec
         Z8ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=z5Cmzb2AUsI3Hv9UIXaoHVhLuwVS6gI+5ZJtgM6TeWw=;
        b=OI0KbmBbGVK46NMahkMnA3MgcylgxDWGiPJFUWj8a60+6e9UTPA3saXrSn9eWbMs+x
         pkj9EktesUUBzuzLRg6CtLt8ZFRVuoH8JkUqi1mCz4j3HwAd+pWsKmsQAgh10uP8+1lU
         +Guny/OIANMJuFR1nh3jco+unOcRcelw1i2uodQIJPJrZ6wMz1MFHRbiIH5glEOH8AZn
         6HBe9E7CqOotGX2xaxbFmjavdkQQnXQjw9ryIPZIbEqz56TgNsF7peyZ+AzM1zGW5afu
         so0Db24v8Rpp0SCZ9Y2fbgoYAIGSwzTS7XDGGaLbQEXY+SLsrGYFH/IkbUJ0DJ+8lzGO
         NLkg==
X-Gm-Message-State: AOAM533RkmDsr4Sn+Mu6WpupsJK85HXgo+ktLVhoQkTFJLPELD07TR7p
        DZ5ZdfhqjeGZHpU3R7isBIj4eg==
X-Google-Smtp-Source: ABdhPJwZe+FiVplboBpjYaxfTRff4cdepEVSFdTS9bY/Yoq+7Dl+0RNdfxw0KKYYLRXUtGZQ3Emq1w==
X-Received: by 2002:a17:90b:3910:b0:1dc:515e:1b12 with SMTP id ob16-20020a17090b391000b001dc515e1b12mr10526130pjb.107.1651672447496;
        Wed, 04 May 2022 06:54:07 -0700 (PDT)
Received: from [192.168.4.166] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id d8-20020a170902728800b0015e8d4eb1e0sm8290692pll.42.2022.05.04.06.54.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 May 2022 06:54:06 -0700 (PDT)
Message-ID: <6fc53990-1814-a45d-7c05-a4385246406c@kernel.dk>
Date:   Wed, 4 May 2022 07:54:05 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: Short sends returned in IORING
Content-Language: en-US
To:     Constantine Gavrilov <constantine.gavrilov@gmail.com>
Cc:     io-uring@vger.kernel.org
References: <CAAL3td0UD3Ht-rCpR5xUfmOLzeEzRSedCVXH4nTQKLR1b16+vA@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CAAL3td0UD3Ht-rCpR5xUfmOLzeEzRSedCVXH4nTQKLR1b16+vA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/3/22 5:05 PM, Constantine Gavrilov wrote:
> Jens:
> 
> This is related to the previous thread "Fix MSG_WAITALL for
> IORING_OP_RECV/RECVMSG".
> 
> We have a similar issue with TCP socket sends. I see short sends
> regarding of the method (I tried write, writev, send, and sendmsg
> opcodes, while using MSG_WAITALL for send and sendmsg). It does not
> make a difference.
> 
> Most of the time, sends are not short, and I never saw short sends
> with loopback and my app. But on real network media, I see short
> sends.
> 
> This is a real problem, since because of this it is not possible to
> implement queue size of > 1 on a TCP socket, which limits the benefit
> of IORING. When we have a short send, the next send in queue will
> "corrupt" the stream.
> 
> Can we have complete send before it completes, unless the socket is
> disconnected?

I'm guessing that this happens because we get a task_work item queued
after we've processed some of the send, but not all. What kernel are you
using?

This:

https://git.kernel.dk/cgit/linux-block/commit/?h=for-5.19/io_uring&id=4c3c09439c08b03d9503df0ca4c7619c5842892e

is queued up for 5.19, would be worth trying.

-- 
Jens Axboe

