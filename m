Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0FFD01303C9
	for <lists+io-uring@lfdr.de>; Sat,  4 Jan 2020 18:41:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726101AbgADRlX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 4 Jan 2020 12:41:23 -0500
Received: from mail-pj1-f52.google.com ([209.85.216.52]:35281 "EHLO
        mail-pj1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726099AbgADRlX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 4 Jan 2020 12:41:23 -0500
Received: by mail-pj1-f52.google.com with SMTP id s7so6003299pjc.0
        for <io-uring@vger.kernel.org>; Sat, 04 Jan 2020 09:41:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=xUK668tkpk/kcB9h3Av/zeNHCOyLiiQQcvmr53DDBqw=;
        b=T4DFtMQlQWmBeNvxnUL9IyV2qUlFcq60Qj/UI6xatzvqee0XVoDaq1agG+oWMVnFBm
         2IIXzPeePJvG0/peyn/sCQntye+vyV22rUDz/DQcuR1aRWVAo7tEMqZQuyWOdkcoRutw
         6j+wwoSodTO4WNz8slIgjy6MHKuw0rk2+rEgiVBVct6gImHyPJBCgt7E928URHMm/A2Y
         9+wOrDAtbrgfRbN7ZCJueMf55tTGG2cWMdapJW5SFeCXsI/FreopHG0UyIdKmBgry3hT
         s3Aq1kaLLzJ+/reTJPPKsJI4e9YCamHcxt42PlrJ+pvHhA5pT4RIEeKy6hD8NfRoAYLG
         rnvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xUK668tkpk/kcB9h3Av/zeNHCOyLiiQQcvmr53DDBqw=;
        b=jdR25nQVhMpiGP0ajhTggv2aA5+UIqPf63EpHxk9KIxy7Wk6j6lNi71VzWMsOwiDv6
         Snd7EZe3dN4XJK8fKHfkcLIBPS5MIK2/KExyk4fB6Z40hRSOHyxAOUP7Tb0dngXLsCqN
         NGkBKpqqmkYMr2/iWXsCLyea8dUD8E5yfUSevQOpl4kD4Bbb5p8U4pskS2Lw443X4Xng
         9V5TeiISPe4pMlBSit1QtNSgeChtNiOUR5gksVdTa3RnvVWZ73B6iWFgpxgPTdvMC9vs
         VGAa4RZcCLFxR448McAeqprOsIAk8wPRpe9iG1nAVBKqp2LHaJ3wEPcR6+qBRyeCVlkB
         sPAA==
X-Gm-Message-State: APjAAAXltqJQIyR66jSZAqmIw9h5D338alDc6de0euIvV+jIKmuiB4uU
        IgFMYtN2g3KdTuOwP6tLuWsMIXkd/HC41Q==
X-Google-Smtp-Source: APXvYqxyH+sWBnv0yaz1JIc8ehbb3QOHqIdCe5D9Fo/F9id7MnYIbOUylmmW4R2gpjwfVSeoHRHIig==
X-Received: by 2002:a17:90b:3cc:: with SMTP id go12mr33567861pjb.89.1578159682090;
        Sat, 04 Jan 2020 09:41:22 -0800 (PST)
Received: from ?IPv6:2605:e000:100e:8c61:c432:634e:2cbb:b7c? ([2605:e000:100e:8c61:c432:634e:2cbb:b7c])
        by smtp.gmail.com with ESMTPSA id j5sm56401642pfn.180.2020.01.04.09.41.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 04 Jan 2020 09:41:21 -0800 (PST)
Subject: Re: SQPOLL behaviour with openat
To:     William Dauchy <wdauchy@gmail.com>
Cc:     io-uring@vger.kernel.org
References: <20200104162211.9008-1-wdauchy@gmail.com>
 <fad9c723-88ed-355f-6938-71db6db948b4@kernel.dk>
 <CAJ75kXZdwF4x0Od9BE5OD0vxbkuKR2UDHSfjaQ-yhjUkpx=r2A@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <587a53c3-5a7e-e8fa-d7d4-9bc33e0ec8ce@kernel.dk>
Date:   Sat, 4 Jan 2020 10:41:20 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <CAJ75kXZdwF4x0Od9BE5OD0vxbkuKR2UDHSfjaQ-yhjUkpx=r2A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/4/20 9:41 AM, William Dauchy wrote:
> Hello Jens,
> 
> Thank you for the quick answer.
> 
> On Sat, Jan 4, 2020 at 5:28 PM Jens Axboe <axboe@kernel.dk> wrote:
>> sqpoll requires the use of fixed files for any sqe, at least for now.
>> That's why it returns -EBADF if the request doesn't have fixed files
>> specified.
> 
>  I indeed forgot sqe->flags |= IOSQE_FIXED_FILE; in my modified test.
> 
>> So it cannot be used with opcodes that create (or close) file
>> descriptors either.
> 
> ok, I thought `dirfd` could have been the index of my registered fd
> for `openat` call. It was not very clear to me this was not possible
> to use fixed files for those opcodes.

I should probably clarify that in the man pages! I'll get that done.
But yes, that it is how it _should_ work for registered files. I haven't
spent too much time on sqpoll lately, but there's really no reason why
it cannot do everything that the regular path can. Just need to ensure
the proper inheritance is done, it's a kernel thread just like the async
workers.

-- 
Jens Axboe

