Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBC64356CC3
	for <lists+io-uring@lfdr.de>; Wed,  7 Apr 2021 14:56:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344101AbhDGM47 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 7 Apr 2021 08:56:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235427AbhDGM46 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 7 Apr 2021 08:56:58 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A78E4C061756
        for <io-uring@vger.kernel.org>; Wed,  7 Apr 2021 05:56:47 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id j4-20020a05600c4104b029010c62bc1e20so1115851wmi.3
        for <io-uring@vger.kernel.org>; Wed, 07 Apr 2021 05:56:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=xf3veKUIlgqe0YesC+Tc9E7Pv1vzGorvEDaLVAJ8/Vw=;
        b=RAAjoKU0nZsQhF3MaHaJdATCsN0JrGfWzWU0ywEzJe6cFZfJj7YQHA52nlM5Q8tZpI
         Jyk6YYgKFmuKm9psUIraevsWEJw5xNPJCJPWfS94lfYi53rdTjjaoVk63kF58JAgBjTr
         m6qtwvjBneOm9abzgscF0/4UjZK/5HeeMMKy7EJpG8XYJkcDHUO+PTwcw82SqiQKIBnU
         /NCP8COyxm/hTQjg/TBl7w/4OUgeBq2CQOus8Fh3a3fYNdBWeqV7cZ31mVBfrHHdArSj
         nXtk6rbz0o1f8daPDGHqgwggwlgmgb9GTylyZqBcRcWkrnSVCbZfRN+DsIFqw2M6z366
         9f5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=xf3veKUIlgqe0YesC+Tc9E7Pv1vzGorvEDaLVAJ8/Vw=;
        b=j60OTUPqkgF+JSrp0TqoqGvQPY3hNEn9LBJVRg3LjpLvJP+zkabvFB40gzVFAr6dUu
         ouxhU6eCEpGVl6meT20DHVuSTKKDFMr2MiFQzV1EBQR8OUSas6OWt3aeyVzjuOku0TYK
         cvdegRQVKDwC5T7ASIrKMx3aJ69vZQGmjD7+urYMCI79HqA/fpykON0Msw/yIBC/OqZ+
         qMFM43XiUJTEreyapCg8e+VGLbuqFCTNEFBjtLFRxP1Xt8tulNX2Vmv3OP9eZw/Gb4IF
         LFWcw9Wefh3V+WJcBWBRGJpHoRSNoXpXLqBDqyoELy//lPCR3ZLYEvwIgs5FtyduiRNV
         FKUg==
X-Gm-Message-State: AOAM531ImMxsYs8sWZMKHwPF0D7lYD5wp0eMn57IsxLg4BtPomr48Aks
        lCWXKH9i9t5cXu10nPSpFEGBh3h2Lk7c7A==
X-Google-Smtp-Source: ABdhPJywGYRkwwxoCLW83zCZhD6NXAHxB/kURptAHk7f2pXzzISxeaq/f70GdUMZky16pSRVOtiwnA==
X-Received: by 2002:a1c:6a03:: with SMTP id f3mr2931712wmc.179.1617800206461;
        Wed, 07 Apr 2021 05:56:46 -0700 (PDT)
Received: from [192.168.8.145] ([148.252.132.202])
        by smtp.gmail.com with ESMTPSA id l13sm348465wmj.3.2021.04.07.05.56.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Apr 2021 05:56:46 -0700 (PDT)
Subject: Re: Potential corner case in release 5.8
To:     Ryan Sharpelletti <sharpelletti@google.com>,
        io-uring@vger.kernel.org
Cc:     axboe@kernel.dk
References: <CA+9Y6nzQ8M++uMjJV8_LbB+HwvSZOO3kzKoRO-OaMggdU+xXTA@mail.gmail.com>
 <CA+9Y6nxMg8W8P1-_56N8ArwHvT2EUippzwd0y_zNJ+O5Hvbw0Q@mail.gmail.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <2234ef28-4357-ebaa-b707-31abadf067f6@gmail.com>
Date:   Wed, 7 Apr 2021 13:52:39 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <CA+9Y6nxMg8W8P1-_56N8ArwHvT2EUippzwd0y_zNJ+O5Hvbw0Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 06/04/2021 18:53, Ryan Sharpelletti wrote:
> On Fri, Mar 5, 2021 at 2:07 PM Ryan Sharpelletti
> <sharpelletti@google.com> wrote:
>> I suspect there is a corner case for io_uring in release 5.8.

Did you see any fail?

>> Can you please explain where the associated mmdrop/kthread_unuse_mm
>> calls for io_sq_thread_acquire_mm in io_init_req(...) are?

Look for io_sq_thread_drop_mm(). acquire_mm shouldn't do anything
unless it's SQPOLL mode and so executed by sqpoll task.

>> Specifically, what would happen if there was an error after calling
>> io_sq_thread_acquire_mm (for example, the -EINVAL a few lines after)?

Will be cleaned by io_sq_thread().

>>
>> From what I can understand, it looks like the kthread_unuse_mm and
>> mmput might be handled in the call to io_sq_thread_acquire_mm in
>> io_sq_thread. However, I am not seeing where mmdrop might be called.


-- 
Pavel Begunkov
