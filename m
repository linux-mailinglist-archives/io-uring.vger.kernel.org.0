Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C266380C47
	for <lists+io-uring@lfdr.de>; Fri, 14 May 2021 16:51:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233096AbhENOwj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 14 May 2021 10:52:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233073AbhENOwg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 14 May 2021 10:52:36 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C301C061574
        for <io-uring@vger.kernel.org>; Fri, 14 May 2021 07:51:24 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id u5-20020a7bc0450000b02901480e40338bso2517115wmc.1
        for <io-uring@vger.kernel.org>; Fri, 14 May 2021 07:51:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=PAVACRAlhcl/lsm172YJuHsEfssQ8lLuQnUEqCt3Hqc=;
        b=qEvn3EQ7qn95Vy8/VWBS7c2ac9iVvGpWwNc036BMersx3DMlSCWyNpd5dh66GULfnQ
         uKv/nQwKyOF/anypa37chEGMIAavbr/xhfDI/erzuRvdZW3N7L9HjmDomBzEZxylQFx1
         EE3cvxDgEW0uzmOZs6fyHJGHlR4S4LGtvL99haG3cLNot0M3lKSdq8z8g2kQlFP7JMWT
         MzReyaBsDye5Aclm2+W3Rp60StYUGhf7fcQjdvFSDTu0S2060t4i0ms1BeJRrCG63X6Z
         pMcFFopjChckiO0Cj2ZGn6Y7Ve31HzrsZD1ocMI5z/O/HjUNsmL7S5w/MBwr8f38Yq5O
         GOSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PAVACRAlhcl/lsm172YJuHsEfssQ8lLuQnUEqCt3Hqc=;
        b=dyy4t2qomJwtZEZTwDZnHyxAvbuq66woCbackE/lvtxghvCqTRWVf/ZOxZ/vy6CG4f
         0EG1rqi8iUPTWrwaBMTAkYbcKDUytw97pKYqhYfaMddAdQQSqd4knc+NLplVCuDUzwqm
         Q64S0DR4qH2qjEFw/zP+cIdrDRW8dZFOa8kxcD2iM2B1hdnMwzMp0c2lPL/xeNeP5iBg
         +kx02whU+eYBO+GRl9rf0X8dYzybJmIMQz5bG1lG5nu96CdvivdRjheh+MCS5FEIj+p/
         d2PfhWd9zwsFsRrtZGvligLcFBGKq9MPPhDlLfpahiWzi3/TL9m3L87C/bHv2NbAlwVc
         L2cw==
X-Gm-Message-State: AOAM530hz6QD6i2y45zGP/rbiFHY6lPK2isYn3Lqb9tDNNmzDQNb4OsW
        /rf/2jWllZJmcmPjqOy682KySPiSUl0=
X-Google-Smtp-Source: ABdhPJyiAxEPtWkaABhZKHOpTI79MOvSgu9lRCkwycQhpeLVpaFUoMX7Wi2X/e4uHwaPdhVFGAIK1w==
X-Received: by 2002:a1c:c91a:: with SMTP id f26mr9940632wmb.15.1621003882770;
        Fri, 14 May 2021 07:51:22 -0700 (PDT)
Received: from [192.168.8.197] ([185.69.144.134])
        by smtp.gmail.com with ESMTPSA id o15sm6562717wru.42.2021.05.14.07.51.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 May 2021 07:51:22 -0700 (PDT)
Subject: Re: [PATCH] io_uring: increase max number of reg buffers
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <d3dee1da37f46da416aa96a16bf9e5094e10584d.1620990371.git.asml.silence@gmail.com>
 <e5a87242-fc97-3c1b-24ab-c6f01f1032f5@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <83982723-3787-deea-4e29-089bb31d7a1e@gmail.com>
Date:   Fri, 14 May 2021 15:51:16 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <e5a87242-fc97-3c1b-24ab-c6f01f1032f5@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/14/21 3:42 PM, Jens Axboe wrote:
> On 5/14/21 5:06 AM, Pavel Begunkov wrote:
>> Since recent changes instead of storing a large array of struct
>> io_mapped_ubuf, we store pointers to them, that is 4 times slimmer and
>> we should not to so worry about restricting max number of registererd
>> buffer slots, increase the limit 4 times.
> 
> Is this going to fall within the max kmalloc size?
> 

2^14 * 8 bytes = 128KB or 32 pages, 

Even though 128KB may be not nice, but should be way below max
limit. On the other hand that's the same amount of memory we were
allowing prior to dynamic buffer changes.

-- 
Pavel Begunkov
