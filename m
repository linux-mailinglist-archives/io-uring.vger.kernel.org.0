Return-Path: <io-uring+bounces-12226-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SD8HHChFkmlysgEAu9opvQ
	(envelope-from <io-uring+bounces-12226-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sun, 15 Feb 2026 23:14:00 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E2D6D13FE2D
	for <lists+io-uring@lfdr.de>; Sun, 15 Feb 2026 23:13:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 72B52301AB93
	for <lists+io-uring@lfdr.de>; Sun, 15 Feb 2026 22:13:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E615F308F1A;
	Sun, 15 Feb 2026 22:13:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Bju2sI1f"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f45.google.com (mail-ot1-f45.google.com [209.85.210.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B140530B513
	for <io-uring@vger.kernel.org>; Sun, 15 Feb 2026 22:13:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771193614; cv=none; b=frL1ojC+99akxjiRnEg9RJRDgpMobTKxyVdsS82S9xgRrXPc+C7ljMVb8MvXZG+0Xz8X5lDF2D9xROX4ZFwceXg4xF/rMBK7sdEA8lxzrbHke91gwwCaZ4jW+/prqLYgKeTn1OhpXsjMIGaFFAlT4RXfodUzoSDRlGLFwc2OZpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771193614; c=relaxed/simple;
	bh=KM/b2sDRAa6rGHvDPfdqOut0uA21hg4dEnXe7vIL8XY=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=lPRZDmcZY2JMJZSYokVcVt8MjMho8J2QYin89tw6Z6Qa6ipKB2Vb4MsTIB+Rgp53q0EiO9dtefv4GqVklA/NE7aqdeE5BSuT4CW8ca4DWnKYhaEo7aLXk8A6qtea4T0/G7qSGBv+q+0awtro2vcoI20xAQ+ENucG4+VeW5Vigms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Bju2sI1f; arc=none smtp.client-ip=209.85.210.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f45.google.com with SMTP id 46e09a7af769-7d4c4b494fcso1397542a34.3
        for <io-uring@vger.kernel.org>; Sun, 15 Feb 2026 14:13:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1771193613; x=1771798413; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=crXKJvX6kY6JhEWsLVFA3cmlh+GvC4J1kvUfExxSWgw=;
        b=Bju2sI1f7McWMK2MIej3hdrfQGY6/bnmGeTKZheHlZ1dYG3RwcpFBfixUv1NuqF10f
         UC/nMJpTq6Gkw8463lq6Lk65yo/pUAYRi7bdPcRIMVosbYsasQC+tR27ehx3pZ+/OdT5
         P/EYz36/ok2XnkTieE27nfkWJ7QosnCsX0vj2u0djKIzPlSlate6kDXq1z9/PZ0ZOHD8
         qrYuJkpvOfpS3l6qkYUezi/o+QZ0YqEgFXL0fsP4d825UL9hmp57Cuq9DosHl3w44ltq
         qITMRDTRN1gsj3km3Vl+JPg/d1U99BwiLZt80Qp4AfgFavAUBkL1Mq0FTXXfYV1bGfU5
         XS0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771193613; x=1771798413;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=crXKJvX6kY6JhEWsLVFA3cmlh+GvC4J1kvUfExxSWgw=;
        b=fvufb+qx9/vVM3a0obbpDvLFQuSbMuZhyI0cKuMu8gMNhYqTCnv1rOAqwOq07yoPHl
         iBjoxLlCRMDgtFxJUwM7T0ttmWBaMyk/tOjuNo7ulyC0LhVgmaYpCJMLtHkkgkZ6AHdj
         4w5zGgyRyFOdsYQMEeExFvqNOjX5LQsxpN2XYWg7k+QsDNCiaFWNcyxdKmHEuTkk6zsr
         Rg0qt4fRm337NBWjFd5vbOqjXqcBqCkLuctXEoU9bqs4jCqem2Kkp0mbm4T5PFrc72Pn
         wvYAipxi23dd/cuttp3LfaG/p14rPR3co0zVY5SVNLbrpLzJSZMQE1CupZKgcA/GFqS7
         iItQ==
X-Gm-Message-State: AOJu0YxBgij2vnGIB7H12naewXH723VYQVY0zO4VC1yJtsDWRY4X0V9f
	tVSUmxvgjHHkil4vjlP6oJvxG7FtUcu9bxy57HPqDpmr12b1Tct57hGPL8pqWgnjIhvpkEWrEMq
	pe4R2tWc=
X-Gm-Gg: AZuq6aLXkdDzN4x8hXfRcnN9g/+vK9ulsInc4PiMWgijabiho6k+rG4/TSAahTqEGbi
	KmpIS67zX591dC+d+ZauSM/OZtj4QOpfu6YO2FU5VSB4iJAfQOp33eK8/ayCz/wLsq4hasLi4km
	aGNF3X2GBbsJVJyl0+zCrdXWFWGk5p9Qh7gEKlGn+61kC3MOoTajfhU407NuCIpAN6Fvs40dJFJ
	JbDYtMB9hMTvdzTqrnMQ7YYFdi5hp45DuDAfcC0QT3jmZEGaNVJYgMXrxyhn7fg5Bjs6735yL96
	qAsHF5Se3/4YKXZ+1mXwLZSuYykqSo+kHTeQxmYI0xdGAeWAj3k0N+DNDd/bDTJ3Mskvr6wwPUJ
	V1VGgFavETJcwtVAah9nDgdhsIvl1iF7jzwFejOkDtqdugfu1n1sb/0/e6Bo3VicinQ3gM0hSaD
	9ZrnHqrhK+LIZszBDaY+GyGs8dFrCCsWpmsFTzaSBlbYJRAfubOH07Pf0QRVbTzEZ9hRwRd66SW
	KyB
X-Received: by 2002:a05:6830:6213:b0:7cf:d1b7:7b28 with SMTP id 46e09a7af769-7d4d0a935b4mr3354036a34.4.1771193612734;
        Sun, 15 Feb 2026 14:13:32 -0800 (PST)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-40eaf178c1fsm13191922fac.17.2026.02.15.14.13.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Feb 2026 14:13:31 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <0837f85d2d0beb1ab012812bd373cbdbc3d71551.1771193194.git.asml.silence@gmail.com>
References: <0837f85d2d0beb1ab012812bd373cbdbc3d71551.1771193194.git.asml.silence@gmail.com>
Subject: Re: [PATCH v2 1/1] io_uring: delay sqarray static branch
 disablement
Message-Id: <177119361123.79392.3562541510878676890.b4-ty@kernel.dk>
Date: Sun, 15 Feb 2026 15:13:31 -0700
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	FREEMAIL_TO(0.00)[vger.kernel.org,gmail.com];
	DMARC_NA(0.00)[kernel.dk];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12226-lists,io-uring=lfdr.de];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kernel.dk:mid,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,kernel-dk.20230601.gappssmtp.com:dkim]
X-Rspamd-Queue-Id: E2D6D13FE2D
X-Rspamd-Action: no action


On Sun, 15 Feb 2026 22:06:52 +0000, Pavel Begunkov wrote:
> io_key_has_sqarray static branch can be easily switched on/off by the
> user every time patching the kernel. That can be very disruptive as it
> might require heavy synchronisation across all CPUs. Use deferred static
> keys, which can rate-limit it by deferring, batching and potentially
> effectively eliminating dec+inc pairs.
> 
> 
> [...]

Applied, thanks!

[1/1] io_uring: delay sqarray static branch disablement
      commit: 56112578c71213a10c995a56835bddb5e9ab1ed0

Best regards,
-- 
Jens Axboe




