Return-Path: <io-uring+bounces-13620-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id 6k+PNXoeJWrLDgIAu9opvQ
	(envelope-from <io-uring+bounces-13620-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sun, 07 Jun 2026 09:32:10 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F7A764F042
	for <lists+io-uring@lfdr.de>; Sun, 07 Jun 2026 09:32:10 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=JeSeoNzw;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13620-lists+io-uring=lfdr.de@vger.kernel.org" designates 2600:3c0a:e001:db::12fc:5321 as permitted sender) smtp.mailfrom="io-uring+bounces-13620-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D161C3011F08
	for <lists+io-uring@lfdr.de>; Sun,  7 Jun 2026 07:32:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 786CB1624D5;
	Sun,  7 Jun 2026 07:32:07 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 028502FD66D
	for <io-uring@vger.kernel.org>; Sun,  7 Jun 2026 07:32:05 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780817527; cv=none; b=pZq8qC0UNLac9VUABxBm+CV1L58R+Yfy3SCAK3mh/2TvPKLQfFbziFV7ElPgYK5p/pkcduGvf25rGnB6wnFajgQhyRgCGc8y0v8mbEkOYmSJiKYvJXB0BqKHFTG3R3mRrxLELqS9trHBgLxhW5IksHcKFPyRZnJXNs4EqaG3nDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780817527; c=relaxed/simple;
	bh=X5iwO1FACE+1+2xU8oc4DOo/3EV26eWzaAKzM8GlpEU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=NuznCVJEP9IA1U+ZvNodLQ5waFZnLMFciW7aLzxVSCoAZb9etkkRsqFmczPhrYIWIae7u/lbDDxlQWGwd4gNKg43l/4NADZAz8iXlLKDO0Qes/9sIMwKPhcGNNqSekbQOe4xS8YZ+Pf9QBN0JNz0tEuXDNeCdlBQL4s68rCyg6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JeSeoNzw; arc=none smtp.client-ip=209.85.221.48
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-45eeba68948so2189848f8f.1
        for <io-uring@vger.kernel.org>; Sun, 07 Jun 2026 00:32:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780817524; x=1781422324; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=DGsP3mPndPhYcXEi6EgFHfHqDO/gbUdhLXTqxEZxCZg=;
        b=JeSeoNzwJH5dwinLL9rqqjEirJlPeXDYaaX3feCcHFOXrYUT0oW4zTEN4GZMcSOSxY
         U2DruBakXr3XDS5VjO6ReL2aVA9q2vNuEJodZI8AqOcO+DwccaJCSs4C/GgUzdnKn+ZL
         Udnv6TbvdKZ7GtIvKGCYaZ0S5ckaOezQahhxPH52UAGGxSxN7f7IrqfqPx5BSbJ7TVy4
         tvvRo7A0I8/DZEfFEpxw0Fj8OTzul/S5PPpe9jJcB1f54jhAVmvr1cRbhOx+teFbu0jX
         b2ZC3KIgOKeIgrgjjCf26hZ4ydpsQbkzJtdFU22ckj0CurdtjRlJqOa3/8lkHeffucdR
         MqZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780817524; x=1781422324;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DGsP3mPndPhYcXEi6EgFHfHqDO/gbUdhLXTqxEZxCZg=;
        b=FS6HRr9u1vSKYB3OFnxcfMNNNSvG/ZYumznQ3kXNqmCZOIdJGsgc4fc6MYgKpMBIUo
         kZxmSYbrF0fSmVrqXVfjmoiAXE3qD3t0GLf5lobufquz6dPTNM9HvjGF/kiQhV9zgv5D
         n9BA67/3U3i6XqxbJKkTyZdnnrrsvLAEDu45zd0ill1PFGEfRk13n0LGZgjzM3pG23M5
         BE+XFXRAQy7h8Ce0yuRmduyMI00YytFYAKqbbwUdWdfwQbgqP+3jeRR/HTh14P4Scos0
         GxtfMjGEWBvbpOAM03kwjkQvDWHF2D1pXEA7lSQNUbj7x/qMmLzTDVYQlZuQM1vNVLzc
         zuqA==
X-Forwarded-Encrypted: i=1; AFNElJ/WQI13BQqPqNexN4lyM4jPSUtUXyib5s1pDqL/9u/ndla2v0E0An9SkvsIOXEhReC5alvSWomYrg==@vger.kernel.org
X-Gm-Message-State: AOJu0YyHB7AZcoQD0ma0q4B+8tqUpgLviBXHTZaZlBBwBub5cOFHvwNa
	iUxCOAtPjAfYx9t4eE7QWausPeEpfbfGeBGrRsfouTLjaBVLd2htVbOo
X-Gm-Gg: Acq92OHJopXYrNc7Ncv57UUrtm2FN6X750SGY7qT8L9e1Cy6SLsMTwEPdYMo5LyVDFW
	KlSmM33Yi18Pi18hEmEyuxgBvmeon2qZcIB1nIo3NRhR/psgXAlmNh8XkgpsK+hgWJVyv1Mfcgn
	eiu7qJ5znMEkh0kxqPXU8Yvrjfattyy/CRXqMz90KBLjs7E6BTSTaFuYJUgXbFW8PXyViPYQD4N
	h68vGvOmg/+o5UVNvF1Wsb+GSQJwQiI9z7/MqlTcz2tlpIxOeUt5Hlk4zfjF2VImsv38GLdKEPE
	Wes0vfaoTRKrhhY3B3ezma7Q/nyFJ6SAPWQCfNLbqqnz6idqNApkgGrCSgO7/82lGf82Q/dHW7h
	bb39Ggbxl7Fxgo4N72b/Ih6k64xmPJihVERyfgb5PXf4aMpbGWV+31emNhwMBT+xo9XxY9fYzxN
	V1BH71r8SvwC1MACgc05o/esWjeaHBOt7EUGL8N3ZxsRtJS6y/LBaG
X-Received: by 2002:adf:e30e:0:b0:460:1233:ecf2 with SMTP id ffacd0b85a97d-46030609798mr12570199f8f.30.1780817524257;
        Sun, 07 Jun 2026 00:32:04 -0700 (PDT)
Received: from puck (234.243.199.146.dyn.plus.net. [146.199.243.234])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4601f351d40sm40459372f8f.26.2026.06.07.00.32.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Jun 2026 00:32:02 -0700 (PDT)
From: Dylan Yudaken <dyudaken@gmail.com>
To: trondmy@kernel.org,
	anna@kernel.org,
	linux-nfs@vger.kernel.org
Cc: axboe@kernel.dk,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Dylan Yudaken <dyudaken@gmail.com>
Subject: [PATCH v2 0/2] nfs: support FMODE_NOWAIT on O_DIRECT reads
Date: Sun,  7 Jun 2026 08:31:53 +0100
Message-ID: <20260607073155.105314-1-dyudaken@gmail.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORWARDED(0.00)[lists@lfdr.de];
	TO_DN_SOME(0.00)[];
	FREEMAIL_CC(0.00)[kernel.dk,vger.kernel.org,gmail.com];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-13620-lists,io-uring=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:trondmy@kernel.org,m:anna@kernel.org,m:linux-nfs@vger.kernel.org,m:axboe@kernel.dk,m:io-uring@vger.kernel.org,m:linux-kernel@vger.kernel.org,m:dyudaken@gmail.com,s:lists@lfdr.de];
	FORGED_SENDER(0.00)[dyudaken@gmail.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[gmail.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	FREEMAIL_FROM(0.00)[gmail.com];
	PRECEDENCE_BULK(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[dyudaken@gmail.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	RCPT_COUNT_SEVEN(0.00)[7];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[vger.kernel.org:from_smtp,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 2F7A764F042

I had noticed that io_uring always punts O_DIRECT NFS reads to a background thread
since the file does not advertise FMODE_NOWAIT.

I am not very familiar with the NFS codebase, but looking around suggests a simple change
to nfs_start_io_direct is all that is required to properly support this functionality.
On the request issue side, it seems everything in NFS is actually run in the background
(post this lock change), and the completion codepaths all look to have no similar locking
semantics.

I have restricted this to read-only files initially, as the code paths are simpler.
  
I unfortunately do not have the means to test the performance improvement, since even
without this change my local network is the bottleneck here.
However I do suspect that there are people that would want this fix ([1]).
Applying a similar patch on that GitHub issue did give performance gains.

To convince myself this works at all I did trace io_uring events through with and
without the patch.
Using a test app ([2]) to issue O_DIRECT io_uring reads calls io_uring_queue_async_work
without this patch, while with it the call is skipped and the completion is queued into
io_uring directly from nfs_direct_read_completion.

Patch 1 here adds an unused nfs_start_io_direct_nowait which patch 2 uses in order to safely
advertise FMODE_NOWAIT.

v2: Suggestions from Sashiko:
* Handle file flags changing
* Do not use mapping_empty anymore as it was apparently racy
  
[1]: https://github.com/axboe/liburing/issues/1499
[2]: https://github.com/DylanZA/liburing/commit/264c06f1939dfd6b6bc4c967ada5960c4f4f2db3

Dylan Yudaken (2):
  nfs: add nowait version of nfs_start_io_direct
  nfs: expose FMODE_NOWAIT for read-only files

 fs/nfs/direct.c   | 12 ++++++++++--
 fs/nfs/file.c     | 16 +++++++++++++++-
 fs/nfs/internal.h |  1 +
 fs/nfs/io.c       | 41 +++++++++++++++++++++++++++++++++++++++++
 4 files changed, 67 insertions(+), 3 deletions(-)


base-commit: a2be31abc3fac6a20f662f6118815b9c40c371c9
-- 
2.50.1


