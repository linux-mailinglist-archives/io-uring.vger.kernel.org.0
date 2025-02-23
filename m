Return-Path: <io-uring+bounces-6647-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AE6E4A41211
	for <lists+io-uring@lfdr.de>; Sun, 23 Feb 2025 23:44:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5A1BB167F6D
	for <lists+io-uring@lfdr.de>; Sun, 23 Feb 2025 22:43:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 579D76EB7C;
	Sun, 23 Feb 2025 22:43:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="rwkBGLv7"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C041110A3E
	for <io-uring@vger.kernel.org>; Sun, 23 Feb 2025 22:43:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740350615; cv=none; b=PZjzXF4jRE8D+Bm9RnAxEpInzRUfSG8khS1WOHK4ZxObTFttJZPtPJrIknXXHzj7o9sVwosaronK9WxnNwMCmHlHeleN5vLhg4U5Bcj6XofaM9UQWkv32aT2yFlhWtwnYmAH0JX1HNOPilWZ2RRH+eqG5axoHpLxcGKEBlhgz0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740350615; c=relaxed/simple;
	bh=0utmdy0X+M1HR4beSqeBwCGzXRwXHAi3ie55aeDZPsk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=L/7KXtClytYDyJPXmLV68EIHhYg+/IA/qyLA7tllBZDZVo6FqnzK87c3l8wbetKrFBp8skVcBACQKD/TNfV15JzCWiseZDFSOhzlF3PocsqxqYMvqoqPvl+V/E4VfxAtpZ5oIWuPsK9Uewy8Nunf+dSdk7hTmGQB08pdkoG+its=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=rwkBGLv7; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-22100006bc8so64219875ad.0
        for <io-uring@vger.kernel.org>; Sun, 23 Feb 2025 14:43:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1740350613; x=1740955413; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6N7Aj2iogTSrK7YlQZA+Mp1d3ULlKnu/6yg3x8AhblA=;
        b=rwkBGLv7oROJKhSbz2thmRDrjwwAqMshOh4zMlHZ7wjQZxaY+BEQHDw9QO38Nikeo3
         WSEQ2eKzxUYyGsu8Odp6Wd8L9s+3QJgDvzh8SfJWe8L/jU3kTjbC0Tz34Dx4ooRWM+f/
         inNqv7VCFDGU0dwcduqS4JWK3gFouPlO9yBb3N413vCwfwQP/l08p580mk463jctuQsU
         NaEzseKA7h5Q0e29Znvz7nmhCoXrdfsZqZmZ+X9NC9jqxY7flVtJUKQ+v9tGd17/giXC
         R00Z+ciQx9ozkcpiE3GbVsj9nraYxX1x+nX5VTjch7lS8Zb+deAQ76MfMQs9ckSqrf1X
         0IZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740350613; x=1740955413;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6N7Aj2iogTSrK7YlQZA+Mp1d3ULlKnu/6yg3x8AhblA=;
        b=Z96dV2mzNfBejZNeSYHYArJj7YbrvN/x8AW2V2Y6CaJWUbAZVHPnsFRnij7wzMA/5B
         CakmNzY1diPr3Op7cklbczP6FnQNHxgML9BRoyP5mczXdz1F6roqGTF9FElHg81FsHBz
         hYDXYhYvSHuGXFOAK0te3XQJptKtS69ohfp7eYiI3PD5ccf0WxmNZKmwc0bswUoYiGuj
         JG4rnGTOjr85ycOqOlB8TGgdYYPo+yw8t+1yskSW4jRfjbQdMpgfxy8tBriJGWmvFU+w
         jJRRKc4IZzwqRp4wBoG1tAlryTPR9+n4jrV36Ws+UBwMP47mchJ6UB8TnZ8j6hiQ7GYu
         LsCg==
X-Forwarded-Encrypted: i=1; AJvYcCUWN0NhCiCgi0D55OMq16l29ceUhxzerin3Tt36PoKJQNwEanQGL8sJQ9A3pCiGWn9kq9UMBCYERQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YyJD5m5s8v3p7ie8nJu4EMKXDpj3kS9Q0ZnbrBAMa708xZT+cxO
	yls15FuJkQLNslRUOOPbJjqhPyU81GzVLJ2nkO5y1vtMW9aqBUnuhj3/X4PDpjw=
X-Gm-Gg: ASbGncsiUXOF+gmAp+GC3Cntoi+a8BtOQlrO0w36xA2cvrxbbQudNC+YiKyI4c+256I
	RHwnzLe3K2ijUJtGrwxthS80oeqnJK38D8rBe4wyaqeM+mOns7OvsLZoFXjOm4MadpPfs6SZggg
	w/hVoIk/R2w7DKha+VG0CiGMvKyeSFBnhMaWjQRv+bbsh8q5IXuseUQuC9QEoklwPfGBHLmMs0S
	dA8+bmmfsZQOFkmqYW0bkCrxLumcO+Zjqu+cz5sfn0CC+aW+G9YviNKEsa/wOMPKPyryt91ZOgB
	AvESeVVy1r0ZbwP7o4QD+rR6QI8yS+DR
X-Google-Smtp-Source: AGHT+IFWz5Opm2SvJA7R0b9TZgG9+5wgy6OD8S+HYagZ9slfcgg6BjyZvfSNxing9u4RPxN4UAyFiw==
X-Received: by 2002:a05:6a20:7290:b0:1ee:cab3:426e with SMTP id adf61e73a8af0-1eef3c569b2mr22011352637.7.1740350612949;
        Sun, 23 Feb 2025 14:43:32 -0800 (PST)
Received: from [192.168.1.12] ([97.126.136.10])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-adbf21517eesm16513246a12.13.2025.02.23.14.43.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 23 Feb 2025 14:43:32 -0800 (PST)
Message-ID: <4e89f559-37ff-45a8-aa76-a8d2b827319f@davidwei.uk>
Date: Sun, 23 Feb 2025 14:43:32 -0800
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] io_uring/zcrx: add single shot recvzc
Content-Language: en-GB
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
References: <20250221205146.1210952-1-dw@davidwei.uk>
 <20250221205146.1210952-2-dw@davidwei.uk>
 <6165d6a4-a8d3-4c2f-8550-e157a279c8f3@gmail.com>
From: David Wei <dw@davidwei.uk>
In-Reply-To: <6165d6a4-a8d3-4c2f-8550-e157a279c8f3@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2025-02-21 16:40, Pavel Begunkov wrote:
> On 2/21/25 20:51, David Wei wrote:
>> Currently only multishot recvzc requests are supported, but sometimes
>> there is a need to do a single recv e.g. peeking at some data in the
>> socket. Add single shot recvzc requests where IORING_RECV_MULTISHOT is
>> _not_ set and the sqe->len field is set to the number of bytes to read
>> N.
> 
> There is no oneshot, we need to change the message.

I'll make commit subject/descriptions consistent. There is no single
shot, only multishot with and without limits.

> 
> 
>> There could be multiple completions containing data, like the multishot
>> case, since N bytes could be split across multiple frags. This is
>> followed by a final completion with res and cflags both set to 0 that
>> indicate the completion of the request, or a -res that indicate an
>> error.
>>
>> Signed-off-by: David Wei <dw@davidwei.uk>
>> ---
>>   io_uring/net.c  | 19 +++++++++++++++++--
>>   io_uring/zcrx.c | 17 ++++++++++++-----
>>   io_uring/zcrx.h |  2 +-
>>   3 files changed, 30 insertions(+), 8 deletions(-)
>>
>> diff --git a/io_uring/net.c b/io_uring/net.c
>> index 000dc70d08d0..cae34a24266c 100644
>> --- a/io_uring/net.c
>> +++ b/io_uring/net.c
>> @@ -94,6 +94,7 @@ struct io_recvzc {
>>       struct file            *file;
>>       unsigned            msg_flags;
>>       u16                flags;
>> +    u32                len;
>>       struct io_zcrx_ifq        *ifq;
>>   };
>>   @@ -1241,7 +1242,7 @@ int io_recvzc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>>       unsigned ifq_idx;
>>         if (unlikely(sqe->file_index || sqe->addr2 || sqe->addr ||
>> -             sqe->len || sqe->addr3))
>> +             sqe->addr3))
>>           return -EINVAL;
>>         ifq_idx = READ_ONCE(sqe->zcrx_ifq_idx);
>> @@ -1250,6 +1251,12 @@ int io_recvzc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>>       zc->ifq = req->ctx->ifq;
>>       if (!zc->ifq)
>>           return -EINVAL;
>> +    zc->len = READ_ONCE(sqe->len);
>> +    if (zc->len == UINT_MAX)
>> +        return -EINVAL;
> 
> The uapi gives u32, if we're using a special value it should
> match the type. ~(u32)0
> 
>> +    /* UINT_MAX means no limit on readlen */
>> +    if (!zc->len)
>> +        zc->len = UINT_MAX;
>>         zc->flags = READ_ONCE(sqe->ioprio);
>>       zc->msg_flags = READ_ONCE(sqe->msg_flags);
>> @@ -1269,6 +1276,7 @@ int io_recvzc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>>   int io_recvzc(struct io_kiocb *req, unsigned int issue_flags)
>>   {
>>       struct io_recvzc *zc = io_kiocb_to_cmd(req, struct io_recvzc);
>> +    bool limit = zc->len != UINT_MAX;
>>       struct socket *sock;
>>       int ret;
>>   @@ -1281,7 +1289,7 @@ int io_recvzc(struct io_kiocb *req, unsigned int issue_flags)
>>           return -ENOTSOCK;
>>         ret = io_zcrx_recv(req, zc->ifq, sock, zc->msg_flags | MSG_DONTWAIT,
>> -               issue_flags);
>> +               issue_flags, &zc->len);
>>       if (unlikely(ret <= 0) && ret != -EAGAIN) {
>>           if (ret == -ERESTARTSYS)
>>               ret = -EINTR;
>> @@ -1296,6 +1304,13 @@ int io_recvzc(struct io_kiocb *req, unsigned int issue_flags)
>>           return IOU_OK;
>>       }
>>   +    if (zc->len == 0) {
> 
> If len hits zero we should always complete it, regardless
> of errors the stack might have returned, so might be
> cleaner if you do that check right after io_zcrx_recv().

Sounds good.

> 
>> +        io_req_set_res(req, 0, 0);
>> +
>> +        if (issue_flags & IO_URING_F_MULTISHOT)
>> +            return IOU_STOP_MULTISHOT;
>> +        return IOU_OK;
>> +    }
>>       if (issue_flags & IO_URING_F_MULTISHOT)
>>           return IOU_ISSUE_SKIP_COMPLETE;
>>       return -EAGAIN;
>> diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
>> index f2d326e18e67..74bca4e471bc 100644
>> --- a/io_uring/zcrx.c
>> +++ b/io_uring/zcrx.c
>> @@ -817,6 +817,7 @@ io_zcrx_recv_skb(read_descriptor_t *desc, struct sk_buff *skb,
>>       int i, copy, end, off;
>>       int ret = 0;
>>   +    len = min_t(size_t, len, desc->count);
>>       if (unlikely(args->nr_skbs++ > IO_SKBS_PER_CALL_LIMIT))
>>           return -EAGAIN;
>>   @@ -894,26 +895,32 @@ io_zcrx_recv_skb(read_descriptor_t *desc, struct sk_buff *skb,
>>   out:
>>       if (offset == start_off)
>>           return ret;
>> +    if (desc->count != UINT_MAX)
>> +        desc->count -= (offset - start_off);
> 
> I'd say just set desc->count to it's max value (size_t), and
> never care about checking for limits after.

True, we're limited by IO_SKBS_PER_CALL_LIMIT.

> 
>>       return offset - start_off;
>>   }
>>     static int io_zcrx_tcp_recvmsg(struct io_kiocb *req, struct io_zcrx_ifq *ifq,
>>                   struct sock *sk, int flags,
>> -                unsigned issue_flags)
>> +                unsigned issue_flags, unsigned int *outlen)
>>   {
>> +    unsigned int len = *outlen;
>> +    bool limit = len != UINT_MAX;
>>       struct io_zcrx_args args = {
>>           .req = req,
>>           .ifq = ifq,
>>           .sock = sk->sk_socket,
>>       };
>>       read_descriptor_t rd_desc = {
>> -        .count = 1,
>> +        .count = len,
>>           .arg.data = &args,
>>       };
>>       int ret;
>>         lock_sock(sk);
>>       ret = tcp_read_sock(sk, &rd_desc, io_zcrx_recv_skb);
>> +    if (limit && ret)
>> +        *outlen = len - ret;
>>       if (ret <= 0) {
>>           if (ret < 0 || sock_flag(sk, SOCK_DONE))
>>               goto out;
>> @@ -930,7 +937,7 @@ static int io_zcrx_tcp_recvmsg(struct io_kiocb *req, struct io_zcrx_ifq *ifq,
>>           ret = IOU_REQUEUE;
>>       } else if (sock_flag(sk, SOCK_DONE)) {
>>           /* Make it to retry until it finally gets 0. */
>> -        if (issue_flags & IO_URING_F_MULTISHOT)
>> +        if (!limit && (issue_flags & IO_URING_F_MULTISHOT))
>>               ret = IOU_REQUEUE;
> 
> And with earlier len check in net.c you don't need this change,
> which feels wrong, as it's only here to circumvent some handling
> in net.c, I assume
> 

Yeah, I don't think this is needed anymore, will remove.

