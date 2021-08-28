Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FD4A3FA356
	for <lists+io-uring@lfdr.de>; Sat, 28 Aug 2021 05:22:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233117AbhH1DXR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 27 Aug 2021 23:23:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233101AbhH1DXR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 27 Aug 2021 23:23:17 -0400
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D36CC0613D9
        for <io-uring@vger.kernel.org>; Fri, 27 Aug 2021 20:22:27 -0700 (PDT)
Received: by mail-il1-x129.google.com with SMTP id g8so9246018ilc.5
        for <io-uring@vger.kernel.org>; Fri, 27 Aug 2021 20:22:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=7vgw1Fd/PKlbVC0KWuXV201EVHOviDvwtaEIjPxzsmc=;
        b=0feEplWcolUTuumVgBLseSg3SrF1L5/lJyYvZ4MSxFAO+CPBECe1clt5LFch9FJp1h
         CyOMV79ah2MmyJ1zrE3fR65fMTxc5+G753g+p/ojnRJ5dX3tXL/QWXcP0F9WV9WpyTa+
         1knw4h1WvwDxABGn3G08HFJcPuIS/uh3D0Oc+IJ36nDr06iw2GYIO7ntzYGJ/ezceoB0
         i+zCglCukgoRyMYgoTQ4CoNGcAfxxttVRVpjU2QtdS1Wvho26aoyXZzqZbueZnt2CDat
         Zc2cO5pZVI1hmHOdteLftNp2I55+amaF/sFw+DIbIcsvjNdrLIolfQ1p2sEoVoYbx8nT
         fcOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7vgw1Fd/PKlbVC0KWuXV201EVHOviDvwtaEIjPxzsmc=;
        b=Ja74Nmy+sESQAKupSRFZVZ43fMgkz83+Y+0hhVUtIRxpDxjIbSvsM2AX0UPKBwEykF
         88LjVqNuJ7xP7elfhdW61Tz8okVGdjxC58hq9vqfGsyl7DemrhdYFm0SaT3RozHz/1gb
         WWOjTOX2gu3+kSpwlJS3KZfZ0ojaMmBB4QWaeMXnxcz2uAS+nRP8nO83VCNXCKw7rXlw
         84f9AhQFvm2dOGXLRYOu9vM7mjS16dqJ0eB2H+aY2vWwMQls7V7RzxIHbxeXN7dNTS2L
         6nfyuZEAT/5NWpY1PihM8Ea/Jmn2b0bNbTZRi4wWUTXNUzXxwzwJnm5aT0o9JkYsqwv5
         KONQ==
X-Gm-Message-State: AOAM530SoVmGLTSKwrcb+22OOWmTSiVMPCSxiYZBWnF9go+A46MjITJt
        paEWQ2OONHBbmyb6ccI2WrV9JCZMOk7hSg==
X-Google-Smtp-Source: ABdhPJx0ozC5IubSpIrJKUyrE4jdVOvpPWtbAZ5hri3Aj+JkZXStFGeaqVeP4mkHmOU47im+b3Ky/Q==
X-Received: by 2002:a05:6e02:2184:: with SMTP id j4mr8860759ila.30.1630120946479;
        Fri, 27 Aug 2021 20:22:26 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id r18sm4459355ioa.13.2021.08.27.20.22.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Aug 2021 20:22:26 -0700 (PDT)
Subject: Re: io_uring_prep_timeout_update on linked timeouts
To:     Victor Stewart <v@nametag.social>,
        io-uring <io-uring@vger.kernel.org>
References: <CAM1kxwhHOt1Ni==4Qr6c+qGzQQ2R9SQR4COkG2MXn_SUzEG-cg@mail.gmail.com>
 <CAM1kxwi83=Q1Br46=_3DH46Ep2XoxbRX5hOVwFs7ze87Osx_eg@mail.gmail.com>
 <CAM1kxwiAF3tmF8PxVf6KPV+Qsg_180sFvebxos5ySmU=TqxgmA@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <1b3865bd-f381-04f3-6e54-779fe6b43946@kernel.dk>
Date:   Fri, 27 Aug 2021 21:22:25 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAM1kxwiAF3tmF8PxVf6KPV+Qsg_180sFvebxos5ySmU=TqxgmA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/26/21 7:40 PM, Victor Stewart wrote:
> On Wed, Aug 25, 2021 at 2:27 AM Victor Stewart <v@nametag.social> wrote:
>>
>> On Tue, Aug 24, 2021 at 11:43 PM Victor Stewart <v@nametag.social> wrote:
>>>
>>> we're able to update timeouts with io_uring_prep_timeout_update
>>> without having to cancel
>>> and resubmit, has it ever been considered adding this ability to
>>> linked timeouts?
>>
>> whoops turns out this does work. just tested it.
> 
> doesn't work actually. missed that because of a bit of misdirection.
> returns -ENOENT.
> 
> the problem with the current way of cancelling then resubmitting
> a new a timeout linked op (let's use poll here) is you have 3 situations:
> 
> 1) the poll triggers and you get some positive value. all good.
> 
> 2) the linked timeout triggers and cancels the poll, so the poll
> operation returns -ECANCELED.
> 
> 3) you cancel the existing poll op, and submit a new one with
> the updated linked timeout. now the original poll op returns
> -ECANCELED.
> 
> so solely from looking at the return value of the poll op in 2) and 3)
> there is no way to disambiguate them. of course the linked timeout
> operation result will allow you to do so, but you'd have to persist state
> across cqe processings. you can also track the cancellations and know
> to skip the explicitly cancelled ops' cqes (which is what i chose).
> 
> there's also the problem of efficiency. you can imagine in a QUIC
> server where you're constantly updating that poll timeout in response
> to idle timeout and ACK scheduling, this extra work mounts.
> 
> so i think the ability to update linked timeouts via
> io_uring_prep_timeout_update would be fantastic.

Hmm, I'll need to dig a bit, but whether it's a linked timeout or not
should not matter. It's a timeout, it's queued and updated the same way.
And we even check this in some of the liburing tests.

Do you have a test case that doesn't work for you? Always easier to
reason about a test case.

-- 
Jens Axboe

