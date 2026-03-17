Return-Path: <io-uring+bounces-12731-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 2Po0IFG7uWnJMQIAu9opvQ
	(envelope-from <io-uring+bounces-12731-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 17 Mar 2026 21:36:33 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E49F02B2513
	for <lists+io-uring@lfdr.de>; Tue, 17 Mar 2026 21:36:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 650533067872
	for <lists+io-uring@lfdr.de>; Tue, 17 Mar 2026 20:36:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A061D37BE84;
	Tue, 17 Mar 2026 20:36:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="hoT+AZ2w"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oo1-f43.google.com (mail-oo1-f43.google.com [209.85.161.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58E4A34028D
	for <io-uring@vger.kernel.org>; Tue, 17 Mar 2026 20:36:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773779788; cv=none; b=H1Fnl6jyBki/GR9Amn91Zf6kA+7n8lQtpXFcW8j3A/htkr9Ew3I6V8esram9NsSf3MGU4m+9boxl2pih0YIFzf7Zl+41dDC+Ti6CX7AnZpXm3MOUZz16+sedJbxiqkaTRUAnHC5UwuvZZMmLIQmLJe8nFvgwnTOy4V4U8D8ePik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773779788; c=relaxed/simple;
	bh=60tGrkA5F4jxXbmUt/YLaKBnk21jinHakj9ES/p5hAg=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=spzua7D28dFPGOo5yz7hXi8NREVI5bL0Nta0L/0AxDpNA9xTO1Uhc3gjd7hBUj5fubMblwAISvfSBCj2zBstQMoROnbjX/DOHyXtS+FvVbzI8vXdZdUNfElIiqyF73dj9LLvCsL7+90DHKCTgA5CeacOWovIlruWtOrgUxjHnhg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=hoT+AZ2w; arc=none smtp.client-ip=209.85.161.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oo1-f43.google.com with SMTP id 006d021491bc7-67bd4e63606so2160953eaf.1
        for <io-uring@vger.kernel.org>; Tue, 17 Mar 2026 13:36:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1773779785; x=1774384585; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=ta6Uh1PUNWoo0kmvYROJJEKijR06/qLH8Shqc+Z+XT8=;
        b=hoT+AZ2w9OiZ2pRNZkayo92jPRbEj5ZS2TNhZUGC6IsKtX04JGng9s+WzTBx+x3QGz
         xKfshPfp0bYb5mFMXDz43BBS1d/AR0sD0u8bJSI07kFkaF3nqNQGYTiDRai/pMbgvvJt
         jAyoGhGo1k0yhf7IsZOms/CdgUmzdwJvF3+0tht6K1kf3ksWF3Z1oF9MBhlB2evgMb3s
         CePoEMxGCzRJN+NqT3sqV/C4CEy6V7JrrUyeXVI8lGDBrC+mIRzNpeFUPJGZtiLYTYQw
         9uiMZdN/DIZlIE1MVc75A7y8qGVnIwoZQ5qtu163PxdG/fdpySzQ3MN5rT1pIBttc9bz
         x/DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773779785; x=1774384585;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ta6Uh1PUNWoo0kmvYROJJEKijR06/qLH8Shqc+Z+XT8=;
        b=K0eeT5umi6/AnfgocrDo0PAn85IppKi5Yt/5txM8KhyCFzEdupimRfMDFlYJLtpd2v
         OBUaj3muJt/+kwuu9em5KHCF2FQhDAFc4fxSqB1sCzKqDGq0nsnwAwhotUIajjiheLJ/
         6Ylogu0YTgq1aMpQVrkbKKXzGS0MMzddbF3KjeB4LTHHsxB0GCHdMK1l+8/6mnry5RwQ
         mtjr5Ztzis5fZWDbdfHsgjOpRiy2SeEiOi00hoFZ8Rm4Ch7gd06SsT7bd+TwJoRRgA/c
         Njb1ttaT7CKDumRAKspnGQo6z+nFClWtvpURHMRwWAHz0+KEM5IEsbCvXU/FL+PMcU1/
         GwQQ==
X-Gm-Message-State: AOJu0YxVt2DbAYYeBjZgbjDHrI6WlmBKNQfKSY/WZjSHa0NTKyWYmlUd
	/ovaNZItDn5Oaw89L2Xme9baMCE6DTAQ2e4SuPYE5Xkt2tYQ9QNlGkUrMI7Kvo+/QlBWTdVNBqS
	HjWrVN4s=
X-Gm-Gg: ATEYQzzNQt9Np0O0fqf0yySs0KC1tRXiUUG8fJPL70/llHq8ZEs51hVEyIkRiXDZICn
	uGiK2yWadKqLsykBtSScT9rM+8dpuOXCt3cudpb8sXgCAFd/MpmqGWQyLiAeCTgG2AVz/zSaGiu
	hw/FQDEgkZ3267lnMw/9osEFf5aueVswXu/Ow5aBkw1lft69z6Mn9aVGhN2HyNLYsZ8NoZoAQ38
	kGJfWcqvWjkZ0LTAyrqUwjslPmxwHTxajy95VoVSa6Wp650+PFvARs8L86R7scppb+ibz4pLOTo
	rPgAqTCjZGZNzjeQu1PrioDGp93pRDQYAvgh2pnhLn4cyb0OH/o2der0nej5RddOTLOuND0XXFg
	RhM3eAkLBFLheQsuV27M2PkayoyN3uKRYZvv6uN4eznVvRCefkszi4W2O613RBLm0ohIsfGN/Xw
	zmZq5Z4R+uMDTnRdiUysDTdats+pgdNIANc9X5T65aq7RTIR45B1VYOF2BKKorycMFESU=
X-Received: by 2002:a05:6820:229c:b0:67b:dd09:bc60 with SMTP id 006d021491bc7-67c0da95093mr462366eaf.12.1773779784578;
        Tue, 17 Mar 2026 13:36:24 -0700 (PDT)
Received: from m2max ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-41bd2cc1015sm670885fac.14.2026.03.17.13.36.23
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Mar 2026 13:36:24 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Subject: [PATCHSET for-next 0/5] Various minor cleanups
Date: Tue, 17 Mar 2026 14:35:13 -0600
Message-ID: <20260317203622.1007183-1-axboe@kernel.dk>
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
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12731-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	DMARC_NA(0.00)[kernel.dk];
	RCPT_COUNT_ONE(0.00)[1];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	PRECEDENCE_BULK(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_NONE(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_HAS_DN(0.00)[]
X-Rspamd-Queue-Id: E49F02B2513
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Hi,

Nothing major in here, basically just being consistent with using
variables that are already cached. Depending on arch/compiler, these
also save a reload of a variable. I see different results on arm64 and
x86-64, but I think the cleanups stand by themselves either way.

-- 
Jens Axboe


