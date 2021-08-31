Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DE233FCB38
	for <lists+io-uring@lfdr.de>; Tue, 31 Aug 2021 18:10:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232770AbhHaQLW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 31 Aug 2021 12:11:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233018AbhHaQLW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 31 Aug 2021 12:11:22 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E00A2C061760
        for <io-uring@vger.kernel.org>; Tue, 31 Aug 2021 09:10:26 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id m25-20020a7bcb99000000b002e751bcb5dbso2970802wmi.5
        for <io-uring@vger.kernel.org>; Tue, 31 Aug 2021 09:10:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=GyZvewauVSF/zUF0Dubd1r7gzO2vcieflQ01gqLbDIk=;
        b=Mda8z8W2w9lZvBkAb+nMYqrtvJz/wnmhbP/0/yTD+oidcTGS+bfM9M+LCRN7o9L/tq
         ryWw72pQL/xedfa4tZcPW6i3yJRNtL9/0hstq+VMl/jS+EYsNPJOui+ucm/8dzdUkZOT
         15bdaAK6w2EfCQksjyQk9OTeFLrNd5tr3fd1zbYCsv9pWObH57fg1K9SsS9ZKs/yimIY
         DxdK9ef44zNz2jsQNfNjqw0fsf+YASAUtInODu0zSVJQoG5MdziJ4cgFsvezWgzeMIFd
         QF4tMTjvwPD4P6Xws1CjwtqjJFIAsOC0fQvck5G8n6HT+kPPJe7iPSIGFCIyKkGyzZ4d
         9IWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GyZvewauVSF/zUF0Dubd1r7gzO2vcieflQ01gqLbDIk=;
        b=TAotNZchJAcmcGpw9NAfh8UNOrpSjq/0vyUjJrMKzJPw4ozUPKY1ZKmiSkq3gsOy6I
         4haBVN6e82LFytKCOe+Aewuc9uboT3LrCdTMn+3SjEw20eG87tWUq8Y3bc6jbAteg1+/
         3rhzH21maW501w6OSASJ1tqVc7M+g8JervfoAN1C5/MTgnV3kKNDnbRh7ja1yKqQkJCG
         7Y0NUp373Kj2UHr7s9ZxW74bBFeO8jxNKguaml6oBrr5fi3z7OuYZY8YUcghQxkt9PAZ
         bwQWLGjwkfq6SwwbkTN4VmWMQ4ara0vMflITE9laqtuTzXx/mnDmhSMg2dCpIYDMm7cH
         /dFw==
X-Gm-Message-State: AOAM531GLWZkJ5vHGJuQCd4HR3aw2jLawl1O1ikR8jy1HR1CiBX7c8Qx
        dF7jWAdS7Y4fXRHeRD9K8P7UsKJ0Ofk=
X-Google-Smtp-Source: ABdhPJxzroe6DORBMMx73iO4WnLZ06CDsSSa7mX5XKkpb5dq+w3lWf5Fa9wz73UF0/qqCpLdzTg3/w==
X-Received: by 2002:a05:600c:4f85:: with SMTP id n5mr5108352wmq.1.1630426225261;
        Tue, 31 Aug 2021 09:10:25 -0700 (PDT)
Received: from [192.168.8.197] ([148.252.133.138])
        by smtp.gmail.com with ESMTPSA id y21sm2905978wmc.11.2021.08.31.09.10.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 31 Aug 2021 09:10:24 -0700 (PDT)
Subject: Re: io_uring_prep_timeout_update on linked timeouts
To:     Victor Stewart <v@nametag.social>, Jens Axboe <axboe@kernel.dk>
Cc:     io-uring <io-uring@vger.kernel.org>
References: <CAM1kxwhHOt1Ni==4Qr6c+qGzQQ2R9SQR4COkG2MXn_SUzEG-cg@mail.gmail.com>
 <CAM1kxwi83=Q1Br46=_3DH46Ep2XoxbRX5hOVwFs7ze87Osx_eg@mail.gmail.com>
 <CAM1kxwiAF3tmF8PxVf6KPV+Qsg_180sFvebxos5ySmU=TqxgmA@mail.gmail.com>
 <1b3865bd-f381-04f3-6e54-779fe6b43946@kernel.dk>
 <04e3c4ab-4e78-805c-bc4f-f9c6d7e85ec1@gmail.com>
 <b53e6d69-9591-607b-c391-bf5fed23c1af@kernel.dk>
 <ebf4753c-dbe4-f6b5-e79c-39cc9a608beb@gmail.com>
 <66bf3640-a396-28cf-0b0d-8f3a9622ce2b@kernel.dk>
 <CAM1kxwgKJYUN=-CGT02oK+gxk_u60DchEAykoSYLbHRXfOz0Yg@mail.gmail.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <019fd0c1-a6ac-a4fc-7b6e-b2779b977ca2@gmail.com>
Date:   Tue, 31 Aug 2021 17:09:53 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <CAM1kxwgKJYUN=-CGT02oK+gxk_u60DchEAykoSYLbHRXfOz0Yg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/31/21 12:36 PM, Victor Stewart wrote:
>>> _Not tested_, but something like below should do. will get it
>>> done properly later, but even better if we already have a test
>>> case. Victor?
> 
> sorry been traveling! i can extract out a simple test today...
> 
>> FWIW, I wrote a simple test case for it, and it seemed to work fine.
>> Nothing fancy, just a piped read that would never finish with a linked
>> timeout (1s), submit, then submit a ltimeout update that changes it to
>> 2s instead. Test runs and update completes first with res == 0 as
>> expected, and 2s later the ltimeout completes with -EALREADY (because
>> the piped read went async) and the piped read gets canceled.
> 
> ...unless?

Extra tests are always appreciated, there is never too many of them :)
FWIW, don't see any new related added by Jens (yet?).

-- 
Pavel Begunkov
