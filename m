Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92AE840B04B
	for <lists+io-uring@lfdr.de>; Tue, 14 Sep 2021 16:11:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233481AbhINOMa (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Sep 2021 10:12:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233349AbhINOM3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 14 Sep 2021 10:12:29 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 713ABC061574
        for <io-uring@vger.kernel.org>; Tue, 14 Sep 2021 07:11:12 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id i21so29260118ejd.2
        for <io-uring@vger.kernel.org>; Tue, 14 Sep 2021 07:11:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:references:from:subject:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=mah8uLBtV9sGiwKoyMAPqvDxuaHBTO9oOc3LAYpUTi8=;
        b=Q8oURUz3VkH52o6vweLtOGcrVWdssxn8KctQjpsyGvcZzUXDAV43D10YZqHwnXL2VI
         jIzbzKUbxZ1dSW1wLL9TwfgNe4jAnZsoOC4sEyssocMnMbyWxPaOeLdPBe6Lx5GeOoCl
         T6Xkuu9d9KLPaiFb1pbjOWmZa84K8gfnyhHoq2ULYEkYUVMztWtl57FXItJecqzTz2qF
         1W5KpOsq5H6YVQxOhXWjJ8mCuPdTT0FNwQVdclyGy8f4cvvzIDR80HFUpMH//jWTwu/4
         fC4TrNmm3iGVoXB1FmwZTHX19eStEF2g0ilmBPJHgqacR7nuILsMD9MC8X0DCVheF9ez
         YyUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:to:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mah8uLBtV9sGiwKoyMAPqvDxuaHBTO9oOc3LAYpUTi8=;
        b=pQB2JiqTO05gHS/RBAjIj2NNVFNthoQ+JObN4FYkz7RjAI2Cet4E6p+JbvnX1WoMtZ
         QC4WZjF/Mqfxjr6drDBR3ZUwp+zauG8/+ShyBozZ87WPGZN6r+nNFBF8EXur5Hw8xYTQ
         zgvLt5SJSNG3rFcyuFkqwCVD+jefPw0elJQqjq/YZf4BQ02zHxnE7ykAN3PKbnzLatnG
         /IjcIMJtL496qwK+qC6ZCPBKVG9Yv7AB/xKnHUh2d2rwiBoB8rgJygj4aQWujXULS2y9
         lSfTK+oixEzWas/J/BJKkLIEHOwR+SwFmqoL3UofSVb1bmz9i/T6Svkm6mtFnyorMUF0
         VpKw==
X-Gm-Message-State: AOAM532UWkwZ+M8g2FuVvkhWG9Pol95AzlsIdl5gRE9rnAHvB4yHrqyh
        ztt2LR7UpXRm7nHg6bfb6ie5sunN/FA=
X-Google-Smtp-Source: ABdhPJzs3QuFm1lZSMuxyCagv2XeQWfg7J12eHLf6yAVuxDy8Y7gU93cmYkUgAsEf6Xg9aKhyn6rhg==
X-Received: by 2002:a17:906:9742:: with SMTP id o2mr19379465ejy.532.1631628670667;
        Tue, 14 Sep 2021 07:11:10 -0700 (PDT)
Received: from [192.168.8.197] ([85.255.232.220])
        by smtp.gmail.com with ESMTPSA id bs13sm4934891ejb.98.2021.09.14.07.11.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Sep 2021 07:11:10 -0700 (PDT)
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <0ef71a006879b9168f0d1bd6a5b5511ac87e7c40.1631626476.git.asml.silence@gmail.com>
 <27718f96-30af-2ebc-3a53-8fb6bb7155ec@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [PATCH 5.15] io_uring: auto-removal for direct open/accept
Message-ID: <450eb78a-a714-c6d1-c844-dbe8424a1c1c@gmail.com>
Date:   Tue, 14 Sep 2021 15:10:36 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <27718f96-30af-2ebc-3a53-8fb6bb7155ec@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/14/21 3:02 PM, Jens Axboe wrote:
> On 9/14/21 7:37 AM, Pavel Begunkov wrote:
>> It might be inconvenient that direct open/accept deviates from the
>> update semantics and fails if the slot is taken instead of removing a
>> file sitting there. Implement the auto-removal.
>>
>> Note that removal might need to allocate and so may fail. However, if an
>> empty slot is specified, it's guaraneed to not fail on the fd
>> installation side. It's needed for users that can't tolerate spuriously
>> closed files, e.g. accepts where the other end doesn't expect it.
> 
> I think this makes sense, just curious if this was driven by feedback
> from a user, or if it's something that came about thinking about the use
> cases? This is certainly more flexible and allows an application to open
> a new file in an existing slot, rather than needing to explicitly close
> it first.

Franz noticed that it would've been more convenient this way. Good idea
to add his suggested-by. I had been thinking to make it this way before
that, but without particular use cases, it just felt better.

-- 
Pavel Begunkov
