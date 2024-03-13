Return-Path: <io-uring+bounces-931-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9501F87B332
	for <lists+io-uring@lfdr.de>; Wed, 13 Mar 2024 22:03:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B95B11C22C40
	for <lists+io-uring@lfdr.de>; Wed, 13 Mar 2024 21:03:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E197535C4;
	Wed, 13 Mar 2024 21:03:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="2t7JIm64"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f175.google.com (mail-il1-f175.google.com [209.85.166.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DE4F5337A
	for <io-uring@vger.kernel.org>; Wed, 13 Mar 2024 21:03:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710363829; cv=none; b=ds8a+dWdASwWnPh8jtd/K3bOM1/9ib053nsy2utz+h7OQX+fdL1Ar7mhaqLiaLL2GribSQvbFyDvgqBxWtE14yYuvIXhHBOPov9ttvZxE5MD/FvLSmYUlNky5WyVPfduv9DNibfEmiKCia6jhhAKWuQwBnoO2+RXwZZCjPaO3u4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710363829; c=relaxed/simple;
	bh=2LhrZSZGfs3pLlFLvMFm1jKmS8XK98hQPV3FPwhIbY8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GasVwls8jnXJOJ49Ybk9lpQMqCCmhPd1T3cGQP0FhlIX+ATJSJW3e5eWDIv0l/5Ed6EQtygVnDsNo28xzW6rUYXbZBUoYS6CKosJ876DjCHmYsUIcO2h38O+5Msq3rrmJpp6BdPOAkHEX76FWC117ixbvKrsifq9iA4fuTInrqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=2t7JIm64; arc=none smtp.client-ip=209.85.166.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f175.google.com with SMTP id e9e14a558f8ab-366478a02baso627865ab.0
        for <io-uring@vger.kernel.org>; Wed, 13 Mar 2024 14:03:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1710363826; x=1710968626; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7wVU99eoCj78Pm8h38UW/lWlyGyYU2qflgtnNcsqD20=;
        b=2t7JIm64wn+s9mSKHKVcg7YM6UROnM7r/B+QZmsilTUyqmmGnroJwBWOUUQCQvKIkz
         mQoODLZwKklUT0U7O0j++4h7o+StL5nv+gHc2apgsxQcMuHszv9ngOAKNhB1lMFjfXHE
         heC3wzb/kIRBy/TgTAlp4YiY0qbcVQGNB3zv8tNLQ7luEUo5rbhBMMwM5G1+pFD6W33K
         vlGf8L75ae5jIgp2iE+WQW8GfNidarVtWHwVWjKsIzWDsb/1EsENuZmQUtiF9Bu5Pt83
         cVYvQcZ76buLPbRISi6pk4jshKDJSlEVOfbJS8+uyOki6bhdrG7FmOYpv3QPeGkE1Qdu
         UrCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710363826; x=1710968626;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7wVU99eoCj78Pm8h38UW/lWlyGyYU2qflgtnNcsqD20=;
        b=xAzFK7IfybW8/k073JPGvpy2Vc0uxPSR12h5AR+DIYfM4/uEjQUQT5wnPskZXpaSey
         yx1gBQOF8oSEtu3r1mvViebq9CevIpTB+ycITE3VYAakwPTUPZ8tBKezFSBG6Wv9wRWt
         Ng8PyyQ8M1ep7LOms6JOa2RxsmdgvWYl2zYA7ALZ29y7J+hAdpsjlPncYnmaTEBo8oFt
         SjIi0YHJcBQB4t26VMCbPtTkD6aC6lmF6wg572abr2CcAYPrdRUyJ3w46J25jA7XoN0e
         ZYjLSqV6s5LBPzdi8cOhPmwyRSQMSptdj60EPzjmez11r9SMZLK6q9W3V+y5dIpVgihU
         NjQA==
X-Forwarded-Encrypted: i=1; AJvYcCVHIYlgFOB5PcbmU5CZi60LNKfyg6wVLzX76BZ31AqlTUkkVw9xhP0zMra28KJS0dDzSUwSb+Nrt6cBsjnQHufQJpp0EUqtslY=
X-Gm-Message-State: AOJu0YxAik6dkWtL9vFmiE3W3BitcQUlzMq2j7NHk2WsPq5EGJrPZfEy
	xj9uW6nGkiHDSoGDvf8t+lUMJn14ofCLuBbrm7KAJaTkeyGSdYKG9vj4INp8Zwo=
X-Google-Smtp-Source: AGHT+IEBoSQ0ayAn08GRm0f7iuEs4qxQf8gRC3enze76lDpG/eQP0FK1b07dxb3wzdukDIMfxvnGLA==
X-Received: by 2002:a5d:9253:0:b0:7c8:bd77:b321 with SMTP id e19-20020a5d9253000000b007c8bd77b321mr107807iol.2.1710363826269;
        Wed, 13 Mar 2024 14:03:46 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id k18-20020a02ccd2000000b004767d9bc182sm2967056jaq.139.2024.03.13.14.03.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Mar 2024 14:03:45 -0700 (PDT)
Message-ID: <8efd8232-fd4f-4f7a-a061-2f82cda8df4b@kernel.dk>
Date: Wed, 13 Mar 2024 15:03:44 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v4 13/16] io_uring: add io_recvzc request
Content-Language: en-US
To: Pavel Begunkov <asml.silence@gmail.com>, David Wei <dw@davidwei.uk>,
 io-uring@vger.kernel.org, netdev@vger.kernel.org
Cc: Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jesper Dangaard Brouer <hawk@kernel.org>, David Ahern <dsahern@kernel.org>,
 Mina Almasry <almasrymina@google.com>
References: <20240312214430.2923019-1-dw@davidwei.uk>
 <20240312214430.2923019-14-dw@davidwei.uk>
 <7752a08c-f55c-48d5-87f2-70f248381e48@kernel.dk>
 <4343cff7-37d9-4b78-af70-a0d7771b04bc@gmail.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <4343cff7-37d9-4b78-af70-a0d7771b04bc@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 3/13/24 2:26 PM, Pavel Begunkov wrote:
> On 3/13/24 20:25, Jens Axboe wrote:
>> On 3/12/24 3:44 PM, David Wei wrote:
>>> Add an io_uring opcode OP_RECV_ZC for doing ZC reads from a socket that
>>> is set up for ZC Rx. The request reads skbs from a socket. Completions
>>> are posted into the main CQ for each page frag read.
>>>
>>> Big CQEs (CQE32) is required as the OP_RECV_ZC specific metadata (ZC
>>> region, offset, len) are stored in the extended 16 bytes as a
>>> struct io_uring_rbuf_cqe.
>>>
>>> For now there is no limit as to how much work each OP_RECV_ZC request
>>> does. It will attempt to drain a socket of all available data.
>>>
>>> Multishot requests are also supported. The first time an io_recvzc
>>> request completes, EAGAIN is returned which arms an async poll. Then, in
>>> subsequent runs in task work, IOU_ISSUE_SKIP_COMPLETE is returned to
>>> continue async polling.
>>
>> I'd probably drop that last paragraph, this is how all multishot
>> requests work and is implementation detail that need not go in the
>> commit message. Probably suffices just to say it supports multishot.
>>
>>> @@ -695,7 +701,7 @@ static inline bool io_recv_finish(struct io_kiocb *req, int *ret,
>>>       unsigned int cflags;
>>>         cflags = io_put_kbuf(req, issue_flags);
>>> -    if (msg->msg_inq && msg->msg_inq != -1)
>>> +    if (msg && msg->msg_inq && msg->msg_inq != -1)
>>>           cflags |= IORING_CQE_F_SOCK_NONEMPTY;
>>>         if (!(req->flags & REQ_F_APOLL_MULTISHOT)) {
>>> @@ -723,7 +729,7 @@ static inline bool io_recv_finish(struct io_kiocb *req, int *ret,
>>>               goto enobufs;
>>>             /* Known not-empty or unknown state, retry */
>>> -        if (cflags & IORING_CQE_F_SOCK_NONEMPTY || msg->msg_inq == -1) {
>>> +        if (cflags & IORING_CQE_F_SOCK_NONEMPTY || (msg && msg->msg_inq == -1)) {
>>>               if (sr->nr_multishot_loops++ < MULTISHOT_MAX_RETRY)
>>>                   return false;
>>>               /* mshot retries exceeded, force a requeue */
>>
>> Maybe refactor this a bit so that you don't need to add these NULL
>> checks? That seems pretty fragile, hard to read, and should be doable
>> without extra checks.
> 
> That chunk can be completely thrown away, we're not using
> io_recv_finish() here anymore
> 
> 
>>> @@ -1053,6 +1058,85 @@ struct io_zc_rx_ifq *io_zc_verify_sock(struct io_kiocb *req,
>>>       return ifq;
>>>   }
>>>   +int io_recvzc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>>> +{
>>> +    struct io_recvzc *zc = io_kiocb_to_cmd(req, struct io_recvzc);
>>> +
>>> +    /* non-iopoll defer_taskrun only */
>>> +    if (!req->ctx->task_complete)
>>> +        return -EINVAL;
>>
>> What's the reasoning behind this?
> 
> CQ locking, see the comment a couple lines below
> 
> 
>>> +    struct io_recvzc *zc = io_kiocb_to_cmd(req, struct io_recvzc);
>>> +    struct io_zc_rx_ifq *ifq;
>>> +    struct socket *sock;
>>> +    int ret;
>>> +
>>> +    /*
>>> +     * We're posting CQEs deeper in the stack, and to avoid taking CQ locks
>>> +     * we serialise by having only the master thread modifying the CQ with
>>> +     * DEFER_TASkRUN checked earlier and forbidding executing it from io-wq.
>>> +     * That's similar to io_check_multishot() for multishot CQEs.
>>> +     */
> 
> This one ^^, though it doesn't read well, I should reword it for
> next time.
> 
>>> +    if (issue_flags & IO_URING_F_IOWQ)
>>> +        return -EAGAIN;
>>> +    if (WARN_ON_ONCE(!(issue_flags & IO_URING_F_NONBLOCK)))
>>> +        return -EAGAIN;
>>
>> If rebased on the current tree, does this go away?
> 
> It's just a little behind not to have that change
> 

-- 
Jens Axboe



