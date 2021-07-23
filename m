Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAEB63D3D7C
	for <lists+io-uring@lfdr.de>; Fri, 23 Jul 2021 18:22:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229616AbhGWPll (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 23 Jul 2021 11:41:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230001AbhGWPlj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 23 Jul 2021 11:41:39 -0400
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D69DC061575
        for <io-uring@vger.kernel.org>; Fri, 23 Jul 2021 09:22:12 -0700 (PDT)
Received: by mail-io1-xd30.google.com with SMTP id u15so3141916iol.13
        for <io-uring@vger.kernel.org>; Fri, 23 Jul 2021 09:22:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Q85PNgMm8BohN+B4Wb28lL4/4iVgRErzsdyam6+5v6k=;
        b=h3aMgJuMMmQVuTBEnt9gpTPQLgZbaQEDgcOR/XI2w3NtY8OK1lB0VQqEvEwvOoGtsT
         2HJy7aOdLEu1/0/yZILdhIJWsTb/N8EUSp8AiLcY5dodrRFHTEQ3hklIHzKezhObPh8P
         Ma58z1GgI54UnIxQ1kRso+O9LaGztm3cjrX0sIwtfnf24pl4gbTVkPpPBhGPc+1FqslT
         OcX8X44Tpyrl9f+xIim3Mb2tRdtLSDkt2rMcciYr35r82luEM6iQBsiDAL5tLxvcYPSr
         sMP5LeJ/nv/gSYWkd9XlngkYzqN52HWdFWS4mSdxZA1BDIS/G/q9Y/IwqtpYypf0Cmds
         c+kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Q85PNgMm8BohN+B4Wb28lL4/4iVgRErzsdyam6+5v6k=;
        b=ZR/dOqt2dLmheYoTHXbbB39+rtmpsLkgAFZc3pR6jyyPDT8bZzlG5ZHW2J3lRWGKyV
         k0DtoT/r/dOTqiPZ37jAKJIOKydaraS8IRlRtsmmPcw0J827ffL+C96VcNoe37uD9FUh
         2VFYN0KK1VCu4JiOgFiQ4emH+U4esLpHQQ1ArvA3sIaf9SlJltqi4XSDLsF3je6a2lnc
         QLXc7ivCafdU6d2l2kHCtErB/STdLIgKnkgX0W45Nrfmfhr7XFehJaJl0aH1gGLtwk2P
         UqhH8qOZkuESQj/tU+yPf7riXUXPkJKgeVrYfD8iXnVUVCzTMEqwjc25oUmgS8Uaf7A6
         1meg==
X-Gm-Message-State: AOAM533L1o7B+duWmSp6PkIfmEkunf3PAHMWmiwO3POzSIQEZ0qp2l3j
        fJsWCB+8ItzHhrH66F7/8gQce2oNzo42i8JG
X-Google-Smtp-Source: ABdhPJyDLICktU7C1lwqq2XdJiuUGx/OahDKPIQJ2apaFD68XBKWAppVYBbZBSZJGdmg49fjLZZJbw==
X-Received: by 2002:a6b:e706:: with SMTP id b6mr4680383ioh.202.1627057331814;
        Fri, 23 Jul 2021 09:22:11 -0700 (PDT)
Received: from [192.168.1.10] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id z10sm4017200iln.8.2021.07.23.09.22.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Jul 2021 09:22:11 -0700 (PDT)
Subject: Re: [PATCH io_uring-5.14 v2] io_uring: remove double poll wait entry
 for pure poll
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Hao Xu <haoxu@linux.alibaba.com>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20210723092227.137526-1-haoxu@linux.alibaba.com>
 <c628d5bc-ee34-bf43-c7bc-5b52cf983cb1@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <12552166-8d0c-2cbb-faec-ec320f171f13@kernel.dk>
Date:   Fri, 23 Jul 2021 10:22:10 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <c628d5bc-ee34-bf43-c7bc-5b52cf983cb1@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/23/21 8:31 AM, Pavel Begunkov wrote:
> On 7/23/21 10:22 AM, Hao Xu wrote:
>> For pure poll requests, we should remove the double poll wait entry.
>> And io_poll_remove_double() is good enough for it compared with
>> io_poll_remove_waitqs().
> 
> 5.14 in the subject hints me that it's a fix. Is it?
> Can you add what it fixes or expand on why it's better?

Ditto that, the commit message explains what is being done, it should
explain _why_ it's being done. For the 'what' part you can read the
code. So while the patch doesn't look wrong, I also can't quite tell why
the change is necessary.

-- 
Jens Axboe

