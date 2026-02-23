Return-Path: <io-uring+bounces-12377-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SPHdJAZgnGnsFQQAu9opvQ
	(envelope-from <io-uring+bounces-12377-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 23 Feb 2026 15:11:18 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 46CEF177CF4
	for <lists+io-uring@lfdr.de>; Mon, 23 Feb 2026 15:11:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id AFFC9304E7F0
	for <lists+io-uring@lfdr.de>; Mon, 23 Feb 2026 14:10:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15977283FCE;
	Mon, 23 Feb 2026 14:10:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IbkmaR9E"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57CEB27FB18
	for <io-uring@vger.kernel.org>; Mon, 23 Feb 2026 14:10:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771855858; cv=none; b=UHaefHK2zOmVNfI+pylIJv6jGLcAk8s92BNx+1kIHhxpYY0D4DFUcGPFkMoPeXCBiirQrn+SV6J2Ydt3QpjJmvz3sc4egdE5oOpKiy5/c7Ok6pxbcWjsCTkXx06evHjPlrjTSLg2pfMcXnfBiQVxKkTVb6wCO/CZntbBS//gK14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771855858; c=relaxed/simple;
	bh=2ZcR9zAA+ijCun56ms8GzK5P5WiOGsy+pTvH1/xiMto=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iQpZ55LGoJZTlvm/2ome50xykzxypeax31pue1biErQWtktcF9uCCt0NAHjSW68vTPsjxVTqQ0QqDHcsu5raO++adW7OsZrdbuSHJQt4XY4y+M5NxSBTD7EBldrfVPW5Rl/hHyDSk3VbldG7xpUAoOQkwgxoL6St6J5lXBFjjgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IbkmaR9E; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-43767807da6so3257627f8f.2
        for <io-uring@vger.kernel.org>; Mon, 23 Feb 2026 06:10:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771855854; x=1772460654; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hQvbDRlp6zr7sqW0Cbja8/AWgExmrJVPBZ7Jd+Q7MAs=;
        b=IbkmaR9EudHgC533Ym9AddriN9mk1ADfGbTbaFdBnSNjig6NSehogxEuFHOrci2fet
         Cacq7IgNjJwcUoLpCTrFSb/sgMnBMugl+hT88mwbiKSA8i54AGD77/L9jhm9PUz3nMTZ
         hc72j83i7l9CsK2b+efrqIZz4yiR8l4xTtNqsTgtGZKj9dSBJn9wKqbn1CBLLm4//j37
         nNdT41OhbuQRvLnkTsn7YvLarEm+x3EZdRkDcb3w711KD6ukzrjI8sXeuGnt+LD19MIa
         uhfMFNW1/GeBKEQRnYbRZnAM7vBrLvWtUQfOsmZYyDlPm3BmARCAP7Dzmy6qmPkXgtjY
         mZZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771855854; x=1772460654;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=hQvbDRlp6zr7sqW0Cbja8/AWgExmrJVPBZ7Jd+Q7MAs=;
        b=HwDXHtIeB7ETZaALEPNwTleqXmER7odiGO+CTngjZ8xztuObw1zksnyRVuoMVOtdYn
         IKkZW1KDgV28ZFtouJtbn3V57JaGpMI6RG9X7dQ5dU8aFaKpr31dHtICS16Bs/wJ+Qo+
         MHaxKG0cGoPuPzb5xgC7Ntri5/8PPEOhGw1VEROklJkoJRcHi4/ySEXSztSMORRklz7s
         b+pczRxpmjLpRez3fKyqM/Dlmtyex2NjEFkaFXplRcdIjMDIhrddxjs0/Dr7Uw88pNBG
         amZJQ4p5gJL4FGyAxcvE/Pepe5Jy/fTcwTQRAkJpRZearFavZF+c3PcolmmbbaDtvIQM
         tcLA==
X-Gm-Message-State: AOJu0Yx87PSijY6Z+bIYQCJlfIsrWp/Sb0SP4KkyQTQszePEkOLp+mwN
	35UXJpgZg60DrGI1QNt44IQbqP7iotHrgNTMvnOpw9hZu9QomNcMjiVKx9dcVQ==
X-Gm-Gg: ATEYQzz4G9MfvP/0XcMYk2YxVxzGuM9vRjBUa1sgS9pmhU3FyPccQludYTBSYcjH60a
	ZCRb3etBdJqdgufMBK7CRSpNPnf334yBNIBaPNjJ52CgRFkDV+9lWTjVhiR4kgYnC/k7ySZ57DZ
	TsT8qfVMvkHxNbkEPs3qmfOZqmO2pknrMj4LfvQmt28jriPIajDi5ImqUUURNrazF2yE7OHsYZE
	wSm5T4CvGl2sLrd7ZQWEdm5rKW9jnL5V22s+QYkE4GUiVvjEg+o6/QX6Z4TnKzc8+22mbMLnU6D
	pnuSsJOkjHBdzJptq41CCFAhzlT53o84IkeK+pMx1tpGV9Imx97dpF2EOI5uKwgvPIav9Wa9x9z
	IMiRHx8LZ2QA1diKnuEWzmw4YLU3pUwDnssFKAorggj/wUkEzxj5CNOF2f8gVlMTsla50KSL13V
	nbjp4oXjxV/kU8Dgq5OakF1Q9txmn0ej1XWbBxiss8DYnEweU0LWpn/BFgET302czPvzf5yEUQI
	QP58n1jRg==
X-Received: by 2002:a05:6000:1883:b0:437:893f:3361 with SMTP id ffacd0b85a97d-4396f15ae17mr15852198f8f.20.1771855854172;
        Mon, 23 Feb 2026 06:10:54 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::1:36ea])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43970bf9feasm19464640f8f.6.2026.02.23.06.10.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Feb 2026 06:10:53 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	bpf@vger.kernel.org,
	axboe@kernel.dk,
	Alexei Starovoitov <alexei.starovoitov@gmail.com>
Subject: [PATCH v9 10/10] io_uring/selftests: test BPF [un]registration
Date: Mon, 23 Feb 2026 14:10:21 +0000
Message-ID: <6015650200dd82a41a50b0b23fd30f57b76a6203.1771855761.git.asml.silence@gmail.com>
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
	TAGGED_FROM(0.00)[bounces-12377-lists,io-uring=lfdr.de];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[lib.mk:url,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 46CEF177CF4
X-Rspamd-Action: no action

Make sure BPF registration and unregistration leave io_uring in the
right state.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 tools/testing/selftests/io_uring/Makefile     |  2 +-
 .../testing/selftests/io_uring/common-defs.h  |  4 +
 tools/testing/selftests/io_uring/unreg.bpf.c  | 25 +++++
 tools/testing/selftests/io_uring/unreg.c      | 92 +++++++++++++++++++
 4 files changed, 122 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/io_uring/unreg.bpf.c
 create mode 100644 tools/testing/selftests/io_uring/unreg.c

diff --git a/tools/testing/selftests/io_uring/Makefile b/tools/testing/selftests/io_uring/Makefile
index 77df197449ef..37f50acdba37 100644
--- a/tools/testing/selftests/io_uring/Makefile
+++ b/tools/testing/selftests/io_uring/Makefile
@@ -3,7 +3,7 @@ include ../../../build/Build.include
 include ../../../scripts/Makefile.arch
 include ../../../scripts/Makefile.include
 
-TEST_GEN_PROGS := nops_loop overflow
+TEST_GEN_PROGS := nops_loop overflow unreg
 
 # override lib.mk's default rules
 OVERRIDE_TARGETS := 1
diff --git a/tools/testing/selftests/io_uring/common-defs.h b/tools/testing/selftests/io_uring/common-defs.h
index 948453c90375..9a44e0687436 100644
--- a/tools/testing/selftests/io_uring/common-defs.h
+++ b/tools/testing/selftests/io_uring/common-defs.h
@@ -24,4 +24,8 @@ struct nops_state {
 	int		reqs_left;
 };
 
+struct unreg_state {
+	unsigned	times_invoked;
+};
+
 #endif /* IOU_TOOLS_COMMON_DEFS_H */
diff --git a/tools/testing/selftests/io_uring/unreg.bpf.c b/tools/testing/selftests/io_uring/unreg.bpf.c
new file mode 100644
index 000000000000..e872915b09dd
--- /dev/null
+++ b/tools/testing/selftests/io_uring/unreg.bpf.c
@@ -0,0 +1,25 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#include <linux/types.h>
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
+#include "vmlinux.h"
+#include "common-defs.h"
+
+char LICENSE[] SEC("license") = "Dual BSD/GPL";
+
+SEC("struct_ops.s/unreg_loop_step")
+int BPF_PROG(unreg_loop_step, struct io_ring_ctx *ring,
+			      struct iou_loop_params *ls)
+{
+	struct unreg_state *us;
+
+	us = (void *)bpf_io_uring_get_region(ring, IOU_REGION_MEM, sizeof(*us));
+	if (us)
+		us->times_invoked++;
+	return IOU_LOOP_STOP;
+}
+
+SEC(".struct_ops.link")
+struct io_uring_bpf_ops unreg_ops = {
+	.loop_step = (void *)unreg_loop_step,
+};
diff --git a/tools/testing/selftests/io_uring/unreg.c b/tools/testing/selftests/io_uring/unreg.c
new file mode 100644
index 000000000000..43076681999f
--- /dev/null
+++ b/tools/testing/selftests/io_uring/unreg.c
@@ -0,0 +1,92 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Test BPF registration / unregistration works and doesn't leave a dangling
+ * function pointer.
+ */
+#include <linux/stddef.h>
+#include <errno.h>
+#include <signal.h>
+#include <stdlib.h>
+
+#include <bpf/libbpf.h>
+#include <io_uring/mini_liburing.h>
+
+#include "helpers.h"
+#include "unreg.bpf.skel.h"
+
+static struct unreg *load_unreg(struct ring_ctx *ctx)
+{
+	struct unreg *skel;
+	int ret;
+
+	skel = unreg__open();
+	if (!skel) {
+		fprintf(stderr, "can't generate skeleton\n");
+		exit(1);
+	}
+
+	skel->struct_ops.unreg_ops->ring_fd = ctx->ring.ring_fd;
+
+	ret = unreg__load(skel);
+	if (ret) {
+		fprintf(stderr, "failed to load skeleton\n");
+		exit(1);
+	}
+
+	return skel;
+}
+
+int main()
+{
+	struct bpf_link *link1, *link2;
+	struct unreg *skel1, *skel2;
+	struct unreg_state *us;
+	struct ring_ctx ctx;
+
+	ring_ctx_create(&ctx, sizeof(struct unreg_state));
+	us = ctx.region;
+
+	skel1 = load_unreg(&ctx);
+	skel2 = load_unreg(&ctx);
+
+	link1 = bpf_map__attach_struct_ops(skel1->maps.unreg_ops);
+	if (!link1) {
+		fprintf(stderr, "failed to attach ops\n");
+		return 1;
+	}
+
+	ring_ctx_run(&ctx);
+	if (us->times_invoked != 1) {
+		fprintf(stderr, "failed to run BPF\n");
+		return 1;
+	}
+
+	/* remove the program and give the kernel time to actually destroy it */
+	bpf_link__destroy(link1);
+	unreg__destroy(skel1);
+	sleep(1);
+
+	ring_ctx_run(&ctx);
+	if (us->times_invoked != 1) {
+		fprintf(stderr, "Executed removed BPF\n");
+		return 1;
+	}
+
+	/* try to attach another program */
+	link2 = bpf_map__attach_struct_ops(skel2->maps.unreg_ops);
+	if (!link2) {
+		fprintf(stderr, "failed to reattach ops\n");
+		return 1;
+	}
+
+	ring_ctx_run(&ctx);
+	if (us->times_invoked != 2) {
+		fprintf(stderr, "failed to run reattached BPF\n");
+		return 1;
+	}
+
+	bpf_link__destroy(link2);
+	unreg__destroy(skel2);
+	ring_ctx_destroy(&ctx);
+	return 0;
+}
-- 
2.53.0


