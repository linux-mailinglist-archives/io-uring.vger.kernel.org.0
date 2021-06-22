Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EFD13B0351
	for <lists+io-uring@lfdr.de>; Tue, 22 Jun 2021 13:52:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230136AbhFVLzC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 22 Jun 2021 07:55:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229912AbhFVLzB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 22 Jun 2021 07:55:01 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20D90C061574;
        Tue, 22 Jun 2021 04:52:46 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id gt18so34048980ejc.11;
        Tue, 22 Jun 2021 04:52:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=6OZa1byb9iZvn3cj/IkiXzxAJUgvAqP9J54khDjMBTw=;
        b=cPuw8O9RikzEVjj6EHsqFy9M80R4sPY4ALRf5JX0RtHyBqdytdv9KdVEvh6MEDnMtJ
         UJogQ4iFKgehHyxjclvnvp9qP2lsTSIp6OXVqE8Obw8v5NNNRVcgHcZHBLysoJTCUWiA
         8qJq/qjN4TE17idrXc/Cyg85og8Dk7W0lzH82ecAEJu0xKILEuNQlPi38Poj7Wi1qmGT
         Zbc3pnVI7aK1ivV2gNhueLeVy0sR4a56JTI4j2M3WA30pmgQl9vNgshQiF3qcuO5D8ym
         KMfchth9bAQ/oA+TLsPprR5vtyeCpBL0M2k97oqx1KpB/TMNWvTjmY+u3m5yZNOMOuSJ
         zCcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6OZa1byb9iZvn3cj/IkiXzxAJUgvAqP9J54khDjMBTw=;
        b=oQACGFxpsgJRojRdsnhhVH/iuHpPXwDZ4Wf50SzOesguiXzyZp1iKgBT388GCP2fu/
         Y6YRxIiHl8HbkS/pZYuUZJiDhDmDVCHoyPNxKw8NtN7o4e0Ueme1JX88icUejJxxkNTe
         6IDEQN1XSAjTNM/OfU+2VVB8dz871PQYGsZ6bUICEGxgdelqGZZ4oz/X9qN9aVzbjpFb
         RN40pRBppuFLsr36gah6y7Rz91W6/APkBNTPrDIVHWQhD378b0cE6K9zBRhepRS4+x8R
         bunU41UyC0I3Xv+ZeU2e5HfdCb6inOhL7VskJvm2L8/dTKpa0pulrPXs0ppaNVIzF+Ir
         ji6g==
X-Gm-Message-State: AOAM5339ih/Ph8MLU08ru9E8KLEMQnYcpEfNN6GCMUIruLsDI+bbn0ON
        +X8TbsgNCTE/AJRYFl0mmE9bPujYUlq28p/A
X-Google-Smtp-Source: ABdhPJxZlfOPZBndhubqsE3msDFniiIYA7kC8lEExzCPz2eQDs5TyWPdI9YEAbgtD4lRRTSkDHx/bA==
X-Received: by 2002:a17:907:3f06:: with SMTP id hq6mr3427659ejc.130.1624362764538;
        Tue, 22 Jun 2021 04:52:44 -0700 (PDT)
Received: from ?IPv6:2620:10d:c096:310::2410? ([2620:10d:c093:600::2:c503])
        by smtp.gmail.com with ESMTPSA id ar27sm4413901ejc.48.2021.06.22.04.52.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Jun 2021 04:52:44 -0700 (PDT)
Subject: Re: [PATCH v5 10/10] io_uring: add support for IORING_OP_MKNODAT
To:     Dmitry Kadashev <dkadashev@gmail.com>,
        Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <christian.brauner@ubuntu.com>
Cc:     linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org
References: <20210603051836.2614535-1-dkadashev@gmail.com>
 <20210603051836.2614535-11-dkadashev@gmail.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <1a3812fe-1e57-a2ad-dc19-9658c0cf613b@gmail.com>
Date:   Tue, 22 Jun 2021 12:52:29 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210603051836.2614535-11-dkadashev@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/3/21 6:18 AM, Dmitry Kadashev wrote:
> IORING_OP_MKNODAT behaves like mknodat(2) and takes the same flags and
> arguments.
> 
> Suggested-by: Christian Brauner <christian.brauner@ubuntu.com>
> Link: https://lore.kernel.org/io-uring/20210514145259.wtl4xcsp52woi6ab@wittgenstein/
> Signed-off-by: Dmitry Kadashev <dkadashev@gmail.com>
> ---
>  fs/internal.h                 |  2 ++
>  fs/io_uring.c                 | 56 +++++++++++++++++++++++++++++++++++
>  fs/namei.c                    |  2 +-
>  include/uapi/linux/io_uring.h |  2 ++
>  4 files changed, 61 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/internal.h b/fs/internal.h
> index 15a7d210cc67..c6fb9974006f 100644

[...]

>  static bool io_disarm_next(struct io_kiocb *req);
> @@ -3687,6 +3697,44 @@ static int io_linkat(struct io_kiocb *req, int issue_flags)
>  	io_req_complete(req, ret);
>  	return 0;
>  }
> +static int io_mknodat_prep(struct io_kiocb *req,
> +			    const struct io_uring_sqe *sqe)
> +{
> +	struct io_mknod *mkn = &req->mknod;
> +	const char __user *fname;
> +
> +	if (unlikely(req->flags & REQ_F_FIXED_FILE))
> +		return -EBADF;

IOPOLL won't support it, and the check is missing.
Probably for other opcodes as well.

if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
	return -EINVAL;

> +
> +	mkn->dfd = READ_ONCE(sqe->fd);
> +	mkn->mode = READ_ONCE(sqe->len);
> +	fname = u64_to_user_ptr(READ_ONCE(sqe->addr));
> +	mkn->dev = READ_ONCE(sqe->mknod_dev);
> +
> +	mkn->filename = getname(fname);
> +	if (IS_ERR(mkn->filename))
> +		return PTR_ERR(mkn->filename);
> +
> +	req->flags |= REQ_F_NEED_CLEANUP;
> +	return 0;
> +}

-- 
Pavel Begunkov
