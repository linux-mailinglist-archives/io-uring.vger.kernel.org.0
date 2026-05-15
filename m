Return-Path: <io-uring+bounces-13345-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qAarKPD2BmpUpwIAu9opvQ
	(envelope-from <io-uring+bounces-13345-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 15 May 2026 12:35:28 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 3D05054D710
	for <lists+io-uring@lfdr.de>; Fri, 15 May 2026 12:35:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E279430063A4
	for <lists+io-uring@lfdr.de>; Fri, 15 May 2026 10:15:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88DDE3A875F;
	Fri, 15 May 2026 10:15:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="J8UV9Ngo"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88A2E394462
	for <io-uring@vger.kernel.org>; Fri, 15 May 2026 10:15:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778840143; cv=none; b=SKrk/BxaA6Y9zjhuC1RVtC+t8arZp7Q3XGd23jTywH+2h90Yd5PIC134pS7+5pByztrmdZcrkGHKAxPy4kd4uWAptro3vwO28id7Px+ec6GwtyBsl3wklVgAfTWyjsXdAFkgemQZCN4SG7rqE5nIUBjdRFAUScyRy6NFGfybEF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778840143; c=relaxed/simple;
	bh=xScMA0q0NXIapHwlKcSS3Y72Zx9bmpHDZ+6dlPoEHbs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Gyk+iYFNyTl7Jtgut/ID/jfT4j6Eb8n7Fh33FyS/EioUa8AJxNtuq/O6CDm6QRI5CoDaJMY5mHWskDl6cLp06HJPvQ7QDqC4MMIV6m1d0PumPYmmDjnJY+bJKZXeCYxLqsKSQU7vePmLxCTldeb+ke0xURzmWgkxkpYSYDrJzAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=J8UV9Ngo; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-67929ff6dbfso3684129a12.2
        for <io-uring@vger.kernel.org>; Fri, 15 May 2026 03:15:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778840140; x=1779444940; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=r/FEyp5SppURPHvJUMmMU44Qas/FVrvUVqS3KWjciNU=;
        b=J8UV9NgoMjq8LTCiQhwFznnF5W4ETFWpAbeUC6OU+HVcQdavmvIlUqGV70ekTfUvrO
         snZ7SFsQMtA/6Wcjgfv+0Nfs/SeKzED+wkg5wKzKvQvJjILXU3PeWNX3fzz8OgtGrmQ7
         wgn7xrqiCNr1zODnp0uccbhi1DVR0/ia8pPpC6sEl/FqAE2RGWdBsax1TbsvIgMIROMO
         ngAAFRoEsAmcgICajdGEvlObuUNLhSu0/YGfP+XSMuPst66kSj2CMSBLGgTAzrlMUeH/
         MkADGkSir8jTaonQQmSwqJVA1mGm+s2Qcu/JqGh1uuqEv6O25bSIQgTB1yiwpMLn3PGW
         dRAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778840140; x=1779444940;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=r/FEyp5SppURPHvJUMmMU44Qas/FVrvUVqS3KWjciNU=;
        b=MC7u0rzo02MlRv3o86WoWMyHUZ3XLJv5iz9rT51QpIXXQDWJdUOYJg0XIjPHhST9NS
         iZusju21S8NFZgUaKycv/pSBrNeNBjfiM7eZASFV7342C6GKitJTxgzw0GSpY3qn04kN
         aosKOShD2I/aq1SS4cDaQTqsM97DkVCuhcX2urMTjbVt1HXnUc4NpG55itxOTKxMsmsn
         cAWW9sbk4LhidUkNl9+CAAi6VkxLS3vMzrshJIxS0nHOZtLRCoWPSebTtIcUF2eI4UHd
         kh7/+PdJkKXgclPWqlM71u6T36FzkzVPIA96Six+BHkXd/SUc/4aC6pY0+c9mqqHlBjo
         eqqQ==
X-Gm-Message-State: AOJu0Ywt3VCFDvTs3T8GlRDds53w4+nzbyeLYKTdP1GJl0y4U5vt3Miq
	kOWxVYuV6chnU0dCE0GfsmMz2R2+Qu3PnsKmUPq++I86WT8381Bz7GKk2UoITA==
X-Gm-Gg: Acq92OFYb4EALdqwzo/eXcS0MHJFVfZXskUyUbV9vGTjw7R62oOZTuCBU9BIw7lRGWg
	tkkTNTQdRHX88nyBDIyFXo37KZ7qAuA0rrXJPktyz4CPOkuaWG/lwqSIboZLHMw4DPp6OEOX7Ko
	Xh7myHAwtIGBCjjtYytxn9hAGa98I9PkrvVnus9OedLg31tGX03XoyjeeiC4gs7s53E8asPo/cP
	N3lgJ9rLAmqknyaSf/dtKfQZ1Yk7EDA0TA5+2ImivMOE1HzW4vMc2FZCvzXn4cOIjB2eeM9hXx8
	7HfTk66Y12oK8tcdkz+u/5rF7+/RI25tvohD5gPm/TeLwaRYCcVh2aFkvl1MFqvI/8pVuB88ipZ
	MBioyVrkJiVhtajQ/ze2HwYn9YKoCw82seXcb0iDhBnpCEJOxiYK8U0qnBsUy14qbjav1UvGACH
	Oqre4jWo1sYfLWFGBnm4bVnYi34i2U1Fn60/j28b2Q9doOzAwcoJsF0wuKe//up3kPNeeNDWKue
	eNtBIKP2g==
X-Received: by 2002:a05:6402:6d3:b0:677:75e5:a1b3 with SMTP id 4fb4d7f45d1cf-683bd488932mr1162865a12.18.1778840139449;
        Fri, 15 May 2026 03:15:39 -0700 (PDT)
Received: from 127.net ([2620:10d:c092:600::1:5f66])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-68310b3e6d1sm1784719a12.5.2026.05.15.03.15.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 May 2026 03:15:38 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH liburing 1/1] tests: improve zcrx ro params testing
Date: Fri, 15 May 2026 11:15:17 +0100
Message-ID: <c633c9e2c3cc7a0a07bd9765f86f54b7cc90d876.1778840077.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 3D05054D710
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13345-lists,io-uring=lfdr.de];
	FREEMAIL_CC(0.00)[gmail.com];
	RCVD_COUNT_FIVE(0.00)[5];
	RCPT_COUNT_TWO(0.00)[2];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[gmail.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	PRECEDENCE_BULK(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_NONE(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	FREEMAIL_FROM(0.00)[gmail.com];
	FROM_HAS_DN(0.00)[]
X-Rspamd-Action: no action

Test clean up on failed copy_to_user for export does the right thing.
For that I put parameters in read-only memory, it's a second place doing
that, so also consolidate it for convinience.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 test/zcrx.c | 60 ++++++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 46 insertions(+), 14 deletions(-)

diff --git a/test/zcrx.c b/test/zcrx.c
index 0f91e36f..27ddaac4 100644
--- a/test/zcrx.c
+++ b/test/zcrx.c
@@ -27,6 +27,7 @@
 #define RQ_ENTRIES_SMALL	16
 #define AREA_SZ			(4096 * 132)
 #define HUGEPAGE_AREA_SZ	(16 << 20)
+
 #define T_ALIGN_UP(v, align) (((v) + (align) - 1) & ~((align) - 1))
 
 struct zcrx_reg {
@@ -49,12 +50,33 @@ static long page_size;
 static void *def_rq_mem;
 static void *def_area_mem;
 static void *def_hugepage_area_mem;
+static void *ro_param_mem;
+static size_t ro_param_mem_size;
 
 enum {
 	CONFIG_HUGEPAGE		= 1 << 0,
 	CONFIG_SMALL_RQ		= 1 << 1,
 };
 
+static void *write_ro_params(void *src, size_t bytes)
+{
+	int ret;
+
+	if (bytes > ro_param_mem_size)
+		t_error(0, 1, "write_to_ro: too large");
+	ret = mprotect(ro_param_mem, ro_param_mem_size, PROT_READ | PROT_WRITE);
+	if (ret)
+		t_error(0, errno, "mprotect failed");
+
+	memcpy(ro_param_mem, src, bytes);
+
+	ret = mprotect(ro_param_mem, ro_param_mem_size, PROT_READ);
+	if (ret)
+		t_error(0, errno, "mprotect read failed");
+
+	return ro_param_mem;
+}
+
 static struct io_uring_cqe *submit_and_wait_one(struct io_uring *ring)
 {
 	struct io_uring_cqe *cqe;
@@ -370,27 +392,17 @@ static int test_area(void)
 
 static int test_ro_params(void)
 {
-	size_t size = T_ALIGN_UP(sizeof (struct zcrx_reg), page_size);
-	struct zcrx_reg *reg;
-	void *mem;
+	struct zcrx_reg __reg, *reg;
 	int ret;
 
-	mem = mmap(NULL, size, PROT_READ | PROT_WRITE,
-			MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
-	if (mem == MAP_FAILED)
-		t_error(0, 1, "Can't allocate buffer");
-
-	reg = mem;
-	default_reg(reg, 0);
-	mprotect(mem, size, PROT_READ);
+	default_reg(&__reg, 0);
+	reg = write_ro_params(&__reg, sizeof(__reg));
 
 	ret = try_register_zcrx(&reg->zcrx);
 	if (ret != -EFAULT) {
 		fprintf(stderr, "registered unaligned area ptr\n");
 		return ret;
 	}
-
-	munmap(mem, size);
 	return 0;
 }
 
@@ -698,7 +710,7 @@ static int test_zcrx_invalid_clone(void)
 {
 	struct io_uring_zcrx_ifq_reg import;
 	struct io_uring r1, r2;
-	struct zcrx_ctrl ctrl;
+	struct zcrx_ctrl ctrl, *pctrl;
 	struct zcrx_reg reg;
 	unsigned box_fd;
 	int ret;
@@ -750,6 +762,18 @@ static int test_zcrx_invalid_clone(void)
 		fprintf(stderr, "Can't register zcrx\n");
 		return ret;
 	}
+
+	ctrl = (struct zcrx_ctrl) {
+		.zcrx_id = reg.zcrx.zcrx_id,
+		.op = ZCRX_CTRL_EXPORT,
+	};
+	pctrl = write_ro_params(&ctrl, sizeof(ctrl));
+	ret = t_zcrx_ctrl(&r1, pctrl);
+	if (ret == 0) {
+		fprintf(stderr, "exported with ro params\n");
+		return ret;
+	}
+
 	ctrl = (struct zcrx_ctrl) {
 		.zcrx_id = reg.zcrx.zcrx_id,
 		.op = ZCRX_CTRL_EXPORT,
@@ -1249,6 +1273,14 @@ static void setup(void)
 	if (def_area_mem == MAP_FAILED)
 		t_error(1, 0, "mmap(): refill ring");
 	madvise(def_area_mem, AREA_SZ, MADV_NOHUGEPAGE);
+
+	ro_param_mem_size = T_ALIGN_UP(4096 * 2, page_size);
+	ro_param_mem = mmap(NULL, ro_param_mem_size, PROT_READ | PROT_WRITE,
+		    MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
+	if (ro_param_mem == MAP_FAILED) {
+		fprintf(stderr, "null ro\n");
+		t_error(0, 1, "read-only mmap setup failed");
+	}
 }
 
 int main(int argc, char *argv[])
-- 
2.54.0


