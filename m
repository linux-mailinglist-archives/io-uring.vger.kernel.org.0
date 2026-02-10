Return-Path: <io-uring+bounces-12125-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id OIWYJwB9imkgLAAAu9opvQ
	(envelope-from <io-uring+bounces-12125-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 10 Feb 2026 01:34:08 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E4E8115A92
	for <lists+io-uring@lfdr.de>; Tue, 10 Feb 2026 01:34:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 1ECF73049946
	for <lists+io-uring@lfdr.de>; Tue, 10 Feb 2026 00:31:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E081923507B;
	Tue, 10 Feb 2026 00:31:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EjOfdSf9"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C924B1DE3DB
	for <io-uring@vger.kernel.org>; Tue, 10 Feb 2026 00:31:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770683518; cv=none; b=PNtfFEjrjN5je4zY+p5d7iIDwos/utzuldGeLHL90QleGDrwekaS5Wm/5B/psoNb0VmliSC17x/JeuImVyiZlm/UPPvY+Fj68DSAElCw4fKMtJ34kIX6ME7ob3HbIbl2yCMK5guesZ9Jf8swF3AgCHFdRBLdeuratiwFadPadX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770683518; c=relaxed/simple;
	bh=QGNJ0nQNwT/2Xhj5X47IZwQEmRNeo0omf8RhJnDgWj4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dI8sM24VW4JRKvFfjHaUp3C8Y6o8M8us1lvQUbKqS1VPBTCEaTmmj3btU/uWmSVdoPpQIMRzRthhyvuqmoeDbTp33Xujl4aecvM1hfORMKAkMje8XBBKEtAdtv+V5ymL49gjtyXwnsy4gInxbiJS2HzVhItJG18IoamLTy62GZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EjOfdSf9; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2aad9b03745so9703325ad.0
        for <io-uring@vger.kernel.org>; Mon, 09 Feb 2026 16:31:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770683517; x=1771288317; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FxTLhehX+HeveXFCHQu2LEA+jkrjd1h7v3RTfPHoVvg=;
        b=EjOfdSf9yJXp7SLGfU7rW1lzrpB5q8iMsRYbAROKATCNHN/IseKYJIgXI8iUIwTwkl
         joFTm1yzdf1i/4YnzfHPQ4M9Zt4YwmxsXAulR29NQiiBZL2IcVtpR0sa/0uqqwo3wQEC
         mopMP2Nn2Bn1JvfMtaOhDiApSntmRTCI42o17pGW32BnLQCqa4y1KhcUQV9zX0sxBhjt
         nG30CNqErVSwanrUeuTO11uEKtFcs047FAO51jp726KP/s4rONLtHBFnBYEMs0cyFcp9
         axyYFd2OscnrYePuE8yH1WNiSqV0SAIc7ELmh+SbDirR2HL9eI5qp0Va0sxvGOjAc9tw
         FYSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770683517; x=1771288317;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=FxTLhehX+HeveXFCHQu2LEA+jkrjd1h7v3RTfPHoVvg=;
        b=rOnwY4HW14VCHMv8pvRT+H+eieLzVW0brh0RO8MRsCO5lg6VUz1qSFXApZKUPHSrhG
         a3pvqM9eKSpz+12Xqtz8xgZOW/0SsZHVLMvbsUvUj8Za/99cCeMkQoYhXfkvP70VJ8GF
         IV5A3SbTvyzU3sV4vwlP/vsYMB80T9klzQz4eFfNNn6wThaemL1/ZWKBdyWJK0tCoJ/0
         q6qeeGTqXlApdlV0D+8dBnJBvoHzbV/xfuexEL0k1O+CF+mDgFb6qlGosFuVpZxn4HlQ
         9hpE7qxieYHlu3oQbll61Du8YCqj8iGi9QyJlQEFAwlE27UUY1kLU6m/PRlyDg4Tv7AM
         kBdw==
X-Forwarded-Encrypted: i=1; AJvYcCUTgvTUZ4dn9j7rx03KuRzlQefySiaLOL3GjYBtVtSC/KsylhxiSznfHxT/sJRjTpNNb7tRxSX/JA==@vger.kernel.org
X-Gm-Message-State: AOJu0YwYZ8nCRmAeAnQeYTTT8zoC18Zuy+jm4mOYXKnL4WXVm20ddFD9
	uWhrArShagCAnE+EVdy6+ATBN0A0s78yuyJhAxQS+lg9I2xmBjAPv+xE
X-Gm-Gg: AZuq6aL5GZI0iqcRswdiKfWSYfNYckbrOhX9W6HYXEF4yQSfUiUiWogqrMy+ANBP6Gd
	QB2kcGEkSppLjP+x/vF1Y1k+wPU+87HxZX2ehmXvpXPeSNmFzHOPbxPDudxVgh+gw/BU2MPN08t
	IH4obCtqs16S/uZHTh5mkjrmZO3jhyQfhIajDMYiyXWN7spfHVqeXl9hbXn/LJfNQr2raiJLIC1
	PR4S1r1P4iQBsjOTapsbQIwVcca1OHKQfgKi6xKC7hyTSs+L2U0i3JTl4bPT0Fj4CU6RS9+uMSh
	NIBNtXDF1VF3GJEK6kMY+GZNEPW/fQb79W6bQ4QuWszNvC1yCwd36OunkPHfjc6f8yHqGfN1HBW
	kqZjvNbW9K1tEnYtern5vPkIHPFsrb1WzjQh3gpzbe/zKKaMOm3/cB7K2Pcya1Riy2TAeD1A3MM
	l5kqK7NtwwNRjQ6YURMg==
X-Received: by 2002:a17:902:db10:b0:2a7:80bf:3125 with SMTP id d9443c01a7336-2ab100a36b6mr4925465ad.13.1770683517125;
        Mon, 09 Feb 2026 16:31:57 -0800 (PST)
Received: from localhost ([2a03:2880:ff:1d::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a95dce24f0sm101233175ad.32.2026.02.09.16.31.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Feb 2026 16:31:56 -0800 (PST)
From: Joanne Koong <joannelkoong@gmail.com>
To: axboe@kernel.dk,
	io-uring@vger.kernel.org
Cc: csander@purestorage.com,
	krisman@suse.de,
	bernd@bsbernd.com,
	hch@infradead.org,
	asml.silence@gmail.com,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH v1 11/11] io_uring/cmd: set selected buffer index in __io_uring_cmd_done()
Date: Mon,  9 Feb 2026 16:28:52 -0800
Message-ID: <20260210002852.1394504-12-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260210002852.1394504-1-joannelkoong@gmail.com>
References: <20260210002852.1394504-1-joannelkoong@gmail.com>
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
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[purestorage.com,suse.de,bsbernd.com,infradead.org,gmail.com,vger.kernel.org];
	RCVD_TLS_LAST(0.00)[];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12125-lists,io-uring=lfdr.de];
	DKIM_TRACE(0.00)[gmail.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	FREEMAIL_FROM(0.00)[gmail.com];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[joannelkoong@gmail.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	RCPT_COUNT_SEVEN(0.00)[8];
	TO_DN_NONE(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 0E4E8115A92
X-Rspamd-Action: no action

When uring_cmd operations select a buffer, the completion queue entry
should indicate which buffer was selected.

Set IORING_CQE_F_BUFFER on the completed entry and encode the buffer
index if a buffer was selected.

This will be needed for fuse, which needs to relay to userspace which
selected buffer contains the data.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 io_uring/uring_cmd.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index ee7b49f47cb5..6d38df1a812d 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -151,6 +151,7 @@ void __io_uring_cmd_done(struct io_uring_cmd *ioucmd, s32 ret, u64 res2,
 		       unsigned issue_flags, bool is_cqe32)
 {
 	struct io_kiocb *req = cmd_to_io_kiocb(ioucmd);
+	u32 cflags = 0;
 
 	if (WARN_ON_ONCE(req->flags & REQ_F_APOLL_MULTISHOT))
 		return;
@@ -160,7 +161,10 @@ void __io_uring_cmd_done(struct io_uring_cmd *ioucmd, s32 ret, u64 res2,
 	if (ret < 0)
 		req_set_fail(req);
 
-	io_req_set_res(req, ret, 0);
+	if (req->flags & (REQ_F_BUFFER_SELECTED | REQ_F_BUFFER_RING))
+		cflags |= IORING_CQE_F_BUFFER |
+			(req->buf_index << IORING_CQE_BUFFER_SHIFT);
+	io_req_set_res(req, ret, cflags);
 	if (is_cqe32) {
 		if (req->ctx->flags & IORING_SETUP_CQE_MIXED)
 			req->cqe.flags |= IORING_CQE_F_32;
-- 
2.47.3


