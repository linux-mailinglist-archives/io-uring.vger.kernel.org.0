Return-Path: <io-uring+bounces-12047-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id mPLUHapWg2mJlQMAu9opvQ
	(envelope-from <io-uring+bounces-12047-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 04 Feb 2026 15:24:42 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 0DE23E70A4
	for <lists+io-uring@lfdr.de>; Wed, 04 Feb 2026 15:24:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 00F063008246
	for <lists+io-uring@lfdr.de>; Wed,  4 Feb 2026 14:24:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6A6C40FDA5;
	Wed,  4 Feb 2026 14:24:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="ms+4pUu7"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f169.google.com (mail-oi1-f169.google.com [209.85.167.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3FB719D8BC
	for <io-uring@vger.kernel.org>; Wed,  4 Feb 2026 14:24:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770215077; cv=none; b=TiQWcgsTStsm8ZQJiZMFXtk4B6LQ3ugimh2k4AwRQOi10sFjyZRZidhiAqRlMJ0Amvx1X3ZkKaVGknGOs4dCd9oeauEAtqmXRVKSpuh8KHZ2GYu7bxeaVXLCUbDLCrX64+yL2LSPg698j0MlqVfIO9CZLH4o9hQGW755ravNuyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770215077; c=relaxed/simple;
	bh=USQ/k67lSOHF8DSJ+/bHP63ykueZC+6AKBSK1o+5hQ8=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=EP+bcwnvn9idttniRsNqJ6pdK0clABjbqvPgioCJIZ1dRQo3qV0WEfssath95SBS5fc1O+FVRvbix9QJV/atIAFhkdJfl2+gVX9FhgtjsIUcs4zVZXEsCJYJvQgQBe6iLZEg58YuVk14OimWWNaAgrDbqfvof5DhzyaA1z5ddPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=ms+4pUu7; arc=none smtp.client-ip=209.85.167.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f169.google.com with SMTP id 5614622812f47-45c70afbeebso4496064b6e.0
        for <io-uring@vger.kernel.org>; Wed, 04 Feb 2026 06:24:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1770215075; x=1770819875; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1eJPXcgYDwLm1AFdJEXbRvzy853uNk47UlaCT2G2u8k=;
        b=ms+4pUu7eiFadZbvdDvDUS5BIkjmYlr8/o6VZ9kyMSbiD7AQSgGPgBbbSGisT9t4WL
         iZ9ZF3a0h398j6uCgNTGNyJ58GawPuYqB96LB6KGxeIHcrMYHTU03jbofVRVXBtXdznP
         ZWMPTTpXvDJ/RdNzAZg2WJArsnvfw0YMzZq/qlhJj9+553P05AdXzzYve/X21i2BiAjQ
         xXax+j1uPtrY8adV+y6cUGtutqbV+Inwwqcs+vHy7S2dT6fXl0N+mwayL9g0t2Gcznnn
         52bD65pQZyG7Y21KjnxwGDX/orceTiv51tbXlnylbgl/Ox5ccfJ3n6mJU7bjfQ5xULzH
         2iIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770215075; x=1770819875;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=1eJPXcgYDwLm1AFdJEXbRvzy853uNk47UlaCT2G2u8k=;
        b=k5/Lei+Z4mdTLl/AUxO4XwaOF+8TSLnD4qTqS/tMVU3q0vZUgh/YJzUWOTnpsAA2zP
         lf1y7CSlYNmmecrAZiOw0CCUuXeXvElyyFxtTs+gYZvYTWm/vezTOnan2SxJhSWJ394G
         ccI+qyGr1/YCvLSCm4eJ2ipj4F+v85NX1TNX0dmb70AKHEWqKrWjmXPQqHYI+FaPWNw3
         lmgGxg5Htl5iNj90M3uKTUE3SXjF6PhvYwMV8N4Axo8SmkzA0kotXMyfteFQmp0z8v2+
         AI2jix0QN/jr29PU448OCGfAtlRmWfk2guB2owJgKQtORphhJOuniXcfZ3uZAXKn1mww
         N5Vg==
X-Forwarded-Encrypted: i=1; AJvYcCUhGqEBDcrEaB3dD/kZETS+as1HQhc0pog9xtZ770hDQoDhAwVQJsjLx6GCRCXDHKI1q1Q7PAz50A==@vger.kernel.org
X-Gm-Message-State: AOJu0YySnE9k55V/LGjnqRRMajjdtEuUn9dH0nuzbEfpodsmO9iINqR4
	mz5/73SelxKyNSrSwR+ncGfuWaJpwEkhYiRYvp/JWtmCXQof4OyE6v2kF0gFx8G/jZY=
X-Gm-Gg: AZuq6aLeVhALBZw21pwSk+e37Bf2oDcDb2IB8tZiZOefoIuTWB1fcaGzajAp3ExRvNe
	+22fTe4uonvG1lJIYNUvVVODb4oqortjVdGvhgpWgeEAe+fMe/My5b68iQ4kG10T/2BKDhy/iTw
	Al7fj15hfWISXnR2xGTAfuDTPEvXv38O4ipY4FwFKFwTjlSQ/CoJ/UG9kR8WjounWWHqowkdIoY
	Ec0rN1PWSnVhKT7yFqAep2QPexMeQR07v534Ao7Z9XTllzwCJLSkCOMI5wIRV9HnPT9CixaJ0YQ
	5YCFBm0znXZkb5d3AmnqFQfzdSRMo3EkJrzXxfHBDAKxuK9yAKyiyoDHHeP77o6QIhrb3qnSjz8
	/moNdE8zCs/03r7VxPWVNp80MfZwk5S049cwzwNJKMCw8Li5Otie25hSWLcmH+/hRGw8JddK73z
	gaIoh0syqle5x/B6brBtPSm0vb2HWq+mU2cQOWZFL7LlD7bru1b2Y2dcjAPtIPObOsNsn/rlFY+
	A==
X-Received: by 2002:a05:6808:222a:b0:45c:8724:3608 with SMTP id 5614622812f47-462d59c53e6mr1510710b6e.35.1770215075334;
        Wed, 04 Feb 2026 06:24:35 -0800 (PST)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-462d66553adsm1422083b6e.6.2026.02.04.06.24.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Feb 2026 06:24:34 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: asml.silence@gmail.com, Tim Bird <tim.bird@sony.com>
Cc: linux-spdx@vger.kernel.org, io-uring@vger.kernel.org, 
 linux-kernel@vger.kernel.org
In-Reply-To: <20260203234624.1722921-1-tim.bird@sony.com>
References: <20260203234624.1722921-1-tim.bird@sony.com>
Subject: Re: [PATCH] io_uring: Add SPDX id lines to remaining source files
Message-Id: <177021507413.12691.2658326702670917313.b4-ty@kernel.dk>
Date: Wed, 04 Feb 2026 07:24:34 -0700
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
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	FROM_HAS_DN(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	TAGGED_FROM(0.00)[bounces-12047-lists,io-uring=lfdr.de];
	TO_DN_SOME(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com,sony.com];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	RCPT_COUNT_FIVE(0.00)[5];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 0DE23E70A4
X-Rspamd-Action: no action


On Tue, 03 Feb 2026 16:46:24 -0700, Tim Bird wrote:
> Some io_uring files are missing SPDX-License-Identifier lines.
> Add lines with GPL-2.0 license IDs to these files.
> 
> 

Applied, thanks!

[1/1] io_uring: Add SPDX id lines to remaining source files
      commit: ccd18ce290726053faff75b6fc3e541301ac99f9

Best regards,
-- 
Jens Axboe




