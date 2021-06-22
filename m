Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75BD13B032C
	for <lists+io-uring@lfdr.de>; Tue, 22 Jun 2021 13:48:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230136AbhFVLud (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 22 Jun 2021 07:50:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230062AbhFVLuc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 22 Jun 2021 07:50:32 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1CD6C061574;
        Tue, 22 Jun 2021 04:48:15 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id gn32so6654139ejc.2;
        Tue, 22 Jun 2021 04:48:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=eCl6aAEwGln+JJgUnXZVygZY5TJOZNN8ju0U5DXKXH8=;
        b=B66QrLHkAvNUV8t0YoonDHwAeN5Mk3OCZlOKYEv+dtcZJHugERB6UE0zThxpZ1mXIP
         ZwxYLAlT/PMx8uzk1uGkXm0NzqVGIf2ASIdrhJPKZDCLLF91uddbcamFrEcBCP+DH5PD
         uT5c1vqn+7VBomiJGsbn6JxM8VAzlPPuqnwd7TYYupoLiN8W0XUuXrFIDqA4TbyTgubn
         lp0byiQZRHRG9AYyI6BVy07HBjsYKnMCPfsWsiFPxLRCDEfXAKaQt9p2LHscO1itf1Qj
         OK9Q5XoNYoZgflqxvYPYQnlKUxGAf6j2mRK+Nz4SsanpyddxybhV3JynUTGF9DOhraug
         2OZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=eCl6aAEwGln+JJgUnXZVygZY5TJOZNN8ju0U5DXKXH8=;
        b=C+4p3YkRd8JeXIEIhmIfPO1Tnjz5VUKvzUELI7KoRzEf38KRwNiGPzNIu9iShg6VXj
         qlLJhjVoCoC5OazU78aHwMRca97rq0TyFJN478K0JBd6JRZZACPUxqiZbjCwB+LY6DEt
         Z8oZKRbgmyMZ1HwWu3z/IWyLIka91A26mT8oVvfQbaaGpx+RloTbb+OE3YWKdBZFOViz
         +A0DMDDtOVKuNBA5oTyYpGmP5wj3Y6JAXHRxuowLuBqVh5yUV5JwyVbsXz5uMmMEjnUc
         uvbPTaVWcSuPmssw4DLu64ibePmAt6tRlRePb5YH6QOwvOd+5g/3xWguJJSNucLUTKUd
         PqJA==
X-Gm-Message-State: AOAM530vbG/Aa6xDqPwcujfkvX87k5PHJ4x5A3TEGzYegDOmjKPkEWSx
        OemNx/7nrjbP4TEfUhv+rk1vNMkvYJmXockB
X-Google-Smtp-Source: ABdhPJx8XZHdXnJMZ9lbCb649wTKCsjDLvw/sa+3n5o12W9HkHKtFsM76apE7RMQHO79+N5xPocjPA==
X-Received: by 2002:a17:906:c211:: with SMTP id d17mr3539398ejz.247.1624362494269;
        Tue, 22 Jun 2021 04:48:14 -0700 (PDT)
Received: from ?IPv6:2620:10d:c096:310::2410? ([2620:10d:c092:600::2:e69])
        by smtp.gmail.com with ESMTPSA id ck2sm3306376edb.72.2021.06.22.04.48.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Jun 2021 04:48:13 -0700 (PDT)
Subject: Re: [PATCH v5 09/10] io_uring: add support for IORING_OP_LINKAT
To:     Dmitry Kadashev <dkadashev@gmail.com>,
        Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <christian.brauner@ubuntu.com>
Cc:     linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org
References: <20210603051836.2614535-1-dkadashev@gmail.com>
 <20210603051836.2614535-10-dkadashev@gmail.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <77b4b24f-b905-ed36-b70e-657f08de7fd1@gmail.com>
Date:   Tue, 22 Jun 2021 12:48:00 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210603051836.2614535-10-dkadashev@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/3/21 6:18 AM, Dmitry Kadashev wrote:
> IORING_OP_LINKAT behaves like linkat(2) and takes the same flags and
> arguments.
> 
> In some internal places 'hardlink' is used instead of 'link' to avoid
> confusion with the SQE links. Name 'link' conflicts with the existing
> 'link' member of io_kiocb.
> 
> Suggested-by: Christian Brauner <christian.brauner@ubuntu.com>
> Link: https://lore.kernel.org/io-uring/20210514145259.wtl4xcsp52woi6ab@wittgenstein/
> Signed-off-by: Dmitry Kadashev <dkadashev@gmail.com>
> ---
>  fs/internal.h                 |  2 ++
>  fs/io_uring.c                 | 67 +++++++++++++++++++++++++++++++++++
>  fs/namei.c                    |  2 +-
>  include/uapi/linux/io_uring.h |  2 ++
>  4 files changed, 72 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/internal.h b/fs/internal.h
> index 3b3954214385..15a7d210cc67 100644
> --- a/fs/internal.h
> +++ b/fs/internal.h

[...]
> +
> +static int io_linkat(struct io_kiocb *req, int issue_flags)
> +{
> +	struct io_hardlink *lnk = &req->hardlink;
> +	int ret;
> +
> +	if (issue_flags & IO_URING_F_NONBLOCK)
> +		return -EAGAIN;
> +
> +	ret = do_linkat(lnk->old_dfd, lnk->oldpath, lnk->new_dfd,
> +				lnk->newpath, lnk->flags);

I'm curious, what's difference b/w SYMLINK and just LINK that
one doesn't use old_dfd and another does? Can it be
supported/wished by someone in the future? In that case I'd rather
reserve and verify a field for old_dfd for both, even if one
won't really support it for now.

> +
> +	req->flags &= ~REQ_F_NEED_CLEANUP;
> +	if (ret < 0)
> +		req_set_fail(req);
> +	io_req_complete(req, ret);
> +	return 0;
> +}
> +

-- 
Pavel Begunkov
