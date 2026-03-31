Return-Path: <io-uring+bounces-12903-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qEq3Mj84zGn7RQYAu9opvQ
	(envelope-from <io-uring+bounces-12903-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 31 Mar 2026 23:10:23 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id CD57637167E
	for <lists+io-uring@lfdr.de>; Tue, 31 Mar 2026 23:10:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id A2CA83041355
	for <lists+io-uring@lfdr.de>; Tue, 31 Mar 2026 21:07:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F75B44102C;
	Tue, 31 Mar 2026 21:07:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aQBVeCXu"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2939E41B36E
	for <io-uring@vger.kernel.org>; Tue, 31 Mar 2026 21:07:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774991259; cv=none; b=SeWkIkmfsdDGUMC8ATnpOVcLGENy1wzPvUSYBL58RYC5LJxqoJ4Z7J5ZTJMO3BW5e5MToEFFAM/SbCgOszh/DKGsLw31dYjKYhua4nzQ8cNPhsh6LNh0Prb6jDHJ2fY/Y2PQJM7hd6xEmdlPZZDm2WXqcFJpfyecRFDbysDF7Ww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774991259; c=relaxed/simple;
	bh=pwg7obW1F45qdk6CF931VQ3fdTHsQqpoLghThsE9nsg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f7/A4whQjEy0HDg0cMUlBxEkWx7uWhBxvKkXT+jhWrtX+Mh/WTvCqwRN13JYhZahLT8M4oEChq3ehJAa77131J9SYi8LCcQ0CPg4GljIzA6VKXC5H+mFNx4bsz9DvewxjxmF+SywNvNxLqDh53g3M3+ZIQXMzo2ZU+cE5hGSXEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aQBVeCXu; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-483487335c2so66152055e9.2
        for <io-uring@vger.kernel.org>; Tue, 31 Mar 2026 14:07:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774991256; x=1775596056; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0roaam8cmLBX+UQ0cLs13fGICp7YbtIQisTozBtEwtY=;
        b=aQBVeCXu02RZ5/XP6IqVZc+e+ZsjpL1m7jHgrhYkqewLr24JRyvjzdyFcGgJ3tGmRW
         ACM5rujXmA3Cq8sRfOW/goJt3iiGe6Vje9BMyvT+MncPVuSSe0r64LyhJe4JnuOKecrz
         +AXk2BGgfMW+/yI/aGzWQDvbuGlPZheFhN81w8zvQO+oGAgjNMMq2Pt1TRTR22f6larX
         PB7LzCCjEdCkhILbA3x00AMI3VJhywGGF+hNk33CyjCVDvuc3sK9u9Bb+mWcTR08BEqH
         Yo37QIo2VT943GnUTuM1zXwiVHRbGmErGfbcmagMFD0rktr7qA3VDxwy/K6qxn6Og4My
         yNMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774991256; x=1775596056;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=0roaam8cmLBX+UQ0cLs13fGICp7YbtIQisTozBtEwtY=;
        b=lr0Yi0QA15ngaFws/It6YmN1U9wBhweSAWPqkgA4J5+jqTUG5Yres7CtERRI1Fk9sH
         vY1iKtLx6t7x2g/SeY5IjlTivMu5YferrQauKi4kzSyi9wcbOryQlc6vuGmhJlXUYuir
         sosWrCsL1u6jgGr/xNMfd+AVnB2tQyGGveFH4v0F/c/HRx0El1e1wPSVa4qWQruE01ca
         HqXeQxygaZGz+tUVjExu3Tznnuo76aRQxuK9qKQCkGDqWru2dJ6lY89lLWDNNDURtdIs
         7AxzV1tKlrwN0HBCrlRToqPdHvlj7NCaeDhrUuF5I9lw1Hhj1NadqmEnT7RNYGHiyQQO
         pGmA==
X-Gm-Message-State: AOJu0YzDw/42JhFBvKbz6mvZw21diKP36Qv4iaapt1gj8xL9qUWwMuYC
	RrzuRSe1CcK0gCakUA0q+Ih3eYm2sMpyB4CJm3ozz7+3niHUPh0ezzHkIcdGnQ==
X-Gm-Gg: ATEYQzzP9InuqquWGVdoutZyneAmvB7jpIzw4YL9M/s2w4FKOP4QfItChD8q0BmNNQ/
	pMunj1DQq+kRxMc0rXeQZXRXrLoiWBOz9wZ5QKP8h4YNfTkYVbfRx2W6F8xCG+2DwPrBgfc/Bbc
	WZGV5NXaXQo+4Z+2zftgjZCjkfNvvWchuhn0v8KJQbOF+s9pbFPIfYG/w4mLmMkKiqVdn4ibTi+
	oTSeVf7oQsgO1P9hxfXM/nAD0fwZHEZcIt0UVbRicIjWdbrmOhpQp+moHQ8YBEp0CM/7lj4eF+L
	gGAPl/MXE85CBoWfyTZkES1H6d7PYk9tULmwWD7CdJINdfcehIlyPjH1ZccuCZHIWy+N0UNBDZp
	fPfitIyjWPPOkspzMODfzJ4iytr3Sp/6kUpUFwwxFiOC7Xxc7Asyw7l8pj8oEnydT1Vt2y46uIx
	iVVdOpgAJ3Xw1xuzdZGgyTMScgdb2j/RlLTeY5XdvAL9cuLhihuSyBpZ5U5rYTWAZRPybhuIidl
	3Dh5JHLNx4wYGIKjB+OScBwJ3cheQ==
X-Received: by 2002:a05:6000:230c:b0:43c:e7a7:9256 with SMTP id ffacd0b85a97d-43d150513d6mr1976348f8f.12.1774991256052;
        Tue, 31 Mar 2026 14:07:36 -0700 (PDT)
Received: from 127.mynet ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43cf2570b18sm32431393f8f.31.2026.03.31.14.07.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Mar 2026 14:07:35 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	axboe@kernel.dk,
	netdev@vger.kernel.org,
	Anas Iqbal <mohd.abd.6602@gmail.com>
Subject: [PATCH io_uring-7.1 v3 2/6] io_uring: cast id to u64 before shifting in io_allocate_rbuf_ring()
Date: Tue, 31 Mar 2026 22:07:39 +0100
Message-ID: <52400e1b343691416bef3ed3ae287fb1a88d407f.1774780198.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1774780198.git.asml.silence@gmail.com>
References: <cover.1774780198.git.asml.silence@gmail.com>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12903-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[gmail.com,kernel.dk,vger.kernel.org];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_COUNT_FIVE(0.00)[5];
	DKIM_TRACE(0.00)[gmail.com:+];
	TAGGED_RCPT(0.00)[io-uring];
	RCPT_COUNT_FIVE(0.00)[5];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: CD57637167E
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

From: Anas Iqbal <mohd.abd.6602@gmail.com>

Smatch warns:
io_uring/zcrx.c:393 io_allocate_rbuf_ring() warn: should 'id << 16' be a 64 bit type?

The expression 'id << IORING_OFF_PBUF_SHIFT' is evaluated using 32-bit
arithmetic because id is a u32. This may overflow before being promoted
to the 64-bit mmap_offset.

Cast id to u64 before shifting to ensure the shift is performed in
64-bit arithmetic.

Signed-off-by: Anas Iqbal <mohd.abd.6602@gmail.com>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/zcrx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index 1ce867c68446..b8f15439d5df 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -384,7 +384,7 @@ static int io_allocate_rbuf_ring(struct io_ring_ctx *ctx,
 		return -EINVAL;
 
 	mmap_offset = IORING_MAP_OFF_ZCRX_REGION;
-	mmap_offset += id << IORING_OFF_PBUF_SHIFT;
+	mmap_offset += (u64)id << IORING_OFF_PBUF_SHIFT;
 
 	ret = io_create_region(ctx, &ifq->rq_region, rd, mmap_offset);
 	if (ret < 0)
-- 
2.53.0


