Return-Path: <io-uring+bounces-12023-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id eEcDOPDCgGl3AgMAu9opvQ
	(envelope-from <io-uring+bounces-12023-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 02 Feb 2026 16:29:52 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 881FACE3F1
	for <lists+io-uring@lfdr.de>; Mon, 02 Feb 2026 16:29:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 8A687305F3D6
	for <lists+io-uring@lfdr.de>; Mon,  2 Feb 2026 15:21:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 799D337C102;
	Mon,  2 Feb 2026 15:21:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="aiYrJAju"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f45.google.com (mail-ot1-f45.google.com [209.85.210.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDA3D37B3FD
	for <io-uring@vger.kernel.org>; Mon,  2 Feb 2026 15:21:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770045699; cv=none; b=RYYDEK9eJ63Nni/m/NzU9FKYrb6lRXhrsET8wOs6uWqyWpw6z59F7AGwU04/WGbc1+Bc9gnv1S7GTWTbPEq7sM3NNqVvx1OUleBCf4kHYxqlqHjxESuT86FAQEMh2NGl8VylR0/uvJHhjkGI51QzcDnX06hoFZtAq2FZWgL0LBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770045699; c=relaxed/simple;
	bh=8Q88YVpVN3f3KDYwz/Bw/XL91VtecrW4X14Cb3DAFDU=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=p5kdOPRN3stM6ukghe96yvcRUxHjzEilHL+u5c5BrbZEUSf64jCxPYYjsYGk7VmbX7RMwLb8T41B5FPBMINnV78tv0J97EImca+F5cN9KsDe1EiczOG84rTAhoEtsVsXpk0G/MiSGA6FkTAncx5JN28U+ZNL21l8R8GbIQNEUdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=aiYrJAju; arc=none smtp.client-ip=209.85.210.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f45.google.com with SMTP id 46e09a7af769-7d19bfe1190so3415775a34.1
        for <io-uring@vger.kernel.org>; Mon, 02 Feb 2026 07:21:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1770045697; x=1770650497; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uLiAs6xCi3OF/LJRXhhuk0xFYAWHNsdktdbtat4hSjg=;
        b=aiYrJAjueiUgJ/jQVBQdnW7Du4jBRFhi/+UzWwaLimkR6qgXB9O3yF26ivKn6H2aZg
         SIL0MmRfQd+Zz7+tgKTkX3Y+Cas3nZSirA3to+/IhpmfMcSvD7Rkeeg+k1dQcFETSzh0
         2Qd7ab5uRLelI1KCwKvEUJJBI1aeAcve9sG36yWt2n0c1j7Ozuetk78rflGVPJUyeDFl
         fxH5JOkw8pCxVm34ECaC2VCmEWGwETtcqIjzK7/uvJV9UZF7RPgCutkPmLC/lsMQPofz
         Oph0KEfmp6hPwOt4Xb9Pzdm24OExKOuorQNuf/dPXCoE4T4h1cAy5ip9HhpIjc/xK8jv
         dNlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770045697; x=1770650497;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=uLiAs6xCi3OF/LJRXhhuk0xFYAWHNsdktdbtat4hSjg=;
        b=pHwyhgxx16+ijotmUslNPDHnFyXWR4iCX1kJ1zHak5iGoz8e9MmlPRhBchyS/d/b6R
         s3IJ7PMBvR/bDrBH11etXH2n/LyJdB1dhsm9VsBXxMswsJqnUc807RmFYOohhcVhvwzE
         HZP6fXhVpU7q7F9Gfr1IdkrFn+UHhMLptiIeXNEaVCvGy17gdoXzdvmqPCoX43G7pOmB
         HIwI2UM03UY7LbEjYvxwno/auXllmY9SsqefUFf+Sv6JwrRbXf4M04g6am9qOhUbSC11
         p4oFftqnbM+f5BC37D/29TVNyValfLYKj4NF8Zorat8/KoHcKcu4/C+1FBQtnBVWghCN
         oMQA==
X-Gm-Message-State: AOJu0Yzmf+mg3Dd7fK0ZX93FxAcaNWJUOjq7j+qsOw8ioLlA1Xqg4lSe
	POcLnazytZOoM06/+f5un1SrTRRFi6ShZanY9t/q00DHGZyUkBc3w9KayKx6WlGDnnBOVHd8fbg
	COBAooD0=
X-Gm-Gg: AZuq6aKkGgCYcxnLZ2anRMIQM1anCcdiRRNs2a+DzlI3Lezvmk4vtpYYsPA5FhMr6eh
	1AE6yO7cgXPXwx5PMb5Bg3jdks+FggG5ohNK9mpAbY8CvFBjtjUrcoirHYiGAwMjIfib5uHr2WY
	975o8O3RV5XEj+OXXJS7HBzHBhzXxn9iRCo+QbJou+IsAXvJM/SAIq5qE/4nRq9UHK+rNmtU6ID
	n7nbXP6b1TfdDICcKh28EpH22smJLM22mLFoidL7prSk9mHhwxtai9DTPGtACUYMbc0Uv01LhCy
	7RgjUp7Dzg/ysoK2cQNUTOqB8xTPpS5tEWa35AcNRtxLoIwrmtFUs5aeobycsHfmT8ezeusbT0I
	YYw1fD+LcMaCXF9mcrbg2UxeOfW/Ukm/3LmX7bRLFaogS5Lgw0nYV7rkcZQmDYJioMM1xv+hkfH
	eVEx8aFItI/vq6EfvxKXG1kaA5OT0/0jOXMcb13vSatrMlNaB7Vgjk6nEDeGHo8FNS
X-Received: by 2002:a05:6830:3103:b0:7cf:d168:1f3e with SMTP id 46e09a7af769-7d1a52a738bmr6797945a34.3.1770045696904;
        Mon, 02 Feb 2026 07:21:36 -0800 (PST)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7d18c7ffcbcsm10613171a34.24.2026.02.02.07.21.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Feb 2026 07:21:36 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
Cc: netdev@vger.kernel.org
In-Reply-To: <634b9ef89352140259494d6d08086aaa30a72e02.1769962683.git.asml.silence@gmail.com>
References: <634b9ef89352140259494d6d08086aaa30a72e02.1769962683.git.asml.silence@gmail.com>
Subject: Re: [PATCH io_uring 1/1] io_uring/zcrx: fix rq flush locking
Message-Id: <177004569590.1085433.5381405081805742961.b4-ty@kernel.dk>
Date: Mon, 02 Feb 2026 08:21:35 -0700
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
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12023-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_TO(0.00)[vger.kernel.org,gmail.com];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	RCPT_COUNT_THREE(0.00)[3];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kernel-dk.20230601.gappssmtp.com:dkim,kernel.dk:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 881FACE3F1
X-Rspamd-Action: no action


On Sun, 01 Feb 2026 21:19:56 +0000, Pavel Begunkov wrote:
> zcrx needs to keep the rq lock for uref manipulations, for now move all
> zcrx_return_buffers() under the lock.
> 
> 

Applied, thanks!

[1/1] io_uring/zcrx: fix rq flush locking
      commit: af07330e28ad65352126270b0b3af226df46e307

Best regards,
-- 
Jens Axboe




