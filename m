Return-Path: <io-uring+bounces-13549-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qBZcEl5kGGpEjggAu9opvQ
	(envelope-from <io-uring+bounces-13549-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 28 May 2026 17:50:54 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 3EC825F4A22
	for <lists+io-uring@lfdr.de>; Thu, 28 May 2026 17:50:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id BE394301FB1A
	for <lists+io-uring@lfdr.de>; Thu, 28 May 2026 15:36:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B49E3E5A18;
	Thu, 28 May 2026 15:35:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="pDIXDRyW"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f48.google.com (mail-oa1-f48.google.com [209.85.160.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88F802D8795
	for <io-uring@vger.kernel.org>; Thu, 28 May 2026 15:35:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779982558; cv=none; b=WFR7WP5dUzVULuxvFy0ojDCaBYnIdo4/t+zFCR6KJe+w1yMr4z0g9BmttBwd8/Y6Rk8Ua6tKfcq+PlaoVhCiGxSM0/y5CcsOksWjPmBMUL2VMkliJFJnSmke5/A+XT+wo3fTjnrNE6yT6IiTToVNfpRqX/cpW6J8vGIn14jevGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779982558; c=relaxed/simple;
	bh=0+L11fk9Izyta9S7kJVLDSR1ngYMv8hAklu4/THTGcs=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=rYvUU9++bPrctjVtm81FptzyPBk91wxg2eohNStXPU8cXJpfhH0tkct6NdFln2QXxRtalz2slCRNDkjFjL0RCPRvzDpKDV+NaYMLrH+77jQXCii9SDSxS8DwKk6INy9NW5bOo9HeAXnsomRRjX36SzLq41ks1mNFDiZYCeNHqVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=pDIXDRyW; arc=none smtp.client-ip=209.85.160.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f48.google.com with SMTP id 586e51a60fabf-43bf95c3f6fso2862363fac.0
        for <io-uring@vger.kernel.org>; Thu, 28 May 2026 08:35:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1779982556; x=1780587356; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dz1kiqoLVJ6hRG23SPw7NRuc6dgMEOLrO9vqYLBNo6w=;
        b=pDIXDRyWVep7CycnpeEt42TjSyPTeN66FksEg904VXsV7RnQ+eZJJYaZV1jjt5G/P2
         FJjuFMUAXzGO+Brtd0pDH0EAS1ofsMdQpLcx8h1hi88vuOcn8oxKRU4EHfK6mLuw774z
         oTDIjAD+ao+S4cfPycSSy+hJVt/dFwyUhmn5u+m4EYHHbC8TpHYO84RlvS4reZK+ub/L
         F6/mUTaOFWzuBUL9aH5n/IeMAvJVTbU/U5joiRA8PEqHjdKqKYOwvVUE8gDeSHaqSgSm
         /tReSekZSzuh66Gz9PGQwXxK0OWQ6tpQxDh7DpvHww9eqdbUhtUKpwRE6PzEU99FMNEL
         H6MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779982556; x=1780587356;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=dz1kiqoLVJ6hRG23SPw7NRuc6dgMEOLrO9vqYLBNo6w=;
        b=Mc/fzRdK23IRPwZYYhwijCUJbBZh5ZqHXFKRiZ/2FPpr9/PV8j/dZQK/a5UtaKRnbN
         JBrG2+wfjnoX6u5vKcuVsQTdqG0PV+Z+kzqX52uZaR/IkUWXTO6qY4aSTUFtO3ht3P8g
         kf8NnzOQROhEpW3Vi7ed/rNJKKvVqrtwACidAgPxKzdXyCgaoieDRdDSoGIwSFoAmDOS
         LeWAA6pqOWlfZ8QXfkWj3n+bMRZtkkLTHPMVjATg6iT8ziqef0WwMNxaU0qa0EcKgRdk
         MV98B0saQ4B7lR/M+HrAtzJkHk/6uSRJE4CMGJa46rEkXN5PV1DmaYQfayqUdNAGN1Ph
         QtLw==
X-Gm-Message-State: AOJu0YwONPQpeeu4wCRQyLhW+iMKfd2WFAEAtQ7dTK1uw2aQmobo+fgu
	4PIvYZhYMt6XIJRKlm66bTRWbSlLurvOZujfhbtf+EYtdoTxTmGd8Ch69SBKRNsvrRY=
X-Gm-Gg: Acq92OFGTZEczKaM6rTe9CClx8Jb1FCFcYbsQMck3WNEIWiZlfCOVb56QCe+QMOBVII
	C7JdfgYDjL7kwpGm4YbtKXV2chqODpc9y+l01QyQauHabr0nYss1t5E5Oy0AtmIVH4YsrnElpNr
	p8AAWR1bIZy4/RJ9IuLaTPAoEyUj+TtLViuWdts5ETiPpmXvRrTsMXRlgTrld6jmCy0vcuLmau8
	7f7YhT+GMdU5E06Bp891tCB0hQtUuV3KAoomx0bOCVMPvpShBo+WHYJfDSpg1tnCU3/1YHtS9CW
	7CAV3GA+y3JZkbjcATELlKUwm5SHi4UqdAnNUPRPr+XD9+Yy+mOpSRTbOzOpusGcDXdO08FSxYw
	Iaiwzo9le6d7fPmlnGSa4Pu+bZJ+a22VJrE9tl194NWAMggSzmrT4n7CnCgiUuOs+639vbW0YIi
	8J6raHGUqECOKqUeXA1uS09Saht7OSX53Ob1IB+DSt0CW2wB6IczcLH+hDHlhdWUR+pdr3a4siK
	TEmCzDhmhJxIQ==
X-Received: by 2002:a05:6870:6f05:b0:423:9751:c1c5 with SMTP id 586e51a60fabf-43c6c98709fmr1119076fac.22.1779982556503;
        Thu, 28 May 2026 08:35:56 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-43b63976202sm17548732fac.12.2026.05.28.08.35.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 May 2026 08:35:55 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: Runyu Xiao <runyu.xiao@seu.edu.cn>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org, 
 jianhao.xu@seu.edu.cn, stable@vger.kernel.org
In-Reply-To: <20260527172203.2043962-1-runyu.xiao@seu.edu.cn>
References: <20260527172203.2043962-1-runyu.xiao@seu.edu.cn>
Subject: Re: [PATCH v2] io_uring/io-wq: re-check IO_WQ_BIT_EXIT for each
 linked work item
Message-Id: <177998255558.134892.12462292234696248083.b4-ty@b4>
Date: Thu, 28 May 2026 09:35:55 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15.2
X-Spamd-Result: default: False [-1.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_HAS_DN(0.00)[];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-13549-lists,io-uring=lfdr.de];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	RCPT_COUNT_FIVE(0.00)[5];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kernel-dk.20251104.gappssmtp.com:dkim]
X-Rspamd-Queue-Id: 3EC825F4A22
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr


On Thu, 28 May 2026 01:22:03 +0800, Runyu Xiao wrote:
> commit 10dc95939817 ("io_uring/io-wq: check IO_WQ_BIT_EXIT inside work
> run loop") fixed the obvious case where io_worker_handle_work() took one
> exit-bit snapshot before draining pending work, but the fix stops one
> level too early.
> 
> io_worker_handle_work() now re-checks IO_WQ_BIT_EXIT in its outer work
> run loop, yet it still snapshots that bit once before processing a
> whole dependent linked-work chain. If io_wq_exit_start() sets
> IO_WQ_BIT_EXIT after the first linked item has started, the remaining
> linked items can still reuse stale do_kill = false, skip
> IO_WQ_WORK_CANCEL, and continue running after exit has begun.
> 
> [...]

Applied, thanks!

[1/1] io_uring/io-wq: re-check IO_WQ_BIT_EXIT for each linked work item
      commit: 29bef9934b2521f787bb15dd1985d4c0d12ae02a

Best regards,
-- 
Jens Axboe




