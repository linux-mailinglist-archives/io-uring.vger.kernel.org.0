Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92E21414D89
	for <lists+io-uring@lfdr.de>; Wed, 22 Sep 2021 17:55:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236321AbhIVP5G (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 22 Sep 2021 11:57:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230480AbhIVP5F (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 22 Sep 2021 11:57:05 -0400
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9699C061574
        for <io-uring@vger.kernel.org>; Wed, 22 Sep 2021 08:55:35 -0700 (PDT)
Received: by mail-io1-xd30.google.com with SMTP id q3so4011630iot.3
        for <io-uring@vger.kernel.org>; Wed, 22 Sep 2021 08:55:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=f8FYLT3mAYVFq040e5OHrWxVL3xcQ98C5otdOFTtNYM=;
        b=k/60x4NrIyB6gCv/PoxLrmgQwkGl4bhk4TspOoiCrPK7TaZG9VewSq+5S8f3ZxWFCZ
         XKM1+nlLuN/JcrXrbKJAjNe9pCcCy3h2ktd7vLw+jJpw3elL5dAQry3BUfU1Hg6cTzZj
         EIKzYQsxBUtqYy2tpSqG3Lq47ZZhV8bM6oUfK4swBTsX0dyqhynUNWn6fbTtHpEXKdrk
         oMBGd/Yn3E7Fskk1INFgAEJ4wvjNaPtJlPvgW/pMQjOggsIzJuxdRm6BX1Wihhx0NKBl
         xKYCIOv95EAkf1berwAYRRMMzlLBMHiNILf8KcIy/LTiISIm4Ng22mSXIKgDPQYLdjYH
         iikg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=f8FYLT3mAYVFq040e5OHrWxVL3xcQ98C5otdOFTtNYM=;
        b=giT517CoMbPykrgrgx/eBRtj9UunlhaysWtcd2zNdgDauA5RAnvVpaH2zJopVW1yOE
         sHk+TzMiwtJmKRZEoQG5BwdquqyuzFMVkVu4ZlAIvbfC4mHfJRENNcj6UDR5Y8nu0ILE
         55Sp5Mm8vq0LdqSvxe3MNmUFU8S+8EX4J8SLn0CH2FhuQh8VVA1hlakheD9WXiFwJmiW
         DEgxwWnQ13w5lRYwAGhZu4qOFv9r5U+gbyKwDEWUJN12N+/Z2ypl9/a6gi1QMJD8cd7X
         SKix3JwHXtEomhtOaoooCAi+WfylTvDg7VBpQq0ZIzidpxoYWNbVgNekNaFgEeozVt9K
         CDuw==
X-Gm-Message-State: AOAM530tIMBisfv+bnynp3Sxt9K/vEdJ1RoGEPet3UaRB4QIjVV3BJJb
        sz4SU8IKRixxDbQn8S0pEUeO3Q==
X-Google-Smtp-Source: ABdhPJwN6Kn26wPqrcVyFX1qBiAlD21L4dtWAU4C/VSnQgdhpy+eVT3iFR2bNtsW9EcaKzwq+v8SFQ==
X-Received: by 2002:a05:6638:f8f:: with SMTP id h15mr407901jal.149.1632326135240;
        Wed, 22 Sep 2021 08:55:35 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id i5sm1201400ilj.49.2021.09.22.08.55.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Sep 2021 08:55:34 -0700 (PDT)
Subject: Re: [PATCH 0/3] poll fixes
To:     Hao Xu <haoxu@linux.alibaba.com>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20210922101238.7177-1-haoxu@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <92181585-ccd9-c12b-db31-848480644aa0@kernel.dk>
Date:   Wed, 22 Sep 2021 09:55:34 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210922101238.7177-1-haoxu@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/22/21 4:12 AM, Hao Xu wrote:
> Three poll fixes.
> 
> Hao Xu (3):
>   io_uring: fix race between poll completion and cancel_hash insertion
>   io_uring: fix lacking of EPOLLONESHOT
>   io_uring: fix potential req refcount underflow
> 
>  fs/io_uring.c | 13 ++++++++++---
>  1 file changed, 10 insertions(+), 3 deletions(-)

These look good to me, nice fixes! I'll run this through some testing and
get them applied for 5.15. Thanks.

-- 
Jens Axboe

