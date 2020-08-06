Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6861323DD2E
	for <lists+io-uring@lfdr.de>; Thu,  6 Aug 2020 19:05:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729386AbgHFRFF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 6 Aug 2020 13:05:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729477AbgHFREh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 6 Aug 2020 13:04:37 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A1C6C034619
        for <io-uring@vger.kernel.org>; Thu,  6 Aug 2020 06:21:33 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id i92so4726451pje.0
        for <io-uring@vger.kernel.org>; Thu, 06 Aug 2020 06:21:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ZfjBCNF/3EZaWIAWdRT0NxoaXvvRxREl4/qQ5B67eIc=;
        b=hnXtAjeElJ86R065wAUVzHlNdRMWe271q3vRtlCeCiyTPdPV6G909Q9v9eEyFyQl8f
         EUvbegeNVRh2Nuf+x5WX26e8l4EbI+/VY8qZdO80XLXg0/KnhF9Xz/V033C/9GGJLjBw
         jlsIedEyTOJ0kvYMxdP+BY+lwYpmoO0+YdZ3axnZAfz6w2IPq8EViWbp7tnbcp3bkk5H
         QhRzzlmeSwKAszhXRETXXW3WVWryJrwvu//ivcYLVf2ypmU9hNUxZILdYXC28EsnO2Kx
         APjpUzvoz69g++jkLIifvE3Cm+ZUv1Ei6IKRy1DqHFKAzHmQ/Kyq9Sh7h9XPuPav+ZbI
         aqXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZfjBCNF/3EZaWIAWdRT0NxoaXvvRxREl4/qQ5B67eIc=;
        b=SMTdxQGCKf4hTJno9kRTebgmdjcLDVB6WgDLaIwrL5npgrqufktDPknaEhSOAdM5Cd
         DdqAMkcV5EP1O3xHge5ITMVRXQycEBy9Ujcge31sguOhlFqcJAoNGf1Bo38Hn5ckz8px
         tLF8K3jNOpc0RIFwan7EQ1PwxdSqo5eb5PwoqV74fD1SBfSAnhOevwU2pW52Ti26NLpf
         vLV1+x4KRoJlVjbBk58cGIUrr7LKLPJUj6ziVgnuL2VfLkcq4WQY6wP3byNpJTnYFz+d
         QlFlHW1irhArEcnKYt/oxRUjgcQCHxU5Yrie3ihw9ja+g+asYvRVCJfEMxnomuNAkaML
         L6Fw==
X-Gm-Message-State: AOAM530clX8t6/PpVW0z8w89K+t6J+9WE6SRyjGxvMGk+sOvXGxxGWUG
        fguXfXbWv548IOODQ330WzWTCUbFL+s=
X-Google-Smtp-Source: ABdhPJwmZLBAW/ghSD561eyYMrodGO5cV/WhqH9jT1U2XrTh8zIjS/iS9ZFM6hE/xDRQDtzkqVsBYA==
X-Received: by 2002:a17:90a:7c04:: with SMTP id v4mr8917101pjf.191.1596720092373;
        Thu, 06 Aug 2020 06:21:32 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id u66sm8608840pfb.191.2020.08.06.06.21.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Aug 2020 06:21:31 -0700 (PDT)
Subject: Re: [PATCH 2/2] io_uring: account locked memory before potential
 error case
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     io-uring@vger.kernel.org
References: <20200805190224.401962-1-axboe@kernel.dk>
 <20200805190224.401962-3-axboe@kernel.dk>
 <20200806074231.mlmfbsl4shvvzodm@steredhat>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <e7d046e3-8202-4c70-c6fb-760e3da63f24@kernel.dk>
Date:   Thu, 6 Aug 2020 07:21:30 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200806074231.mlmfbsl4shvvzodm@steredhat>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/6/20 1:42 AM, Stefano Garzarella wrote:
> On Wed, Aug 05, 2020 at 01:02:24PM -0600, Jens Axboe wrote:
>> The tear down path will always unaccount the memory, so ensure that we
>> have accounted it before hitting any of them.
>>
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>> ---
>>  fs/io_uring.c | 16 ++++++++--------
>>  1 file changed, 8 insertions(+), 8 deletions(-)
>>
>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>> index 0d857f7ca507..7c42f63fbb0a 100644
>> --- a/fs/io_uring.c
>> +++ b/fs/io_uring.c
>> @@ -8341,6 +8341,14 @@ static int io_uring_create(unsigned entries, struct io_uring_params *p,
>>  	ctx->user = user;
>>  	ctx->creds = get_current_cred();
>>  
>> +	/*
>> +	 * Account memory _before_ installing the file descriptor. Once
>> +	 * the descriptor is installed, it can get closed at any time.
>> +	 */
> 
> What about update a bit the comment?
> Maybe adding the commit description in this comment.

I updated the comment:

/*
 * Account memory _before_ installing the file descriptor. Once
 * the descriptor is installed, it can get closed at any time. Also
 * do this before hitting the general error path, as ring freeing
 * will un-account as well.
*/

-- 
Jens Axboe

