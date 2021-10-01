Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96E0141EF41
	for <lists+io-uring@lfdr.de>; Fri,  1 Oct 2021 16:18:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353834AbhJAOTn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 1 Oct 2021 10:19:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231806AbhJAOTj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 1 Oct 2021 10:19:39 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C6DCC061775
        for <io-uring@vger.kernel.org>; Fri,  1 Oct 2021 07:17:55 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id l7so11671298edq.3
        for <io-uring@vger.kernel.org>; Fri, 01 Oct 2021 07:17:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:from:to:references:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=VRf7GFHU3DCGiAjK65jrThAAO7PwObpyr5zic8mUGvY=;
        b=HAhZLYjgG9nkK9O6Fdy+sJalGOxT+SP4d9AiD/WtixbHIMYo94S1cSItzcFAzVJaSx
         MRzi/Yu27Gdw1ASuyzbQAvfH/Newcd7bCJaT6eerZkW0fU36RgFStGAXsySXxb6D8jz2
         0sTf9WJshuRBcYPFfjP00HLy957gUX1vypJkZJh3OvsqGj9t/+GRoxeANWRGXDjuPSA1
         ZwRAkyMHG1f3WFOxf9V0PlCR2shaSsHFe472TJS2D3XIj3norWFfdN/4MCR0+6n14oKk
         2BIQcsMnZ1mB9J/7HjWV4bx33FUm4UL78OUN/AQrzWxwg62sKRcs0liGOXuTa2L5ocug
         XIQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:from:to:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VRf7GFHU3DCGiAjK65jrThAAO7PwObpyr5zic8mUGvY=;
        b=cBpnQ3drBGGJHa0UIjmIiHh8I9Eb8lGUqpcqXFwypWQP7k2K9tApxV4dgjvYBFAg1n
         asSJStlio2E4+xql66HbxzBfkWyQMvdpfOZMUqLE+tvab6nKyj1S9zVGFfZ4Wfg9y2ow
         0wIrQMNgng7UBpPnnyH4dpkSXvNKStELJ5mttsRkHas41WgWcd0/f10Pi+0XqF160cW9
         MOa4S70I2pj2TuiVa9QncJuhWhFtRLUpzFaHeHN6AQyXrRYlm+/Guy+MKX0xLjJPL3RI
         DPHwDL4L7vapqpuCITmTpi4iFisG8IHzvSuSAV0BlnVi/CTDoPYf5Z6e24suA9PGKgLr
         shAA==
X-Gm-Message-State: AOAM532/eDu7FBqzHr3d+R1Lp0fMCqZ0h8Yvwt8Yv4fNhkmKsnOkT7dW
        Zf+SZJJ1LpXlIxqrraw5SflPAY4EstI=
X-Google-Smtp-Source: ABdhPJyq1MuXSBGNp1/TKrPFTdtV9uWDIFNwGqA/sOilEDIrUTa4VJSNFYN3GqR/aFNuP8ZGUyWTTA==
X-Received: by 2002:a17:906:5d5:: with SMTP id t21mr6709760ejt.160.1633097873191;
        Fri, 01 Oct 2021 07:17:53 -0700 (PDT)
Received: from [192.168.8.197] ([85.255.233.39])
        by smtp.gmail.com with ESMTPSA id ky7sm3038353ejc.75.2021.10.01.07.17.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Oct 2021 07:17:52 -0700 (PDT)
Subject: Re: [PATCH 1/1] io_uring: kill fasync
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <2f7ca3d344d406d34fa6713824198915c41cea86.1633080236.git.asml.silence@gmail.com>
 <75491111-e4fe-59e3-ab4e-827f1a9ebef2@gmail.com>
Message-ID: <d0bfbcab-33db-b9f0-6561-c8e4b88c0393@gmail.com>
Date:   Fri, 1 Oct 2021 15:17:15 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <75491111-e4fe-59e3-ab4e-827f1a9ebef2@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/1/21 3:07 PM, Pavel Begunkov wrote:
> On 10/1/21 10:39 AM, Pavel Begunkov wrote:
>> We have never supported fasync properly, it would only fire when there
>> is something polling io_uring making it useless. Get rid of fasync bits.
> 
> Actually, it looks there is something screwed, let's hold on this

My bad, failed because of unrelated change, this one is good to go

> 
> 
>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>> ---
>>  fs/io_uring.c | 17 ++---------------
>>  1 file changed, 2 insertions(+), 15 deletions(-)
>>
>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>> index c6a82c67a93d..f76a9b6bed2c 100644
>> --- a/fs/io_uring.c
>> +++ b/fs/io_uring.c
>> @@ -398,7 +398,6 @@ struct io_ring_ctx {
>>  		struct wait_queue_head	cq_wait;
>>  		unsigned		cq_extra;
>>  		atomic_t		cq_timeouts;
>> -		struct fasync_struct	*cq_fasync;
>>  		unsigned		cq_last_tm_flush;
>>  	} ____cacheline_aligned_in_smp;
>>  
>> @@ -1614,10 +1613,8 @@ static void io_cqring_ev_posted(struct io_ring_ctx *ctx)
>>  		wake_up(&ctx->sq_data->wait);
>>  	if (io_should_trigger_evfd(ctx))
>>  		eventfd_signal(ctx->cq_ev_fd, 1);
>> -	if (waitqueue_active(&ctx->poll_wait)) {
>> +	if (waitqueue_active(&ctx->poll_wait))
>>  		wake_up_interruptible(&ctx->poll_wait);
>> -		kill_fasync(&ctx->cq_fasync, SIGIO, POLL_IN);
>> -	}
>>  }
>>  
>>  static void io_cqring_ev_posted_iopoll(struct io_ring_ctx *ctx)
>> @@ -1631,10 +1628,8 @@ static void io_cqring_ev_posted_iopoll(struct io_ring_ctx *ctx)
>>  	}
>>  	if (io_should_trigger_evfd(ctx))
>>  		eventfd_signal(ctx->cq_ev_fd, 1);
>> -	if (waitqueue_active(&ctx->poll_wait)) {
>> +	if (waitqueue_active(&ctx->poll_wait))
>>  		wake_up_interruptible(&ctx->poll_wait);
>> -		kill_fasync(&ctx->cq_fasync, SIGIO, POLL_IN);
>> -	}
>>  }
>>  
>>  /* Returns true if there are no backlogged entries after the flush */
>> @@ -9304,13 +9299,6 @@ static __poll_t io_uring_poll(struct file *file, poll_table *wait)
>>  	return mask;
>>  }
>>  
>> -static int io_uring_fasync(int fd, struct file *file, int on)
>> -{
>> -	struct io_ring_ctx *ctx = file->private_data;
>> -
>> -	return fasync_helper(fd, file, on, &ctx->cq_fasync);
>> -}
>> -
>>  static int io_unregister_personality(struct io_ring_ctx *ctx, unsigned id)
>>  {
>>  	const struct cred *creds;
>> @@ -10155,7 +10143,6 @@ static const struct file_operations io_uring_fops = {
>>  	.mmap_capabilities = io_uring_nommu_mmap_capabilities,
>>  #endif
>>  	.poll		= io_uring_poll,
>> -	.fasync		= io_uring_fasync,
>>  #ifdef CONFIG_PROC_FS
>>  	.show_fdinfo	= io_uring_show_fdinfo,
>>  #endif
>>
> 

-- 
Pavel Begunkov
