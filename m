Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12385200B13
	for <lists+io-uring@lfdr.de>; Fri, 19 Jun 2020 16:13:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728606AbgFSONu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 19 Jun 2020 10:13:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725974AbgFSONr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 19 Jun 2020 10:13:47 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF15EC06174E;
        Fri, 19 Jun 2020 07:13:46 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id l12so10346159ejn.10;
        Fri, 19 Jun 2020 07:13:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=/u6tJnI73bJ/e/Tlk8P+EJrFujPPPek4eDZC5ID4TB4=;
        b=OOdb10J3fJcUv7rD7aa2nUAL2at0tcc+aJ+JmPHo1mNqaaNtEE2mGL/LDBYIA/RChO
         fLIWzDY8P23r2i12eghtL9CGezE+y0Z3lL35O+bnRFBfSaz2DZRUOhpgbB7jzRncPr4k
         IMx6vBGtazjQgbTxo+DrN0HJpgkU/GUoqttbcppx4cZUrusCKEfnkDAYU/811C0svVSc
         DYukW/CJQcoW8m/papdvBWF4L49snxiYqT+7InBCdUwcKOILhkFBuH7wVRJYP6KH9QJ7
         mD63k6lXHNav4GC+dP2hEsJo2fsZBjaU9UIzPbVUT24Tb9bGvJWKpR+BCFmxDsmrrspB
         PsJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=/u6tJnI73bJ/e/Tlk8P+EJrFujPPPek4eDZC5ID4TB4=;
        b=ZKjVNoQs0t/Vr5Dzm+U0klL6JiRFLtjhI37hoRKHUayZXq/zm5/0V6ZebuHJuL9Cq5
         avArnjfmGUZXqDDUh6va/0ni/S+Rg8iNGRBmqt1aHxqGJN/IjtSB62zV2+zm1cvSUb1h
         s+hMXd1AAX5abmG4U2jyVhNhRd1RvfmNuQLjPVXn2yzh4AmFnO+TZtO4D6TeHD0brjbR
         q8w/eyrgAzXT8iQlZNgSGfIFAFzV95y9nxwxhMb9f/uljUxqviftFCoGn14r3DpkdqUs
         RjOBscA1uq2Orsgdi4PmQXgbsQsqjbKTXGg1i7GFARfxyCiWiBuU8MOGLhG520hL67ct
         2usQ==
X-Gm-Message-State: AOAM5317lKRSP2qJpWoPI3rOxOteu/76nv8tGimiLVPDuaHEp+4lh6oL
        4ml4r5s69XHMGtfuUk6GeaNWBCJY
X-Google-Smtp-Source: ABdhPJwWdBfRvifwAV1AW1ZLcskxfE0/peDRuwlANJdnd5OP32hhuWt7QQZuJy2YsaBdReoZ4DuO7w==
X-Received: by 2002:a17:907:216c:: with SMTP id rl12mr4088982ejb.156.1592576025563;
        Fri, 19 Jun 2020 07:13:45 -0700 (PDT)
Received: from [192.168.43.243] ([5.100.193.151])
        by smtp.gmail.com with ESMTPSA id k24sm4611013edk.95.2020.06.19.07.13.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Jun 2020 07:13:45 -0700 (PDT)
To:     io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, akpm@linux-foundation.org
References: <20200618144355.17324-1-axboe@kernel.dk>
 <20200618144355.17324-5-axboe@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH 04/15] io_uring: re-issue block requests that failed
 because of resources
Message-ID: <cdd4bf56-5a08-5d28-969f-81b70cc3c473@gmail.com>
Date:   Fri, 19 Jun 2020 17:12:17 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20200618144355.17324-5-axboe@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 18/06/2020 17:43, Jens Axboe wrote:
> Mark the plug with nowait == true, which will cause requests to avoid
> blocking on request allocation. If they do, we catch them and reissue
> them from a task_work based handler.
> 
> Normally we can catch -EAGAIN directly, but the hard case is for split
> requests. As an example, the application issues a 512KB request. The
> block core will split this into 128KB if that's the max size for the
> device. The first request issues just fine, but we run into -EAGAIN for
> some latter splits for the same request. As the bio is split, we don't
> get to see the -EAGAIN until one of the actual reads complete, and hence
> we cannot handle it inline as part of submission.
> 
> This does potentially cause re-reads of parts of the range, as the whole
> request is reissued. There's currently no better way to handle this.
> 
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>  fs/io_uring.c | 148 ++++++++++++++++++++++++++++++++++++++++++--------
>  1 file changed, 124 insertions(+), 24 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 2e257c5a1866..40413fb9d07b 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -900,6 +900,13 @@ static int io_file_get(struct io_submit_state *state, struct io_kiocb *req,
>  static void __io_queue_sqe(struct io_kiocb *req,
>  			   const struct io_uring_sqe *sqe);
>  
...> +
> +static void io_rw_resubmit(struct callback_head *cb)
> +{
> +	struct io_kiocb *req = container_of(cb, struct io_kiocb, task_work);
> +	struct io_ring_ctx *ctx = req->ctx;
> +	int err;
> +
> +	__set_current_state(TASK_RUNNING);
> +
> +	err = io_sq_thread_acquire_mm(ctx, req);
> +
> +	if (io_resubmit_prep(req, err)) {
> +		refcount_inc(&req->refs);
> +		io_queue_async_work(req);
> +	}

Hmm, I have similar stuff but for iopoll. On top removing grab_env* for
linked reqs and some extra. I think I'll rebase on top of this.

> +}
> +#endif
> +
> +static bool io_rw_reissue(struct io_kiocb *req, long res)
> +{
> +#ifdef CONFIG_BLOCK
> +	struct task_struct *tsk;
> +	int ret;
> +
> +	if ((res != -EAGAIN && res != -EOPNOTSUPP) || io_wq_current_is_worker())
> +		return false;
> +
> +	tsk = req->task;
> +	init_task_work(&req->task_work, io_rw_resubmit);
> +	ret = task_work_add(tsk, &req->task_work, true);

I don't like that the request becomes un-discoverable for cancellation
awhile sitting in the task_work list. Poll stuff at least have hash_node
for that.

> +	if (!ret)
> +		return true;
> +#endif
> +	return false;
> +}
> +

-- 
Pavel Begunkov
