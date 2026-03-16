Return-Path: <io-uring+bounces-12698-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qMQhF/UnuGnhZgEAu9opvQ
	(envelope-from <io-uring+bounces-12698-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 16 Mar 2026 16:55:33 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id C3A1229CD24
	for <lists+io-uring@lfdr.de>; Mon, 16 Mar 2026 16:55:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id CB20E307A0A6
	for <lists+io-uring@lfdr.de>; Mon, 16 Mar 2026 15:49:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A35443A6B8A;
	Mon, 16 Mar 2026 15:49:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cKRe4kkC"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37F963A5E93
	for <io-uring@vger.kernel.org>; Mon, 16 Mar 2026 15:49:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773676180; cv=none; b=rF4T2mvWLUmPrelFNtjZ+UpZkjkgUXZ/yoPkN2SuI8k1tTIMBIp6DA3vqv7acrGO399IY5M7zeNE5byYp1vcjUFTxJwtf193ELcEUTJbqlXuWrpaDlz0teYLOpypYKyW8d5vOmDrLhqrb3SQyQ0VJ+yIS29dxe3sgV2H6NXjwlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773676180; c=relaxed/simple;
	bh=xhj7V5VOHhyPhjZT8w+2BQtGE00MYdrzk3o+IvpVuEQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hrrcUaL5I/nVmX1bwX+0N7foY0rBmyfuKtTI8SGlPnIZ77YveKW+CUCxn5zWCFqsWj1TOJvLrGeRmSYuOOfPMOMzAu11bpvA2oI77YbMD0QDaLDb0OIaO/Q22b8+mF8FQQAQgjBU7f/b+Ac0FLWM8YlanugoVLOoG9+r7r44Wao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cKRe4kkC; arc=none smtp.client-ip=209.85.215.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-c70c112cb61so3134085a12.0
        for <io-uring@vger.kernel.org>; Mon, 16 Mar 2026 08:49:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773676177; x=1774280977; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=I6uZPXtzqz7Sbxlt8I3hTrbR+x+36hfWguC11NiV9bo=;
        b=cKRe4kkC59oBmJ/78byqIkDm1LmxXNPPoJGE8qOKBJuQZUCnYTODgvPMoeLThip/gH
         cqtA+wF5+eH2EZECS59Udi4JZTc6pOhB1Xb3+hd79gnVLdOxmsIS9wwt/cLohLhKnYJk
         SJor9rSTQSIsr4Dbw0k44e8Dm6bahMoB7uUDQmhhnDcqu95UQX/XRomcik9/P16Btifk
         kuntQnF/vDpwF/5cptIlXTe+aanMzsuWtFmftowKxVncKxL+GqEDFxIGeQkcAgL2ZfJU
         /7+AbgolCVryXr6K2oEIt+5dz+39+J0H3e5FsNHWUiR8/jl4c6LtEFyby+lmigFcVP87
         gckA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773676177; x=1774280977;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=I6uZPXtzqz7Sbxlt8I3hTrbR+x+36hfWguC11NiV9bo=;
        b=VnnqSZNwJDSqmJFXDD0FBG33LGcaicsVSA/unnIn2myc942sO9nZYZ2SetZT42p/nX
         GvP4wAAGBdsKv+VtZkBjpXMrF6nRom5PEUNuj2+XnkgtIll+GZZXNiP7pMq6j/6zsrwP
         c4Yd7eEgoTt4E+GklJ5McvUpKoalkFoCRX1YkZd1s/QU/xUlSnAlPwh2ncBX+e9XDhuF
         wnmr4YBfHf4j+QE6eybSXGRGet4Zk1lyIRZxYbJOTZ9ttZw3GokYgg65cGWZeetwDzB3
         k40/GuC9OsNWPGODuGwAwrmLzi3ErBGsbUAO2UyFM3SA5UZ0a+091n6dESiOdgcsGDKj
         aP5A==
X-Gm-Message-State: AOJu0YzFW2sAzbY6KVRni39Sl65N4t8nXUZJyepuJN2v16AEvhs4wTq/
	twm7j5HpCAgWboDmwLkw6YVH/PVMuelhEhezelSoH757rXVDSi6UC1hzRQs+vo7wBbY=
X-Gm-Gg: ATEYQzxSy2La64nlFn1e4o2T7ceSiBkyuwnXnsJSsdUYzW93nxrBA97qYdzWNvIN7U/
	rHm0oOUQa9QSkc4SEc9pgj3/ob9aix2Igj5gpuy0lsiieYrirMbPwMv4NfugA41p3P4pxHsOao8
	q2HWH3c7v/zRWMLdntnIhA3WT+mKJOXIOwYG4TnIvOcMB+FaGtPXJa4EdoLY9p7oOewY5aG6naq
	l6dQypYkZtC96THZ2w1Uojht+4QA5Z8mCzf+AVsDIfG58mx35nhyXU+0XSO+b1edF24v9h3oIY5
	dcCnipMzirTmF9crCH7TwyznfhlpWVg34JrFNf12x0r4NORHFX8O4Clyn7fIHCqD5VuGhMq4jSx
	2tqxLLAmIhy/D6Z/yjIwe8fEkEpP5LWgKZ6ucOJnVE2Zqg9m+2zKmeG1smEwprp24uUAZEvzTTb
	JEOxHaYsPJV3EmlWg1H4VJ4I2A
X-Received: by 2002:a05:6a20:a111:b0:398:72b7:ec8f with SMTP id adf61e73a8af0-398eca384d3mr12261294637.18.1773676177484;
        Mon, 16 Mar 2026 08:49:37 -0700 (PDT)
Received: from ubuntu.. ([152.58.131.4])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c73eb993e40sm9149350a12.8.2026.03.16.08.49.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Mar 2026 08:49:37 -0700 (PDT)
From: Anas Iqbal <mohd.abd.6602@gmail.com>
To: Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Anas Iqbal <mohd.abd.6602@gmail.com>
Subject: [PATCH] io_uring: cast id to u64 before shifting in io_allocate_rbuf_ring()
Date: Mon, 16 Mar 2026 15:06:36 +0000
Message-ID: <20260316150636.2123-1-mohd.abd.6602@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,gmail.com];
	TAGGED_FROM(0.00)[bounces-12698-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com,kernel.dk];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCPT_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[mohdabd6602@gmail.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: C3A1229CD24
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Smatch warns:
io_uring/zcrx.c:393 io_allocate_rbuf_ring() warn: should 'id << 16' be a 64 bit type?

The expression 'id << IORING_OFF_PBUF_SHIFT' is evaluated using 32-bit
arithmetic because id is a u32. This may overflow before being promoted
to the 64-bit mmap_offset.

Cast id to u64 before shifting to ensure the shift is performed in
64-bit arithmetic.

Signed-off-by: Anas Iqbal <mohd.abd.6602@gmail.com>
---
 io_uring/zcrx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index 62d693287457..d96d2802f3da 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -390,7 +390,7 @@ static int io_allocate_rbuf_ring(struct io_ring_ctx *ctx,
 		return -EINVAL;
 
 	mmap_offset = IORING_MAP_OFF_ZCRX_REGION;
-	mmap_offset += id << IORING_OFF_PBUF_SHIFT;
+	mmap_offset += (u64)id << IORING_OFF_PBUF_SHIFT;
 
 	ret = io_create_region(ctx, &ifq->region, rd, mmap_offset);
 	if (ret < 0)
-- 
2.43.0


