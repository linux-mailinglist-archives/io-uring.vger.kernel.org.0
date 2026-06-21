Return-Path: <io-uring+bounces-13801-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id O3ndHaw+N2otLwcAu9opvQ
	(envelope-from <io-uring+bounces-13801-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sun, 21 Jun 2026 03:30:20 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 17D0A6A9FAC
	for <lists+io-uring@lfdr.de>; Sun, 21 Jun 2026 03:30:20 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=W4QhCikS;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13801-lists+io-uring=lfdr.de@vger.kernel.org" designates 172.105.105.114 as permitted sender) smtp.mailfrom="io-uring+bounces-13801-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 5908D3010B89
	for <lists+io-uring@lfdr.de>; Sun, 21 Jun 2026 01:29:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 792CA2222CC;
	Sun, 21 Jun 2026 01:29:42 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 974D31E7C2E
	for <io-uring@vger.kernel.org>; Sun, 21 Jun 2026 01:29:40 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782005382; cv=none; b=jpD8ehn+e7cy97VSxTkdliY5ik4Rp8V6FfUS9VpAS1Z/XKCkLvFrSOkQEExaGLmviNpYhEHB6iht3FczjWs6UrBgtRQdwrKqVdBaorwb0zneVHYdsx3SmSS/wOPNKrCuPh/BY2rrk37mpIp/r72UKbTNR+27aGufaZRajO+SjE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782005382; c=relaxed/simple;
	bh=3UBYzeU2dVhBN1XdXgDI32bS+wfwbHsKNgce5dpLOA0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=QoHhfG9RnZLIcsrHWcS7skgg3QX/TQtMtFzWkeBolm8ObEf44GkF25RFJFQMFQk0TVq0yij32NY3O86L7U51ulQpady+zlG5h1jANKRUYC8wU7mDBVcPnM8FIeR3m2fogfAeUP6kA2qurM3cBLgA2Eme/wghongNeqB27tXI9V0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=W4QhCikS; arc=none smtp.client-ip=209.85.216.50
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-37c6cd1ac98so2856094a91.0
        for <io-uring@vger.kernel.org>; Sat, 20 Jun 2026 18:29:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782005380; x=1782610180; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=QIRmNxLSiDs+vGpBgdhj9EfUDMiH5ZJ3syFKf4560AU=;
        b=W4QhCikSiYvnawsr//q2EUZexVVMLZQKvkytFfLfEjCwyGWuTk/o4mLyG+qYxiKp/k
         f6eO9UJGljjkt+6gfP8FkgvSG187vq7glxZNKr9Dhpfjvk2gnLiR+mm7jtGHtqwyauwb
         YOBM5Xabh4eDKJy3rWgY0JAw+VtB6OmIdXom0nqxIZuf7ojDa86eOe6iGzyB3r9SKgfY
         2gsoFFuroGPbKuwifGFMXUssjHHTwkR7hBU5ng2h/5Witcpg0D/WIiQoP4xV4yczGq5v
         ravKhmTUb7FCEETDfk1rXV1hmZ4E0qksdC7OvHrF7V11KLra4hdPDQHHSsSjR3D22dXZ
         w53Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782005380; x=1782610180;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QIRmNxLSiDs+vGpBgdhj9EfUDMiH5ZJ3syFKf4560AU=;
        b=sD/VGQ6SCNz4JApsituxYFjFXiAqcgIG/jwSJmIFg7YLsEtgycyfpJV4EitrcNjcZw
         q7bdD5oG99QTturK2JhW0tif1LjFUIskedP180WzdP5Mav7GPEQZRALeL1JhxvY9sZAE
         FR4B4ssJEYfcaYwohIeQzYgo9VMcnyntkkuo7QKtp2mXEMUpCqjXFlw+v3OToaZH7aCk
         3nZamGM1IMKfXt73vHqxxupzn8j4lq6ew+HCcQ325t8z+XVFUMvRF4wvLbtOCSsPbwo0
         ewsQW7ERX72BYrcbgny+Nvwrl/okH0QZXVi8hFGUaCObJ1O+ZAackP7MW2rG0N8e4Jpr
         whyg==
X-Gm-Message-State: AOJu0Yy8K0nSgQdazujCvNxR/uiPKgBZHv68E77mKRkOGJyrl7dOsWKc
	xe+dAlwvAHaqFXJ/AUO8KCc2dy+yYrB3/vdZ893l6tit2pM4UNeF0NqI
X-Gm-Gg: AfdE7ckIbvIVDJ0ZuuCAsLSdnDPedKM/mvK5jVI6gQpg3uK7KM0Ckly23Kk6gN1q4/o
	2lkIoOVLEEywD2UgtaRTdiA7OTPyX/wiMR4UkGpgZb2ItMjDzyVAwoITvUqDzTnq9hoRhM54lZj
	ZC+WLAYjX3ZhwpJPIADvVuviJZ9ZJiyn9Q94W0Pc56xGzvrExp/03REhLJwwOZO4I8BWtx1UQHe
	+jHxOjJvbUbM8Wotj160RkTQMVWAaFAnI2KDBRvEEEsopuw/GvTodWd7fN7TGKvjls3gxT5CJr3
	x2/rp6FtxDoT3mV1JRmSMMQeP7KURcPxeWsGq32GLqHH1xieXVnURc3XP4szuJipd+cDFxajBhZ
	DpzujQ9g65XoaZyTu1EF+YdSwxY4B9m51ysyfG4wI4iOB/2iCfATbbmreKrYyfKSJbd/Ebgid62
	o/WBBtqH/kK35PRBXHY2n1++OXolQNVfPrCJa2+6qaN4dMXkQ2yCzb/dBitnsCYyxPuLIw
X-Received: by 2002:a17:90b:3b44:b0:36b:936e:73c8 with SMTP id 98e67ed59e1d1-37d1e9e7d8emr8043325a91.19.1782005379681;
        Sat, 20 Jun 2026 18:29:39 -0700 (PDT)
Received: from deepanshu-kernel-hacker.. ([2405:201:682f:383f:6622:5068:7fd9:7931])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c7444a9c4fsm34118905ad.75.2026.06.20.18.29.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Jun 2026 18:29:39 -0700 (PDT)
From: Deepanshu Kartikey <kartikey406@gmail.com>
To: axboe@kernel.dk
Cc: io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Deepanshu Kartikey <kartikey406@gmail.com>,
	syzbot+f99b00a963915b6b52c6@syzkaller.appspotmail.com
Subject: [PATCH] io_uring/memmap: bound io_pin_pages() by page array byte size
Date: Sun, 21 Jun 2026 06:59:33 +0530
Message-ID: <20260621012933.50571-1-kartikey406@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Spamd-Result: default: False [0.84 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13801-lists,io-uring=lfdr.de];
	FORGED_SENDER(0.00)[kartikey406@gmail.com,io-uring@vger.kernel.org];
	FREEMAIL_CC(0.00)[vger.kernel.org,gmail.com,syzkaller.appspotmail.com];
	FREEMAIL_FROM(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:axboe@kernel.dk,m:io-uring@vger.kernel.org,m:linux-kernel@vger.kernel.org,m:kartikey406@gmail.com,m:syzbot+f99b00a963915b6b52c6@syzkaller.appspotmail.com,m:syzbot@syzkaller.appspotmail.com,s:lists@lfdr.de];
	FORWARDED(0.00)[lists@lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[kartikey406@gmail.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	RCVD_COUNT_FIVE(0.00)[5];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	ALIAS_RESOLVED(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring,f99b00a963915b6b52c6];
	DBL_BLOCKED_OPENRESOLVER(0.00)[syzkaller.appspot.com:url,vger.kernel.org:from_smtp,appspotmail.com:email,tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 17D0A6A9FAC

io_pin_pages() checks that nr_pages does not exceed INT_MAX, then
allocates a struct page * array of nr_pages entries. kvmalloc() limits
allocations to INT_MAX bytes, but the check counts pages, not bytes.
On 64-bit each entry is 8 bytes, so the array hits the INT_MAX byte
limit at INT_MAX / sizeof(struct page *) pages, well before the page
count check fires.

Since commit b4e41050b212 ("io_uring/rsrc: raise registered buffer 1GB
limit") raised the per-buffer cap to 1TB, a buffer near that cap maps
~2^28 pages, making the array allocation exceed INT_MAX bytes. This
passes the page count check, reaches kvmalloc(), and triggers the
WARN_ON_ONCE() for oversized allocations in __kvmalloc_node_noprof().

Check nr_pages against INT_MAX / sizeof(struct page *) so the buffer is
rejected with -EOVERFLOW before the allocation is attempted.

Reported-by: syzbot+f99b00a963915b6b52c6@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=f99b00a963915b6b52c6
Fixes: b4e41050b212 ("io_uring/rsrc: raise registered buffer 1GB limit")
Tested-by: syzbot+f99b00a963915b6b52c6@syzkaller.appspotmail.com
Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
---
 io_uring/memmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/memmap.c b/io_uring/memmap.c
index 4f9b439319c4..da1f6c5d07f8 100644
--- a/io_uring/memmap.c
+++ b/io_uring/memmap.c
@@ -53,7 +53,7 @@ struct page **io_pin_pages(unsigned long uaddr, unsigned long len, int *npages)
 	nr_pages = end - start;
 	if (WARN_ON_ONCE(!nr_pages))
 		return ERR_PTR(-EINVAL);
-	if (WARN_ON_ONCE(nr_pages > INT_MAX))
+	if (nr_pages > INT_MAX / sizeof(struct page *))
 		return ERR_PTR(-EOVERFLOW);
 
 	pages = kvmalloc_objs(struct page *, nr_pages, GFP_KERNEL_ACCOUNT);
-- 
2.43.0


