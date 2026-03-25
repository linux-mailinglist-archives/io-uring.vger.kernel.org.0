Return-Path: <io-uring+bounces-12854-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IIEqAvLlw2lvugQAu9opvQ
	(envelope-from <io-uring+bounces-12854-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 25 Mar 2026 14:41:06 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 0CFF4325F8C
	for <lists+io-uring@lfdr.de>; Wed, 25 Mar 2026 14:41:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 502E33004435
	for <lists+io-uring@lfdr.de>; Wed, 25 Mar 2026 13:09:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0A413D8115;
	Wed, 25 Mar 2026 13:09:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ey/htoSD"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E0833D8119
	for <io-uring@vger.kernel.org>; Wed, 25 Mar 2026 13:09:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774444160; cv=none; b=VeKIPvSBJMj0r7NElzr9y7djvHcpfy9KL3r7Ruz2gCZ/cAF4sLJIVW5jluRU5cEy3AmlDvY2wu2DkR1V8jc+KqJBeQjIFDKK+gA4oJbl2LHyvFTAp/0vCR5CfOcqwovD1sx3uOm7NWj5dXXAI6Wi/0ZGiEtHMYZ7+UhfIIPgYbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774444160; c=relaxed/simple;
	bh=8dcACiXoZPc7rI6bRDNFxNEVa6WUQdrHX1lzl6WzD+A=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=lokfB7mJGUqFwqDE5Olky+6fAzGG0fexKjLO1RsWh+Q6ctCOdxYJvOUH7FOnspxyfQvulUPGCCE8DLLev8nkhM7TPKTLWJFljYZ7rKnItfiQT3MFGphhEi+w9UVu2xeT3MYbKVjGbFv/rKIXkd54xY0K+BA6TEjrHHcF6/v6wKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ey/htoSD; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-439bc14dcf4so700455f8f.1
        for <io-uring@vger.kernel.org>; Wed, 25 Mar 2026 06:09:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774444157; x=1775048957; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=+tK8GZ6vdDAcYV6J0Km1TLOUN9CYUfFL+0DfUE0nS4c=;
        b=Ey/htoSDwgxsvvkCg725sp131aXX8mE72+xF2UMDgmY6Zy1yQRIpigpyMtSGH4CQDK
         gVmuc7uhKQwvVaceJr+4ciq/rpdj4+w4bYiFdea8Ng9WG+DiT05eWuY2fryXo5r0Cw5o
         A0r8qJRCzIU0jTAmly1ZpK8RGoCnI3mGPVZa6IoRKeyc5E4u1jmjLjqr7fBZVskSm5rp
         tb5zC8Nva7xmLQgNKbt9uFPLOfbYCP1L4aRcChrOdPzWGBQDu/GaXrmV0CtJubHyeQw8
         +JJBXo6tyaNTf3EOekSFh/SQYbTO4O1MnpYbuf+yEEqHfpUj7eO3RvA4qlz+2r3Uphoh
         rWKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774444157; x=1775048957;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+tK8GZ6vdDAcYV6J0Km1TLOUN9CYUfFL+0DfUE0nS4c=;
        b=Fqd3ca1yfMb63uixZAqMZaXLTKi1jiqK97YyhMlrs4KIR0W40Ul3WX8sTgAwtQuPt6
         OdjmQE6wHtbaEXUmtXd2h1HINFJK4k6E5aihdGzRnrW5zyCINe8RbdNIwfQILlp+r/B5
         hsBFeZ0Uhn0ylYGqO64U7XYxggItVQcwz0x/i6wWH35IaR8H6ncJTHYVr9+LXC/JoRUy
         IxUNIQ6uDkGKyUiWer2BDwi6xiMCrZPqQPdYn9gvFL4atLAA0/SDcJWFdi53qNfz/OG4
         FDexgoP/7BwoMkVdqr1mu7DZyXiTYrjd34jz4Z8V93wCUuA87m3wQAHeaz7NlWgl4FuI
         tErA==
X-Gm-Message-State: AOJu0YwKLT++Jd5niF8CsIVG1sLqSFJDx7fh6w8sPjIKF45hH4wJlhul
	PqNER4TwitpMY+ObNIdJMh2lGcGNAUjF44Y14Jh/ZeiKBDN7I1ebbWBKpPJA0w==
X-Gm-Gg: ATEYQzwkODxXhJ8fXQS7DhudQgmVJ54E+IM1mFbG3qHj/wODl8OrD9HxVpgXowsWWAZ
	NXQOZ+yMsSaq+eiiHGvtvw6skd84AYpdtiskkMOvy8eWqDIHt+M6sDlXy7yjr9BRQKfkmDVrho0
	3svQbr0OueB489EvjHfPQjVxs/FUs4sSEHkh9OPJWvwEtok77HketEjW/LOJcSLPp2FNrJT2S1p
	G++N9fYxNSAiV+vvfUw9PZOInL42r9AK8SrfVNoHFA/e47RAcNnWM0ugXm58zAE3114EBgfXU1W
	zU1FphoZrScz5Fve5DH8FDXgR9Md8sbdzVRZ7Ptf8wbi9TAwnqM3B3lPLLv3lsq+kvMek8sygsn
	qgkvy0XPpG8a4N1ZWPhSpMlEuHcCG22ZLGot0IPJra5LdkNmyQYFaBzAjvpydY3ibWiU5rwe6P1
	R1a5CS+3lVp3KdxRKaFC91SNknxj846GEqP+v1FZm7VPFp4SMjqeEPYFFKyODAv8nB+GV09wBic
	S51TQNuSA==
X-Received: by 2002:a05:6000:2004:b0:43b:548b:e7c9 with SMTP id ffacd0b85a97d-43b8837864amr6104017f8f.7.1774444157308;
        Wed, 25 Mar 2026 06:09:17 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:8126])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43b644bd923sm54062611f8f.12.2026.03.25.06.09.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Mar 2026 06:09:16 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	axboe@kernel.dk,
	netdev@vger.kernel.org
Subject: [PATCH io_uring-7.1 v2 0/5] follow up zcrx fixes
Date: Wed, 25 Mar 2026 13:09:17 +0000
Message-ID: <cover.1774444007.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.53.0
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
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[gmail.com:+];
	TAGGED_FROM(0.00)[bounces-12854-lists,io-uring=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 0CFF4325F8C
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Follow up fixes for the recent update flagged by review.

v2: reject REG_NODEV + ->rx_buf_size

Pavel Begunkov (5):
  io_uring/zcrx: reject REG_NODEV with large rx_buf_size
  io_uring/zcrx: don't use mark0 for allocating xarray
  io_uring/zcrx: don't clear not allocated niovs
  io_uring/zcrx: use dma_len for chunk size calculation
  io_uring/zcrx: use correct mmap off constants

 io_uring/zcrx.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

-- 
2.53.0


