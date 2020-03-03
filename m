Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C899C1782A9
	for <lists+io-uring@lfdr.de>; Tue,  3 Mar 2020 20:03:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730541AbgCCS5y (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 3 Mar 2020 13:57:54 -0500
Received: from mail-il1-f195.google.com ([209.85.166.195]:44027 "EHLO
        mail-il1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726766AbgCCS5y (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 3 Mar 2020 13:57:54 -0500
Received: by mail-il1-f195.google.com with SMTP id o18so3716288ilg.10
        for <io-uring@vger.kernel.org>; Tue, 03 Mar 2020 10:57:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=oJxS1+Wv0mozz3TAhS0BOcOmGdtUSP5H9bxTQD7t2Io=;
        b=hxkAK9VyWYhaL2DkQ2C5a1dCmCx6H1i7BB4GBV9jr6HoJziB17Zo3otPt1eotw2crc
         zDNBn/FgFl2dtoeoM9UYaMk5FVL2CNWc0zXaGcIGGRBU6lwx9pHQpERw5U2scxAgo5yS
         E7SNvR3gACLp8IBufyg45tz19T7P4V/o9NBH0aGOnmIg1mpvvLbDfICSp4EAEkkis/Bw
         sMtl+9vKBltlI+pnYcCdtjYbmLIZ0Ugf+eokxrpeTsOafPnLcU/hs67iCc11AUNNH1ak
         l8Cr8VqQSbOVp+u5AYSAMhq2zVQwJNioPQzeuK1YzCwWuxKexAAxDnLieZI+Ky2PpHZs
         Ev7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=oJxS1+Wv0mozz3TAhS0BOcOmGdtUSP5H9bxTQD7t2Io=;
        b=mwX9kBbqMqaSW02CbTS8jGV2K3ny2xQ0BjtKRGyzS83M/0/dAzsw8EcKCLSXO0kovv
         yNWFeigwoH+ZlY6b/KyqcoE6hUV3mBKJQa8mD85VHb3SEGrjJs3r0iuOC9erX1hk4eUG
         0ovWH9nFzssnmLaO/V4kDRUznipsa8dI+8qiGvMOqbIDJOoLXuinnzVDANS5OfHwCnOe
         pC0kzZ+Eg/atPuoqCKHORe59aJqAT6dDO9UGv+T4yZE0hVt21DJzs+VDrM0XcybSHEv/
         f7WJyU27Edi39y8IniKE6l+IyNqbvLv7G8N2bOl7gKnYHHa+70IC8kDrwEaN3CrXmqEe
         ULAA==
X-Gm-Message-State: ANhLgQ1bavytwSUTnu+qtZJtEZEM+gd3HGK5n5yc8IUCxEreSB0nptks
        a3zuQbZjYegfCEZa+ZvjUVqiv16Zw9M=
X-Google-Smtp-Source: ADFU+vsPLKnE3EFLcMaQyv7OFyS8l3M1CoQDrAfH4+o//E4qZu5ZjQstmRtxeGUlYkLXXVso+PZ8Lw==
X-Received: by 2002:a05:6e02:cc1:: with SMTP id c1mr6220547ilj.165.1583261871733;
        Tue, 03 Mar 2020 10:57:51 -0800 (PST)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id j81sm2104965ilg.15.2020.03.03.10.57.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Mar 2020 10:57:51 -0800 (PST)
Subject: Re: [PATCH v3 0/3] next work propagation
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1583258348.git.asml.silence@gmail.com>
 <90a9fcda-dd44-1b5c-7dc6-28ec3a1dd81a@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <1df4c652-31c1-2368-0520-440bfe29cfbd@kernel.dk>
Date:   Tue, 3 Mar 2020 11:57:50 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <90a9fcda-dd44-1b5c-7dc6-28ec3a1dd81a@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/3/20 11:52 AM, Pavel Begunkov wrote:
> On 03/03/2020 21:33, Pavel Begunkov wrote:
>> The next propagation bits are done similarly as it was before, but
>> - nxt stealing is now at top-level, but not hidden in handlers
>> - ensure there is no with REQ_F_DONT_STEAL_NEXT
> 
> Forgot to update this part, and also add, that there is no
> refcount_dec_fetch(), so I did
> 
> io_put_req_async_completion() {
>         refcount_dec()
>         refcount_read()
> }
> 
> because checks in refcount*() are useful, and I intend to remove
> refcount_dec() with the optimisation patches.

I think that's fine, and it's likely still faster than a
refcount_dec_return() would be. Plus then we'd have to argue about that,
since it might not be safe for all use cases. For this one it is.

-- 
Jens Axboe

