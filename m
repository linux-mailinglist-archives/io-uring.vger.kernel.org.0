Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 930A831A5C8
	for <lists+io-uring@lfdr.de>; Fri, 12 Feb 2021 21:05:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229648AbhBLUEw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 12 Feb 2021 15:04:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbhBLUEt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 12 Feb 2021 15:04:49 -0500
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D72A3C061788
        for <io-uring@vger.kernel.org>; Fri, 12 Feb 2021 12:04:08 -0800 (PST)
Received: by mail-pf1-x432.google.com with SMTP id b145so192810pfb.4
        for <io-uring@vger.kernel.org>; Fri, 12 Feb 2021 12:04:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=xldzmoA9SJDOiaito4OEwPMO1Y/8mUNqoMJ3iTqrBKg=;
        b=BRZocUsGA1K/PBQNUc+sR1EQP3/+jE+1+wAyvRkfb94iJAqNmHFzVVd4X9nJkX4Auc
         2CVvFSs/cv9WR6buCSAhDD/4JgeYrC0ndgjfFbtzeJsCbrvp9GvX2Hz1u8vooq5TUMm/
         RpS7LJM3JdHFVjqbhZbjVS+eCp7bbnaqT8u3Zv42Jgb32paFqFNBz17hGxda98+ivkTY
         s1I9CsMCncewjUiHaMnj49ApO7ujPAUPW3sPmX7liFq748GVBlJe5WDAgacvy1g+yTHP
         ugZXCV5lzX+IO3eq44jhPio4jFRwHBBta1tAGu8Kdhz3xo3f6aNuugJVwOC3HV11XmO8
         /wEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xldzmoA9SJDOiaito4OEwPMO1Y/8mUNqoMJ3iTqrBKg=;
        b=OfWUcQ7YInn6xTj8ZLkTOfI/KPCfbzNTlwuJml8LBwK70omIA5o4OmtclpEeAE5hVN
         GjzRB3i7v/b81OGtT60FbhoBgpLEBqzVM8kozZhqlEFn7F7Xxpp3sHx0psuxDfNZgO04
         uZvTyIj5/X+rA/md6GrvtcPOSzrQ2S4G77g5ULp1DXpacMWrhzAXOgiVi2px1XF2PEcj
         bwFzLWXYzev9+UlU/yTFFdwvCnOTfQIzEM2vwpCvQhPc6H7DV65oZn2q1/0pzXBL1Syk
         pwidi5IJed6uYUlaQVDuTjX4STqpyJjfrtaWOfdwYuzgsdtpP+s3jfFyln/EPnp4PzrU
         JRtw==
X-Gm-Message-State: AOAM5314SlwYJWSzwUFZBbBHXSNwSqWD+aa+doj59J/qwKwdTzwYzLvR
        dXw93jtzjtN+uT2k7QQWeHs7xGB2T5ZaSQ==
X-Google-Smtp-Source: ABdhPJwsV6LxlnDH4FXAV3SjUUmawMX7kL+sKa67G1mZtKSp8VXn5JsXmbawYqBUgqf7/0mq0lsgAg==
X-Received: by 2002:a65:68ca:: with SMTP id k10mr4834906pgt.398.1613160247995;
        Fri, 12 Feb 2021 12:04:07 -0800 (PST)
Received: from ?IPv6:2620:10d:c085:21e8::16bf? ([2620:10d:c090:400::5:2056])
        by smtp.gmail.com with ESMTPSA id u19sm8941371pjy.20.2021.02.12.12.04.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Feb 2021 12:04:07 -0800 (PST)
Subject: Re: [GIT PULL] io_uring fix for 5.11 final
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>
References: <a1f5c4b9-5c5d-a184-7ede-78739e1c01c6@kernel.dk>
 <CAHk-=wicH60LB9sENxT95mE_LY-EPruphMc-wRRXc97KVER2vQ@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <1b7b68bd-80d4-8be8-cf6d-26df28e334ce@kernel.dk>
Date:   Fri, 12 Feb 2021 13:04:06 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAHk-=wicH60LB9sENxT95mE_LY-EPruphMc-wRRXc97KVER2vQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/12/21 12:51 PM, Linus Torvalds wrote:
> On Fri, Feb 12, 2021 at 6:08 AM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> Revert of a patch from this release that caused a regression.
> 
> I really wish that revert had more of an explanation of _why_ it
> needed to retain the ->fs pointer.
> 
> I can guess at it, but considering that we got it wrong once, it might
> be better to not have to guess, and have it documented.

We end up doing path resolution for certain cases, so having the
right fs_struct ends up being paramount. Do you want me to update the
commit with a fuller description?

-- 
Jens Axboe

