Return-Path: <io-uring+bounces-5697-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6579EA0339E
	for <lists+io-uring@lfdr.de>; Tue,  7 Jan 2025 00:53:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C9ED61885DC5
	for <lists+io-uring@lfdr.de>; Mon,  6 Jan 2025 23:53:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91A9F1DFE00;
	Mon,  6 Jan 2025 23:53:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Fr4dki3r"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f49.google.com (mail-io1-f49.google.com [209.85.166.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3D441E0B82
	for <io-uring@vger.kernel.org>; Mon,  6 Jan 2025 23:53:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736207619; cv=none; b=oXCeBUEqLtZjpSjHu2MeGQWjMyKfz767hUTvqX6yaUsUGIm5cvj32vv4BoQC+z/jSYsVESezVGKvjOk3OKJd4QczKMDso7FjDKDbWb0AFZTHM/4BTi7FtKdPUrH3kdk3PDg0N89sC51DVLW5U9ebG0sI7XapLpLrn7Bq1gC0X4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736207619; c=relaxed/simple;
	bh=Wb3OdZFLmnZnFUwoRgj3YiMm1u7kxAi4aDTIMT13GOA=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=U6Ret+91+YWp4v+IlrLgi1ddlHqjM0WmtyAxCOscOASoADVYda664sDJwtWYh5kInIiUn9HINJWfJvzM+mvltqCcCq8MUBKMrDocy5Voual3QqNiNBUaAlGPuFeSwfUvB2++RLRDjjXApDOXLjFEn9nON9UfhHysaqc+r+0tBwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Fr4dki3r; arc=none smtp.client-ip=209.85.166.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f49.google.com with SMTP id ca18e2360f4ac-844d7f81dd1so649447239f.2
        for <io-uring@vger.kernel.org>; Mon, 06 Jan 2025 15:53:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1736207614; x=1736812414; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=rvTapTW4ETdeXwSoJK4RfLwuJxjruwd1CqFJJrP4yOE=;
        b=Fr4dki3rgx6KxZZbFyfzDJ5g/4ryXtPhfmWVeJgDfPCVeT1S01CdnFDaQwLCvPMw2p
         fkSGILJZLvb3LJkthGR1s0iJZMVcFMVb6bEFVECY3Igw3MmqppBDQCC86dkwIlk85I2t
         bbjh/J6UWk7GKH/oJglMH0OJAbn6/8JPQpBP2OYc9yqsMUT4vBq4nEzVyOdKVhi+47m0
         IE7FI1T8pz2meerqKhqCcwacrITtGHJUGqYKms4vc1f1mTo2xzeUBxcBkrXzhmkHiYpu
         qXoFwedRi4Fer+KsiwyRHCxUKiNbDcRjLkX56XRXahKdJvPQhtiNGZTveMMSa9eCq75n
         E+3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736207614; x=1736812414;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rvTapTW4ETdeXwSoJK4RfLwuJxjruwd1CqFJJrP4yOE=;
        b=GzllYcxfER8HS3QyFBh/4fKJa/mqfZ2/GoJ+/ZFWeMhLe0p3goZTOe1eQG81ewxhUr
         TUcqBeqwZ6TPApU7IOubZPKRbp45Ua/avxF7S1YWK2oh0S0NiUKwomPbwkVq01vIVc1U
         pCvMj11QMxdswLQTsa0ANjc2MwlZWUuKYZcDVD1kjsfR12WnBXrQjkEPD7zvxQam6MFH
         WmJO37CYL5TG5CxKP0gp31E5puI2m/6dKOFtrjTo4nIaVI5ILLGIPNmKkBikkUGypyFL
         w9QvSy8Oyjq6vLnxlTGcRzbEYqJKBSxKwEJ/Lzz16xSHlCDeHFfZj1GHPkQfGnntHrWs
         e8Mg==
X-Forwarded-Encrypted: i=1; AJvYcCUuSh63pM3j0hl1mw6+o0ce/G5LNyeEUSpA8zBP2eTli0f5wvuJ02o4yDB2faTSJtIRsuhdKJtVWg==@vger.kernel.org
X-Gm-Message-State: AOJu0YwSp1GqI2ZOzVEhMZi9MhYGEcDe3W5EqKtqSOD9JpnuryN+9fqS
	ashL9YwgoxKEHdisKoCl77kZttZMnFr56Q37WdyYsiB6vAdMfyWNsrkvcZUGS09ecD1auh1qaC0
	6
X-Gm-Gg: ASbGncs6EdETNEmllMUBL3TZGAQYzn5mOTg3/XWI0878KTEt/rPAHXD6e7kb7tOKc62
	3GeZF1n3+2sJyGpf7QNvf7Y+5kZGeIoMtRKPlEmFY5RcALz8TUIyNn2ko6UPJfnWP6/feNDTffK
	4oXCAd6QSW3ZvoroRNlqjLc+TZaV7v5xdU7aTXCDBRbgdLTbH1QXUMftH8E2scI9oi3KwJUYbjr
	El30BjzspYghuEAeNNNZYhCJDHxOF+ac+DC8mWrz+JNhG0qlIw8Pg==
X-Google-Smtp-Source: AGHT+IH9n/cbeZUxf/iDxQqpciUap/WS5y038QbuaKCy5yMvjxN9vBLSpRn0cOzPVeIet6GbtBzjPg==
X-Received: by 2002:a05:6602:168c:b0:83a:a305:d9ee with SMTP id ca18e2360f4ac-8499e6a6afdmr5950869039f.12.1736207614634;
        Mon, 06 Jan 2025 15:53:34 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4e68bf4f36bsm9331186173.32.2025.01.06.15.53.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Jan 2025 15:53:34 -0800 (PST)
Message-ID: <fe2c7e3c-9cec-4f30-8b9b-4b377c567411@kernel.dk>
Date: Mon, 6 Jan 2025 16:53:33 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Bug? CQE.res = -EAGAIN with nvme multipath driver
To: "Haeuptle, Michael" <michael.haeuptle@hpe.com>,
 "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
References: <DS7PR84MB31105C2C63CFA47BE8CBD6EE95102@DS7PR84MB3110.NAMPRD84.PROD.OUTLOOK.COM>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <DS7PR84MB31105C2C63CFA47BE8CBD6EE95102@DS7PR84MB3110.NAMPRD84.PROD.OUTLOOK.COM>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/6/25 1:03 PM, Haeuptle, Michael wrote:
> Hello,
> 
> I?m using the nvme multipath driver (NVMF/RDMA) and io-uring. When a
> path goes away, I sometimes get a CQE.res = -EAGAIN in user space.
> This is unexpected since the nvme multipath driver should handle this
> transparently. It?s somewhat workload related but easy to reproduce
> with fio.
> 
> The multipath driver uses kblockd worker to re-queue the failed NVME
> bios
> (https://github.com/torvalds/linux/blob/13563da6ffcf49b8b45772e40b35f96926a7ee1e/drivers/nvme/host/multipath.c#L126).
> The original request is ended. 
> 
> When the nvme_requeue_work callback is executed, the blk layer tries
> to allocate a new request for the bios but that fails and the bio
> status is set to BLK_STS_AGAIN
> (https://elixir.bootlin.com/linux/v6.12.6/source/block/blk-mq.c#L2987).
> The failure to allocate a new req seems to be due to all tags for the
> queue being used up.
> 
> Eventually, this makes it into io_uring?s io_rw_should_reissue and
> hits same_thread_group(req->tctx->task, current) = false (in
> https://github.com/torvalds/linux/blob/13563da6ffcf49b8b45772e40b35f96926a7ee1e/io_uring/rw.c#L437).
> As a result, CQE.res = -EAGAIN and thrown back to the user space
> program.
> 
> Here?s a stack dump when we hit same_thread_group(req->tctx->task,
> current) = false 
> 
> kernel: [237700.098733]  dump_stack_lvl+0x44/0x5c
> kernel: [237700.098737]  io_rw_should_reissue.cold+0x5d/0x64
> kernel: [237700.098742]  io_complete_rw+0x9a/0xc0
> kernel: [237700.098745]  blkdev_bio_end_io_async+0x33/0x80
> kernel: [237700.098749]  blk_mq_submit_bio+0x5b5/0x620
> kernel: [237700.098756]  submit_bio_noacct_nocheck+0x163/0x370
> kernel: [237700.098760]  ? submit_bio_noacct+0x79/0x4b0
> kernel: [237700.098764]  nvme_requeue_work+0x4b/0x60 [nvme_core]
> kernel: [237700.098776]  process_one_work+0x1c7/0x380
> kernel: [237700.098782]  worker_thread+0x4d/0x380
> kernel: [237700.098786]  ? _raw_spin_lock_irqsave+0x23/0x50
> kernel: [237700.098791]  ? rescuer_thread+0x3a0/0x3a0
> kernel: [237700.098794]  kthread+0xe9/0x110
> kernel: [237700.098798]  ? kthread_complete_and_exit+0x20/0x20
> kernel: [237700.098802]  ret_from_fork+0x22/0x30
> kernel: [237700.098811]  </TASK>
> 
> Is the same_thread_group() check really needed in this case? The
> thread groups are certainly different? Any side effects if this check
> is being removed?

It's their for safety reasons - across all request types, it's not
always safe. For this case, absolutely the check does not need to be
there. So probably best to ponder ways to bypass it selectively.

Let me ponder a bit what the best approach would be here...

-- 
Jens Axboe

