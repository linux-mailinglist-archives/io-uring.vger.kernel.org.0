Return-Path: <io-uring+bounces-1104-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6FECF87EA3B
	for <lists+io-uring@lfdr.de>; Mon, 18 Mar 2024 14:39:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 251481F22FB8
	for <lists+io-uring@lfdr.de>; Mon, 18 Mar 2024 13:39:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF9A347F7E;
	Mon, 18 Mar 2024 13:39:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DabtLnii"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EADAF2D605;
	Mon, 18 Mar 2024 13:39:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710769144; cv=none; b=H1yTMPwDhTRolFr3FL6NVKT+l5al728CvgqQTc2YHFQqeFjdHkAGS24CPMn0RXmp/vburrNYuW9uv0BDyKDTPO7zZhDI/V5szUa7PnbXqXL1+I8UAccf/PCEsXLTz1NhXRejm8B6bmqr5Qe3U9p+2B9r3d1EZrKynFTtLKBSvT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710769144; c=relaxed/simple;
	bh=J/rmBMCkirwgLwFEI7PUbVNSUtCuP1vgDBgK5fnmoik=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=ctboi4gdOYmYLtntSRPv3+1ZEihqc3Gb/c46RaT0P7PiQfEe1KfFBT/n5H6AkswEGwfZ4D19TbTHKQeNIJtGP1yIzk8eFdEMdgfCozUu2hOrcPfomz3Hf1cVgnU8lYbfB+Y6pL2ISQQTAVSmiiGh1sRPntEFfv+G4bOb+qIdir4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DabtLnii; arc=none smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-568107a9ff2so5156484a12.3;
        Mon, 18 Mar 2024 06:39:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710769141; x=1711373941; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BXPf5P7bZxEIvp1uqSPX1bqHyj8zpD6Mu7CRQm23nJI=;
        b=DabtLniiQx+HhLlGsR7dIYIOZlKL9te5IfEeLnXQ6vE4TmsO0LMbN5avUQhuJtkSdK
         xHgt+pZAT7Je5EL6XAmWSZffLdplbbxHlF7aP21FexX6dXVsYkTTDnLP6Z551Bopv5Yp
         IdaToi7jRrdxhPFRm6/uSLDc1YJAI5LeLK03Z2+dz97XzCSX1iISdZ6xLOsYXIiZvLVQ
         j/oyyVihRNSod/B/A8D05ePv7cWJGpfjilAb37gcFYiJTvXAcL3XchT/iurS91ZRuYDT
         Ymh+uEHWhe+4IVZg0cSIZH6YJd/bwddmiT4EBEXd3VPc5MTMFohiyiqqFoxbexWQxCQR
         f6Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710769141; x=1711373941;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BXPf5P7bZxEIvp1uqSPX1bqHyj8zpD6Mu7CRQm23nJI=;
        b=wXbm4mG/RIQpA/ab5/D7WcA4lzMhkNVxggMJ1HSIaLxwdG4sxFSrPh3oSmNV/o+RZl
         2qtL6bsPc6u1SqfcJ++J+EI1JR6LRDWJjJO7l1s7+iTF1QSNuJ21wA4dYls9sGOcJGG4
         JEmUpBg1soCKOTtf2AepZkm3hEHZwDbPKPGk5Sx/QQrfHNxVcfL6dw4JXkKRJWaMlxSv
         KmnWBdvjF1Nf5nurB2TreZFw18QMVAfYngCSsumGSJv+CJTgFVP0FBxf6EvTVkHx8vXk
         BOXPO2txKHzB4RdbLhZrdqG7dqTmvcfEImoyPzHlic00uvxWbM2EQLXBWhlBekQkmoQM
         lbWg==
X-Forwarded-Encrypted: i=1; AJvYcCVyyNeFpFCbAghTCoAKa9elsZz+SqJWjyS4TAjegX6c+yJPnRl3GDuctXdzF4Jfulg3BF7DXMG1PBguOEpiQEJjzRr6QqRs4P1f09Y=
X-Gm-Message-State: AOJu0YxoRcSFa3PuuH2YXBu+Ul1IqoUlZ2THbCl4AStrqBdpOflBCsi+
	Puh9uHe84sarrwerlx8lcWjkDJgCEKSWmjquWOSjhR67XEP8LHC3
X-Google-Smtp-Source: AGHT+IEpHPe5s/OEC+5u0A9PHQWCvYGpGLSIU8N9vVLh9GukQnLT2REfMfturGVh8srxV6itpo0iYA==
X-Received: by 2002:a05:6402:5306:b0:568:a9f3:b3fb with SMTP id eo6-20020a056402530600b00568a9f3b3fbmr6681990edb.8.1710769141088;
        Mon, 18 Mar 2024 06:39:01 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:310::2181? ([2620:10d:c092:600::1:429a])
        by smtp.gmail.com with ESMTPSA id g38-20020a056402322600b0056b8cc4d6a7sm47915eda.43.2024.03.18.06.38.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Mar 2024 06:38:59 -0700 (PDT)
Message-ID: <2095ac3e-5e5f-4ea2-a906-a924a25c121a@gmail.com>
Date: Mon, 18 Mar 2024 13:37:23 +0000
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
In-Reply-To: <61b29658-e6a9-449f-a850-1881af1ecbee@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 3/18/24 12:52, Pavel Begunkov wrote:
> On 3/18/24 08:16, Ming Lei wrote:
>> On Mon, Mar 18, 2024 at 12:41:50AM +0000, Pavel Begunkov wrote:
>>> uring_cmd implementations should not try to guess issue_flags, just use
>>> a newly added io_uring_cmd_complete(). We're loosing an optimisation in
>>> the cancellation path in ublk_uring_cmd_cancel_fn(), but the assumption
>>> is that we don't care that much about it.
>>>
>>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>>> Link: https://lore.kernel.org/r/2f7bc9fbc98b11412d10b8fd88e58e35614e3147.1710514702.git.asml.silence@gmail.com
>>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>> ---
>>>   drivers/block/ublk_drv.c | 18 ++++++++----------
>>>   1 file changed, 8 insertions(+), 10 deletions(-)
>>>
>>> diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
>>> index bea3d5cf8a83..97dceecadab2 100644
>>> --- a/drivers/block/ublk_drv.c
>>> +++ b/drivers/block/ublk_drv.c
>>> @@ -1417,8 +1417,7 @@ static bool ublk_abort_requests(struct ublk_device *ub, struct ublk_queue *ubq)
>>>       return true;
>>>   }
>>> -static void ublk_cancel_cmd(struct ublk_queue *ubq, struct ublk_io *io,
>>> -        unsigned int issue_flags)
>>> +static void ublk_cancel_cmd(struct ublk_queue *ubq, struct ublk_io *io)
>>>   {
>>>       bool done;
>>> @@ -1432,15 +1431,14 @@ static void ublk_cancel_cmd(struct ublk_queue *ubq, struct ublk_io *io,
>>>       spin_unlock(&ubq->cancel_lock);
>>>       if (!done)
>>> -        io_uring_cmd_done(io->cmd, UBLK_IO_RES_ABORT, 0, issue_flags);
>>> +        io_uring_cmd_complete(io->cmd, UBLK_IO_RES_ABORT, 0);
>>>   }
>>>   /*
>>>    * The ublk char device won't be closed when calling cancel fn, so both
>>>    * ublk device and queue are guaranteed to be live
>>>    */
>>> -static void ublk_uring_cmd_cancel_fn(struct io_uring_cmd *cmd,
>>> -        unsigned int issue_flags)
>>> +static void ublk_uring_cmd_cancel_fn(struct io_uring_cmd *cmd)
>>>   {
>>>       struct ublk_uring_cmd_pdu *pdu = ublk_get_uring_cmd_pdu(cmd);
>>>       struct ublk_queue *ubq = pdu->ubq;
>>> @@ -1464,7 +1462,7 @@ static void ublk_uring_cmd_cancel_fn(struct io_uring_cmd *cmd,
>>>       io = &ubq->ios[pdu->tag];
>>>       WARN_ON_ONCE(io->cmd != cmd);
>>> -    ublk_cancel_cmd(ubq, io, issue_flags);
>>> +    ublk_cancel_cmd(ubq, io);
>>
>> .cancel_fn is always called with .uring_lock held, so this 'issue_flags' can't
>> be removed, otherwise double task run is caused because .cancel_fn
>> can be called multiple times if the request stays in ctx->cancelable_uring_cmd.
> 
> I see, that's exactly why I was asking whether it can be deferred
> to tw. Let me see if I can get by without that patch, but honestly
> it's a horrible abuse of the ring state. Any ideas how that can be
> cleaned up?

I assume io_uring_try_cancel_uring_cmd() can run in parallel with
completions, so there can be two parallel calls calls to ->uring_cmd
(e.g. io-wq + cancel), which gives me shivers. Also, I'd rather
no cancel in place requests of another task, io_submit_flush_completions()
but it complicates things.

Is there any argument against removing requests from the cancellation
list in io_uring_try_cancel_uring_cmd() before calling ->uring_cmd?

io_uring_try_cancel_uring_cmd() {
	lock();
	for_each_req() {
		remove_req_from_cancel_list(req);
		req->file->uring_cmd();
	}
	unlock();
}

-- 
Pavel Begunkov

