Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2213716B045
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2020 20:30:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726452AbgBXTaf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 24 Feb 2020 14:30:35 -0500
Received: from mail-io1-f66.google.com ([209.85.166.66]:40453 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725860AbgBXTaf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 24 Feb 2020 14:30:35 -0500
Received: by mail-io1-f66.google.com with SMTP id x1so11481555iop.7
        for <io-uring@vger.kernel.org>; Mon, 24 Feb 2020 11:30:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=1dQyKD0IoAObv4kQrfcb5tTp+mP2as1gz8jCcHjazLk=;
        b=y3PPNI8u0qhXXWir4R5c1nYWZV0z659B1GF9rlJbmAcbdkxyE55ow1dZhqzwvvwnxO
         sl2O6IU0WItF3tLTNbIt1vQ0B+r0UxgkMDv0Q8aLjxYtBD9UKIWREmG8X0fZvx1K8uMx
         26ESoMGYIHB7R3q5BMUFP/C/mQzYgmmQdF43NgIMhrxECw/8zUrehXZcsiS70Zn2eGE0
         HobL+DLd7mRfm9flPohJFXMpORxBtctF7FgG51jmnsNC8nN2XvyXc+QM5eJBFuixAjje
         Uswwx2+K78+qHYqyl2DNC7nma5nxm4PpWfs0kZp7q186hIPTW29hHOtXOzaVnCEvMrf4
         C6zA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1dQyKD0IoAObv4kQrfcb5tTp+mP2as1gz8jCcHjazLk=;
        b=ZgRGqxyrjOhGgFs4WjTKq+slmaSsGCmdES/9fG86ewhQ2HYMUpZH7iJUbaFpEYSE2/
         TrOfy7lccKWBjdckJpj5HFCcfsuUVfzJNOfRoErW57NeNAI/LDOixJcHOh/Sgw7a9shx
         Ezq+tOl8OhNoQWFt12EiXSk4bbrDiwR8W0gnBTGFPGc8WkKWv3A5+DqFEtSH9RPA95JK
         xZYZLejZ0xPkNbOFvjEDu0DpDdi0pa7GRIEFfTqA+Li2laLxeNqwD9WeCOdKQYw9SUve
         d5QySJ80Th8a+txHOxk9hF1iztLeu0EeyHWr65OY7pyRenV9Iiwy1zOji+Tl0aV4Rh4x
         H0Lg==
X-Gm-Message-State: APjAAAV1efUO6cVeqzgFZmzGyed9KufhTClepasHzYD2hBdlpCn1UZdM
        cYCVAKnymoKmtKpWFxR/WG356X6M6pI=
X-Google-Smtp-Source: APXvYqwHG+LtR5I8GsbNWCDgzOTudkDWHgJXqMS83PUNtmNFgjPZMiw522ibrapKEM1JbkDhQYPidQ==
X-Received: by 2002:a05:6602:20d9:: with SMTP id 25mr50392384ioz.181.1582572633100;
        Mon, 24 Feb 2020 11:30:33 -0800 (PST)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id t88sm4653327ill.51.2020.02.24.11.30.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Feb 2020 11:30:32 -0800 (PST)
Subject: Re: [PATCH liburing v5 2/2] test/splice: add basic splice tests
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1582566728.git.asml.silence@gmail.com>
 <aa79d4a192bd1a8e68beddfb177618c1cdacf381.1582566728.git.asml.silence@gmail.com>
 <56c83973-db0f-cc25-4b78-6c9a74431d2a@kernel.dk>
 <060087a8-a6c1-b44c-1b7c-3fc0de3a4a5d@gmail.com>
 <12eb524a-cc65-48e1-d82e-5e3d07ff444a@kernel.dk>
 <20e51d15-82d8-3e91-a1ca-36dccd9d30e7@gmail.com>
 <89272517-d4c4-1a0f-f955-af2b1c1a337f@kernel.dk>
 <c863a99f-aa29-4629-a959-53c584f4d2ed@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <c54b27bb-0eb0-000f-ab6c-6fcb62a9730c@kernel.dk>
Date:   Mon, 24 Feb 2020 12:30:32 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <c863a99f-aa29-4629-a959-53c584f4d2ed@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/24/20 11:47 AM, Pavel Begunkov wrote:
> On 24/02/2020 21:41, Jens Axboe wrote:
>>> I've wanted for long to kill this weird behaviour, it should consume the whole
>>> link. Can't imagine any userspace app handling all edge-case errors right...
>>
>> Yeah, for links it makes sense to error the chain, which would consume
>> the whole chain too.
>>
>>>> submit fails. I'll clean up that bit.
>>>
>>> ...I should have tested better. Thanks!
>>
>> No worries, just trying to do better than we have in the best so we can
>> have some vague hope of having the test suite pass on older stable
>> kernels.
> 
> Have you gave a thought to using C++ for testing? It would be really nice to
> have some flexible test generator removing boilerplate and allowing
> automatically try different flags combinations. It sounds like a lot of pain
> doing this in old plain C.

I'm not a c++ guy, but if it's useful, then I'm open to anything.

-- 
Jens Axboe

