Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A0DD48592F
	for <lists+io-uring@lfdr.de>; Wed,  5 Jan 2022 20:31:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243475AbiAETa7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 5 Jan 2022 14:30:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231584AbiAETa6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 5 Jan 2022 14:30:58 -0500
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4E6FC061245
        for <io-uring@vger.kernel.org>; Wed,  5 Jan 2022 11:30:58 -0800 (PST)
Received: by mail-io1-xd2a.google.com with SMTP id y70so388381iof.2
        for <io-uring@vger.kernel.org>; Wed, 05 Jan 2022 11:30:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=DMDyVFtwDqG7zCTgnBPM/RrWzwScfQ0OQCuIiJfEtKw=;
        b=uG54arT6RqfHaPHgXk3nwdqxgRz3XKT51x0cp9cpIHnDAtHjqpq/vLdnGsGX5dL9VG
         wWYqTbSM/II/30qgOZO/ZTDB/CniH4t6V5H50ufWhSD3Sp4t6P1i2OsUgUznfKbkpSUz
         OWAA/OxZj0NyMJfUbOEkbzzKIzyXZVKsMSMjWpsFD3RrnIqVULqyb0Zj6RRGMwERk3hF
         Vk6S5vpBBP6Ir/OhepgzAL3JGVbia44TiG72J1uedmXvdHvWw8RyQ2vwT+cqEyffmLQ/
         aEQsS0BLo+NZqScB42EreMzOEbNYZ7mJGkEGlDsBKYl5fmgc+DJ4B+wQxicWQIcoKJ+S
         SaJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DMDyVFtwDqG7zCTgnBPM/RrWzwScfQ0OQCuIiJfEtKw=;
        b=5HWUUvikBqJUgMDsWomQe9d0NV+y/EC9uRrQaC4hCIMmFKusgyGFYJcnLrPzVQZRYM
         4XYYeUUbfD68Ny2qFv1FZbNnmLLKJ+O1HsC5vpwATLA19Lh3VvWhxocZpY6gOQCrrstU
         9EyxBo16CKvKPgZTYzRX1Ua98c5s11IsLe9EIcAr8bvqKQRn2YNoUx0pS3b/n9rTkWW4
         AAQLx4mSBqGPq1aWecQ4gnliXvG0Bo4/qipGWZ21TMcFagUO9dyXaJda81HpG31QODwn
         HXAU3qSkCyVjsKP6QYLXcZlbkyXUpgkQLjfyB7i4CPoyyMz1R5YRcuDV4Y0RWUkKOof3
         3ePg==
X-Gm-Message-State: AOAM530f2fJJiPG4w2x8jijKSVQbMEfmx118WgXUtpqnuLm1/CFL4OX1
        U20qCMQlGiNXJmJpojrQ/p151g==
X-Google-Smtp-Source: ABdhPJxAjdF18pppt7QsGuUeqs5t3GeE6qeeALB1KYU5MTy/EqK6/mPlT+h5EUjSykkKLKsxA7R0vQ==
X-Received: by 2002:a5d:944a:: with SMTP id x10mr25007319ior.18.1641411058036;
        Wed, 05 Jan 2022 11:30:58 -0800 (PST)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id z13sm6024551iln.43.2022.01.05.11.30.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Jan 2022 11:30:57 -0800 (PST)
Subject: Re: [PATCH] io_uring: remove unused para
To:     GuoYong Zheng <zhenggy@chinatelecom.cn>, asml.silence@gmail.com
Cc:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1641377522-1851-1-git-send-email-zhenggy@chinatelecom.cn>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <296e66fa-e8a1-4888-92e3-6f5093c5378d@kernel.dk>
Date:   Wed, 5 Jan 2022 12:30:56 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1641377522-1851-1-git-send-email-zhenggy@chinatelecom.cn>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/5/22 2:12 AM, GuoYong Zheng wrote:
> Para res2 is not used in __io_complete_rw, remove it.

Applied, but changed 'para' to parameter. Please just spell it out,
there's no point in being too verbose here. Also added a Fixes tag:

https://git.kernel.dk/cgit/linux-block/commit/?h=for-5.17/io_uring&id=00f6e68b8d59bf006db54e3e257684f44d26195c

Thank you!

-- 
Jens Axboe

