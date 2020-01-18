Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D45A914151C
	for <lists+io-uring@lfdr.de>; Sat, 18 Jan 2020 01:17:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730393AbgARARA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 17 Jan 2020 19:17:00 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:39120 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730232AbgARAQ7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 17 Jan 2020 19:16:59 -0500
Received: by mail-pg1-f193.google.com with SMTP id b137so12422337pga.6
        for <io-uring@vger.kernel.org>; Fri, 17 Jan 2020 16:16:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=Y6hFtlGWNj2335ptBmTRWPobE2rmTBdw86gaZCZvr98=;
        b=piNWalyrCazeaNdOIEIExKlexZTPIGOgNqDRrIJZk+6RywU5zIJ4q2GRfg7Y6teOQy
         uwZfYEHYU5cpPTAaQIV9LDwHWphc7CB3f3Yb7ai8TvKyN5WRnoTsv3uXBPmYDHZKpTdU
         2B+slw2na/O0P2Px0ooBbVj75eH3Yw6VPZqBxZsIWRs1uhtFArdeBxnuUc0GOlUVIVtl
         CQLsS0rwfaIjcA025vDbKYVrkkKckA06w4uad7Kotj9QSVEzFZcf8cyF9lryN+IOl73j
         ZSbTUyadOq4ClJBO0/gw4dbjk2DdPf2gWX/6DuQIMAHvvcHsfquav4FpPjBNBShRaI8g
         5gkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Y6hFtlGWNj2335ptBmTRWPobE2rmTBdw86gaZCZvr98=;
        b=B1NI7FeTlDoagzGB2bUoQKjwy67mvAHBBlPvJIN22euUu1mQE68EjzZWjFudCdv2Ne
         jsOUOdTNNZhDyL/5TzJs+7wdXTT0gCvmSctij39JI540aqqLjk3zQwyuMwdQyGSxXBkZ
         Fh8BF5qGWjxOvU6dsIEarPboQT027IeqVNpzEv8du43PJIOuS1qZSIziesEY1dEAEpJz
         Hxy67u5gIk/vG5Gk+D0aFXNnV4IZDCFibnMFiVEnCckxXY9+knZqQmGBft59D1x4fHUs
         JleF8RhfiHkEhb5BfWMg0uNCOas3itpKoty3NX22e1ad1A9sujoG5uhttmS8EusJ4yHS
         aUaw==
X-Gm-Message-State: APjAAAV1Efk843HFVP65M7yMjYp2If1IBSkEyxFguluDw1MHTNHZXxY5
        eQqUJtGkrJCdeOLJFWUo0u0SfA==
X-Google-Smtp-Source: APXvYqwnnCKaqiVUSOFPsMT/FPdjbdkheYjE0PvYbNDZcoQqGmEcUuiWNJKlENaWcds9yIQqVrHV+A==
X-Received: by 2002:a65:4381:: with SMTP id m1mr49118391pgp.68.1579306619174;
        Fri, 17 Jan 2020 16:16:59 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id n26sm31102181pgd.46.2020.01.17.16.16.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Jan 2020 16:16:58 -0800 (PST)
Subject: Re: [PATCH 0/2] optimise sqe-to-req flags
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <37a04c11e980f49cb17a4fd071d2d71a291a8fd5.1579299684.git.asml.silence@gmail.com>
 <cover.1579300317.git.asml.silence@gmail.com>
 <cf0b8769-0365-2fd1-c87e-fe2e44052b51@kernel.dk>
 <fa7b4b9a-b0a4-7c1f-d3e9-c5bfa8fff74b@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <b507d39e-ec2b-5c9f-0fd0-6ab1b0491cad@kernel.dk>
Date:   Fri, 17 Jan 2020 17:16:57 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <fa7b4b9a-b0a4-7c1f-d3e9-c5bfa8fff74b@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/17/20 4:14 PM, Pavel Begunkov wrote:
> On 18/01/2020 01:49, Jens Axboe wrote:
>> On 1/17/20 3:41 PM, Pavel Begunkov wrote:
>>> *lost the cover-letter, but here we go*
>>>
>>> The main idea is to optimise code like the following by directly
>>> copying sqe flags:
>>>
>>> if (sqe_flags & IOSQE_IO_HARDLINK)
>>> 	req->flags |= REQ_F_HARDLINK;
>>>
>>> The first patch is a minor cleanup, and the second one do the
>>> trick. No functional changes.
>>>
>>> The other thing to consider is whether to use such flags as 
>>> REQ_F_LINK = IOSQE_IO_LINK, or directly use IOSQE_IO_LINK instead.
>>
>> I think we should keep the names separate. I think it looks fine, though
>> I do wish that we could just have both in an enum and not have to do
>> weird naming. We sometimes do:
>>
>> enum {
>> 	__REQ_F_FOO
>> };
>>
>> #define REQ_F_FOO	(1U << __REQ_F_FOO)
>>
> 
> I thought it will be too bulky as it needs retyping the same name many
> times.  Though, it solves numbering problem and is less error-prone
> indeed. Let me to play with it a bit.

It's less error prone once the change is done, though the change will be
bigger. I think that's the right tradeoff.

> BTW, there is another issue from development perspective -- it's
> harder to find from where a flag is came. E.g. search for REQ_F_FOO
> won't give you a place, where it was set. SQE_INHERITED_FLAGS is close
> in the code to its usage exactly
> for this reason.

Since it's just that one spot, add a comment with the flag names or get
rid of the SQE_INHERITED_FLAGS define. That'll make it easy to find.

>> and with that we could have things Just Work in terms of numbering, if
>> we keep the overlapped values at the start. Would need IOSQE_* to also
>> use an enum, ala:
>>
>> enum {
>> 	__IOSQE_FIXED_FILE,
>> 	__IOSQE_IO_DRAIN,
>> 	...
>> };
>>
> 
> I tried to not modify the userspace header. Wouldn't it be better to
> add _BIT postfix instead of the underscores?

No strong preference, I usually do the underscores, but not a big deal
to me. There's also BIT_* helpers to make the masks, we should use
those.

-- 
Jens Axboe

