Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C30E3A1893
	for <lists+io-uring@lfdr.de>; Wed,  9 Jun 2021 17:07:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232629AbhFIPJb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 9 Jun 2021 11:09:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232498AbhFIPJa (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 9 Jun 2021 11:09:30 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 579B0C061574
        for <io-uring@vger.kernel.org>; Wed,  9 Jun 2021 08:07:35 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id q25so18600051pfh.7
        for <io-uring@vger.kernel.org>; Wed, 09 Jun 2021 08:07:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=42VwcY+kjtDmTEiCuwAgf6grIVCFjKRXhmn8qADe3GA=;
        b=GARUJxehv0czSdZpBY4fHxaEfymOADgPJXkCu2KnsH5MmDRsK2pU6Jce/7psodSK3j
         NAR5OQMfqyXsLYbSlUUUSHS/CiDglGloOCfcw1+zShpR9+O+xxx8IE2aTDzL6I3SHIqL
         OvJRpu9G53lAOKcnIDpAWPT1QWmyridVUxDBSkDe02o5NsvjlxZHzTNiQYt38BvgEnqj
         g+fdLvpWIi9CIA83KTJkS624g9+QpC9FLGRQr1dIgXAeKRrSr1tWoV1f94lHxyvPOFFq
         ZLi+jidI1O90N+X0gzFPgQgluEt+N1WSZgQifdBVVX9CkDmkSiaL3NBuGAD3cQfWdNqb
         xaaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=42VwcY+kjtDmTEiCuwAgf6grIVCFjKRXhmn8qADe3GA=;
        b=nIbRm5jxxb0hOQzv/mH0bceSOIgStU+nSXw87LpJ/VTdwlYIH5vstED7APc3Bc9hcJ
         ilIhxTuruT5Zgg3o189r8kvKyz6dWfglWf8mTc4Ec0CPQ12c/A7Z69ll7xGQuWNASW0B
         pXF6Erau+ncFBB+EOzEKGJXtzL17k2VME8r7VTQgSmFZ5aiVKB9/B+2mrQrAYMm5smAm
         p05GBXbKrw1uTZ7gqIc6uy2/iEEL5FmhKiVAVnmXLT3RJhECewMx/ZtZpSmWWKX2qQ8a
         qYWjIUVwnHMwvvT+H13JNXRnzwVMtPpgQNJozetyO0tCQW18QTWa+C5KTCbKiX3dUuge
         114w==
X-Gm-Message-State: AOAM533f0o4UZqMlgaFMeGU/8F8ZaW28KS0Fs1BaIwPqBfINJYvgugq/
        qGXawTEchOwL4QPciNe7rSjYFhFcwsErMQ==
X-Google-Smtp-Source: ABdhPJwNEFHCwx0QH2GekM2m0DwMeilCho5W9vYdgdqT+oxfoX9cOPb5GM8FUEK2TGXG28AEMqfhVA==
X-Received: by 2002:a65:6549:: with SMTP id a9mr132532pgw.213.1623251254370;
        Wed, 09 Jun 2021 08:07:34 -0700 (PDT)
Received: from [192.168.4.41] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id h16sm14032104pfk.119.2021.06.09.08.07.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Jun 2021 08:07:33 -0700 (PDT)
Subject: Re: [PATCH] io_uring: fix blocking inline submission
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <d60270856b8a4560a639ef5f76e55eb563633599.1623236455.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <e3edab99-624d-6f24-a6ba-63589d00eeee@kernel.dk>
Date:   Wed, 9 Jun 2021 09:07:35 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <d60270856b8a4560a639ef5f76e55eb563633599.1623236455.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/9/21 5:07 AM, Pavel Begunkov wrote:
> There is a complaint against sys_io_uring_enter() blocking if it submits
> stdin reads. The problem is in __io_file_supports_async(), which
> sees that it's a cdev and allows it to be processed inline.
> 
> Punt char devices using generic rules of io_file_supports_async(),
> including checking for presence of *_iter() versions of rw callbacks.
> Apparently, it will affect most of cdevs with some exceptions like
> null and zero devices.

I don't like this, we really should fix the file types, they are
broken if they don't honor IOCB_NOWAIT and have ->read_iter() (or
the write equiv).

For cases where there is no iter variant of the read/write handlers,
then yes we should not return true from __io_file_supports_async().

-- 
Jens Axboe

