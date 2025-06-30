Return-Path: <io-uring+bounces-8520-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 49DD0AEE3A0
	for <lists+io-uring@lfdr.de>; Mon, 30 Jun 2025 18:10:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DA2B0176968
	for <lists+io-uring@lfdr.de>; Mon, 30 Jun 2025 16:10:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DCA63292B2B;
	Mon, 30 Jun 2025 16:07:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GjeMrjoJ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5519C292906
	for <io-uring@vger.kernel.org>; Mon, 30 Jun 2025 16:07:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751299671; cv=none; b=NUS0hzC2HWdbeBXhaTl4aW7xlE9CT98DKyNg3LSpM9QW9Yxl2gzXWyBPkUU0A/FBY0LploCIdX1c2jiVVWLsdl4BwXg0ktxciXOPbYh4p+PzOtvvRJewR643kuHd8BxBpE9xvF9Um91RlSRDYlsIrF/z0CJ/I6/vJOJKO47WEu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751299671; c=relaxed/simple;
	bh=jAwMbpmnJhTBb5AOocOHMiEmXgVt3xEHqp1O+zu2aAE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qz2lBN/6SFIPVXQDENMrv3NKTdMUjgYJFGr+yj7kGDcVeoSIITaKOTj5SuFkWjTOGepVglumPm5qPx3gtdiH81M+kl1Vix7OYp5daTaJ490mKQyu5GSZRmrErrs2vLOv6GAhT0SleKqsnp5c2nhSbkvwtFzeXoLF3T1NS9FLcKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GjeMrjoJ; arc=none smtp.client-ip=209.85.215.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-b31e0ead80eso4097240a12.0
        for <io-uring@vger.kernel.org>; Mon, 30 Jun 2025 09:07:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751299669; x=1751904469; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OvkliDsW1PFgDSFmU5IBIY3ABVglLSbFpnuOzp0vuKg=;
        b=GjeMrjoJlfFmIpaopawTLvCwltAvkhOq29p7pgZdK6NvI1XLdCzoXXS0MbeFwCxSvA
         8oDOirsNTkRfE91dGIjp1veKXvWPISYuSthdgtiR3OL4VydBtS9G6w8L+8ao/Aj/FYjk
         gku92qnmuJYn8TRZIL75z9UwnkY1MFKmvEsmaloBcKXIWKDowEUh/u1Kf6zHz5WlQ/wV
         Fz+SfPuIWpXId+t3Jk0WK8NV6YySVkDPMzxY9BkV00XrTZEw8JvuarA/0IKPkqNXmqtJ
         bDVFK5KQMTV6fkFgcVPbUzLWORlpsj2OrWu45GbabwKwCpmxjoTXGWSSngurTQFDWrvJ
         SmKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751299669; x=1751904469;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OvkliDsW1PFgDSFmU5IBIY3ABVglLSbFpnuOzp0vuKg=;
        b=XK8nGMblpStTHznlyyrYD8S0Aj+JqDBqJppobUMZApesHL0P6BDtpkUJd7SA/4gmj7
         BO75mc4ldgGdC1CHo3ZNZd663GUwjfUKNHSHIaXzsg6/ocX9LwIGsf3Z+aeMTVLKqzu+
         w4icFuiMIpGyfAX/y97s15LBuhnMxpTzmydtRP3NIpz1cMcFy/89Whkfo1JaqwJ1feen
         wGgSfybeUr8nPrJ35210yhu5+nM/4S6cbLtD5WEGerPZqPq4TokqMQ7mhBkLFnbt4tJT
         PFAtclcgKsdg8ZdBtcOM9heqwixT8ywXDFSVkaZ+fSB+Be+UcJCdTx3Qv1PzC9SGHvoj
         QW8A==
X-Gm-Message-State: AOJu0YxL5p15Eh8tdNSyViBif4H8uwR4oQLRQGN8Ksf+Wv9cZmjAuwzm
	5a77Pt5veCbD4BlBIUu/y+BPcvKvKEGca7bhg4j6oIbuoebcFIvKsjU1XAneLaIe
X-Gm-Gg: ASbGncveSgCpGsd/wANtUeUoZmc4QsPyl/95BvuFtZ1JxkwIWle63TVM4DrfZLD5lia
	8ayr1C+K3NdapSWn/Rb7lS8nZyL5uhZrLfrRhBzpJGbxFlvbktF0q/gh5HCmBeV6JOhWmdYI4l8
	vfwnkDXUcOO9FXsjCBNNH8DLKkoLhfGNkO+DpuHv+RDpQ+v9SZDBi4RTUVKWgq845fHcdyjksDY
	klwytwkLoVzy+qA83ua+LWXAo8i+r8yY2b1jZC5LggicvWqBlJVVgKOQbM43h8/a2X2EirQN7Jr
	plbE3/N1JjOryAWLlIOZukZhOTb7cdbw94oVuAWBJQsdeqvVbeBuOvUT
X-Google-Smtp-Source: AGHT+IHz6ESLN1rsnfnA+3mqwwI7B814IEL6sK00bxjtdQQXuPX8u+u64/HgSl9mAS9hC68gBlQ7Qw==
X-Received: by 2002:a05:6a20:729f:b0:21f:751a:dd41 with SMTP id adf61e73a8af0-220a17feb0amr21631000637.40.1751299669251;
        Mon, 30 Jun 2025 09:07:49 -0700 (PDT)
Received: from 127.com ([2620:10d:c090:600::1:335c])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b34e320fc3bsm7577870a12.75.2025.06.30.09.07.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Jun 2025 09:07:48 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 1/2] Sync io_uring.h with tx timestamp api
Date: Mon, 30 Jun 2025 17:09:09 +0100
Message-ID: <52422aa12720f7e976e9fd6b32dc66b7dbdd5794.1751299730.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1751299730.git.asml.silence@gmail.com>
References: <cover.1751299730.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 src/include/liburing/io_uring.h | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/src/include/liburing/io_uring.h b/src/include/liburing/io_uring.h
index 73d29976..94de038d 100644
--- a/src/include/liburing/io_uring.h
+++ b/src/include/liburing/io_uring.h
@@ -915,6 +915,22 @@ enum io_uring_socket_op {
 	SOCKET_URING_OP_SIOCOUTQ,
 	SOCKET_URING_OP_GETSOCKOPT,
 	SOCKET_URING_OP_SETSOCKOPT,
+	SOCKET_URING_OP_TX_TIMESTAMP,
+};
+
+/*
+ * SOCKET_URING_OP_TX_TIMESTAMP definitions
+ */
+
+#define IORING_TIMESTAMP_HW_SHIFT	16
+/* The cqe->flags bit from which the timestamp type is stored */
+#define IORING_TIMESTAMP_TYPE_SHIFT	(IORING_TIMESTAMP_HW_SHIFT + 1)
+/* The cqe->flags flag signifying whether it's a hardware timestamp */
+#define IORING_CQE_F_TSTAMP_HW		((__u32)1 << IORING_TIMESTAMP_HW_SHIFT);
+
+struct io_timespec {
+	__u64		tv_sec;
+	__u64		tv_nsec;
 };
 
 /* Zero copy receive refill queue entry */
-- 
2.49.0


