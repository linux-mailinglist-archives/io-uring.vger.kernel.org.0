Return-Path: <io-uring+bounces-1107-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 59FE987EB14
	for <lists+io-uring@lfdr.de>; Mon, 18 Mar 2024 15:34:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C75A81F2122E
	for <lists+io-uring@lfdr.de>; Mon, 18 Mar 2024 14:34:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F6384E1D0;
	Mon, 18 Mar 2024 14:34:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TsgqcPwL"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCC0E4D9E5;
	Mon, 18 Mar 2024 14:34:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710772442; cv=none; b=BdRUS8htA6iEMf8rWZe7YFqIDv/WCvTqP7koUexHKaChoiaDRp5/Trxvj0FoA0Phcz3lbj4NhrF8voYC8HrDGPGAEOXRkUssQAq2E4Z2zwMdX1SAd9AQ1RFFynn6elEIqwU6PtNOPlCT+vTCqiYUTjHWuLxmPXIPvY2y3upkuFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710772442; c=relaxed/simple;
	bh=ueuuoZi3Hf3v0PLLizomcIoyyLgC8MsuAbim8ZRCdLM=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=lIbkRSozVjp6sFKOh3mVsrsSgvgNV8jvT3tP9tueJ8ylCOrtJ3YNKoRH964cIWbSNWhM4sZbAV7ibpFg7eA+n9tyMvKoUBK3s1aHEnvjB5ZbG4i+A9KZgvM2VloPvTCIxCRfnGrxuEw/OYY2Cm5P75N/ECXIG5Mp16Jut+Xns7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TsgqcPwL; arc=none smtp.client-ip=209.85.167.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-5131316693cso5431599e87.0;
        Mon, 18 Mar 2024 07:34:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710772439; x=1711377239; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rgoB/FA+cpjDuL5piCbmvbWWUyM1NnFPB8MDiD339bQ=;
        b=TsgqcPwLXVlCqMEptQXnmKrV1LQ3Se5suvtEdOH1m672z8CN/vNW0+pfIxH621diLp
         D9Ao5q2gxo+FU/l8R8uxFRgyOmX1yqj4vWo3p1NJOG8yGe7GohyL7/bDjPNDgMmOszsN
         w4YlVl/diIzl6J522LoeIHQ58GrewHoKXRIsX/usu3r3s/FJL6v5lmJxbmrvJSbuET7g
         ANFH82NA+4XSeHyiULqQYGCVqzobTTZ+iPXtOQh3uRIZE0ObY9vhe2ibuLWAeivyyyOJ
         WG91tpus+tAy9Q3RI8TMmtTYXQMwnIqOZq5WfWsjWU29vjphM/gWG/HuzBDCyiv7U29I
         CJmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710772439; x=1711377239;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rgoB/FA+cpjDuL5piCbmvbWWUyM1NnFPB8MDiD339bQ=;
        b=jyTjS1+pnts2JFUHRzTQZ1bBLaEuuvJxp4UE9A7cyGY+PHFz9XO2S3gRk3elcSeJ4x
         YE/pTU2uAlx/N71Q4rbIOadj9FJ1q+0KZ7AvWyLbpSEI2s8L7x1Q/ARELOsCBEIiQhOj
         t0W6JDahkNQC+0tU5a4YdnD2kW6bEPraijT7YYTKBlbAqtwhxqv4pRKdbnxZOnaF2aS+
         vLUhWpzUvS+pkq9hg4ujGmBL4Y/GhLlKOGIUOdohktK2tuViTymSCmIRQi1xid2nMKcT
         WUdx+YcAE5OGv4mIxm3/JHEEFMEbQEq4bjclArVGv5JKgBZ9FnW4sEVX4uQY5QqkFQsC
         BZEA==
X-Forwarded-Encrypted: i=1; AJvYcCXuzw9JAzqSLJCwqbYrDocl45+kHyLLZ3FgPdR8jTugf6h/IgooaLucZqb1CNo0py5d26TK82FeHLu0rqwpIIEsyNX77xn53V6jisk=
X-Gm-Message-State: AOJu0YzGPDzwR/MAYG9Bh/daOhRNLxS+7/hJYIiXLwvJXHD2EU0ib7W9
	BOLur5xwbpoaUf4QNYmDjIGDZu2avvp6b/wjf1A7y2oHeAAOgCNd
X-Google-Smtp-Source: AGHT+IH6B8NdlNYv/aelIhFdP1ubcxZzfTv7/OKmZwCqbArAMEWe1eaFnx9Xxo+G/tdHTQczTAyWzA==
X-Received: by 2002:a05:6512:32a6:b0:513:cfa6:3ea3 with SMTP id q6-20020a05651232a600b00513cfa63ea3mr9491993lfe.6.1710772438699;
        Mon, 18 Mar 2024 07:33:58 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:310::2181? ([2620:10d:c092:600::1:429a])
        by smtp.gmail.com with ESMTPSA id bw9-20020a170906c1c900b00a45ff821e09sm4892778ejb.150.2024.03.18.07.33.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Mar 2024 07:33:58 -0700 (PDT)
Message-ID: <8bf6d549-cf66-4412-bebd-fd6e98166552@gmail.com>
Date: Mon, 18 Mar 2024 14:32:16 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 05/14] ublk: don't hard code IO_URING_F_UNLOCKED
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
To: Ming Lei <ming.lei@redhat.com>
Cc: io-uring@vger.kernel.org, linux-block@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, Kanchan Joshi <joshi.k@samsung.com>
References: <cover.1710720150.git.asml.silence@gmail.com>
 <a3928d3de14d2569efc2edd7fb654a4795ae7f86.1710720150.git.asml.silence@gmail.com>
 <Zff4ShMEcL1WKZ1Q@fedora> <61b29658-e6a9-449f-a850-1881af1ecbee@gmail.com>
 <2095ac3e-5e5f-4ea2-a906-a924a25c121a@gmail.com>
In-Reply-To: <2095ac3e-5e5f-4ea2-a906-a924a25c121a@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 3/18/24 13:37, Pavel Begunkov wrote:
> On 3/18/24 12:52, Pavel Begunkov wrote:
>> On 3/18/24 08:16, Ming Lei wrote:
>>> On Mon, Mar 18, 2024 at 12:41:50AM +0000, Pavel Begunkov wrote:
>>>> uring_cmd implementations should not try to guess issue_flags, just use
>>>> a newly added io_uring_cmd_complete(). We're loosing an optimisation in
>>>> the cancellation path in ublk_uring_cmd_cancel_fn(), but the assumption
>>>> is that we don't care that much about it.
>>>>
>>>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>>>> Link: https://lore.kernel.org/r/2f7bc9fbc98b11412d10b8fd88e58e35614e3147.1710514702.git.asml.silence@gmail.com
>>>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>>> ---
>>>>   drivers/block/ublk_drv.c | 18 ++++++++----------
>>>>   1 file changed, 8 insertions(+), 10 deletions(-)
>>>>
>>>> diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
>>>> index bea3d5cf8a83..97dceecadab2 100644
>>>> --- a/drivers/block/ublk_drv.c
>>>> +++ b/drivers/block/ublk_drv.c
>>>> @@ -1417,8 +1417,7 @@ static bool ublk_abort_requests(struct ublk_device *ub, struct ublk_queue *ubq)
>>>>       return true;
>>>>   }
>>>> -static void ublk_cancel_cmd(struct ublk_queue *ubq, struct ublk_io *io,
>>>> -        unsigned int issue_flags)
>>>> +static void ublk_cancel_cmd(struct ublk_queue *ubq, struct ublk_io *io)
>>>>   {
>>>>       bool done;
>>>> @@ -1432,15 +1431,14 @@ static void ublk_cancel_cmd(struct ublk_queue *ubq, struct ublk_io *io,
>>>>       spin_unlock(&ubq->cancel_lock);
>>>>       if (!done)
>>>> -        io_uring_cmd_done(io->cmd, UBLK_IO_RES_ABORT, 0, issue_flags);
>>>> +        io_uring_cmd_complete(io->cmd, UBLK_IO_RES_ABORT, 0);
>>>>   }
>>>>   /*
>>>>    * The ublk char device won't be closed when calling cancel fn, so both
>>>>    * ublk device and queue are guaranteed to be live
>>>>    */
>>>> -static void ublk_uring_cmd_cancel_fn(struct io_uring_cmd *cmd,
>>>> -        unsigned int issue_flags)
>>>> +static void ublk_uring_cmd_cancel_fn(struct io_uring_cmd *cmd)
>>>>   {
>>>>       struct ublk_uring_cmd_pdu *pdu = ublk_get_uring_cmd_pdu(cmd);
>>>>       struct ublk_queue *ubq = pdu->ubq;
>>>> @@ -1464,7 +1462,7 @@ static void ublk_uring_cmd_cancel_fn(struct io_uring_cmd *cmd,
>>>>       io = &ubq->ios[pdu->tag];
>>>>       WARN_ON_ONCE(io->cmd != cmd);
>>>> -    ublk_cancel_cmd(ubq, io, issue_flags);
>>>> +    ublk_cancel_cmd(ubq, io);
>>>
>>> .cancel_fn is always called with .uring_lock held, so this 'issue_flags' can't
>>> be removed, otherwise double task run is caused because .cancel_fn
>>> can be called multiple times if the request stays in ctx->cancelable_uring_cmd.
>>
>> I see, that's exactly why I was asking whether it can be deferred
>> to tw. Let me see if I can get by without that patch, but honestly
>> it's a horrible abuse of the ring state. Any ideas how that can be
>> cleaned up?
> 
> I assume io_uring_try_cancel_uring_cmd() can run in parallel with
> completions, so there can be two parallel calls calls to ->uring_cmd
> (e.g. io-wq + cancel), which gives me shivers. Also, I'd rather
> no cancel in place requests of another task, io_submit_flush_completions()
> but it complicates things.

I'm wrong though on flush_completions, the task there cancels only
its own requests

io_uring_try_cancel_uring_cmd() {
	...
	if (!cancel_all && req->task != task)
		continue;
}


> Is there any argument against removing requests from the cancellation
> list in io_uring_try_cancel_uring_cmd() before calling ->uring_cmd?
> 
> io_uring_try_cancel_uring_cmd() {
>      lock();
>      for_each_req() {
>          remove_req_from_cancel_list(req);
>          req->file->uring_cmd();
>      }
>      unlock();
> }
> 

-- 
Pavel Begunkov

