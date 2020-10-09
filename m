Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 906A2288977
	for <lists+io-uring@lfdr.de>; Fri,  9 Oct 2020 15:00:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732494AbgJINAB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 9 Oct 2020 09:00:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732456AbgJINAB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 9 Oct 2020 09:00:01 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAD77C0613D2;
        Fri,  9 Oct 2020 06:00:00 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id e18so10187354wrw.9;
        Fri, 09 Oct 2020 06:00:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=3jW1cNleT9waqdKWVbFqqQfgrom0uFAHbjs1stVg2ig=;
        b=KJegSrueJP2ZPV29u51f7Ku+PTyQGJaCwV3K4Gt0TOTiYAl98hKJR4jRSxQ2uHxa6K
         VKbfZOuSnJmaGN7G9BC5Ut9TSG6LCNLtkqA4R8jZccBXCHtZDg+a4aSEKA8XtI8XO5WJ
         SWMxMSBK7QpdJ+6RAPsJSd2nju2pW6SuJhvp872AEcWNdxz8URlwbGtb0/RolShm8P3G
         4oc9PxJTgrtwhgX2E9hG6fGzpvfLrSXlH2rweWflZZXm5h/ONCsmGMe45/dXBIn2nxvQ
         2t6krCa9lglxg9MecuKpANTEDxeDeub6oYgzSx40HQd/J2E068xQNcHicD7CzZ4asafR
         t22w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=3jW1cNleT9waqdKWVbFqqQfgrom0uFAHbjs1stVg2ig=;
        b=uL4rSaSeoUbknOwqUnLsM5nPYYy/y8fwrzEtbNsvaPXmQ8j/dITeMx9GsEUcJ1fGZX
         Y/KaN4lg2DGHu3HOUNStrTqt0pV0hv5IGtRyYYP9epn/AabYWmUaF+Zb4DfWevPrTMMA
         Ti2Nw2t0UIzYbpB7bfWe2u+Gar3aOAoPJKfTLQU4IvxQKbwbXnkX3xNfLqZ0SxqLgzs8
         MA0qeJc/hkDYfj7WoO4pZyGMD4pqMDR+r0LwID3geheVjna6ehPYnJbWpcjRQD2UwJIJ
         E5IRTeXcjDi9Zl89aTBww6qeNY7mKID9o6sN3peblvU6HCq978pfrkb3hl2mrxBFBJoy
         cPeQ==
X-Gm-Message-State: AOAM531D/BDz3ng9i5JcICrHvJqTvJuozrwJpq1qXHakdSOLPxIyMRRA
        5iXD/v1f22xMSbXkckyP1nMC9D/NZGU=
X-Google-Smtp-Source: ABdhPJxhsdfX+miE/FioupatDCtZfqF0kP9rF54wHR7qoxY9xZ/It/w8OB8M6qVe3lLw/MO2tjM1lw==
X-Received: by 2002:adf:ee07:: with SMTP id y7mr15973046wrn.229.1602248399387;
        Fri, 09 Oct 2020 05:59:59 -0700 (PDT)
Received: from [192.168.1.82] (host109-152-100-164.range109-152.btcentralplus.com. [109.152.100.164])
        by smtp.gmail.com with ESMTPSA id a3sm2251068wrh.94.2020.10.09.05.59.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Oct 2020 05:59:58 -0700 (PDT)
Subject: Re: [PATCH 1/3] io_uring: Fix use of XArray in
 __io_uring_files_cancel
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Jens Axboe <axboe@kernel.dk>
Cc:     linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20201009124954.31830-1-willy@infradead.org>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <7dd0bd6a-e9e6-e4b8-4343-99681d283306@gmail.com>
Date:   Fri, 9 Oct 2020 15:57:17 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20201009124954.31830-1-willy@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 09/10/2020 15:49, Matthew Wilcox (Oracle) wrote:
> We have to drop the lock during each iteration, so there's no advantage
> to using the advanced API.  Convert this to a standard xa_for_each() loop.

LGTM, but would be better to add

Reported-by: syzbot+27c12725d8ff0bfe1a13@syzkaller.appspotmail.com

> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---
>  fs/io_uring.c | 19 +++++--------------
>  1 file changed, 5 insertions(+), 14 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 299c530c66f9..2978cc78538a 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -8665,28 +8665,19 @@ static void io_uring_attempt_task_drop(struct file *file, bool exiting)
>  void __io_uring_files_cancel(struct files_struct *files)
>  {
>  	struct io_uring_task *tctx = current->io_uring;
> -	XA_STATE(xas, &tctx->xa, 0);
> +	struct file *file;
> +	unsigned long index;
>  
>  	/* make sure overflow events are dropped */
>  	tctx->in_idle = true;
>  
> -	do {
> -		struct io_ring_ctx *ctx;
> -		struct file *file;
> -
> -		xas_lock(&xas);
> -		file = xas_next_entry(&xas, ULONG_MAX);
> -		xas_unlock(&xas);
> -
> -		if (!file)
> -			break;
> -
> -		ctx = file->private_data;
> +	xa_for_each(&tctx->xa, index, file) {
> +		struct io_ring_ctx *ctx = file->private_data;
>  
>  		io_uring_cancel_task_requests(ctx, files);
>  		if (files)
>  			io_uring_del_task_file(file);
> -	} while (1);
> +	}
>  }
>  
>  static inline bool io_uring_task_idle(struct io_uring_task *tctx)
> 

-- 
Pavel Begunkov
