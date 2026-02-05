Return-Path: <io-uring+bounces-12056-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id wGpxE8nbhGkV6AMAu9opvQ
	(envelope-from <io-uring+bounces-12056-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 05 Feb 2026 19:04:57 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 7FFB6F64BF
	for <lists+io-uring@lfdr.de>; Thu, 05 Feb 2026 19:04:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E4F28301F9A6
	for <lists+io-uring@lfdr.de>; Thu,  5 Feb 2026 18:04:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 167903054FB;
	Thu,  5 Feb 2026 18:04:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JJXepR00"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5DA02FD7C3
	for <io-uring@vger.kernel.org>; Thu,  5 Feb 2026 18:04:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770314691; cv=none; b=rpPRCagEVUYQNrpfVASxFDJGGxvQsMvnN0tS7FoW2uRb6LamEvYE7dh8eGII8Ek1OTSWdKPLrLq3zQJr23SBp822FDpZq/VPBmkQSKBUrOp308+Ofce4efGHkB32wDOQKY4aak5ylWBgoHCzYJR5Wp5i7yqNnZ0M+hXWHFU5tN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770314691; c=relaxed/simple;
	bh=hRREcuqUBPsZcxZ3S25elriMROdIzvwpOjRUL0Djdec=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=mcWkHPNFd2EN7IVyzHXq18NnAxH0h39Htr7HBH3bVaocJH2h6yr8al5WRa/vlwUShK9CY80WM9HPdYvopEwbS/jXjZXIxrsgVrrE5Abw0j5vn5DeSzNAo2qWFfZTgytfhSA9smmeqUVlEXaITtMPYo7s43tZbKeU5NOSm6PNLJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JJXepR00; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-42fb2314f52so847373f8f.0
        for <io-uring@vger.kernel.org>; Thu, 05 Feb 2026 10:04:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770314689; x=1770919489; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Tzyb9dTmR1mpIk8oF584sKimNUfLAb6TY7/PYKotmuA=;
        b=JJXepR00UQ+EbsUv0TRtE/RX97JqjSfaP9utxIh+tQkJ4bVdDjGWZqzq1v3+ULFbnN
         vFVF7yYVpirzG0RiRDml1CgCQhp1PjJvftBlRGm6DqfKkSCg+S7QIwFuDpgoT5OhHbdc
         60yCWI1EkekEBOunbUnpgfQkgHygq0FUlceM+keARuXX4PQXKq3JYDYjpLgNjGL4DrE0
         sliLcNvBgZTnKL2WlXO3j0nsk2+zG7vcz3rxXKX9ym7Uc9rg54FdcJZ8TVh+kGEnnVUb
         4+9/u4uChPDhl/QpUCK+f3vxOv4AcqNhUsqVuZnmSxZm4c5+3+aT4RPjJ1ZUlS4rO30j
         Sqvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770314689; x=1770919489;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Tzyb9dTmR1mpIk8oF584sKimNUfLAb6TY7/PYKotmuA=;
        b=s4e3TpiPKJSCauLJPm/nnnI8IEr4yIOX6zjFa6sp2Xp8JNc5kznXC/w1wA4xY8kB+i
         JHZczeoZxnqq1Z1VfrZNQYGOm/SvNoTAAry3mCOxZ2vUnLP5IE0nAg2d+D8V1F9Y2zSh
         ydm0g/n4PK/6vHFCL5dHfNOt2ymvMz+mAwIsci/KX8QhNdZrhTbRqC8hypGps5hAZiw3
         qd2suOeA78bVKvcrYtSh5oSPzfJ8bxL9YwHhhYdrxPIQDTrXnifadcWF4HBL5Oj/SMdp
         UtYOjpIAg97C8kkY3bJKUYk/jyFhm6KFs4N62r6WF9SKqCONzda4jzT2ucHsSGvlYNea
         QYeA==
X-Gm-Message-State: AOJu0YzFmAxm5hadvfHOy+xxDI5cumqo6WO8GdeFutRVMIXzr97/qk9h
	Bi3SZD40beZ8ZmJWhea5sWqqxZTMyVpUrb55xKKTdTmOEcJBcTHWKUXoSfZwOw==
X-Gm-Gg: AZuq6aLsA6jiQggo96CGVyZaOXbuByfWf3YDqfRgTy8itTD0H6KfsgcEShAYXB3++pp
	X7vM6wLSwFXrLG2B4vOS8oLYs3FG25SlfmLfcTAhqQhNfbF24vBcfuCaSZQs2TXkiejM7C8YD3i
	XHCMUIQEqkqXrgq77znmOYKKSPppFvk5C+bnRaYFPbUK+oUB/0HmQ+vqe7yc+ORiCsb3yugjaSf
	E9Q9dq20GK4sQ2sgQvmG8L+OmevBmCE/0TQADmmVXjsPyKe2J2BpR0gbBz7WM7ytIcD5FmZTDny
	L+7ggQocc57BbcnZLQYWz491tZBHa1JWMjoitQbBGqQsfBlQ/68YxdMp1dpHKmHdIsqXTqZiDyx
	M0EgXD9MpziRM7ay6jEL3lryEr2fnA4ekvnoV8LdqyvEk2hhdJ7qBsBkWXqu9EVyvUaE/cHrIBk
	wUG4s1x7nKP5/tiOznVlnN1GetFhgGwqckcxUTNsUyFD+af0t07syH7M6+wHqgKkYJHzNcZ+52h
	AGmD6qfruHncwBgQw==
X-Received: by 2002:a5d:584a:0:b0:431:808:2d32 with SMTP id ffacd0b85a97d-4362904b903mr225923f8f.7.1770314688625;
        Thu, 05 Feb 2026 10:04:48 -0800 (PST)
Received: from 127.mynet ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43618058473sm15460469f8f.22.2026.02.05.10.04.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Feb 2026 10:04:47 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	axboe@kernel.dk,
	netdev@vger.kernel.org
Subject: [PATCH io_uring 1/1] io_uring/zcrx: improve types for size calculation
Date: Thu,  5 Feb 2026 18:04:43 +0000
Message-ID: <ebd70ad4ce36d8487ac994ed464b97aa08d8ed3b.1770314615.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[gmail.com:+];
	TAGGED_FROM(0.00)[bounces-12056-lists,io-uring=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,kernel.dk,vger.kernel.org];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 7FFB6F64BF
X-Rspamd-Action: no action

Make sure io_import_umem() promotes the type to long before calculating
the area size. While the area size is capped at 1GB by
io_validate_user_buf_range() and fits into an "int", it's still too
error prone.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/zcrx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index 8a9df72bc094..6a6e2f8d6133 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -205,7 +205,7 @@ static int io_import_umem(struct io_zcrx_ifq *ifq,
 		return PTR_ERR(pages);
 
 	ret = sg_alloc_table_from_pages(&mem->page_sg_table, pages, nr_pages,
-					0, nr_pages << PAGE_SHIFT,
+					0, (unsigned long)nr_pages << PAGE_SHIFT,
 					GFP_KERNEL_ACCOUNT);
 	if (ret) {
 		unpin_user_pages(pages, nr_pages);
-- 
2.52.0


