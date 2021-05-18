Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 456E43875C8
	for <lists+io-uring@lfdr.de>; Tue, 18 May 2021 11:54:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242914AbhERJ4G (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 18 May 2021 05:56:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241006AbhERJ4F (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 18 May 2021 05:56:05 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F8D4C061573
        for <io-uring@vger.kernel.org>; Tue, 18 May 2021 02:54:47 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id z17so9473840wrq.7
        for <io-uring@vger.kernel.org>; Tue, 18 May 2021 02:54:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=JvecSrP9x/KMAZX4pNzcbiPl3UglER5OLg4o0TUv1lA=;
        b=rip/D4sNdxO8H5SLUBRs+AIK6QCQV7iGGsx2jU8Qcejrpjcizn6jWZ6+fo/sK45BJ0
         SP/cERUJKSKS5++H9KJhzDTN1CF59Hn55qrqXG6lj3N3ScPBJ1k/DkqUAY+w6HAiI5dq
         T4p0z2FT+lvREBWejL1fy5SjMpNnhn709QbI/E/VBh4+zaFvvAN11RC1S6nEdcIU4q9p
         ALYnmk9ErX/ur6ndAghns6ejU9eWNSCyR2o/JTeO3Wd15EGnHwIj3v/cfcufRwmKr/CG
         hEZIXGjta37nTsG4uGHPx/BFjf9oGmpUtQqIBlGhypdHkiyUvAFSqPum2OtmfSffLxxH
         cJTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JvecSrP9x/KMAZX4pNzcbiPl3UglER5OLg4o0TUv1lA=;
        b=oNJ/xXZh7c8FynWFErkjmZAzQ/tELZUMErKiNtAePqoPzSRiHqmpqYui9h/iM+3CLO
         lN9ppT5Zt3uT2iDkVRxEqeY6LOYJnw1xfu1XYfBdjdZ00oMsa6+PTZp86EWsfXvyCsWe
         ZqYox/f+WI3EEfzAhc1ieiAVxEdz1u2Bx8QUgQuEPGmD+oiF7nA5EnEs56GYI84S2Y7l
         HEB4soDaFoGb0umlp7F3BodEkI2LLsYGYCDp9qU1t/B8eHb4zShNfCSgqFlEEfnxiYa+
         APvHZkE4VgUUyuyJc+C4f0TP0MIb6dphkkW7WKB8HGkzAzgYFFQWUAc/VoERtlEVTavg
         VDZw==
X-Gm-Message-State: AOAM532R7coDwr5xnmA17uu0Q7mCSXQAZYn5te+MYTvuajFU9SC5vcQ4
        mp27LHuYYZB9Du/1yD0wLnI=
X-Google-Smtp-Source: ABdhPJwxyJftkYURyksX0bVk/YeLdjloBd7BKFDRBbFGbbwo4TBI7ubuX0G40IazpqWFs86hEGvkow==
X-Received: by 2002:adf:e84e:: with SMTP id d14mr2302280wrn.323.1621331685788;
        Tue, 18 May 2021 02:54:45 -0700 (PDT)
Received: from ?IPv6:2620:10d:c096:310::2810? ([2620:10d:c093:600::2:f06d])
        by smtp.gmail.com with ESMTPSA id g5sm7363957wmi.8.2021.05.18.02.54.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 May 2021 02:54:45 -0700 (PDT)
Subject: Re: [PATCH] io_uring: add IORING_FEAT_FILES_SKIP feature flag
To:     Drew DeVault <sir@cmpwn.com>, io-uring@vger.kernel.org
Cc:     noah <goldstein.w.n@gmail.com>, Jens Axboe <axboe@kernel.dk>
References: <20210517192253.23313-1-sir@cmpwn.com>
 <b836b9cd-e91b-7e46-ce29-8f32e24fb6ab@gmail.com>
 <CBFWQ64F7PWU.3EOQ3BQXFHZY7@taiga>
 <7f2c075d-bf3a-7101-23ac-ef63eecb70cd@gmail.com>
 <CBFWWQBIO18Q.18PQR27VN9NEV@taiga>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <f1cf7294-3730-a6b8-a023-5e38c497cbb6@gmail.com>
Date:   Tue, 18 May 2021 10:54:38 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <CBFWWQBIO18Q.18PQR27VN9NEV@taiga>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/18/21 12:33 AM, Drew DeVault wrote:
> On Mon May 17, 2021 at 7:32 PM EDT, Pavel Begunkov wrote:
>>> What is the relationship between IORING_FEAT_NATIVE_WORKERS and
>>> IORING_REGISTER_FILES_SKIP? Actually, what is NATIVE_WORKERS? The
>>> documentation is sparse on this detail.
>>
>> They are not related by both came in 5.12, so if you have one
>> you have another
> 
> Gotcha. I'm open to a simple alias in liburing, in that case. I'll send
> a new patch tomorrow morning.

At least there won't be one release delay between feature and the flag
this way as it can't lend earlier than 5.13

-- 
Pavel Begunkov
