Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8795E12BE18
	for <lists+io-uring@lfdr.de>; Sat, 28 Dec 2019 18:03:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726100AbfL1RDv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 28 Dec 2019 12:03:51 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:46613 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726080AbfL1RDv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 28 Dec 2019 12:03:51 -0500
Received: by mail-pg1-f196.google.com with SMTP id z124so15950950pgb.13
        for <io-uring@vger.kernel.org>; Sat, 28 Dec 2019 09:03:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=QvjnXLLKPymtY82PWmMDmpJTxCRz0c5SPqFwNtPtmKU=;
        b=RnhBqvVTxwPcme8Mt7R4p0ZWdzW/udQmCnBzVF8JYnzb0w3T9Jsb1TFegu3VV26cte
         N7r7CdxxkT2AkfjUud6L8ihKvUckQhQnCjQD1s/gMYZCvXBTV/FPi9uxsBCBCfoYqn4y
         cwCWY9kO8vQO/iKiOprNvkzSkR6UshOmoJljwM191mkH5JLvu97EEPagEOV+jh88eZXK
         HpocQZJZ69UAOXqWtoVY5sbBy5glRMSioMaubRtF4WnJwQaeKWu4kkbyo9TgaXJjcSZ4
         yu2G4ulDNWQXvQyilN2wR50EB1CfGwBPhcK5EcmEqylOGYLq0e7+G2j8fGfacuGb2s3B
         m6Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QvjnXLLKPymtY82PWmMDmpJTxCRz0c5SPqFwNtPtmKU=;
        b=lq6UZ+jx4ro+ggfeYlywd8MdQoAWUoigxmYzdJsJav5uMXRWRr0hxjJkFvJHyEcjvh
         nnF6S1hGmCKdqxjVLzoxBZoQ0jY/753NXM4pJsTpYJEZAtDN1mPL9ZmUcC/Lcbj/Shik
         SMBXqFJaEpjCmvK3GApk0kHX14f+8MSdX+7jteNRTKxOOyr3Xuypkqb4Y1T5Y79AztlM
         A87lqLWEGOxMUOuExp8DXyhP/u4qOGQVDdkXDPvlM3nhzWmqGz7QEDUzrYU8BWYyf3Mm
         7g48Ug1KJm5zsIYOg1GoOBOWLSG2INy1yGvjSoAhLg264w5uxYZF6jyM0Xpi7YDao59m
         eIAg==
X-Gm-Message-State: APjAAAXox4O8B2qpNt3JcOQBTUzFLUIGdjTFKz3vQOdUjxSrqkvFrJb9
        BNA+ypLr86vtWW2mHDGRveiY4yUAEsqF4Q==
X-Google-Smtp-Source: APXvYqwufA27RzTNs7e/EWFqvNItAe3UUyNgAbJ9Ss5Gvs7SJnOUnPZRTUKzb5EpBnlIv2QR6MmxqQ==
X-Received: by 2002:aa7:86c3:: with SMTP id h3mr51819095pfo.225.1577552630847;
        Sat, 28 Dec 2019 09:03:50 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id t137sm41259142pgb.40.2019.12.28.09.03.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 28 Dec 2019 09:03:50 -0800 (PST)
Subject: Re: [PATCH v4 2/2] io_uring: batch getting pcpu references
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1577528535.git.asml.silence@gmail.com>
 <1250dad37e9b73d39066a8b464f6d2cab26eef8a.1577528535.git.asml.silence@gmail.com>
 <6facf552-924f-2af1-03e5-99957a90bfd0@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <e0c5f132-b916-4710-a0f3-036e4df07c69@kernel.dk>
Date:   Sat, 28 Dec 2019 10:03:49 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <6facf552-924f-2af1-03e5-99957a90bfd0@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/28/19 4:15 AM, Pavel Begunkov wrote:
> On 28/12/2019 14:13, Pavel Begunkov wrote:
>> percpu_ref_tryget() has its own overhead. Instead getting a reference
>> for each request, grab a bunch once per io_submit_sqes().
>>
>> ~5% throughput boost for a "submit and wait 128 nops" benchmark.
>>
>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>> ---
>>  fs/io_uring.c | 26 +++++++++++++++++---------
>>  1 file changed, 17 insertions(+), 9 deletions(-)
>>
>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>> index 7fc1158bf9a4..404946080e86 100644
>> --- a/fs/io_uring.c
>> +++ b/fs/io_uring.c
>> @@ -1080,9 +1080,6 @@ static struct io_kiocb *io_get_req(struct io_ring_ctx *ctx,
>>  	gfp_t gfp = GFP_KERNEL | __GFP_NOWARN;
>>  	struct io_kiocb *req;
>>  
>> -	if (!percpu_ref_tryget(&ctx->refs))
>> -		return NULL;
>> -
>>  	if (!state) {
>>  		req = kmem_cache_alloc(req_cachep, gfp);
>>  		if (unlikely(!req))
>> @@ -1141,6 +1138,14 @@ static void io_free_req_many(struct io_ring_ctx *ctx, void **reqs, int *nr)
>>  	}
>>  }
>>  
>> +static void __io_req_free_empty(struct io_kiocb *req)
> 
> If anybody have better naming (or a better approach at all), I'm all ears.

__io_req_do_free()?

I think that's better than the empty, not quite sure what that means.
If you're fine with that, I can just make that edit when applying.
The rest looks fine to me now.

-- 
Jens Axboe

