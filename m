Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F0E8362408
	for <lists+io-uring@lfdr.de>; Fri, 16 Apr 2021 17:34:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243343AbhDPPer (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 16 Apr 2021 11:34:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343730AbhDPPer (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 16 Apr 2021 11:34:47 -0400
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7F9EC061574
        for <io-uring@vger.kernel.org>; Fri, 16 Apr 2021 08:34:22 -0700 (PDT)
Received: by mail-io1-xd30.google.com with SMTP id a11so25979678ioo.0
        for <io-uring@vger.kernel.org>; Fri, 16 Apr 2021 08:34:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ajuPbq2KoOSxi5i/wHRwgz7F42IvaTFI6eL4te6L1IQ=;
        b=ttwAl5Em+9GXw8XpCYuS5Rk9wDJpIWpBnqKGnFBTQ7TWeYsEnAblKg8ex+vgv1tQSZ
         SBWgURHdwaO71lbEw47+qAyFEqH7OaPyaNVFeespxDqfsFTPoor8JOGrVuSzPS2sHKkr
         V/eKicBlS57QQl3+CSNe/QlpjjddhH9JD9Zdypozot4ZgbHO/1lrbdYtWyCVEaIJGQU0
         yGeMSwmcd4xJQYG8uxUgMWwiA5LhnSef6t38u5RKM5YINKBE8G10APHz9n3SqSyM7PTm
         Oh/Mie1/jfL93ahPKuhkIfuuUzyTQtq44/UnLVTrQLgVKagHggSHYbKGjTdMUaVPFpp9
         k0SA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ajuPbq2KoOSxi5i/wHRwgz7F42IvaTFI6eL4te6L1IQ=;
        b=BU/3497eT6kR00PSjDrxfbypQlWiRVmEdgit56Ko/9Wkt0Ejo0a+iQ+CItEDdiDkCZ
         FV0LBJVlek0eCRBauQSTmTtx05Yp5Biz2WLe0OaC/wm3DIUZ6a1VQv5UuW92xichpSyl
         ijeX3k8gsZjD+SSsMi32NoC9zM7Z9pEqgON/H5SajLeKOWrzxNMDdws1Olu2uDlLeNec
         Uy6/FlM/mxRBOCp+tRyD2wwAiZO5rY37Z21tOWwcaiygVy8vYzANuTWc+tuZsJ6iEfMQ
         3v6tudR4kmFjAc3l9yle1DsBM/HP0aQxCKkTaoKm+AAE+hTY//el/BgoXffkaMEG0kqh
         y7cg==
X-Gm-Message-State: AOAM530eLgtE2yCF/V6o/5l0VmVIZ2YryBbr/ajA/H8Z3ChraMdfRB+b
        rSTApFIitvwWTkY9w+g1VqzNKg==
X-Google-Smtp-Source: ABdhPJyJHNdRSB6rnKP/oluTBLt9DxPZH/0xVQBFyTUUVdDRZ75oLiA+41aNUsybWuX8QA04+426hA==
X-Received: by 2002:a02:cbaf:: with SMTP id v15mr4474339jap.118.1618587262078;
        Fri, 16 Apr 2021 08:34:22 -0700 (PDT)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id f18sm2877503ile.40.2021.04.16.08.34.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Apr 2021 08:34:21 -0700 (PDT)
Subject: Re: [PATCH 1/2] percpu_ref: add percpu_ref_atomic_count()
To:     Bart Van Assche <bvanassche@acm.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org
Cc:     Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>,
        Christoph Lameter <cl@linux.com>, Joakim Hassila <joj@mac.com>
References: <cover.1618532491.git.asml.silence@gmail.com>
 <d17d951b120bb2d65870013bfdc7495a92c6fb82.1618532491.git.asml.silence@gmail.com>
 <a393b2dd-bf2d-236d-8262-e908862789e4@acm.org>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <54cbda99-0cde-6b1c-e65a-0df96e290d90@kernel.dk>
Date:   Fri, 16 Apr 2021 09:34:21 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <a393b2dd-bf2d-236d-8262-e908862789e4@acm.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/16/21 9:31 AM, Bart Van Assche wrote:
> On 4/15/21 5:22 PM, Pavel Begunkov wrote:
>> diff --git a/lib/percpu-refcount.c b/lib/percpu-refcount.c
>> index a1071cdefb5a..56286995e2b8 100644
>> --- a/lib/percpu-refcount.c
>> +++ b/lib/percpu-refcount.c
>> @@ -425,6 +425,32 @@ bool percpu_ref_is_zero(struct percpu_ref *ref)
>>  }
>>  EXPORT_SYMBOL_GPL(percpu_ref_is_zero);
>>  
>> +/**
>> + * percpu_ref_atomic_count - returns number of left references
>> + * @ref: percpu_ref to test
>> + *
>> + * This function is safe to call as long as @ref is switch into atomic mode,
>> + * and is between init and exit.
>> + */
> 
> How about using the name percpu_ref_read() instead of
> percpu_ref_atomic_count()?

Not sure we're going that route, but in any case, I think it's important
to have it visibly require the ref to be in atomic mode. Maybe
percpu_ref_read_atomic() would be better, but I do think 'atomic' has
to be in the name.

-- 
Jens Axboe

