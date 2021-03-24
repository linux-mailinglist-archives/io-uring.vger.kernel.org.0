Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CE38347B38
	for <lists+io-uring@lfdr.de>; Wed, 24 Mar 2021 15:56:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236376AbhCXOz7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 24 Mar 2021 10:55:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236410AbhCXOzq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 24 Mar 2021 10:55:46 -0400
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EEF2C061763
        for <io-uring@vger.kernel.org>; Wed, 24 Mar 2021 07:55:45 -0700 (PDT)
Received: by mail-io1-xd2b.google.com with SMTP id x17so10512629iog.2
        for <io-uring@vger.kernel.org>; Wed, 24 Mar 2021 07:55:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=/uD0nuq+cvGVh7+29Dol4ldLu5eZndNQPAsET2rYGpI=;
        b=ELn8c68yEbcDlfhXx6CCdJxslOwsBukAwdIxS6NGAmHdEsYhlKeoKJBUEHex6UPikE
         +yVarVSKeQjcJ4p8Ae9Iahu/rYxpDGoWpZg0DwMeS2bl1eoffcW7EhAagyhIEoApHVXA
         +7fVjstOt/O+bYziqLy16sfvinr5KTUZ6OIUnoYBDjQQXwIzPar9NuQ2N2P+3em6i7KQ
         z2Cetg/nRccbBBjBrx7ywLN/eDPcFXPmhNoDmaqSlX8i6R6VRmpZMoo8xD6zg3asBjya
         JQABcGEa4r2AWLJNtv8MBa8AUSTHF8r/8kB764rlRjZM2UO+QENNXvY7uNwx6V/EqoMJ
         VKRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/uD0nuq+cvGVh7+29Dol4ldLu5eZndNQPAsET2rYGpI=;
        b=LMBBKMTZV4o/wjLzZTctxhrxygWMG3YXDAVkUbJHnWpJPiFNmKSgs5QiNdjBxrBZ98
         hxXn2kg/s5y/8dFffM/9mhIkAo7R/MI8oA//5CmrgQLd6dSk2GhYK8yV3QQ3jUX882tA
         LQJO8nKifHK22R4MkG35xeQA2ZbQg9KdZoHoc4tLZnumr+6PG9M5iqXO/LZ7oKegxt0K
         sDjWv1plliWCfvvGduIIpzYQGfGIbvwgBswJwMH8WE82KGSIVIzIScgwiAYoA0rQpDKi
         i9P3fGZRqtSRJHgTxhrUDwdWK47xjQDTELcRBLJIJOxY79xFmhIwaoxy9EicbyJSMAUy
         duxg==
X-Gm-Message-State: AOAM533kabxU7U6vbJfwsjvwFqlwIJs0i+4nJp73NGLhAbDmNQulW0U8
        x/7dLb39vXS+gQ5kJYW2eGFY9hCkO2KJpA==
X-Google-Smtp-Source: ABdhPJyDKbqTe00mS744WRSH8ClQtfmjeszGlyaocf6X9QQzcZqL/PQvLILGf3aKFiCUetKJIa5YDQ==
X-Received: by 2002:a6b:4411:: with SMTP id r17mr2693692ioa.64.1616597744851;
        Wed, 24 Mar 2021 07:55:44 -0700 (PDT)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id b5sm1210259ioq.7.2021.03.24.07.55.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Mar 2021 07:55:44 -0700 (PDT)
Subject: Re: [PATCH 5.12] io_uring: reg buffer overflow checks hardening
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <41c8fce27c696171e845a6304f87ec06d853c5a6.1616596655.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <da6587a4-9c40-cb62-b545-ef96556638be@kernel.dk>
Date:   Wed, 24 Mar 2021 08:55:43 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <41c8fce27c696171e845a6304f87ec06d853c5a6.1616596655.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/24/21 8:40 AM, Pavel Begunkov wrote:
> We are safe with overflows in io_sqe_buffer_register() because it will
> only yield allocation failure, but it's nicer to check explicitly.

Right, either that or fault when mapping. So nothing serious here, but
would be nice to clean up though and just explicitly make it return
-EOVERFLOW when that is the case.

> @@ -8306,6 +8306,8 @@ static int io_buffers_map_alloc(struct io_ring_ctx *ctx, unsigned int nr_args)
>  
>  static int io_buffer_validate(struct iovec *iov)
>  {
> +	u64 tmp, acct_len = iov->iov_len + (PAGE_SIZE - 1);
> +

No need for those parens.

>  	/*
>  	 * Don't impose further limits on the size and buffer
>  	 * constraints here, we'll -EINVAL later when IO is
> @@ -8318,6 +8320,9 @@ static int io_buffer_validate(struct iovec *iov)
>  	if (iov->iov_len > SZ_1G)
>  		return -EFAULT;
>  
> +	if (check_add_overflow((u64)iov->iov_base, acct_len, &tmp))
> +		return -EOVERFLOW;
> +

Is this right for 32-bit?

-- 
Jens Axboe

