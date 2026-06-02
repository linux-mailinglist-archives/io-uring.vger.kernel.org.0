Return-Path: <io-uring+bounces-13590-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id ghAdM8ARH2oKfAAAu9opvQ
	(envelope-from <io-uring+bounces-13590-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 02 Jun 2026 19:24:16 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 4071A630AAB
	for <lists+io-uring@lfdr.de>; Tue, 02 Jun 2026 19:24:16 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=kernel-dk.20251104.gappssmtp.com header.s=20251104 header.b=panmJ0VX;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13590-lists+io-uring=lfdr.de@vger.kernel.org" designates 172.105.105.114 as permitted sender) smtp.mailfrom="io-uring+bounces-13590-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=none;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 171F9302EA88
	for <lists+io-uring@lfdr.de>; Tue,  2 Jun 2026 17:20:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A34EC3750B9;
	Tue,  2 Jun 2026 17:20:42 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f52.google.com (mail-oa1-f52.google.com [209.85.160.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B96B82E36F8
	for <io-uring@vger.kernel.org>; Tue,  2 Jun 2026 17:20:38 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780420842; cv=none; b=rJnKfPbUI/OXEjc1yD4xqImHSjtooIIAT8OyeEqJMpF/llewGBBPAAEH/96oZ3/Ie5wXnFeMl8GdOflo7Gd2AJp7eBT6m28JujyiDW6A2eOO6g071a2VVLozmut34S/8fYkmKKlA9vW6ZdBckXuA+ZuddG58ToP9hyoVkJJKHK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780420842; c=relaxed/simple;
	bh=H+MoBAvkDRbRTAE1fwhgV8BRws1/74D55xE7GMKFkP4=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=bQzFOq0vFanux2niWxiMHV3fyvrT7XaeflHMXxA3O5/HHHaq7zQVZyEke6kNujykTNalXc1kSkdnITyf6my/7kejCjCD/n/Ct9o0OQUqywX4QCs1IyYHNjP16ClBRZS3DGNP44TjxdtU2Bzn2H47I3pa/RjuZ3vsPd4+Kc2eTTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=panmJ0VX; arc=none smtp.client-ip=209.85.160.52
Received: by mail-oa1-f52.google.com with SMTP id 586e51a60fabf-43cce7db292so2137537fac.2
        for <io-uring@vger.kernel.org>; Tue, 02 Jun 2026 10:20:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1780420837; x=1781025637; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=txzhxRKsiDelssTz8KZvZqcbEthxdCC0qzK2QC1DmHA=;
        b=panmJ0VXfz8oAhmwBg2DJ3S5rmfwS4ONQxHAxx/WhL9EBQiFM8SAyVtyi1XiAHK08U
         DNIp/rJFI72U785XSfpJX8IdkOnEt+CpgsB4DkfIrUJOMLRwTSfxcRzBJuS7DPlFB6yb
         cnrNvXXleo4p3w9WGfpbvWAtCXqNxd9ngG4b5VNQZsb5Bjb2SjqNux4cBqK4Kh9AtKue
         l+zIhkJH+nFRdCjp5Y6hRIO/IIVMv2IXan4FLkUv/HPlWMsSi/VI8wIvUJDZEtAjLxvd
         FWhO34WsEdrbsFqgdtpOsmR0u0IXL1RaxqsjjIMuJKITOL3VB9Fodt6GZiH85+GOt7M9
         84fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780420837; x=1781025637;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=txzhxRKsiDelssTz8KZvZqcbEthxdCC0qzK2QC1DmHA=;
        b=gc0jgmJ0vvx2i7O1+ZOpLitAnMUFxkZpU/tc02FbpYc7q8sMRUxjU+akTI8GA0fSWw
         9V8szdctZ1xggW6lVRLzDGf54G1puLmO7Kvb7RD0Chpe5FFBwCYMn8/H3VGbVVHremE1
         puDu5eg10aCxoD/LNoTtZ6s+db6qz8x5VExSCXHN1vFCa0Q/l0lDM2stjIXeUWmUKTaQ
         FXjQTdhOHwU5kCzneBY/Y6V3zcwp30eimidGIhn9ltCPxFLuUisoB16ujEbtXZF+jpPH
         oVMF1IlLoXvEQsoTqcUGDZbN46qqoqOvydlPE/ApPLwA+G48TH6XkqsUeqL6UJvfKk1E
         j+Bw==
X-Gm-Message-State: AOJu0YzLYaPaKwEyJUMmgyCUlThW+FF43E5HJn2e5stLuvM2DOvw4scs
	1EnZOuvRht0YZ5Spd5aDmyvw5yv9nKgIchISsqzedhIJuAR0huE/SJ4PxxCNu7VnWans8nrCtuA
	pMrOX
X-Gm-Gg: Acq92OErd3LKofciYWaM05k1GGr8C6XhpeRX7GPukq++/PM1Wpc+I4Iv2DC/9AgKEVA
	NbajqGFmZ1EH4GU5caBX1HHSn5Oi2pyTxBrseG0DePwjzl6YXbBJH/aFHkbbcACwXoxKjDBeZq3
	B/vR7PI7jU7AJDBi/PIKIG90Rilw6Q3KVOYjj5ZjSZBJugpvZhfAM2k5xNvQ97FK+zIhl9VSFs7
	FUjS36zP7DAwwyDqvdcKjMVEam16v2B2Vv3fKyM6+l3Qi3cvhapoXRTzNV+fO2YhV19Tm06VHDk
	+GI7zEyyHU1HbUQKVc9jnpZSr2kRMPK3zDTwoCBjvg5evTGjxSH5ipNTJHQ3+NN1Hzr8UTwH4EF
	o+zGh3c4YT+ZMe7SaebbGTmgxvS9yL1ZxwIdvp8UnoSfcdV+KYBnByTqnpHkSkswmtc0KlEkJdN
	dM2WnhoGaByEV9j+4DZDy4dj2SBLbzEYiwqDRuZnT2JMJ6XebWb/NaYp5aYphz8yxP8b7aoUASi
	IS7YX93mDiNBA==
X-Received: by 2002:a05:6870:a797:b0:43a:ef08:6551 with SMTP id 586e51a60fabf-440da01e5bemr23864fac.5.1780420837409;
        Tue, 02 Jun 2026 10:20:37 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-440d84c0ce2sm169246fac.16.2026.06.02.10.20.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jun 2026 10:20:36 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <5f6ca3649e9e0bae8667db4357e28dd00cd07901.1780394491.git.asml.silence@gmail.com>
References: <5f6ca3649e9e0bae8667db4357e28dd00cd07901.1780394491.git.asml.silence@gmail.com>
Subject: Re: [PATCH 1/1] io_uring/bpf-ops: restrict ctx access to BPF
Message-Id: <178042083663.560797.8108073756982087463.b4-ty@b4>
Date: Tue, 02 Jun 2026 11:20:36 -0600
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
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS(0.00)[m:io-uring@vger.kernel.org,m:asml.silence@gmail.com,m:asmlsilence@gmail.com,s:lists@lfdr.de];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	FROM_HAS_DN(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_TO(0.00)[vger.kernel.org,gmail.com];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_SENDER(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	FORGED_SENDER_FORWARDING(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	TAGGED_FROM(0.00)[bounces-13590-lists,io-uring=lfdr.de];
	ALIAS_RESOLVED(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	TO_DN_SOME(0.00)[];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,vger.kernel.org:from_smtp,kernel-dk.20251104.gappssmtp.com:dkim]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 4071A630AAB


On Tue, 02 Jun 2026 11:08:25 +0100, Pavel Begunkov wrote:
> BPF programs should have no need in looking into struct io_ring_ctx, if
> anything, most of such cases would be anti patterns like looking up ring
> indices directly via the context.
> 
> Replace it with a new empty structure, which is just an alias to struct
> io_ring_ctx. It'll create a new BTF type and fail verification if a BPF
> program tries to access it (beyond the first byte). It'll also give more
> flexibility for the future, and otherwise it can be made aligned with
> io_ring_ctx as before with struct groups if ever needed or extended in a
> different way.
> 
> [...]

Applied, thanks!

[1/1] io_uring/bpf-ops: restrict ctx access to BPF
      commit: ec02fe217fa66d79f8a65e8d28be9295c7f85093

Best regards,
-- 
Jens Axboe




