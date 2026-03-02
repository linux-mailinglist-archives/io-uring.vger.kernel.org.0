Return-Path: <io-uring+bounces-12508-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id +HCbAP2fpWmuCAAAu9opvQ
	(envelope-from <io-uring+bounces-12508-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 02 Mar 2026 15:34:37 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B2691DAF11
	for <lists+io-uring@lfdr.de>; Mon, 02 Mar 2026 15:34:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 45F36306A39E
	for <lists+io-uring@lfdr.de>; Mon,  2 Mar 2026 14:32:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 21FA03FD12C;
	Mon,  2 Mar 2026 14:32:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Gda899eK"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EA983FFABF
	for <io-uring@vger.kernel.org>; Mon,  2 Mar 2026 14:32:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772461942; cv=none; b=mGM1EQBzWj99whvGXitFXzc5Zs/faFe1CgFwGi+1+mkvoxPw43xco3puAzRRGWbQXGRWQ6brHkchzhAEmFjJ9Po5EBXa9LXU9PMwLUXI0jVQ7ZTdBKi9+YlaatKFWn5AAcVvi/YtwE2RUEbr3DgiUYyZpURpDL+NSnf6pRqVpFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772461942; c=relaxed/simple;
	bh=S8CAwIGhKhy9ab3MD3VFswZiVXDBKwbdGVV6k03bZ5w=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=CLSViiHN2DivQSTIOelItVi+L0dIGftffR9AAtGMjXvlSOPKLSGsf82WRIJDt7QoElgWOd62IR2DaeQuaZ9C8QUwJhD18eTYnY5RBOoVUdqUmvodmmJ27foro91fCnjYNSi3OUdve/3ieRJIvx8011xJ6BPGggV7VQD6JBtIYoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Gda899eK; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-439b611274bso766112f8f.3
        for <io-uring@vger.kernel.org>; Mon, 02 Mar 2026 06:32:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772461935; x=1773066735; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=n36hlSuZIvYDjFjhEvPh0ctroqGoxpwSfwMGHLXB+F4=;
        b=Gda899eKjosprgxrLX5Eq4+CmAA/kMuDfP6DBykWIYxFGg/mUJ83J3sLaTMmFXIYfU
         H3/xzJr+sAC57GNq5IGwkcyOz1FjD6EeXMbcRcfESeeK0f70d+NqojzhybrZrOpIX4/R
         ivXFFyGxSMO0O2abxdjfBNt2suF9hD361NGwudX/Yz5hvz9nMrKLe2TWtMQbfrWRaG6c
         qnQxwCxYmo2orIip9hQVgY9akwU03q3w3jbBcYLN46b90cBoPYxdcj6Ibkc1XLY+CRfq
         1L3O8GjNl+5Qh+1opvTDBbKeDcPvKsrF4M9PA0EIrpuiDMjRmbqIjCis/b3n0+tCHQzs
         ER3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772461935; x=1773066735;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=n36hlSuZIvYDjFjhEvPh0ctroqGoxpwSfwMGHLXB+F4=;
        b=cM68+J62US2Ecgt7EM4V6KRh8+3xammoxOPaQgPMAU7VA222uGaKF9um6St9212gh7
         cUh9rFra415CejyqpHoLVYjIuRqzDgh9E2zJu7plzT37IFsxAXpR1XiXbnB9b6schwAg
         xtDolAb69qGNTJM7e9wHA0xr4D5+eyMG8vSRbTFYyUJInM7LtW6/duSVLBYAVBOT5vBQ
         bvX2oQU8DhD8PT8++mQtHTcb/KxUnwfdmvtnb3eEO3qsDNihNDkWdA9/zrxR0Xsb4JDA
         46hqAQBzc1Amiz7lvRTlDfwsLPeVEHLKFhZKvYbDmHBG88NMtd0XOHASE8oeuSnuDMlJ
         X3Jw==
X-Gm-Message-State: AOJu0YyCL5Lmk3oyV+UvsVBUtrizDwovHIXxviYrB/x604vi2jC2mtJm
	2e3xJIbUWyVCkYsxaOkUYLQOJ2SzCdGE8PIGhv1z2OLLQBYxKia5IBFs6i6H0g==
X-Gm-Gg: ATEYQzyJmwRKyUJ5vU506bf5Oo+t/CIvIqWEvpEK2zrA1d3IpgKyTb5WXhe5rlzkgGx
	yhEqhA75qreWlieg3wjqqhbq14tgM3MgrTyM2/u991hQqng2xKs2sonUiXwBnpLazDYfxZ6cBa4
	H/vE9wSyY2fs10ZU32tcBOGg97GL4oV1A6Rbec34qzSufGzxQHG3JHO5GLJ6ILgBAFG/rbLGGy+
	DfNdK39WrstxLtTVb0nYo1rF5rM7dPse1/pO+QK88fUamFTi8/8FD1adjP7ZAMma85C4vy1i/6F
	C6nvHT+0m95TqF1sPwi3VmyvcqC39O8cw7L2twdP5E/0m0HM/DUHOt5k7uTD1t/Td1MJKAyqjau
	s0l9WWmjfcUFiFMOtQCpBc50NCoZ6xIYR2p0LPC6fzlTtpZlj70e9/fF1PO2HRTITSAhIRgqBlJ
	TYd2T3KwaK+auhQCiOEMR5fnN8Z8I5Yc2ttuTMe824Zve/Bj6vX5qiJWX7SR5+Y0OExw02XmLTw
	Nzkhonjdw==
X-Received: by 2002:a05:6000:22c7:b0:436:1964:e3d with SMTP id ffacd0b85a97d-4399ddf88bbmr24402896f8f.14.1772461934988;
        Mon, 02 Mar 2026 06:32:14 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::1:cad2])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-439b59723fesm9489397f8f.38.2026.03.02.06.32.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Mar 2026 06:32:14 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	axboe@kernel.dk
Subject: [PATCH 1/1] io_uring/net: reject SEND_VECTORIZED when unsupported
Date: Mon,  2 Mar 2026 14:32:04 +0000
Message-ID: <74d3b5c7058d3acd902514e9bab060ff6f9212bd.1772461896.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 7B2691DAF11
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12508-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,kernel.dk];
	RCVD_COUNT_FIVE(0.00)[5];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	PRECEDENCE_BULK(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_NONE(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	FREEMAIL_FROM(0.00)[gmail.com];
	FROM_HAS_DN(0.00)[]
X-Rspamd-Action: no action

IORING_SEND_VECTORIZED with registered buffers is not implemented but
could be. Don't silently ignore the flag in this case but reject it with
an error. It only affects sendzc as normal sends don't support
registered buffers.

Fixes: 6f02527729bd3 ("io_uring/net: Allow to do vectorized send")
Cc: stable@vger.kernel.org
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/net.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/io_uring/net.c b/io_uring/net.c
index 7ebfd51b84de..3e6112beea88 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -375,6 +375,8 @@ static int io_send_setup(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		kmsg->msg.msg_namelen = addr_len;
 	}
 	if (sr->flags & IORING_RECVSEND_FIXED_BUF) {
+		if (sr->flags & IORING_SEND_VECTORIZED)
+			return -EINVAL;
 		req->flags |= REQ_F_IMPORT_BUFFER;
 		return 0;
 	}
-- 
2.53.0


