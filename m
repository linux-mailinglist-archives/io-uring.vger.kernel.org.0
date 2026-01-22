Return-Path: <io-uring+bounces-11894-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GBH/CdarcmkkogAAu9opvQ
	(envelope-from <io-uring+bounces-11894-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 22 Jan 2026 23:59:34 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id C11286E59F
	for <lists+io-uring@lfdr.de>; Thu, 22 Jan 2026 23:59:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 30F703011F22
	for <lists+io-uring@lfdr.de>; Thu, 22 Jan 2026 22:59:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 787DD3A6401;
	Thu, 22 Jan 2026 22:59:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="oOoyzwB9"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f172.google.com (mail-oi1-f172.google.com [209.85.167.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE7F1367F46
	for <io-uring@vger.kernel.org>; Thu, 22 Jan 2026 22:59:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769122768; cv=none; b=Fe9xLSCMvsH0sPn+lIhc0vYeW0fOtN7CJSVdZN4vZGPttgw9kqNqnFhZaUaT6HOhrfckherfeqawa7hPE+a810xJZBaldat2wObX+mwjMGOj9+Hw2UMCL2H4/mT4GRtwBvvLM9Rmrlmo/1IRO9XicnTYo2K6PUYJ4tSFUzytuG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769122768; c=relaxed/simple;
	bh=KeNcsJAIkIqYyCHPTcyfY48mOQneu/j7pm8RW6FgXJI=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=OHB6aN0AUNhu5J0C8ejqYfNRfXD9Kj0pb6of6ygdaX79+tKYepoRZjFlDEE1hQ33xkCx77RVVi+uQ+DWRQhYZcA+upsIWfZCRECTxFQRo6159L8mFvZ+NZ0CVJW7wu7BsA3errgrhf56Pcq9+FAde4TdgA5rPpQENJVNhtefQrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=oOoyzwB9; arc=none smtp.client-ip=209.85.167.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f172.google.com with SMTP id 5614622812f47-45c8b850f96so1075233b6e.0
        for <io-uring@vger.kernel.org>; Thu, 22 Jan 2026 14:59:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1769122758; x=1769727558; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nA2gaKdeQbD+EPUwlfZO1SgIPhwg5HRpQarSLH7k4UI=;
        b=oOoyzwB9hBjc52QexinO52kYXmbjhgNUy4JT4xvZpW3A8iCvFbeylqozvYuWItkOfi
         to6iZK8qyYs69tMVH0KiC79dDwEIEUNoHcfsQp/Hm6A/nUHvVCdyZ3fFH4ZPDQm0S9eI
         xseR82B5tKPAm9YMu3ifrW50in+bkit36IeqCLPmTPf1mlZuIdD750OMd/yN4CeaM+Iu
         CuDQH2j96gUo6PYwJphYG8ksZv4fSqpS6J2SSaBdBTwcUvF1YE2PaA1zTociiYlhSRDx
         dvnwrv++s3NPQdmYOpVZOW0LIPeCHXZvmAmJH9YGVyL1ninEtY6EBpcx1i2vfkMAT9ud
         ovNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769122758; x=1769727558;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=nA2gaKdeQbD+EPUwlfZO1SgIPhwg5HRpQarSLH7k4UI=;
        b=mKAKEYI858oT7l7p6oqiE5OY9Zn1dcrgRF7xVmFko6xc6OSDLFComyOl5fPyqJ5/Bv
         U2z/y/DzC7rS6Fg3gBJMAISegT4b6mzPl1xuDDIpHFVbyuXF5ED13hmklgWPPyhq06gX
         bjyi6icb+ZfcJycHirJR08E4FFmfZdf0UNw51DWUlhPTWz2bqjFrhXA5Y1pJTwbm4TRD
         I3bK1XzmzNA5HOE0olTET8ecQqEo/Dk1ZSXZjLpMvLZV4L5juTs+w1lxwYVAVMjmbDS2
         wuN9XwYzfm3lfGcvjB8JHtcMdNsDWZCmtRPQjb0/hTGv+SDus0nclhajyy79ZvnfY2s0
         TUpg==
X-Gm-Message-State: AOJu0YxInCy3hxJ8zO4e6yhTs+50Uhlhz5JCNcHOI6BGm1biA4JaTLAk
	V5vuzoVinFVrSTAJaM5ITW4h4CUaC9CYJe7gdDhaw1VI9vZslN+fRoXRe+x9Wp1pGCz2NJqO0lF
	z2V7AMQ8=
X-Gm-Gg: AZuq6aJwVVYdSRrPGZoJ7ZfESGOLrxwAv2+joeGKISNTT8lsCpoRFqlgAp2BMv0CSib
	iv3iGzaVtpZOP9+fSbMO3D8k+dtKbU+qLBGQnTfyFAOMfJiVwWb5UZUyamYccOkFJcF2VBd1ymo
	5XVNVX3brs/b7AnnBn00HBgbxruYfUoY33CBtkc6r4l4hp5RC9DZq+zrXOpdVWxoGsxhW1yplqY
	usskz4Mkx5tlF7132o5h/S/tXcgslWJ+c+Ut5ZVsNHXrnpEto+WkD/4hD4BBkYma3DFKGcjULsm
	7qh2uU1Cu/MHhOgAKtbeSB+Z3DRPGPdUfowtFKNufV+h27VCpIoDNHptVHbxoQb/+416YyX3+yk
	qAaGa8YlxJHgbwYB+Pdb0QaKFfxlnJ63AY4BuKsjObuQ4UrTRSlEJgfMeFxlepuwJLABd6ruywX
	I0uFjwIezkECW8NVYsNBQeUpXiImhbTmwHoBZG1Z2+rI0fQ/4Lfrlh2/rl5S43tsIYCstRxAE7r
	2o=
X-Received: by 2002:a05:6808:5282:b0:43c:afd4:646d with SMTP id 5614622812f47-45eb1b015ccmr638118b6e.14.1769122758230;
        Thu, 22 Jan 2026 14:59:18 -0800 (PST)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-45eb4235b50sm290180b6e.14.2026.01.22.14.59.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Jan 2026 14:59:17 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <b7a5502ee3da7ef096455498cd1ad3efbdbee288.1768940337.git.asml.silence@gmail.com>
References: <b7a5502ee3da7ef096455498cd1ad3efbdbee288.1768940337.git.asml.silence@gmail.com>
Subject: Re: [PATCH v3 1/1] io_uring: introduce non-circular SQ
Message-Id: <176912275723.523910.2329374293029110776.b4-ty@kernel.dk>
Date: Thu, 22 Jan 2026 15:59:17 -0700
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
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	FREEMAIL_TO(0.00)[vger.kernel.org,gmail.com];
	TAGGED_FROM(0.00)[bounces-11894-lists,io-uring=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,kernel.dk:mid]
X-Rspamd-Queue-Id: C11286E59F
X-Rspamd-Action: no action


On Tue, 20 Jan 2026 20:47:40 +0000, Pavel Begunkov wrote:
> Outside of SQPOLL, normally SQ entries are consumed by the time the
> submission syscall returns. For those cases we don't need a circular
> buffer and the head/tail tracking, instead the kernel can assume that
> entries always start from the beginning of the SQ at index 0. This patch
> introduces a setup flag doing exactly that. It's a simpler and helps
> to keeps SQEs hot in cache.
> 
> [...]

Applied, thanks!

[1/1] io_uring: introduce non-circular SQ
      commit: 5247c034a67f5a93cc1faa15e9867eec5b22f38a

Best regards,
-- 
Jens Axboe




