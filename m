Return-Path: <io-uring+bounces-13349-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WOsoObMdB2rnrgIAu9opvQ
	(envelope-from <io-uring+bounces-13349-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 15 May 2026 15:20:51 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D252E5505DC
	for <lists+io-uring@lfdr.de>; Fri, 15 May 2026 15:20:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id DE9F03024F96
	for <lists+io-uring@lfdr.de>; Fri, 15 May 2026 13:13:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0B592BEC2B;
	Fri, 15 May 2026 13:13:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="oUXSZHNb"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f44.google.com (mail-oa1-f44.google.com [209.85.160.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B290314B76
	for <io-uring@vger.kernel.org>; Fri, 15 May 2026 13:13:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778850808; cv=none; b=oz3VQtWEvqUJGH1Db/CwFjYU7SBpGkETl0al43fzl/jPbfexPuDNZdcFNPzmicNLO9TVa43i2VP0U0gA4vrIZfW50Rv0vPTxSFrDw78dzKzdCnpUi2ZtnRdlm7KqtEzs84zCuorrunzNSxQCra1CceNDyj50zWdze0S4XFquQSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778850808; c=relaxed/simple;
	bh=BsbgfGxdIaE2nxlPPt3AHSZ+iJZER9+DnbFxIXGiO+8=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=uHRxSFjd1zVD2/YrXBrly7Osrxn1YMk88fi6nM+orCwnEpF28hTljkMM5vSZKS6hADzfffU/T9ehYgFXxminr/7rbOWpaiWqwAwqBKuBchImt22miPe8P9BTjSScbpwSImooEQv5eCZYt6ojk9AuQWoFcaNFseKBYKRdOKcX7v0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=oUXSZHNb; arc=none smtp.client-ip=209.85.160.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f44.google.com with SMTP id 586e51a60fabf-43587e63a8eso3961669fac.0
        for <io-uring@vger.kernel.org>; Fri, 15 May 2026 06:13:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1778850806; x=1779455606; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lBrkANC0gfhD7n5PQY71+3lOX7dUvkb4saoqUsP2Jrc=;
        b=oUXSZHNbFFo/Hofm3Qg6LsCVbnhxFj4ZHhEHkPLeEOfJ0fgrR9t/sMePFTpirB1kGC
         6rjPFo5MVIPCMuHWBjg5RHEznv4tq83Bqu/z7+JL2ToW+reju3+x5hXYucqaRom2QebC
         C215OtqD4A4NNEu2attF2DSD20u8DV7DgA4yYv1nLX5XKQze4SK7Cd9LA+4DNJnd7jkI
         I5Bl4oCCgGQMJcN3Q0shd9dm1JCeV0XYLeYPCSRXbT7jjcuaLaADidkP+ntEJCIn3zGF
         t93NUhdoKk8iQsWO/OxSYgEsRYfl+y4f9f9a5ZIOuHghPJZgSM6vLTtFKBtY6F69LB/3
         IlhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778850806; x=1779455606;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=lBrkANC0gfhD7n5PQY71+3lOX7dUvkb4saoqUsP2Jrc=;
        b=NxbiyzpvThDXzmF0O51bPmCYDfL6EjIGvU+DUVEgjAWQCPggJ0vmteiUeY3eTT+KH6
         CHw31MCvBhIka0KSLtKDifDglt+56WW7+RdXIxWd2TEXrq/4XYBDRqUDo1RQyTsqXvRl
         qV/BJA2VZP7ZvY0k1pnhRrZebSdX4tNPWqtIwjtmYASGmETWCMPCafM2dZKpGc5nzJuV
         ssddX96CLmB3ksGY7Y1OSiTNLNMdTOrr31uMfy67dEsmWqfirJYrdKUSr5DozFW6w+Qn
         QEGLvxxVXtndAWgOmbavd8vQRt2ZvJyAmnQrypJiHCHfIg+XYoFS8l5kfAcyiKLy5vLY
         Vf/A==
X-Gm-Message-State: AOJu0YxICfapQGGTjDgALAz9NUOK+pmKw4LYC4fcejoA/Yd43bahxvpl
	rQUNMnemZcITQz2XtrMKVMVLDugqqXG9FJj2AP2+AwtM+JChtbBoXrPT0bi90TZdWhk=
X-Gm-Gg: Acq92OHtV/WshT6XRgTxTq6/FzEdeI7ZOpHI3509zql7HCXF/csPbGJ2n5VdsCAXwDB
	ttIx4zqfR+UPrybyPWj2H3yRL9TkI+eMjiv5oHDdDqDMkrK+tMaQB89nUwVEBAN7muNCi6S+5kZ
	mHs3kEVq2Vu8i5IL97cS/M4t7cxk5tP2b4lWm4iKRyZLeNmOcYrTgUNyIrGMOR2m4/2OBfiLMy+
	lFJVgwji6Xv1F1k9FmN343cGqEuCMQyMKxtYoogOb83ag27xHGITfBFrPTEoWKzi8QQ+8RvAt9J
	Y10DRrN0YQOWzrdJ+r+lucuKzGzT9YqNBHZqKd0bDhf+xI9GRRC5e85C8RitvsQwTE/Z42hB0c1
	7TjpQRYqIXGacBggixCW7AcmoIPIzgMHHtnFKS19vbXrmo/doJFwurjWcv3qPlDCXNLnYYqaTY9
	8mRocab5srHS1PKYTWil4IB5r0hPxgbhddjo4e3G6YeBSkUa+WsB6w6PRVNzPwz2FfJYwYcc6Ng
	usc
X-Received: by 2002:a05:6870:891d:b0:417:5285:6c7b with SMTP id 586e51a60fabf-43a2db4d89fmr2633473fac.8.1778850806389;
        Fri, 15 May 2026 06:13:26 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-439fc4dcb89sm4160706fac.12.2026.05.15.06.13.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 May 2026 06:13:25 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <c633c9e2c3cc7a0a07bd9765f86f54b7cc90d876.1778840077.git.asml.silence@gmail.com>
References: <c633c9e2c3cc7a0a07bd9765f86f54b7cc90d876.1778840077.git.asml.silence@gmail.com>
Subject: Re: [PATCH liburing 1/1] tests: improve zcrx ro params testing
Message-Id: <177885080535.720964.16051493970091754263.b4-ty@b4>
Date: Fri, 15 May 2026 07:13:25 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15.2
X-Rspamd-Queue-Id: D252E5505DC
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCPT_COUNT_TWO(0.00)[2];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_TO(0.00)[vger.kernel.org,gmail.com];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	TAGGED_FROM(0.00)[bounces-13349-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kernel-dk.20251104.gappssmtp.com:dkim,sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Action: no action


On Fri, 15 May 2026 11:15:17 +0100, Pavel Begunkov wrote:
> Test clean up on failed copy_to_user for export does the right thing.
> For that I put parameters in read-only memory, it's a second place doing
> that, so also consolidate it for convinience.

Applied, thanks!

[1/1] tests: improve zcrx ro params testing
      commit: 9d707e2b7f1f56158921ec7d45fcecbf5eb6222f

Best regards,
-- 
Jens Axboe




