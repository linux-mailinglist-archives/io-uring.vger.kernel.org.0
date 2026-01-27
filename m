Return-Path: <io-uring+bounces-11937-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id OHz8IYqReGmirAEAu9opvQ
	(envelope-from <io-uring+bounces-11937-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 27 Jan 2026 11:20:58 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id DEBCC92AB5
	for <lists+io-uring@lfdr.de>; Tue, 27 Jan 2026 11:20:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E4295317308E
	for <lists+io-uring@lfdr.de>; Tue, 27 Jan 2026 10:15:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8BCE3382EF;
	Tue, 27 Jan 2026 10:14:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FGgsJz++"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B266033C19C
	for <io-uring@vger.kernel.org>; Tue, 27 Jan 2026 10:14:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769508879; cv=none; b=KJPY66/LRc5ZrHrVnYtPuI+qCTifDd2x8X0PjdrN+l9i/eRV425Nwk2qnA91D7WjBUkPdn7iAuKboDE7YKP3mCUhaVXtpxDQX9z8yYP9hZubvQ5+CbXFjFGWmT536A+kxwuORS9ARsXeF5JJpk6vMiwgjuDSAOQ363IV05yLlOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769508879; c=relaxed/simple;
	bh=XmPry/OxPrEyMg/xg/1hD+YQK8vhAdJbzWFuLff8N8g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O3KMfNSOmO2hAX/Bnw9uQ2enFWTOtqvSUA8AJpNiS2Wb4jTrpBCOWuEwlmO3ilbSPZBAE6Frn90KKauYLrKhsiNhGB39brOofknee6Cw3XIuiIztlxtPq09sMpDhoIoQquxsGbQm+eHFSCBqlG76qKvMjrgCHpcEBKi2RXYND/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FGgsJz++; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-432d2c7dd52so5564371f8f.2
        for <io-uring@vger.kernel.org>; Tue, 27 Jan 2026 02:14:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769508876; x=1770113676; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bQZULh+1aOViUNzlyUitezWDtyBZNbRYLQVS+ZcBn2g=;
        b=FGgsJz++9U2I6V9JA8tJ3KUSIOMyO2bVx1/mYDVO4RmOliSaSjcNZxxYFbR/tL16Cg
         5o/5I5d7J3V3FjT+QbEZfTjFoq2n9RONcq2LHRxdPWBYIBQ7kn1z31rNdj9z9WubrWiD
         jfZWSncLpqy0crRMJgtR5qg58mlQ7PKC2MIvbEvSsoKaZQkQQaHPeO83l08lDo4e9jo+
         axPnESnV2nwQ8V07y8FBzPh9H3gRVmUO244ue3Z8jN2hfNUSxEB/bqoGJMM2IC5T21C1
         yCRQf78G6qTYMtlTe2LkU+qr4YqBr0W0mPT9wvbiYr3lBJg9JbKZ08+YDCsGRA029qxU
         d23A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769508876; x=1770113676;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=bQZULh+1aOViUNzlyUitezWDtyBZNbRYLQVS+ZcBn2g=;
        b=Isnim0gMHhAElPzHyMc/w6VBH2+nXlRNQsK2raSoqMoSE51uFL1UyiCkHk0J3AI5G4
         9FTE4cTjSv/YEWP8WRHSP3NAQxFLzGTp7v8A6Bf5wG8MifnCiA7iGG9eT7z9SCNRFrC4
         gMnFaqBLe+xmQ58JK8a/htcEgDWkrGIWSfP2i/Tqag/YGX+Olr4a1BLVMcCV5BXyeQnU
         0Z4cc9E87iND+l0m10ejzGPKex0GT+qykXVVolf8u72lDbFUuybouw9tQh/lGmGFaXLV
         HXb/XaP/FM+lt4C88/XXOi9brTxYmR3mozgJqBba2J6dcR6NYIB03XC8UUyUkYEf5hi7
         DRNg==
X-Gm-Message-State: AOJu0Yx7KArzIFXaP9RX/UG6tQkWB34mCaSA2doJdotXjd7qWl8RRgvZ
	gKGYZ7BAqbWQANXO27q6D+1xCArizFSyB1rYLkanN3yFOZtU4A/NOw0z5XyrDbfu
X-Gm-Gg: AZuq6aLMhjI4hCWZ69j3DCoe+/l2mAddlkYI/AYcfygBTlVOX5ro12Gep04tYjExfq7
	ltKyuxu3c3DFN3wsuQM+Di+Xi8IWDyj2mOvZNLr78xQWobZoSHRAAJHTFVVOOcEsYPy1LEKC3iT
	VfAnNTb96Rqc7Qz9bHk6kAvhl2Efyhqxw8ZiZQZgGoVAI6zthLb/sCG6N+izOFDU5puw8V4shBu
	N5LaB3nempDzCl8iorbo+UnJOXI9h++3vqCH84W+BsTXeT7lTNukEFiZDCRYXIwMBZsrgjsFaR6
	fpd5/kmXENtCqbiHCR/EocaLeRLa/sSXbFYz+53C6+EhG29Z7Yw54rrK+vgIwnSXwKYAU4qT3mX
	rQQZx53rK2lyz8phwM2YSzo8aXh2MY/zFSVfPNQ41noF8i1tSpZe9lZXLHXLajoD/lof3o9HrPw
	rWXhppsoWB5cI2f/z+cR17q3jwfe/iGyl4nFMcyPqJCp2aD2ByYGn9fUxoAi1KgUYOuKnNC+HYE
	GKGdrK097zLgWwIyA==
X-Received: by 2002:a05:6000:609:b0:435:9bf5:b32c with SMTP id ffacd0b85a97d-435dd1c0c81mr1764022f8f.29.1769508875493;
        Tue, 27 Jan 2026 02:14:35 -0800 (PST)
Received: from 127.mynet ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-435b1c24acdsm38190407f8f.13.2026.01.27.02.14.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jan 2026 02:14:35 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	bpf@vger.kernel.org
Subject: [PATCH v4 3/6] io_uring/bpf-ops: add loop_step struct_ops callback
Date: Tue, 27 Jan 2026 10:14:07 +0000
Message-ID: <05a3f3c4b6f1e3117ba90ba87611c292f436bcb5.1769470552.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1769470552.git.asml.silence@gmail.com>
References: <cover.1769470552.git.asml.silence@gmail.com>
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
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-11937-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,vger.kernel.org];
	RCVD_COUNT_FIVE(0.00)[5];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	PRECEDENCE_BULK(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_NONE(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	FREEMAIL_FROM(0.00)[gmail.com];
	FROM_HAS_DN(0.00)[]
X-Rspamd-Queue-Id: DEBCC92AB5
X-Rspamd-Action: no action

Allow BPF to implement the loop_step callback to overwrite the main loop
logic. As described in the patch introducing the callback, it receives
iou_loop_params as an argument, which BPF can directly use to control
the loop.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/bpf-ops.c | 36 ++++++++++++++++++++++++++++++++++++
 io_uring/bpf-ops.h |  4 ++++
 2 files changed, 40 insertions(+)

diff --git a/io_uring/bpf-ops.c b/io_uring/bpf-ops.c
index a89d1dea60c7..7db07eda5a48 100644
--- a/io_uring/bpf-ops.c
+++ b/io_uring/bpf-ops.c
@@ -1,11 +1,22 @@
 #include <linux/mutex.h>
 #include <linux/bpf.h>
+#include <linux/bpf_verifier.h>
 
 #include "io_uring.h"
 #include "register.h"
 #include "bpf-ops.h"
+#include "loop.h"
+
+static const struct btf_type *loop_params_type;
+
+static int io_bpf_ops__loop_step(struct io_ring_ctx *ctx,
+				 struct iou_loop_params *lp)
+{
+	return IOU_LOOP_STOP;
+}
 
 static struct io_uring_bpf_ops io_bpf_ops_stubs = {
+	.loop_step = io_bpf_ops__loop_step,
 };
 
 static bool bpf_io_is_valid_access(int off, int size,
@@ -27,6 +38,14 @@ static int bpf_io_btf_struct_access(struct bpf_verifier_log *log,
 				    const struct bpf_reg_state *reg, int off,
 				    int size)
 {
+	const struct btf_type *t = btf_type_by_id(reg->btf, reg->btf_id);
+
+	if (t == loop_params_type) {
+		if (off >= offsetof(struct iou_loop_params, cq_wait_idx) &&
+		    off + size <= offsetofend(struct iou_loop_params, cq_wait_idx))
+			return SCALAR_VALUE;
+	}
+
 	return -EACCES;
 }
 
@@ -36,8 +55,25 @@ static const struct bpf_verifier_ops bpf_io_verifier_ops = {
 	.btf_struct_access = bpf_io_btf_struct_access,
 };
 
+static const struct btf_type *
+io_lookup_struct_type(struct btf *btf, const char *name)
+{
+	s32 type_id;
+
+	type_id = btf_find_by_name_kind(btf, name, BTF_KIND_STRUCT);
+	if (type_id < 0)
+		return NULL;
+	return btf_type_by_id(btf, type_id);
+}
+
 static int bpf_io_init(struct btf *btf)
 {
+	loop_params_type = io_lookup_struct_type(btf, "iou_loop_params");
+	if (!loop_params_type) {
+		pr_err("io_uring: Failed to locate iou_loop_params\n");
+		return -EINVAL;
+	}
+
 	return 0;
 }
 
diff --git a/io_uring/bpf-ops.h b/io_uring/bpf-ops.h
index a6756b391387..e8a08ae2df0a 100644
--- a/io_uring/bpf-ops.h
+++ b/io_uring/bpf-ops.h
@@ -5,6 +5,10 @@
 #include <linux/io_uring_types.h>
 
 struct io_uring_bpf_ops {
+	int (*loop_step)(struct io_ring_ctx *ctx, struct iou_loop_params *lp);
+
+	__u32 ring_fd;
+	void *priv;
 };
 
 #endif /* IOU_BPF_OPS_H */
-- 
2.52.0


