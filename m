Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3422F3E4ADD
	for <lists+io-uring@lfdr.de>; Mon,  9 Aug 2021 19:30:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234208AbhHIRaq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 9 Aug 2021 13:30:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233996AbhHIRaq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 9 Aug 2021 13:30:46 -0400
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99724C0613D3
        for <io-uring@vger.kernel.org>; Mon,  9 Aug 2021 10:30:25 -0700 (PDT)
Received: by mail-ot1-x32f.google.com with SMTP id d10-20020a9d4f0a0000b02904f51c5004e3so14462112otl.9
        for <io-uring@vger.kernel.org>; Mon, 09 Aug 2021 10:30:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=OUTedMHqphNOStWFh1qYuqpiYa1+fz/LuX9qPZZJIC0=;
        b=N5wq+zcVqLbW3K93soPFkt/eWXWb6T9l/EmhYWNHDIgHJH1G/Z8LFQV1zrXdCyeczU
         3rTEz26RCyKK+ATFGgpVZONwkjIMdLNx+1ltIQGOPRrXDpHJHCa0hevtYG4t8wEYGT7c
         +JUKz8coMpX+/1xqBUtx0Xa99msDkHeMvbUUtpLffRYsdqahEB+afcUiftXA4qweqAWO
         /vxm7KxWObrDB0WLlxlXPjWT5rI9eQYzuuG4Fm4DYOnX+c8tZiHlXnjFemk2DmH41YmO
         o9lxVN0MquDI9Kp0SJ2P4KIhc6bMTHZbr7jFIjmwJbDyNS3s5Wyo7HrKrSIdQYI+Hx09
         TSCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=OUTedMHqphNOStWFh1qYuqpiYa1+fz/LuX9qPZZJIC0=;
        b=E2W4qAOwjsA/DW8Z47flvmBogp75n+pC0Azb2Z/luD4rrEf05VUkKdJIEBSXudHFMv
         V5lOXIM00DHMpVsoA8REVxNLLHYMSthH0+7XyJxNr3hqRO0iB2LNhx78WGbkCaFbNHrb
         bxK2nNwkuQc1azl4ycSR1O7vI9w8fatXjWZAs0agm9pLF0cnW+d/V7mpdKnKYSCMg6iB
         bImu3xPBEeBVHYaqgakobpo3ZnWqO4Dx/KGr3DT1x9tFaIJdbTqoZz2YN/mFmLdX+vYu
         SareyNUyDeFisEKxI8q96rduzj7kAw7AKdUTX+BUTLqIDHuOlzGRGc8WB1TH///7jXwo
         sBWA==
X-Gm-Message-State: AOAM530ibohSzu4229vmKcKVXXoS2d0XmAH6foEdR5w9KekXLXhol8Dz
        nnUzxXciB+1q2c0URcuaYuX2ld+2D8VPzgCg
X-Google-Smtp-Source: ABdhPJy+PXA0Xi4sd8LUeiEw0Vwp8IBekOZPfmAflLs9JKgMyqwUpfbUhOSzWM+HiIGwIbphxq4dag==
X-Received: by 2002:a9d:2782:: with SMTP id c2mr17729366otb.323.1628530224675;
        Mon, 09 Aug 2021 10:30:24 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id j20sm2864105oos.13.2021.08.09.10.30.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Aug 2021 10:30:24 -0700 (PDT)
Subject: Re: [PATCH 21/28] io_uring: hide async dadta behind flags
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1628471125.git.asml.silence@gmail.com>
 <707ce8945e0247db7a585b5d1c9e8240a22e6708.1628471125.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <4603a964-2812-64ab-8236-ea897f610a83@kernel.dk>
Date:   Mon, 9 Aug 2021 11:30:23 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <707ce8945e0247db7a585b5d1c9e8240a22e6708.1628471125.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/9/21 6:04 AM, Pavel Begunkov wrote:
> Checking flags is a bit faster and can be batched, but the main reason
> of controlling ->async_data with req->flags but not relying on NULL is
> that we safely move it now to the end of io_kiocb, where cachelines are
> rarely loaded, and use that freed space for something more hot like
> io_mapped_ubuf.

As far as I can tell, this will run into an issue with double poll:

static void io_poll_queue_proc(struct file *file, struct wait_queue_head *head, 
                                 struct poll_table_struct *p)
{                                                                               
	struct io_poll_table *pt = container_of(p, struct io_poll_table, pt);   
                                                                                  
	__io_queue_proc(&pt->req->poll, pt, head, (struct io_poll_iocb **) &pt->req->async_data);
}

where we store the potential extra allocation, if any, in the async_data
field. That also needs to get freed when we release this request. One
solution would be to just set REQ_F_ASYNC_DATA before calling
__io_queue_proc().

> @@ -3141,6 +3150,8 @@ static inline int io_alloc_async_data(struct io_kiocb *req)
>  {
>  	WARN_ON_ONCE(!io_op_defs[req->opcode].async_size);
>  	req->async_data = kmalloc(io_op_defs[req->opcode].async_size, GFP_KERNEL);
> +	if (req->async_data)
> +		req->flags |= REQ_F_ASYNC_DATA;
>  	return req->async_data == NULL;
>  }

With this change, would be better to simply do:

if (req->async_data) {
	req->flags |= REQ_F_ASYNC_DATA;
	return false;
}

return true;

-- 
Jens Axboe

