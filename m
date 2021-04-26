Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A86536B131
	for <lists+io-uring@lfdr.de>; Mon, 26 Apr 2021 12:02:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232140AbhDZKCq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 26 Apr 2021 06:02:46 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44362 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232877AbhDZKCp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 26 Apr 2021 06:02:45 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212])
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1lay3o-0002RT-2W; Mon, 26 Apr 2021 10:01:48 +0000
Subject: Re: [PATCH][next] io_uring: Fix uninitialized variable up.resv
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210426094735.8320-1-colin.king@canonical.com>
 <ef9d0ed2-a8cd-fc4a-5b02-092d2c151313@gmail.com>
From:   Colin Ian King <colin.king@canonical.com>
Message-ID: <b937f247-e5b2-0630-aa7a-72d495a20667@canonical.com>
Date:   Mon, 26 Apr 2021 11:01:47 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <ef9d0ed2-a8cd-fc4a-5b02-092d2c151313@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 26/04/2021 10:59, Pavel Begunkov wrote:
> On 4/26/21 10:47 AM, Colin King wrote:
>> From: Colin Ian King <colin.king@canonical.com>
>>
>> The variable up.resv is not initialized and is being checking for a
>> non-zero value in the call to _io_register_rsrc_update. Fix this by
>> explicitly setting the pointer to 0.

                          ^^ s/pointer/variable/

Shall I send a V2?

> 
> LGTM, thanks Colin
> 
> 
>> Addresses-Coverity: ("Uninitialized scalar variable)"
>> Fixes: c3bdad027183 ("io_uring: add generic rsrc update with tags")
>> Signed-off-by: Colin Ian King <colin.king@canonical.com>
>> ---
>>  fs/io_uring.c | 1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>> index f4ec092c23f4..63f610ee274b 100644
>> --- a/fs/io_uring.c
>> +++ b/fs/io_uring.c
>> @@ -5842,6 +5842,7 @@ static int io_files_update(struct io_kiocb *req, unsigned int issue_flags)
>>  	up.data = req->rsrc_update.arg;
>>  	up.nr = 0;
>>  	up.tags = 0;
>> +	up.resv = 0;
>>  
>>  	mutex_lock(&ctx->uring_lock);
>>  	ret = __io_register_rsrc_update(ctx, IORING_RSRC_FILE,
>>
> 

