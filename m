Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6CD0616994E
	for <lists+io-uring@lfdr.de>; Sun, 23 Feb 2020 19:04:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726534AbgBWSEu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 23 Feb 2020 13:04:50 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:34126 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726208AbgBWSEt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 23 Feb 2020 13:04:49 -0500
Received: by mail-wr1-f66.google.com with SMTP id n10so7746236wrm.1
        for <io-uring@vger.kernel.org>; Sun, 23 Feb 2020 10:04:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=wasVj1zTfbzuJ5gHhCjJfxgS7TzeBzZkxX2ht31DbFA=;
        b=fSutG0941E3StaV6gJKQvyDMeoECbfYSiGSS1osxk1+xkYi9OudlRUEbiVKm401PN3
         tKYusdgGe5fZ7xZpzdMgzWz+taxXw+tN06f6/0dD0ti5VMFkQ4O1x2AeZxBN9CsBV0TJ
         um9tfHD9yDT4RbSGrgWVWT8yfnsWZUiurdzlPf4UtOwlzSKyqu8uaLhLwzWC9UXUb8/A
         1V23zFGZBsLSH464mxBZGFgYFx4qoURh4+cbKgAYDEOTso0VeiRETNaSPrWSnWfNo02j
         BQBc4GmOxSamT7gQwnb9+xoIKRiar34qaoi9dVU/9vGBedqg4/Z+RQv6U+4gCdLEFfRe
         EHjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=wasVj1zTfbzuJ5gHhCjJfxgS7TzeBzZkxX2ht31DbFA=;
        b=rHE8fi+VdCfEd7FQRM52dDE7VRROfl3NoDrK3xIC0nHOocn9iYXRp0rRtScgnkUo7o
         5qD8uUWJ5HoOK9+sDvEA9b6KYtJNBgYesCd3mYzcYhJ5v401w2cCUqPe3VhHdjBvSzpu
         Xpd2a5MNyRuZKnfbSfLgshdPsfA7HhM2fvFYS54ldsgzmkUKxQsgnDSoHuLyRBgdO0js
         8+P+a7ZpDm6jzyJkb9sCeXLx94lq+z3ji6dM1kAEE47FSCz/vDdFCeRba8sClPOEYtt8
         TIVkBPIIvsROwcBZaPpnE+DH8kSxMHbAB1Y19DBrMZec1RFpPiWe4Z0KvSQrUZlwzOfM
         Bo4g==
X-Gm-Message-State: APjAAAWgQ4f57HUfOdoCWwNufYyKGCMJ/t1XiOiyUTLbUiV5SjRu6WAG
        wdf68e8kEdGa7uO/iEooMAk=
X-Google-Smtp-Source: APXvYqzbh0sM/oJY52i6yMN5TbTxuhkbhqkDEjMWzImtOt19rviIl1exEw5z37SZdIrU+4wDSSBJVA==
X-Received: by 2002:a5d:4d48:: with SMTP id a8mr4702192wru.35.1582481086797;
        Sun, 23 Feb 2020 10:04:46 -0800 (PST)
Received: from [192.168.43.74] ([109.126.153.91])
        by smtp.gmail.com with ESMTPSA id l15sm14242215wrv.39.2020.02.23.10.04.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 23 Feb 2020 10:04:46 -0800 (PST)
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     glauber@scylladb.com, peterz@infradead.org,
        Jann Horn <jannh@google.com>
References: <20200220203151.18709-1-axboe@kernel.dk>
 <20200220203151.18709-8-axboe@kernel.dk>
 <862fb96f-cebe-dfd8-0042-3284985d8704@gmail.com>
 <3c9a3fca-a780-6d04-65cb-c08ef382a2eb@kernel.dk>
 <a5258ad9-ab20-8068-2cb8-848756cf568d@gmail.com>
 <2d869361-18d0-a0fa-cc53-970078d8b826@kernel.dk>
 <08564f4e-8dd1-d656-a22a-325cc1c3e38f@kernel.dk>
 <231dc76e-697f-d8dd-46cb-53776bdc920d@kernel.dk>
 <fcfcf572-f808-6b3a-f9eb-379657babba5@gmail.com>
 <18d38bb6-70e2-24ce-a668-d279b8e3ce4c@kernel.dk>
 <3d4aa255-f333-573c-e806-a3e79a28f3c6@kernel.dk>
 <48e81bbf-89c7-f84d-cefc-86d26baeae07@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH 7/9] io_uring: add per-task callback handler
Message-ID: <3e51d59a-f856-0491-1e51-faed95b3af20@gmail.com>
Date:   Sun, 23 Feb 2020 21:04:02 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <48e81bbf-89c7-f84d-cefc-86d26baeae07@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 23/02/2020 18:07, Jens Axboe wrote:
> On 2/23/20 7:58 AM, Jens Axboe wrote:
>> On 2/23/20 7:49 AM, Jens Axboe wrote:
>>>> Anyway, creds handling is too scattered across the code, and this do a
>>>> lot of useless refcounting and bouncing. It's better to find it a
>>>> better place in the near future.
>>>
>>> I think a good cleanup on top of this would be to move the personality
>>> lookup to io_req_defer_prep(), and kill it from io_submit_sqe(). Now
>>> __io_issue_sqe() does the right thing, and it'll just fall out nicely
>>> with that as far as I can tell.
>>>
>>> Care to send a patch for that?
>>
>> Since we also need it for non-deferral, how about just leaving the
>> lookup in there and removing the assignment? That means we only do that
>> juggling in one spot, which makes more sense. I think this should just
>> be folded into the previous patch.
> 
> Tested, we need a ref grab on the creds when assigning since we're
> dropped at the other end.

Nice, this looks much better.

> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index cead1a0602b4..d83f113f22fd 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -4923,7 +4923,6 @@ static inline void io_queue_link_head(struct io_kiocb *req)
>  static bool io_submit_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
>  			  struct io_submit_state *state, struct io_kiocb **link)
>  {
> -	const struct cred *old_creds = NULL;
>  	struct io_ring_ctx *ctx = req->ctx;
>  	unsigned int sqe_flags;
>  	int ret, id;
> @@ -4938,14 +4937,12 @@ static bool io_submit_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
>  
>  	id = READ_ONCE(sqe->personality);
>  	if (id) {
> -		const struct cred *personality_creds;
> -
> -		personality_creds = idr_find(&ctx->personality_idr, id);
> -		if (unlikely(!personality_creds)) {
> +		req->work.creds = idr_find(&ctx->personality_idr, id);
> +		if (unlikely(!req->work.creds)) {
>  			ret = -EINVAL;
>  			goto err_req;
>  		}
> -		old_creds = override_creds(personality_creds);
> +		get_cred(req->work.creds);
>  	}
>  
>  	/* same numerical values with corresponding REQ_F_*, safe to copy */
> @@ -4957,8 +4954,6 @@ static bool io_submit_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
>  err_req:
>  		io_cqring_add_event(req, ret);
>  		io_double_put_req(req);
> -		if (old_creds)
> -			revert_creds(old_creds);
>  		return false;
>  	}
>  
> @@ -5019,8 +5014,6 @@ static bool io_submit_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
>  		}
>  	}
>  
> -	if (old_creds)
> -		revert_creds(old_creds);
>  	return true;
>  }
>  
> 

-- 
Pavel Begunkov
