Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90221404011
	for <lists+io-uring@lfdr.de>; Wed,  8 Sep 2021 22:10:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352422AbhIHULk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 8 Sep 2021 16:11:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350524AbhIHULj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 8 Sep 2021 16:11:39 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8B75C061575
        for <io-uring@vger.kernel.org>; Wed,  8 Sep 2021 13:10:30 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id q11so5017422wrr.9
        for <io-uring@vger.kernel.org>; Wed, 08 Sep 2021 13:10:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=fYjHragZ7UAJOtUTBGK1KqOrHsqpYfo+eKFlfTsWltg=;
        b=mDuoBdmGxQ890bLGeGnEvBTN82mnUH3tjM6aUplGm5v+dQW1cOt/DVU4NxJDcEsWm+
         wGPF2xqfnrCNoYUt34y8HraV9upQUBNAQws/jECjXR70H2ej2L5xAlRvn9mPqzCV6U2d
         XKJD1blVUG3wvErDtlbuepcieX0caOG/sogR/GECkunxvRj0967yONZ7hr8d7b/nyyXS
         /UpwYsqI4f6AEULg5Vem1BmjMzsXNq6t0uMBUpiVz3vgGaqIVGKSU16bcqE33OlGJfth
         Mm9V4JM9E1YIyro21UzLZZB/A6ZxuNgXIIsJpJf/8gUn8MWep53yYVMQsfmOIe705MmN
         v42A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fYjHragZ7UAJOtUTBGK1KqOrHsqpYfo+eKFlfTsWltg=;
        b=VYCJ3+f3O6HPE83xmOBZehRC4OU3geanrbae6ToDRZbOUNKnsX2iyuwQXYqn1OFOgD
         XvLh1Kct7HjrILqjBkHdYncZXWEHVmKQaIgTvs3iWJopapv0HndYblQ0+eD6m4ICC5tr
         8yGY5GofP5+eE0yKBA9meVSSssSXE0JZiKCx7aXdptPdZC0qPZxmLIUqjU2RnTE6QWJJ
         9H2vrLZQmNS5ipJFTCVjuA9uERNjoTZ/FdtAQmOSHhVVBTQCUftbMtsZQg1zKSmny3jy
         vyQw4WWZBZIz+hsLblvpVldX4yRdDo8KekoMzODRNpTK5K4E6MuyMrTRCsFxwgPS353m
         yn9A==
X-Gm-Message-State: AOAM530l6gY4CSlloSDnVXUYSVv/K05hIUCv7ZLW8P/If9bGYb5wtrfw
        p22PILp97ruOfYQUQvt2C1+Nyag6YBE=
X-Google-Smtp-Source: ABdhPJy6WPJZZdnEtubm3iIcADg9wXnilgVLnNm1twH/7f9DSiEtIoeDSdy+ouZj9V/ubJAn4N+A4w==
X-Received: by 2002:adf:b7c2:: with SMTP id t2mr63679wre.375.1631131829151;
        Wed, 08 Sep 2021 13:10:29 -0700 (PDT)
Received: from [192.168.8.197] ([185.69.144.232])
        by smtp.gmail.com with ESMTPSA id m8sm57515wms.32.2021.09.08.13.10.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Sep 2021 13:10:28 -0700 (PDT)
Subject: Re: [PATCH 1/1] io_uring: fix missing mb() before waitqueue_active
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <2982e53bcea2274006ed435ee2a77197107d8a29.1631130542.git.asml.silence@gmail.com>
 <bd0b0727-d0ac-7f2a-323d-39411edbe45d@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <34219094-7e90-a665-2998-4658f3becdff@gmail.com>
Date:   Wed, 8 Sep 2021 21:09:56 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <bd0b0727-d0ac-7f2a-323d-39411edbe45d@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/8/21 8:57 PM, Jens Axboe wrote:
> On 9/8/21 1:49 PM, Pavel Begunkov wrote:
>> In case of !SQPOLL, io_cqring_ev_posted_iopoll() doesn't provide a
>> memory barrier required by waitqueue_active(&ctx->poll_wait). There is
>> a wq_has_sleeper(), which does smb_mb() inside, but it's called only for
>> SQPOLL.
> 
> We can probably get rid of the need to even do so by having the slow
> path (eg someone waiting on cq_wait or poll_wait) a bit more expensive,
> but this should do for now.

You have probably seen smp_mb__after_spin_unlock() trick [1], easy way
to get rid of it for !IOPOLL. Haven't figured it out for IOPOLL, though

[1] https://github.com/isilence/linux/commit/bb391b10d0555ba2d55aa8ee0a08dff8701a6a57

-- 
Pavel Begunkov
