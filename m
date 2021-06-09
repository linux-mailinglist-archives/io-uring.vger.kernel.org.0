Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08E423A19E8
	for <lists+io-uring@lfdr.de>; Wed,  9 Jun 2021 17:36:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232474AbhFIPim (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 9 Jun 2021 11:38:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234462AbhFIPil (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 9 Jun 2021 11:38:41 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21783C061574
        for <io-uring@vger.kernel.org>; Wed,  9 Jun 2021 08:36:46 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id l184so4252757pgd.8
        for <io-uring@vger.kernel.org>; Wed, 09 Jun 2021 08:36:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=6cUjbI8DzEWasfSNBDu27xndvzA9NXmUw548uCVLhPI=;
        b=lNmMef1O8vtqg4ChZMuBR/owSDFGeJZSbYYUWkDhIELerjpSI3r2GS2aYVCXB9P0CP
         2I3Kmjo+p2OH5cE4UIaWlnbAHRNpI+XqBJBPua+9FwHTJezrChmiERkLN6+TLyd+rzkE
         1qT1soOTo/xOoHy0qJ8x2oszxJST/QP2494JVUtn/DacBboIQV53ZnccsCrd9jvdwc3J
         /dG1PT7jeQbh8FlxmB9ug4zicFtBWUX1RSYLqbGS2mFv3BTZBq7oJ5zCKU9VG+y5/12j
         kENYzZ7r1VYucSNpMzz/1aw/i//QZImyqtsAlqZ5PCnoPKpRff90KnIk9mPKETKY0L1U
         KwPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6cUjbI8DzEWasfSNBDu27xndvzA9NXmUw548uCVLhPI=;
        b=qr3/8sgi2szjiThj9tHrngGF1/1o5X8JTQxYI28AJK2XLgKljqmLjwGKi/fIPxprE7
         2o5pzJ2YaY+ZRlObk2l7kwU1ju3+4QdPqFBDPLFIRMkokkbCqAGXokv+A6l4LeEqvEHT
         a34xRqlrV6KXL5QUgtKPp67BW9HpqcJskkGm8vro3J6RfYZD4NkibXTbfOWJDwCi3oyC
         GKTFMvPiHlFK+h3xZYdg/A890I4R7py/igei12XySSQplo9ZHGmLgYWQhcy5sFJortUF
         bh1RLwkMocyJEXSYibDNr/jF/Xe81F34QFXixsymau7BGg2QEIoPGl1CqkAdm9mIxaIn
         S2JA==
X-Gm-Message-State: AOAM533eQc5kaCOANc2fxRfs5VYmZ3XSn5+nqdaOA4NlBsN16KXbGX2q
        pvY8oxI3+CIgRXIsdWfDDiD8QwzmKJcv7w==
X-Google-Smtp-Source: ABdhPJxwtnX9iwHy+FmQPaywhRR4UgCnYu7obfp443nru0092anWxmkSKpcILmX1DSMjjc1mxluMYw==
X-Received: by 2002:a63:175e:: with SMTP id 30mr317987pgx.48.1623253005196;
        Wed, 09 Jun 2021 08:36:45 -0700 (PDT)
Received: from [192.168.4.41] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id u24sm31755pfm.156.2021.06.09.08.36.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Jun 2021 08:36:44 -0700 (PDT)
Subject: Re: [PATCH] io_uring: fix blocking inline submission
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <d60270856b8a4560a639ef5f76e55eb563633599.1623236455.git.asml.silence@gmail.com>
 <e3edab99-624d-6f24-a6ba-63589d00eeee@kernel.dk>
 <e6283f40-52ab-ddcc-131c-309e34321613@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <cb972cf9-c35b-51f3-7216-13437285cda2@kernel.dk>
Date:   Wed, 9 Jun 2021 09:36:43 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <e6283f40-52ab-ddcc-131c-309e34321613@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/9/21 9:34 AM, Pavel Begunkov wrote:
> On 6/9/21 4:07 PM, Jens Axboe wrote:
>> On 6/9/21 5:07 AM, Pavel Begunkov wrote:
>>> There is a complaint against sys_io_uring_enter() blocking if it submits
>>> stdin reads. The problem is in __io_file_supports_async(), which
>>> sees that it's a cdev and allows it to be processed inline.
>>>
>>> Punt char devices using generic rules of io_file_supports_async(),
>>> including checking for presence of *_iter() versions of rw callbacks.
>>> Apparently, it will affect most of cdevs with some exceptions like
>>> null and zero devices.
>>
>> I don't like this, we really should fix the file types, they are
>> broken if they don't honor IOCB_NOWAIT and have ->read_iter() (or
>> the write equiv).
>>
>> For cases where there is no iter variant of the read/write handlers,
>> then yes we should not return true from __io_file_supports_async().
> 
> I'm confused. The patch doesn't punt them unconditionally, but make
> it go through the generic path of __io_file_supports_async()
> including checks for read_iter/write_iter. So if a chrdev has
> *_iter() it should continue to work as before.

Ah ok, yes then that is indeed fine.

> It fixes the symptom that means the change punts it async, and so
> I assume tty doesn't have _iter()s for some reason. Will take a
> look at the tty driver soon to stop blind guessing.

I think they do, but they don't honor IOCB_NOWAIT for example. I'd
be curious if the patch actually fixes the reported case, even though
it is most likely the right thing to do. If not, then the fops handler
need fixing for that driver.

-- 
Jens Axboe

