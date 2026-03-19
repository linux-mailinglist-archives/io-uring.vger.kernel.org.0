Return-Path: <io-uring+bounces-12757-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id MByZJEZqvGlQyQIAu9opvQ
	(envelope-from <io-uring+bounces-12757-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 19 Mar 2026 22:27:34 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id EB9912D2A99
	for <lists+io-uring@lfdr.de>; Thu, 19 Mar 2026 22:27:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 97564302AE20
	for <lists+io-uring@lfdr.de>; Thu, 19 Mar 2026 21:23:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07A8C3B776A;
	Thu, 19 Mar 2026 21:23:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="MBaQ9Hgj"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f173.google.com (mail-oi1-f173.google.com [209.85.167.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E83DB402459
	for <io-uring@vger.kernel.org>; Thu, 19 Mar 2026 21:23:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773955402; cv=none; b=YYdiHNT8UTJ0DhT8FG2FB150cXRqLEnhHCxdUFxq68dB4PvKbBvEB70yBVylBLj4NguYPSksV+UwgxDFAXqKgA7R6LexAFCuSPPTgl+Gh6TWX4vd5vlAghytgLZUEWCwca/ea/PRBnwj2HAHPX2/thfyWEwOFpL+GTUDT+R6AYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773955402; c=relaxed/simple;
	bh=DlmMfWpYDGyGJyY3dvu/TxNqp89onH7c7Yioh6/SV3Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s2YkqX2BiZ0zsUf2r9HdnNOGDs6EoiSMrIp9P1qNCC89K2MQh/XkkuNO3f/Q/yh8/vEUhxlc+1ju3N+sdNl2E+SqnVpGWp+ZaTqp+UGATgp3cS4pSN7btrlOp32qft4nh4Mxz1iFP6ghk9CsVEcv2PvCGd4F3o7I3TUyjIoS4Dk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=MBaQ9Hgj; arc=none smtp.client-ip=209.85.167.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f173.google.com with SMTP id 5614622812f47-4671cbce32bso9873b6e.3
        for <io-uring@vger.kernel.org>; Thu, 19 Mar 2026 14:23:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1773955397; x=1774560197; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SCodX196ucy7nu88OLGRgC4cCz00gZWrCN++YGvYx7I=;
        b=MBaQ9Hgj+DS8zZ/sRr5H5cTqyNqzp09mdglzjBpCiTSKV9jrUAdZ59DT5d54lGNH1b
         1EcwyMrHaua4FJqsfEl/vZxRoec3qqz35nvUqsTurSpE7q4zOdmZe8/FdDqfAyET49P4
         KIvyelyVBkGA4ddLTIo7tgpx4e3ZO0hs0qzaGqggE02PrrEck2X9WAz3fyyRps/VDaCp
         fU/evL1OEN8dvvX4GmK/WQcGXBBjEWLsw6G2/sEwPY3Ld5wiT6Pdl4YtcjWVgkVhsgDt
         3KFiphSk/YKOcHyXNK2BudDcT3UbCCIUaMxPxfaoykLTVVemgq0fGccfhHBJyD4LpcPU
         iQeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773955397; x=1774560197;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=SCodX196ucy7nu88OLGRgC4cCz00gZWrCN++YGvYx7I=;
        b=j+udUYOlt/otBZ3iFDl/VU3aHpzUrK8RqhSnvD2oECV/BVh7ZlVW2ACpF3yp4OwTMb
         9nmwiQ/3bQ3TkyTFHKaesG7ecvsLOcOcoyUEQg1JYZ/v3JRx/l6uTe4GNuCR2EoXK3sG
         fj8bwm/AklF8kqu2VYzkEFpvKha5c8sU3By02OvE0oleJF0RlZLskJctIk7B5OheyHpW
         gI2EhXAWud418mINft6oXqwxN/p9ccgDFHLPMQLFfdhnwAHij8BCM4WRPQ6GM+72s0Oy
         02PiFuUMiMs0uFSp97LyYi9313XvoEzX52THZGDOsPnp3DX2O3tQUVw+oq51PJpXXDBw
         0d3A==
X-Gm-Message-State: AOJu0YzgW/H10H+6qF7O3Y29E5bHQ48AZFCp77w2MvG6gKmsnXaYVort
	/HvZMXIs6DCc99aLXQ2hVIxrqEZI34J+k7sqdQtDS0OHdfekdBqAtT1s5i3qsE91KCsUrZVH4Xb
	f7h9WRHI=
X-Gm-Gg: ATEYQzwo3VhiK35z0axm2D25bDupgxXCKVgpteinIHUYlKIpF9aP2Eiaw1K8maX5JNG
	Bf6kEWI7N2qB/BTm8QbFrdepL4DUe8fREn8HG7mCewchLWkUy+ysqfKkX2gnD8hI2doPT8h6z88
	A/11sKGlPRqPRDa1g2w57JczdIwnnPMmN2Xen8GB4+rMF5DRdvT/bbw/+NDjVIOJ7Te94gJ5Vtr
	zDQVa7PauJbASXfgckUbL+x5821zcqte0VCKic4FielRECiCIBlARw0/V+5FH8yrS3nvwUfvFeF
	TRWPEPWox/vQCzWPoUTeb9Zd4YDUPhVu8wINNVcZVFHbo6c92AY8YLeIAOu86R6Pp6F+K/2w2eM
	LyJIkQiku/TytMQoH134mdE4XuNcWb9ofpPps3vHp3w9I2EpuvqMD1Og71TqqpnPQVTthEzA53G
	e7trlXiwEX8YGX6GZFv3n4J2EJl3JvduwLtnh3X7hlPez0SM4a+yfie/0Ao+TCzR9eVp4=
X-Received: by 2002:a05:6808:8919:20b0:45f:2719:32af with SMTP id 5614622812f47-467e5eebfdbmr324290b6e.37.1773955396949;
        Thu, 19 Mar 2026 14:23:16 -0700 (PDT)
Received: from m2max ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-41c148a5ca4sm186363fac.3.2026.03.19.14.23.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Mar 2026 14:23:14 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: code@mgjm.de,
	Jens Axboe <axboe@kernel.dk>,
	stable@vger.kernel.org
Subject: [PATCH 1/2] io_uring/kbuf: fix missing BUF_MORE for incremental buffers at EOF
Date: Thu, 19 Mar 2026 15:21:35 -0600
Message-ID: <20260319212309.284152-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260319212309.284152-1-axboe@kernel.dk>
References: <20260319212309.284152-1-axboe@kernel.dk>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12757-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	NEURAL_HAM(-0.00)[-0.993];
	RCVD_COUNT_FIVE(0.00)[5];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	TAGGED_RCPT(0.00)[io-uring];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kernel.dk:email,kernel.dk:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,mgjm.de:email]
X-Rspamd-Queue-Id: EB9912D2A99
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

For a zero length transfer, io_kbuf_inc_commit() is called with !len.
Since we never enter the while loop to consume the buffers,
io_kbuf_inc_commit() ends up returning true, consuming the buffer. But
if no data was consumed, by definition it cannot have consumed the
buffer. Return false for that case.

Reported-by: Martin Michaelis <code@mgjm.de>
Cc: stable@vger.kernel.org
Fixes: ae98dbf43d75 ("io_uring/kbuf: add support for incremental buffer consumption")
Link: https://github.com/axboe/liburing/issues/1553
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/kbuf.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index e7f444953dfb..a4cb6752b7aa 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -34,6 +34,10 @@ struct io_provide_buf {
 
 static bool io_kbuf_inc_commit(struct io_buffer_list *bl, int len)
 {
+	/* No data consumed, return false early to avoid consuming the buffer */
+	if (!len)
+		return false;
+
 	while (len) {
 		struct io_uring_buf *buf;
 		u32 buf_len, this_len;
-- 
2.53.0


