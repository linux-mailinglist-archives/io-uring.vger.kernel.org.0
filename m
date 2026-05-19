Return-Path: <io-uring+bounces-13427-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0EcjKTxODGqxeQUAu9opvQ
	(envelope-from <io-uring+bounces-13427-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 19 May 2026 13:49:16 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 0873757E00C
	for <lists+io-uring@lfdr.de>; Tue, 19 May 2026 13:49:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id CE6A630B62D2
	for <lists+io-uring@lfdr.de>; Tue, 19 May 2026 11:44:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 60C2E4ADD9B;
	Tue, 19 May 2026 11:44:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="T2P5/vW4"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55EEB45BD6F
	for <io-uring@vger.kernel.org>; Tue, 19 May 2026 11:44:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779191089; cv=none; b=IN4FgLRBKOEAaWZY/O+chLQyC+lpe89toCdwKkmqbCxa9gdcQjirzuLrfDCDyU1BEDTz4s4rh8+xQkUdkRA9KZVDeq9Sw2ekX1J20/1cI0P7jt4Vo6Vt9FjekmzB5s8t3I+ytTuFa9cAH5z1PNPY6Q8GlsPL/+ziw5MC34mrBhg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779191089; c=relaxed/simple;
	bh=nrbYpBy868OO21naSXq+nQrVgcpPLfu559sT9xboaIU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ctBgL0K+idHxIrx7Ci0Ow9O5FZDUpccVoTSRgds8JD34CkoLbSoN7xHmGUmu00RkZ/cVYBMRlCfZ/xDi3GTtO6Q+qGRN3g+hAgpwXDY+XmxOfvfq6s/QFd2r5/HhYFtZATTvLn8iuvqOaHd9sqC6NXKI/CDsNDjdDYVTnrr23P0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=T2P5/vW4; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4891e5b9c1fso29250375e9.2
        for <io-uring@vger.kernel.org>; Tue, 19 May 2026 04:44:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779191085; x=1779795885; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FqqYqVafM0zolYsrVGJ5kVgLp6hSHmtv8+xcU2f3T4k=;
        b=T2P5/vW4CNRNkdbJ561HoBqtlwh2mIv8TvOeIBlprvLwXSOBP0hMItu9kVIidoIm0S
         E8hj9jKqt9jdE8tIljjCe33RhiJfPkHGhWXhJue+LPt1I2Pld3et64lPX+7fOZict/DR
         kUdMnJKrbqyqeLGgjlFlOpEFoJCwie+e7+r8ljnJgj6MKJ6ExL2bZvhpcpZapnG3NKe2
         AvVWuciCfAS0nRaVep02jrAJWQdNP2Au0MWOvrI2ZPJzUE6Maj+h7Ilz1YOFT4w9p52l
         wnu3zJrhnMfpSXkAZR3t3fJNmZK32Yck5WsBkIQmHbz++nMrhIcE/+9+MFidriZrNHm9
         jhBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779191085; x=1779795885;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=FqqYqVafM0zolYsrVGJ5kVgLp6hSHmtv8+xcU2f3T4k=;
        b=dqQaq4ZQjwmCeAgJ9N+LjVtKwCEBXDDW4W8IOyZZ3EqTrsrv5sJPfHRI5jCcQMxmYL
         7ePmfhX7Q1QilSupN5jPXuJEmtfAAsHQaRwhpv2F1+bS2LVDLwOpuKOPoKtHvDhqeZ1P
         kQp2xndVd17edBjMdUlZ5D2pUgMBUs9WbqVWM22WgHGE0oLNSSr5e6ptjT5lS/aA5zwA
         az0fMSDyzkVHhE83L1qhQVL64tvH68QiBW5r5LXMhC6pEsn9mq2M8RrkDWx2qK0i2wUj
         SjCsbdqcquGIvNMQTx5XO1aQkXDdeZFcUCGi5TRJ85pUsJfPMOFyZSA2ECksPGQL4sqe
         Zq7Q==
X-Gm-Message-State: AOJu0YxOSAyjmSBLn/ci10CZdpSSFg2LgroJNTg7vrzxBVtBnjccg4Vb
	EvtKBE/huFS2L4XoAod16TcnT9vgatDjWaNaQAcJTn+St1W4/2oXgHoOtPOBOw==
X-Gm-Gg: Acq92OESwRbwMGP9b1P/h/om/IjGIp91BY2wc6tiBuq/275yWoohZrYSWQ8WSwmTFKN
	ehVMw3e369IAM83q5XK5mvmLCrLyE8K1nroN07m8TruZppk1DWlCsK8yLUIM1bLa3uw+32uG6YB
	qNPNEIFHBjysGBwKLka2eJhfI1uDZ0gVKnc3pd8XpkKvGt1uBGy4a9WdfwDB5Os0sX2BtsXMT4h
	mpeRDlSn22QTVpUrREJTh0mYwoGOggEWehdbxIg31MU3xiYhyRkapJIJv9BSPlMPO45JKcNFPSH
	ukAwOsRCyXMF/96pJqbyZ5pxiUFDSJPKiRTVjZr8rk6MZBTToFdPabv6HrN/zhTbKAZe2FDttB4
	Kp5QZXhFKC7ydZV19Pv/j+Kg4ghcU33N4p5SQ5AA9RLD5uZsxdYbiNB6N9yLsL2Cos9qPSxfhpJ
	Q+3TDrb8wbAMCqUyDtMaHgf3VJHbinPKuRJg6JcQJhWzsZXePlPpzbOGLxfk3g47B9zqrgzhKMu
	HNoR5jKb3EZ0EWbL49Pafw44evtog==
X-Received: by 2002:a05:600c:a406:b0:48a:599a:3716 with SMTP id 5b1f17b1804b1-48fe651487emr233632465e9.23.1779191085040;
        Tue, 19 May 2026 04:44:45 -0700 (PDT)
Received: from 127.mynet ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48fe5694f2csm323392445e9.4.2026.05.19.04.44.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 May 2026 04:44:44 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	netdev@vger.kernel.org
Subject: [PATCH 3/8] io_uring/zcrx: remove extra ifq close
Date: Tue, 19 May 2026 12:44:29 +0100
Message-ID: <be6c4a283a5bab5440e22fbccafe7b885acb7abc.1779189667.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1779189667.git.asml.silence@gmail.com>
References: <cover.1779189667.git.asml.silence@gmail.com>
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
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13427-lists,io-uring=lfdr.de];
	FREEMAIL_CC(0.00)[gmail.com,vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	RCPT_COUNT_THREE(0.00)[3];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	FREEMAIL_FROM(0.00)[gmail.com];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Queue-Id: 0873757E00C
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

By the time io_zcrx_ifq_free() is called the interface queue should
already be closed, so io_close_queue() will be a no-op. Remove the call
and add a couple of warnings.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/zcrx.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index 4bf6635c222f..f4440881960f 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -575,7 +575,10 @@ static void io_close_queue(struct io_zcrx_ifq *ifq)
 
 static void io_zcrx_ifq_free(struct io_zcrx_ifq *ifq)
 {
-	io_close_queue(ifq);
+	if (WARN_ON_ONCE(ifq->if_rxq != -1))
+		return;
+	if (WARN_ON_ONCE(ifq->netdev != NULL))
+		return;
 
 	if (ifq->area)
 		io_zcrx_free_area(ifq, ifq->area);
-- 
2.54.0


