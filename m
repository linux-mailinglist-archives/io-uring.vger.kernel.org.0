Return-Path: <io-uring+bounces-4587-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 876C79C3640
	for <lists+io-uring@lfdr.de>; Mon, 11 Nov 2024 02:50:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 027292810D6
	for <lists+io-uring@lfdr.de>; Mon, 11 Nov 2024 01:50:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 725E61BF58;
	Mon, 11 Nov 2024 01:50:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HkKNhbZP"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 700F012A177
	for <io-uring@vger.kernel.org>; Mon, 11 Nov 2024 01:50:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731289808; cv=none; b=kHsjgGkLU6BVNSKu+Yzo5ZXEr68HaikhJArIrkjCAuoyI6thCTtHHCg6OMY/n9OKfBIhwhLNVHZuN1C1wDD7oA4unMbjUVhwbFYTYRiL+y224Fbvi4+PZiJ4Pi+AVqPoay6MoZzF/cG8RN/zmAPJ/USRRA9jnYg3nTHYeH5l6OQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731289808; c=relaxed/simple;
	bh=oEN3PTJSvYYENoMEeU/fXjb0Mx1Jf3wvTKILFlqvdSc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kSwMuNBrhCSkW5q1KE0iwLLB4eBn0vhPKmytqLfWNKKFFFjU6sBEt2FONg1O0prubGYcLV/QBQuJdw5H2q4RaqMnOBGHUhci8OsmdcvCFVVtO7XeyP+0AAKI8nmpEUDSG/dxLWzPMfO2qZon1XOQfqCl4nQpZ4ZWB2mnrtV+VW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HkKNhbZP; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-37d495d217bso3742459f8f.0
        for <io-uring@vger.kernel.org>; Sun, 10 Nov 2024 17:50:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731289804; x=1731894604; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ngqLuMC/mZAvUzUaZXEWfX8nsydLs3KWDt2xoq7rbDk=;
        b=HkKNhbZPom+NJ0o/yDjxnAoOFO4Xo9zfUabAZ7mG5DXVuPZZF75Anv9bOhlZVPfb7E
         WEJyYl0QeorSvHNoJ6nHe8aDqtqO1xSkQoQIXl6tAgvDFjoLrSkIIlzClKeBagqr60hO
         MfVaVeCsozD2Ao0zQHCSp5YY3J9xLgKV6kRI4B4/DjkNvol6IXxa8u2EnxK9lLoic4uI
         fklkOT/JeiIBqpgWb/JTeE1w2393TIP0ydss830ARgzzQa+FZ8heql8cQ7lFci5VdVXM
         YHMbFskuPrEri5ln14e790xJQopVyxo3NTBtAo9FoJPuL68z2+1aQRIrEHazPj4hDiaX
         T+nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731289804; x=1731894604;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ngqLuMC/mZAvUzUaZXEWfX8nsydLs3KWDt2xoq7rbDk=;
        b=YFhMngLYuC0sq3fCKJqJQOgAFYJn5XdKvdccIz8lmQmU1GSees4KnFJfAXykcBdxRp
         tf9D+1kaFtytzAaU02g0ycqIMykTW6U+lwgZ0TQRkHK4/sT9P+93PWUV9V0T3Q3GcTek
         c75Jp1EfMLn4KNcb8+TBwy8U7JtmxENtQX8f6SAGufMh7vrHRXp+OKKaAe19gjYOHf4i
         9S44hQJksIQMUuGwTY4tFX2AHoFcLjs+YhpLK8L4bQ4Mub8LVPRrp74HTj4vZ27A2KAH
         qJj0oxp1RM+kfslCNOx3Fm8VMkVonhivlyW48xY6FK6gdHWQVfAWAKZ3go9JJuTqe0nu
         7+3g==
X-Gm-Message-State: AOJu0YzhD3tqfctjxtO0NixV76IvEmP7iVO59Xkk9XYsV3rOwQTHIbuB
	k47NcwVJUMui1+shZDRFRTl8n3RV1Qapc9+ey0hvWIrJf8kqnuzvBdFDUg==
X-Google-Smtp-Source: AGHT+IHfMaPGXVe+eREEpmSckVLmCOutwi7NZlRuJICkkBG8gR45DAtxff3Mesmt1zSMkv3AmccfRA==
X-Received: by 2002:a05:6000:1fad:b0:37c:cc4b:d1d6 with SMTP id ffacd0b85a97d-381f1872041mr12519580f8f.27.1731289804318;
        Sun, 10 Nov 2024 17:50:04 -0800 (PST)
Received: from 127.0.0.1localhost ([85.255.234.98])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-432b05c18e0sm161494685e9.28.2024.11.10.17.50.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Nov 2024 17:50:03 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [RFC 1/3] bpf/io_uring: add io_uring program type
Date: Mon, 11 Nov 2024 01:50:44 +0000
Message-ID: <ef243f43eb20ebfaf122cdf0a089eb7c2a304127.1731285516.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <cover.1731285516.git.asml.silence@gmail.com>
References: <cover.1731285516.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a new BPF program type and bare minimum implementation that would be
responsible orchestrating in-kernel request handling in the io_uring
waiting loop. The program is supposed to replace the logic which
terminates the traditional waiting loop based on a number of parameters
like the number of completion event to wait for, and it returns one of
the IOU_BPF_RET_* return codes telling the kernel whether it should
return back to the user space or continue waiting.

At the moment there is no way to attach it anywhere, and the program
is pretty useless and doesn't know yet how to interact with io_uring.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/linux/bpf.h               |  1 +
 include/linux/bpf_types.h         |  4 ++++
 include/linux/io_uring/bpf.h      | 10 ++++++++++
 include/uapi/linux/bpf.h          |  1 +
 include/uapi/linux/io_uring/bpf.h | 22 ++++++++++++++++++++++
 io_uring/Makefile                 |  1 +
 io_uring/bpf.c                    | 24 ++++++++++++++++++++++++
 kernel/bpf/btf.c                  |  3 +++
 kernel/bpf/syscall.c              |  1 +
 kernel/bpf/verifier.c             | 10 +++++++++-
 10 files changed, 76 insertions(+), 1 deletion(-)
 create mode 100644 include/linux/io_uring/bpf.h
 create mode 100644 include/uapi/linux/io_uring/bpf.h
 create mode 100644 io_uring/bpf.c

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 19d8ca8ac960..bccd99dd58c4 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -30,6 +30,7 @@
 #include <linux/static_call.h>
 #include <linux/memcontrol.h>
 #include <linux/cfi.h>
+#include <linux/io_uring/bpf.h>
 
 struct bpf_verifier_env;
 struct bpf_verifier_log;
diff --git a/include/linux/bpf_types.h b/include/linux/bpf_types.h
index 9f2a6b83b49e..24293e1ee0b1 100644
--- a/include/linux/bpf_types.h
+++ b/include/linux/bpf_types.h
@@ -83,6 +83,10 @@ BPF_PROG_TYPE(BPF_PROG_TYPE_SYSCALL, bpf_syscall,
 BPF_PROG_TYPE(BPF_PROG_TYPE_NETFILTER, netfilter,
 	      struct bpf_nf_ctx, struct bpf_nf_ctx)
 #endif
+#ifdef CONFIG_IO_URING
+BPF_PROG_TYPE(BPF_PROG_TYPE_IOURING, bpf_io_uring,
+	      struct io_uring_bpf_ctx, struct io_bpf_ctx_kern)
+#endif
 
 BPF_MAP_TYPE(BPF_MAP_TYPE_ARRAY, array_map_ops)
 BPF_MAP_TYPE(BPF_MAP_TYPE_PERCPU_ARRAY, percpu_array_map_ops)
diff --git a/include/linux/io_uring/bpf.h b/include/linux/io_uring/bpf.h
new file mode 100644
index 000000000000..b700a4b65111
--- /dev/null
+++ b/include/linux/io_uring/bpf.h
@@ -0,0 +1,10 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+#ifndef _LINUX_IO_URING_BPF_H
+#define _LINUX_IO_URING_BPF_H
+
+#include <uapi/linux/io_uring/bpf.h>
+
+struct io_bpf_ctx_kern {
+};
+
+#endif
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index e8241b320c6d..1945430d31a6 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -1055,6 +1055,7 @@ enum bpf_prog_type {
 	BPF_PROG_TYPE_SK_LOOKUP,
 	BPF_PROG_TYPE_SYSCALL, /* a program that can execute syscalls */
 	BPF_PROG_TYPE_NETFILTER,
+	BPF_PROG_TYPE_IOURING,
 	__MAX_BPF_PROG_TYPE
 };
 
diff --git a/include/uapi/linux/io_uring/bpf.h b/include/uapi/linux/io_uring/bpf.h
new file mode 100644
index 000000000000..da749fe7251c
--- /dev/null
+++ b/include/uapi/linux/io_uring/bpf.h
@@ -0,0 +1,22 @@
+/* SPDX-License-Identifier: (GPL-2.0 WITH Linux-syscall-note) OR MIT */
+/*
+ * Header file for the io_uring bpf interface.
+ *
+ * Copyright (C) 2024 Pavel Begunkov
+ */
+#ifndef LINUX_IO_URING_BPF_H
+#define LINUX_IO_URING_BPF_H
+
+#include <linux/types.h>
+
+enum {
+	IOU_BPF_RET_OK,
+	IOU_BPF_RET_STOP,
+
+	__IOU_BPF_RET_MAX,
+};
+
+struct io_uring_bpf_ctx {
+};
+
+#endif
diff --git a/io_uring/Makefile b/io_uring/Makefile
index 53167bef37d7..5da66ecc98e5 100644
--- a/io_uring/Makefile
+++ b/io_uring/Makefile
@@ -17,3 +17,4 @@ obj-$(CONFIG_IO_URING)		+= io_uring.o opdef.o kbuf.o rsrc.o notif.o \
 obj-$(CONFIG_IO_WQ)		+= io-wq.o
 obj-$(CONFIG_FUTEX)		+= futex.o
 obj-$(CONFIG_NET_RX_BUSY_POLL) += napi.o
+obj-$(CONFIG_BPF) += bpf.o
diff --git a/io_uring/bpf.c b/io_uring/bpf.c
new file mode 100644
index 000000000000..6eb0c47b4aa9
--- /dev/null
+++ b/io_uring/bpf.c
@@ -0,0 +1,24 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <linux/bpf.h>
+
+static const struct bpf_func_proto *
+io_bpf_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
+{
+	return bpf_base_func_proto(func_id, prog);
+}
+
+static bool io_bpf_is_valid_access(int off, int size,
+				   enum bpf_access_type type,
+				   const struct bpf_prog *prog,
+				   struct bpf_insn_access_aux *info)
+{
+	return false;
+}
+
+const struct bpf_prog_ops bpf_io_uring_prog_ops = {};
+
+const struct bpf_verifier_ops bpf_io_uring_verifier_ops = {
+	.get_func_proto			= io_bpf_func_proto,
+	.is_valid_access		= io_bpf_is_valid_access,
+};
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 5cd1c7a23848..e102ee7c530a 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -219,6 +219,7 @@ enum btf_kfunc_hook {
 	BTF_KFUNC_HOOK_LWT,
 	BTF_KFUNC_HOOK_NETFILTER,
 	BTF_KFUNC_HOOK_KPROBE,
+	BTF_KFUNC_HOOK_IOURING,
 	BTF_KFUNC_HOOK_MAX,
 };
 
@@ -8393,6 +8394,8 @@ static int bpf_prog_type_to_kfunc_hook(enum bpf_prog_type prog_type)
 		return BTF_KFUNC_HOOK_NETFILTER;
 	case BPF_PROG_TYPE_KPROBE:
 		return BTF_KFUNC_HOOK_KPROBE;
+	case BPF_PROG_TYPE_IOURING:
+		return BTF_KFUNC_HOOK_IOURING;
 	default:
 		return BTF_KFUNC_HOOK_MAX;
 	}
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 8cfa7183d2ef..5587ede39ae2 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -2571,6 +2571,7 @@ bpf_prog_load_check_attach(enum bpf_prog_type prog_type,
 		return -EINVAL;
 	case BPF_PROG_TYPE_SYSCALL:
 	case BPF_PROG_TYPE_EXT:
+	case BPF_PROG_TYPE_IOURING:
 		if (expected_attach_type)
 			return -EINVAL;
 		fallthrough;
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 411ab1b57af4..14de335ba66b 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -15946,6 +15946,9 @@ static int check_return_code(struct bpf_verifier_env *env, int regno, const char
 	case BPF_PROG_TYPE_NETFILTER:
 		range = retval_range(NF_DROP, NF_ACCEPT);
 		break;
+	case BPF_PROG_TYPE_IOURING:
+		range = retval_range(IOU_BPF_RET_OK, __IOU_BPF_RET_MAX - 1);
+		break;
 	case BPF_PROG_TYPE_EXT:
 		/* freplace program can return anything as its return value
 		 * depends on the to-be-replaced kernel func or bpf program.
@@ -22209,7 +22212,8 @@ static bool can_be_sleepable(struct bpf_prog *prog)
 	}
 	return prog->type == BPF_PROG_TYPE_LSM ||
 	       prog->type == BPF_PROG_TYPE_KPROBE /* only for uprobes */ ||
-	       prog->type == BPF_PROG_TYPE_STRUCT_OPS;
+	       prog->type == BPF_PROG_TYPE_STRUCT_OPS ||
+	       prog->type == BPF_PROG_TYPE_IOURING;
 }
 
 static int check_attach_btf_id(struct bpf_verifier_env *env)
@@ -22229,6 +22233,10 @@ static int check_attach_btf_id(struct bpf_verifier_env *env)
 		verbose(env, "Syscall programs can only be sleepable\n");
 		return -EINVAL;
 	}
+	if (prog->type == BPF_PROG_TYPE_IOURING && !prog->sleepable) {
+		verbose(env, "io_uring programs can only be sleepable\n");
+		return -EINVAL;
+	}
 
 	if (prog->sleepable && !can_be_sleepable(prog)) {
 		verbose(env, "Only fentry/fexit/fmod_ret, lsm, iter, uprobe, and struct_ops programs can be sleepable\n");
-- 
2.46.0


