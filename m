Return-Path: <io-uring+bounces-8197-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 0BFFBACC9DD
	for <lists+io-uring@lfdr.de>; Tue,  3 Jun 2025 17:11:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1EC627A1E5B
	for <lists+io-uring@lfdr.de>; Tue,  3 Jun 2025 15:10:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 28770223316;
	Tue,  3 Jun 2025 15:11:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="t7hLirZk"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f172.google.com (mail-il1-f172.google.com [209.85.166.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73AAD1DA23
	for <io-uring@vger.kernel.org>; Tue,  3 Jun 2025 15:11:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748963483; cv=none; b=jz1urkN8U+Yg4rSY/OznDjM8zuleV1mtMCG3Dvg9xIR3z4g1it3hGzULaLflnYNij6h6dewP3JMQ+H/KMFrEoDPajsWIIvWV8aUqI9B+JMFIWj7PjEy42ZMFZgpEqzQLZv/sFtBNfq10iNL09Dz5s9hYAUU0Vu9JlvnPpi6wqEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748963483; c=relaxed/simple;
	bh=P0y3o16XGa3S6zBmnVm2d+XAyvvVuhr34DOoLsoAwDM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=t1xbL4tNLJp+7tywOUU4+ExPOOPfBm1ektMqEM/7xJJZnGKlkIdop14PPbA2RloT/cuvoWzy0s4y4YVqpAovP2poYie0EKzmsGiVdoRz+xKdt1q58WeFZxeUIn2BB4VSTHLX9MINOventGdRCaJF2KotqcWYi6pfvn6hDWhtBEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=t7hLirZk; arc=none smtp.client-ip=209.85.166.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f172.google.com with SMTP id e9e14a558f8ab-3da831c17faso16301225ab.3
        for <io-uring@vger.kernel.org>; Tue, 03 Jun 2025 08:11:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1748963476; x=1749568276; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ENZPVk28fyhK8QBCNn1dutmAmP0iQqTHH437t9XffpQ=;
        b=t7hLirZkwFXcZXd6UFU0waePKN/r4+X9RCr9LA92jg8PF4Z9IJWqGGs+Ls4OMOs1Xu
         Pa3FPDtOwDarcg5cuzyKZ0tu+PUdSEYvRl40mry4ElsI+RiyX71w6RUDiHAPQjA8jjFG
         JOOAi8HRUqEVI41UFVFODu2vXDpvr7GVRfE7d5l2TIprRexAlgzXnko0mVxtQvh0vDvl
         rPv/aO5H5gS5MVGQK2RTF5uVZioMhSgyuKNOEEY0zU8foKP1W5+ANTPYng226a1uRIhG
         qAlUCtD2qCGzNLuBwtjcL7swqKrdn7N20AmsG8oXsu6rw5xRoDVPyFDKVaBUZTZGH2Em
         isQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748963476; x=1749568276;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ENZPVk28fyhK8QBCNn1dutmAmP0iQqTHH437t9XffpQ=;
        b=l2FwEJuZgntuQas87QS2P93qO2rm6qngGwldBgr9In5nLFu3NUpJrHjDVN/nBE9CrA
         6R7l1ZmF7Gzp4z9b/OnGE31DsPS7eEjzBH7c0CX7yT7YSxgW3iAwUuVrksaDCBo7cT00
         oVAbZok1s02JbF7wi38Tkom0Bo1V3E4RmaQK73HdmKRPBDYk5yiUhyOQWxcUDxOA5dhN
         b/3Z2eRknc2BJBtBAfcaPNDnBk/nkKPOEsyVKd0eR9Cwp+a9MifFwSN1bYXJA1iqfQGB
         74L0Kgw6P5/h3zTnYCKiAyAC+sRKXCBXkB+mk5tKFHGn7P58tPJDwgHILcnKaGGjVp/X
         +2kw==
X-Gm-Message-State: AOJu0Yx5OgU05yb4MfUTp7lm1dPw+rHukC23YL6+zV84OuUqqwZUrJ1y
	DhA5gHOMVzyMo7CzQ/G0xEyZoAVTAinmUbn9Tb2x2a5/fxoCG8xg0XHfJLSbsYTM9p2dXtRVn95
	4knvs
X-Gm-Gg: ASbGnctROQtUosIhoSPBTIwLp/eR+NqqWDnHa34vK8DtGCqDk3ICI59nSLuHI0ULNue
	+KLFw1HJ6ebeFRngDCiV432qHFy21fk3Oz2TmbYr+UGPa6ex0Dhm/4in3SbDM/loVy0CqpRIias
	ssgiwTih51i7b1MKBjUuh3ZFdwhqLE8zyAihQozYpRd91/tTAZj/d8uEJpDzd2uMJgzvX0o1R71
	DAzb7t14P3v8rHFjUdKBFOu09nwyuDfdi1yO246ooDUac1uRKspnfYYWc7FiABjpxuFKG8I1hVY
	ni9UvAs8hmDCCzFtnsmqIbCsl+HrYiHarFAn/iTEKJibCrsWeZOpTrVmmA==
X-Google-Smtp-Source: AGHT+IEojq6Uj4It+9Vg5kasvnyap8r0oWKnt4AYXmVYB+Efqs3lX4me8337zc/pHzWTDQY30P632g==
X-Received: by 2002:a05:6e02:1562:b0:3dc:787f:2bc4 with SMTP id e9e14a558f8ab-3dd99c2b6d6mr217730115ab.18.1748963475803;
        Tue, 03 Jun 2025 08:11:15 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3dd9353587fsm26617075ab.7.2025.06.03.08.11.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Jun 2025 08:11:15 -0700 (PDT)
Message-ID: <9dd8a125-5d15-4480-a86e-87ee96e238a4@kernel.dk>
Date: Tue, 3 Jun 2025 09:11:14 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring/uring_cmd: be smarter about SQE copying
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: io-uring <io-uring@vger.kernel.org>
References: <5d03de61-1419-443f-b3a4-e1f2ac2fe137@kernel.dk>
 <CADUfDZo=mbiz=0wxKSihhw9cxRdj5Uojh=XO0aPxKOZKtEc22A@mail.gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Content-Language: en-US
In-Reply-To: <CADUfDZo=mbiz=0wxKSihhw9cxRdj5Uojh=XO0aPxKOZKtEc22A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/3/25 9:05 AM, Caleb Sander Mateos wrote:
> On Sat, May 31, 2025 at 1:52?PM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> uring_cmd currently copies the SQE unconditionally, which was introduced
>> as a work-around in commit:
>>
>> d6211ebbdaa5 ("io_uring/uring_cmd: unconditionally copy SQEs at prep time")
>>
>> because the checking for whether or not this command may have ->issue()
>> called from io-wq wasn't complete. Rectify that, ensuring that if the
>> request is marked explicitly async via REQ_F_FORCE_ASYNC or if it's
>> part of a link chain, then the SQE is copied upfront.
>>
>> Always copying can be costly, particularly when dealing with SQE128
>> rings. But even a normal 64b SQE copy is noticeable at high enough
>> rates.
>>
>> Reported-by: Caleb Sander Mateos <csander@purestorage.com>
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>
>> ---
>>
>> diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
>> index 929cad6ee326..cb4b867a2656 100644
>> --- a/io_uring/uring_cmd.c
>> +++ b/io_uring/uring_cmd.c
>> @@ -181,29 +181,42 @@ void io_uring_cmd_done(struct io_uring_cmd *ioucmd, ssize_t ret, u64 res2,
>>  }
>>  EXPORT_SYMBOL_GPL(io_uring_cmd_done);
>>
>> +static void io_uring_sqe_copy(struct io_kiocb *req, struct io_uring_cmd *ioucmd)
>> +{
>> +       struct io_async_cmd *ac = req->async_data;
>> +
>> +       if (ioucmd->sqe != ac->sqes) {
>> +               memcpy(ac->sqes, ioucmd->sqe, uring_sqe_size(req->ctx));
>> +               ioucmd->sqe = ac->sqes;
>> +       }
>> +}
>> +
>>  static int io_uring_cmd_prep_setup(struct io_kiocb *req,
>>                                    const struct io_uring_sqe *sqe)
>>  {
>>         struct io_uring_cmd *ioucmd = io_kiocb_to_cmd(req, struct io_uring_cmd);
>> +       struct io_ring_ctx *ctx = req->ctx;
>>         struct io_async_cmd *ac;
>>
>>         /* see io_uring_cmd_get_async_data() */
>>         BUILD_BUG_ON(offsetof(struct io_async_cmd, data) != 0);
>>
>> -       ac = io_uring_alloc_async_data(&req->ctx->cmd_cache, req);
>> +       ac = io_uring_alloc_async_data(&ctx->cmd_cache, req);
>>         if (!ac)
>>                 return -ENOMEM;
>>         ac->data.op_data = NULL;
>>
>>         /*
>> -        * Unconditionally cache the SQE for now - this is only needed for
>> -        * requests that go async, but prep handlers must ensure that any
>> -        * sqe data is stable beyond prep. Since uring_cmd is special in
>> -        * that it doesn't read in per-op data, play it safe and ensure that
>> -        * any SQE data is stable beyond prep. This can later get relaxed.
>> +        * Copy SQE now, if we know we're going async. Drain will set
>> +        * FORCE_ASYNC, and assume links may cause it to go async. If not,
>> +        * copy is deferred until issue time, if the request doesn't issue
>> +        * or queue inline.
>>          */
>> -       memcpy(ac->sqes, sqe, uring_sqe_size(req->ctx));
>> -       ioucmd->sqe = ac->sqes;
>> +       ioucmd->sqe = sqe;
>> +       if (req->flags & (REQ_F_FORCE_ASYNC| REQ_F_LINK | REQ_F_HARDLINK) ||
>> +           ctx->submit_state.link.head)
> 
> To check my understanding, io_init_req() will set REQ_F_FORCE_ASYNC on
> any request with IOSQE_IO_DRAIN as well as all subsequent requests
> until the IOSQE_IO_DRAIN request completes? Looks like this condition

Correct

> should work then. I think you can drop REQ_F_LINK | REQ_F_HARDLINK,
> though; the initial request of a linked chain will be issued
> synchronously, and ctx->submit_state.link.head will be set for the
> subsequent requests.
> 
> I do share Pavel's concern that whether or not a request will be
> initially issued asynchronously is up to the core io_uring code, so it
> seems a bit fragile to make these assumptions in the uring_cmd layer.
> I think I would prefer either passing a bool issue_async to the
> ->prep() handler, or adding an optional ->prep_async() hook called if
> the initial issue may happen asynchronously.

Yes I do too, which is why I suggested we add a specific cold handler
for this kind of case. That leaves the core of io_uring calling it
appropriately, and eliminates the need for storing an sqe pointer. Which
would've been fine before resizing, but not a great idea to do now. I'll
do a v2 of this with that in mind, just haven't gotten around to it yet.

>> +               io_uring_sqe_copy(req, ioucmd);
>> +
>>         return 0;
>>  }
>>
>> @@ -259,6 +272,12 @@ int io_uring_cmd(struct io_kiocb *req, unsigned int issue_flags)
>>         }
>>
>>         ret = file->f_op->uring_cmd(ioucmd, issue_flags);
>> +       if (ret == -EAGAIN) {
>> +               io_uring_sqe_copy(req, ioucmd);
>> +               return ret;
>> +       } else if (ret == -EIOCBQUEUED) {
>> +               return ret;
>> +       }
>>         if (ret == -EAGAIN || ret == -EIOCBQUEUED)
>>                 return ret;
> 
> This if condition is always false now, remove it?

Heh yes, just forgot to remove those lines when adding the above change.

-- 
Jens Axboe

