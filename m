Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFC6A2DE680
	for <lists+io-uring@lfdr.de>; Fri, 18 Dec 2020 16:27:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727302AbgLRP0q (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 18 Dec 2020 10:26:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725776AbgLRP0p (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 18 Dec 2020 10:26:45 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46F2AC0617A7
        for <io-uring@vger.kernel.org>; Fri, 18 Dec 2020 07:26:05 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id y17so2573442wrr.10
        for <io-uring@vger.kernel.org>; Fri, 18 Dec 2020 07:26:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=LLwvtd8/fiStk247VT8HegTzZLorovSVA7h422L8Ahk=;
        b=bJkbeB8AErEMDJx7srbdc02TOH78C8HGVPADuWxEoZwUnCMQYbP2AwEdVU1oi4haf7
         gq214Pde+dHnreIUCIfIKIZo7BODj/VFEdMPPXZm0Z9jQnSoaYpLkqdPyfml8gLgrkbD
         OLDpU5SMTDNTdWvjFZTafDGGznhr4mmbrCM1pIUVuEGhDJ2IuLdfOSwA6rHsnKf1quKO
         0hXXuIgTRU63j4f2lPRG6Uzhvv4OjsacoGpr5Mb69CDJPHgPcitoOp18NqmXmFh9FBLd
         a0Ig1YiX0yI1y0Ktr9dmKp8onBILbomgeWSZ2OXPLR6QIA1tG++jxrbGGx9l+mGr58mZ
         O2dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LLwvtd8/fiStk247VT8HegTzZLorovSVA7h422L8Ahk=;
        b=acZ/2RLc6a690dcSTxVhYM860S2S3O/vZzb2MUsUvub+rUchx2Z/TJatNDe7QWFefU
         fa1C+yg/Yy0bbXHHuFDgmIsAHsmcxulFdNjs3QjbEBmnEs8pQnFJbovx5/J96Gjy4wjc
         f8e4ByF7UitAPYcnFu/Qn/T/e5zLoMtgb26lKfys91BUNBvcgjBXwTdQmHZGThYubomk
         vLn5xnvU6qas/2gRxmnjtdlv1w6f/vUfbllkrOCVLf8lP26E1tY6j66IcAgtMepcXCKT
         al9ixZFh5pqvfRm8mWiNeaVlWVyUA6Ms37D5RnoX89Rt5uveK0QJ04B34iAuQWzsVQq3
         5F3w==
X-Gm-Message-State: AOAM530XdxL1DAo4N/ILdepXm6es6WwzScIpX8Dm5q814aPt/YzO3lA6
        H82BobJUaojxXNdrjT/DwpzN/6D4MkNw2A==
X-Google-Smtp-Source: ABdhPJzoCgW8KSPwqKAqDhIPDMERFZ+xDVklhxMvyo99m0Xg0kBfcTyPWTIwBItWyHKe11AHu1L0OA==
X-Received: by 2002:adf:f18a:: with SMTP id h10mr5331470wro.244.1608305163683;
        Fri, 18 Dec 2020 07:26:03 -0800 (PST)
Received: from [192.168.8.132] ([85.255.234.120])
        by smtp.gmail.com with ESMTPSA id t188sm11751595wmf.9.2020.12.18.07.26.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Dec 2020 07:26:03 -0800 (PST)
Subject: Re: [PATCH 0/8] a fix + cancellation unification
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <cover.1608296656.git.asml.silence@gmail.com>
 <17d4ffd5-9d11-1ffe-cdee-cc114dedec4b@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <dcd63c20-d85a-7aef-d48d-03d2978803cd@gmail.com>
Date:   Fri, 18 Dec 2020 15:22:44 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <17d4ffd5-9d11-1ffe-cdee-cc114dedec4b@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 18/12/2020 15:16, Jens Axboe wrote:
> On 12/18/20 6:12 AM, Pavel Begunkov wrote:
>> I suggest for 1/8 to go for current, and the rest are for next.
>> Patches 2-8 finally unify how we do task and files cancellation removing
>> boilerplate and making it easier to understand overall. As a bonus to it
>> ->inflight_entry is now used only for iopoll, probably can be put into a
>> union with something and save 16B of io_kiocb if that would be needed.
> 
> I've added 1/8 to the 5.11 mix for now, I'll get back to the other ones.

Sure, I'll keep track of the rest. Thanks

-- 
Pavel Begunkov
