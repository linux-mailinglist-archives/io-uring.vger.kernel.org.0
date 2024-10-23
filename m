Return-Path: <io-uring+bounces-3937-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 96AFC9ABBF0
	for <lists+io-uring@lfdr.de>; Wed, 23 Oct 2024 04:57:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B6AF71C20F47
	for <lists+io-uring@lfdr.de>; Wed, 23 Oct 2024 02:57:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 421CA51C5A;
	Wed, 23 Oct 2024 02:57:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="UBnvqE4U"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56BF94087C
	for <io-uring@vger.kernel.org>; Wed, 23 Oct 2024 02:57:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729652253; cv=none; b=K/t2SvV9EkydJNB0aWey6p3X9dDmQYzBN+nqKm5CBYORhv9coAhxQ3GNMpqt7eN8ns1HMstIz9aYRhcsFqCT9lQwYbT5k/lVEeccxT3pbKeO7MKK+7W1GdhF7iCor0pPOeLOqwCCpUwvdB4njRzmVu/dn2ZcYWW386OFZDmomis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729652253; c=relaxed/simple;
	bh=R4WYToyEXGqsmc47XnG1WPZwrHp2kUHlZMmfaio5N3g=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=XZYDcK6QD3kbJ3xWzIczoA9nKIeKJKTjk5wxp3fzkY+O86LkgTeR4q/dvHe5Ns1Yr4H+e2p8JXKvRPlLwhCs7Se9AqnKqidvB9YHKDqjsbW5BhB7DmYQkjz5A3Om67zRdKtmTZPwUCrSIQM75QXNrwgg5s9On6QUR93aN2xNnhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=UBnvqE4U; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-2e3686088c3so4619013a91.0
        for <io-uring@vger.kernel.org>; Tue, 22 Oct 2024 19:57:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1729652248; x=1730257048; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Kq5cQLy4PVkhCE0eHVFqK3Wz+Q3lY9yEvUCRcuxYm0Q=;
        b=UBnvqE4UuxRRPTKKSOaXOEkOg8I26o4RQp7+iF3f5bSx/CmDr+CpYXTCF3M7zNtpr1
         QA2OdI/msd0q3vZfpByLAPGRfY7MRWAC+B6YxEowKoVtbz7xh0DLPTNrUUnpL4c0G2KV
         dt/7ZX2Qr2vYkCo9QygGWc/UEUq47Og37+/6RHdVthGGnql9iQJmP6qi+RXEzjbd70MH
         S98iPqxRsFzd2ZCQQghFVTpCed/zYM/r6oR/9HiwrcKLu7yXxU5MZNyLqO7ANFPUIRMb
         Whgv0hyEVzfrOaDuCKAVfqv1Ydz9AkiPp60DVmdO0k1A+bcW1b7Lpqm868oDd+V+h76F
         gEEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729652248; x=1730257048;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Kq5cQLy4PVkhCE0eHVFqK3Wz+Q3lY9yEvUCRcuxYm0Q=;
        b=Zpuif/Fe+sQAu6Eb4ONZHspcdVhn6yVPW4B9Fjf3RNVeLPVi0fICHFzCjsoCYI0TJZ
         xjHAJuxy2A0kyccu+Eeu6CWbkITHFLuODdC7VCO2gV5DHtipnn9pbAkiXGjGLaNgwosA
         ml97Pf3w/XB6mx5e3yofBX5TZ2reYTtaCnNeMoPB5j+N05kxIy4DtnFjzyH7iRAba4/B
         ShCNaijLS7ylb2wAfshcFycAWkun6yD3LkX346RxVxWbbZVjC5x2WnTVK9y3IVAUbElb
         A0Dtli+8aokx/3DGMp9AxMVE9ubbWWPWkKXIvyaOh87YlOOyX7ZQGpulRnjtcnLoQilK
         xeFQ==
X-Forwarded-Encrypted: i=1; AJvYcCX/N6gy4xQSjAh6kgMim3h4qa3M7ivdQWvta/iVSJ3w27Lq3NS1trj8htFSZd+H79L5O1jwHRWPAw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx+GptyzKyRnjPuT8QP6thIAZOPqzho6GgRUEit7qbZiJNCPWF5
	kBmc1MA/be2SdK+KX2ZszTAMbKiuaNRp9AaIGwmKiVd9mTG04ww/PKS6W7k0Kz8=
X-Google-Smtp-Source: AGHT+IGOOR/QeH6CITDVuIkt7PQAs0t5JN5Z52c0DvgaaAURKzYQ9bdhfpiBzUy/OEKCSTrSm804DQ==
X-Received: by 2002:a17:90a:c001:b0:2d8:dd14:79ed with SMTP id 98e67ed59e1d1-2e76b6ec720mr1140682a91.31.1729652247924;
        Tue, 22 Oct 2024 19:57:27 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2e76df2aadfsm198754a91.9.2024.10.22.19.57.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Oct 2024 19:57:27 -0700 (PDT)
Message-ID: <875e522f-b55e-4c83-ae90-7a203b96596e@kernel.dk>
Date: Tue, 22 Oct 2024 20:57:25 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/4] io_uring/net: move send zc fixed buffer import to
 issue path
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <20241022133441.855081-1-axboe@kernel.dk>
 <20241022133441.855081-4-axboe@kernel.dk>
 <834c14c5-4e8b-49c9-a523-825305495c6d@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <834c14c5-4e8b-49c9-a523-825305495c6d@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/22/24 8:51 PM, Pavel Begunkov wrote:
> On 10/22/24 14:32, Jens Axboe wrote:
>> Let's keep it close with the actual import, there's no reason to do this
>> on the prep side. With that, we can drop one of the branches checking
>> for whether or not IORING_RECVSEND_FIXED_BUF is set.
>>
>> As a side-effect, get rid of req->imu usage.
>>
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>> ---
>>   io_uring/net.c | 29 ++++++++++++++++-------------
>>   1 file changed, 16 insertions(+), 13 deletions(-)
>>
>> diff --git a/io_uring/net.c b/io_uring/net.c
>> index 18507658a921..a5b875a40bbf 100644
>> --- a/io_uring/net.c
>> +++ b/io_uring/net.c
>> @@ -76,6 +76,7 @@ struct io_sr_msg {
>>       /* initialised and used only by !msg send variants */
>>       u16                addr_len;
>>       u16                buf_group;
>> +    u16                buf_index;
> 
> There is req->buf_index we can use

But that gets repurposed as the group ID for provided buffers, which is
why I wanted to add a separate field for that.

>>       void __user            *addr;
>>       void __user            *msg_control;
>>       /* used only for send zerocopy */
>> @@ -1254,16 +1255,6 @@ int io_send_zc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>>           }
>>       }
>>   -    if (zc->flags & IORING_RECVSEND_FIXED_BUF) {
>> -        unsigned idx = READ_ONCE(sqe->buf_index);
>> -
>> -        if (unlikely(idx >= ctx->nr_user_bufs))
>> -            return -EFAULT;
>> -        idx = array_index_nospec(idx, ctx->nr_user_bufs);
>> -        req->imu = READ_ONCE(ctx->user_bufs[idx]);
>> -        io_req_set_rsrc_node(notif, ctx, 0);
>> -    }
>> -
>>       if (req->opcode == IORING_OP_SEND_ZC) {
>>           if (READ_ONCE(sqe->__pad3[0]))
>>               return -EINVAL;
>> @@ -1279,6 +1270,7 @@ int io_send_zc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>>       zc->buf = u64_to_user_ptr(READ_ONCE(sqe->addr));
>>       zc->len = READ_ONCE(sqe->len);
>>       zc->msg_flags = READ_ONCE(sqe->msg_flags) | MSG_NOSIGNAL | MSG_ZEROCOPY;
>> +    zc->buf_index = READ_ONCE(sqe->buf_index);
>>       if (zc->msg_flags & MSG_DONTWAIT)
>>           req->flags |= REQ_F_NOWAIT;
>>   @@ -1339,13 +1331,24 @@ static int io_sg_from_iter(struct sk_buff *skb,
>>       return ret;
>>   }
>>   -static int io_send_zc_import(struct io_kiocb *req, struct io_async_msghdr *kmsg)
>> +static int io_send_zc_import(struct io_kiocb *req, unsigned int issue_flags)
>>   {
>>       struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
>> +    struct io_async_msghdr *kmsg = req->async_data;
>>       int ret;
>>         if (sr->flags & IORING_RECVSEND_FIXED_BUF) {
>> -        ret = io_import_fixed(ITER_SOURCE, &kmsg->msg.msg_iter, req->imu,
>> +        struct io_ring_ctx *ctx = req->ctx;
>> +        struct io_mapped_ubuf *imu;
>> +        int idx;
>> +
>> +        if (unlikely(sr->buf_index >= ctx->nr_user_bufs))
>> +            return -EFAULT;
>> +        idx = array_index_nospec(sr->buf_index, ctx->nr_user_bufs);
>> +        imu = READ_ONCE(ctx->user_bufs[idx]);
>> +        io_req_set_rsrc_node(sr->notif, ctx, issue_flags);
> 
> This entire section should be under uring_lock. First, we're looking
> at a imu that can be freed at any moment because io_req_set_rsrc_node()
> is done after. And even if change the order nothing guarantees that the
> CPU sees the imu content right.

True, I'll lock around it instead.

> FWIW, seems nobody was passing non-zero flags to io_req_set_rsrc_node()
> before this series, we should just kill the parameter.

I did briefly look at that last week, but this got in the way. I'll take
another look.

-- 
Jens Axboe

