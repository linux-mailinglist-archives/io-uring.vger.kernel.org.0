Return-Path: <io-uring+bounces-12136-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id Nu73JBejiml2MgAAu9opvQ
	(envelope-from <io-uring+bounces-12136-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 10 Feb 2026 04:16:39 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id E86FA116B58
	for <lists+io-uring@lfdr.de>; Tue, 10 Feb 2026 04:16:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id B6D133011079
	for <lists+io-uring@lfdr.de>; Tue, 10 Feb 2026 03:16:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E0BE285073;
	Tue, 10 Feb 2026 03:16:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="B167zbVX"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oo1-f46.google.com (mail-oo1-f46.google.com [209.85.161.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E451274FDF
	for <io-uring@vger.kernel.org>; Tue, 10 Feb 2026 03:16:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770693396; cv=none; b=J5QVNEXz7QVcrvTXTrxPdzv9e6XHMSXIQ8OwSRJlKXbVROYagRGxx4EK/Ls1cbepJZ5B3RIpmjPb/s1dsgFHO+99qQNSMrNEckjJDBG3nAgFnegCPt9LTEqcG3avJh2BhlAKfEew3m28SEyaye24OK6n1gZshFFrZBuO8tfm1sE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770693396; c=relaxed/simple;
	bh=19QF1yrbFGEPExVaP3vDmbuugkpv3B39Mgras0qSQB8=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=ElqWAhovDenT9a8xehvRfGmFPF4DcWTvD6BqNYnvyWptNLaCXnL+nGvF50yHxfVIuTW8RppIt3XSgk0f0qajKY/ad8SJkmrhVIwFPfyT0vuxiwEoFvTHStFT3zup2CKSTOtHRtSpJm88asD3fHtZ7NdDkmwXeSoNRclKkekNfW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=B167zbVX; arc=none smtp.client-ip=209.85.161.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oo1-f46.google.com with SMTP id 006d021491bc7-662f9aeb782so3113346eaf.3
        for <io-uring@vger.kernel.org>; Mon, 09 Feb 2026 19:16:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1770693393; x=1771298193; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UatjcoVxwf6eOeo4yvNkidW3e6786jLoKxEjLNDCB94=;
        b=B167zbVX7/GAC5/UvRWJA586OSKKlTuIaFiEW0mggjONC0cnNyBKX15D93WhuEj8dk
         3TP+rUi+5vUIkTG3HvPRxB4AlkzAre4J2mLMrHcXB0bmcgONNuQCY+/KtK6ATyqhzY2Q
         gpeb7mB8w8MoLakNiBY4PYV/Hx5mseVENBBfkO4D/1jRgAwdnwPvUwRsuS92w6SetVDs
         0i1sFcnF+LAygZc1Rvk32O4p2S4Lqi3uPSEMKJiCkQZE8ZklamDm2bpmtgbkznspw54w
         +1+PwXw285uqxajB8XYfU2i67AyMwHEA+SXVmSMwMWn72kuvB6cRd1dUfQT9PQxFB0z7
         t5ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770693393; x=1771298193;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=UatjcoVxwf6eOeo4yvNkidW3e6786jLoKxEjLNDCB94=;
        b=qpzCZBTgP7+SxAVFciOnArIHxnpmDR4iO+A1MhZrhHjfc9teZ89zBh2YT8zBkvcsEa
         dFb4iUBZ8qRQrWZHx722gh1h+A62h14zHenulaGyxewXiXEVixpAh28cYDVqGUV0rZNg
         bN7CQvG0r8gJIdIUtcfJL91Idcq+n4vfzVefNfAiNzVG2z3EmUGsYp46+37g7PKLLztl
         nFn1ZWSRGOTHqDoMTm55Jr+wtI8i20tVhOdarpO8dV9jYLEwiTPSbagg9q9+/V5zpRCY
         H7IjbuBxD+/VYYsrzRuK+2PrLpcrR72yO/e3G+xhZHCbRWmsWXKN+dA2T7aHxTDrghhi
         mJZw==
X-Gm-Message-State: AOJu0YwGJA84bH2sZUCMsuQ+fgm+Nm8lbP4gWejip7rbOQwIdd6SQeqJ
	ZUKTF0/F9GiGhv8jPCOIpRR4yyaepfWLjPRM9tbHF9jOW+HKLaQEqqqlfUDrrwgivWA=
X-Gm-Gg: AZuq6aIIQTZLmFRppj0H+cI99XbN+g/4hE5Ioijt9FcZRPD5c/eHtjQD+o1EgMU1sQu
	wcKBSweveFFCd+8+l0tPjLasU/bkx8IhLzGh8pObB92x6akA/T9X2LmmA8yxKTcKQe0cgnn96Ca
	5HV5dMm1q4e66FHBWyrgdgFzwitVDTs0+neLhjzi57h5aj6K8C6t3MmfpPy0zT26nfW3YZpJRd0
	PyXBRNNj5B3uAApQUCitH1LSetK7UKcNqr7fnwq3IsjUujZi+FWhbXisDDJPRyIHwl2ZNmTEpvx
	Bb1tx9k3M59Y0V2I7zzxHHsfcig8gWCGlGAe+Ue49H3PA4EHdIJ1ps4mAj6PhI3ba3i+hAk9Lgu
	WuhjY8bivAwLDJzSiU5uLP40PEKZWTbx0xkD+maosBqlfV7Nfg+gPE0Ewy03tmJ7s+z0M4Zg0Bz
	51erBvdEMG9yUD/8NBYJIHl3D99MYPL1HD0RM5QZ8XmgbF/Jx0qFHQNSsqBT3kkAvgbQmQo1PED
	Z8w
X-Received: by 2002:a05:6820:2106:b0:663:2b12:1500 with SMTP id 006d021491bc7-672ff550affmr288529eaf.76.1770693393520;
        Mon, 09 Feb 2026 19:16:33 -0800 (PST)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-66d3adcaa9csm7545605eaf.11.2026.02.09.19.16.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Feb 2026 19:16:32 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20260206215806.1637548-1-csander@purestorage.com>
References: <20260206215806.1637548-1-csander@purestorage.com>
Subject: Re: [PATCH] io_uring: simplify IORING_SETUP_DEFER_TASKRUN &&
 !SQPOLL check
Message-Id: <177069339234.478075.3124286738158436259.b4-ty@kernel.dk>
Date: Mon, 09 Feb 2026 20:16:32 -0700
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
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	SUBJECT_HAS_EXCLAIM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	TAGGED_FROM(0.00)[bounces-12136-lists,io-uring=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kernel.dk:mid]
X-Rspamd-Queue-Id: E86FA116B58
X-Rspamd-Action: no action


On Fri, 06 Feb 2026 14:58:04 -0700, Caleb Sander Mateos wrote:
> io_uring_sanitise_params() already rejects flags that include both
> IORING_SETUP_SQPOLL and IORING_SETUP_DEFER_TASKRUN. So it's unnecessary
> to check IORING_SETUP_SQPOLL in io_uring_create() when
> IORING_SETUP_DEFER_TASKRUN has already been checked. Drop the
> !(ctx->flags & IORING_SETUP_SQPOLL) check for the task_complete case.
> 
> 
> [...]

Applied, thanks!

[1/1] io_uring: simplify IORING_SETUP_DEFER_TASKRUN && !SQPOLL check
      commit: 7cb3a68376da0bc0afab8157223cb479c97de9ff

Best regards,
-- 
Jens Axboe




