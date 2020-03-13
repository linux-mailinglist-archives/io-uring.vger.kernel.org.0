Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46B3E18504E
	for <lists+io-uring@lfdr.de>; Fri, 13 Mar 2020 21:29:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726480AbgCMU3W (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 13 Mar 2020 16:29:22 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:45927 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726620AbgCMU3V (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 13 Mar 2020 16:29:21 -0400
Received: by mail-wr1-f67.google.com with SMTP id t2so3678865wrx.12;
        Fri, 13 Mar 2020 13:29:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:references:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=490+CG9QfTRf0k+IoKMcNqFIwfT4CQ6yVuzCCGzoGaI=;
        b=M8+jbamQYND25WIBqurvq0w/FMrI1ErVjXZEnmjaDtv57JQ8lctz1slql1yLcYICqx
         LbxY2Xvv8SA/IrApaG6qW3an9O57L0cfypuzwkEHtVSt5bCc00pcoNRW48y3o6g+X41o
         9YOWAsyaZT5Ba8wsYP/BNs0alamNbym0ivaQ2W+WEpaOEfw0nYCpg/hM6b7u9i4ggna/
         OjMuNJkuHXqEMbVWuZrE2pDvT2+kX3/Oh4mjFcIGG7qOXzPh5g9DX2pYi2K632eVdFnQ
         NuTgGbmpMJjC83WOuaPHTdVPfniS12byCKNplbwgRSKNAUaQXcv8R1uuiSeUzwiPa/fO
         raog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:references:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=490+CG9QfTRf0k+IoKMcNqFIwfT4CQ6yVuzCCGzoGaI=;
        b=nNBeMWr3OdTMfkQqlJDkoDJwVXwMtoWwfJtF2mssRYFZ6OsaNkgC9wK1ehhWhpKojG
         nD6sX3YC3LUVRgu+ev/8tUoxs7HnbRp/ZnmoLGbQ+4R3S3Ck9YBNeupf+yj+wNR26rqG
         UQ5Yu8TVu5O4vn78GRBElLLPuRlOe2Sa85/1LtL6COOlTBOny2ahYlrWFA7GyugcIryF
         O72RGoLsmBm1diDbmLXdDeW0E7k1Vu48iLS2sRQ/4Vr3EDRW/Zs+Tym2LbV9rSWX/+qG
         cvL9Qe6iRn8lzOIbwAJ8dwld0m9VQ/zizOnj2UzEL3/ZZ14CdIKl0oOEMaoAgkzcyq+E
         m0KA==
X-Gm-Message-State: ANhLgQ1pbmpjnX90PdRTEPXkforOfXxhhCDsr8SjUeWvMjAJiUYxvSwd
        XdAdTbVLt9wG4sMaqrO4I6jBXMbb
X-Google-Smtp-Source: ADFU+vsppbGBa5i5BOIYwlTf/MMa9JUDV/0zt1h17+9u5sSWfiJUBKBPOrO+xQd4XnOLhA5v3ZdOeA==
X-Received: by 2002:a5d:46cc:: with SMTP id g12mr19344608wrs.42.1584131356899;
        Fri, 13 Mar 2020 13:29:16 -0700 (PDT)
Received: from [192.168.43.52] ([109.126.140.227])
        by smtp.gmail.com with ESMTPSA id b6sm24433704wrv.43.2020.03.13.13.29.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Mar 2020 13:29:16 -0700 (PDT)
Subject: Re: [PATCH 5.6] io_uring: NULL-deref for IOSQE_{ASYNC,DRAIN}
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <3fff749b19ae1c3c2d59e88462a8a5bfc9e6689f.1584127615.git.asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <bc3baf1c-0629-3989-c7c1-bc7c84ac8ae5@gmail.com>
Date:   Fri, 13 Mar 2020 23:28:24 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <3fff749b19ae1c3c2d59e88462a8a5bfc9e6689f.1584127615.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 13/03/2020 22:29, Pavel Begunkov wrote:
> Processing links, io_submit_sqe() prepares requests, drops sqes, and
> passes them with sqe=NULL to io_queue_sqe(). There IOSQE_DRAIN and/or
> IOSQE_ASYNC requests will go through the same prep, which doesn't expect
> sqe=NULL and fail with NULL pointer deference.
> 
> Always do full prepare including io_alloc_async_ctx() for linked
> requests, and then it can skip the second preparation.

Hmm, found unreliably failing the across-fork test. I don't know whether it's
this patch specific, but need to take a look there first.

> 
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  fs/io_uring.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 55afae6f0cf4..9d43efbec960 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -4813,6 +4813,9 @@ static int io_req_defer_prep(struct io_kiocb *req,
>  {
>  	ssize_t ret = 0;
>  
> +	if (!sqe)
> +		return 0;
> +
>  	if (io_op_defs[req->opcode].file_table) {
>  		ret = io_grab_files(req);
>  		if (unlikely(ret))
> @@ -5655,6 +5658,11 @@ static bool io_submit_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
>  		if (sqe_flags & (IOSQE_IO_LINK|IOSQE_IO_HARDLINK)) {
>  			req->flags |= REQ_F_LINK;
>  			INIT_LIST_HEAD(&req->link_list);
> +
> +			if (io_alloc_async_ctx(req)) {
> +				ret = -EAGAIN;
> +				goto err_req;
> +			}
>  			ret = io_req_defer_prep(req, sqe);
>  			if (ret)
>  				req->flags |= REQ_F_FAIL_LINK;
> 

-- 
Pavel Begunkov
