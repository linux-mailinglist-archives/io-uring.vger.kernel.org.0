Return-Path: <io-uring+bounces-12398-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WGRKA+/NnWn4SAQAu9opvQ
	(envelope-from <io-uring+bounces-12398-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 24 Feb 2026 17:12:31 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 584B51899D6
	for <lists+io-uring@lfdr.de>; Tue, 24 Feb 2026 17:12:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id E786F30177B7
	for <lists+io-uring@lfdr.de>; Tue, 24 Feb 2026 16:12:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D02D239567;
	Tue, 24 Feb 2026 16:12:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dTKdg9gQ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B4623A7836
	for <io-uring@vger.kernel.org>; Tue, 24 Feb 2026 16:12:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771949542; cv=none; b=IzGG/Ulw7Tv8K/hmll0heF8QW2447O7qzKWjHlnSZNrwhLQJUPWHwr0h4O64wtRYK+Emhqf33ck/381rdaDKpM7+BR1a3q/GBCkxc8TZcmoc0oYkKYZkgX5CNBNRKPHz7Xzlzu9u+ly04Eynkgd9bsMBxlzCFF7YhmP3VeYV6S4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771949542; c=relaxed/simple;
	bh=4XKXxlRK6ddZhGjVEmdepXvUMOcu9djBXPl3KUIY8ig=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XW7nhAwxFg7LDt3R0Ys5bc6Y/AzzvQwatrALT37s0WqSeds9MbxHOc15NmA6QORYxb5SZoq1awALwQiRwMtmLjn1NapUGV0Qn0Bgt7Fog/MXemuDu+DORERp35ruMAbBrmRcDwOU3O4wI9U3f1Rj1bj3HlHrdKS8YIkpUBURRfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dTKdg9gQ; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-48374014a77so59471545e9.3
        for <io-uring@vger.kernel.org>; Tue, 24 Feb 2026 08:12:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771949539; x=1772554339; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Hvx+GQ2tKX2peAf2bH3zYcWtLT/8YuDxqS3RJE6EcIc=;
        b=dTKdg9gQ8E4qy0UZ0Nwt/wolMyRAaYd9gxIHYdShaoP2NcrhXAynPYezq7/evaGbgv
         yqKs4YnWBowa+HLcW/ZwC0TPr0w+wx9kT0gneucbXZvwrRsX/BIJpohnjPFcREuuzUOZ
         UTo2uCGF7Wdt++qPMQQus1PLbZ+5mFNU/zxzaOh6CiKt4osa9cRoQwebKPIJOLdom8Kz
         IJhpVJgd0hhS9GArs3B1doUgacvEXVRspss9GvnUcsbAResXbgY+xRJa2qG85e6UPrlB
         DvMGTy1xOuQGZB9ApnjO3jBegeYTWP97TgJtLnPn3qgBljbeWoIE0LQZp5ktIiEpbVuW
         mA7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771949539; x=1772554339;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Hvx+GQ2tKX2peAf2bH3zYcWtLT/8YuDxqS3RJE6EcIc=;
        b=v5zMjXRtHaQSZILa23CAPd1AM/w0LZNp92j4vG4DrjP1MrRTkUeyjzqbFUTFvDSSkE
         kCyIxg0I+Msz06pmmDLeFd9UinUtJOOW1X7a5F6zIn+LMDSc62CNC5/yPmD3Ua5A0FoG
         B3LqNGl3SlyOqV3mSqEZUCZQGigQ09UKspFV6XI33yIbmmIH/XMMja7NikeGcb2A/cL2
         WVpwuA/EWOFYkearPnMch2ChFNhguOJRO5YLEo/cUWLvYhbO1I5J+VRauNo6xNmDnxdy
         1TfoCCSk7/DetQJizkxP8GXp5Zq54BDM4pRpOwnKUq3RYFP/4Tmgt3u/l/oJ0ta1vyKC
         7UcA==
X-Gm-Message-State: AOJu0YwIlfApVdHnSFEFMTb7z1W/K9wtotv1lESULUMwaXg8/GtqZT1w
	ldpbC96bVAgo2aSKcZmHRreo3TmjDERkIeTALfIso955i/dyrVJeaLaKrYIvuw==
X-Gm-Gg: AZuq6aJgIGLgowr+5pJwlQaSj6mDhFuZ6NfJXT+kVhMjdVhJgG9meH5w2IJyc+dc6EP
	Um9OgE31wL6nW1sKuwuPBQgRyqZ2O31zZgHolj/oNvbMeTNfnaHP7VVzx2O8HLSa/FoSiX+m2Zf
	bi7u1KPhCuVeIsXZuEmiFLDWEQ6HhWu3mXMyj31fpAWjNQVGRSdOwX5vLDvFdIGTBOBOK8XW1Ip
	GYhO3bWGwffkSq09xRBboam0veaTiaJLgczfB53cLCGAzxdnPCkU7KNtuNirfXfj9N4D0fP0ye3
	Ujlxu8KL9+o4PCODM3Uk+8BK/e13unR/1SYNIgj0h8vBAha2BcT5nJPr8cb1SFjeWDMDr5L/Q+k
	2eVf67xp5BzpGiHhBEAIuuLTsyZ4/Pu6xNYW2Ly3hlagpYm9TAxfxuldtaW7BUyd6xw/W6yx+Se
	E1vvQ83DTjT24u51fDzrFdqH/Kph+ndHVHZOqy1DV+mwORwWvlP6EbznmlRCVNSez2gtnovS2SC
	MFwTj1JrPUUlRypip5yUZBNWLrJUw==
X-Received: by 2002:a05:600c:609b:b0:483:7eea:b172 with SMTP id 5b1f17b1804b1-483a95e9a11mr193823645e9.23.1771949538822;
        Tue, 24 Feb 2026 08:12:18 -0800 (PST)
Received: from 127.mynet ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43987f3ed03sm6292977f8f.16.2026.02.24.08.12.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Feb 2026 08:12:18 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	axboe@kernel.dk
Subject: [PATCH 1/2] io_uring/timeout: READ_ONCE sqe->addr
Date: Tue, 24 Feb 2026 16:12:10 +0000
Message-ID: <8deca9c11a924888d317b4666c93c6ed2e719cee.1771949518.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1771949518.git.asml.silence@gmail.com>
References: <cover.1771949518.git.asml.silence@gmail.com>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[gmail.com:+];
	TAGGED_FROM(0.00)[bounces-12398-lists,io-uring=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,kernel.dk];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 584B51899D6
X-Rspamd-Action: no action

We should use READ_ONCE when reading from a SQE, make sure timeout gets
a stable timespec address.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/timeout.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/timeout.c b/io_uring/timeout.c
index 84dda24f3eb2..d97f67d85ea3 100644
--- a/io_uring/timeout.c
+++ b/io_uring/timeout.c
@@ -557,7 +557,7 @@ static int __io_timeout_prep(struct io_kiocb *req,
 	data->req = req;
 	data->flags = flags;
 
-	if (get_timespec64(&data->ts, u64_to_user_ptr(sqe->addr)))
+	if (get_timespec64(&data->ts, u64_to_user_ptr(READ_ONCE(sqe->addr))))
 		return -EFAULT;
 
 	if (data->ts.tv_sec < 0 || data->ts.tv_nsec < 0)
-- 
2.53.0


