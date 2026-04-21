Return-Path: <io-uring+bounces-13083-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id OGqzBMiC52k+9gEAu9opvQ
	(envelope-from <io-uring+bounces-13083-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 21 Apr 2026 15:59:36 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id EFEC143BAC9
	for <lists+io-uring@lfdr.de>; Tue, 21 Apr 2026 15:59:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id DCDF8301976E
	for <lists+io-uring@lfdr.de>; Tue, 21 Apr 2026 13:56:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 864D93D668C;
	Tue, 21 Apr 2026 13:56:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="zFT+GPmM"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f46.google.com (mail-oa1-f46.google.com [209.85.160.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 364E23BAD99
	for <io-uring@vger.kernel.org>; Tue, 21 Apr 2026 13:56:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776779797; cv=none; b=GNU5ijLsGI/JvnvB2i5HNA4IDbQ0P/SrOM9V+ZLOGawK2eL25Ghl3mZn5zv5Dbyh9gWt4GjBS8Yc5Jg2GAk07AHZCobzED/VbjPF3hvhH/8KmgjMWsgmZaDv6cxQTciIOjNX1uDRC6FqK/jpbUZo8RbahAYuJU9Zn5bbNzYX5Q8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776779797; c=relaxed/simple;
	bh=Y05G3Xw7f/cPhop1KBDFxsU+2FTVPPCVrJGBRqkN89o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jE5N5VwcND6sgA9NUZCxoLX2KCDn9TJYnRzvnw4SNYtZWvDvO023X7ix42/7Gdra0IFg4c19qipID5SOiMwyfQTMBR3ydBnWNLU2dmBpcYDrb0tuwiFtEmcXb45UhgwlwPVYSktCLV48PwyUzVxt2yOPQcxSxUm1o+XIDULr3LU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=zFT+GPmM; arc=none smtp.client-ip=209.85.160.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f46.google.com with SMTP id 586e51a60fabf-4230a00de40so4095867fac.1
        for <io-uring@vger.kernel.org>; Tue, 21 Apr 2026 06:56:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1776779795; x=1777384595; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+Q732lPAO4SYcUR1HDdQbRZy4v8r3zDftqlANb0Jr8U=;
        b=zFT+GPmM+2sp+GDTUXs3zVpfSxNVQ3/746xqt0+FmYyiOFOakAqKcOsBv1rYwFnfYh
         NH7whUF3Z9mj24Cdq2C1eNNRtiaBiMf8ARMmGX+MRODS+00PsTjhL5jluL/youcBJBLm
         SPXT+1EVgL7pa8v4XIPWmO2ADRyo8eis9R6xDY/RdVnlULCj/7zsvv2T4vCi6uB9N34W
         rPZUpLGmn/xZnBOqE/e6xBb45uyNLNmlsyJUZDfHp8aMadGgDzJBnJNg1DVREb+OKukT
         ioKayyb8Ay4/QrF7zR9S9Fia8xVPms73EFcnVzPiJZLcGUF/l2mx1OMxjWLqY4NkFkIA
         V1JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776779795; x=1777384595;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=+Q732lPAO4SYcUR1HDdQbRZy4v8r3zDftqlANb0Jr8U=;
        b=S0ttZH6yqOqt2q0ehRayiKH8pCLHRx0fW1oWNWVFE6Z1KCyXi9yTLdJ3MNavB6gM0E
         ZBxGmxBRh6W99I51zEBFsuKJOWQQs6iwXlHF2jr9Xf5peTvEgvwCv1sOrFIxbgHDVI+G
         CUiUE37ZBeIHV83myT95H0vDEzJ4ZpMCJ2S8Y6EMMVA1AYwyJGrbMG+ShIPAvzXmLrCs
         wwhaG6uhuak5fvRJHfl220KvnXFU7HrING2GwgzBO1jXIn5hmmj9Fmlg1e8NzwyOkSuV
         QhRzpkvnQREVq996AUAHI8QsEm83ukwI+zrSqfxoZwLf61qQ/S9M7KuHajNFhd9nAg0t
         JkwQ==
X-Gm-Message-State: AOJu0YyExNjH8M9phdkMtRSnCw7ta+buTG86TB1Ib2IrQ364WDHTPSlQ
	HgMQKPjPTvjoi+3WYQXqrKocZbnnshOVdav6nYlv5CTYeTVgbeU3AwVjQOQxrrfN8vNn0QVec9c
	Qi7+bAC8=
X-Gm-Gg: AeBDietXW6Emu/oUfivQr4DdlkTHie+FxMLG0tOA1drVg0IHkU55CutEpUBJTNKi1CH
	LVCgPFsq7Wy87tslPo8LS20m+Dcz/YAEkmhSIBc4p8wngpt0InpuR6VrTm4OUk0dVrLehNtpQFU
	4XXbPbLevw/5rjjgZvI6T77faenWtLiRiQ3bZc0iafs/MbjKDGYWhZnUy2e+DV51a5Te+jbOgi5
	QrOKkYbnmBkCjQFrqalhY8cQtZWMZvHS1AFSG2JQ/XZ5ip8+QN99mkzsQTkP/hQLJtpXaelrtGF
	qcxR393WFnNxJDDEYpb6aP5G88PWTGOIRTAkT2Re8PhoSkeGJqnlaxElA/ZXlgSI0PmePPs6Tld
	fvCBLEjZ4ZKsVWTHvzvxfwIGJDAy/uvti8owHBR2MRqxohUrye5m0QA7hE/H7xmNTttYnxlgFGZ
	y8iSgfIFnZS1WmnAf2VikJ5QxNU1+twTelpgssTDwIfqrDch2S92S32di6xs1/qLI0AEevvP57j
	bt5gj0=
X-Received: by 2002:a05:6870:6111:b0:41c:686c:322b with SMTP id 586e51a60fabf-42a9986b8e5mr9302766fac.9.1776779794861;
        Tue, 21 Apr 2026 06:56:34 -0700 (PDT)
Received: from m2max ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-42b8fe2c52bsm11756474fac.0.2026.04.21.06.56.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Apr 2026 06:56:33 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5/6] io_uring/futex: ensure partial wakes are appropriately dequeued
Date: Tue, 21 Apr 2026 07:51:42 -0600
Message-ID: <20260421135626.581917-6-axboe@kernel.dk>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260421135626.581917-1-axboe@kernel.dk>
References: <20260421135626.581917-1-axboe@kernel.dk>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCPT_COUNT_TWO(0.00)[2];
	RCVD_TLS_LAST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13083-lists,io-uring=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_COUNT_FIVE(0.00)[5];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	TAGGED_RCPT(0.00)[io-uring];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,kernel.dk:mid,kernel.dk:email]
X-Rspamd-Queue-Id: EFEC143BAC9
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

If a FUTEX_WAITV vectored operation is only partially woken, we
should call __futex_wake_mark() on the queue to account for that.
If not, then a later wakeup will wake the same entry, rather than
the next one in line.

Fixes: 8f350194d5cfd ("io_uring: add support for vectored futex waits")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/futex.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/io_uring/futex.c b/io_uring/futex.c
index fd503c24b428..9cc1788ef4c6 100644
--- a/io_uring/futex.c
+++ b/io_uring/futex.c
@@ -159,8 +159,10 @@ static void io_futex_wakev_fn(struct wake_q_head *wake_q, struct futex_q *q)
 	struct io_kiocb *req = q->wake_data;
 	struct io_futexv_data *ifd = req->async_data;
 
-	if (!io_futexv_claim(ifd))
+	if (!io_futexv_claim(ifd)) {
+		__futex_wake_mark(q);
 		return;
+	}
 	if (unlikely(!__futex_wake_mark(q)))
 		return;
 
-- 
2.53.0


