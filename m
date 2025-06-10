Return-Path: <io-uring+bounces-8292-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C68B9AD3979
	for <lists+io-uring@lfdr.de>; Tue, 10 Jun 2025 15:39:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A40A316C572
	for <lists+io-uring@lfdr.de>; Tue, 10 Jun 2025 13:35:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1340923ABA1;
	Tue, 10 Jun 2025 13:35:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Q3iBNE5j"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f54.google.com (mail-ot1-f54.google.com [209.85.210.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6206D23ABBF
	for <io-uring@vger.kernel.org>; Tue, 10 Jun 2025 13:35:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749562506; cv=none; b=dc6yDaJtAT950t4tmihTOGzIeDzQLxZy+d8hQ14MR+O9PgBetMsyhOrxHvlmtvz4/U8WLx98h3hEDE3yK/ecupUuorW93ZXb/MryEEJQ+Xo9LGoCsH68f+7V/p9GWu7gQgf6vijrwXOBtxMWP27Y4xw5mO/4DbZ8x0VWjn1les0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749562506; c=relaxed/simple;
	bh=WzoPV9NXhuO3D8e0HGCzeQpzXSu/zrsWRmvETPzH4yY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=g57te6pqrtzJZ46TQB6if1iqxzsY9D0sUKWeeClNInxIYRd093dhl5gkJcclEl1QA7QbvugP4fdPD0zPyXGw22AHse2oALjEOBpA2DFewrM7l3Y8azrHURjmZjmcK4DMTw9D6KNNzN8vxGa7Tb3p3mAq9E8Ebqym/gG0RDiTobM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Q3iBNE5j; arc=none smtp.client-ip=209.85.210.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f54.google.com with SMTP id 46e09a7af769-72c14138668so1402806a34.2
        for <io-uring@vger.kernel.org>; Tue, 10 Jun 2025 06:35:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1749562502; x=1750167302; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Nk7s+Xm2x0Je27mdhEaaInIsWLaCbPe0vuG/LuHm/yg=;
        b=Q3iBNE5jpPAaTOuJdXh/cwZRFOFpR4c5lNzouTavrUdNpgEizN+/Jri2XWXD00CmkO
         lbcl3KN/ObLdpUjqTr3SyNns2L2tIIUrQsl+ulILB/w7EZhrfDCgZ3LnfR+khuYJBUTa
         tSXYGsq5Sip7vCWN+evWZiq9iu97aC7x8EJOrWR7fD3VT/UNfITlXV/ljvywrr0wVat/
         otQUQmm3i3quRwpSqb/FhttLamJ8MjjGcyiTJ6J2b5iV04S0T/h12Cgv/uNzN1gQhMgl
         /kmRUWh0YaZ1gzYw7zkh58yXqj/n9wkhhIlGa2fTA/iEcTLRtONuZQQbnKvp8do9CO01
         t9Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749562502; x=1750167302;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Nk7s+Xm2x0Je27mdhEaaInIsWLaCbPe0vuG/LuHm/yg=;
        b=k28yJpnLPogROisIgQZXvJ9ON6hyQbM0xVYXt1Vg9mDQNyeYyIVwPfKq1Bz6HPMsNS
         s7TdNoTySEQwkOUtdJtrSezD80AcyEi5vLTIAzCBFQFgAVTz4AfCj5d+N2U3e+suhHPs
         J2BkZmmQKUm3VmnBYmnpPVeBZToWWf0lsDsHc4IW5V8vnSPgTB4O0qoKVoS5h6T+BMbq
         YanWskHhHMW9vUzfXFTJfQXBpHVLh2bSt6HGBeUkvfpQx314s7KRldbG6Gi+EWfoB38t
         cfJYymzf9jSi6pI5WF7CUxuXyV92r5nywfWD65oH21IILGLAGwKFLs0OpBKcDO4k/6Iy
         slXw==
X-Gm-Message-State: AOJu0Yy++TTmNALB+MG3SKuoep6msuxjJxJhc2haxy7HYcf15ISyuAW6
	DzQ8YfwublhTX4shC4sNtYxkaakYhFrD2+fQS81bKTmwVG2hIk7/rt4++zPmNAYlSb0=
X-Gm-Gg: ASbGncuTZxgTqNcV47/h2toY/qZRLlJYLpdoPBPiubLt7fMDUxY6xco7a1vQzwdIzP0
	2NTv7LjSVMhu+t2JNrOWiJ38XlIaN9Tgeo+t6HnjzZpLhcgGXlB5ejYc1i4dVVfoudVEjzMbzyq
	hvYGvLLpn6js4BQIRjmAzGhnniGhFGOM/IMVSfgaE8cP67OA2d/qqSEJH4ZtuZUlacYzSabfD+4
	tOt9BNPiYBI5Eb1EpwEGGbRT4S+/u/WtIp84XZCRqmWSnNvtnTZDDOGt83uwrmXi1BDashaXaQq
	DGXc0IIBabA8gwJT9U9DaDWl06Ztkymaa0bQYY2GwuHI7Z9N+MXL/bP7+Ok=
X-Google-Smtp-Source: AGHT+IEy1rlRi8HYD3/oTSreGy2qM+h4UTjTXlC9Jgoc/NHT0RJbGDVEyXiN9z0QfYIni2dOYSwh7w==
X-Received: by 2002:a05:6830:d13:b0:735:afba:ba9a with SMTP id 46e09a7af769-73888df6dfdmr12123975a34.12.1749562502386;
        Tue, 10 Jun 2025 06:35:02 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-500df3f60f8sm2303156173.26.2025.06.10.06.35.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Jun 2025 06:35:01 -0700 (PDT)
Message-ID: <0a4ec7ff-c9d2-4423-a7fc-9f1b190623a3@kernel.dk>
Date: Tue, 10 Jun 2025 07:35:01 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/4] io_uring/uring_cmd: implement ->sqe_copy() to avoid
 unnecessary copies
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: io-uring@vger.kernel.org
References: <20250609173904.62854-1-axboe@kernel.dk>
 <20250609173904.62854-5-axboe@kernel.dk>
 <CADUfDZr=EhcUuJuMC5-VW0hVCNUNwtjNbb19fkApdD7j2aSGMQ@mail.gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CADUfDZr=EhcUuJuMC5-VW0hVCNUNwtjNbb19fkApdD7j2aSGMQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 6/9/25 3:54 PM, Caleb Sander Mateos wrote:
> On Mon, Jun 9, 2025 at 10:39 AM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> uring_cmd currently copies the full SQE at prep time, just in case it
>> needs it to be stable. However, for inline completions or requests that
>> get queued up on the device side, there's no need to ever copy the SQE.
>> This is particularly important, as various use cases of uring_cmd will
>> be using 128b sized SQEs.
>>
>> Opt in to using ->sqe_copy() to let the core of io_uring decide when to
>> copy SQEs. This callback will only be called if it is safe to do so.
>>
>> Reviewed-by: Caleb Sander Mateos <csander@purestorage.com>
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>> ---
>>  io_uring/opdef.c     |  1 +
>>  io_uring/uring_cmd.c | 21 ++++++++++++---------
>>  io_uring/uring_cmd.h |  1 +
>>  3 files changed, 14 insertions(+), 9 deletions(-)
>>
>> diff --git a/io_uring/opdef.c b/io_uring/opdef.c
>> index 6e0882b051f9..287f9a23b816 100644
>> --- a/io_uring/opdef.c
>> +++ b/io_uring/opdef.c
>> @@ -759,6 +759,7 @@ const struct io_cold_def io_cold_defs[] = {
>>         },
>>         [IORING_OP_URING_CMD] = {
>>                 .name                   = "URING_CMD",
>> +               .sqe_copy               = io_uring_cmd_sqe_copy,
>>                 .cleanup                = io_uring_cmd_cleanup,
>>         },
>>         [IORING_OP_SEND_ZC] = {
>> diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
>> index e204f4941d72..a99dc2f9c4b5 100644
>> --- a/io_uring/uring_cmd.c
>> +++ b/io_uring/uring_cmd.c
>> @@ -205,17 +205,20 @@ int io_uring_cmd_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>>         if (!ac)
>>                 return -ENOMEM;
>>         ac->data.op_data = NULL;
>> +       ioucmd->sqe = sqe;
>> +       return 0;
>> +}
>> +
>> +void io_uring_cmd_sqe_copy(struct io_kiocb *req)
>> +{
>> +       struct io_uring_cmd *ioucmd = io_kiocb_to_cmd(req, struct io_uring_cmd);
>> +       struct io_async_cmd *ac = req->async_data;
>>
>> -       /*
>> -        * Unconditionally cache the SQE for now - this is only needed for
>> -        * requests that go async, but prep handlers must ensure that any
>> -        * sqe data is stable beyond prep. Since uring_cmd is special in
>> -        * that it doesn't read in per-op data, play it safe and ensure that
>> -        * any SQE data is stable beyond prep. This can later get relaxed.
>> -        */
>> -       memcpy(ac->sqes, sqe, uring_sqe_size(req->ctx));
>> +       /* already copied, nothing to do */
>> +       if (ioucmd->sqe == ac->sqes)
> 
> REQ_F_SQE_COPY should prevent this from ever happening, right? Could
> we make it a WARN_ON()? Or drop it entirely?

It should in the current form of the patchset, now that the copy is
gone inside uring_cmd and we have the SQE_COPIED flag. I'll make it
a WARN_ON_ONCE() instead.

-- 
Jens Axboe


