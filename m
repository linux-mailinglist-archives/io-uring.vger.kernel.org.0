Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 596CD3F9F37
	for <lists+io-uring@lfdr.de>; Fri, 27 Aug 2021 20:53:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230084AbhH0SyN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 27 Aug 2021 14:54:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230005AbhH0SyM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 27 Aug 2021 14:54:12 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 224D8C061757
        for <io-uring@vger.kernel.org>; Fri, 27 Aug 2021 11:53:22 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id c129-20020a1c35870000b02902e6b6135279so5021636wma.0
        for <io-uring@vger.kernel.org>; Fri, 27 Aug 2021 11:53:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:references:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=9i33O+GPH7p71loG56U8h8VKYsL55h6zTLPyhKZ+dhU=;
        b=Iipgy66ayy2y6guZ8IhbsTMwU5Vu2ORob/P/AVtuSxGlc0o2XPgxjWiH0nlgd4R2U5
         9R066Da1k0fZ3FoslhsEOa7fYL+/s3FcaU1vzkcFA4Tu8yeRfRvsnaUc4Fwv02rta1CK
         n0Lr8LzZ7pdpI1bKUdcFNCDouCAzIrg6KoA1S6T79dJsz0hvZWxwvk0XosArvOyJWfWv
         qEfgk9R2COSLM+SBW7g9+cDjr35KpOVCNREXGoU0fanPk0PnomNj+LY2UxHWw0+I+bj6
         DSKF/K6Pz/K3/TmD9SG71YgMPS+aT8pwcEBamPFYZMXusl1yw/nMXnoUMT8LL/iyWwve
         UhSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9i33O+GPH7p71loG56U8h8VKYsL55h6zTLPyhKZ+dhU=;
        b=gZb2E5nb0V7MOOx9WPNM5HOsaNCp6OeaA47kjtDF1G3EAZqcoEKS71m5QugTThsyh6
         wgl7g9rjqrpc3gc37QfinhL2qH7qzgecTd3JbkonnqtAxy9ZuUtkY+kODkxpdQPcXPtp
         ng+u4KPiEAEiwM15A9XTUK52+fm8oZC+qLx6D9ULgzw+Ao+mj1U6CxlFDma+lglgNvxD
         FoHC87AAEUxrEBkSw84MDnlGpomjD98ntJ69efQxQwwdADzkWGp6IfUe5VjZELCrUPv+
         95R3NqGXq41MF+WheT/AnteXzgliGmX5JSmeB5i0lrDE1DPEoyNJidDZTzMVvQjcgc9m
         rrOw==
X-Gm-Message-State: AOAM5327EVo6CHI4ms+oE+8q1QbDnSlDEF1TRlgQSp5Hm4TbdvpATRRJ
        +NHWQ1za2T6ERgWApmOxuNLMlZb7JC8=
X-Google-Smtp-Source: ABdhPJyVb4D7q4vq87OUuPWKmforKiIKkjGoKJNfy9JKx/LeW68aiJxaLwNdDLgK6Wiq3Rg5e453MA==
X-Received: by 2002:a05:600c:259:: with SMTP id 25mr8464944wmj.82.1630090400733;
        Fri, 27 Aug 2021 11:53:20 -0700 (PDT)
Received: from [192.168.8.197] ([148.252.128.94])
        by smtp.gmail.com with ESMTPSA id y21sm12422391wmc.11.2021.08.27.11.53.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Aug 2021 11:53:20 -0700 (PDT)
Subject: Re: [PATCH liburing] register: add tagging and buf update helpers
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <f4f19901c6f925e103dea32be252763ba8a4d2d3.1630089830.git.asml.silence@gmail.com>
 <7c95d8a0-7449-ce1e-4c7b-c6fb8537d61f@kernel.dk>
 <652de562-c9ac-3a03-fdd1-e91751eb1997@gmail.com>
Message-ID: <585bf392-6d40-569b-c60d-9ed26a714a31@gmail.com>
Date:   Fri, 27 Aug 2021 19:52:49 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <652de562-c9ac-3a03-fdd1-e91751eb1997@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/27/21 7:51 PM, Pavel Begunkov wrote:
> On 8/27/21 7:48 PM, Jens Axboe wrote:
>> On 8/27/21 12:46 PM, Pavel Begunkov wrote:
>>> Add heplers for rsrc (buffers, files) updates and registration with
>>> tags.
>>
>> Excellent! They should go into src/liburing.map too though. 
> 
> Hmm, indeed
> 
> Should it be LIBURING_2.2 or LIBURING_2.1 ?

I mean sections in the .map file

-- 
Pavel Begunkov
