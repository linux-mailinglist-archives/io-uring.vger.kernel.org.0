Return-Path: <io-uring+bounces-12238-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kEOeM40Dk2nF0wEAu9opvQ
	(envelope-from <io-uring+bounces-12238-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 16 Feb 2026 12:46:21 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E6B821431B3
	for <lists+io-uring@lfdr.de>; Mon, 16 Feb 2026 12:46:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 4CAD03001A62
	for <lists+io-uring@lfdr.de>; Mon, 16 Feb 2026 11:46:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1996C2DB799;
	Mon, 16 Feb 2026 11:46:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CZOZoKb6"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 437873009E1
	for <io-uring@vger.kernel.org>; Mon, 16 Feb 2026 11:46:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771242374; cv=none; b=KTq7+kgvCMZ4jUOIrt4oh5dkiu+XLQwsgvOUgPc9ZBKtQChOui0OpIjIrArQalLnrFLwvSoEcD8pwuTxR476cJ7w0gNUbOfRRPlqPifuQ8FlPOWE357RISWZqesv06OwtsksCOb0GkZyAMNZZlpguLqD8BCF8o4COLtApeX6tj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771242374; c=relaxed/simple;
	bh=m7J/ZVpinojZa2+6c1QOX26TXsranBN14pauau14LfQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Da3LfHiRdXWxLZnRQGb4PJOWH8r+YpSuilRknRctN7Co5lotvIyZWA4m5+kRRsg6cuAh7dJCTHEdhPIdh5R3rZSInpe8WVh3G/bhgXINyboVXNIY1YeXRpTBlrap7wssrWisLaKuQ9RC7dFbBYasDFuTe3QSKP9GSKBD1KrUZ/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CZOZoKb6; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-4359228b7c6so2291091f8f.2
        for <io-uring@vger.kernel.org>; Mon, 16 Feb 2026 03:46:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771242370; x=1771847170; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TDJZXQwK7f4GY7+mdLBNJw5yCc2DjgqZE35NGKkgJNU=;
        b=CZOZoKb6d14LEIFrG980PkFn26htT/OmT+N8BHWcfDKgjYSBog3tPaY9hwz2Fh7FH8
         P/hf/0tY6q8vfDoS1gi68jyv9SJIHHaovj7HaXMbzMijBLQcRQm70qDeKOqa3V8ECOi7
         9LCrEW8Sk66iaHJvUFqGhdWPHL2srmHAPoaZXqBIkKWfb7JeacixC3dyl818CsOPagEK
         wNvP1d85DMlAcAY/wle7D1foSFZpsXXOw0SilCVDXnA+BGltYVUzJ2vzccqmAJnghirl
         ACDDfxry6lBx2blIb3/GhVs1W1XFomciQdvHmgE49F6fGJndqnnOvk/lit8Naylsgs6X
         QmBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771242370; x=1771847170;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=TDJZXQwK7f4GY7+mdLBNJw5yCc2DjgqZE35NGKkgJNU=;
        b=vDmmWpvYet13luEM2UjhaRujFt6fgigkHongsGZOro+qySKn1FXSxLg924WS8o1Kig
         L0QPuOWqFNcwsprasr9r2ybvOLdT11VT6kteHJZS76ItoekRDUkY1NQt5AV4dhHOwlmY
         fLZiOIjnOorq6MvIm/dNMfaufJDQr8d2kMO0tO4yGfB4rLn8z7K1v4XcM9Eudv+2wFCz
         0qGmj2yUzOYWPU+Z71KdK5zNhx1z6veKp9PyUWF7exxK5kEyGpHXeTzRBXbpWNss7yTF
         B1fsubaKUtRYEenc2QqXs3GbOtKBKczwIB2Ua6mRoC9540ta0u/b3yGzxJhfC472MQqk
         VAMQ==
X-Gm-Message-State: AOJu0YwqMqPUoUCMUob75bB1+h4Ctj86UzxmYsrCFKqFDWr42d9hr1Tb
	IC6T8EwOlYpOIXhdq0NzTUUdrhDhCCIya00A7aQi1DXKwn2vaF33tRAJLonx+Q==
X-Gm-Gg: AZuq6aIkRg7yNz2SkH9qwIpylJ/711R1ponhWaYPRarJ2vVnTL4WUOfzLR7SCVLDg65
	p+G5ftYA3DnklsaR9cjWXD6vakcKjWuS5pKAx9GvwZLRJgs0+HxTtIfY1PqlNYwoiBE4idh1SiB
	HRVWk5pknAyX2RGmseA0j/iyTCL7u4rbRffg0URIEUfq6bQJjKXd7gnzoUgbtEcjGEnlPZQ3K5R
	apPVaeYMjz5OmKZkkTZEgx1ZxE+AzKXsAmQT7neSNjeCCbU20aSn9nBL5+BFvLt7+aYsi9T9a3a
	8VuqNvI++PuQnK9hAtgCJNXHvwivS9TWblcntEbRzPTeyy8dxny8YHIOYypJb4pNQc5w1SGDbaG
	Fk4s8/+QmljKS/BBsDEmEzgYh6c/oF9D5/YAYhPPBiMA23IvaYIZvPXaaBd+eO8movbvEa2Nz6y
	ZzHfWvCMJ3ez7DPMOpP2dGBp1hgy0v7oTbjZjlSAQqVXU5Fc/7Pqjn8PcQeRXnQsLTsx9+kgTPl
	aqk+AYl
X-Received: by 2002:a05:6000:2403:b0:435:b0e7:ea1 with SMTP id ffacd0b85a97d-4379db6649cmr14306294f8f.19.1771242370125;
        Mon, 16 Feb 2026 03:46:10 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::1:c3fa])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43796a5b4cdsm28991802f8f.8.2026.02.16.03.46.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Feb 2026 03:46:09 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	axboe@kernel.dk,
	Dylan Yudaken <dyudaken@gmail.com>
Subject: [PATCH 1/3] io_uring/zctx: rename flags var for more clarity
Date: Mon, 16 Feb 2026 11:45:53 +0000
Message-ID: <14b3c62803fe22e2b29fb4fc9648fb1a08e53f72.1771240334.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1771240334.git.asml.silence@gmail.com>
References: <cover.1771240334.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,kernel.dk];
	TAGGED_FROM(0.00)[bounces-12238-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	RCPT_COUNT_THREE(0.00)[4];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: E6B821431B3
X-Rspamd-Action: no action

The name "flags" is too overloaded, so rename the variable in
io_sendmsg_zc() into msg_flags to stress that it contains MSG_*.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/net.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index 8576c6cb2236..5f7f02e2c034 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -1524,7 +1524,7 @@ int io_sendmsg_zc(struct io_kiocb *req, unsigned int issue_flags)
 	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
 	struct io_async_msghdr *kmsg = req->async_data;
 	struct socket *sock;
-	unsigned flags;
+	unsigned msg_flags;
 	int ret, min_ret = 0;
 
 	if (req->flags & REQ_F_IMPORT_BUFFER) {
@@ -1550,21 +1550,21 @@ int io_sendmsg_zc(struct io_kiocb *req, unsigned int issue_flags)
 	    (sr->flags & IORING_RECVSEND_POLL_FIRST))
 		return -EAGAIN;
 
-	flags = sr->msg_flags;
+	msg_flags = sr->msg_flags;
 	if (issue_flags & IO_URING_F_NONBLOCK)
-		flags |= MSG_DONTWAIT;
-	if (flags & MSG_WAITALL)
+		msg_flags |= MSG_DONTWAIT;
+	if (msg_flags & MSG_WAITALL)
 		min_ret = iov_iter_count(&kmsg->msg.msg_iter);
 
 	kmsg->msg.msg_control_user = sr->msg_control;
 	kmsg->msg.msg_ubuf = &io_notif_to_data(sr->notif)->uarg;
-	ret = __sys_sendmsg_sock(sock, &kmsg->msg, flags);
+	ret = __sys_sendmsg_sock(sock, &kmsg->msg, msg_flags);
 
 	if (unlikely(ret < min_ret)) {
 		if (ret == -EAGAIN && (issue_flags & IO_URING_F_NONBLOCK))
 			return -EAGAIN;
 
-		if (ret > 0 && io_net_retry(sock, flags)) {
+		if (ret > 0 && io_net_retry(sock, msg_flags)) {
 			sr->done_io += ret;
 			return -EAGAIN;
 		}
-- 
2.52.0


