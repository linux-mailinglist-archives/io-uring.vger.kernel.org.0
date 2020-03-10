Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA199180179
	for <lists+io-uring@lfdr.de>; Tue, 10 Mar 2020 16:19:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727650AbgCJPT1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 10 Mar 2020 11:19:27 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:43482 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727481AbgCJPT1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 10 Mar 2020 11:19:27 -0400
Received: by mail-io1-f68.google.com with SMTP id n21so13107531ioo.10
        for <io-uring@vger.kernel.org>; Tue, 10 Mar 2020 08:19:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=zd1eNsrUxitWDnNkIFUAnhaBJN119i/qn7PBT08jS6E=;
        b=Hcct9gm6JtLJSrSNNK4QEP3S2+FgxG02jQ2fDkUqqcPoCLnUADI8JKqnP5c058791+
         AjyyT//YeTxag/+GoQ2CYz8OHZfNosBQmg/hArpN+n3gaZT3FGpA9KvSi57yT6yhPUkA
         oXu8HWADp3RMS3mIHPpbpFJfSUhRk3k2O6pW7GczH3cfJ8mpiICUbqUYSxGHRixZBkFQ
         MrEEo7ELiIfhRKs2yGJnf6Fg4ffwm0yX0eQ0i19uODl0bxMJMJHS3eLFmBWdY0A2hODz
         beLjCvqyWCU8N3OXzLRThTeLjpDMSr1CGT8ykF0S0kV3tW35Ac7yMyhHKdqtTEF4TUq6
         fZeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zd1eNsrUxitWDnNkIFUAnhaBJN119i/qn7PBT08jS6E=;
        b=N+nt7n4T87eBR7LfaqkgAxZhjcCs68Mg6hj7UzEA/82YVhvYdBMdW39eE7lvYB44Yv
         a6gQZAiPc0BFdH4Vqd7rLJzU0klYhRN/hd//GLVG3S1NiP9hZglyWZZa2m7APhg4/rcn
         Zf+kALtM3hFwCaOcgLXvIbwOpHM0zGj88JxRO1rt3X0CHAuAjTotlfyceqOiefMKlEpZ
         hnyQ6jql/dMTBArqBz9apHyeryf4YTK3WAczCK6DZjef4Ak/vOBzYJ+KreEsK4UT+jRR
         d/jOu0GH1D2lVjlUK7N+MiTW8qn2fQ/Wf2TZEm5ny/S7RiDKk7BaplDJeu3l5WAEjJMF
         zM1w==
X-Gm-Message-State: ANhLgQ38QRj/MmNQhJoTAxeDk6+JmrgfeSKjuDnyCN9XaThVUti9bfb7
        e2s9z3El3Jv3E32lLUXCiR3Mrd3hOFd+FA==
X-Google-Smtp-Source: ADFU+vtLgTKFnj96dd5jk7y6aGEgVRO9eW2IfTMNGimHH6dTEzJbgzF9KYa3Q5lD4MnGqq6lFSe/yQ==
X-Received: by 2002:a02:cc15:: with SMTP id n21mr11170739jap.108.1583853566925;
        Tue, 10 Mar 2020 08:19:26 -0700 (PDT)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id o12sm11107047ild.69.2020.03.10.08.19.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Mar 2020 08:19:26 -0700 (PDT)
Subject: Re: [PATCH 2/9] io_uring: add IORING_OP_PROVIDE_BUFFERS
To:     io-uring@vger.kernel.org
Cc:     andres@anarazel.de
References: <20200310150427.28489-1-axboe@kernel.dk>
 <20200310150427.28489-3-axboe@kernel.dk>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <fa1ed659-3b82-0030-1e03-5cdecbe13838@kernel.dk>
Date:   Tue, 10 Mar 2020 09:19:25 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200310150427.28489-3-axboe@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/10/20 9:04 AM, Jens Axboe wrote:
> +static int io_provide_buffers(struct io_kiocb *req, bool force_nonblock)
> +{
> +	struct io_provide_buf *p = &req->pbuf;
> +	struct io_ring_ctx *ctx = req->ctx;
> +	struct io_buffer *head, *list;
> +	int ret = 0;
> +
> +	/*
> +	 * "Normal" inline submissions always hold the uring_lock, since we
> +	 * grab it from the system call. Same is true for the SQPOLL offload.
> +	 * The only exception is when we've detached the request and issue it
> +	 * from an async worker thread, grab the lock for that case.
> +	 */
> +	if (!force_nonblock)
> +		mutex_lock(&ctx->uring_lock);

I mistakenly introduced io_ring_submit_lock() in patch 3 instead of this
one, I've corrected this mistake in the git branch.

-- 
Jens Axboe

