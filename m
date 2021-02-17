Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 509D931D9A8
	for <lists+io-uring@lfdr.de>; Wed, 17 Feb 2021 13:43:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231709AbhBQMmp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 17 Feb 2021 07:42:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232783AbhBQMmo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 17 Feb 2021 07:42:44 -0500
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 853A1C061756
        for <io-uring@vger.kernel.org>; Wed, 17 Feb 2021 04:42:03 -0800 (PST)
Received: by mail-wm1-x334.google.com with SMTP id a132so2022840wmc.0
        for <io-uring@vger.kernel.org>; Wed, 17 Feb 2021 04:42:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=dGv7glabXqC5WvpJ6AA4u5twX2dtbGUx9aicY0PraUo=;
        b=DcJGrXC1EBJFcrR3LaqtxGr3kbrB+xk6DCTWAi3eS2HMvfrBs2iXM9EcEorAnejByh
         XAQ3jPjmgTqes5TcyuA45H4anHjpTAHe6mLo0rqLovw7E8eZb86N2ISQ6AzUnd6VL5mk
         mw8lfWYKbneJAII5htDm9lqqYQVbjIm2kI5FzKg+/CX4z98Gk3HvCFQSq9CvTHeam3W8
         Ye1JLEFK8WW4BQnQh68/h3JSpoHYscKWa/8+l+jH3BpFbmFwXWu30zIVoBrIkSa86cMz
         jpHpKI86onvv7Q+xaz0BxPX9dv5LxXfM9XeyPDRsRLrS4fs6IO3oAZCtp9ykEC9xM24h
         8EEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dGv7glabXqC5WvpJ6AA4u5twX2dtbGUx9aicY0PraUo=;
        b=iOr8VCDidShbpXtZTYnaiwH/gT+CMAx9jA8f2HMfqOw8OYwPIJh13XNXntHNLwpe0/
         CBl946oOMSBqCajJVWvXl20OXulFwnKzyCOwnfCLdcl4ouPv4UBGWYdP1aM40/nC2m8o
         TIoyfQotFY4VAGlHpb2JxkDlpwJibvFYWE2hFr/7fONU8AWLow3MwjtBxLk4bPlmWh1G
         TL6tiT44QoS0guCC83g+pFDkHZXD6NY5bpvC6/P9Pj9t5AEZ7ZORnW4bTZccsaQ0rtJz
         SUC/tlgw0HHK6jZIxxinR0DHw5RKJSRP/3nyxnCrnE9fKhegjCMFIEEt714wAA+VAm10
         rYXA==
X-Gm-Message-State: AOAM530b2vEzTtsu0WSEmeEfHNQh6dCMtp1C3UoGOO7JHgm/GMZCpZ/B
        hzZF/feY3CJ/AU/ii6V8Hs3CpjGQIm2eUA==
X-Google-Smtp-Source: ABdhPJzE5gH+g5mc8Gw2KViL/P9ipyuuT2DhTQN6JPHhmWn/ZGPRFJa0wHNFsCeAShVsX0UO/4ASPQ==
X-Received: by 2002:a1c:f60b:: with SMTP id w11mr6918275wmc.3.1613565722269;
        Wed, 17 Feb 2021 04:42:02 -0800 (PST)
Received: from localhost.localdomain ([85.255.235.13])
        by smtp.gmail.com with ESMTPSA id t9sm3589979wrw.76.2021.02.17.04.42.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Feb 2021 04:42:01 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 1/4] bpf: add IOURING program type
Date:   Wed, 17 Feb 2021 12:38:03 +0000
Message-Id: <73cb41c5c3be42a5a0815550a9dc9baaea48bae5.1613563964.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1613563964.git.asml.silence@gmail.com>
References: <cover.1613563964.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Draft a new program type BPF_PROG_TYPE_IOURING, which will be used by
io_uring to execute BPF-based requests.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c             | 21 +++++++++++++++++++++
 include/linux/bpf_types.h |  2 ++
 include/uapi/linux/bpf.h  |  1 +
 kernel/bpf/syscall.c      |  1 +
 kernel/bpf/verifier.c     |  3 +++
 5 files changed, 28 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 61b65edabe5e..2c8904bee386 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -10166,6 +10166,27 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
 	return ret;
 }
 
+static const struct bpf_func_proto *
+io_bpf_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
+{
+	return bpf_base_func_proto(func_id);
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
+	.get_func_proto		= io_bpf_func_proto,
+	.is_valid_access	= io_bpf_is_valid_access,
+};
+
 SYSCALL_DEFINE4(io_uring_register, unsigned int, fd, unsigned int, opcode,
 		void __user *, arg, unsigned int, nr_args)
 {
diff --git a/include/linux/bpf_types.h b/include/linux/bpf_types.h
index 99f7fd657d87..d0b7954887bd 100644
--- a/include/linux/bpf_types.h
+++ b/include/linux/bpf_types.h
@@ -77,6 +77,8 @@ BPF_PROG_TYPE(BPF_PROG_TYPE_LSM, lsm,
 	       void *, void *)
 #endif /* CONFIG_BPF_LSM */
 #endif
+BPF_PROG_TYPE(BPF_PROG_TYPE_IOURING, bpf_io_uring,
+	      void *, void *)
 
 BPF_MAP_TYPE(BPF_MAP_TYPE_ARRAY, array_map_ops)
 BPF_MAP_TYPE(BPF_MAP_TYPE_PERCPU_ARRAY, percpu_array_map_ops)
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 77d7c1bb2923..2f1c0ab097d8 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -200,6 +200,7 @@ enum bpf_prog_type {
 	BPF_PROG_TYPE_EXT,
 	BPF_PROG_TYPE_LSM,
 	BPF_PROG_TYPE_SK_LOOKUP,
+	BPF_PROG_TYPE_IOURING,
 };
 
 enum bpf_attach_type {
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index e5999d86c76e..9b8f6b57fb1b 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -2031,6 +2031,7 @@ static bool is_net_admin_prog_type(enum bpf_prog_type prog_type)
 	case BPF_PROG_TYPE_CGROUP_SOCKOPT:
 	case BPF_PROG_TYPE_CGROUP_SYSCTL:
 	case BPF_PROG_TYPE_SOCK_OPS:
+	case BPF_PROG_TYPE_IOURING:
 	case BPF_PROG_TYPE_EXT: /* extends any prog */
 		return true;
 	case BPF_PROG_TYPE_CGROUP_SKB:
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index e7368c5eacb7..54e26586932b 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -7981,6 +7981,9 @@ static int check_return_code(struct bpf_verifier_env *env)
 	case BPF_PROG_TYPE_SK_LOOKUP:
 		range = tnum_range(SK_DROP, SK_PASS);
 		break;
+	case BPF_PROG_TYPE_IOURING:
+		range = tnum_const(0);
+		break;
 	case BPF_PROG_TYPE_EXT:
 		/* freplace program can return anything as its return value
 		 * depends on the to-be-replaced kernel func or bpf program.
-- 
2.24.0

