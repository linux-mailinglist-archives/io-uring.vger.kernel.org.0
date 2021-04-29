Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE97D36E8ED
	for <lists+io-uring@lfdr.de>; Thu, 29 Apr 2021 12:36:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232629AbhD2Khl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 29 Apr 2021 06:37:41 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40896 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232245AbhD2Khk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 29 Apr 2021 06:37:40 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212])
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1lc42O-0007Og-Id; Thu, 29 Apr 2021 10:36:52 +0000
Subject: Re: [PATCH][next] io_uring: Fix memory leak on error return path.
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210429102654.58943-1-colin.king@canonical.com>
 <6929b598-ac2f-521a-8e96-dbbf295d137a@gmail.com>
From:   Colin Ian King <colin.king@canonical.com>
Message-ID: <0aa1bcfe-9e45-ac54-1292-43caad8b9b06@canonical.com>
Date:   Thu, 29 Apr 2021 11:36:51 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <6929b598-ac2f-521a-8e96-dbbf295d137a@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 29/04/2021 11:32, Pavel Begunkov wrote:
> On 4/29/21 11:26 AM, Colin King wrote:
>> From: Colin Ian King <colin.king@canonical.com>
>>
>> Currently the -EINVAL error return path is leaking memory allocated
>> to data. Fix this by kfree'ing data before the return.
>>
>> Addresses-Coverity: ("Resource leak")
>> Fixes: c3a40789f6ba ("io_uring: allow empty slots for reg buffers")
>> Signed-off-by: Colin Ian King <colin.king@canonical.com>
>> ---
>>  fs/io_uring.c | 4 +++-
>>  1 file changed, 3 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>> index 47c2f126f885..beeb477e4f6a 100644
>> --- a/fs/io_uring.c
>> +++ b/fs/io_uring.c
>> @@ -8417,8 +8417,10 @@ static int io_sqe_buffers_register(struct io_ring_ctx *ctx, void __user *arg,
>>  		ret = io_buffer_validate(&iov);
>>  		if (ret)
>>  			break;
>> -		if (!iov.iov_base && tag)
>> +		if (!iov.iov_base && tag) {> +			kfree(data);
>>  			return -EINVAL;
>> +		}
> 
> Buggy indeed, should have been:
> 
> ret = -EINVAL;
> break;
Ah, thanks.

> 
> Colin, can you resend with the change?

Will do in a moment or so.
> 
>>  
>>  		ret = io_sqe_buffer_register(ctx, &iov, &ctx->user_bufs[i],
>>  					     &last_hpage);
>>
> 

