Return-Path: <io-uring+bounces-12458-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GG5iK3XPoWn3wQQAu9opvQ
	(envelope-from <io-uring+bounces-12458-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 27 Feb 2026 18:08:05 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 38A641BB37F
	for <lists+io-uring@lfdr.de>; Fri, 27 Feb 2026 18:08:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id A707B30635D3
	for <lists+io-uring@lfdr.de>; Fri, 27 Feb 2026 17:07:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0F493603FE;
	Fri, 27 Feb 2026 17:07:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i4oO112w"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DE74346A06;
	Fri, 27 Feb 2026 17:07:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772212072; cv=none; b=FjaBe5U75VFOAfLOWmmnjNOeoKicypWRmCeIg1DcN68z6YHO6l6xR6qFCVDdma7v2GvAZJKN0XJWKIWhQJbwd1GaynFt+F70U6TvWGfiKHN5u2Qci/dSKjbryub5RrJBASaaHiYcMhcC1WUJu2xc+60Fyzetfq8vLKVgrSFXSwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772212072; c=relaxed/simple;
	bh=yyBoghsysskz6c1puapeOsGWqQ4Bqre1PjZevmYThTE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=pQP008U7/TKTxvI0dN7cmpV0N+EOc+kgZzF3jlvubjURaJJ38cNXLzyjgyMOKAO0CaoUuW4+jkAHvxbleGt+xVjxuwWxAgQ+BTfi6mGN9LrxmD+aCS4epvhoSBgp+GarJ1XFIMBV6tmer9rW1NSFeenoRthA8k+E8ke8JGbki7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i4oO112w; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECF0AC116C6;
	Fri, 27 Feb 2026 17:07:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772212072;
	bh=yyBoghsysskz6c1puapeOsGWqQ4Bqre1PjZevmYThTE=;
	h=From:To:Cc:Subject:Date:From;
	b=i4oO112wongsBRk88/GFqPCWDkWx0c/92Oftxux/gm4mIMKCM+hpWp8DqcTgjlqI+
	 +dQLeHMT26QM5yPUcreNNXlE0pZ1Q0vTilpvkEQvVKYqrEYpEjxtHcvSj4p+3J0xBQ
	 6FETjGDTAaHv0u4lbc+Ah2uDiQj2FaKtUlaAxHpHAWPLCehK/JKbdHwnUJiM86+Axz
	 9767ZuI4QkFgrYw/NSUdEAw2b7KnAF72neAZY2go0HqAmE7YgpjRiuZQaQc7SCUW4F
	 v6ARnE2dP5JAwv2tDeOLh9O940tmpGtylX1qlP8jZ+6OhgK3FFPI+ZYP9RUkGKNXaK
	 G4AWO1sIMWogg==
From: Jakub Kicinski <kuba@kernel.org>
To: axboe@kernel.dk
Cc: Jakub Kicinski <kuba@kernel.org>,
	asml.silence@gmail.com,
	io-uring@vger.kernel.org,
	netdev@vger.kernel.org
Subject: [PATCH iouring] io_uring/zcrx: don't set rx_page_size when not requested
Date: Fri, 27 Feb 2026 09:07:45 -0800
Message-ID: <20260227170745.2845550-1-kuba@kernel.org>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.84 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[kernel.org,gmail.com,vger.kernel.org];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-12458-lists,io-uring=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[kuba@kernel.org,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,kernel.dk:email]
X-Rspamd-Queue-Id: 38A641BB37F
X-Rspamd-Action: no action

The rx_buf_len parameter was recently added to the Rx zero-copy
implementation. The expectation is that when not set system will
maintain previous behavior and use the default buffer size (PAGE_SIZE).

This works correctly at the iouring level, but we don't preserve
the same "zero means default" semantics when registering the memory
provider on the netdev. mp_param.rx_page_size is unconditionally
set to PAGE_SIZE. This causes __net_mp_open_rxq() to check for
QCFG_RX_PAGE_SIZE support in the driver, and return -EOPNOTSUPP
for drivers that don't advertise it -- even though the user never
asked for large buffers.

Only set mp_param.rx_page_size when rx_buf_len was explicitly provided,
so that the default page size path works on all zcrx-capable drivers.
mlx5 and fbnic only support 4kB pages in the current release.

Fixes: 795663b4d160 ("io_uring/zcrx: implement large rx buffer support")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: asml.silence@gmail.com
CC: axboe@kernel.dk
CC: io-uring@vger.kernel.org
CC: netdev@vger.kernel.org
---
 io_uring/zcrx.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index 28150c6578e3..594220c8eb7e 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -833,7 +833,8 @@ int io_register_zcrx_ifq(struct io_ring_ctx *ctx,
 	if (ret)
 		goto netdev_put_unlock;
 
-	mp_param.rx_page_size = 1U << ifq->niov_shift;
+	if (reg.rx_buf_len)
+		mp_param.rx_page_size = 1U << ifq->niov_shift;
 	mp_param.mp_ops = &io_uring_pp_zc_ops;
 	mp_param.mp_priv = ifq;
 	ret = __net_mp_open_rxq(ifq->netdev, reg.if_rxq, &mp_param, NULL);
-- 
2.53.0


