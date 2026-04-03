Return-Path: <io-uring+bounces-12954-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 3KUBK44J0Gn22gYAu9opvQ
	(envelope-from <io-uring+bounces-12954-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 03 Apr 2026 20:40:14 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id DFDBB39755D
	for <lists+io-uring@lfdr.de>; Fri, 03 Apr 2026 20:40:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 19528302EEB0
	for <lists+io-uring@lfdr.de>; Fri,  3 Apr 2026 18:40:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9B8827FD5B;
	Fri,  3 Apr 2026 18:40:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="GciOnZi+"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f47.google.com (mail-oa1-f47.google.com [209.85.160.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25136625
	for <io-uring@vger.kernel.org>; Fri,  3 Apr 2026 18:40:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775241610; cv=none; b=Vbl+z/wDuUn3BehO/R5xE3AFDwcPVea9cEMs0ww1ZZELp/b+7MuhFqm0bhDqK7sOAwyGnT5x4OqEe9H9gl/Hwq3U1ZLkIT68ArPwPsB2roZqtC5MSI8sjl6DfyqTSVnKbWev2ypkE7vXuIeNgEJea3QMb1Uy1f6L+6fhTWsw7tY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775241610; c=relaxed/simple;
	bh=bgTXZ4e0KARqZjBaH6Fy/4KRztYiFatpAs4Peoq1i2M=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=rGm7AhBl/sBVaJ53FnCblk79k6+4S0zXzn7ouiwUQ6+75VISDxZRKCn98EsO0aC7u9aTk938Mc5+Jnj84TkeSOlwwCI7N6Z61jdjcKfhfJQx3J4L6YvZf4uMLEsfkK+ca5XBLVT8brIZ6N2Lo2+jcL8PBhmVf92Lr7AuS9aGKaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=GciOnZi+; arc=none smtp.client-ip=209.85.160.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f47.google.com with SMTP id 586e51a60fabf-40f1ffba6a0so1498927fac.0
        for <io-uring@vger.kernel.org>; Fri, 03 Apr 2026 11:40:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1775241608; x=1775846408; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=73i/yijj4TDhj+c/SKksTJMIjSwvazPaZ6ziFjblEw0=;
        b=GciOnZi+LAxvEoWPAkkiPrNZxO5ikvyk3cVpnrPUclgj8APKhv61LiqR7SH/4j7H+J
         V4E5hXzG+MntDKjOdx5n5tjIn1/8isMVxKU7BdwvDAxbOR9xqGce6dw11NigKWhyYxek
         nmnL18a8iccQTq9MYOj+o6WbQqCpqSqS9slwedeqpoY96BERUGXTB0hhJsL2WiimV/e5
         h7f9W/Vpy1BCvW7wv1AZtqzkP0PvyzLjqLHVYxcCBXnPjf7V22MZ79mr4aTMr6Bx2uuF
         Jz7nZkUiQ9USvsrjO89wP/CUILwyvTuZRGkQTkqtvas6GE4CtfcKlFYsfvV9rjdiNER8
         exsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775241608; x=1775846408;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=73i/yijj4TDhj+c/SKksTJMIjSwvazPaZ6ziFjblEw0=;
        b=lkIKRlOpEQtUZOMsH101HXr/MD9hTB+p1tbmde2vB2/RrCvd86wgvZ3kHNUQrWCrHG
         xvPpYDjI1WQpjRsy8RbXXOoND9/2/qoBvF1UO0JJH3EzjEx0+AO3/gCDNMJ3Z+HGOoqT
         TPeLlZOGlahR8rIABTzgyVABRYwiVYRp9M0kjJYqBJrMf+/QWyf38ohqLrorqb0Y5TWX
         61Pf6NnE23kXgpC//lhl13UBxyf9WUQFQu1RJn8jyeC3TGRNQpc41ZKebKTNgQqks+oG
         ezjfqDqpoEsU7LzAc2/jdX0rS6Qalr0Joel8IXcRO/JMIgk7ahywmYcoUQUV8PtQCp78
         Vgcw==
X-Forwarded-Encrypted: i=1; AJvYcCW+zpvVGAvy0/Pg1s3zMWD5U0kDoisTCxeF8HyT1yOm0zBGTUn6sKbSnyKYuCnbXP0DLSON76QN6w==@vger.kernel.org
X-Gm-Message-State: AOJu0YxKSP2fL4npM6/LIDjytTLlV9NlzOmJWvoitsu/8mSNFxV7nuc5
	pwA+9a2TDBiiaZ2iZ+9otRb/6rkFlJxzY7BZepePY5vKfZuYVWf8Qa7Y461bgpjBvng=
X-Gm-Gg: ATEYQzyT2huFZL87J8mXv07sD+pbKzPPbbfZbxPKx7GPmnFq3RtvVYfZw0AMu6pVHO3
	187hc9L9xIk+LIBt26egtFQWZMeYI/vp33JF0K7x8oymZRsGIw+gq0BW6hIRQEK3EGRDboij8cM
	D8/r8P7PpgPPUIDQ3QM5QUZmJc+yCETjYZOCLZo4rHLF23V85Y2T2AGVW05jvh7ID0dJZAQmoi2
	kU19p2zcCSlyGN2bMYKU6DpdbtrFQ6tkpFojfjx2mH4p3o4kX/V5IaHDt1Xf6Dy10YBeS9YNCXe
	MpAbhelowV3N7+h/1CO3ydSJ1GYymbQwF9bBwjcNJbAe3ShgCyBVSqWIUB3xScRhUlji8Qg1Fui
	rYy1nJrbVtrE7ahcuDbGGubD1q5BbFSWBH+JsqGCXUtR2wJmNDlmXC2u4wHIQJ7lRmHcx/garu2
	jbVR7J/pxFzJAIxNTOnGBHvTgZlHxtuYoDbcnXDWGthFaaJWq9m/ZWCh0hgIkPgHAZnlkpHkfL6
	YA=
X-Received: by 2002:a05:6870:ec8d:b0:417:a815:e59f with SMTP id 586e51a60fabf-4230ffc8c13mr2108615fac.22.1775241607873;
        Fri, 03 Apr 2026 11:40:07 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-422eb25acbesm6404773fac.11.2026.04.03.11.40.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Apr 2026 11:40:07 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: csander@purestorage.com, io-uring@vger.kernel.org
In-Reply-To: <20260403174139.3634824-1-joannelkoong@gmail.com>
References: <20260403174139.3634824-1-joannelkoong@gmail.com>
Subject: Re: [PATCH v6 0/4] io_uring: extend bvec registration
Message-Id: <177524160686.130036.14064983242704180206.b4-ty@b4>
Date: Fri, 03 Apr 2026 12:40:06 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15.1
X-Spamd-Result: default: False [-1.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	TAGGED_FROM(0.00)[bounces-12954-lists,io-uring=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,kernel-dk.20251104.gappssmtp.com:dkim]
X-Rspamd-Queue-Id: DFDBB39755D
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr


On Fri, 03 Apr 2026 10:41:35 -0700, Joanne Koong wrote:
> This series refactors and extends the io_uring registered buffers
> infrastructure to allow external subsystems to register pre-existing bvec
> arrays directly.
> 
> The motivation for the patches in this series is to make fuse zero-copy
> possible. These patches are split out from a previous larger
> fuse-over-io_uring series [1]. The fuse zero-copy work that builds on top of
> this is in [2].
> 
> [...]

Applied, thanks!

[1/4] io_uring/rsrc: rename io_buffer_register_bvec()/io_buffer_unregister_bvec()
      commit: 29ebfdd7db89514b9a6dea9feba6e2f9b90079bc
[2/4] io_uring/rsrc: split io_buffer_register_request() logic
      commit: 367978400e3b792b702e0710d9faaaf0acf2cecf
[3/4] io_uring/rsrc: add io_buffer_register_bvec()
      commit: 33ee911b8e6230fb5c939ed19d159c227673321f
[4/4] io_uring/rsrc: rename and export IO_IMU_DEST / IO_IMU_SOURCE
      commit: b09efaddf67196b74160e54a3fc45efa3fa100ee

Best regards,
-- 
Jens Axboe




