Return-Path: <io-uring+bounces-13884-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id 6EstDdLsSmo4JwEAu9opvQ
	(envelope-from <io-uring+bounces-13884-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 06 Jul 2026 01:46:26 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 761F970BC49
	for <lists+io-uring@lfdr.de>; Mon, 06 Jul 2026 01:46:25 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=YHTkX2vp;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13884-lists+io-uring=lfdr.de@vger.kernel.org" designates 172.234.253.10 as permitted sender) smtp.mailfrom="io-uring+bounces-13884-lists+io-uring=lfdr.de@vger.kernel.org";
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 150483005749
	for <lists+io-uring@lfdr.de>; Sun,  5 Jul 2026 23:46:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F49E346AF1;
	Sun,  5 Jul 2026 23:46:23 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 435FB78F2B
	for <io-uring@vger.kernel.org>; Sun,  5 Jul 2026 23:46:22 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783295183; cv=none; b=O4f81LneOKVcT9f2yqdY/0xOdxBL26GxByAURvrvHcRN781ZvBzXfvrbYNFYMyxAVSsqS8a1s8Sqrrh5BUTSVVaI8BqpYB1N+QBQqjvG36PThKeZkWKguaE8z1BgWYaXro/4Zy3/rFYKFtYAXOqcYPYGV3gaBNig+twUT+0DHQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783295183; c=relaxed/simple;
	bh=rwiGUlXrzKU1WnDfytZuyAUkQvRMBBDHS4rt18BXk1g=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=CWv2MznsfMqB5XmifyQ3PxUDekMhbHfHd1rfaxbuiz6IIE5QodR1k+NKmTPj1JX2iubGg9YgmsTedBnpGb28YTdZbZgUVP5ZueCizK5tVJ5iCFgopxEW3ky123vEKSbdH8GCtPi8Ecb+jss6g0W9O7hT4nyNlNkV8wIlJ2UQV5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YHTkX2vp; arc=none smtp.client-ip=209.85.216.54
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-385ea3ce80dso387107a91.2
        for <io-uring@vger.kernel.org>; Sun, 05 Jul 2026 16:46:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783295182; x=1783899982; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=1ww0dOKkmeJX/064KbajPe2nczUlwX/FWmPsoIooNcM=;
        b=YHTkX2vpTgUY6ZaSUw1gVW38HtwXZCyrEPHv+TAbZ/ZW9v6GpYklQuMTjWLeFHM4bG
         2P0m7Zxfyydvzxlqau5hA9TnvJNIsONcatrK+KcyIFPNVH3vJ8QVsJy1Qlkj5ZBGGGKc
         QJKiHanhMVVnXYZwZuUIgVKtmGbrZxFYmpw4FtXRSW/cMCcQHM8woNz8eQcxTTicKIJV
         8YgHglWdWxx3T7dhJCjxkCv0QJW4Pv32vLI7EoxSIbD5KvLi4RQCk3H+PYn78WthHqeH
         F6uxwTsVv3DVyUmVJzoVVgadDuMPcfSu5aymajg2hmCDtWs8phCPcJ4hapBkrFFpp+Gg
         K2fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783295182; x=1783899982;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1ww0dOKkmeJX/064KbajPe2nczUlwX/FWmPsoIooNcM=;
        b=g+9fUce9BqbgxFKDT4UKlJe9P5uc+Jyz/UN4XuJ3a8MQOBZUjwqjFdrMI5UGDguchv
         ZNrtxwOhNTR46B2hojbC3sZqDmvAxZmxQ4Ty4R76nVA+4P45bKaOOIhRHy63EBowzhfQ
         yvoEhHMah0FxP5UQoeBRRV2qVVK9TEGvz0bCbRRFvHDdW/H39q8+6iOHGUjhr+0/IjOO
         TJlMYUQFejGl/xnR8uvjKQ8OaGIoRzoWRbUoqZ8UPt2KPBXyMC5vF0jmudLSMDPGicaK
         QPDWylNai7iZNdfAYqovCDlyxZryGrrUQlcsEzmLLlqs2984RSyzSHNjaI+DrxyUNiR4
         e1Bg==
X-Forwarded-Encrypted: i=1; AHgh+RqutV2tmU9kRvO/o6u3/WNRY4jSTewVIlbUuUNQVNxRTFZyO06d5ev7jtG4BR6mqgHr1g731KH+Hw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz6K156NR0ZmHAIeH10n8OaEmioxN3y4ruj6lUyPTWu/0g47PF9
	0uMEq6/wnL+orAPERSl6ZwPySrJqxwUrcY/Tt3oHNOFnutNR5ACsrsQk
X-Gm-Gg: AfdE7cmEHYwdExxwjn22Tn6t9xjjRHKgolYUIaZF10aphCM7fCaKA5kZbu2ea3d7PTX
	lf/c40f49PLSUFAR/9ZTAJIDJyDMekwKFaoqr2sLy6jmaPDWmO1wzu3bViDfQ7Y2VkdgP/Dh1Ns
	Xnqew6NDu6LrzQ/Hkeix17COvrGMcJ1fUZK6oyGkrFNlc3feaZfBEuoMNqEhYbgEXVxbEMfiAmw
	ptQKjKIMRr4BnUwrJ/H84DljB7bGxWb8EKrJDGkZCRouhoLbCo4ROongIjzyyO0ZrkRPg/U3aub
	hzyAlDgRdZz+ZsBBienAyC4wArMCDzC0XrmzwjrcC8q04M3cOnFCztKFadDRYzYsV1hHTSD6tt0
	KI0wdaZ18CwS+9jOEMKGIzbm+qxD7b54DVfTwNuDdk3k99YCRVe79mtHOf6EXhm8ZiCwqD2WVSp
	bFblS+VOAYMXd4sc/0dAhukVAmuwaZIYVj/caAm31AR5aYwB+sLWzu68Q=
X-Received: by 2002:a17:90b:2e42:b0:381:720d:240 with SMTP id 98e67ed59e1d1-3828127f8f6mr7770740a91.14.1783295181617;
        Sun, 05 Jul 2026 16:46:21 -0700 (PDT)
Received: from naup-virtual-machine.localdomain ([140.113.139.102])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3812801eadasm3820671a91.10.2026.07.05.16.46.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Jul 2026 16:46:20 -0700 (PDT)
From: Hao-Yu Yang <naup96721@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: axboe@kernel.dk,
	io-uring@vger.kernel.org,
	Hao-Yu Yang <naup96721@gmail.com>
Subject: [PATCH v1] io_uring: fix dangling iovec after provided-buffer bundle grow failure
Date: Mon,  6 Jul 2026 07:45:34 +0800
Message-Id: <20260705234534.768138-1-naup96721@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[kernel.dk,vger.kernel.org,gmail.com];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-13884-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_SENDER(0.00)[naup96721@gmail.com,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS(0.00)[m:linux-kernel@vger.kernel.org,m:axboe@kernel.dk,m:io-uring@vger.kernel.org,m:naup96721@gmail.com,s:lists@lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	FREEMAIL_FROM(0.00)[gmail.com];
	PRECEDENCE_BULK(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[naup96721@gmail.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	RCVD_COUNT_FIVE(0.00)[5];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	ALIAS_RESOLVED(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,vger.kernel.org:from_smtp]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 761F970BC49

When growing a provided-buffer bundle, the old cached iovec is freed
before the new buffers have all been validated. If validation fails, the
request still points at the freed iovec, which can be freed again during
completion cleanup.

BUG: KASAN: double-free in io_vec_free+0x2c/0x90
Freed by task 73:
 kfree+0x104/0x3b0
 io_vec_free+0x2c/0x90
 __io_submit_flush_completions+0xc03/0x1e40
 io_submit_sqes+0xdb5/0x2310

Allocated by task 73:
 io_ring_buffers_peek+0x559/0xc60
 io_buffers_select+0x1c1/0x460
 io_send+0x770/0x1050

Fix this by deferring the free of the old cached iovec until validation
has succeeded. On failure, free the newly allocated iovec and leave the
request pointing at the original one.

Fixes: 46800585ae04 ("io_uring/kbuf: validate ring provided buffer addresses with access_ok()")
Signed-off-by: Hao-Yu Yang <naup96721@gmail.com>
---
 io_uring/kbuf.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index 3cd29477fff2..4055173e0c48 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -256,6 +256,7 @@ static int io_ring_buffers_peek(struct io_kiocb *req, struct buf_sel_arg *arg,
 	struct io_uring_buf_ring *br = bl->buf_ring;
 	struct iovec *org_iovs = arg->iovs;
 	struct iovec *iov = arg->iovs;
+	struct iovec *old = NULL;
 	int nr_iovs = arg->nr_iovs;
 	__u16 nr_avail, tail, head;
 	struct io_uring_buf *buf;
@@ -288,7 +289,7 @@ static int io_ring_buffers_peek(struct io_kiocb *req, struct buf_sel_arg *arg,
 		if (unlikely(!iov))
 			return -ENOMEM;
 		if (arg->mode & KBUF_MODE_FREE)
-			kfree(arg->iovs);
+			old = arg->iovs;
 		arg->iovs = iov;
 		nr_iovs = nr_avail;
 	} else if (nr_avail < nr_iovs) {
@@ -318,6 +319,8 @@ static int io_ring_buffers_peek(struct io_kiocb *req, struct buf_sel_arg *arg,
 		if (unlikely(!access_ok(iov->iov_base, len))) {
 			if (arg->iovs != org_iovs)
 				kfree(arg->iovs);
+			/* hand the still-live cached vec back to the owner */
+			arg->iovs = org_iovs;
 			return -EFAULT;
 		}
 		iov++;
@@ -330,6 +333,8 @@ static int io_ring_buffers_peek(struct io_kiocb *req, struct buf_sel_arg *arg,
 		buf = io_ring_head_to_buf(br, ++head, bl->mask);
 	} while (--nr_iovs);
 
+	kfree(old);
+
 	if (head == tail)
 		req->flags |= REQ_F_BL_EMPTY;
 
-- 
2.34.1


