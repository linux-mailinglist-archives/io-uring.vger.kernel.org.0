Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3D08303EE7
	for <lists+io-uring@lfdr.de>; Tue, 26 Jan 2021 14:40:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392134AbhAZNjl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 26 Jan 2021 08:39:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392688AbhAZNjU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 26 Jan 2021 08:39:20 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 647A3C0611BD
        for <io-uring@vger.kernel.org>; Tue, 26 Jan 2021 05:38:40 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id gx5so22956924ejb.7
        for <io-uring@vger.kernel.org>; Tue, 26 Jan 2021 05:38:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:references:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Gj5F/0a91yUz2jG08+A1Uzb4XKqJyYxQ+Lo6jAW+23U=;
        b=nc/9Cz5XO1WFdNK+w2NKnE7igsUfMQVQo68Z1yPvgTwMTmI34Sf8vuM6LwvU8kR5wL
         29dzBF+uYRrF8D3q5jwpoNxT9lOOARsrM7n+WpfdmIM4nQlRhV6aBRuE5m/e4Ud93vAD
         g8kdPcnwCsjc81Fj71HzHVHqwOVaQelARKG/i36A12Y05hJ4yvSsJYmZ0rFGljeC01va
         PnsgTGsobmVB3vq6NAJYn7ETBX35LboCbOadOokunXAc47BgDq+s2QFRuFi5D1ZbZZLK
         I2TC+4MnnKG9oD5VOIM6Q7Uo3XHP4DsHrj5RIn8Jttwx07EoLzHutitm86fSTpTkSgAa
         m1wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:references:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Gj5F/0a91yUz2jG08+A1Uzb4XKqJyYxQ+Lo6jAW+23U=;
        b=ITL+xwoh8qdk0d20gm63JNCF6ifgDAUZQmbSZBrEP5/N3xR3hrNAATatu0Fs5TKhGX
         TmcD1jJ2nfZwVpiUwzWrD7UuJLEx8NppwP1zLvAGKjXsav0ybPJZ/WEheF8pZq5uDTNy
         qKkJA63x/W3nAQ+F6GDFGdWHIa6xbFgjSDOXWDoGsOPI0byBzVdhC7cBI3O3nv0QY7i3
         34Nfrl+n0JcSPbnvZpXjR5Ue8Qv699ivrgJ/dn629P/EjEsLQl5M8weBA675IIg0eMEV
         CxiEiRXai1dEIzxVnBPTm8otbxHCWiQV8pomOP1C8ZIx6hzIquNvH+3V/lFjIFOOvzPz
         7T9w==
X-Gm-Message-State: AOAM533AmvWfPJHrjjYQa5UNLCMfMo5NVhMDTcVyYIbmekGI2GHIdX4h
        hJHlYTl5Yku6g5W2KtEcOADHO/sRsCWdlg==
X-Google-Smtp-Source: ABdhPJy2IUOjmftB4KGq5mLCdCYwfC0MElN+SQjNiLnbRrfkL1Ct7F/IWRQZPlW81nb2Rq4cnsaiXw==
X-Received: by 2002:a17:906:f246:: with SMTP id gy6mr3361372ejb.264.1611668318905;
        Tue, 26 Jan 2021 05:38:38 -0800 (PST)
Received: from [192.168.8.156] ([148.252.129.161])
        by smtp.gmail.com with ESMTPSA id o11sm12537501eds.19.2021.01.26.05.38.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Jan 2021 05:38:38 -0800 (PST)
Subject: Re: [PATCH 1/1] io_uring: cleanup files_update looping
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <36db2a597f591671257ef4c1f59b74c0b4c6bd6d.1611663156.git.asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <8bbfc340-d234-983c-db42-af1055e8da79@gmail.com>
Date:   Tue, 26 Jan 2021 13:34:58 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <36db2a597f591671257ef4c1f59b74c0b4c6bd6d.1611663156.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 26/01/2021 12:14, Pavel Begunkov wrote:
> Replace a while with a simple for loop, that looks way more natural, and
> enables us to use "contiune" as indexes are no more updated by hand in
> the end of the loop.

needs a rebase, I'll resend

> 
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  fs/io_uring.c | 8 ++------
>  1 file changed, 2 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index f77821626a92..36e4dd55e98b 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -7666,9 +7666,8 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
>  	if (!ref_node)
>  		return -ENOMEM;
>  
> -	done = 0;
>  	fds = u64_to_user_ptr(up->fds);
> -	while (nr_args) {
> +	for (done = 0; done < nr_args; done++) {
>  		struct fixed_file_table *table;
>  		unsigned index;
>  
> @@ -7677,7 +7676,7 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
>  			err = -EFAULT;
>  			break;
>  		}
> -		i = array_index_nospec(up->offset, ctx->nr_user_files);
> +		i = array_index_nospec(up->offset + done, ctx->nr_user_files);
>  		table = &ctx->file_data->table[i >> IORING_FILE_TABLE_SHIFT];
>  		index = i & IORING_FILE_TABLE_MASK;
>  		if (table->files[index]) {
> @@ -7715,9 +7714,6 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
>  				break;
>  			}
>  		}
> -		nr_args--;
> -		done++;
> -		up->offset++;
>  	}
>  
>  	if (needs_switch) {
> 

-- 
Pavel Begunkov
