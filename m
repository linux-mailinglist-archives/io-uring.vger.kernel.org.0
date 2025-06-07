Return-Path: <io-uring+bounces-8280-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C6550AD0D0C
	for <lists+io-uring@lfdr.de>; Sat,  7 Jun 2025 13:16:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 40CAF18931F3
	for <lists+io-uring@lfdr.de>; Sat,  7 Jun 2025 11:17:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15EF6218AD1;
	Sat,  7 Jun 2025 11:16:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="ZyFwAtGD"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f52.google.com (mail-io1-f52.google.com [209.85.166.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC63420D4E3
	for <io-uring@vger.kernel.org>; Sat,  7 Jun 2025 11:16:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749295007; cv=none; b=lZHsYuBzKSKlexOcSP64155QnTPqfZyw7Fbn6svpUxOqEx/HbG74tBL1o7vk8cOiSKyHm1ZUIT5VxrTv+zyJWuQrDg9gzNa+awppn2SaW4NdI6j4DrMMYhtCMuxzDayLKJbHGixCd4n6dG8qrRZyGH7++ZOqnb7tmpIWMO5QuYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749295007; c=relaxed/simple;
	bh=HsSh9Px86fmtilbvzvdF3EZ8sLLs1eerbydCqBn2m2c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GV4FzranPv9CyXxTAJkUyRKz9OGF9XFLqtMZLItA5V/lMMNgDV29n9XJXu243OPnQgoKp7ScXix3+9KNcLM+vp/2l54X0GryuLxw6lyXB9SgrNtAYeOsCUPHOd0P7nxTzJCzujacAwT3g7y6Nls1206Pv+xd4K4TAXLCRwh13FE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=ZyFwAtGD; arc=none smtp.client-ip=209.85.166.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f52.google.com with SMTP id ca18e2360f4ac-8723a232750so256301739f.1
        for <io-uring@vger.kernel.org>; Sat, 07 Jun 2025 04:16:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1749295001; x=1749899801; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6+fv+VxiPPdnUoibaG8YqzN011wU+7ut+7GZYmILV6Y=;
        b=ZyFwAtGD6LuQcplBWAUWbcqyl60Y9ns150piuwZr+crOa+1n6fy1nXZucg5o5keYol
         U6upDSFz0/Vo6mYe6bvaHgKQbfwW3+5AhYa8W9wcmjtg83Z9fAgmVocatShKsLGuSuFV
         EhRZDyvQTpaT+z7nq84zqTs7qSUIWoZufqc3tQEGdsspWu7U9RVRqOGTCayf39c789p6
         dHZsujLJSjv4fhbT+beG5DiuispsttpjH0x1T3d4aFwdCHwtdMmBPINW7in9bTxRoY0d
         /0fhYpWNmBLpevTHAj38VqEHHJGi5v8imQcV4A4YPROHpgIwkOrqD+TzZ3FDowxF6g9L
         A3SA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749295001; x=1749899801;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6+fv+VxiPPdnUoibaG8YqzN011wU+7ut+7GZYmILV6Y=;
        b=WbpM3G/E9oKR0wz84ja+2dSJWQsd1/ZHM5woQx17sClCPHiUdA10kCoBvOW+xszFmX
         9Vdso57fUUtP4zndJTf08zrmc9DGTsDrfK44bmXZuSPuk+KJ+wkkE8FsWthamTxVLTSD
         ua++zUJBO4n0wjdaFOWnAwEBwb4Em3FrJPBminuOsBdGAifWSfx+EN+6mdM9pmR6AZ4D
         Q2oATgEd+k9gNBotBSnEc1zqMQ+1hFEVJpPZtJ8I6tuZKYW6/YUe+LoOKGi3GcQ29qtu
         lsWez8/tNkwlaRHjLLo2Htv0AdRnvt/OidEefE9CbVBNJTZAjfoqgTaFhF7bqNZ/nxOR
         y01g==
X-Gm-Message-State: AOJu0YzzjvOuAhn8tcKjkizr7VqfaD+yzyAqmPNQTbEpLMGhb9JAD0V9
	Nd93MTsdBalRb0O0BysbLuHMRfr8EfoycX+t/VNgEjjFfd1HngsYlgAJHDSN39qWm+8=
X-Gm-Gg: ASbGncuDdyFshVucrJhQjRBmtgd0XTgNgEnUdEFQ0ssEQIdz0iUmvdrPUg0KZJ2e3dI
	ZXvMnXPuQGuIulncZCyy4vpRLQEoClNgSk0eErXR5arWxncNn/DjMrKvi39An1tRpSMlyTunrsC
	mYcqYLz+mofvXYNWa4bHMcWWkQa/7oA9szNMA/OeS77hINuOVwWWlmPFOdymVucPEEj4mC+K+nH
	+GvqQsZSYtxyBMiF5WfSBLOpRaU6QLWGT9DqbgL/Yp77T5dBOzEgyaCBhLWJm3ii31gW9C2EYz3
	eHYYmHy7IunYYOK9u1QTEz2Of2x2MijMoLpD+K8T+XsJND2vNm3QwE5JTGHtjFXmDLS8Ag==
X-Google-Smtp-Source: AGHT+IGwr+7KS+nc6edKpc7KPDI+/In+EwsQFsrOVblG3CqpkHhN/DbCA+K3DtPuHfxZ0/3go/Fwyw==
X-Received: by 2002:a05:6e02:219e:b0:3dc:8667:3426 with SMTP id e9e14a558f8ab-3ddce46e8d1mr71230425ab.17.1749295001526;
        Sat, 07 Jun 2025 04:16:41 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3ddcf13ec9esm9038085ab.4.2025.06.07.04.16.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 07 Jun 2025 04:16:40 -0700 (PDT)
Message-ID: <950a9907-6820-4c2f-9901-8454b418e884@kernel.dk>
Date: Sat, 7 Jun 2025 05:16:39 -0600
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
References: <20250606215633.322075-1-axboe@kernel.dk>
 <20250606215633.322075-3-axboe@kernel.dk>
 <CADUfDZq45a9K9SHEeTTFU5vpbbkFtOhjpW_ovAiV_Y-Xbdy=uA@mail.gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Content-Language: en-US
In-Reply-To: <CADUfDZq45a9K9SHEeTTFU5vpbbkFtOhjpW_ovAiV_Y-Xbdy=uA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/6/25 6:50 PM, Caleb Sander Mateos wrote:
> On Fri, Jun 6, 2025 at 2:56?PM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> Will be called by the core of io_uring, if inline issue is not going
>> to be tried for a request. Opcodes can define this handler to defer
>> copying of SQE data that should remain stable.
>>
>> Only called if IO_URING_F_INLINE is set. If it isn't set, then there's a
>> bug in the core handling of this, and -EFAULT will be returned instead
>> to terminate the request. This will trigger a WARN_ON_ONCE(). Don't
>> expect this to ever trigger, and down the line this can be removed.
>>
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>> ---
>>  io_uring/io_uring.c | 25 ++++++++++++++++++++++---
>>  io_uring/opdef.h    |  1 +
>>  2 files changed, 23 insertions(+), 3 deletions(-)
>>
>> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
>> index 0f9f6a173e66..9799a31a2b29 100644
>> --- a/io_uring/io_uring.c
>> +++ b/io_uring/io_uring.c
>> @@ -1935,14 +1935,31 @@ struct file *io_file_get_normal(struct io_kiocb *req, int fd)
>>         return file;
>>  }
>>
>> -static void io_queue_async(struct io_kiocb *req, int ret)
>> +static int io_req_sqe_copy(struct io_kiocb *req, unsigned int issue_flags)
>> +{
>> +       const struct io_cold_def *def = &io_cold_defs[req->opcode];
>> +
>> +       if (!def->sqe_copy)
>> +               return 0;
>> +       if (WARN_ON_ONCE(!(issue_flags & IO_URING_F_INLINE)))
> 
> I'm pretty confident that every initial async path under
> io_submit_sqe() will call io_req_sqe_copy(). But I'm not positive that
> io_req_sqe_copy() won't get called *additional* times from non-inline
> contexts. One example scenario:
> - io_submit_sqe() calls io_queue_sqe()
> - io_issue_sqe() returns -EAGAIN, so io_queue_sqe() calls io_queue_async()
> - io_queue_async() calls io_req_sqe_copy() in inline context
> - io_queue_async() calls io_arm_poll_handler(), which returns
> IO_APOLL_READY, so io_req_task_queue() is called
> - Some other I/O to the file (possibly on a different task) clears the
> ready poll events
> - io_req_task_submit() calls io_queue_sqe() in task work context
> - io_issue_sqe() returns -EAGAIN again, so io_queue_async() is called
> - io_queue_async() calls io_req_sqe_copy() a second time in non-inline
> (task work) context
> 
> If this is indeed possible, then I think we may need to relax this
> check so it only verifies that IO_URING_F_INLINE is set *the first
> time* io_req_sqe_copy() is called for a given req. (Or just remove the
> IO_URING_F_INLINE check entirely.)

Yes, the check is a bit eager indeed. I've added a flag for this, so
that we only go through the IO_URING_F_INLINE check and ->sqe_copy()
callback once.

>> +               return -EFAULT;
>> +       def->sqe_copy(req);
>> +       return 0;
>> +}
>> +
>> +static void io_queue_async(struct io_kiocb *req, unsigned int issue_flags, int ret)
>>         __must_hold(&req->ctx->uring_lock)
>>  {
>>         if (ret != -EAGAIN || (req->flags & REQ_F_NOWAIT)) {
>> +fail:
>>                 io_req_defer_failed(req, ret);
>>                 return;
>>         }
>>
>> +       ret = io_req_sqe_copy(req, issue_flags);
>> +       if (unlikely(ret))
>> +               goto fail;
>> +
>>         switch (io_arm_poll_handler(req, 0)) {
>>         case IO_APOLL_READY:
>>                 io_kbuf_recycle(req, 0);
>> @@ -1971,7 +1988,7 @@ static inline void io_queue_sqe(struct io_kiocb *req, unsigned int extra_flags)
>>          * doesn't support non-blocking read/write attempts
>>          */
>>         if (unlikely(ret))
>> -               io_queue_async(req, ret);
>> +               io_queue_async(req, issue_flags, ret);
>>  }
>>
>>  static void io_queue_sqe_fallback(struct io_kiocb *req)
>> @@ -1986,6 +2003,8 @@ static void io_queue_sqe_fallback(struct io_kiocb *req)
>>                 req->flags |= REQ_F_LINK;
>>                 io_req_defer_failed(req, req->cqe.res);
>>         } else {
>> +               /* can't fail with IO_URING_F_INLINE */
>> +               io_req_sqe_copy(req, IO_URING_F_INLINE);
>>                 if (unlikely(req->ctx->drain_active))
>>                         io_drain_req(req);
>>                 else
>> @@ -2201,7 +2220,7 @@ static inline int io_submit_sqe(struct io_ring_ctx *ctx, struct io_kiocb *req,
>>                 link->last = req;
>>
>>                 if (req->flags & IO_REQ_LINK_FLAGS)
>> -                       return 0;
>> +                       return io_req_sqe_copy(req, IO_URING_F_INLINE);
> 
> I still think this misses the last req in a linked chain, which will
> be issued async but won't have IO_REQ_LINK_FLAGS set. Am I missing
> something?

Indeed, we need to call this before that section. Fixed that up too,
thanks.

-- 
Jens Axboe

