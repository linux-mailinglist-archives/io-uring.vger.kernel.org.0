Return-Path: <io-uring+bounces-12010-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id MF1dBlDDf2lvxQIAu9opvQ
	(envelope-from <io-uring+bounces-12010-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sun, 01 Feb 2026 22:19:12 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 6FDC9C7441
	for <lists+io-uring@lfdr.de>; Sun, 01 Feb 2026 22:19:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id DEC403007AF7
	for <lists+io-uring@lfdr.de>; Sun,  1 Feb 2026 21:19:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7240D2DC789;
	Sun,  1 Feb 2026 21:19:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YGJnk0oK"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 002AC2DC321
	for <io-uring@vger.kernel.org>; Sun,  1 Feb 2026 21:19:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769980743; cv=none; b=ONJU9/FkphBw+88RQhrqiI0crNnINvvuF4QYwRzYd5EAwAO6+k05By9dQAGVo4ubPyvhbnwonvleFTc6Kendj1fjVPpv2OX8a5kUc4VfvF2o67eOKukfBMBC5a01AYLUJvB5cHCcouHbtWtgqfauKqfEU4otqxWwAFPmTDsc10g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769980743; c=relaxed/simple;
	bh=4tAKjceAqndRpc+ZomLK/YujbZ/N+W+Q94sN7KsxBnk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=D/4TTBJ6RoDZvrBY6kI2UNwlbxn8014PM0+h47h9YptwUbA94hI2dzhx7Zw0GfAhxuAD/sd6VdJYfTdf3pedXOX6H4nWlJoP7Gyoe4k+c9JPQcUU0k5YlQkF4ILzFlYoLp0SchAPvL5ivfmMYfUSa/nnA8IJjpf3/Ggjc84aJmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YGJnk0oK; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4806cc07ce7so37865005e9.1
        for <io-uring@vger.kernel.org>; Sun, 01 Feb 2026 13:19:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769980740; x=1770585540; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ld7WbI1rQlFVF5lIZMpr5m89ydDvu85IcZ6bvRMoGqg=;
        b=YGJnk0oK2caR9QDCyiC4D6xI6XivYxXF95jjOyDzgezuUEFKDJVuCKaOuK3ZjfEC/A
         /MsPHz+VKvN5M7z9tNLGyh/0w4gDvv5VDgpdIVgVuFMnrTdg2cC4Tw4Wpy5AAYlFksqH
         bPj/lkT5ILmXSZ74JIowkL7b8g9dspY3wrzME9kFxjjGj4Xs9Rrsq24vASzl6y/Rx8DD
         lcQYJrPpTsUBApGU17HVUpyMYdzzw6cNMOP/IpPJjYPR8Ak4F/M8t9GrtLdLykC76WUE
         CcXSR9E1Im/RrlBWxhq46AkplQ8jh06Zk852r/+1YXC2zYLF39VdAlMuIae3O9trCmQj
         l7cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769980740; x=1770585540;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ld7WbI1rQlFVF5lIZMpr5m89ydDvu85IcZ6bvRMoGqg=;
        b=t9VMzck0OKRRCZ4XYyi9Gt5UGGKdfq7KK1ROeuZnmJOpDntrBp2FhIH9vDlAMz2Gt+
         atDDC092z2p22WDlZvFaic05AP7Im9LnR8dZ2h93NlHnDRaX9gGZ90zII9Z62S276r6l
         hzNNmKJYCYEjCKkG0L/Ooy7FhmBVhzXSzU0HajMerDt9xRKHNHJ1WuS8Y2ve0R3OlLHj
         2AFWX/BPMIB5GWooYPC1YU6CiQdLEPlMbncFU4i0ut6oV523w4ZSupnoljkSnUbA4OEy
         15UjgBAlUeGrhrIWzn2uDva++HOPGs/d4UszTEsmK39oNPptkaOvibSwCaKdvcivKyr6
         wksw==
X-Gm-Message-State: AOJu0YwgwYBxRHYZqEYeVbOZQdcJK8wMA/7h8v+0jp9Dp375fc/dcY8k
	Py2pCfvVVgaNz2xR4fPd7MbGTaGOWOJJ6035Or9MFnPHWxnx11halPkevPi6kQ==
X-Gm-Gg: AZuq6aK7QmVB5RcI8AaNzOksr1mb6OymG1D0DFFyw3bm6PczNGaYf3zWWv19jjjQtCt
	4aJC4h9owUyGPtXJZ2rIKHGk2SgZwejfVvrYlzhQ6XIZLmIYlpqYCDuh4PC4oLAH17CmN7yUwAA
	beTJxLBSpIEyiPTVCEZ4rbTm4jNQmi7fvwq1IyhL/v2vbrID0Bj7wXMiNCWxQsxbLx/GYftVtfq
	HJNSZVn4Zwp18NdWQyxDjeQiNNuwEn1kd5jRBzIt/GR2TzoJMDCe3z7Syb/chPtYoNJmKc6CgaX
	S5iiwnCm28wlCbmFuEOkH/pPXfmU4LrQZQmyWoxTGhOg7+zwuje1R7CU8+B7slB3l2DpFY4Egw1
	mpA0PoT7iyh+bt0bePj2cC+B+iEpCQf+ss7OFMDCtuoWOPm8emiz009vycDqLgda2TnZunD7GRf
	Ae1tsd3g8IFhPdD+rCSJVevVI8qkTu38OiSc4nX5eeX2LTOUYOzfLYM1nsU3tQ3wN1SgwX83ag6
	/rf7O8OIbCWTeYDiQ==
X-Received: by 2002:a05:600c:34ca:b0:480:3b4e:41ba with SMTP id 5b1f17b1804b1-482db48d595mr111497185e9.18.1769980739829;
        Sun, 01 Feb 2026 13:18:59 -0800 (PST)
Received: from 127.mynet ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48066bee7d0sm443704085e9.4.2026.02.01.13.18.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Feb 2026 13:18:59 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	axboe@kernel.dk,
	netdev@vger.kernel.org
Subject: [PATCH io_uring 1/1] io_uring/zcrx: fix page array leak
Date: Sun,  1 Feb 2026 21:18:53 +0000
Message-ID: <8b46043155b3abd8a6421c6aa9a61064d1d430e4.1769962652.git.asml.silence@gmail.com>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[gmail.com:+];
	TAGGED_FROM(0.00)[bounces-12010-lists,io-uring=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 6FDC9C7441
X-Rspamd-Action: no action

d9f595b9a65e ("io_uring/zcrx: fix leaking pages on sg init fail") fixed
a page leakage but didn't free the page array, release it as well.

Fixes: b84621d96ee02 ("io_uring/zcrx: allocate sgtable for umem areas")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/zcrx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index 8a9df72bc094..0c4b339f712e 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -209,6 +209,7 @@ static int io_import_umem(struct io_zcrx_ifq *ifq,
 					GFP_KERNEL_ACCOUNT);
 	if (ret) {
 		unpin_user_pages(pages, nr_pages);
+		kvfree(pages);
 		return ret;
 	}
 
-- 
2.52.0


