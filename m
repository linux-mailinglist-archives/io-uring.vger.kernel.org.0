Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22FE816AA8D
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2020 16:57:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727825AbgBXP5X (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 24 Feb 2020 10:57:23 -0500
Received: from mail-il1-f194.google.com ([209.85.166.194]:34633 "EHLO
        mail-il1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727693AbgBXP5X (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 24 Feb 2020 10:57:23 -0500
Received: by mail-il1-f194.google.com with SMTP id l4so8147477ilj.1
        for <io-uring@vger.kernel.org>; Mon, 24 Feb 2020 07:57:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=JJwHAc92RJBcQGkRlyEF4Z5y7InniIUrRVeIPURwguc=;
        b=0ditpleXPaPcOuvLuZmfcMeZEayD31bXfzWmEUTVSW5pVYdI4leqnR08LwYnncwQ/c
         502A5ESh0lzSoFXM2wjutP6AVsbLLy44ChU0Zcxzq4tfkbUrvDI7eet3SbacZw/fhXhe
         c/7hAESXYYeWjReDMxNu5F4oNDF54cdFha73BJ0HyGP1tkGX9p9R1mSC9AIHcCqVeJ4O
         GVj+zj6DKzRmrzLt586JUaZ1PvKuOFJIfMhfKNFKeNchUNau7kIpodoFOUZxTZC9XADt
         XW8D5dovlnLgTUojbZjuQz/sy1RLhNDmz5NaFegSFh0pSDoJ+s2EFvCwOnBw0ffUFG8L
         DUhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JJwHAc92RJBcQGkRlyEF4Z5y7InniIUrRVeIPURwguc=;
        b=kcVZeGGkHSW8GYYiDd/1GO/Sj4WeSlY0lpSHUhuYi+/M0HkDUZJEcjT6Imjn7spdnZ
         hRlikHD2u/bbd6PHsrmnIx523E0QPSfw61ZK5HpxVRtM8x/Dy9nu4MDv9MFs290C1EZF
         1O6TkEgDDUMOhTINXwP7NlvPzs6ekTbT6XhrnAvC5hVzsGUJyiLVOpAOliGFhco11L8j
         QsrQ9jstLvKWzUXMHULdJvd17q/Kcu9zEGVwIcN2/8vvM5lH4huB9XSgIWYC3ZC1qYst
         GvB3dE0WM8+z3sk3t4DP5ND8RnGCzS9txkYoo91hcDR1Pfe6hlYvDbD5imUJUnfs4rJR
         oDzg==
X-Gm-Message-State: APjAAAUIAuuEUGcTNAjiwcfDm6ZPBaP/YxTak93fNoTKbqhu3iqpUkyX
        xXlmE2O/syoXv2VU8jQpiKIlbQ==
X-Google-Smtp-Source: APXvYqyxbzdw4MgsCJjvSPBJBiQcmxoSZ0SqfcgS7mlPXqy42iLRmPDDR1R/jpJ/F4GtX6Gmhj7lWg==
X-Received: by 2002:a05:6e02:4c2:: with SMTP id f2mr59200239ils.126.1582559839603;
        Mon, 24 Feb 2020 07:57:19 -0800 (PST)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id z21sm3102490ioj.21.2020.02.24.07.57.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Feb 2020 07:57:18 -0800 (PST)
Subject: Re: [PATCH 3/3] io_uring: support buffer selection
To:     Jann Horn <jannh@google.com>
Cc:     io-uring <io-uring@vger.kernel.org>, andres@anarazel.de
References: <20200224025607.22244-1-axboe@kernel.dk>
 <20200224025607.22244-4-axboe@kernel.dk>
 <CAG48ez2UDoAOnGaVzXkdZGikc+=0mreMD=57LoGf6bG6uRh6hw@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <cd9960e7-ad0e-826b-b7c4-bcc8001326dd@kernel.dk>
Date:   Mon, 24 Feb 2020 08:57:16 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <CAG48ez2UDoAOnGaVzXkdZGikc+=0mreMD=57LoGf6bG6uRh6hw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/24/20 8:50 AM, Jann Horn wrote:
> On Mon, Feb 24, 2020 at 3:56 AM Jens Axboe <axboe@kernel.dk> wrote:
> [...]
>> With IORING_OP_PROVIDE_BUFFER, an application can register buffers to
>> use for any request. The request then sets IOSQE_BUFFER_SELECT in the
>> sqe, and a given group ID in sqe->buf_group. When the fd becomes ready,
>> a free buffer from the specified group is selected. If none are
>> available, the request is terminated with -ENOBUFS. If successful, the
>> CQE on completion will contain the buffer ID chosen in the cqe->flags
>> member, encoded as:
> [...]
>> +static struct io_buffer *io_buffer_select(struct io_kiocb *req, int gid,
>> +                                         void *buf)
>> +{
>> +       struct list_head *list;
>> +       struct io_buffer *kbuf;
>> +
>> +       if (req->flags & REQ_F_BUFFER_SELECTED)
>> +               return buf;
>> +
>> +       list = idr_find(&req->ctx->io_buffer_idr, gid);
>> +       if (!list || list_empty(list))
>> +               return ERR_PTR(-ENOBUFS);
>> +
>> +       kbuf = list_first_entry(list, struct io_buffer, list);
>> +       list_del(&kbuf->list);
>> +       return kbuf;
>> +}
> 
> This function requires some sort of external locking, right? Since
> it's removing an entry from a list.
> 
> [...]
>> +static struct io_buffer *io_send_recv_buffer_select(struct io_kiocb *req,
>> +                                                   struct io_buffer **kbuf,
>> +                                                   int *cflags)
>> +{
>> +       struct io_sr_msg *sr = &req->sr_msg;
>> +
>> +       if (!(req->flags & REQ_F_BUFFER_SELECT))
>> +               return req->sr_msg.buf;
>> +
>> +       *kbuf = io_buffer_select(req, sr->gid, sr->kbuf);
> 
> But we use it here in io_send_recv_buffer_select(), not taking any
> extra locks before calling it...
> 
>> +       if (IS_ERR(*kbuf))
>> +               return *kbuf;
>> +
>> +       sr->kbuf = *kbuf;
>> +       if (sr->len > (*kbuf)->len)
>> +               sr->len = (*kbuf)->len;
>> +       req->flags |= REQ_F_BUFFER_SELECTED;
>> +
>> +       *cflags = (*kbuf)->bid << IORING_CQE_BUFFER_SHIFT;
>> +       *cflags |= IORING_CQE_F_BUFFER;
>> +       return u64_to_user_ptr((*kbuf)->addr);
>> +}
>> +
>>  static int io_send(struct io_kiocb *req, struct io_kiocb **nxt,
>>                    bool force_nonblock)
>>  {
>>  #if defined(CONFIG_NET)
>> +       struct io_buffer *kbuf = NULL;
>>         struct socket *sock;
>> -       int ret;
>> +       int ret, cflags = 0;
>>
>>         if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
>>                 return -EINVAL;
>> @@ -3217,9 +3323,16 @@ static int io_send(struct io_kiocb *req, struct io_kiocb **nxt,
>>                 struct io_sr_msg *sr = &req->sr_msg;
>>                 struct msghdr msg;
>>                 struct iovec iov;
>> +               void __user *buf;
>>                 unsigned flags;
>>
>> -               ret = import_single_range(WRITE, sr->buf, sr->len, &iov,
>> +               buf = io_send_recv_buffer_select(req, &kbuf, &cflags);
> 
> ... and call io_send_recv_buffer_select() from here without holding
> any extra locks in this function. This function is then called from
> io_issue_sqe() (no extra locks held there either), which is called
> from __io_queue_sqe() (no extra locks AFAICS), which is called from
> places like task work.
> 
> Am I missing something?

Submission is all done under the ctx->uring_lock mutex, though the async
stuff does not. So for the normal path we should all be fine, as we'll
be serialized for that. We just need to ensure we do buffer select when
we prep the request for async execution, so the workers never have to do
it. Either that, or ensure the workers grab the mutex before doing the
grab (less ideal).

> It might in general be helpful to have more lockdep assertions in this
> code, both to help the reader understand the locking rules and to help
> verify locking correctness.

Agree, that'd be a good addition.

-- 
Jens Axboe

