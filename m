Return-Path: <io-uring+bounces-6726-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6772AA4364E
	for <lists+io-uring@lfdr.de>; Tue, 25 Feb 2025 08:43:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 541383AE33E
	for <lists+io-uring@lfdr.de>; Tue, 25 Feb 2025 07:42:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5CE56433B3;
	Tue, 25 Feb 2025 07:43:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shopee.com header.i=@shopee.com header.b="F+nkqvDR"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1CBA17C79
	for <io-uring@vger.kernel.org>; Tue, 25 Feb 2025 07:43:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740469383; cv=none; b=jEkHW6zA1BNF5UxPVpN8P9o0FoNoCkpLvb9kNRG3ZcbXIcHSpxNi8JvuHjOuforZx4776DBFco8oxMvvxe4A7kpXIwkp1gwM6pticJ7eSaX1lMbfIWfoj6r9uuHgCe3f8ANKl+F7HwEPCyrLzLKEXzQzKRzq09H6QTl6fRQAaGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740469383; c=relaxed/simple;
	bh=IbYlX3PEQuVexzHhbqBghr9OI2n08wKQS1XCpeyjorI=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=W6TZAmNmbQfyMictlRYyXgMLwpqCAGoLFV093Vjaa122eTU5t8edAWKBtyDpddgyrIrjmAFQlSl1/+812kD+723+o2kQV3QthfSThaFShdxui0Ykw/ozYHN7w11rpbNIcmndWoRAX71RT0wS0xKFVMkftsmN8SYMj1Nnoy8S7lw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=shopee.com; spf=pass smtp.mailfrom=shopee.com; dkim=pass (2048-bit key) header.d=shopee.com header.i=@shopee.com header.b=F+nkqvDR; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=shopee.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shopee.com
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2230c74c8b6so9001265ad.0
        for <io-uring@vger.kernel.org>; Mon, 24 Feb 2025 23:43:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shopee.com; s=shopee.com; t=1740469381; x=1741074181; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=Y2/Bi/+um9TiTy0GDGglUry/DmFoADFyro0SU2c0Y80=;
        b=F+nkqvDRp7tgG9gyoO/pPfNhhDnuBQ3IvJe/TTG8cwPzcuRJGt1xrO0bRjgzXcKKEj
         WX8UcEeC36T+i3jq0z/sPGRR3ZudB5v/0GTU2a2A/Bk76uJneEgxkSoAU+Lo/En31Ji5
         Tcw/QR+oJUwDy2nUGPogqgWssTwxUH0mn2YdD8mFNrVGnhSp6HN35pGVbiQW7CadGjPV
         pEmNYsYN924KvZMpB5Y1QCiHmJchV6vMNcQTOsuwbQnYHVvqDY/l5GAIeQmf7J4pTASz
         1k3tBUMTyE8OR/MFSjiyzwfZt63sCneF+QzIt6V7Jkeit4FeO8S6M4w1W5Cq5TsYmMUl
         SATw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740469381; x=1741074181;
        h=content-transfer-encoding:subject:from:to:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Y2/Bi/+um9TiTy0GDGglUry/DmFoADFyro0SU2c0Y80=;
        b=Yf/ZAhD+bpDtaLvnM7OYb7DUTo3SmOnWTjYZkTiWjFnR8VTDQ72ekSlVRgUQz5LrtE
         K34WKbu67PAm5FIA8+moOAE2RVnig9KmU1di5JsYRhX/2xX8DC4U6rIpONcqONLJIRXC
         SdpBaZdu9htuao5g5NNlmsytsglbAAdiRpyhEOCWBQIP8nLekYDQwcvpzr07URgcYnMb
         /Tyc4HqLLr6+vU1pZMu9lgAa78oLSzpM9D8zUbqImPXZQD8IvHRIhfy/QE3aEyf3bZd8
         JfvSAyQWic/1mv0Hz+ectZK3X9Qur/jIuxHfhunJQFZo6gUSIds7WOdC6hLrprAGVK9R
         qoKg==
X-Forwarded-Encrypted: i=1; AJvYcCUvREw5A5N5PIh8payCr+HDfVZSBciwCtqWdtXbxqZXOS/pfvVufDXsD8MtTAmlQL2SIdDyeObyxg==@vger.kernel.org
X-Gm-Message-State: AOJu0Ywry9e50eeoewmx66DCJljBVE1a4hcfeLvQR5KXEOedO0Ec7pRc
	F3F7BLNUP3X+ij06/YMfrMQEXdMCU76dD9Cy0fYphd/HxmpLmuozAjUb3wo3kac=
X-Gm-Gg: ASbGnctSnqA7cFgl2+Xjatc3G5qBWHMpGcWwJeKx53Gszs6f6nKqdatXtV3+mz3hKmA
	V7FZSRs0wFosPG04GTY+qBMUA2HZ5ThUgxGuarRUd+X/EoA9eQP0OM5aBvtlaZ0xLa75sGKlh0v
	va+wBFLpIQxgKiotDk/le1nKeHZyLbVVve0SXqvctSVILVEqAf0j3/mfoKs6A8rXPktiP2ix++Z
	l+ztF+Mb7XZwN5/Bzr64JHXxavuM5669GlwG+Oej9rVcj4rm4s3+c4jk0+l1Xo8x+UYKJ+xJjTj
	RIJcyqQ3TRnfkuUcb+nlE6TEOi+aaEe4bptpZ+E=
X-Google-Smtp-Source: AGHT+IGPooWi5k55owu/1zq3Dx2BUeqGX+MWLBCsPeXe+/xkrCkl5y754dU0xILKnqlRW3HR3wZ6Jg==
X-Received: by 2002:a17:902:d4ce:b0:220:bd61:a337 with SMTP id d9443c01a7336-22307b595demr36974005ad.23.1740469380973;
        Mon, 24 Feb 2025 23:43:00 -0800 (PST)
Received: from [10.54.24.77] ([143.92.118.3])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2230a02159csm8014965ad.72.2025.02.24.23.42.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Feb 2025 23:43:00 -0800 (PST)
Message-ID: <3d67a75b-0819-4f0e-87b6-99dd836e88e9@shopee.com>
Date: Tue, 25 Feb 2025 15:42:56 +0800
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: Pavel Begunkov <asml.silence@gmail.com>, Jens Axboe <axboe@kernel.dk>,
 "Eric W. Biederman" <ebiederm@xmission.com>,
 Olivier Langlois <olivier@trillion01.com>, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org
From: Haifeng Xu <haifeng.xu@shopee.com>
Subject: io_uring : deadlock between io_uring and coredump
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi masters,
	In our production environment, we found many hung tasks.

	Thead A (exit_mm)
	...
		if (core_state) {
		struct core_thread self;

		mmap_read_unlock(mm);

		self.task = current;
		if (self.task->flags & PF_SIGNALED)
			self.next = xchg(&core_state->dumper.next, &self);
		else
			self.task = NULL;
		/*
		 * Implies mb(), the result of xchg() must be visible
		 * to core_state->dumper.
		 */
		if (atomic_dec_and_test(&core_state->nr_threads))
			complete(&core_state->startup);

		for (;;) {
			set_current_state(TASK_UNINTERRUPTIBLE);
			if (!self.task) /* see coredump_finish() */
				break;
			freezable_schedule();
		}
		__set_current_state(TASK_RUNNING);
		mmap_read_lock(mm);
	}
	...

	Thead B (coredump_wait)
	...
		if (core_waiters > 0) {
		struct core_thread *ptr;

		freezer_do_not_count();
		wait_for_completion(&core_state->startup);
		freezer_count();
		/*
		 * Wait for all the threads to become inactive, so that
		 * all the thread context (extended register state, like
		 * fpu etc) gets copied to the memory.
		 */
		ptr = core_state->dumper.next;
		while (ptr != NULL) {
			wait_task_inactive(ptr->task, 0);
			ptr = ptr->next;
		}
	...

	Thead C (io_worker_exit)
	...
		if (refcount_dec_and_test(&worker->ref))
		complete(&worker->ref_done);
		wait_for_completion(&worker->ref_done);
	...
		

	Thread A is waiting Thead B to finish core dump, but Thead B found that there is still one thread which doesn't 
	step into exit_mm() to dec core_state->nr_threads. The thead is Thread C, it has submitted a task_work (create_worker_cb)
	to Thread B and then wait Thread B to execute or cancel the work. So this leads to a deadlock.

	Our kernel vesion is stable 5.15.125, and the commit 1d5f5ea7cb7d ("io-wq: remove worker to owner tw dependency") is included.
	when the last io woker exits, it doesn't find any callback. Once scheduled out, it will invoke io_wq_worker_sleeping
	to submit a task work to the master thread. If the above guess is right, the commit 1d5f5ea7cb7d won't help.

	Can we cancel the io_uring requests before dumping core?

Thanks!
	




