Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30AE44BEAA2
	for <lists+io-uring@lfdr.de>; Mon, 21 Feb 2022 20:36:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229574AbiBUSOV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 21 Feb 2022 13:14:21 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231526AbiBUSMe (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 21 Feb 2022 13:12:34 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED3B2215;
        Mon, 21 Feb 2022 10:03:36 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id s14so13658950edw.0;
        Mon, 21 Feb 2022 10:03:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=JSzbeyJ3wmi72yBQpp06Oo4N3LKGxxejN6QrBogGfGY=;
        b=ImHynHr4TWu/Jy3NY3KN2p5AbC6LhDNHrAmrMj7BkA8vKIuHo+2S3dB7i1FcXXu6xT
         Aw9mYdUevGkiHxzsqJpQzsOa6VkXKDSRN2d+pUvSj/xSdO9NRZlYRdRokOH3uYu8++8S
         5SCfSWWB0EJc854KDzKK2iFAF2GSLXVkmybj6xQ2DjB1S+SKB+PfBLjVmePk4EUgIQ8U
         SjKX2rB2nrNULYbIXBg6zlWB+tEelS3RtuXdkrIpEkBkbnlkWKaEmLse7xjaEE4ET57G
         fnjczkAFH8kjtR2qjQuokfibC3+s0gk7Kn3zwutU9Lpwrgv/jMTwJ4OgXyumcIrhF+TZ
         Xctg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=JSzbeyJ3wmi72yBQpp06Oo4N3LKGxxejN6QrBogGfGY=;
        b=RkcurywT6jXQXQIcEbLUmbKLlCCW0/R9HKr35URmRAALOJf/tKqe3+2HqbbjPC6dwh
         dNY87OPu+hAFFhp8AAYNz+5mAc0cEW4nw4z6NDEDGKtoj9oSSUO//egTHnkWDQ+MR0tx
         GzgDngzEUulNcQ7RpkkdfppRZfe92Ld76/XryFkc/A0kpaXQgIRQn29SihUiqGnzSYS1
         IUt/dVsgx8mfRFvHPeUbG7GEhz6GMAue8eNHJr9eXLWEbTRlNGvvPjIHuCbiJsK/UdfO
         JuHC5heKW60Z0JdLE/AYmPlzdzZjjDFBNmYYL091LX5PrMg6Q+KOQOpZ/30FC21jrCt8
         q3Iw==
X-Gm-Message-State: AOAM531635p+Ncj1WMn7Nyo1a11lAELUPTrJrt6q4OflqjO2CBO10yMY
        DTDXVk/LsvUKWqIZoTRL3QySMYbB8oM=
X-Google-Smtp-Source: ABdhPJyRHVKif8YwOMbAOuZy8/YcSv7z4RmtG1Sdw/znjf5FGmjpGfTCWwd3HIqBOrfosroOHlBazg==
X-Received: by 2002:a05:6402:350e:b0:412:d02f:9004 with SMTP id b14-20020a056402350e00b00412d02f9004mr16805706edd.59.1645466615399;
        Mon, 21 Feb 2022 10:03:35 -0800 (PST)
Received: from [192.168.8.198] ([85.255.234.184])
        by smtp.gmail.com with ESMTPSA id nc40sm3123736ejc.127.2022.02.21.10.03.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Feb 2022 10:03:35 -0800 (PST)
Message-ID: <ec1647f3-2c37-04be-bdbd-ab78b9f07a03@gmail.com>
Date:   Mon, 21 Feb 2022 18:00:17 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [PATCH v2 4/4] io_uring: pre-increment f_pos on rw
Content-Language: en-US
To:     Dylan Yudaken <dylany@fb.com>, Jens Axboe <axboe@kernel.dk>,
        io-uring@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, kernel-team@fb.com
References: <20220221141649.624233-1-dylany@fb.com>
 <20220221141649.624233-5-dylany@fb.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20220221141649.624233-5-dylany@fb.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/21/22 14:16, Dylan Yudaken wrote:
> In read/write ops, preincrement f_pos when no offset is specified, and
> then attempt fix up the position after IO completes if it completed less
> than expected. This fixes the problem where multiple queued up IO will all
> obtain the same f_pos, and so perform the same read/write.
> 
> This is still not as consistent as sync r/w, as it is able to advance the
> file offset past the end of the file. It seems it would be quite a
> performance hit to work around this limitation - such as by keeping track
> of concurrent operations - and the downside does not seem to be too
> problematic.
> 
> The attempt to fix up the f_pos after will at least mean that in situations
> where a single operation is run, then the position will be consistent.
> 
> Co-developed-by: Jens Axboe <axboe@kernel.dk>
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> Signed-off-by: Dylan Yudaken <dylany@fb.com>
> ---
>   fs/io_uring.c | 81 ++++++++++++++++++++++++++++++++++++++++++---------
>   1 file changed, 68 insertions(+), 13 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index abd8c739988e..a951d0754899 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -3066,21 +3066,71 @@ static inline void io_rw_done(struct kiocb *kiocb, ssize_t ret)

[...]

> +			return false;
>   		}
>   	}
> -	return is_stream ? NULL : &kiocb->ki_pos;
> +	*ppos = is_stream ? NULL : &kiocb->ki_pos;
> +	return false;
> +}
> +
> +static inline void
> +io_kiocb_done_pos(struct io_kiocb *req, struct kiocb *kiocb, u64 actual)

That's a lot of inlining, I wouldn't be surprised if the compiler
will even refuse to do that.

io_kiocb_done_pos() {
	// rest of it
}

inline io_kiocb_done_pos() {
	if (!(flags & CUR_POS));
		return;
	__io_kiocb_done_pos();
}

io_kiocb_update_pos() is huge as well

> +{
> +	u64 expected;
> +
> +	if (likely(!(req->flags & REQ_F_CUR_POS)))
> +		return;
> +
> +	expected = req->rw.len;
> +	if (actual >= expected)
> +		return;
> +
> +	/*
> +	 * It's not definitely safe to lock here, and the assumption is,
> +	 * that if we cannot lock the position that it will be changing,
> +	 * and if it will be changing - then we can't update it anyway
> +	 */
> +	if (req->file->f_mode & FMODE_ATOMIC_POS
> +		&& !mutex_trylock(&req->file->f_pos_lock))
> +		return;
> +
> +	/*
> +	 * now we want to move the pointer, but only if everything is consistent
> +	 * with how we left it originally
> +	 */
> +	if (req->file->f_pos == kiocb->ki_pos + (expected - actual))
> +		req->file->f_pos = kiocb->ki_pos;

I wonder, is it good enough / safe to just assign it considering that
the request was executed outside of locks? vfs_seek()?

> +
> +	/* else something else messed with f_pos and we can't do anything */
> +
> +	if (req->file->f_mode & FMODE_ATOMIC_POS)
> +		mutex_unlock(&req->file->f_pos_lock);
>   }

Do we even care about races while reading it? E.g.
pos = READ_ONCE();

>   
> -	ppos = io_kiocb_update_pos(req, kiocb);
> -
>   	ret = rw_verify_area(READ, req->file, ppos, req->result);
>   	if (unlikely(ret)) {
>   		kfree(iovec);
> +		io_kiocb_done_pos(req, kiocb, 0);

Why do we update it on failure?

[...]

> -	ppos = io_kiocb_update_pos(req, kiocb);
> -
>   	ret = rw_verify_area(WRITE, req->file, ppos, req->result);
>   	if (unlikely(ret))
>   		goto out_free;
> @@ -3858,6 +3912,7 @@ static int io_write(struct io_kiocb *req, unsigned int issue_flags)
>   		return ret ?: -EAGAIN;
>   	}
>   out_free:
> +	io_kiocb_done_pos(req, kiocb, 0);

Looks weird. It appears we don't need it on failure and
successes are covered by kiocb_done() / ->ki_complete

>   	/* it's reportedly faster than delegating the null check to kfree() */
>   	if (iovec)
>   		kfree(iovec);

-- 
Pavel Begunkov
