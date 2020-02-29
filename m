Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D0F91746C5
	for <lists+io-uring@lfdr.de>; Sat, 29 Feb 2020 13:21:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726980AbgB2MVu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 29 Feb 2020 07:21:50 -0500
Received: from mail-lf1-f66.google.com ([209.85.167.66]:37372 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726975AbgB2MVt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 29 Feb 2020 07:21:49 -0500
Received: by mail-lf1-f66.google.com with SMTP id j11so722177lfg.4
        for <io-uring@vger.kernel.org>; Sat, 29 Feb 2020 04:21:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=nicjlVDTn1RLjF5YNP4lJKlt1OSyZqzHGmBmYoJbz9M=;
        b=UteAvbI5W3HLWgpOhsWM8dumC7iExPWvudaUWjZZ1tBv0DntJ46A+ehplyLjeq/EQ9
         CXrYv4cJvdyPFaAAzUhMI/K71hkLTwnag7k8JLHWhRRqvWErnObY95FOe+cdCUdoFFfa
         fnkbJEc2oNaQN6Un5gRgJPI/5ezT/ZpAibdI6lEHP2y0Ygnzbp41WshM1zVHjXOpzEDR
         DXmt94CMY6m7XwSUjA4F1clwA3C9t1xswXrXUrMGq5amjEYVmJOGHXfSpHVtT1MnDT8k
         GzsPqj9No/NwM2jRt++KJDwNAFYhWiUbjr61Ta4YaJw5gHcysAoydbnA3hqD6+kvN1/B
         /6Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nicjlVDTn1RLjF5YNP4lJKlt1OSyZqzHGmBmYoJbz9M=;
        b=h6TaJpVHucBPpkb3fpqC4k1vV+SM6IcpTjdvoo1VZRD1dwkl2TSBmIjCvIAbtsB6Sv
         KqiJHeuleOuvdGS585T8CPhzjjB195t+85koin3xRxe7PoshyQGj8pEMjn6q9kvRic1e
         qMWW1Cpjr9/n4255m069vCIGscmEvgaezqTdVX15xWpxanJ+++4HuBJd4ExbDp3pwL7b
         vwZC4+kSkASx7MmbpIaYFZA+tHjv9YttyTJGFAhg175/+KC0WAmBUPdtcVU7E+hLVycP
         AOMAErkZu0yK0OJB9zKEh2rPfGpuisTLdAbgdcNCXLeQn9XPnfGw871J5jzsmmkLh4QW
         ZQtA==
X-Gm-Message-State: ANhLgQ2iZXPUhA5PGIo31CRLcwBrLz/EhovyCKTvsMFxb350CuCJFwGO
        /bKzU9ODZyRUiZ9YBlajEujowfP9zSc=
X-Google-Smtp-Source: ADFU+vsvU48IOm54NC2O1gM3oRj4v7wvDonYABfMPPllxbmE67uLg/sWVG/9N4lmTxOVIPTr3PoY2g==
X-Received: by 2002:ac2:5190:: with SMTP id u16mr5151945lfi.43.1582978906178;
        Sat, 29 Feb 2020 04:21:46 -0800 (PST)
Received: from [172.31.190.83] ([86.57.146.226])
        by smtp.gmail.com with ESMTPSA id q10sm7834771ljj.60.2020.02.29.04.21.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 29 Feb 2020 04:21:45 -0800 (PST)
Subject: Re: [PATCH 3/6] io_uring: support buffer selection
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     andres@anarazel.de
References: <20200228203053.25023-1-axboe@kernel.dk>
 <20200228203053.25023-4-axboe@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <e6fdc525-760d-466f-b754-229d76406e45@gmail.com>
Date:   Sat, 29 Feb 2020 15:21:44 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200228203053.25023-4-axboe@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/28/2020 11:30 PM, Jens Axboe wrote:

> +static int io_rw_common_cflags(struct io_kiocb *req)

Sounds more like sort of const/idempotent function, but not one changing
internal state (i.e. deallocation kbuf). Could it be named closer to
deallocate, remove, disarm, etc?

> +{
> +	struct io_buffer *kbuf = (struct io_buffer *) req->rw.addr;
> +	int cflags;
> +
> +	cflags = kbuf->bid << IORING_CQE_BUFFER_SHIFT;
> +	cflags |= IORING_CQE_F_BUFFER;
> +	req->rw.addr = 0;
> +	kfree(kbuf);
> +	return cflags;
> +}



> +static struct io_buffer *io_buffer_select(struct io_kiocb *req, int gid,
> +					  struct io_buffer *kbuf,
> +					  bool needs_lock)
> +{
> +	struct list_head *list;
> +
> +	if (req->flags & REQ_F_BUFFER_SELECTED)
> +		return kbuf;
> +
> +	/*
> +	 * "Normal" inline submissions always hold the uring_lock, since we
> +	 * grab it from the system call. Same is true for the SQPOLL offload.
> +	 * The only exception is when we've detached the request and issue it
> +	 * from an async worker thread, grab the lock for that case.
> +	 */
> +	if (needs_lock)
> +		mutex_lock(&req->ctx->uring_lock);

The same concern as for the [2/6]

> +
> +	lockdep_assert_held(&req->ctx->uring_lock);
> +
> +	list = idr_find(&req->ctx->io_buffer_idr, gid);
> +	if (list && !list_empty(list)) {
> +		kbuf = list_first_entry(list, struct io_buffer, list);
> +		list_del(&kbuf->list);

free(list), if it became empty? As mentioned, may go away naturally if
idr would store io_buffer directly.

> +	} else {
> +		kbuf = ERR_PTR(-ENOBUFS);
> +	}
> +
> +	if (needs_lock)
> +		mutex_unlock(&req->ctx->uring_lock);
> +
> +	return kbuf;
> +}
> +

-- 
Pavel Begunkov
