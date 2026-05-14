Return-Path: <io-uring+bounces-13344-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id mHFdKmP4BWqcdwIAu9opvQ
	(envelope-from <io-uring+bounces-13344-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 14 May 2026 18:29:23 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 613B8544AF6
	for <lists+io-uring@lfdr.de>; Thu, 14 May 2026 18:29:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id E10DE306989A
	for <lists+io-uring@lfdr.de>; Thu, 14 May 2026 16:27:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3D5733C182;
	Thu, 14 May 2026 16:27:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PbMmIqS5"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56C72336895
	for <io-uring@vger.kernel.org>; Thu, 14 May 2026 16:27:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778776029; cv=none; b=DinqjXguJcicFpcKMwB17Uv0x9idNeXJMpnmzcwmsuzRK9CQZ2S2P2OjICwCXP9XlQvX5Tzt0Nqz+lYmdohaa97IFOUn5i/AJEw807f+IlOM0qQ7yA+lpB+DD0E/Cv8SWqD/Id5f76Z2qnwWWVvCw8on2UgYwp6VA7EntUOu5VY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778776029; c=relaxed/simple;
	bh=fYYVa+CTc0H9gx/EShHu4VE2g/FEgpjn7B9YQk+aZ2A=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=NjFhYOQW3SzIj0bncvXA1qR0PidbTuZe5em0hsS448Zb9F1/CK7nV1MeFdn0ES0z0OX26bbaOnB3veO2p4dcM58YVpL4Ly8eOYmscdibYM2Ntmx9TXXyLlsEf9HlstBuhAsdPxza0yRijoqeNwpinRF53GaKtxwQIJ7yi+P7bpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PbMmIqS5; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-48fde648a71so277145e9.0
        for <io-uring@vger.kernel.org>; Thu, 14 May 2026 09:27:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778776026; x=1779380826; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=7xCvdVuwj9xwDOSWQkVIKNDZKoTDKXaANCEj2TPDPJE=;
        b=PbMmIqS5+Q31jIY/se80bRoyVuB0Cp9hNG/6Y/sVGf7mVQmr4qEt+XwSoF2mAYnAXk
         NndCo+t0Ow6XEOxwVTb5CaN40wyROyZcfGUPT3uMveQf/whgw31jc15JajGZxp3cLyz8
         tMZ0iDLHcg4Lvj4P/OPhzMtc3bHcqKa+RbfRqnGgMctJY6YsSNX2VzmzA9tSO4RWtX1u
         Y2w7I4n3LK9f706LM+O3SbAn6fqeP+g6j4e1H0JBAUSWl8qlysKN4tigLtuOdDQ23+mf
         FPlr2H4VYFxdEF/m61f9msFh6Ov3LtLCiwYlo+eyKJZMYM+Uz1BKXpxP2/0O9ggH88MH
         Z8bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778776026; x=1779380826;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7xCvdVuwj9xwDOSWQkVIKNDZKoTDKXaANCEj2TPDPJE=;
        b=S7KP4z1Jx0gwDaIHEbU+d+6gcycWqFxqzkcDevSrQJC+9/F2uGUYVamoEH4eA8O2ix
         60VH9BapgBNUUE895+zSn90NSZeM2RDkgX7xCvDb9y9JgrrSQsfWyrkK1sQnWSyJpxJs
         DjjNEcnZ0jXr3ls7lV8I+YbaL5BZi4Op5TN45QUse+d0TtQUUCd/DMCVBze4fTAWcm3E
         Xtvc7FPKk+0kL0uJ0EvdRfRIzK/exJS2Hf/lWz+5UtMi5BylScEp5Lkr4uwn4wjanfn6
         F4Yu8qpt3ygJTTlmHrAkJhUps4ZgLCtfXsv5t56IRn4+tk19ai5nGz8rHO5kzUayTMtm
         k7jw==
X-Gm-Message-State: AOJu0YyfWVC/OF/Jv1BuMmzc1uUz/yW6q7snUpaDDXffLsT5smJoF8hm
	nvy/YjV9j1Rr662PAi52Qxafsqov1hMv1pPg/T4YrjQClJ/taUzgWFXc4tByNA==
X-Gm-Gg: Acq92OElX8n9SSAyIy603vQCFPJsNnwdzZ7WQfz37JtycZHhz9D3CVVNkIOGHk6yxa2
	m2GOWtdxhTm08O/+r8QP4Jku83P/yZDv7gdsx0fb8kGEa7BvrWwbQyK40livxvAPQSJBJoe5Nbm
	VEL/9UKJ7bM2kxe4tzbuf3ReYpASW07odz2vnsDiAwsU8wXLwnvqF4LddJXW29t5fDfOTJwgCIu
	UlqGzdTsUFRzcXgU0K7OHb0AbwlQDQNAe4fPySjSLWtKtjERC1HVMfqTx4ZX3pPuExRHR52waY9
	Fj+XDqzufs7BKPmOiTdueGvNEdF3hR/B59v4UEkdtqVrD1WzAg/75/7opV5328rbdiRLeKrGxP2
	UOPc5HLMqICI+eNy1LUrsmkpiCco62EgNYjzbkex8aVXk43MhbF7S6XpYLYVpcjq84RNWefi0r0
	06waJ59JBBdr8B4jfLpX0QycXRlZpe6zOM/gnG7DuV0xaRLtRAY/u3vhABQXdxlxYxiisXzGEX4
	V/BIW92s1I4JSG1Nd8ml3MFNJnYWw==
X-Received: by 2002:a05:600c:a09:b0:485:3cef:d6ea with SMTP id 5b1f17b1804b1-48fe539198fmr3035395e9.13.1778776026125;
        Thu, 14 May 2026 09:27:06 -0700 (PDT)
Received: from 127.mynet ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48fe5376812sm2938205e9.11.2026.05.14.09.27.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 May 2026 09:27:05 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH liburing 1/1] tests: test abnormal zcrx removal
Date: Thu, 14 May 2026 17:26:58 +0100
Message-ID: <fe6674d9768120da6054f1ec1057ec3db3c45454.1778775953.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 613B8544AF6
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[gmail.com:+];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13344-lists,io-uring=lfdr.de];
	FREEMAIL_CC(0.00)[gmail.com];
	RCPT_COUNT_TWO(0.00)[2];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Action: no action

Add some tests for dropping zcrx while there are zcrx recv requests in
different states. It intends to check that zcrx is not leaked and killed
in the right way.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 test/zcrx.c | 96 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 96 insertions(+)

diff --git a/test/zcrx.c b/test/zcrx.c
index e4d2213e..0f91e36f 100644
--- a/test/zcrx.c
+++ b/test/zcrx.c
@@ -895,6 +895,88 @@ static int test_recv(void)
 	return 0;
 }
 
+static int test_abnormal_exit(bool iowq, bool pin_zcrx)
+{
+	struct io_uring_sqe *sqe;
+	struct io_uring ring;
+	struct zcrx_reg reg;
+	char buf[16] = {};
+	char *refill_queue_ptr;
+	int ret, fds[2];
+	int box_fd = -1;
+
+	ret = t_create_ring(16, &ring, RING_FLAGS);
+	if (ret != T_SETUP_OK) {
+		fprintf(stderr, "ring create failed: %d\n", ret);
+		return -1;
+	}
+
+	default_reg(&reg, 0);
+	refill_queue_ptr = (char *)(uintptr_t)reg.rq_region.user_addr;
+	memset(refill_queue_ptr, 0, get_rq_size(0));
+
+	ret = io_uring_register_ifq(&ring, &reg.zcrx);
+	if (ret) {
+		fprintf(stderr, "Can't register zcrx %i\n", ret);
+		return ret;
+	}
+
+	ret = t_create_socket_pair(fds, true);
+	if (ret) {
+		fprintf(stderr, "t_create_socket_pair failed: %d\n", ret);
+		return ret;
+	}
+
+	if (pin_zcrx) {
+		struct zcrx_ctrl export_ctrl = {
+			.zcrx_id = reg.zcrx.zcrx_id,
+			.op = ZCRX_CTRL_EXPORT,
+		};
+
+		ret = t_zcrx_ctrl(&ring, &export_ctrl);
+		box_fd = export_ctrl.zc_export.zcrx_fd;
+		if (ret < 0) {
+			fprintf(stderr, "Export failed %i %i\n", ret, box_fd);
+			return ret;
+		}
+	}
+
+	if (!iowq) {
+		sqe = io_uring_get_sqe(&ring);
+		test_io_uring_prep_zcrx(sqe, fds[0], reg.zcrx.zcrx_id);
+		ret = io_uring_submit(&ring);
+		if (ret != 1)
+			t_error(1, ret, "zcrx submit fail\n");
+
+		/* try to queue a task_work for the rx request */
+		ret = send(fds[1], buf, sizeof(buf), 0);
+		if (ret <= 0)
+			t_error(1, ret, "Send failed\n");
+		/* unregister zcrx with inflight request */
+	} else {
+		ret = send(fds[1], buf, sizeof(buf), 0);
+		if (ret <= 0)
+			t_error(1, ret, "Send failed\n");
+
+		sqe = io_uring_get_sqe(&ring);
+		test_io_uring_prep_zcrx(sqe, fds[0], reg.zcrx.zcrx_id);
+		sqe->flags |= IOSQE_ASYNC;
+		ret = io_uring_submit(&ring);
+		if (ret != 1)
+			t_error(1, ret, "zcrx submit fail\n");
+		/* unregister zcrx while io-wq processes a request */
+	}
+
+	io_uring_queue_exit(&ring);
+	/* give it time to exit before shutting the socket */
+	usleep(300);
+	close(fds[0]);
+	close(fds[1]);
+	if (box_fd != -1)
+		close(box_fd);
+	return 0;
+}
+
 static int flush_invalid(struct t_executor *ctx, struct io_uring_zcrx_rqe *rqes,
 			 unsigned nr)
 {
@@ -1023,6 +1105,7 @@ static int test_area_ro(void)
 static int run_tests(void)
 {
 	int ret;
+	int i;
 
 	ret = test_register_basic();
 	if (ret == -EPERM) {
@@ -1118,6 +1201,19 @@ static int run_tests(void)
 		return T_EXIT_FAIL;
 	}
 
+	for (i = 0; i < 4; i++) {
+		bool iowq = i & 1;
+		bool pin_zcrx = i & 2;
+
+		if (pin_zcrx && !(query.register_flags & ZCRX_REG_IMPORT))
+			continue;
+		ret = test_abnormal_exit(iowq, pin_zcrx);
+		if (ret) {
+			fprintf(stderr, "test_abnormal_exit(%i, %i) %i\n", iowq, pin_zcrx, ret);
+			return T_EXIT_FAIL;
+		}
+	}
+
 	return T_EXIT_PASS;
 }
 
-- 
2.53.0


