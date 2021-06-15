Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE3353A7B58
	for <lists+io-uring@lfdr.de>; Tue, 15 Jun 2021 12:01:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231393AbhFOKDr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 15 Jun 2021 06:03:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231439AbhFOKDm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 15 Jun 2021 06:03:42 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CCCAC061574;
        Tue, 15 Jun 2021 03:01:32 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id f16-20020a05600c1550b02901b00c1be4abso1343046wmg.2;
        Tue, 15 Jun 2021 03:01:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:references:from:subject:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=6m2622jH6xxUBqqW7CQu925QgNn7I6YBkLdVIXOmSOk=;
        b=kWzBnPerdDME4nff5nC4aP50OIa/17pFnPzgC4+LOTFo6y+XyVXyFrkAdVNtcb517V
         gN3RU0+gPjwuAfVKbrY68WRvDqcGCx7CxLF54Zna5XUzRTMjbXNd7wZ/SY9zktecm8JW
         yT3C4R3B8MIaxdXmXxvYmqnbWc2F1QXy297XuroOCeZ/E1hYMj+nDRC0FV7DlqFHDuRM
         Dv6rHyz+YxkPJnq6cRadxV0D5QJOo4+lvX0ZDn6RvvXxHjKoVIrB/ocXrNcWVTHwv9NH
         Tnrj9G04nW30tajrJK4njmEDaF/N69cfrF/QhNcADUkqLflOxXXzPl2laV5ANExMkfFf
         Ct1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6m2622jH6xxUBqqW7CQu925QgNn7I6YBkLdVIXOmSOk=;
        b=a8n9rn4tPqP5TGWZYCfmYd9RxuBBBOIGw+fiunIMrnE4g5I7j/Iq4YxV4rPac9hydG
         M4HdhcAUMrIkj0nH85mscnn586yunvpa8kUEselgb2tupk6Y3jafWWV7SSa88zXC0JkY
         Lg3heZNu6XeRvojLEkqoM4ZS8pxr+UbtV43HVoSpYX2cVbaGlRmcGuwGt4biZjoePTcN
         3FrvAoZeK2QTk3iEPHXYdNGubhcl2ANsaOU8dZSsr9EM0NHbt60EtfxjdwQq1Qq4vAqf
         2PAb6wXOmREQuvSRiEvZ4hs4AaAYhH7wqe+m5oCfPpvhfax5nHBn7XGwO1ArljdHq0x1
         1rJw==
X-Gm-Message-State: AOAM5307sXGL4ibaiIIv3CGtla/jeSLo8GrtHfeO91p/JMEdwd/e30JH
        QRXrrDunI/NUQXTQZltqqeA3XTKb13GmHTZu
X-Google-Smtp-Source: ABdhPJx1Q1EkRg1RqLbBc92fgSmR/QPjpjk4+H6BdPAFtshEb5sy1Ggzn7bgpDmwmYDUAbVXLe5DQQ==
X-Received: by 2002:a1c:f613:: with SMTP id w19mr4087753wmc.136.1623751290861;
        Tue, 15 Jun 2021 03:01:30 -0700 (PDT)
Received: from [192.168.8.197] ([148.252.132.209])
        by smtp.gmail.com with ESMTPSA id 73sm19402122wrk.17.2021.06.15.03.01.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Jun 2021 03:01:30 -0700 (PDT)
To:     Olivier Langlois <olivier@trillion01.com>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <60c83c12.1c69fb81.e3bea.0806SMTPIN_ADDED_MISSING@mx.google.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [PATCH] io_uring: store back buffer in case of failure
Message-ID: <93256513-08d8-5b15-aa98-c1e83af60b54@gmail.com>
Date:   Tue, 15 Jun 2021 11:01:18 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <60c83c12.1c69fb81.e3bea.0806SMTPIN_ADDED_MISSING@mx.google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/11/21 8:46 PM, Olivier Langlois wrote:
> the man page says the following:
> 
>     If succesful, the resulting CQE will have IORING_CQE_F_BUFFER set
> in the flags part of the struct, and the upper IORING_CQE_BUFFER_SHIFT
> bits will contain the ID of the selected buffers.
> 
> in order to respect this contract, the buffer is stored back in case of
> an error. There are several reasons to do that:
> 
> 1. doing otherwise is counter-intuitive and error-prone (I cannot think
> of a single example of a syscall failing and still require the user to
> free the allocated resources). Especially when the documention
> explicitly mention that this is the behavior to expect.
> 
> 2. it is inefficient because the buffer is unneeded since there is no
> data to transfer back to the user and the buffer will need to be
> returned back to io_uring to avoid a leak.
> 
> Signed-off-by: Olivier Langlois <olivier@trillion01.com>
> ---
>  fs/io_uring.c | 97 +++++++++++++++++++++++++++++++++------------------
>  1 file changed, 64 insertions(+), 33 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 42380ed563c4..502d7cd81a8c 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
[...]
> +static unsigned int io_put_kbuf(struct io_kiocb *req, struct io_buffer *kbuf,
> +				u16 bgid, long res, unsigned int issue_flags)
>  {
>  	unsigned int cflags;
> +	struct io_ring_ctx *ctx = req->ctx;
> +	struct io_buffer *head;
> +	bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
>  
>  	cflags = kbuf->bid << IORING_CQE_BUFFER_SHIFT;
>  	cflags |= IORING_CQE_F_BUFFER;
>  	req->flags &= ~REQ_F_BUFFER_SELECTED;
> -	kfree(kbuf);
> +
> +	/*
> +	 * Theoritically, res == 0 could be included as well but that would
> +	 * break the contract established in the man page saying that
> +	 * a buffer is returned if the operation is successful.
> +	 */
> +	if (unlikely(res < 0)) {
> +		io_ring_submit_lock(ctx, !force_nonblock);

io_complete_rw() is called from an IRQ context, so it can't sleep/wait.

> +
> +		lockdep_assert_held(&ctx->uring_lock);
> +
> +		head = xa_load(&ctx->io_buffers, bgid);
> +		if (head) {
> +			list_add_tail(&kbuf->list, &head->list);
> +			cflags = 0;
> +		} else {
> +			INIT_LIST_HEAD(&kbuf->list);
> +			if (!xa_insert(&ctx->io_buffers, bgid, kbuf, GFP_KERNEL))
> +				cflags = 0;
> +		}
> +		io_ring_submit_unlock(ctx, !force_nonblock);
> +	}
> +	if (cflags)
> +		kfree(kbuf);
>  	return cflags;
>  }
>  
[...]
> -static inline void io_rw_done(struct kiocb *kiocb, ssize_t ret)
> +static inline void io_rw_done(struct kiocb *kiocb, ssize_t ret,
> +			      unsigned int issue_flags)
>  {
>  	switch (ret) {
>  	case -EIOCBQUEUED:
> @@ -2728,7 +2775,7 @@ static inline void io_rw_done(struct kiocb *kiocb, ssize_t ret)
>  		ret = -EINTR;
>  		fallthrough;
>  	default:
> -		kiocb->ki_complete(kiocb, ret, 0);
> +		kiocb->ki_complete(kiocb, ret, issue_flags);

Don't remember what the second argument of .ki_complete is for,
but it definitely should not be used for issue_flags. E.g. because
we get two different meanings for it depending on a context --
either a result from the block layer or issue_flags.

-- 
Pavel Begunkov
