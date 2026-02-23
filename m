Return-Path: <io-uring+bounces-12374-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id eDtHLfdfnGnpFQQAu9opvQ
	(envelope-from <io-uring+bounces-12374-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 23 Feb 2026 15:11:03 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 6DCBF177CAB
	for <lists+io-uring@lfdr.de>; Mon, 23 Feb 2026 15:11:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id A1C54302F7F2
	for <lists+io-uring@lfdr.de>; Mon, 23 Feb 2026 14:10:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03740281358;
	Mon, 23 Feb 2026 14:10:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dLgUv58n"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7CD6280CD2
	for <io-uring@vger.kernel.org>; Mon, 23 Feb 2026 14:10:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771855853; cv=none; b=D5PmAcpNP7QlI3bO8fsO6pQMJo4FKwt3zowEQOozeRaCTd6p2UDZTjO3ch2tWaiJwQR+pYvfkewuN/jUVm5G5QVPR+und61bvNXdLqHzajnK4JOBef71L7EcpN01ZhxjcoVHlbSbFnT433nTColMZK+4x+/PfCp5HJieqEPJIkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771855853; c=relaxed/simple;
	bh=GmM0gwjP8emtGhqZB3WjZ23JIZS6tYHfWWkTP4JxzXM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tzsprSeXA/uy9wOK1dl9LKmDq19uItWBWLwJtGg1M+yCWB5lHFb2u8LrEvpL/uwdMIWcGqxqq5HCDZcSNiDgjHIZVb5KPdj5Y3XHx65smIHHOd/gGBOpemdHoO7u+3a0RPD9aV2tEsA7s1Yv0+cM78Dc7n4vMLQ6Lvrba3HSDLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dLgUv58n; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-4362d4050c1so4628797f8f.2
        for <io-uring@vger.kernel.org>; Mon, 23 Feb 2026 06:10:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771855851; x=1772460651; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=G6Bwp0Tecxg67yxK3DKEdNEg3+pqu/PuVYfYSL9GDIA=;
        b=dLgUv58n1ub86vSa2WSh7dPPzs8MuECFQ/VAqu+EEVE7S4u9GTi/kDsoTF7aPTvo1j
         JfjmQjYH2c9Uw9H9hCLhGq1TU7L7Qqk2Aur7kLHoVKJSUkssfu3a6yIXpv9qLtAOvWfy
         p5H1tFQxa0rv0h5ZwU1ACBZ0SX8eG7ErG8CoXSIc8L3mcKivK/n1ywLJp2M+4tk7RGFv
         oUdmvEmamZ65IfWA6AcB2lzNMB2YXWsG/82qBVL2fvmqUXa1xPVuw9KEaKQ/51c7dkir
         xAzZDS0jHSpC2/VC6qWvCwD62FpQ18u0ZJw1S1uej63NyJlfVEd1cyXZtGL5gaqBOaSx
         bKhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771855851; x=1772460651;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=G6Bwp0Tecxg67yxK3DKEdNEg3+pqu/PuVYfYSL9GDIA=;
        b=Fmf4UT1nZc9vck8lvEWkHLf9RUssNLfYjuOae8LvD96zRONc8io+Tf0U/2kWxTtPvK
         P/QA6Z3/XQ9Ih5Sdb3Fn8jeTW31A3/XUauS6PX3tz+I9JKaa2Tm/ot4dUK7BDmmGOXrT
         Ltu1u7gA/Bl8rulu3Us2h8fRUjV1U/K7TuWe2nbBMOpNWDsQrAWX1sVgHIM+gdgMDRmm
         n62ATrT7uPbteDFr/mDsIthYXfk8TArg6Zq3r/Js/wWgwb5ZsKQPFDjazo6kp6N56J0X
         j0tVTAmRiuOP6caJz/fIpeGDLkEjGuuRft0zWCP9DUtmGEuqHEiEe1eH7AE8UcPHbtZs
         l18w==
X-Gm-Message-State: AOJu0YxXz8B6sryKNYsmc/mbq/1JTejxHm7DFqRhJ8slmCL74fZVVzY/
	GjHedhPmAW1FpleqVykqY+1LYNqpeVoYSKH00r9OIxyBATLXO1iBzX9lDcPpeA==
X-Gm-Gg: ATEYQzz8NI1Z+JYAnG3E9zaiFb5q2M4JUB13vg5ACV8UbK/V1vgWMNbKE4ZhznjHic4
	LKxHuFDeYSkjd72AnuydlZUN9FewGJZB3EtsYMcIuwW/Oam/Rdp+2zzKD1vS4o4lWlIUEbvwreB
	sCgCbjZfLR2XJRubCvxO/4UpDcG9MJI3azB7ddcrbiuDwF13f9GeP/nbUdI2RIvwZXffIjOpMZc
	L/VUrvTTb11MPhek0daRsJ3jxxlZBUQVlUsPzqJ77R2IR94ZIGOw1yE27mTzPVHwvWWG+s7vyaC
	73bFDx8BfETE5pk/o3/k8PqqetVbS7pGBIA4/VxZyL10VW4SicY2xUIiA7mutelBVSOK/SWm/IO
	wud4E5rnLrd6FC2FBTRPc6UZZyr0XTgx1VPh6hca9CCNTTDCLoe1jq7DD55bD2skRZawNbyRLBe
	1OiMdeh714PG9SOZVEfVubbUEGvJS2C5a7di4U3vNO6CVtR3VX7EJKNwalrsy627WbEMBBaAyKd
	G/GJv0inA==
X-Received: by 2002:a05:6000:2483:b0:436:684:b94a with SMTP id ffacd0b85a97d-4396f154ceamr15154135f8f.4.1771855850694;
        Mon, 23 Feb 2026 06:10:50 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::1:36ea])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43970bf9feasm19464640f8f.6.2026.02.23.06.10.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Feb 2026 06:10:49 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	bpf@vger.kernel.org,
	axboe@kernel.dk,
	Alexei Starovoitov <alexei.starovoitov@gmail.com>
Subject: [PATCH v9 07/10] io_uring/mini_liburing: add io_uring_register()
Date: Mon, 23 Feb 2026 14:10:18 +0000
Message-ID: <a03081e83292f7ce106613be2bcefba385881b4d.1771855761.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1771855760.git.asml.silence@gmail.com>
References: <cover.1771855760.git.asml.silence@gmail.com>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12374-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[gmail.com,vger.kernel.org,kernel.dk];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_COUNT_FIVE(0.00)[5];
	DKIM_TRACE(0.00)[gmail.com:+];
	TAGGED_RCPT(0.00)[io-uring];
	RCPT_COUNT_FIVE(0.00)[5];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 6DCBF177CAB
X-Rspamd-Action: no action

Add a helper for io_uring registration syscall, which will later be used
for region creation. Keep it generic, it's good enough for now. Later it
can be turned into a separate region API, but I'd rather have liburing
introducing it first and copy from there, than the other way around.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 tools/include/io_uring/mini_liburing.h | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/tools/include/io_uring/mini_liburing.h b/tools/include/io_uring/mini_liburing.h
index 81513b82433a..ee75cfc24d84 100644
--- a/tools/include/io_uring/mini_liburing.h
+++ b/tools/include/io_uring/mini_liburing.h
@@ -70,6 +70,15 @@ struct io_uring {
 #define write_barrier()	__sync_synchronize()
 #endif
 
+static inline int io_uring_register(unsigned int fd, unsigned int opcode,
+				    const void *arg, unsigned int nr_args)
+{
+	int ret;
+
+	ret = syscall(__NR_io_uring_register, fd, opcode, arg, nr_args);
+	return (ret < 0) ? -errno : ret;
+}
+
 static inline int io_uring_mmap(int fd, struct io_uring_params *p,
 				struct io_uring_sq *sq, struct io_uring_cq *cq)
 {
@@ -280,11 +289,8 @@ static inline int io_uring_register_buffers(struct io_uring *ring,
 					    const struct iovec *iovecs,
 					    unsigned int nr_iovecs)
 {
-	int ret;
-
-	ret = syscall(__NR_io_uring_register, ring->ring_fd,
-		      IORING_REGISTER_BUFFERS, iovecs, nr_iovecs);
-	return (ret < 0) ? -errno : ret;
+	return io_uring_register(ring->ring_fd, IORING_REGISTER_BUFFERS,
+				 iovecs, nr_iovecs);
 }
 
 static inline void io_uring_prep_send(struct io_uring_sqe *sqe, int sockfd,
-- 
2.53.0


