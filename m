Return-Path: <io-uring+bounces-13005-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iOweMNis1mncHAgAu9opvQ
	(envelope-from <io-uring+bounces-13005-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 08 Apr 2026 21:30:32 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E9993C316E
	for <lists+io-uring@lfdr.de>; Wed, 08 Apr 2026 21:30:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 38EFA3006B17
	for <lists+io-uring@lfdr.de>; Wed,  8 Apr 2026 19:30:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 41A84370D6A;
	Wed,  8 Apr 2026 19:30:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="ar7qDXnM"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f41.google.com (mail-oa1-f41.google.com [209.85.160.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C1CD352F9D
	for <io-uring@vger.kernel.org>; Wed,  8 Apr 2026 19:30:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775676629; cv=none; b=UtwjIJNZBCfJZScNe+9Jop1l8xdAtLZOOPWaDwXO1tva1dks5YhuEKxVMoxPqO8mWK+YOZvICIg5vP9q398RyF6vP0fa7N4LQYqEovWub0xP/AqY1BaOQSSotBJWGIraTjVjHjpGYHuVhBOFsZB0Fn89zCYbyEUqJ18R2DSzSVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775676629; c=relaxed/simple;
	bh=gOBOy+Fdc/WEa8pSQIDVTOaXMYCpJR7JVAkqjcXGECo=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=XLOp96j0II/anskeH9KJ4FuSSZ4bIMn19MqIpHWLwCEfh1Gp4GQNgOqRxAzqys2pEPkfagqjrifJeERUE+tWNGmS4keCltUABfZKHYV/6OL8a52ItFLzGBD1U3SF3uA6idqPpds8oIuT5ajxQFj2erdNuUE8R2m3vYHfpdO3T3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=ar7qDXnM; arc=none smtp.client-ip=209.85.160.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f41.google.com with SMTP id 586e51a60fabf-4138136f02eso99416fac.2
        for <io-uring@vger.kernel.org>; Wed, 08 Apr 2026 12:30:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1775676626; x=1776281426; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=ZKuZki2H5VX5XJJ99G1qDEf+BaevHybq1gu7W6XV2Eo=;
        b=ar7qDXnMknQISlDIflTyHqX4dQIC1U8BrAHZguhdkMtse2ZLS0DWHnOO8DTKEFQwv8
         nK+h/W6CXoKptU33/WLHctXjHU2dWsA4HbxvnIS73UiaKfvtmEgQVIFpQYOYz7RD8UgB
         /ozQp/NKnSBO5766mR6QAxhUMYAc2H2a+yAoDztF3fAGrApMCtPeHjiN+ZeymydHQKWm
         jnxVTQA4DfrLsRFg4+fTBis/3yTOmiG9i7s0s+jywttCarx8Njj7OENr0NhHESSksN+D
         r1sBs1sPORUp4y77HmoplPCtfgqt57ozAYTjCfShK8boodlyVP3iWhfmARycyralj7tB
         m5Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775676626; x=1776281426;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZKuZki2H5VX5XJJ99G1qDEf+BaevHybq1gu7W6XV2Eo=;
        b=Qr9Uav1yuA8Y49j6c1lXONF8+vxUpeczHrF2H0+FOpc8/WeyaMSWKB+/fLvxUZ669u
         2vWG7B3t1Ijqud/8AiQuJ0yy9UUMx/mMBt6bB0PwKIEQVOiboDLn0YnqT4Kt5gZS9mnf
         2+QMvHhObzm8DDWzTJGLLJdwt0uy+Oq/qYyrY/vvtg52VodgG6pOTnFsED8dvOuMV7Ku
         BSzzP/eZFbyHXJ1WgxhqvcF9CuEQC57D/tR61KN/YMLtkfMXXL81d7O0v8gFvSRym72V
         h0NkLEQZ5W++uhff8efN0anioV/7BcOp4IUQxF+ot9aqhV+vWlcrX7sL5qmr2Fr1rJT2
         7Y4w==
X-Gm-Message-State: AOJu0YyWMd3TaSUbJ5JZvkvAJI4Y8Kc7SxFgYao4Ryg1BdZ9qxN+ylN2
	9SdciiSn8U197yM9CNdJlUvt7A/NGJ9XeZa/rmHVCodf4Mrn1ES3YrKvSgl1yJPlFMpH7pFpByr
	11usq
X-Gm-Gg: AeBDietT8lD+rtGOMFeHmRK+WPGo2kryhTKfh0DQCevqH8fY6j7Be8E9lpNStk2vuqQ
	9DaCNz8+5N4H8Hewm+dSuHxxxQ1YNWB24bhIOHl0o0RJZcLG4Xc9a1XrMkqGnRFUBxQsfPzT8Zm
	GoOlzOBbD8XjfxvPFOtkeERJutLN5QR5NYmxLJfEPPYFk3qmxNflccWJDp/zb7x3wdx/m3kcGtR
	4ca3EHfw1kR2dlBx7ZZO7vC/OE8eDCn8F2T90CBcTA2UsEVxTC3pRlUvfajgRwVaoTAnv6zEivQ
	645HrchyYG+kaXsS37ed0dcbQsA4+R4sYnf9HSLYVGMQQWLsc3jvDRz82bEv6pCOeGEiW6JgYsp
	/0hRjSAK4sXoYSNvb9wwMW1sWgObGfGzVxGuZ9t13oOJRxa020VkmN9G6FrZBmaDygTjqgv1UC+
	wHqgzAPHWTB1URGGUp7UuzlruOefBtLiow4zuL4WvimWyfu4wR4O21Bh7XeSJxKqIGoydDzIpHc
	Ku1ng==
X-Received: by 2002:a05:6870:418b:b0:417:5105:a735 with SMTP id 586e51a60fabf-423100855admr12257078fac.33.1775676625996;
        Wed, 08 Apr 2026 12:30:25 -0700 (PDT)
Received: from m2max ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-422eb25a55asm17486812fac.10.2026.04.08.12.30.25
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Apr 2026 12:30:25 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Subject: [PATCHSET for-next 0/2] Deduplicate fd-to-ctx conversions
Date: Wed,  8 Apr 2026 13:27:39 -0600
Message-ID: <20260408193023.397746-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	DMARC_NA(0.00)[kernel.dk];
	TAGGED_FROM(0.00)[bounces-13005-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	NEURAL_HAM(-0.00)[-0.999];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,kernel.dk:mid,kernel-dk.20251104.gappssmtp.com:dkim]
X-Rspamd-Queue-Id: 3E9993C316E
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Hi,

io_uring_register_get_file() exists to return a file associated with
a struct io_ring_ctx, dealing with both registered ring descriptors
and with normal file descriptors. There are a few users of this, but
the main io_uring_enter(2) syscall handrolls its own.

Deduplicate that by avoiding the fget/fput for the registered ring
descriptor, as that cannot go away since it's private to the task
doing the operation. Unify how the file is put because of that, and
then we can convert io_uring_enter(2) to use this helper too and move
it closer to the hot path of the actual syscall. Then we only have a
single way of doing the ctx retrieval, rather than two separate ones.

 io_uring/bpf-ops.c  |  2 +-
 io_uring/io_uring.c | 57 ++++++++++++++++++++++++++++-----------------
 io_uring/io_uring.h |  1 +
 io_uring/register.c | 39 +++----------------------------
 io_uring/register.h |  1 -
 io_uring/rsrc.c     |  5 ++--
 6 files changed, 44 insertions(+), 61 deletions(-)

-- 
Jens Axboe


