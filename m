Return-Path: <io-uring+bounces-12416-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SOfOCz4Xn2n3YwQAu9opvQ
	(envelope-from <io-uring+bounces-12416-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 25 Feb 2026 16:37:34 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id B9E80199C20
	for <lists+io-uring@lfdr.de>; Wed, 25 Feb 2026 16:37:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 8C1093003629
	for <lists+io-uring@lfdr.de>; Wed, 25 Feb 2026 15:36:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9AAC61917FB;
	Wed, 25 Feb 2026 15:36:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="zl/n8HXF"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f174.google.com (mail-oi1-f174.google.com [209.85.167.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CDD134EF05
	for <io-uring@vger.kernel.org>; Wed, 25 Feb 2026 15:36:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772033806; cv=none; b=R6N97ywJuVwy6AiDuuQgninxImyS3nFME/zHziUZaMN6cOROI9ymQ8f8kmh2vl8ZqOKLBOzrDaEAGKzT2YmwDUD1ieZpcJVzlaMTKfEvjAMOTN+t0HRt6nkjSE7HrydErEE4vYCwtPjJuatoOhwi6rR73T9/9kcHMyR/odxiL74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772033806; c=relaxed/simple;
	bh=YO0S8JwFwqNukjjO7ZmIc4foZ/E1RL1QCOzRnHKkvII=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=Adj5GpP5Lk4xLeRqyKeIRz7fA5DneWp4LsZYIu+RbcwvXpt1eLM+G2IOF3Dh67rOM+gHt4VO8wGS5r4bVgSPs/Yjhca3WPXvD8WRn8PcMzq0J3SWzDdtDXRpWitQioVaKP92chzJPeQ6SUqOW6MUQTHXb3egfbROtKLrbeSl8dE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=zl/n8HXF; arc=none smtp.client-ip=209.85.167.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f174.google.com with SMTP id 5614622812f47-46392972257so4871032b6e.2
        for <io-uring@vger.kernel.org>; Wed, 25 Feb 2026 07:36:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1772033802; x=1772638602; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+CbDK+LodaAxXWcfkScwYdYiS/bly3D06QFJQmp5oYg=;
        b=zl/n8HXFr9jrTrGT+cz9Ul67EdS2qEaCHeZIWo1UmW/N8vGs+315DQKhEMBtrLfzOW
         7eD3MV8N7QIrtOAuf6+jX5sn9byEBfntOy97V5PJpz9o+IIekECR2Iz6I8mIftJMR9Kq
         6fW9Yjbw4gtouagR3pfPKC/gFMUuk2sJHBW0Re/Kb1Puk/FoC9MRy/JE1ywRGS6ZYmSa
         0IlnDfiAaB+otNOV4AtmHBoAjnE+nPw9fGqMsrKSRrSXY5daqJDlQ+F/T625IybQbhvI
         Lk6TvCFrhF83ER1tHG6G1gHUMt4LhC2hh9PaLKwTqEwVbw1BTiv9J1N9TMrBf4quT6Jk
         KgcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772033802; x=1772638602;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=+CbDK+LodaAxXWcfkScwYdYiS/bly3D06QFJQmp5oYg=;
        b=o6Q//Ptc2/wAFPt4Siaa6sUv2OWbL6RdjB+nqNa7LcMave411nPXjC7xYiv82qs37g
         6AB+/W64vf26cxLCGPWYFussEeK1wcTayTIsMbCl6w4DDuP2DsUkMjC3TVnywjv3pa5E
         dn9LnBM2p8n3Z0j08lB341ZkVetqavMU410nqthpzhIrZAi09Q8uXD3vXPCCIhI/EIml
         KWcsxYZU8zLkaYvuBDfrYO3zmQeJz80ShmNhCNJGumn01v1mDDWj/HxjGKOm1VJocYDB
         XMcqXB2hP3zjhEy288TR3eK49ceKi2qRiJ4IMtn8KQzJg0Jm3ouQuRKSv6H1fX1DL+jh
         9rUg==
X-Gm-Message-State: AOJu0YypBVTOAM8FsxsFlCCJZL0LS4zsTLaxfkIEsVOZukEFl7YG93zu
	HAHv4NZay6K6us3fT3Ep08adTPCrSNX3wMzccWAdaKDSToGp7yjQyNSMAYDd0gQ4PY2b9b2jkNu
	AArgVoA8=
X-Gm-Gg: ATEYQzzybYYPOwhkx/VX4KSLO6yoQfpFbgB4fKGIJMpmjhs9Jc/Wr4Fmt2vIMrP0/dk
	m3/9LY3L9/tk0AfFtHs/jiAmIXHsKOyjJa+PMALnJ4+/7KzFKq4T4j4+/bpSX3Qu3dz8s4aGPg/
	xF0VSVrbZzr9C+GUITKxi3zwPaWTG/rSTxNekG0UaJuTBB42DG7hy9dIJWdUiq3cyitAOiYZd5n
	d9i/JC9pNBFSTrlVez+9D9AblLa52VB/pOtVGxKBvbDNXfSCNwdMGkHT5wV/cDgotdGau53E4KM
	QcdxsHPySxfU8MTxMl1yZaB0ucVPJFZMuB5HKdGMvwfjFhyLMxhCJVeee3BeKW1mbNW2ik/RbyM
	peF67wWl/K5odvxDN7G5NK3ZzaW8uyK6w1MlXpG684/e50w75aFte8tSdda1IHqnHc2IwxMebQl
	Xiygvojhtn6HCYUo6CLJ7okvCSQ61YxcsFzzigwjzdp4kv3+xmw7gOa1OrU0qT9xMrlNk9BwKEZ
	mx+
X-Received: by 2002:a05:6808:6c93:b0:450:bcc7:18d7 with SMTP id 5614622812f47-4644612e131mr9340317b6e.2.1772033802422;
        Wed, 25 Feb 2026 07:36:42 -0800 (PST)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-4644a17a11csm9334203b6e.11.2026.02.25.07.36.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Feb 2026 07:36:41 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
Cc: Keith Busch <kbusch@kernel.org>
In-Reply-To: <cover.1772015321.git.asml.silence@gmail.com>
References: <cover.1772015321.git.asml.silence@gmail.com>
Subject: Re: (subset) [PATCH v2 0/2] timeout immediate arg
Message-Id: <177203380125.841173.10233113241761456152.b4-ty@kernel.dk>
Date: Wed, 25 Feb 2026 08:36:41 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_HAS_DN(0.00)[];
	TAGGED_FROM(0.00)[bounces-12416-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	FREEMAIL_TO(0.00)[vger.kernel.org,gmail.com];
	DMARC_NA(0.00)[kernel.dk];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	RCPT_COUNT_THREE(0.00)[3];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,kernel-dk.20230601.gappssmtp.com:dkim]
X-Rspamd-Queue-Id: B9E80199C20
X-Rspamd-Action: no action


On Wed, 25 Feb 2026 10:35:56 +0000, Pavel Begunkov wrote:
> Allow the user to pass the timeout value inside the SQE instead of
> pointing to a timespec, people asked for it as it makes user space
> simpler. More details description is in Patch 2.
> 
> v2: ditto for timeout updates
> 
> Pavel Begunkov (2):
>   io_uring/timeout: READ_ONCE sqe->addr
>   io_uring/timeout: immediate timeout arg
> 
> [...]

Applied, thanks!

[1/2] io_uring/timeout: READ_ONCE sqe->addr
      commit: 85f6c439a69afe4fa8a688512e586971e97e273a

Best regards,
-- 
Jens Axboe




