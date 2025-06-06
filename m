Return-Path: <io-uring+bounces-8265-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id EA811AD0937
	for <lists+io-uring@lfdr.de>; Fri,  6 Jun 2025 23:01:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4B680189D861
	for <lists+io-uring@lfdr.de>; Fri,  6 Jun 2025 21:01:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54184323D;
	Fri,  6 Jun 2025 21:01:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="srWeza6V"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f49.google.com (mail-io1-f49.google.com [209.85.166.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93BCFA31
	for <io-uring@vger.kernel.org>; Fri,  6 Jun 2025 21:01:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749243687; cv=none; b=KnjpSU6BYF5x9Zv/MiX409p9m8FpzwTD1gn658/h8xdqYi8x4+0YzKNUhB7UA1+a7PQapXVHF5snfOuTgKPTPbkIB5ysM8ehT1PVC4ear3VSuGbGiJnFGrpJ5EHZJGmJ/0ooeApc8PDpDmBV/ffk6PGVD5YDB9ZfKqcuD1kGGwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749243687; c=relaxed/simple;
	bh=8wrJ3LY0knSBjA6gZL8AYNlwqGeoeYnEMP9zxt8QzxU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Q5RCX0mqH06HYnCZR2zG4UVRFDEUz1NeiAd3Xr+rSJXHlyCFiprqSvU8Tepq985xjcvioFf9+7fpBCG3zHdOgdIv/ePnrC8pugoMBTbQZ+c7GmWZs2Se9e0M6HOFzqDaHEvE98XPgjn/vb/8TSikqNWnWn0cENkZLTs+/cpyvfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=srWeza6V; arc=none smtp.client-ip=209.85.166.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f49.google.com with SMTP id ca18e2360f4ac-86d0c598433so77473439f.3
        for <io-uring@vger.kernel.org>; Fri, 06 Jun 2025 14:01:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1749243682; x=1749848482; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=G9NpriNM9lC9k7te8I6Rif5JBkhhKXw/eyh/+0a4xss=;
        b=srWeza6VVl7R1XD3O2ii+7RQRPWNzpnxyffPHPS5j/hlbhNHWRNyFMmHd/rBBU7pEG
         bqOMPnuQCAGQYNcok42B/8tsASEP+UtlOJ2VvOUxIcFQelRQ2S+o0WSnP7GauJjTF34Q
         4Uy82S52dVbMy22aQHAh5JfK09QeIib267Wh4EPuLxlA6ET5PmqdqPAnTiVXuNLUS+Tf
         Jv7WWE/axmDaMt6bhdi9j+sCv5cN72cbpSF9jeo3zspJ4eFB0b3TXBoaJ5le2wsjw1vJ
         YwsRi8xef1Ti56VxpPKQ1YAT0dS0G1l3FosISIjXxHIKaWBtykNWZujcA20YG1AMxjHC
         tufg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749243682; x=1749848482;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=G9NpriNM9lC9k7te8I6Rif5JBkhhKXw/eyh/+0a4xss=;
        b=PX6xcq+O62YON/hICGqnoiZx9r3R8Q0Qnliu3r+3QXDiEDWm27pjHR3FRSvqLfFY9W
         MdMdOfWdS8V7to724ossziCe2dVwQ7w172bJoVQ8XOmDhnxEDML+VoFYJjugfvm9yhSH
         /FJMzIHQL3ZEFN3YJYKaX1PusYcM9j/kv+0qba9ujXXyQ1ImK4UA9V5DOuVka5UQz1iR
         dV+aU7eaS9H9/3Ve5G1aH86EnyGO5msfg/vLGVI95piSa6n7mr1om4T57BJAnjSt7o2X
         CdYGzOz+YKMr+43RX5VbF4vbi8pXbSrmRI2yGVP8uH6kPAzOENakcg3RRHtQSguKDWXd
         0jjA==
X-Gm-Message-State: AOJu0YzclxbvQqb8vqx+0cGHsEmtIA0ezMK7V2nRkF5htnv03a907AXz
	aZIExKRy/wcw3u5hyLZdNtgMQuW6lPlYx/74MiP5XWZbRMzfxV4/5sV+g2egWvMeyy0=
X-Gm-Gg: ASbGncv8DzYdXeLss9x0UfmIN0MNQ1Fw4T24XXXK8z2iKUb5oQNHd4q+WGrQ0ubH7aD
	MhPzjSRYUHAbJ1tT3YStbxE6TEqyz1ZPNoxpdg+2f5689pf1TkOgB2PTalAmmqjewcCr9xvv2Yv
	JoTm62govf2Q/5XMGkohai9fEXS3DJ3l/abjRszuXH+zY37CRCGidrzKt2slkMNlg1WhQJCiE8H
	RoCULKIK+hCvXNIUI7l2opho1lLLvDinuBttW42w/dgE957X1w9wpTnUQoiwbbM9uT9e5IpyYQE
	qIF1lQO2VNL04bEW1Fsvv0u7TZkqzytfc6c4L28of3bPdX3x
X-Google-Smtp-Source: AGHT+IGyqHZEPi6+30r9bSH3HKhsQAKnmn/8/hkLeh17vxV1puM5b6H9/vmidMOaaBd1DuLGh0Jslw==
X-Received: by 2002:a05:6e02:1c0f:b0:3dd:a13c:b663 with SMTP id e9e14a558f8ab-3ddce495e82mr50990595ab.14.1749243682278;
        Fri, 06 Jun 2025 14:01:22 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3ddcf13f1d0sm5846805ab.1.2025.06.06.14.01.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Jun 2025 14:01:21 -0700 (PDT)
Message-ID: <d6f5846e-3137-4ab1-8d41-43b53d03ef46@kernel.dk>
Date: Fri, 6 Jun 2025 15:01:20 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/4] io_uring: add struct io_cold_def->sqe_copy() method
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: io-uring@vger.kernel.org
References: <20250605194728.145287-1-axboe@kernel.dk>
 <20250605194728.145287-3-axboe@kernel.dk>
 <CADUfDZq1LaxzeuTDqMjF0H8L5cC36-dqZRhBYEsGQDjZFrZycw@mail.gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Content-Language: en-US
In-Reply-To: <CADUfDZq1LaxzeuTDqMjF0H8L5cC36-dqZRhBYEsGQDjZFrZycw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/6/25 11:36 AM, Caleb Sander Mateos wrote:
> On Thu, Jun 5, 2025 at 12:47?PM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> Will be called by the core of io_uring, if inline issue is not going
>> to be tried for a request. Opcodes can define this handler to defer
>> copying of SQE data that should remain stable.
>>
>> Called with IO_URING_F_INLINE set if this is an inline issue, and that
>> flag NOT set if it's an out-of-line call. The handler can use this to
>> determine if it's still safe to copy the SQE. The core should always
>> guarantee that it will be safe, but by having this flag available the
>> handler is able to check and fail.
>>
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>> ---
>>  io_uring/io_uring.c | 32 ++++++++++++++++++++++++--------
>>  io_uring/opdef.h    |  1 +
>>  2 files changed, 25 insertions(+), 8 deletions(-)
>>
>> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
>> index 079a95e1bd82..fdf23e81c4ff 100644
>> --- a/io_uring/io_uring.c
>> +++ b/io_uring/io_uring.c
>> @@ -147,7 +147,7 @@ static bool io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
>>                                          bool cancel_all,
>>                                          bool is_sqpoll_thread);
>>
>> -static void io_queue_sqe(struct io_kiocb *req);
>> +static void io_queue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe);
>>  static void __io_req_caches_free(struct io_ring_ctx *ctx);
>>
>>  static __read_mostly DEFINE_STATIC_KEY_FALSE(io_key_has_sqarray);
>> @@ -1377,7 +1377,7 @@ void io_req_task_submit(struct io_kiocb *req, io_tw_token_t tw)
>>         else if (req->flags & REQ_F_FORCE_ASYNC)
>>                 io_queue_iowq(req);
>>         else
>> -               io_queue_sqe(req);
>> +               io_queue_sqe(req, NULL);
> 
> Passing NULL here is a bit weird. As I mentioned on patch 1, I think
> it would make more sense to consider this task work path a
> "non-inline" issue.

It very much _is_ a non-inline issue, the sqe being NULL is how the
->sqe_copy() would treat it. But it is a bit confusing in that the
callback would need to check

if (!sqe || !(flags & INLINE))

as the condition for whether or not the sqe is valid. Probably better to
make the INLINE flag dependent on sqe != NULL as well, and then that's
all the callback would need to check for.

-- 
Jens Axboe

