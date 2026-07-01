Return-Path: <io-uring+bounces-13869-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id DC56FDT9RGp64goAu9opvQ
	(envelope-from <io-uring+bounces-13869-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 01 Jul 2026 13:42:44 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C19736ECEAE
	for <lists+io-uring@lfdr.de>; Wed, 01 Jul 2026 13:42:43 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=kernel-dk.20251104.gappssmtp.com header.s=20251104 header.b=zadM+TOu;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13869-lists+io-uring=lfdr.de@vger.kernel.org" designates 2600:3c09:e001:a7::12fc:5321 as permitted sender) smtp.mailfrom="io-uring+bounces-13869-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=none;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 110A73010BE7
	for <lists+io-uring@lfdr.de>; Wed,  1 Jul 2026 11:42:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A80C48095E;
	Wed,  1 Jul 2026 11:42:37 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f50.google.com (mail-ot1-f50.google.com [209.85.210.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF4EC480346
	for <io-uring@vger.kernel.org>; Wed,  1 Jul 2026 11:42:33 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782906156; cv=none; b=N+Qpsv53fmzG+aUzyCFbtvLyBzpXWGqAL9SFbmgnnMoJXJCaGhtPUvvY7nNwgOeFo2v6HOs5/7rnTYCDqnnPX3K/smZocQ9NNyWcns6nbBTqVie+OBXB+kwYqqkXgf5by4PURSFze62sZ0eo+ks4bAyvb8OLEy7lhrV+I3jIRQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782906156; c=relaxed/simple;
	bh=Gi3SJ+4l4Dbj7DZV6bqb8WmXGiRVPS+PJE9Ra18D8UY=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=BYdARWCGn5SUIw/Gd05NNb4P4ZLrOewUeX0aq5t7jl8GigaxOn9Sj8Wkes9pa221qh49oYMYPK7hOfMtH6klu6I4MZ9apankMCF9QuhIO9OH2HUFnkK4MrPWtglsTRCrRmxOaeYRlxB460Nc7SjFI5mUDKIk0P/6sugyjHFFJnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=zadM+TOu; arc=none smtp.client-ip=209.85.210.50
Received: by mail-ot1-f50.google.com with SMTP id 46e09a7af769-7e9ecb1e13bso223909a34.2
        for <io-uring@vger.kernel.org>; Wed, 01 Jul 2026 04:42:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1782906153; x=1783510953; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pXXtoQMbBtJFrR1IrRoQe/GS8/twser0x9RC1yG1s28=;
        b=zadM+TOu32gvpv0lqR9IBCGUDoqUb62vjYj3vhOrQ/usj47fBODjEMvYovFFi8WMHX
         eDu7GIqCCDKW61CNXmQOWZb8rfSONhqlqgUjIy2CqAwdAk/pcTFOR5XBCkd8RJWFcsPK
         MydFMnKyrM6RiXZ7Q+YLakmcp2Nt66W6fkN385IHfn+MbHEgbjB7kEKL5wObsvqn8RX1
         GzBHg1z75cx3gBO7bnvWaJg6VawdDzBJReFSd/yg/Sm+mv6YhIKbWfBj8sp0FkUp7jhr
         DNnxm3jcHrPKUU56zdp+JjwYhg4yrdJS87ZfimeTUeSkZ4HdAMTtfl0uMqZWr+Oh9kpR
         amzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782906153; x=1783510953;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=pXXtoQMbBtJFrR1IrRoQe/GS8/twser0x9RC1yG1s28=;
        b=CkXGwGkx4eHCOoCeG1yBHcKJO9RI2zimStxdVc4OkBnb62TroYWDj1irnmIhGIghbw
         KPEvS081qEVUF59rfUjvJihoMoAKo/lAGSFvVAFFEcBhwrXa5saShgYl/oQMTK+rG2hk
         t+pyYZDoRkdq7OCslCeva0+WPwxVu1Te9jUgEoEspbLzUZEUOSvLv5cN8VRBMpz/yAfl
         6KA6niczbHSt1N7PIVbFs5Wcf3OhWApx2gXG0Hk6LqcV+8gUk8Ny6oJLrUKCzgjzwBC8
         HeyJHCYkyE8Z/6hVZlUQoKBrE7adHf4kDsnvUbvVKhOxiABiEz8MvqmEXGHN1NJjStxd
         UabA==
X-Gm-Message-State: AOJu0YyE/b4PFvOtbN+jwcSzRUJ+uhf24BxSb7xcWdT0lzBBw2D5/3Xg
	1jfEMi1P8213rwNbHrfwnmIytrVuk1pzXfHS2/ACu8GJ/ekAPJLucr+2G6FGwWc/82k7rg6h6oQ
	TQACbVng=
X-Gm-Gg: AfdE7ckgyjQerj6982KoH3AEbdlj1QNnyIZZNomN/aSuoVPNrl6EkeZZlMLhwHHAXiI
	ZG90fWF3Z/OHn6atUMdAcFs+dQytFRbsrhpP7PnujZUXJoxAL4FPbC0Bkkxztq7lF6r4EA6HDDk
	mC+9umeoaUwOpWjfzUxKDBdt1HF9T4rwp3j3LCX6epsYi7i5oSgpX0vzIU4pOFykTbRqtPbJwzJ
	SHfGSe7qPWJfh5fBjogK7HqR6Ew/hS3cH89wBLURZ6T8QDRcRjIYaVnMTm2BfLmCpFixPSx5iMX
	pGXAIK68zfWtvrRlzctnrqhtU+DJ7x9J8t9IS7vBUwMDsovyS2TSrgRCm2cxOJ8TxtL0GoVzr2K
	BrwdFJ3o3jDgPMRPIzVIP0y3zQMG6Rg/HOutVdWl3aTmCURdJBwF+eDI9GsUAG9BYvlfykFOmMh
	V/0vQo+RE0A0iJhwHhq13oO2LvNbkbXY3I0eaZOs9uVWkwfeyKyuIQ64eHnrz3Wq+YzA==
X-Received: by 2002:a05:6830:2b12:b0:7e6:f083:130e with SMTP id 46e09a7af769-7eb48aaece3mr702000a34.4.1782906152718;
        Wed, 01 Jul 2026 04:42:32 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7e9f328636dsm3668677a34.9.2026.07.01.04.42.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jul 2026 04:42:32 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: Melbin K Mathew <mlbnkm1@gmail.com>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20260701081145.196730-1-mlbnkm1@gmail.com>
References: <20260701081145.196730-1-mlbnkm1@gmail.com>
Subject: Re: [PATCH io_uring] io_uring/msg_ring: reject CQE32 flag
 pass-through to normal rings
Message-Id: <178290615154.198657.13240573230463444889.b4-ty@b4>
Date: Wed, 01 Jul 2026 05:42:31 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15.2
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-1.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS(0.00)[m:mlbnkm1@gmail.com,m:io-uring@vger.kernel.org,m:linux-kernel@vger.kernel.org,s:lists@lfdr.de];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	FROM_HAS_DN(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_SENDER(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13869-lists,io-uring=lfdr.de];
	RCPT_COUNT_THREE(0.00)[3];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	FORGED_SENDER_FORWARDING(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	TO_DN_SOME(0.00)[];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[vger.kernel.org:from_smtp,kernel-dk.20251104.gappssmtp.com:dkim,sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: C19736ECEAE


On Wed, 01 Jul 2026 10:11:45 +0200, Melbin K Mathew wrote:
> IORING_OP_MSG_RING with IORING_MSG_RING_FLAGS_PASS allows a sender to
> pass completion flags through sqe->file_index. If the sender sets
> IORING_CQE_F_32 in file_index, the target-side completion path treats
> it as a 32-byte CQE and writes big_cqe[0] and big_cqe[1] into the CQ
> ring regardless of whether the target ring was created with
> IORING_SETUP_CQE32 or IORING_SETUP_CQE_MIXED.
> 
> [...]

Applied, thanks!

[1/1] io_uring/msg_ring: reject CQE32 flag pass-through to normal rings
      commit: 15cd3ccf9b179f0f76948d0901be3b15028bc768

Best regards,
-- 
Jens Axboe




