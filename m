Return-Path: <io-uring+bounces-12850-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6HIML4XZw2lwuQQAu9opvQ
	(envelope-from <io-uring+bounces-12850-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 25 Mar 2026 13:48:05 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 431E232521C
	for <lists+io-uring@lfdr.de>; Wed, 25 Mar 2026 13:48:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id CE9583245CC7
	for <lists+io-uring@lfdr.de>; Wed, 25 Mar 2026 12:08:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 362A83D3CE9;
	Wed, 25 Mar 2026 12:08:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CXEOFkd0"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC74D3D3336
	for <io-uring@vger.kernel.org>; Wed, 25 Mar 2026 12:08:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774440502; cv=none; b=XBkPH7r2T9JYZ7ALweiNwgsCB9uO8oZm1VonaZM8e07q1zlQDzfTcFeTLDA+G9BAC9Z+5l4gj39dD0EiTksozwWu6TQHjwlP5h5EIR3pHkxgAxdF3lyft80kOZB0909MbfQEqV5Zh8KjVRJMMIW1UnLXa07iMdBEzhQvfBwJZ6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774440502; c=relaxed/simple;
	bh=/kN/uNIofHDrbzYJpnMhcPxipapG1wEa9AygHEJJxcc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AqvjnOjubf6IokyOaRU70A/fDDd6EqOYZq6mpiYixQ06SEkRxl5l02VoPhm7RTFwUT7Ue3mKhRXFaSZqdiZfNPXZDth5Jixkf4X0xYyLKE74tGC9p4tHN0u8VdWThLadMhkR8KPZtTQDEJORpCyjPI3R7U8x0PhLp+EPcOaq68g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CXEOFkd0; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-439d8df7620so4138035f8f.0
        for <io-uring@vger.kernel.org>; Wed, 25 Mar 2026 05:08:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774440499; x=1775045299; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PEG1hWxQAEwGv/inzSaw0nBixQ92O1cAUgSliNc3738=;
        b=CXEOFkd0BmDeWvbqplY5EP9Cj8MfiF3e8hNy19UIWu7dFnLVLU04uIxE0OXb7wYl2n
         yG2fHAGEvuNnuViM5+Sg8lvpvVal9m00IxrSOUjOVcPcIxUKj/q1e08lrEczT6kALOfG
         tUnJLUl8lh23CMM7JGqXQT+0ECqc99/A63c44+RdfDg1JhSULQSVEOUE7gbPOzoB6mKx
         M1tW5BWX9OPXcRXsBQ0h32ILdWXhJrFIbLGaaASrLs6LUIqqSRIvoC4oWrbgparOB5D5
         d5UOZB68ngpmTnSAxEjBLFj0LNN/zGXFvpkVUdurqSzMESd2ahURNiP4tF+kT1F9XD4t
         CGQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774440499; x=1775045299;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=PEG1hWxQAEwGv/inzSaw0nBixQ92O1cAUgSliNc3738=;
        b=ljMvNZG4+nZfiqhHTaB3wb20PRwLA491OOAkyG0hF9OGBg6e8STx/OMIRBKq+okDY3
         Ozp14LXWGKbTP7+GTScptaRYSfqRzxWgX2ovwdUekq4G16G6KEj9Dhe3J/B35Nljy/OV
         Wktb8mFOK+m5FfUbz8QlE08jlpLjn0egcU7LKiDpge2cnSpIvn+nzp4kfTcCLC1fA3ET
         18uLpZ3QTq1UTRMhPdw26AXlpcvAjQY+sE6S9VdWv/HH2jNpd9Ve+ji302iX9kqRXgt1
         j3cs2oUX0jonDqedLOf77KhEYzMTIFKHoa0IwDt+ZU2/WVk4f4XZ02f5fh+e5o0s26MO
         O0cw==
X-Gm-Message-State: AOJu0Ywq4zqzJ9Qjnc7XhJ4D7nTbDW6GQ6CA1YuKQkGqb+MIgkFd+cCD
	aEEks3EZHcNuuSE0HtOhwhVF3+McMX261cU3MrNHMK72F8aUblIxATczIe3THw==
X-Gm-Gg: ATEYQzwDlHO/R2mxC0uoknVw0VxBbW/k0SzqgFkh+RXW4qpl2qIlS9UNE7+009fCv/x
	MYBm8PgcAxcA/a8f5uA2rXSZyEZiiU43Rb2TWb/ghVj4k/B9W353WEyCQOYQpV6tN1Jw42wF+BK
	rxkCcD2XJPNjFr3uhEbgiWd34PRrduZOe8pFrAkSQRB5csyBHgx/J5pLDxdzlVjLoIXRmUUVwa0
	kenEyfpX3xjo49gI4W4tHfIKzmEcTU/1uON8iVz8Wu+epmOwOaMUFdMtrGz5b9dUF7xY3FJGCNx
	H6k15cRrM68sB+qB9VNBo97O6hEjviOi/Rak6T+jEGRdsAJIUXpZ3AZAY0WttdkqYvGwJQSnlOJ
	rybTv/FsmxZvzJbS9oF93xXDAxfa6r7+AJ42BrlyYceCRb+lOMAdJP1X89l9hR9Ob6xhWTreaWk
	W781ZbraWOvnxiuWGyAy+yU6eMAkr48cWQAfea3TQzmbjdBa88XC+Fcndm0qlf3SKu+V4QrMlC/
	Mqwd57xX87cMRVeq9/6
X-Received: by 2002:a05:6000:4305:b0:439:beee:43b5 with SMTP id ffacd0b85a97d-43b88989dd9mr4622333f8f.3.1774440498896;
        Wed, 25 Mar 2026 05:08:18 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:8126])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43b644ae37dsm48618289f8f.2.2026.03.25.05.08.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Mar 2026 05:08:17 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	axboe@kernel.dk,
	netdev@vger.kernel.org
Subject: [PATCH io_uring-7.1 2/4] io_uring/zcrx: don't clear not allocated niovs
Date: Wed, 25 Mar 2026 12:08:19 +0000
Message-ID: <5c21ff99757647c8e72d44714a8d9d36410bacef.1774439286.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1774439286.git.asml.silence@gmail.com>
References: <cover.1774439286.git.asml.silence@gmail.com>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[gmail.com:+];
	TAGGED_FROM(0.00)[bounces-12850-lists,io-uring=lfdr.de];
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
X-Rspamd-Queue-Id: 431E232521C
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Now that area->is_mapped is set earlier before niovs array is allocated,
io_zcrx_free_area -> io_zcrx_unmap_area in an error path can try to
clear dma addresses for unallocated niovs, fix it.

Fixes: 8c0cab0b7bf76 ("always dma map in advance")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/zcrx.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index 695398d2f2e0..fc6199edad34 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -289,8 +289,10 @@ static void io_zcrx_unmap_area(struct io_zcrx_ifq *ifq,
 		return;
 	area->is_mapped = false;
 
-	for (i = 0; i < area->nia.num_niovs; i++)
-		net_mp_niov_set_dma_addr(&area->nia.niovs[i], 0);
+	if (area->nia.niovs) {
+		for (i = 0; i < area->nia.num_niovs; i++)
+			net_mp_niov_set_dma_addr(&area->nia.niovs[i], 0);
+	}
 
 	if (area->mem.is_dmabuf) {
 		io_release_dmabuf(&area->mem);
-- 
2.53.0


