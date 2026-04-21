Return-Path: <io-uring+bounces-13072-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kMXYAyM552no5QEAu9opvQ
	(envelope-from <io-uring+bounces-13072-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 21 Apr 2026 10:45:23 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id BE6EB43852D
	for <lists+io-uring@lfdr.de>; Tue, 21 Apr 2026 10:45:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id EE971300DCCA
	for <lists+io-uring@lfdr.de>; Tue, 21 Apr 2026 08:45:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C61739F19F;
	Tue, 21 Apr 2026 08:45:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kHj0wQQ9"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA86F3793DA
	for <io-uring@vger.kernel.org>; Tue, 21 Apr 2026 08:45:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776761119; cv=none; b=LXiOjKSo8oHeMWlE5kKN0jF/dEhYeaQ8mxaGRC5Po7jWgVtqwstsmTg9omalWkbbVv9BpyYr7mKbH4Y0kBG8LoRYyXxs13PorsT++l6TBPuj52ApYhfj6dTJmQzoUvHRYqIoyaJ26tbTkSNExqG0U99Hi+2tjOL9VjSbvwBzwB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776761119; c=relaxed/simple;
	bh=jY2oAnibC/hnxXMwRfhye0JZWn0j5hS9eu/mxZ4RZxQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ju6HTFbDD8msGKkjep23qhAXf85ZDn94wKL0ii7EVUm4CdJCiJbXIego14WLAreUYFzIdCYIFRUhVy4KpFARiOWqwPVED5zyDcaYNd3VId/cMUHlw0K3RbX6l2ZZI/Di1E/eLCPkpsUZ9tuNaTjMIX3rPDWBo4uh+6EzSOfCqSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kHj0wQQ9; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4891cd41959so19828305e9.3
        for <io-uring@vger.kernel.org>; Tue, 21 Apr 2026 01:45:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776761116; x=1777365916; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=rsev4JhWJNqcO+Dsxr7am7zy6PUf5mFhTqsSumq1mwM=;
        b=kHj0wQQ9QyersBZlIaq/w8u8lnKPT2W3adEvZAmT6dfish6cWTXTVIKoSLtRxxpRvI
         6+br3FXZCCRNEtDax9c4q94vvKhr3g0wwFu3qnDFaccjR9Y5RcpLrGnrEAW6hjAcoxaU
         heyeHETgTQYd7lNZRYKQrXysK7WXkQMNF2CaPVKf5+r8Q0d/+vPTwYPY5FImbrvWbri8
         3SDAO5ZRsDzNH41+VFBn0NQ9F2/9ufnQxCQ5OI85xbUAlSthcKAFezrqF3KV5X1St277
         u2ktIVzfzRcGNOi0AZx3DNu+X3+rRBfVbCZIBwI44IMVwIiIBWH1dnnNU8cwk3+iq/T6
         JlnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776761116; x=1777365916;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rsev4JhWJNqcO+Dsxr7am7zy6PUf5mFhTqsSumq1mwM=;
        b=IXiPOuWlYu/HgCQkj2jJJJ8U5BrLOMwDhOSlaeNzjGQZ4qiF3quDe+oOb1Fex16HVt
         LY0gTahDshcaMh6Fk8Q/nCJXDhd7ZUPc0LWxxQTMV6uiJIASiECi5IGLfhcMgJd9ybJH
         /NWwxiPOpBNaW4tMwo4FfNcpmWssnvp47bgktiwn5lGCW5lcruZrKFIB6Hnuqeh38Q75
         NTu69rP5+JjsMJI3te+9XGu6UayPICeV1TUcBtO+FkXUvjadkOzO8R5MEBm2S5LeiSam
         w6XalX1ZcKy/6Ir/6ZFGxmsQcpgHL+Q6tnrE0fPUudqoSKsFfBfYS1expzhWYsYlNKQW
         cXHw==
X-Gm-Message-State: AOJu0Yy0EjpCahy05sPBfg1QGiX6GfXUmB1VZeNabKc5fka8FaV08iA5
	u0b8DnQuVS9KhbG2FDT/9I5009HrMebVCOabXb1ZMUbgJC7hrjms0ds1pt1StQ==
X-Gm-Gg: AeBDieuvCCMZk8wYpO44j4tObrKoZu783I8gmjIpp2Nenq3MzyL+5AfknCzFoj0r5o/
	uW2w711HM/DBLGixYFQq4ZXdMCNTjtvltBxl/1tb57BtEZFU9GUIeJmsMMZ8MNfLsu0IrUhNEjf
	YY75v1GXfrb0ymSfK5X31CYsFIqHYdb5rkF3XkRw45NeWybkBdK5CUchrzxggi++CKTf7Wqf+/Q
	/iXkNisKTD9AOHn+8I30HZkq+EAI/n+XYC6Dh3llEGVb8ylIrLg3zIMBocTew1+rT+CxqDVxqBh
	/72j2tqUvXa7Bus1Wr/34lNyKy8FVeXjmc2/tYuzpQu41DKlrzB8eSAYaTGxBeCSP7hKPG1rtf1
	87mSOK5KOQZB3EQoUkdg8vRv1t7QppPMGh6Rz57f6REtIaog453YTC2TU5NOpEnwkRRPG0rL1xF
	emipnZJKjfGafMfSrwKnY6gDYMcz80awE7ahQypXyhFHL4oA0GyyK9w9il7zw+0v3ci3hrhcGiD
	ffLMkMUGF/XsICd1sCZ
X-Received: by 2002:a05:600c:5295:b0:485:30d4:6b9e with SMTP id 5b1f17b1804b1-488fb77facemr250012955e9.21.1776761115626;
        Tue, 21 Apr 2026 01:45:15 -0700 (PDT)
Received: from 127.net ([2620:10d:c092:600::1:e3a7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4891df9e50asm114549945e9.0.2026.04.21.01.45.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Apr 2026 01:45:15 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	axboe@kernel.dk,
	netdev@vger.kernel.org
Subject: [PATCH 1/1] io_uring/zcrx: warn on freelist violations
Date: Tue, 21 Apr 2026 09:45:29 +0100
Message-ID: <2f3cea363b04649755e3b6bb9ab66485a95936d5.1776760901.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.53.0
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[gmail.com:+];
	TAGGED_FROM(0.00)[bounces-13072-lists,io-uring=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,snailsploit.com:email]
X-Rspamd-Queue-Id: BE6EB43852D
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

The freelist is appropriately sized to always be able to take a free
niov, but let's be more defensive and check the invariant with a
warning. That should help to catch any double-free issues.

Suggested-by: Kai Aizen <kai@snailsploit.com>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/zcrx.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index 2eb09219f0a0..7b93c87b8371 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -602,6 +602,8 @@ static void io_zcrx_return_niov_freelist(struct net_iov *niov)
 	struct io_zcrx_area *area = io_zcrx_iov_to_area(niov);
 
 	guard(spinlock_bh)(&area->freelist_lock);
+	if (WARN_ON_ONCE(area->free_count >= area->nia.num_niovs))
+		return;
 	area->freelist[area->free_count++] = net_iov_idx(niov);
 }
 
-- 
2.53.0


