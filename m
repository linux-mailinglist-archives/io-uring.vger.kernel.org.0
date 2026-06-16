Return-Path: <io-uring+bounces-13751-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id KKUEOVdyMWozjgUAu9opvQ
	(envelope-from <io-uring+bounces-13751-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 16 Jun 2026 17:57:11 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 758916918C7
	for <lists+io-uring@lfdr.de>; Tue, 16 Jun 2026 17:57:11 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=kernel-dk.20251104.gappssmtp.com header.s=20251104 header.b=kJB7E0dc;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13751-lists+io-uring=lfdr.de@vger.kernel.org" designates 172.232.135.74 as permitted sender) smtp.mailfrom="io-uring+bounces-13751-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=none;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 32F153043F0D
	for <lists+io-uring@lfdr.de>; Tue, 16 Jun 2026 15:49:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E612E364024;
	Tue, 16 Jun 2026 15:49:13 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oo1-f51.google.com (mail-oo1-f51.google.com [209.85.161.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DF9244104F
	for <io-uring@vger.kernel.org>; Tue, 16 Jun 2026 15:49:11 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781624953; cv=none; b=H6pU0A9C4nhhF+Y1Wl2lQcy1QUIBzVTxLb58mrn2gHccARJD58V2cc4ckj6NOUbnloniloT3TyqQne4UT+27v+ksSdZIAgwgABbfZAS/qdA6uSlrRs17yATVOPxrjjEgxb7tNz9Z1RdTPf5jUKEMLke9OG0/4jNg+8AdLy1rCa8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781624953; c=relaxed/simple;
	bh=r0AK/4YrcKFxY2xUAkAtfMJTmxeEB48SGQppjaj6/us=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=dSPpn2dS/7+E3qHtJK4AnRmGZmV3my9rzZap385MTTjekMm6tDdbrtk33vDjDM09mnw2/cdcCLsh4VanMqmz6uqEVyBFXyJcuCVuQyjbJjQ8CUBgD9yfDm/XNblXVrJNTbhGamFiDuo7jJduqZrIbqhgDHQVKWEyTTWaNHfVokI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=kJB7E0dc; arc=none smtp.client-ip=209.85.161.51
Received: by mail-oo1-f51.google.com with SMTP id 006d021491bc7-6a0a0b46cd9so659317eaf.1
        for <io-uring@vger.kernel.org>; Tue, 16 Jun 2026 08:49:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1781624950; x=1782229750; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=70fqFEm947VbkU6gs3LBTyckLcbn4fupq4AOOEXmMRM=;
        b=kJB7E0dc43ZhOXC3ooDYQd1bS8D1bb6Of/VjD/il2evUK32UpRR/o123gufljiArKN
         +LP9Z5Nflx1MVbke+wyNHi3WVRErs6+iVDqRBj193wZuioRXdDYZxo47rfDU03flNvQp
         GDcw1WQtZzzPTR/ndS1pjZnEB4LBWEuPTTyX7tWNBSXuqo2i8VesksyMmJnxBHxRjxkT
         HArsqRjL9kHz+6AbP229a1/afgWdGDxx2wcFOLItpow/rh7NpBP0eKVCngmaV0VYs+/K
         E0CKn4CZGpgwlplK4LR7RsSDiAnK8Uz56MaYMvEV1kikmEKYFIXN3Z4nEhNc84y55utv
         gSBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781624950; x=1782229750;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=70fqFEm947VbkU6gs3LBTyckLcbn4fupq4AOOEXmMRM=;
        b=Bfy+YXjmq6vl5SaXtWzCdVOGTyTCCLNE5UnWFtA3pk2A0bqJgX9P/L6PNlpUzwoA5n
         Acm1ayxuzqJjlruoKoyvNMjosN/pl8UNvkmj3lZGzo53vBMdKU/SM5QALTX/eCsqez13
         sOk2TqkylMQRfAl0WqKqdUmVP2WLHefnjC/TMxz4i220fuobf113UjxUSHXxl8D09B6L
         6dOqJ957WR9kV2vGPSPYoIeWE3mBrd9V2uCFRm6FdrOtXQKIIHPBMk67M+ajFMhM1eq+
         NtnPh7DbzvFAVvsZUHpSFTZ1r5z5UNcUsfX+YjDLD1/Fijo5HjuDHOX9oQOdZiLIj6CE
         JSlw==
X-Gm-Message-State: AOJu0YxTRJp2zQq6iiBrLP+st0/1Jqtb7SZOeXVBWjVxOpYX2I3SKldw
	fZZ0ADVG8r7EQgH0By34Q3nZ3+wI4tlMmTHKMcOgI1YgWWjYhlzpfF9EDjW7jNrDstUH0ao2xZU
	ogbHFLi0=
X-Gm-Gg: Acq92OFiXDcTOpQHCJnDWKttUX99l3K3vdZUV7MRPYybnr/g/ZNCCnMfSFSpH4P793z
	96hCBAxTiWNlqGTEZO8rXynCkJB8FNI58DFlYNbjRemayE2VSFWVhTq+hqyPPeMXBj7YcajNGKw
	y3+nlESPTp0W06N+F+Hm1Fjn2tyq0OabEfb9p9DUR6r6L/f5mV06RIw9vJX5aVwxMzd4xX4VdzK
	CyADADeCYK5z4eKIUbLK+8zzE1Vz5/qRNhxQHIwhwDaMQva4Ssox1gj1EFmg5fP8UW8vX9HTx/F
	/H1+NXZtkDg1ZGystcYlCibuwR0XDhWZa+aiLTzdcmVUlRwvm5ML237+8J/IF+LTeyjHgbrjuOY
	xMDXrXT18ViDFTlbIde7s0b7rD1iwYwZPjm2/Fg1ERuEkN+/2Q0kO/7x3mzKqpk/5/EDbIqBHrg
	RTelxB0xkEs7XcgOHx2yVh/9LDHgGHVTBtNd357EjWLZ8kTARo7q4cLDP42i0t+FYBkBYxUlgRD
	ULqOVTXfnd5z4A=
X-Received: by 2002:a05:6820:806:b0:69e:89dd:175a with SMTP id 006d021491bc7-69edc622308mr11504270eaf.20.1781624950391;
        Tue, 16 Jun 2026 08:49:10 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-69f00edacdasm5054586eaf.11.2026.06.16.08.49.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Jun 2026 08:49:09 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Ricardo Robaina <rrobaina@redhat.com>
Cc: paul@paul-moore.com, sgrubb@redhat.com
In-Reply-To: <20260616123632.3209545-1-rrobaina@redhat.com>
References: <20260616123632.3209545-1-rrobaina@redhat.com>
Subject: Re: [PATCH] io_uring, audit: don't log IORING_OP_RECV_ZC
Message-Id: <178162494946.2184109.3179193650867699448.b4-ty@b4>
Date: Tue, 16 Jun 2026 09:49:09 -0600
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
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS(0.00)[m:io-uring@vger.kernel.org,m:linux-kernel@vger.kernel.org,m:rrobaina@redhat.com,m:paul@paul-moore.com,m:sgrubb@redhat.com,s:lists@lfdr.de];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORWARDED(0.00)[lists@lfdr.de];
	TAGGED_FROM(0.00)[bounces-13751-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	FORGED_SENDER_FORWARDING(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	ALIAS_RESOLVED(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[vger.kernel.org:from_smtp,sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo,kernel.dk:from_mime]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 758916918C7


On Tue, 16 Jun 2026 09:36:32 -0300, Ricardo Robaina wrote:
> IORING_OP_RECV_ZC is a read operation. Audit only tracks file/socket
> creation, not subsequent reads. Set audit_skip to align with
> audit-userspace uringop_table.h.

Applied, thanks!

[1/1] io_uring, audit: don't log IORING_OP_RECV_ZC
      commit: bdc2fc388c348ee14b4f984ff75f2ea440cefd44

Best regards,
-- 
Jens Axboe




