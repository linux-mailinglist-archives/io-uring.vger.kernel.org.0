Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB179591741
	for <lists+io-uring@lfdr.de>; Sat, 13 Aug 2022 00:25:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236829AbiHLWZ0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 12 Aug 2022 18:25:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230201AbiHLWZZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 12 Aug 2022 18:25:25 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D28A5AE6B
        for <io-uring@vger.kernel.org>; Fri, 12 Aug 2022 15:25:23 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id 13so1847009plo.12
        for <io-uring@vger.kernel.org>; Fri, 12 Aug 2022 15:25:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=mgtATqh6xE8g4/txlTpYN4WRU76HKbWqN2/BRnTkXA0=;
        b=OHTs0HyuLKRn1wpoHCPASlB2YNI8sYa8DWeKfTt5JDEo45CrTk6runv80pM3BPWvkV
         KOzH7tbRn23OFwNrJcGxSlPqdonfvKNNgqVikIFmoqbrqfQklUHDmKnfCyT2qgrkb8kE
         BZEN30QgPQRC3w2j7Po571LgnypHGJMhtg4JijYXZ1AeZ7SYDQ8bLccwW4VBxPyI8jHU
         wHgeWLqncklyYw7quJPrqAIL8f1lmhx9oEEHvmVJzkZmQZBRxAysCAXKr2JYQxr+cxXY
         ZeWarx2W5joq0bi6BWrtP8VIjWDmRV/VF2aq9JX9uEEFXo5zVKNkAUkMOUICiEYiw0Y2
         R5cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=mgtATqh6xE8g4/txlTpYN4WRU76HKbWqN2/BRnTkXA0=;
        b=x8cmy7bGnY2LYBA8ald19wmDzrbVpLQ20UJsJOYhDRUhsu0P0iG0S6oey6OIBaOraG
         JEOy4a/IjsfMGeGVu+y4w+tXvDzQSsQFMSX/1GMTQbr8xn12gD3SY8eqD7H50U5ukMxK
         JdBJ8jAktdFtrzMdR1/lLerN0emZEkvX6SAZXGdtxJb+G2nS/7Cs34jRFTSkrovyrNCR
         pFFdFizjG7O3dTKToD3fFiM3uz9MBpZPZcTIE1jHbe+y1tL0nCpuPZOP3m9hT5g0jlYk
         thjx4SmZ1NcaG7eR2+tOZEPtnTWgfNJt0NLJG6tPcvJP4tKBMCVhXhtNNYmOtbUQIxb4
         0uug==
X-Gm-Message-State: ACgBeo15AJNaiE3gRuaNYUYShTjH6nrj6NoYiYJpKSXUST5mUsyKICNc
        FzuHQIiKaX40ttQxPZ0a7FdMzAZBEkL+yA==
X-Google-Smtp-Source: AA6agR5b+oDitG9O2Tu4b9kY3DprcGc/3xDIB+lghpwVCAhx+OfWrDlnplmYCoPLGu+r8Jc4ZyrqGA==
X-Received: by 2002:a17:902:cec7:b0:172:5b09:161c with SMTP id d7-20020a170902cec700b001725b09161cmr66013plg.60.1660343122652;
        Fri, 12 Aug 2022 15:25:22 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id x23-20020aa78f17000000b005252a06750esm2099166pfr.182.2022.08.12.15.25.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Aug 2022 15:25:22 -0700 (PDT)
Message-ID: <700d3c1c-557a-f521-c1b1-2b59a76bb479@kernel.dk>
Date:   Fri, 12 Aug 2022 16:25:21 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [GIT PULL] io_uring fixes for 6.0-rc1
Content-Language: en-US
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
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <YvbS/OHMJowdz+X3@kbusch-mbp.dhcp.thefacebook.com>
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

On 8/12/22 4:23 PM, Keith Busch wrote:
> On Fri, Aug 12, 2022 at 04:19:06PM -0600, Jens Axboe wrote:
>> On 8/12/22 4:11 PM, Jens Axboe wrote:
>>> For that one suggestion, I suspect this will fix your issue. It's
>>> obviously not a thing of beauty...
>>
>> While it did fix compile, it's also wrong obviously as io_rw needs to be
>> in that union... Thanks Keith, again!
> 
> I'd prefer if we can get away with forcing struct kiocb to not grow.
> The below should have the randomization move the smallest two fields
> together so we don't introduce more padding than necessary:

Keith suggested the same thing and was going to send it out, and I
definitely like that a lot more than mine. Can you commit something like
this? Should probably add a comment on why these are grouped like that,
though.

-- 
Jens Axboe

