Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 453CF3AE028
	for <lists+io-uring@lfdr.de>; Sun, 20 Jun 2021 22:13:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229877AbhFTUPg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 20 Jun 2021 16:15:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229632AbhFTUPg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 20 Jun 2021 16:15:36 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BF8BC061574;
        Sun, 20 Jun 2021 13:13:23 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id n7so17203506wri.3;
        Sun, 20 Jun 2021 13:13:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Q0TVjI7Y60EXCArmgh8EI3LQcOPZyITFP4rjzjZVKWM=;
        b=CJrORjdm50/3Jv33EaOW9JsuVx5Is9yTPsOtHy5dsiA2gdYOkFuCYWjP6tyIVxliY8
         4F2rkTMJ2nfcfeED9fRW+lOrIApyfxUD9VmGmtbLrachi9UOG3u4hUH44foCZWLG4JIk
         YngB0fDA16ouF0eI9REHaKHHdMyjNxR4qH8lbkW/GOh+En96PotdYuJPJaYlN/8pawtC
         ZUpRxJI5ONL4Hxdg6OJ0oTlwedYM2jxXQ0OjMLsXNqWAThoT3FcPPNKHf3DmAV+ZubDw
         vkRUTFwyBRsjnwszTRtE2d2ypR/edTdOojRgvO1MVdMmLejwoWG1/7Y15K5FvZ8HtRKO
         iIww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Q0TVjI7Y60EXCArmgh8EI3LQcOPZyITFP4rjzjZVKWM=;
        b=Ikq2nfwoazdc7Ilfki8UNqS3TaxdWlTUuRIg4zWiQPes9J2RjiUUmw9pmCV+CIw907
         F98dy5depK7SbSE74xxvNy0ZeYe4fmvML5lZ2qSwgUHcenbZBlIqQ1Q2cSILTfOPzyzY
         2v2EPl7ZbsL75mtIaH6S0ZcWUJ86Aj89y1Yze8ZvV0oSptjx19quU9cJxmEHZrRTxkGU
         qLVccGSp/qOC+ak1s9iPejSz2ILnXFzKSjheux93S/HNJWIP8fKv2/AxDHinCuML2opl
         5huY2Nz9TuQqzpLdXDwacl+IG8HhPOZFbmL3wF1kPFFG7K+3UT2nElc8MDs3jwas0rhp
         FMLg==
X-Gm-Message-State: AOAM533gQoglbc+NCz+fh/SiyKonVqmsCevB6fqGYx1vWQt09TZyGsjl
        GRytTO74s8o0mNxwMgHtuXlTdpsDQroNnw==
X-Google-Smtp-Source: ABdhPJwp+Gj1B285qCokmFA/M82d1AgL0yCXG9NXFSUcdaotI5JNhgqirSDq1Vj2yfpPnds1bygPQQ==
X-Received: by 2002:a5d:45c5:: with SMTP id b5mr2674953wrs.221.1624220001866;
        Sun, 20 Jun 2021 13:13:21 -0700 (PDT)
Received: from [192.168.8.197] ([185.69.145.72])
        by smtp.gmail.com with ESMTPSA id q5sm15309786wmc.0.2021.06.20.13.13.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 20 Jun 2021 13:13:21 -0700 (PDT)
Subject: Re: [PATCH v2 2/3] io_uring: minor clean up in trace events
 definition
To:     Olivier Langlois <olivier@trillion01.com>,
        Jens Axboe <axboe@kernel.dk>,
        Steven Rostedt <rostedt@goodmis.org>
Cc:     Ingo Molnar <mingo@redhat.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <60be7e31.1c69fb81.a8bfb.2e54SMTPIN_ADDED_MISSING@mx.google.com>
 <2752dcc1-9e56-ba31-54ea-d2363ecb6c93@gmail.com>
 <def5421f-a3ae-12fd-87a2-6e584f753127@kernel.dk>
 <20210615193532.6d7916d4@gandalf.local.home>
 <2ba15b09-2228-9a2a-3ac3-c471dd3fc912@kernel.dk>
 <3f5447bf02453a034f4eb71f092dd1d1455ec7ad.camel@trillion01.com>
 <237f71d5-ee6e-247c-c185-e4e6afbd317c@kernel.dk>
 <1cf91b2f760686678acfbefcc66309cd061986d5.camel@trillion01.com>
 <902fdad6-4011-07fc-ea0e-5bac4e34d7bc@kernel.dk>
 <473dbbd3376a085df4672a30f86fe8faf8f8254a.camel@trillion01.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <5d2d9a34-e070-877c-9b94-152f60ae4a2a@gmail.com>
Date:   Sun, 20 Jun 2021 21:13:08 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <473dbbd3376a085df4672a30f86fe8faf8f8254a.camel@trillion01.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/20/21 8:15 PM, Olivier Langlois wrote:
>>
> I found my problem. I had to add the option --thread to git format-
> patch
> 
> as in:
> $ git format-patch --thread -o ~/patches HEAD^

fwiw, was always using

$ git format-patch -n --thread=shallow --subject-prefix "PATCH" -o <path> --cover-letter HEAD~N..HEAD~0

without --cover-letter if a single patch

-- 
Pavel Begunkov
