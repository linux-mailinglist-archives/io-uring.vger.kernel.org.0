Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 888433C34BD
	for <lists+io-uring@lfdr.de>; Sat, 10 Jul 2021 15:40:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231406AbhGJNnE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 10 Jul 2021 09:43:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231312AbhGJNnE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 10 Jul 2021 09:43:04 -0400
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15049C0613DD
        for <io-uring@vger.kernel.org>; Sat, 10 Jul 2021 06:40:18 -0700 (PDT)
Received: by mail-io1-xd30.google.com with SMTP id z26so4585756ioz.11
        for <io-uring@vger.kernel.org>; Sat, 10 Jul 2021 06:40:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:subject:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=bRMWYaXsY3niJ2bqHI7qX2CagL7GLhQFGPtO3/uDOOo=;
        b=UoLnxvSvBZOmyBXpBIE6lL+BkpzPudQRVXsTPT9mN16+xdB99jaEIAehLJz+OIm4ab
         Diw9FqhSzY36M01ujGXzAW3BdBOXV85PtET+YD7nZAZCLiSGqlmZue6xfF/oSUiR25yc
         zFglqDZV3lDnQS42KRg9AGtxvysb7mElPFWUFRh3PCzwn4XHPHm1yNw79w3zMV7ZUQRV
         TPuGMqCXKTTbx46ucaiNtCPerzG8u1r3K+oiPXUMQJHGK/0toQ5NIEryIyq8xyyLro4H
         X6rgholNyHjZNdOfi8jzQVmYRTsMZ+NW5fzir+d1C7VehKFmmZkd3lyRGps6HFmhhHfW
         DNkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bRMWYaXsY3niJ2bqHI7qX2CagL7GLhQFGPtO3/uDOOo=;
        b=CFt512pwFfae9folUlrImifM96ovWQfPQYFa/ofuXg+lksUyiACtbk1QX0W20DIOzU
         HM0z0WnPlkOn+StuESiKh0dwyl/vGc0QTKnPUmirHqNEI/PWoS9aFEgsTeIGHvMEbhN7
         5smn7NMf7DTJ5JPyrEh+StNg9fHwpTYkzqiMTc8wkQ+WdSls8azYURo3uAUAb2G4jops
         DrrT/fGCor7bsX1kbRu2l0/vjkmptdQZDzCooIvPguMcqFLTFjEwgxw7IhqzaI66qKZP
         +f2VDP6205bggrbQ1fyi33by8DDjIilXqCeQHoppG8neNVj0277lZNlp88bCc9HdzZjP
         7O8A==
X-Gm-Message-State: AOAM533E+mWu/IquwvZz3SWdSZv74qIh4iU4VX/U8lTL7nJ7EFFGoTeF
        T1ZBYYuhEZmfDlRhSIKwFXpq1g==
X-Google-Smtp-Source: ABdhPJxMXCoRPWFY356K2gK5DMrg1YxMKN+h+eKIiYmYf2v/MqQoysIGvxNbp1UUyWJ2lZ+18TP2dg==
X-Received: by 2002:a5e:9309:: with SMTP id k9mr17856908iom.207.1625924417327;
        Sat, 10 Jul 2021 06:40:17 -0700 (PDT)
Received: from [192.168.1.134] ([198.8.77.61])
        by smtp.gmail.com with ESMTPSA id q6sm4682097ilt.41.2021.07.10.06.40.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 10 Jul 2021 06:40:16 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 5.14] io_uring: use right task for exiting checks
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring <io-uring@vger.kernel.org>,
        "Pavel Begunkov (Silence)" <asml.silence@gmail.com>
References: <cb413c715bed0bc9c98b169059ea9c8a2c770715.1625881431.git.asml.silence@gmail.com>
Message-ID: <7b465849-f046-530f-42a2-8e42d54bdca7@kernel.dk>
Date:   Sat, 10 Jul 2021 07:40:19 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <cb413c715bed0bc9c98b169059ea9c8a2c770715.1625881431.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Jul 9, 2021 at 7:46 PM Pavel Begunkov <asml.silence@gmail.com> wrote:
>
> When we use delayed_work for fallback execution of requests, current
> will be not of the submitter task, and so checks in io_req_task_submit()
> may not behave as expected. Currently, it leaves inline completions not
> flushed, so making io_ring_exit_work() to hang. Use the submitter task
> for all those checks.
>
> Cc: stable@vger.kernel.org
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  fs/io_uring.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 7167c61c6d1b..770fdcd7d3e4 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -2016,7 +2016,7 @@ static void io_req_task_submit(struct io_kiocb *req)
>
>         /* ctx stays valid until unlock, even if we drop all ours ctx->refs */
>         mutex_lock(&ctx->uring_lock);
> -       if (!(current->flags & PF_EXITING) && !current->in_execve)
> +       if (!(req->task->flags & PF_EXITING) && !req->task->in_execve)
>                 __io_queue_sqe(req);
>         else
>                 io_req_complete_failed(req, -EFAULT);

I don't think that ->in_execve check is useful anymore now that we don't
have weak references to the files table, so it should probably just go
away.

-- 
Jens Axboe

