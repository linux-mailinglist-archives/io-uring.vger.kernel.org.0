Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7872C54EB4D
	for <lists+io-uring@lfdr.de>; Thu, 16 Jun 2022 22:37:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378274AbiFPUhQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 16 Jun 2022 16:37:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377916AbiFPUhO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 16 Jun 2022 16:37:14 -0400
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8B345DA11
        for <io-uring@vger.kernel.org>; Thu, 16 Jun 2022 13:37:11 -0700 (PDT)
Received: by mail-il1-x131.google.com with SMTP id f7so1707402ilr.5
        for <io-uring@vger.kernel.org>; Thu, 16 Jun 2022 13:37:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=u5dKEO6fWLwy94MPcv5oscW/z8Gx/tm0njHp3iApi1w=;
        b=2fZWvMnEvahk9m30GkmsvO/3zYXopKME2jL8YsMlI7Smp4zLBMVPv+hQPhozavBM8A
         Gl0wz6b9I8JA9XOk8sLDOeMxXMWhGRR7Fb9yB752PLFGv34W/3e5/eYZgxz19BkeeY+E
         95JRB112KfTJEj69NwaZ2HdwYBOiuMca3ddeKg87KedmYehA2+x/+nKK0hwAP07Vvm3B
         lJoTyCiQnYosn/PYz5jTkKHZuR6fVjEqwDeBCF6cFwdh2eQYn4dFneohalFH8v+FmCiI
         ct6mjDUlSXHs/XDI40ZO1hxqkx2PmsPI1emykfshlF+Zr4XN/zTEHM9ScVLpaJZeEBL9
         zyUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=u5dKEO6fWLwy94MPcv5oscW/z8Gx/tm0njHp3iApi1w=;
        b=T3q+gVB4iBKVvY5RqTSZ0s9dKV7tFXOwyTHXeQduLK9N3Ke7FGgea6sF8maMULveob
         Lji8rMHTI9OipzYmohrpyp+mrCoR3ioHYvAJJrGXvD5Sx2dN70B7KdY0vnIzNCv3tHzq
         Z0Mb0LWLEjvxYby0W5/IPDbNPlzB9lvqQiuDFntcaY6KtJ8sj/Bz2tLFFm5loCss7V+y
         gyEFOua5c0sqFWWK3W2kvUttXurS4nf4+8zGs/zI7L+T0HG8AY44+yiR6t4Kt7l1QbW6
         JbtB6rIFlzgmaiY4M0rne9DDLv1AAYLn2vGQ9kH2CFjIEOm7v1jyMJ09P7A+sfns9Ww8
         LJRw==
X-Gm-Message-State: AJIora+t82hGDDiHCfX3XxkB67MVHht/ZZ3wvs5zMUVU1GnIyxVsctXW
        vhP83qN+1+0lW5Ad+Sx7YD7WMQ==
X-Google-Smtp-Source: AGRyM1syT2ctM65Koqig9IIbe+be7cM2t2pBFa5Q9NqlfV4ao4UTDpYp3ycfvaQVEzPV6PhumKxxDQ==
X-Received: by 2002:a05:6e02:180e:b0:2d3:c497:710 with SMTP id a14-20020a056e02180e00b002d3c4970710mr3747661ilv.166.1655411831039;
        Thu, 16 Jun 2022 13:37:11 -0700 (PDT)
Received: from [192.168.1.172] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id i26-20020a023b5a000000b0032b3a781781sm1301267jaf.69.2022.06.16.13.37.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Jun 2022 13:37:10 -0700 (PDT)
Message-ID: <a3251a5e-d3cd-0fe2-db49-c81f177d534a@kernel.dk>
Date:   Thu, 16 Jun 2022 14:37:09 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH 2/2] io_uring: kbuf: add comments for some tricky code
Content-Language: en-US
To:     Hao Xu <hao.xu@linux.dev>, io-uring@vger.kernel.org
Cc:     Pavel Begunkov <asml.silence@gmail.com>
References: <20220614120108.1134773-1-hao.xu@linux.dev>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220614120108.1134773-1-hao.xu@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/14/22 6:01 AM, Hao Xu wrote:
> From: Hao Xu <howeyxu@tencent.com>
> 
> Add comments to explain why it is always under uring lock when
> incrementing head in __io_kbuf_recycle. And rectify one comemnt about
> kbuf consuming in iowq case.

Was there a 1/2 patch in this series? This one has a subject of 2/2...

> Signed-off-by: Hao Xu <howeyxu@tencent.com>
> ---
>  io_uring/kbuf.c | 20 ++++++++++++++------
>  1 file changed, 14 insertions(+), 6 deletions(-)
> 
> diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
> index 9cdbc018fd64..37f06456bf30 100644
> --- a/io_uring/kbuf.c
> +++ b/io_uring/kbuf.c
> @@ -50,6 +50,13 @@ void __io_kbuf_recycle(struct io_kiocb *req, unsigned issue_flags)
>  	if (req->flags & REQ_F_BUFFER_RING) {
>  		if (req->buf_list) {
>  			if (req->flags & REQ_F_PARTIAL_IO) {
> +				/*
> +				 * if we reach here, uring_lock has been
> +				?* holden. Because in iowq, we already
> +				?* cleared req->buf_list to NULL when got
> +				?* the buffer from the ring, which means
> +				?* we cannot be here in that case.
> +				 */

There's a weird character before the '*' in most lines? I'd rephrase the
above as:

If we end up here, then the io_uring_lock has been kept held since we
retrieved the buffer. For the io-wq case, we already cleared
req->buf_list when the buffer was retrieved, hence it cannot be set
here for that case.

And make sure it lines up around 80 chars, your lines look very short.

> @@ -128,12 +135,13 @@ static void __user *io_ring_buffer_select(struct io_kiocb *req, size_t *len,
>  	if (issue_flags & IO_URING_F_UNLOCKED) {
>  		/*
>  		 * If we came in unlocked, we have no choice but to consume the
> -		 * buffer here. This does mean it'll be pinned until the IO
> -		 * completes. But coming in unlocked means we're in io-wq
> -		 * context, hence there should be no further retry. For the
> -		 * locked case, the caller must ensure to call the commit when
> -		 * the transfer completes (or if we get -EAGAIN and must poll
> -		 * or retry).
> +		 * buffer here otherwise nothing ensures the buffer not being
> +		 * used by others. This does mean it'll be pinned until the IO
> +		 * completes though coming in unlocked means we're in io-wq
> +		 * context and there may be further retries in async hybrid mode.
> +		 * For the locked case, the caller must ensure to call the commit
> +		 * when the transfer completes (or if we get -EAGAIN and must
> +		 * poll or retry).

and similarly:

buffer here, otherwise nothing ensures that the buffer won't get used by
others. This does mean it'll be pinned until the IO completes, coming in
unlocked means we're being called from io-wq context and there may be
further retries in async hybrid mode. For the locked case, the caller
must call commit when the transfer completes (or if we get -EAGAIN and
must poll of retry).

-- 
Jens Axboe

