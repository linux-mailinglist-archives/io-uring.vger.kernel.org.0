Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6B7B428CD4
	for <lists+io-uring@lfdr.de>; Mon, 11 Oct 2021 14:13:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234996AbhJKMPn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 11 Oct 2021 08:15:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234961AbhJKMPn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 11 Oct 2021 08:15:43 -0400
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 428FFC061570
        for <io-uring@vger.kernel.org>; Mon, 11 Oct 2021 05:13:43 -0700 (PDT)
Received: by mail-io1-xd35.google.com with SMTP id 5so19501448iov.9
        for <io-uring@vger.kernel.org>; Mon, 11 Oct 2021 05:13:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=mahOp0Xn0raHeMyfqK1rwbBvcejtYBgn3PR/WYl8dtA=;
        b=iy75AgcN5s0+72mSzXfuxcnLTlvg/bnUa3hpB4cOgt2Bpae9REcIqI++Hv7yduhewV
         eqY1jfunVeKEJngYceKzeYjl//04TRulABsvjZXWV/pGFO7FoTHr+3t/dEyw02ZqrjdY
         CgpqMEmPcwhud7qksmjuYuZvz4iOyyPBt9mueEmMWwcP3N1Y+LRKccb6meWB5eEmd5c4
         W2Gc56Hepdczo0JFD0ttSzQLwcV/xDL7f445TcR2fEejMKPIB1kqudIVuAJGUg/t84Sk
         7kcD5JnnqpMUq6PSFdZTX58hDV9e/HQwnd+XqKzaW+G3GGzARqz6OEEJMrO4BLiQjHQh
         X+7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mahOp0Xn0raHeMyfqK1rwbBvcejtYBgn3PR/WYl8dtA=;
        b=vkQEaEPao5/gG7dQqGVDxP+7j7HjNKECD3oEuxCcyIzFiQG9LX6C9V90gJTgARMCta
         2jUXDiC1FZD7/A8YTINDTdrS7TaOOhvG3LaSv19Mtd3Ii1aYXXH2yutcnW8VYt+3Q/Ss
         knwsYlASC468M6bWD6pXXqjsZ3PWCIYx7YP074GEd1A5CB5wuR4Tq/npPrenECIEyPe0
         kS/rwDuOhcmqgkftA/19cuFnvU9z0poLDB2oUlHt32N8RgOIuIjl7oFXt6bsPhqCXGyE
         Mo93UegqYnvj+vpT10Ua65VtZ8jey+6fzUcDF/w0ywLyB6Het91vtbcD04/4HTLYsRve
         LWrw==
X-Gm-Message-State: AOAM532dXpipZULXPFjn66JC6wHUYyN8lMz3/V6HhKKTU+JKQrMtZTLj
        w+mn4bjNMNwzIQFhaTfS1oLUlQ==
X-Google-Smtp-Source: ABdhPJziw176FwiRTsbstFFuQQwU4t+/mcuXQkCfmysdmWyz/+A43w3FrUuug0ljO5JPtTd0pNcHWQ==
X-Received: by 2002:a05:6602:29c6:: with SMTP id z6mr14375072ioq.215.1633954422598;
        Mon, 11 Oct 2021 05:13:42 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id k14sm3986103ils.7.2021.10.11.05.13.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Oct 2021 05:13:42 -0700 (PDT)
Subject: Re: [PATCH liburing] src/nolibc: Fix `malloc()` alignment
To:     Ammar Faizi <ammar.faizi@students.amikom.ac.id>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>
Cc:     Bedirhan KURT <windowz414@gnuweeb.org>,
        Louvian Lyndal <louvianlyndal@gmail.com>
References: <20211011064927.444704-1-ammar.faizi@students.amikom.ac.id>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <ae6aa009-765a-82b0-022c-d6696c6d3ee2@kernel.dk>
Date:   Mon, 11 Oct 2021 06:13:40 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20211011064927.444704-1-ammar.faizi@students.amikom.ac.id>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/11/21 12:49 AM, Ammar Faizi wrote:
> Add `__attribute__((__aligned__))` to the `user_p` to guarantee
> pointer returned by the `malloc()` is properly aligned for user.
> 
> This attribute asks the compiler to align a type to the maximum
> useful alignment for the target machine we are compiling for,
> which is often, but by no means always, 8 or 16 bytes [1].
> 
> Link: https://gcc.gnu.org/onlinedocs/gcc-11.2.0/gcc/Common-Variable-Attributes.html#Common-Variable-Attributes [1]
> Fixes: https://github.com/axboe/liburing/issues/454
> Reported-by: Louvian Lyndal <louvianlyndal@gmail.com>
> Signed-off-by: Ammar Faizi <ammar.faizi@students.amikom.ac.id>
> ---
>  src/nolibc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/src/nolibc.c b/src/nolibc.c
> index 5582ca0..251780b 100644
> --- a/src/nolibc.c
> +++ b/src/nolibc.c
> @@ -20,7 +20,7 @@ void *memset(void *s, int c, size_t n)
>  
>  struct uring_heap {
>  	size_t		len;
> -	char		user_p[];
> +	char		user_p[] __attribute__((__aligned__));
>  };

This seems to over-align for me, at 16 bytes where 8 bytes would be fine.
What guarantees does malloc() give?

-- 
Jens Axboe

