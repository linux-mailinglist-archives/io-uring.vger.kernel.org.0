Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE44B23DE6C
	for <lists+io-uring@lfdr.de>; Thu,  6 Aug 2020 19:25:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729854AbgHFRZF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 6 Aug 2020 13:25:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729783AbgHFRDF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 6 Aug 2020 13:03:05 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4AB5C08E8BB
        for <io-uring@vger.kernel.org>; Thu,  6 Aug 2020 06:47:04 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id d22so6650241pfn.5
        for <io-uring@vger.kernel.org>; Thu, 06 Aug 2020 06:47:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=sRlaU+fjgD3nsBQRldYy12BoTnkaiLHOOWLmhuZ7Hns=;
        b=b1/e36uVY4XnX33kjlwggXJIqASCkfTNQt+Qas+MAU1WTRVakK7otwxuP3e36KI7tB
         ycuicjH7/qnpr4/MIB2zVlvuUnP1uLJjSEYO53vtjSOw/zafcA3Az7gTgjeH4axvjaCS
         VnQrnzKbhWLn6wo64RqHhrJnEuINmdNG1kGKSoRwNHBN/pfQIsq8EloQI47x3CTmhueO
         veO4xEkoi6rMg/qGXQ3n4wl4KE6dUSoNuLxyP/1pKbdG9tl2sS08A8CN+WRQ+Etwtip9
         /SVcE5sq3J0YFa4OniwutZ0mOdjsuRX6v7AlLBorV23FdhBrAQkMfJiHXvMmq5FST60r
         OKCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=sRlaU+fjgD3nsBQRldYy12BoTnkaiLHOOWLmhuZ7Hns=;
        b=l0IMnZ3rL4ujDDXEPsNki/HqE6Vz2JapV0rDWoikN4MfQ/RpEp2GrYzlLTRcaULPs1
         B8bGp2ZjC1UsyXNRLhP/s90urAy4ju06fPl2VwECZ6fFnUiRRB9XLUuSTvYdP2nQFb4t
         HX1VCgqklQ/hMn4FT41jxeX5CywehmeFrLCa+o7KGbzj2UX0PS58JTHGm8QRX24iybsf
         flh5OUCRlbQZSqfaLBXKLyxSUZ/q+X0ayQ4DORtcy1nRqgSidhqmDo+Qg+5W1tOwGH91
         ZR5BrL7Suq6Z9ReuhkaLEOwYbp8X/ETo21i4qgDtOxHxOjxtGcYQaYZ4vc4hyC2irkx5
         M/ng==
X-Gm-Message-State: AOAM533g/z7DOo9wYAcQ4tJosjL1qW/cmz1Mq5gpBrls1KZBj7afHUoR
        JvQzp4CE3sGWtZe4HPwNoKfNKHEF+0g=
X-Google-Smtp-Source: ABdhPJxXLaQE4l7K2P3Y2xyJrOASNDNIfXivlF/ibMZJP8ztk+DzIg9ETcpqfHyYEycoXu5tayIxDg==
X-Received: by 2002:a05:6a00:2b7:: with SMTP id q23mr8525607pfs.101.1596721611966;
        Thu, 06 Aug 2020 06:46:51 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id e3sm7316946pgu.40.2020.08.06.06.46.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Aug 2020 06:46:51 -0700 (PDT)
Subject: Re: [PATCH 2/2] io_uring: account locked memory before potential
 error case
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     io-uring@vger.kernel.org
References: <20200805190224.401962-1-axboe@kernel.dk>
 <20200805190224.401962-3-axboe@kernel.dk>
 <20200806074231.mlmfbsl4shvvzodm@steredhat>
 <e7d046e3-8202-4c70-c6fb-760e3da63f24@kernel.dk>
 <20200806133848.xbpueoydtemjgofy@steredhat>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <761a5a67-b96e-e27c-3dee-03bd4886378d@kernel.dk>
Date:   Thu, 6 Aug 2020 07:46:49 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200806133848.xbpueoydtemjgofy@steredhat>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/6/20 7:38 AM, Stefano Garzarella wrote:
> On Thu, Aug 06, 2020 at 07:21:30AM -0600, Jens Axboe wrote:
>> On 8/6/20 1:42 AM, Stefano Garzarella wrote:
>>> On Wed, Aug 05, 2020 at 01:02:24PM -0600, Jens Axboe wrote:
>>>> The tear down path will always unaccount the memory, so ensure that we
>>>> have accounted it before hitting any of them.
>>>>
>>>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>>> ---
>>>>  fs/io_uring.c | 16 ++++++++--------
>>>>  1 file changed, 8 insertions(+), 8 deletions(-)
>>>>
>>>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>>>> index 0d857f7ca507..7c42f63fbb0a 100644
>>>> --- a/fs/io_uring.c
>>>> +++ b/fs/io_uring.c
>>>> @@ -8341,6 +8341,14 @@ static int io_uring_create(unsigned entries, struct io_uring_params *p,
>>>>  	ctx->user = user;
>>>>  	ctx->creds = get_current_cred();
>>>>  
>>>> +	/*
>>>> +	 * Account memory _before_ installing the file descriptor. Once
>>>> +	 * the descriptor is installed, it can get closed at any time.
>>>> +	 */
>>>
>>> What about update a bit the comment?
>>> Maybe adding the commit description in this comment.
>>
>> I updated the comment:
>>
>> /*
>>  * Account memory _before_ installing the file descriptor. Once
>>  * the descriptor is installed, it can get closed at any time. Also
>>  * do this before hitting the general error path, as ring freeing
>>  * will un-account as well.
>> */
> 
> Now it looks better!
> 
> Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

Thanks, added.

-- 
Jens Axboe

