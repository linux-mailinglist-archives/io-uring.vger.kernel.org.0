Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC0D93B89A9
	for <lists+io-uring@lfdr.de>; Wed, 30 Jun 2021 22:22:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234982AbhF3UYd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 30 Jun 2021 16:24:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234888AbhF3UY1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 30 Jun 2021 16:24:27 -0400
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A003C061756
        for <io-uring@vger.kernel.org>; Wed, 30 Jun 2021 13:21:57 -0700 (PDT)
Received: by mail-io1-xd34.google.com with SMTP id g5so1134795iox.11
        for <io-uring@vger.kernel.org>; Wed, 30 Jun 2021 13:21:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=3Z4+OkN6FlBIjlpyyrT+0IF+5jz/Pi/fm32YjnWSb6g=;
        b=Ghf4etGAJtySqxh/3scoTY0v1aCMerzeRpn2JRJ9gRxGOPMZ1lvYditCh5vM+p8MAk
         TK57ynI6Lt4iwCGSUzysoCUw39HfPKicuTSwMkkExkntAOtSlzeeH7TvUSMbyHkUdDuO
         kiSgDOmcenXQ3YjK34O4kwZ9hg/dDq9bchR+BZKnemBP8rK7s/AtAfWc+soaoklMWQa3
         +WsoE3mru3ISUAGggQzbzPBx3NH+B8uROhaEDyJUIwn63n7TiiboI5vqnmLRHWYWCEaA
         C5SOxbkc0/67/wTfutGGOTldQQzCs4fS73B+qJYGT620utMGNirzDr70pH1K/jzXjYOe
         6wYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3Z4+OkN6FlBIjlpyyrT+0IF+5jz/Pi/fm32YjnWSb6g=;
        b=enRjArfglPHiwkOgZUH31lz2izf+b+NrtU4swzosxRQIOaouSXf5vLuGkfYRnWxcEw
         U2wm9ey0qRLATL2KqaRmouNIQQ2LOoVP6FJsE+/D04igr5M+CZtm7WNmOpjYUzChblzi
         KxaHQmHeuxWx0W+LADapI+Uafouc3fx9APYdJIQZhxNQo5LqFZVAA21dc53F4VwW1/sW
         PVVvvqSXRrl7hfXvhiJmuwlmPRAuXJcQD6BMCX2PmMbKCAbasu4+YmI2S0hmft0VIRNN
         WWVtnMfrsy9kwCEhJ211uOM8EHpRipKvcvpscNFz/amKNcohl7Ah0X0cip4YSFuF6A8S
         ft+g==
X-Gm-Message-State: AOAM532rfw8rg+5+0l+Zx+BQu/nWdXWwdkbUmj7+EH1kdwPyrbhPoRdx
        f6BEB8FdbNvMNN0qX0oM1DD/siadnreYqw==
X-Google-Smtp-Source: ABdhPJzpSLLAAE2CPOLgdVfI1n0qbbnd5v8VS4O8Ao+NZVEd6KulztPuHrxnxPspPAiuwY25+/Dnjw==
X-Received: by 2002:a05:6602:1243:: with SMTP id o3mr9224116iou.13.1625084516006;
        Wed, 30 Jun 2021 13:21:56 -0700 (PDT)
Received: from [192.168.1.134] ([198.8.77.61])
        by smtp.gmail.com with ESMTPSA id y3sm8672899ioy.46.2021.06.30.13.21.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Jun 2021 13:21:55 -0700 (PDT)
Subject: Re: [GIT PULL] io_uring updates for 5.14-rc1
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Al Viro <viro@zeniv.linux.org.uk>,
        Dmitry Kadashev <dkadashev@gmail.com>,
        io-uring <io-uring@vger.kernel.org>
References: <c9a79f27-02e9-b0d6-78ae-2e777eed8fe0@kernel.dk>
 <CAHk-=wgCac9hBsYzKMpHk0EbLgQaXR=OUAjHaBtaY+G8A9KhFg@mail.gmail.com>
 <00f21ea0-2f38-f554-63e9-ef07e806a0cd@kernel.dk>
 <CAHk-=wi9TATc=n-zrGfkEPcr7+wXx8PHe7z9-TeOmJPbisss+Q@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <ed4ab723-0c4d-2f44-7819-182527c98174@kernel.dk>
Date:   Wed, 30 Jun 2021 14:21:54 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAHk-=wi9TATc=n-zrGfkEPcr7+wXx8PHe7z9-TeOmJPbisss+Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/30/21 2:18 PM, Linus Torvalds wrote:
> On Wed, Jun 30, 2021 at 1:14 PM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> I think you're being very unfair here, last release was pretty
>> uneventful, and of course 5.12 was a bit too exciting with the
>> thread changes, but that was both expected and a necessary evil.
> 
> The last one may have been uneventful, but I really want to keep it
> that way.

We certainly share that goal.

> And the threading changes were an improvement overall, but they were
> by no means the first time io_uring was flaky and had issues. It has
> caused a _lot_ of churn over the years.

In some ways that was almost inevitable with treading new waters, but
I'm hopeful that we're way beyond the hump on that.

I totally agree that it should not be disruptive to core code, and
I'm definitely fine rejecting those bits to avoid having that be the
case. We'll get it sorted.

-- 
Jens Axboe

