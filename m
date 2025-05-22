Return-Path: <io-uring+bounces-8070-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 97196AC0AB1
	for <lists+io-uring@lfdr.de>; Thu, 22 May 2025 13:35:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C569F1BC0E9B
	for <lists+io-uring@lfdr.de>; Thu, 22 May 2025 11:35:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8EF4ADF58;
	Thu, 22 May 2025 11:35:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="XnfAXtJi"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f45.google.com (mail-io1-f45.google.com [209.85.166.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 763261C32
	for <io-uring@vger.kernel.org>; Thu, 22 May 2025 11:35:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747913703; cv=none; b=isldCR4sdp+c4PZ+sw/w91s+jvsanGhP3FQdy2LGqHr3EJuAOS0V/m3pIZxFmUaEus2H8VKv6raswGLzaQp2rWat2a+D/tORRHcbCZ5m8weTvvE05RelA8YDhksJEXOZ2as0YfEOnEYj3VhXoFcfq66FIxNWSuT4jU0CFToowwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747913703; c=relaxed/simple;
	bh=M+1fBZX/ceR+2GnSdK9hGTw+rCAEtdMzJOFRMNPEQfM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LS29KYDTsPaF1FSk6ocNw4xx20baNYJQu0+0n+YAB+bECQFluSHfwMcNlbMLTmmBELIJPB4jlEvIIKDWTzsiturHeNejsOmfMJ9Tl+zByPiXj9MFCywSfdXK3rLRpyBeeaZzPDwgCgYdkzN6lWqbNfQrLbDkuh+wnDprPlVeO5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=XnfAXtJi; arc=none smtp.client-ip=209.85.166.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f45.google.com with SMTP id ca18e2360f4ac-86a52889f45so118767039f.3
        for <io-uring@vger.kernel.org>; Thu, 22 May 2025 04:35:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1747913699; x=1748518499; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=I9svoeSLe8BB4WjKOJ1VT+IJ+0NN4bnyMdvWVmm3244=;
        b=XnfAXtJi9VSun93Jl9vac0l70KAhqSXfWYaxxjwKhqi6Ii/BSdVIveenwLzJoAeI52
         qkFoho0J8o14sqF02ohEmSF5qsfjmmaUrWLCcRoOERhsG2fVBYFpGSRttpuViXDpRYia
         zjm3pN2Gt43RvwzXHC3rbjI3iLJ7LBIIP6pDlD/CZ0GUaNQyONVnx3w4KGNTbeCAbsGt
         6elEuVQ/76/RXMY7fNRYpD4L/4X8vi5HVGdS7Gmjkk3BPO2AgFyukANmc8/KbYoDlnu3
         +S5l5zLF+XIKYXdTtgWcuA0KbmCEomq91RJ7vda+3CSIfJXObWXCw/g+4/135/R3fAAo
         gkyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747913699; x=1748518499;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=I9svoeSLe8BB4WjKOJ1VT+IJ+0NN4bnyMdvWVmm3244=;
        b=A2udAyoRlUxWXrK0QkCwW0Wkb2l9e7KXHTfrxpwO8j+gXM+yexZf3pLATEGlzVPXAm
         W31FA05TgmjvztuUVFfGlH1P8pHeuIc3bSm6PDHi8NB9Ew5WyWCdWXX9LRWH7WVwJHAL
         7Un0fGdYCWVaGmQZ6Um88NIZ0NMUZvaiPsKtTmMVa0dN2XDQ4kVMyGKeaCDwllFWU77M
         LASnnK8qMibYkvldtXzwbVwz0vJjPtOflYp3DvvDf5EYF5WjlxWoT9T1IkjlRv/SA7xP
         yOc2OdIIRiJpd6VFwK7vLNDZSVF0V/0fQneEToUHkbTkkHpXMTPvpBBa5lx5lQKJDhgu
         x2KA==
X-Gm-Message-State: AOJu0YyXkbipulftUokeR6FckYyCWFBwwqmu8M6hCpu0xP+OS2i4mBLE
	Z28PbGhG6y+Ouhw3mcUtUkG2wdJhavNQW+LXLrWrwXWlLae8VedcELkAPFnQrNQcKo8=
X-Gm-Gg: ASbGncszmt1n2R+VO938neR9JmLSA4bx6TUXxzDi2O8s6v7wDvSCQm0ME3il+/pkQ4F
	qCzGM9crO1mZGqRKKv4Rme1v5nXMLCbpf5SkIh0NBkHjzndSaGcJAjhvJnsXO2cOH/NPRbqOlPZ
	IckyLpJO4Xw+dCPxsVh9LGCc7oHrzUh+lDFcE8X1pnCh7w1JktALG7FmgRhgt3SAfmBhg0GLAnv
	cxVJYQuh5F2HbVMXQkg2L5siSgdBiyBVcQdNoG/FU2BiYdZY2hB2qAGk8tkVg5psMNfD7IQ5yqT
	VRL1lSL7L7X4oA5KCDmQ6P4zZ/urViRepIdEa52XHBBHwytENMV8jAe4xUw=
X-Google-Smtp-Source: AGHT+IENdiAZi0+lKxPAEZ+oG4gaKy10MBmWLdm6mf2eXZFAZDAY+UDTIqIDzILKGupO2B9W8Lx5tg==
X-Received: by 2002:a05:6602:3a08:b0:861:7d39:d4d3 with SMTP id ca18e2360f4ac-86a2316d84cmr3352497739f.3.1747913699372;
        Thu, 22 May 2025 04:34:59 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4fbcc38a534sm3136608173.24.2025.05.22.04.34.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 May 2025 04:34:58 -0700 (PDT)
Message-ID: <b8cd8947-76fa-4863-a1f6-119c6d086196@kernel.dk>
Date: Thu, 22 May 2025 05:34:58 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] io_uring: fix io worker thread that keeps creating
 and destroying
To: Fengnan Chang <changfengnan@bytedance.com>, asml.silence@gmail.com
Cc: io-uring@vger.kernel.org, Diangang Li <lidiangang@bytedance.com>
References: <20250522090909.73212-1-changfengnan@bytedance.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20250522090909.73212-1-changfengnan@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/22/25 3:09 AM, Fengnan Chang wrote:
> When running fio with buffer io and stable iops, I observed that
> part of io_worker threads keeps creating and destroying.
> Using this command can reproduce:
> fio --ioengine=io_uring --rw=randrw --bs=4k --direct=0 --size=100G
> --iodepth=256 --filename=/data03/fio-rand-read --name=test
> ps -L -p pid, you can see about 256 io_worker threads, and thread
> id keeps changing.
> And I do some debugging, most workers create happen in
> create_worker_cb. In create_worker_cb, if all workers have gone to
> sleep, and we have more work, we try to create new worker (let's
> call it worker B) to handle it.  And when new work comes,
> io_wq_enqueue will activate free worker (let's call it worker A) or
> create new one. It may cause worker A and B compete for one work.
> Since buffered write is hashed work, buffered write to a given file
> is serialized, only one worker gets the work in the end, the other
> worker goes to sleep. After repeating it many times, a lot of
> io_worker threads created, handles a few works or even no work to
> handle,and exit.
> There are several solutions:
> 1. Since all work is insert in io_wq_enqueue, io_wq_enqueue will
> create worker too, remove create worker action in create_worker_cb
> is fine, maybe affect performance?
> 2. When wq->hash->map bit is set, insert hashed work item, new work
> only put in wq->hash_tail, not link to work_list,
> io_worker_handle_work need to check hash_tail after a whole dependent
> link, io_acct_run_queue will return false when new work insert, no
> new thread will be created either in io_wqe_dec_running.
> 3. Check is there only one hash bucket in io_wqe_dec_running. If only
> one hash bucket, don't create worker, io_wq_enqueue will handle it.

Nice catch on this! Does indeed look like a problem. Not a huge fan of
approach 3. Without having really looked into this yet, my initial idea
would've been to do some variant of solution 1 above. io_wq_enqueue()
checks if we need to create a worker, which basically boils down to "do
we have a free worker right now". If we do not, we create one. But the
question is really "do we need a new worker for this?", and if we're
inserting hashed worked and we have existing hashed work for the SAME
hash and it's busy, then the answer should be "no" as it'd be pointless
to create that worker.

Would it be feasible to augment the check in there such that
io_wq_enqueue() doesn't create a new worker for that case? And I guess a
followup question is, would that even be enough, do we always need to
cover the io_wq_dec_running() running case as well as
io_acct_run_queue() will return true as well since it doesn't know about
this either?

I'll take a closer look at this later today, but figured I'd shoot some
questions your way first...

-- 
Jens Axboe

