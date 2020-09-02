Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 667C725AE7E
	for <lists+io-uring@lfdr.de>; Wed,  2 Sep 2020 17:13:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726397AbgIBPMK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 2 Sep 2020 11:12:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728047AbgIBPLt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 2 Sep 2020 11:11:49 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E25AAC061244
        for <io-uring@vger.kernel.org>; Wed,  2 Sep 2020 08:11:48 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id d18so6110239iop.13
        for <io-uring@vger.kernel.org>; Wed, 02 Sep 2020 08:11:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=tccld8pu/vEeZLLEWOkGb3/sHgIFzGzccr/6cDpn/3A=;
        b=lWOqeuHWb77h2WHZn0TNujlRTzxPNZnXDvUd5IeeJEl2IBu7CCBmaw5IP4ouZ1KzBg
         1xGzH8NsntPF5nI+pEfSvJbfHhyt45MgcgDw7B2GE9z/E8RPpbyPoz/fpqIbJDT9IOAu
         ko4tdtufl8fplgAaoi2mX2zPxpE/7I/W47rhgVpWWBGejdSZjtyb5xBoPk1cECSYCFqE
         4NDjWCX/DuszyLTIayqfDZZ9irDKkwgRVj28tRB6qcy5Wmbzw6WlM9rIGRXze5WpW2z2
         k9rzK9lFB4kddpYpnBd7v1R674eEO2Dgb9G4TG7NgbL9J7r/6zFxVD6v73rfoea4jIXg
         Trtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tccld8pu/vEeZLLEWOkGb3/sHgIFzGzccr/6cDpn/3A=;
        b=aGLtj0NV+3prqceo6WMnc8qIBeexYpi4r8x6CU4LpElDC6uXI/lkGENW7NSdd3fMIa
         UzcYGu0dm1u+3uv+hYSMh7u7u9UvXR/ZpkPiV1G13FLbPP2LB5OzxulI2p2rKgJRK/oE
         7Fk1YO1eWVhNcaUk3LJ/wQw8kPo4xQIgM/Z2+Ox5AsBI6IQKoFt/iDozLVPz33Ho1U73
         cSqAUBONH5wL26SqNqaLqpx+VCdq1gQyeO0dLGXh1SqANwf7/ZfkGszQUHZ0oPmpn4P8
         fUXgsa/pxWdIT1dd7Ij2HEzHBzWgVjXAZdGq+8wLbP3punQGtmXN2EAPPuoYpdidMgLG
         QoSg==
X-Gm-Message-State: AOAM533vMzJJ32yRVJeKmZRs7xvJfU9OR7eEZGf1jjedvI71lN+vxoks
        pWoiEXE0f8J+DC17+Xo+bfK8OClrAK54L1Fq
X-Google-Smtp-Source: ABdhPJwrX7GVty5AE9tUrROvoRhZ9AV5BRdBRXOc/qjXzPgeBoViP3Ks3Ph1GRvx7naE45qEjU6Lzg==
X-Received: by 2002:a05:6638:967:: with SMTP id o7mr3773414jaj.27.1599059507934;
        Wed, 02 Sep 2020 08:11:47 -0700 (PDT)
Received: from [192.168.1.57] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id o6sm2326563ilq.54.2020.09.02.08.11.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Sep 2020 08:11:46 -0700 (PDT)
Subject: Re: missing backport markings on security fix [was: [PATCH] io_uring:
 set table->files[i] to NULL when io_sqe_file_register failed]
To:     Jann Horn <jannh@google.com>
Cc:     Jiufei Xue <jiufei.xue@linux.alibaba.com>,
        io-uring <io-uring@vger.kernel.org>,
        stable <stable@vger.kernel.org>
References: <1599040779-41219-1-git-send-email-jiufei.xue@linux.alibaba.com>
 <c278224e-314d-e810-67f3-f5353daf9045@kernel.dk>
 <CAG48ez1MLMDPLA28HhRLcp+skk8KBawMq7qLv91kNY_prkZ4uw@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <6ab2ce3c-36b5-fcab-02b1-320401b97f8c@kernel.dk>
Date:   Wed, 2 Sep 2020 09:11:46 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAG48ez1MLMDPLA28HhRLcp+skk8KBawMq7qLv91kNY_prkZ4uw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/2/20 9:07 AM, Jann Horn wrote:
> On Wed, Sep 2, 2020 at 4:49 PM Jens Axboe <axboe@kernel.dk> wrote:
>> On 9/2/20 3:59 AM, Jiufei Xue wrote:
>>> While io_sqe_file_register() failed in __io_sqe_files_update(),
>>> table->files[i] still point to the original file which may freed
>>> soon, and that will trigger use-after-free problems.
>>
>> Applied, thanks.
> 
> Shouldn't this have a CC stable tag and a fixes tag on it? AFAICS this
> is a fix for a UAF that exists since
> f3bd9dae3708a0ff6b067e766073ffeb853301f9 ("io_uring: fix memleak in
> __io_sqe_files_update()"), and that commit was marked for stable
> backporting back to when c3a31e605620 landed, and that commit was
> introduced in Linux 5.5.
> 
> You can see at <https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/tree/fs/io_uring.c?h=linux-5.8.y#n6933>
> that this security vulnerability currently exists in the stable 5.8
> branch.

I'll mark it for stable, it should have been just like the previous one
is.

-- 
Jens Axboe

