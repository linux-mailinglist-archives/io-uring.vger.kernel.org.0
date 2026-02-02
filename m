Return-Path: <io-uring+bounces-12021-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cO8PNiLBgGl3AgMAu9opvQ
	(envelope-from <io-uring+bounces-12021-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 02 Feb 2026 16:22:10 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 7CC8DCE1F1
	for <lists+io-uring@lfdr.de>; Mon, 02 Feb 2026 16:22:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 60AD93012512
	for <lists+io-uring@lfdr.de>; Mon,  2 Feb 2026 15:21:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1762B37B40E;
	Mon,  2 Feb 2026 15:21:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="TTxOf1Ix"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f68.google.com (mail-oa1-f68.google.com [209.85.160.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6529F37AA86
	for <io-uring@vger.kernel.org>; Mon,  2 Feb 2026 15:21:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.68
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770045687; cv=none; b=ZbgRz/9YlOAoe+C38STp9CLAJJd1P7BE4OqIrtkZxYD3+BwIpuW64VmNAoMInDn4hZTw6+HxDswJghkYYc0W2zcu+6e7zoDrvu+LiJf675qSCH7wABz2V+88efJg6f6VOIXCWUtnurtsowyrFfTURuE3FzSwBvO2rhINlYvSvXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770045687; c=relaxed/simple;
	bh=dGYzGKAo13wXuMhpdlIV0DoI/r7fbVlNuaIOOtMCSE0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TV7L+FBwsvTp1uFiJgoMQPAMGYsfvvyT/E2MircWQGJXe+R/EGHSR15ynNGteHDVxgh79Ow2ljHhmaHIH9sL3B63kaBoSXnm0sMFo4PRKUt8nTGXzPi5pW6vBqORmvjWS5O5sjqvMiEcb+CYCbaefpw82hFXoFxdYfiTZIk2oEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=TTxOf1Ix; arc=none smtp.client-ip=209.85.160.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f68.google.com with SMTP id 586e51a60fabf-40427db1300so2924309fac.0
        for <io-uring@vger.kernel.org>; Mon, 02 Feb 2026 07:21:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1770045684; x=1770650484; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tNBPHZopW0bu6uQC/ufqmGalw6uYyMmVRj0C4lk3dj0=;
        b=TTxOf1Ixa/HJqgkPBwlANdfVY4Ce+4VRwu/B+BQv4W5qDyOv/G+KALfeyMA3qXDXmX
         xTjtH8LZvcrIHxZplJNCFfBOv6B35WlmRy5zOdjaBX6X/r1gEKnzmmOssvciyHzZ7FpR
         rWxB5fAW10rCryHQIRGz8ZnyPuYmjcCg/rdg8iQEvKwbFaWZtplJL6fwDs89VuK4JJBs
         c7aYJgKNFux5JrC6Yi88NjJqJrI5tu4xeTSVDoePK7EuBrUPwGLDtxxqBTQ6HjBo9iXZ
         95x9bg/4xgKZlkHgLgJ+PeR8bItIs7nE7KRSGqdkESnfZnvhUqngIRMMlRjnm6LPA2eH
         Ghzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770045684; x=1770650484;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tNBPHZopW0bu6uQC/ufqmGalw6uYyMmVRj0C4lk3dj0=;
        b=IFhqKuYzCGGlXCyMbB2ZumSpCG8bfjtPoXPZmwHnMEHjb1+fWYCMmRU04mzyhyMPb9
         9lMOwLrElNVl/KcXAsS2bRWn79NMKMPHgtMb/aUHBTj9YuhFBtX4DEzwsMCzyMo8q0o8
         v9sBETMRnWmwDuNrrZ9iJCTszruh/haQcenJmzxSo9lb3MZJgJDR/XdRwyr+SBj4MLCS
         rB6/F3jNmu6nJRYv83gEuTzrXzO8zWJyh4WIfemzedXkoeM+gSu0j8QQByBdo9s5iHrf
         0V3fWqSwVWiW4ALhcukkeXClht0CbfWzGOtDbiBNCitZvrs+H1JF2AqpN9jLmDAXgzW3
         vEJg==
X-Forwarded-Encrypted: i=1; AJvYcCXVc6TzqxAel2mE2GO13lSDxvRDvV/+qxfYiQdN5aGCQtdAxnzrI111JzKCiFYZgSOmffhqNrHEuQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YyhwARN9XbvevxmrCr8TF682PnqRz4tqN3RgWGoGCfZlAFDfJPA
	toZMXVyqvBZsxZMdA3v7w3Klls8m9zfrbBEUIMrNqQKwROv2i0N7bDYPxRyoHBL+0F0=
X-Gm-Gg: AZuq6aKWplJGWQWzN3mwAE4vrxgeG1xx5zUUPquT1tev8qc480i+f26IIh3JjJZ6xWe
	/6q2pY46ajfPXIX0T3PdIOBG5jWCYBWd5cNmg+3yi1+CimqsTP9T5lwnQK0hmIBF5yzrGF6qtLX
	AA6AXTb/q0f1fZy+nfmzHcCyF33xwTyX/Ri5Et8sLXOtoG9RC74x9GKOnDpzeJ4qflRWEJA2TWt
	a/8QdLNgJ2LWxH6+azkmlEDVwmphis9Dhm88CAunKNZewOAlexEX9r+FgQzDyfQAQno9IjEl9o5
	kGG0fzwALVbtGiuE5QEPmDL9nO3jdIXDfx0P+eEXeLE900Ta7Nudb1eDe8IzA1ktmUY6EYsuSpf
	KiMlaKzksjx76R9ZkHqwDgHlt1obBGadXRvutgLcnhr9mhDREQsXnJsP9Se7UYsc7o4zDbEtpyl
	0EcWdwqHxPd/3fiEUUrLHTc1WmbI0hBlnblLSKovEYPeILyTuE9RQ848XKTDniviK9S1FJBtpi+
	sGj9gFG
X-Received: by 2002:a05:6870:380b:b0:404:16c6:40b3 with SMTP id 586e51a60fabf-409a6d12163mr6602487fac.37.1770045684242;
        Mon, 02 Feb 2026 07:21:24 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-409570f63b4sm11986517fac.3.2026.02.02.07.21.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Feb 2026 07:21:23 -0800 (PST)
Message-ID: <17d76cc4-b186-4290-9eb4-412899c32880@kernel.dk>
Date: Mon, 2 Feb 2026 08:21:22 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 0/2] io_uring/io-wq: let workers exit when unused
To: Li Chen <me@linux.beauty>
Cc: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260202143755.789114-1-me@linux.beauty>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20260202143755.789114-1-me@linux.beauty>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[gmail.com,vger.kernel.org];
	DMARC_NA(0.00)[kernel.dk];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12021-lists,io-uring=lfdr.de];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	RCPT_COUNT_THREE(0.00)[4];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kernel-dk.20230601.gappssmtp.com:dkim,kernel.dk:mid]
X-Rspamd-Queue-Id: 7CC8DCE1F1
X-Rspamd-Action: no action

On 2/2/26 7:37 AM, Li Chen wrote:
> io_uring uses io-wq to offload regular file I/O. When that happens, the kernel
> creates per-task iou-wrk-<tgid> workers (PF_IO_WORKER) via create_io_thread(),
> so the worker is part of the process thread group and shows up under
> /proc/<pid>/task/.
> 
> io-wq shrinks the pool on idle, but it intentionally keeps the last worker
> around indefinitely as a keepalive to avoid churn. Combined with io_uring's
> per-task context lifetime (tctx stays attached to the task until exit), a
> process may permanently retain an idle iou-wrk thread even after it has closed
> its last io_uring instance and has no active rings.
> 
> The keepalive behavior is a reasonable default(I guess): workloads may have
> bursty I/O patterns, and always tearing down the last worker would add thread
> churn and latency. Creating io-wq workers goes through create_io_thread()
> (copy_process), which is not cheap to do repeatedly.
> 
> However, CRIU currently doesn't cope well with such workers being part of the
> checkpointed thread group. The iou-wrk thread is a kernel-managed worker
> (PF_IO_WORKER) running io_wq_worker() on a kernel stack, rather than a normal
> userspace thread executing application code. In our setup, if the iou-wrk
> thread remains present after quiescing and closing the last io_uring instance,
> criu dump may hang while trying to stop and dump the thread group.
> 
> Besides the resource overhead and surprising userspace-visible threads, this is
> a problem for checkpoint/restore. CRIU needs to freeze and dump all threads in
> the thread group. With a lingering iou-wrk thread, we observed criu dump can
> hang even after the ring has been quiesced and the io_uring fd closed, e.g.:
> 
>   criu dump -t $PID -D images -o dump.log -v4 --shell-job
>   ps -T -p $PID -o pid,tid,comm | grep iou-wrk
> 
> This series is a kernel-side enabler for checkpoint/restore in the current
> reality where userspace needs to quiesce and close io_uring rings before dump.
> It is not trying to make io_uring rings checkpointable, nor does it change what
> CRIU can or cannot restore (e.g. in-flight SQEs/CQEs, SQPOLL, SQE128/CQE32,
> registered resources). Even with userspace gaining limited io_uring support,
> this series only targets the specific "no active io_uring contexts left, but an
> idle iou-wrk keepalive thread remains" case.
> 
> This series adds an explicit exit-on-idle mode to io-wq, and toggles it from
> io_uring task context when the task has no active io_uring contexts
> (xa_empty(&tctx->xa)). The mode is cleared on subsequent io_uring usage, so the
> default behavior for active io_uring users is unchanged.
> 
> Tested on x86_64 with CRIU 4.2.
> With this series applied, after closing the ring iou-wrk exited within ~200ms
> and criu dump completed.

Applied with the mentioned commit message and IO_WQ_BIT_EXIT_ON_IDLE test
placement.

-- 
Jens Axboe


