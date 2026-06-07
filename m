Return-Path: <io-uring+bounces-13633-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id 7o79JFjtJWo7NwIAu9opvQ
	(envelope-from <io-uring+bounces-13633-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 08 Jun 2026 00:14:48 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id E6F9F651CB4
	for <lists+io-uring@lfdr.de>; Mon, 08 Jun 2026 00:14:47 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=kernel-dk.20251104.gappssmtp.com header.s=20251104 header.b=QNVAOFXG;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13633-lists+io-uring=lfdr.de@vger.kernel.org" designates 172.234.253.10 as permitted sender) smtp.mailfrom="io-uring+bounces-13633-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=none;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 1EADE300D442
	for <lists+io-uring@lfdr.de>; Sun,  7 Jun 2026 22:13:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1C523385B9;
	Sun,  7 Jun 2026 22:13:35 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f42.google.com (mail-oa1-f42.google.com [209.85.160.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F328331194C
	for <io-uring@vger.kernel.org>; Sun,  7 Jun 2026 22:13:33 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780870415; cv=none; b=VtO6T0ulGHPcqH6UN9R3HIaG6fWkc0AN6yd35yy0BT6sLWTN6K4Omo4EwOSfCaWf0MfF+bnQDIeSMIO21Zwz1S63Io+cwV8G3ZNEbPWf+aU+bxFdccwJlZYzogdaZiOyjoaW9WYL6REM86qWcgUr04oDVMPuNkHrF9n9ykAtdGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780870415; c=relaxed/simple;
	bh=KWSv6YB7BB8l+zPDe61MTPYJavxf9Y0hWfvZ906ER3I=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=ROfqmH3V7dlYoumDe7tUVPRfvNfldfuEnPvcRCPKRHaVzUvArHVVPbHT1I/m2YzM5+cFCalLr66bo3Jj92s7TOHsqjT3HxE4dNZgHRtNFbVnBGMMPtF/sg3aEnwrNTv/aoz4OMdNdMUIEE73t44qcpURVYZnfnWHWQgNyvYmcI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=QNVAOFXG; arc=none smtp.client-ip=209.85.160.42
Received: by mail-oa1-f42.google.com with SMTP id 586e51a60fabf-43ca73487d2so2528139fac.1
        for <io-uring@vger.kernel.org>; Sun, 07 Jun 2026 15:13:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1780870413; x=1781475213; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YdbCIozaMzK3ixrukTcdtgHCce/WRdA4aHEPyzy/yAQ=;
        b=QNVAOFXG3Y2yeklAleoi0gX55RkJ6cm1+2zIeW4TBOM1mFQoycD6y/msDf43JQaTtR
         dvzXR9XcmfnipJIVe2uA78GVh+Rlwf8dxroxTtxcvlSSrYhUdec20UZT2hQs/SBABib3
         8WgKlvpi2O4ZHyscDDbS9TeswHfDZLfE+Pfjy5UPbfdaG9Fv/JBesF55ZPR+gJ2GyjC4
         DB/QxaN/KaRlbcdi0ykYQQp2mGVmm0zWOwm/JCH5Eyq6QC1eHE2yXl2q/f+/8u+NIEyL
         WPGBnrmkvpjsQZTSMxRkQPmCQaud6D7NYiRXABjHose25FL9TZ1SHfxD0ogenPeHqlI6
         uElw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780870413; x=1781475213;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=YdbCIozaMzK3ixrukTcdtgHCce/WRdA4aHEPyzy/yAQ=;
        b=nMYTU84VOqdYfrxDwO85MCiqPYOyQ/HQ0ypor/cx3cvzLIXmxGJCDONBbJXAqNKbi7
         Dl+zbFo8qkb4f0QEuMKORSAo9YootHGH+4wGXFu+XKQD6eIUENLk0WwZszfrasZNAPq0
         LMjogRlSGaiGC/wMjtYtll5vgQ47S8wfI8A9PoUCwU2uOQrK/u4gJNOz2AcUgFJ/8xIq
         6f2fuHVKqpl2mRxXHtSgYfinS5AVWnteoYdojV4aF/f6sVPv26Z9utIVSRJpdiUvuw3J
         4R7CIVNVFtOfHQoV/Fw0e80pv88b6q2bROQeZh3reQsX3e3YsyTfXypS6WUPIGvq8fA+
         UOKA==
X-Forwarded-Encrypted: i=1; AFNElJ+t7oehNysiUOnLUdwr1p+0YqB40POK6B86WYwXTALQH/TiE69UhuD0v86i47UWnJcFEiuG9KoSPw==@vger.kernel.org
X-Gm-Message-State: AOJu0YyiPJRYQjy7MCPs8Pi1Ycq1nUfjJ2ZW8DBV+6i/yBwhLuedyFAn
	OucYD1xBGtVyiBCY6n1RjS1qQECC8+mtmqteAWJ7unnYuQuCa8sfTzDjLbP0fzn377cy/BWwxfx
	/n5YK
X-Gm-Gg: Acq92OFbqvPzfLrHIa1C5LquU/3qtWXdS9BW7K6MaY3sIcu4gN3QqColhMrIfyxljwr
	SkyathsLOzvrFNzGa3o9HYOXNARhr7PxS1DAqCfR331JztdCXnDjdmcCkVzSSmXLGitVsdnCy7n
	VchG8E3rk0lWRgD3V+B7FOJMvwkrNLJwdH6zSa8nBF0kuk6BwTYC6WNDvjG+axfeU9vSUwFHklW
	iG06cCdKetFU8uBEQTmQqt21f7kZoMHTgFYfwFt7av2npwqefdLBCj+8oRjepxJj+x0R/e1nuHU
	BtrLdpSmarMP8U1azSqLjetwGooP4HQH2mP77aLsgiAGIfPIeiIyR1Ur6rCywf9djpIONYxhhDm
	MC4oBKPbZpOcA6gTK+eTaOuQs7Avz3Q5pznC5fX5MiGfgx0H63TBXiIFOb5rLBRqg67e5yjtt0d
	ZoUP3nGMbmoK2LMpYV+siZgQyifspcwW28uxGnVM8P5DngwAFLAO4a7oVyh+tRlKixHUt5MPYvo
	UULYpyqdtUEg5Y=
X-Received: by 2002:a05:6820:61c:b0:69e:3868:a739 with SMTP id 006d021491bc7-69e6d51574emr4512744eaf.24.1780870413073;
        Sun, 07 Jun 2026 15:13:33 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-69e88a9f72asm2092151eaf.11.2026.06.07.15.13.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Jun 2026 15:13:32 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: "Christian A. Ehrhardt" <lk@c--e.de>
Cc: Tip ten Brink <tip@tenbrinkmeijs.com>, io-uring@vger.kernel.org, 
 linux-kernel@vger.kernel.org
In-Reply-To: <20260606201120.1441447-1-lk@c--e.de>
References: <20260606201120.1441447-1-lk@c--e.de>
Subject: Re: [PATCH] iouring: Fix min_timeout behaviour
Message-Id: <178087041152.983208.11032629125214137499.b4-ty@b4>
Date: Sun, 07 Jun 2026 16:13:31 -0600
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
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:lk@c--e.de,m:tip@tenbrinkmeijs.com,m:io-uring@vger.kernel.org,m:linux-kernel@vger.kernel.org,s:lists@lfdr.de];
	FROM_HAS_DN(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-13633-lists,io-uring=lfdr.de];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_SENDER(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	ALIAS_RESOLVED(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kernel.dk:from_mime,vger.kernel.org:from_smtp,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: E6F9F651CB4


On Sat, 06 Jun 2026 22:11:20 +0200, Christian A. Ehrhardt wrote:
> The wakeup condition if a min timeout is present and has
> expired is that at least _one_ CQE was posted. Thus set
> the cq_tail target to ->cq_min_tail + 1. Without this
> commit a spurious wakeup can result in a premature wakeup
> because io_should_wake() will return true even if _no_ CQE
> was posted at all.
> 
> [...]

Applied, thanks!

[1/1] iouring: Fix min_timeout behaviour
      commit: 29fe1bd01b99714f3136f922230a643c2742cda9

Best regards,
-- 
Jens Axboe




