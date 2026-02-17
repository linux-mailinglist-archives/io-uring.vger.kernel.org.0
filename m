Return-Path: <io-uring+bounces-12278-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KGz0Og1KlGn0BwIAu9opvQ
	(envelope-from <io-uring+bounces-12278-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 17 Feb 2026 11:59:25 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 65DA014B140
	for <lists+io-uring@lfdr.de>; Tue, 17 Feb 2026 11:59:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 3E8F23031015
	for <lists+io-uring@lfdr.de>; Tue, 17 Feb 2026 10:59:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A47CE32C33D;
	Tue, 17 Feb 2026 10:59:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VqUj29ru"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4659B32BF23
	for <io-uring@vger.kernel.org>; Tue, 17 Feb 2026 10:59:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771325944; cv=none; b=Om3da1mIaKNQjl9hW5wGzGu/9GQ4ere2w3s0hxjxhJmuxzAUYjsvZtwr2LZlaGzetUWH5WcOVEQzAxIDp/KFk94ToAPAIo9viHOkBUM+15mA+6XNFdwuR+l1N2s6yeoE9LWe9W7xDjjEVKCLi58R3BfSjmJcmSlHOXtxvjikzAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771325944; c=relaxed/simple;
	bh=8O3zadhQFFrMOJlzFSuNCpmQxJ4lHLoxg1CzYpG41Bs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pnBfzzq4snvV8JAp2VvDyerl2IS1ep1iDYwBfGx1LXult5LY5M989unhfBe+Q5NPCHj9bh52HP+OmyyLiHbaYstqtgnESF8nbRzv8WZN+YDNI2DVdWXMn1mmQpiWRp+2Y2rJGAG9ISDFjiTsES0WaxJbqhR+Ye69vSytOEH0B/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VqUj29ru; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4837907f535so27802665e9.3
        for <io-uring@vger.kernel.org>; Tue, 17 Feb 2026 02:59:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771325941; x=1771930741; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BSD69O1S2Kw6wDmNz4WpERJPeIizD8wuOPPkchpRNWY=;
        b=VqUj29ru8MSY+nRewAevqOhU3CdMVfL1KW8EVASTzjt9WyxaLAWpiFbFUd9JIUmRWi
         fMqCvNVhvge0a5gYYW3dbgdXimhGFU/acq8lS85ly82zoaG2ELdiqafcPNLlKggOo5Pa
         5gUfIOXd2B8Ej5HbKLl6RekQ+Za2vzapRX5j79mCjzIh3mnes7Kuf2Q0V8JNbEOsaTRO
         OD/JQmF9ULft9OWQ6po3NV0XZvAcicITYEPLGcvOaGC7okYsiKG+YK6UpC+wJ1fq6kNW
         cOo4FUtyBDCUb5ZJy7mOEOwkrO8D4Rsi6pSS9YnWL9/quCuKY4vLP981xNYwzDBJrG+g
         01gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771325941; x=1771930741;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=BSD69O1S2Kw6wDmNz4WpERJPeIizD8wuOPPkchpRNWY=;
        b=vtcKKplvDJFTbdbSFJ+VcMlxtbFXB840ePDi2yE6j+y/Ns1Wn35bWWyg37IWwRiPbJ
         i63hY/L4PaJ3Id69kRDyb/hk8vY2E6Xr/NthV/6s5nMtgI5y0ua/bpxvS3dyNRob6GnB
         QTKJ3yaUb1uG20QXZpP/i2JNwqG3S/tVvH0jcr+FK/RGdSiBHOdFuArbX7GnTIVsMIBP
         RO3vR/MWsCUpsoCEfpJBU3wa/8TeI2cP3TDs/ekeXY2r+BmOymJDqrVtRmeNR5p+6nyN
         SuJeIEVaUW/J5oY2Kw/OekPzHbQVNKWxi4MwQQlq7yrx7qg5gkP6NFINEHr8CF/5pRC5
         mwEQ==
X-Gm-Message-State: AOJu0YykN5R2u3pSTHNK/ZJ6suMPiRytuXDGDeTMGD44tucPbc5JMe7+
	zj89tNu3bO9qRp8jFjqTsLe2AVqM3nKjzPi0bw8G6MzZx+aADqst7ycCOMVQbw==
X-Gm-Gg: AZuq6aKbgjwCOGRaH9+4oriCfS8qdro1Kauif0bdiHSoaq6FSK2QF3orjS5EeAkc5N9
	3AogS5qiex0wPvtkZc6vTRhuYxNI5SmBWWO94HuE9Wl+3KS9oCfmoXswUKoUDSFDPPsfgvQiWrg
	I1ennkBb9xby7imx+Lw9a5vr+pH4ISVzpT/YbCa7DFQASXhwWlJRfUlxism176nvdV55V0r4aga
	so3mvAjMsGv2YYS87za2uVF7z+o+VTEDIvn0Rwp+htLzIgJ7fedLSlIV9ma/y4enAbAK5w3oVck
	+EeI3aMlvsq5lznY5yeHB/v7ifAFFUwuBMTCk3J1dNb86XAOPMVZ/dbdyUH18FhAjhuJEq/LoaX
	SLBfmnlWBY9WYqY69YdX6OtX4tL65yDWSeeQMigoYPqMNmRe2pcAaPve35BobBk3U4ucTksAo4A
	DP2uEMXUbFGVm8aLSfW3JXnM8O0b0Jd7eEHqqXjGiC26eT0pzQfwUvCsknpyfIGRvfdVnZmsTYE
	nzXog7ASKRQ3NSLRVcZSCON3sSyBw==
X-Received: by 2002:a05:600c:6814:b0:47e:e78a:c834 with SMTP id 5b1f17b1804b1-48379bf4788mr174371155e9.34.1771325941059;
        Tue, 17 Feb 2026 02:59:01 -0800 (PST)
Received: from 127.mynet ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48370a78c89sm327759395e9.5.2026.02.17.02.59.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Feb 2026 02:59:00 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	axboe@kernel.dk,
	netdev@vger.kernel.org
Subject: [PATCH review-only 1/4] io_uring/zcrx: fully clean area on error in io_import_umem()
Date: Tue, 17 Feb 2026 10:58:52 +0000
Message-ID: <5e051e3a62449d30264dd1000bbfc429727bfc7d.1771325198.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1771325198.git.asml.silence@gmail.com>
References: <cover.1771325198.git.asml.silence@gmail.com>
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
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12278-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,kernel.dk,vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	RCPT_COUNT_THREE(0.00)[4];
	PRECEDENCE_BULK(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TO_DN_NONE(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	TAGGED_RCPT(0.00)[io-uring];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	FROM_HAS_DN(0.00)[]
X-Rspamd-Queue-Id: 65DA014B140
X-Rspamd-Action: no action

When accounting fails, io_import_umem() sets the page array, etc. and
returns an error expecting that the error handling code will take care
of the rest. To make the next patch simpler, only return a fully
initialised areas from the function.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/zcrx.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index 60e12eb5d4f3..117d578224f5 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -207,22 +207,26 @@ static int io_import_umem(struct io_zcrx_ifq *ifq,
 	ret = sg_alloc_table_from_pages(&mem->page_sg_table, pages, nr_pages,
 					0, (unsigned long)nr_pages << PAGE_SHIFT,
 					GFP_KERNEL_ACCOUNT);
-	if (ret) {
-		unpin_user_pages(pages, nr_pages);
-		kvfree(pages);
-		return ret;
-	}
+	if (ret)
+		goto out_err;
 
 	mem->account_pages = io_count_account_pages(pages, nr_pages);
 	ret = io_account_mem(ifq->user, ifq->mm_account, mem->account_pages);
-	if (ret < 0)
+	if (ret < 0) {
 		mem->account_pages = 0;
+		goto out_err;
+	}
 
 	mem->sgt = &mem->page_sg_table;
 	mem->pages = pages;
 	mem->nr_folios = nr_pages;
 	mem->size = area_reg->len;
 	return ret;
+out_err:
+	sg_free_table(&mem->page_sg_table);
+	unpin_user_pages(pages, nr_pages);
+	kvfree(pages);
+	return ret;
 }
 
 static void io_release_area_mem(struct io_zcrx_mem *mem)
-- 
2.52.0


