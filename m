Return-Path: <io-uring+bounces-13351-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id eExOGpwpB2ppsQIAu9opvQ
	(envelope-from <io-uring+bounces-13351-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 15 May 2026 16:11:40 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id BD50F55112D
	for <lists+io-uring@lfdr.de>; Fri, 15 May 2026 16:11:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B53FB30520B0
	for <lists+io-uring@lfdr.de>; Fri, 15 May 2026 14:02:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2FE6848AE3E;
	Fri, 15 May 2026 14:02:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="dJmabCf2"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f43.google.com (mail-oa1-f43.google.com [209.85.160.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 557C63B0ADB
	for <io-uring@vger.kernel.org>; Fri, 15 May 2026 14:02:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778853758; cv=none; b=uj7O2JQ6kQfvcOo2pf+7ogtyydClMD3lOCtjXbu7XQfASjfS9fhTEMH6px5gD2Wg3Tj61L6KMc2pt9J8X8KWPN2XB8RewJCjgZLuZ7TMy5Y8PiHc50U4DmUF9XkKYguTQTLop3HXS789ta7GVjklo+txYRZ7oh1zVlEnAzu72w8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778853758; c=relaxed/simple;
	bh=afPtjVszG169QH6km9gCzMGnB9TiIq5NUkjgJXxJDUw=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=L65VCpl4bXh/dnKBwCLaSglHPcwIS+C/Wih4VD9HXBPu2wBoIUf8n4YSKwa61EIZu1vG9RcigCXin+uFA3wS4s3glWa+8/+ehOIwTg+DQsMkGhaoQE/TNNjFY0hbSNqLhTANqRCOc4nzu17vz/VmcNLDVpbX/Z6bX77jcvBlqt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=dJmabCf2; arc=none smtp.client-ip=209.85.160.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f43.google.com with SMTP id 586e51a60fabf-40ef10ec84cso7489787fac.2
        for <io-uring@vger.kernel.org>; Fri, 15 May 2026 07:02:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1778853753; x=1779458553; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=juyqAozJPA3kiT6vrGKXzyTGpJuBd6TpJcgmUOrO5k4=;
        b=dJmabCf2PiOsZv0sv4zyT/YWsEngce3vGvFov/s2UW9pwZkI6nG3oiDmTBhW5+fkuG
         MjaUjtoeM92+epZ2SpPolXffVsGUE264tfu5xuE1LGX6E8jFkR2o1g4dUtBSWXWeqBy4
         hW9IZFUX6dHV5+MUzFDjxTE0/HWS68/lzs2aEBMCq++IwvPZnZcyKOTjSR/e2iSouiHi
         /vVKyVmjoYWmJLBzVu75rbyqZEpeg/4Z7kjazYLQPXej5F0ZJi6bIzq/kdoWRtnrv1b9
         nq5PhzL43BtzIgPjofN34zt9rcVo6akMqhLO/wKZN7o3jVKch3SxzQB9xB5gdgqfuxtP
         Qhdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778853753; x=1779458553;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=juyqAozJPA3kiT6vrGKXzyTGpJuBd6TpJcgmUOrO5k4=;
        b=sfQftKHE4+ac2BRdnT3RSFZoFgfhJ2c0aaJv3CNdGuqF3/F1z4F2UeVyAz8b2v75zT
         14BIe0AswaJyxg1aRWTrZbakfbIpAdRcdE/Eabjg0nLob+SIx2KXZ94Ei5qOUPYM35GM
         nBS1RSlmT/LFWvvMGgX5VaWBk00xDL/XBzThYcPc9t1/pUXMCOJlE8W78GC5ArryR4ei
         j5608efpy+s3Rzg68xsOHahbxuBRTDDtBgkuuMHcGkDdqYqm14UpYhWYvjHPnf34tiex
         dOElJfJTKbVLyJFn6WxlcUu/zFMtFsDFUnYTo1zmWKIoiLCWwkFy8bp3+cIq/Z9fhBNt
         ooaA==
X-Gm-Message-State: AOJu0Yy9v4v0Ms31Z+dVV4YRCkV3NTm/mO5lDXk082UJOuaJos1MacgT
	RqnGGjU+lSKRrO6BCpToxujnm0ZRi/xBqaf845kx+Cye0Pundvely/nNUkz7ysgkFxk=
X-Gm-Gg: Acq92OFyXE6wT5TeMZt9K0C5KpK8p20RqsRyKKpAgyy1+O1zPS3yUf+MGcG9ry25Odi
	mhC6wq7qekeQBBGSSKlEeO6YsWl2maMW6UL1J7zF3Pwn61p1+l+ROj0tcCQ9X+hhScOnczYHAVE
	n90lI8TfGC46/LFlQ0l6J62MLuUilDShwCgu6Q3iGwEnRTkCpcI8B3kvBjKIz2ACHRzYT55V1WZ
	KCBNXyrR/GrWp6tIbd4LGBSZv0HTvU3JEppZO8WRNOO8V7qB0H/XMR0UsXA7zsLWn3AVMQqmV+/
	Prm0AVs0GLKF+VGdMcB4K3Ik7wX6gozuazKVI2iCcGhFVddz/0077PAR/ScJwjJ3Kx59hw7ZvBJ
	J1FWvsV1NPGmzQXSs1Qg9ByK0+t1pFHGFc7AqJv6Dy62A9pdbSQAVcbY8O5NZb061eMxLjvm3eD
	TjvfeA5HDmHHLvgbV44oyqtmMRDZqCiG2y
X-Received: by 2002:a05:6871:3606:b0:43a:2320:8a29 with SMTP id 586e51a60fabf-43a2da085b8mr2687226fac.16.1778853753215;
        Fri, 15 May 2026 07:02:33 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-439fc4dcab3sm3990377fac.11.2026.05.15.07.02.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 May 2026 07:02:32 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: "Vineeth Pillai (Google)" <vineeth@bitbyteword.org>
Cc: io-uring@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>, 
 linux-trace-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>
In-Reply-To: <20260515135903.2238731-1-vineeth@bitbyteword.org>
References: <20260515135903.2238731-1-vineeth@bitbyteword.org>
Subject: Re: (subset) [PATCH v3 01/11] io_uring: Use trace_call__##name()
 at guarded tracepoint call sites
Message-Id: <177885375208.726485.17873052916016595792.b4-ty@b4>
Date: Fri, 15 May 2026 08:02:32 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15.2
X-Rspamd-Queue-Id: BD50F55112D
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
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
	TAGGED_FROM(0.00)[bounces-13351-lists,io-uring=lfdr.de];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	RCPT_COUNT_FIVE(0.00)[5];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,kernel-dk.20251104.gappssmtp.com:dkim]
X-Rspamd-Action: no action


On Fri, 15 May 2026 09:59:03 -0400, Vineeth Pillai (Google) wrote:
> Replace trace_foo() with the new trace_call__foo() at sites already
> guarded by trace_foo_enabled(), avoiding a redundant
> static_branch_unlikely() re-evaluation inside the tracepoint.
> trace_call__foo() calls the tracepoint callbacks directly without
> utilizing the static branch again.
> 
> Original v2 series:
> https://lore.kernel.org/linux-trace-kernel/20260323160052.17528-1-vineeth@bitbyteword.org/
> 
> [...]

Applied, thanks!

[01/11] io_uring: Use trace_call__##name() at guarded tracepoint call sites
        commit: cf9a29544a01ff818c7f0a01716dc5e48f8ad7b5

Best regards,
-- 
Jens Axboe




