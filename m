Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3D8E591759
	for <lists+io-uring@lfdr.de>; Sat, 13 Aug 2022 00:28:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233587AbiHLW2K (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 12 Aug 2022 18:28:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235899AbiHLW1v (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 12 Aug 2022 18:27:51 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAD8412773
        for <io-uring@vger.kernel.org>; Fri, 12 Aug 2022 15:27:40 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id y1so1886038plb.2
        for <io-uring@vger.kernel.org>; Fri, 12 Aug 2022 15:27:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=iUUoih8UkwYRURLYPvlaNNAYPdp8A2anNSwFl3Z001I=;
        b=SKNSOAgeG4eFTmKQsb9KpOCvK2uif4Xa7OEekK04P7DjkUjLZZIV0NC5PCwi0K0RYy
         Fezn6g0bA373ufVS2R/KVp63ZXZoYbyxz+ztGR7ovRpnDKkZOHk8wQWv4MOiIgfWlLkP
         ZmY8Ck4siev2ejaE8wuZxx6yuL/dCaOaP0NMneaCVfiVvapektKZWc33MEc2RSOLy6SP
         32jsN3WN16Bxt/SYkrGRnPbVqYg7kCjNrgcEq52tIVHMlR69YN0HRxeAbK/HOG9D0r7c
         j0AM6B6UwyYHj7q1OpNOIyVx5pd9CYdsPSeIs6tUMzdrWAK4bwFBTFAmgcDOqrPMlCQD
         OCYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=iUUoih8UkwYRURLYPvlaNNAYPdp8A2anNSwFl3Z001I=;
        b=k+SU5Fk+vh5XtHoTsPOdP06QM3man4ZqAU5iqA7InZU2Zzx6TfcmrsVVyhpAXz9dFn
         XC6jTmML/b6Nkv7l14/srAglKEMnaUakragupJYwwzjMwKhqdQicB2Y2aEPJNhbeMi5E
         buZakVll1LfTr3bLrQw43TVdx0vTdTivd3txJzdYD3q/QTBgJhqOAGObVcp96CP1lBTK
         ra3BEwo7t8Qr2sXj/IevqmektLsFDs9rAeDsfmJFyzimMpP2Ywf2PLsktHKKIBrIc4lZ
         9lpRm9hrB0e9YpFs9/EhaWS5llTDMV0Be6e8/MML8rLtO/Jy+dFaodv47o6RmKL3J/c6
         ldeg==
X-Gm-Message-State: ACgBeo2kLm79VSHRlLSOchnE+t94ILwldhv5cdmBVJENKqUV9Oz66VsI
        P+GZiks7W5dgrsMnqttyLc6M+/wSW/r2aQ==
X-Google-Smtp-Source: AA6agR4CD97kaEZkD5jjRNJpvvDZOF+ZWe53HBWUxcP1AvnueIQfVVMoAQ2KrrX+WepIeH0jABUVsw==
X-Received: by 2002:a17:90b:1b07:b0:1f5:115c:79a4 with SMTP id nu7-20020a17090b1b0700b001f5115c79a4mr6294479pjb.166.1660343260160;
        Fri, 12 Aug 2022 15:27:40 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id f10-20020a63f74a000000b003db7de758besm1819430pgk.5.2022.08.12.15.27.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Aug 2022 15:27:39 -0700 (PDT)
Message-ID: <7a29adb2-059c-9320-02e8-463cbe410c3e@kernel.dk>
Date:   Fri, 12 Aug 2022 16:27:38 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [GIT PULL] io_uring fixes for 6.0-rc1
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
To:     Keith Busch <kbusch@kernel.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        io-uring <io-uring@vger.kernel.org>
References: <CAHk-=wioqj4HUQM_dXdVoSJtPe+z0KxNrJPg0cs_R3j-gJJxAg@mail.gmail.com>
 <D92A7993-60C6-438C-AFA9-FA511646153C@kernel.dk>
 <6458eb59-554a-121b-d605-0b9755232818@kernel.dk>
 <ca630c3c-80ad-ceff-61a9-63b253ba5dbd@kernel.dk>
 <433f4500-427d-8581-b852-fbe257aa6120@kernel.dk>
 <CAHk-=wi_oveXZexeUuxpJZnMLhLJWC=biyaZ8SoiNPd2r=6iUg@mail.gmail.com>
 <CAHk-=wj_2autvtY36nGbYYmgrcH4T+dW8ee1=6mV-rCXH7UF-A@mail.gmail.com>
 <bb3d5834-ebe2-a82d-2312-96282b5b5e2e@kernel.dk>
 <e9747e47-3b2a-539c-c60b-fd9ccfe5c5e4@kernel.dk>
 <YvbS/OHMJowdz+X3@kbusch-mbp.dhcp.thefacebook.com>
 <700d3c1c-557a-f521-c1b1-2b59a76bb479@kernel.dk>
In-Reply-To: <700d3c1c-557a-f521-c1b1-2b59a76bb479@kernel.dk>
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

On 8/12/22 4:25 PM, Jens Axboe wrote:
> On 8/12/22 4:23 PM, Keith Busch wrote:
>> On Fri, Aug 12, 2022 at 04:19:06PM -0600, Jens Axboe wrote:
>>> On 8/12/22 4:11 PM, Jens Axboe wrote:
>>>> For that one suggestion, I suspect this will fix your issue. It's
>>>> obviously not a thing of beauty...
>>>
>>> While it did fix compile, it's also wrong obviously as io_rw needs to be
>>> in that union... Thanks Keith, again!
>>
>> I'd prefer if we can get away with forcing struct kiocb to not grow.
>> The below should have the randomization move the smallest two fields
>> together so we don't introduce more padding than necessary:
> 
> Keith suggested the same thing and was going to send it out, and I
> definitely like that a lot more than mine. Can you commit something like
> this? Should probably add a comment on why these are grouped like that,
> though.

Guess I'm a bit too quick here as I read this one as being from Linus.
Linus, what do you think of this? It'll prevent kiocb from growing due
to fields being moved around.

-- 
Jens Axboe

