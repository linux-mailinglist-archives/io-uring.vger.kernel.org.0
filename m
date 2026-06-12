Return-Path: <io-uring+bounces-13699-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id OS8rOwBELGpiOgQAu9opvQ
	(envelope-from <io-uring+bounces-13699-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 12 Jun 2026 19:38:08 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A16067B65D
	for <lists+io-uring@lfdr.de>; Fri, 12 Jun 2026 19:38:08 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=CUtfoqQm;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13699-lists+io-uring=lfdr.de@vger.kernel.org" designates 172.234.253.10 as permitted sender) smtp.mailfrom="io-uring+bounces-13699-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 070A63216724
	for <lists+io-uring@lfdr.de>; Fri, 12 Jun 2026 17:36:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F467406291;
	Fri, 12 Jun 2026 17:36:31 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3015406829
	for <io-uring@vger.kernel.org>; Fri, 12 Jun 2026 17:36:29 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781285791; cv=none; b=Z7ttS7TRlL+ApP22S6eHmh51yNsyy9QxLrjLnjCM4cp2tKr6xrrPMaa7qSFiPGNO2/SzM6BDUwcCnA4X6Y559ZIn6RtFGhPUv7jlftbArveUxchTGLpL01GPyoo/7fX7aZnNmXvh03qCnn9pLdc0myC+VgPjn2XkWgBHsjH1l1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781285791; c=relaxed/simple;
	bh=X+LINLrUcTEkZm8M66oHNbJqsKf+dL7XFF5mz5gIdUk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=B2pWtPxNfLibYCEUx7nVKlp3Cd2JIpVan/gCtzNUYMb89cOpqM/f7+nycL9hFPyxzCLjUtRw3tF5MWzTtTjVEku7oblTfWdpT0Nt8qNvQk3KQLEG/j9Nyb3Kz+SfvWinGZPZcoQ0IdzFA2BN8JjwcNbm77/FVZy2TIz5FETovbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CUtfoqQm; arc=none smtp.client-ip=209.85.221.48
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-45eec22fab7so560722f8f.3
        for <io-uring@vger.kernel.org>; Fri, 12 Jun 2026 10:36:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781285788; x=1781890588; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=2CryNWlqXd8hetg1mVjUAbuv3LZZLIUiwsOD6iYq0Jk=;
        b=CUtfoqQmBHvRxE9OExbsy7csxj/KGMKnu63yV+StFo6KzL5I0rJX7+CTXK6cCnTkuA
         tzfGVCcfrSCB2zsxpzAyrJHz/1ofQn0A+qm8ezNFUWdRpz3+11FbllNZH27Gw4KmpezL
         r4Tiwua8VHcuf9jG/ayXHZGmVAJiLFFccC3HX4vu5ylFSbji20UwQn6h+hBbU9DN5u5U
         h7AuftyQ042YANN8Ra1HxXMPyc8RoCSLzXjB5dnwXqOgxphxQR2GCW0CSWmf+XDpqnbu
         y5PzmJ6nDmBLvwrf5Y9ifJiavGoK1iGcgkbGW1OtTyZtVu8SDn2WWP97+FZd80DcH1Tm
         l1pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781285788; x=1781890588;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2CryNWlqXd8hetg1mVjUAbuv3LZZLIUiwsOD6iYq0Jk=;
        b=FHWzLGQgzTb38BO6g983vqE8ObZJLqjZDZ1mjgp0BzBV/+DRzK7PjtmMymkLwpNO72
         rqBDwbw6IfSzCX0neDHDAZnBgj+BVCbZn2zluZfA2wlSb2NX5ms25GLSxk0cKD1j046l
         4WMm/NF2+59cuDNtVFNIRYji0+RZROTaarEKTKGMiMoCgvqMk24PF/TKZwTAtX87HvdA
         SJH/XxohbqEllyRBWMZ6BJYzrfBa04s6MPFBC5mPin/IjaGPYXleekkX+S4ucuy1W7qz
         OLS7iTnx7nFyAf8qSasr2Asnf1G3VNIk9Mwc5bgdDt9dQH6TGXD2FwV6jNe+vo1QIzvA
         VSHA==
X-Gm-Message-State: AOJu0YwhfGVhMj65CFgiThxqP4e/8D5ZBJhbiUh8Jy8at+W/vOasvSBe
	4Q/6L5u6x8aU9q8G4eufFjYnupA1/RPpFYbdnqHlv9/5CWBiDs6BT7F8eJT/OQ==
X-Gm-Gg: Acq92OH3ZgnYHw2yDFYnSm8VE7UtutlIc1qMMIrByM4x6/sDnkW6YqY0kq9jpOIaI9/
	mGetpMhwr87WWUH9u2KCMz0mt4kmbG8RlwcxhBAaHqALfGhjIeFUhSkpWWhf8q+oP9w56zo+lnx
	6QQgq3ZUaEEQYCs6rQwGJCq7ID8w3Nrsi/vtA4ZxfPdSAE77mlaX90Wp5B77lrNb0at2SzQgurQ
	RSqT7rSbz6tqMF8OYO9NVO02zL1XSK/3bUOsZcBfAUAUG9WdoZmS0dbpkwKYCDt65Ap3Vv6Uz9o
	rOfohsh19jmWDMr8qorIO702UnAXEObyQlS4I2nW1dQux/0Nhjy6AccV+pQ2LDxxshxB8bUThGQ
	+Xzxu94DLZApNw76GPEH7yVZwZ3DO4GcO1dU7+hKUswRQ2RLl+VS1kj2WMPCJqJ0Fxe6sXgMGeS
	6Qqil3tcrGbKhg5WuxRnjj8SdkrL7pUKUN2UsjozGq5SJRhBfJAiArZivRvRp7srA9vIiPda7+x
	bqLmOkX9eSrlKUHgyE/Mb1OyqOUrg==
X-Received: by 2002:a5d:59ac:0:b0:460:3234:4474 with SMTP id ffacd0b85a97d-4606dbe4f1fmr5786536f8f.42.1781285788071;
        Fri, 12 Jun 2026 10:36:28 -0700 (PDT)
Received: from 127.mynet ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4606f2b0c35sm7741896f8f.22.2026.06.12.10.36.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Jun 2026 10:36:27 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	axboe@kernel.dk
Subject: [PATCH 1/1] io_uring/bpf-ops: add a separate maintainer entry
Date: Fri, 12 Jun 2026 18:36:22 +0100
Message-ID: <d89f3b89e77b09a18daa45476fd1a40f2ee253cd.1780930463.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13699-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,kernel.dk];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:io-uring@vger.kernel.org,m:asml.silence@gmail.com,m:axboe@kernel.dk,m:asmlsilence@gmail.com,s:lists@lfdr.de];
	FORGED_SENDER(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	TO_DN_NONE(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	FORGED_SENDER_FORWARDING(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,vger.kernel.org:from_smtp]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 5A16067B65D

Add a maintainer entry for io_uring bpf struct_ops related files.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 MAINTAINERS | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 2fb1c75afd16..fc3be0ba1462 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -13527,6 +13527,14 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git
 S:	Maintained
 F:	io_uring/zcrx.*
 
+IO_URING BPF-OPS
+M:	Pavel Begunkov <asml.silence@gmail.com>
+L:	io-uring@vger.kernel.org
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git
+S:	Maintained
+F:	io_uring/bpf-ops.*
+F:	io_uring/loop.*
+
 IPMI SUBSYSTEM
 M:	Corey Minyard <corey@minyard.net>
 L:	openipmi-developer@lists.sourceforge.net (moderated for non-subscribers)
-- 
2.54.0


