Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1721380C45
	for <lists+io-uring@lfdr.de>; Fri, 14 May 2021 16:51:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232509AbhENOwX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 14 May 2021 10:52:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232925AbhENOwX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 14 May 2021 10:52:23 -0400
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0C10C061574
        for <io-uring@vger.kernel.org>; Fri, 14 May 2021 07:51:11 -0700 (PDT)
Received: by mail-il1-x134.google.com with SMTP id z1so46614ils.0
        for <io-uring@vger.kernel.org>; Fri, 14 May 2021 07:51:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:references:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=MKWQidtDHyEuZAp1OodZw8MInhWEOpr8dYrQ8eCUkc8=;
        b=XcpiXMVqZIazgKGdvYXDq5jd5KRWzU48G9WzAlP1otwRcy0P5gkJ3wlWzKn8bY2zZs
         Xksa6W7UbPWaUlPvPOM8taRBFVQ3btAoX/miGWy6RTvEtnsywPkP+zzSNT9vuybcKSzC
         2eBjLdu9hcDQKDM/NUJOMqX0jxgoyaq7gniWwSslZTuGfqK+pBuMewNrmgJ6guGvtTl6
         JouAQ6RmiUVo/JNtMtDJiqZ2JsP+ddWOtOobC6Q+1s3FhVJ3nlcahcAMIMoCWf8j1+qY
         vbPEg83w0T5WhznFDAerm+JdAWbsWy8FJq1g30svpBB2eatBhsIMgKtjk8XC/weNKwAO
         hEpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MKWQidtDHyEuZAp1OodZw8MInhWEOpr8dYrQ8eCUkc8=;
        b=WUslDfLMUehouKfas896SSiPNn4ojmoUcMkB+yc7bBX1ZG4VlBqEusWGWJguk5J2rs
         VGZZnZcq8/PQT9F94q5dxStSEblOgkal9+N4vT8ZemhT4PakDWLoPphyQgkcf9QJl3IF
         K5RVDKlr1jLAW+hDW463U3g1HnTbY5BKqRlu1N/3VbpEKlnk8O9WRj1vbDnDWW7Zne3L
         dIs/ZbBgNhtuhVZfTAkow2EA4nZnM5+LOuhwQhuKGWibCz8Q9rr/2kSiBEBzfhP4xGXw
         I4UV2NMxRNNXTVnLylgL4G96UA4M3WI/+jwAawFIP0SBF+A6IW2b0+ch8Ij3gu5Uv2ZA
         uusQ==
X-Gm-Message-State: AOAM532RMkVd/yj7ZGQGWVa5rWgGKbvvU6nAue96pVvmRupPt/UVzoTz
        5EwlezzpxbVejPTLg0JzaS3CNeTLBZ7reQ==
X-Google-Smtp-Source: ABdhPJy9zLvG8smxgUa+PYTqFIMaw3tTy6ZDupY8mkefJehzJRwuKS7iRauAsWG4cASOxKpunq+OXw==
X-Received: by 2002:a05:6e02:671:: with SMTP id l17mr40799517ilt.267.1621003870918;
        Fri, 14 May 2021 07:51:10 -0700 (PDT)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id d2sm3230057ile.18.2021.05.14.07.51.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 May 2021 07:51:10 -0700 (PDT)
Subject: Re: [PATCH] io_uring: increase max number of reg buffers
From:   Jens Axboe <axboe@kernel.dk>
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <d3dee1da37f46da416aa96a16bf9e5094e10584d.1620990371.git.asml.silence@gmail.com>
 <e5a87242-fc97-3c1b-24ab-c6f01f1032f5@kernel.dk>
Message-ID: <62421d38-a843-f769-aae4-6a8f5c43aa5f@kernel.dk>
Date:   Fri, 14 May 2021 08:51:10 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <e5a87242-fc97-3c1b-24ab-c6f01f1032f5@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/14/21 8:42 AM, Jens Axboe wrote:
> On 5/14/21 5:06 AM, Pavel Begunkov wrote:
>> Since recent changes instead of storing a large array of struct
>> io_mapped_ubuf, we store pointers to them, that is 4 times slimmer and
>> we should not to so worry about restricting max number of registererd
>> buffer slots, increase the limit 4 times.
> 
> Is this going to fall within the max kmalloc size?

Ah yes, it's just a u64 now, so should be fine. Might be worth considering
using vmalloc() for this in any case in the future, to make the allocation
more reliable. 128K of contig memory can sometimes be an issue in prod.

-- 
Jens Axboe

