Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09EF54645DD
	for <lists+io-uring@lfdr.de>; Wed,  1 Dec 2021 05:23:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346560AbhLAE1F (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 30 Nov 2021 23:27:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346550AbhLAE1E (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 30 Nov 2021 23:27:04 -0500
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE503C061574;
        Tue, 30 Nov 2021 20:23:43 -0800 (PST)
Received: by mail-pf1-x443.google.com with SMTP id i12so22988826pfd.6;
        Tue, 30 Nov 2021 20:23:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RJfEa4/kZge1CNliuHpB+nDsCwp3gvmf9mSeXDqfsEo=;
        b=XllpY8xi9+d/4oPiBs/Zfb/i0MjssXHB/0Mw79tEXncO6Lx/qVNnYGM16BGrHm1G9D
         uSyHfBTdbtvOlH5exTuDEuwmBRWgg2lGAbgrE14hGjTN807HFX+le6s7G8ytsgNx8kYm
         8sHuq9CtVO2P27np18DNelrSluWbSX0+uU+nds1Zrz2Sgi2S05bXCvkYWQskVEZt7noF
         CzYN/IDLg/n0Da5I7+WdvF9rUx3c1pPTvnmXi/wXTq/p8neIF0ich5GsdT1QCmTpACY2
         C7QCsCTJeo3R/3fKugMhJZo72k4qXE3zUnSLt5IusimecGxat5o0D7pI7SxWpmYVGq2i
         9DJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RJfEa4/kZge1CNliuHpB+nDsCwp3gvmf9mSeXDqfsEo=;
        b=KfxgaqyLtkmmrW41R9E5NxtysFfRs5Iw8XL0BIudrdkG12YjA/pLgwTlVMArCKc2aZ
         AbptrfqjGi7MdzjenzIf5r9x1nypggIhJ42jFIxN5hn81g68Gwt7a9gOlozPHM7BTx7y
         2EWE6dE74Ah3oUuEcrC+ZzjihXqOMbdufdsR93zvCn3qLNiboWYa6hTGLGFWAV2vDBqr
         zonfWyeu0jQxFhPz3RqFSYwci6s9KHiS7UWYULgCUOQfE7LhIuoGbUKOMP6BGYZTQJoZ
         I1M/6neu02yD44aI2XCUBcOfE5Ine1rgzjBe3pnV5YnRimJS0Mcq6CtyNcJ5rcvQYt+L
         Jg3g==
X-Gm-Message-State: AOAM533kWtaKuLxavNLtfiRFVr8LTsuIBlFdVzCM4cvcUndzPu/7mYYV
        IVWmG06PT3jGvWOHqboMSHu5sRLIho4=
X-Google-Smtp-Source: ABdhPJwaFu0/pLwLS9N2DMYVWjSSuVHVdhWnTCwU/9p5YJU6igSbdg94UuAzEGWLYa9W6nK8x0P8DQ==
X-Received: by 2002:a05:6a00:1a8f:b0:49f:f5ac:b27a with SMTP id e15-20020a056a001a8f00b0049ff5acb27amr3904223pfv.38.1638332623141;
        Tue, 30 Nov 2021 20:23:43 -0800 (PST)
Received: from localhost ([2405:201:6014:d064:3d4e:6265:800c:dc84])
        by smtp.gmail.com with ESMTPSA id mg12sm4073990pjb.10.2021.11.30.20.23.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Nov 2021 20:23:42 -0800 (PST)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Yonghong Song <yhs@fb.com>,
        Pavel Emelyanov <ovzxemul@gmail.com>,
        Alexander Mikhalitsyn <alexander@mihalicyn.com>,
        Andrei Vagin <avagin@gmail.com>, criu@openvz.org,
        io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH bpf-next v3 02/10] bpf: Add bpf_page_to_pfn helper
Date:   Wed,  1 Dec 2021 09:53:25 +0530
Message-Id: <20211201042333.2035153-3-memxor@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211201042333.2035153-1-memxor@gmail.com>
References: <20211201042333.2035153-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=5140; h=from:subject; bh=lixf4LU5wjYILcJzQSrrc/f8UnBXtLkm7kOTUJalkSQ=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBhpvYx3UuuxxtcjcyPHfuDglkfto0wfL6OsOhWniBK 6u/+RriJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYab2MQAKCRBM4MiGSL8RyqCCD/ oCZ6ceJT4dcb8IjJpspHFTUK1oEh1A0PnwJx8urTfjbtPqVNAd+wovEasp+hYu2S+vOai0V5AowsjL UJsN8XsZtGKX6ViE24wsQ4Xe0qnabY45XQpDuNpXrJG44t1Yl6Nnxpq3aIy7z0e6KRQCh4CLdnxBik lJFgDd341YWfk3REmcyWyQVgwJbz321T/s4+drVmNYbvGqXkg9bxju+M+TloLsTSi51WtEhTyestk/ DoLl/cnJzsPsQ0dH9tsypCtRt0GbD6CQ72mQeZ7+yJFQBXzdZqB2whDmz+fSll4+QJeApRjATiLb7h Km0qlNhndqze+FDQXT50bAVKvab4a90TIi1MB5cgV6+77XvSyezP2RhTAypbUgAtZlZ2MI2SvguOBz x6wH2/j4rxjZksgSbc2t9uDtaqthbpkB9rw3xOaY/cDKec68N4kLbXFwD2wj7afbqa8RLbdC9+2EEJ U9AcIyXOT27b3qixx3UM08v4gnyQdz+bV5TGAf6P5ZqGF+ySzQ0odquqxBkvEH97Yxd07BFcFlhgCu iXUxTc+xh0d1y5HWA+9F1eVx7z1TerlJEYcGpPRvhwbRb8Dmv03gEgjeqX7YGsp1sNUmAZ3NEzPhA/ ZL/9R5lMOlmEeTyG7FekGhIuWBUXGVllMtMpjhUGmr+527arGG2lbA1XoDAg==
X-Developer-Key: i=memxor@gmail.com; a=openpgp; fpr=4BBE2A7E06ECF9D5823C61114CE0C88648BF11CA
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

In CRIU, we need to be able to determine whether the page pinned by
io_uring is still present in the same range in the process VMA.
/proc/<pid>/pagemap gives us the PFN, hence using this helper we can
establish this mapping easily from the iterator side.

It is a simple wrapper over the in-kernel page_to_pfn macro, and ensures
the passed in pointer is a struct page PTR_TO_BTF_ID. This is obtained
from the bvec of io_uring_ubuf for the CRIU usecase.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 include/linux/bpf.h            |  1 +
 include/uapi/linux/bpf.h       |  9 +++++++++
 kernel/trace/bpf_trace.c       | 19 +++++++++++++++++++
 scripts/bpf_doc.py             |  2 ++
 tools/include/uapi/linux/bpf.h |  9 +++++++++
 5 files changed, 40 insertions(+)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 967842881024..e44503158d76 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -2176,6 +2176,7 @@ extern const struct bpf_func_proto bpf_sk_setsockopt_proto;
 extern const struct bpf_func_proto bpf_sk_getsockopt_proto;
 extern const struct bpf_func_proto bpf_kallsyms_lookup_name_proto;
 extern const struct bpf_func_proto bpf_find_vma_proto;
+extern const struct bpf_func_proto bpf_page_to_pfn_proto;
 
 const struct bpf_func_proto *tracing_prog_func_proto(
   enum bpf_func_id func_id, const struct bpf_prog *prog);
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 1ad1ae85743c..885d9293c147 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -4960,6 +4960,14 @@ union bpf_attr {
  *		**-ENOENT** if *task->mm* is NULL, or no vma contains *addr*.
  *		**-EBUSY** if failed to try lock mmap_lock.
  *		**-EINVAL** for invalid **flags**.
+ *
+ * long bpf_page_to_pfn(struct page *page)
+ *	Description
+ *		Obtain the page frame number (PFN) for the given *struct page*
+ *		pointer.
+ *	Return
+ *		Page Frame Number corresponding to the page pointed to by the
+ *		*struct page* pointer, or U64_MAX if pointer is NULL.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -5143,6 +5151,7 @@ union bpf_attr {
 	FN(skc_to_unix_sock),		\
 	FN(kallsyms_lookup_name),	\
 	FN(find_vma),			\
+	FN(page_to_pfn),		\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index 25ea521fb8f1..2a6488f14e58 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -1091,6 +1091,23 @@ static const struct bpf_func_proto bpf_get_branch_snapshot_proto = {
 	.arg2_type	= ARG_CONST_SIZE_OR_ZERO,
 };
 
+BPF_CALL_1(bpf_page_to_pfn, struct page *, page)
+{
+	/* PTR_TO_BTF_ID can be NULL */
+	if (!page)
+		return U64_MAX;
+	return page_to_pfn(page);
+}
+
+BTF_ID_LIST_SINGLE(btf_page_to_pfn_ids, struct, page)
+
+const struct bpf_func_proto bpf_page_to_pfn_proto = {
+	.func		= bpf_page_to_pfn,
+	.ret_type	= RET_INTEGER,
+	.arg1_type	= ARG_PTR_TO_BTF_ID,
+	.arg1_btf_id	= &btf_page_to_pfn_ids[0],
+};
+
 static const struct bpf_func_proto *
 bpf_tracing_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 {
@@ -1212,6 +1229,8 @@ bpf_tracing_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 		return &bpf_find_vma_proto;
 	case BPF_FUNC_trace_vprintk:
 		return bpf_get_trace_vprintk_proto();
+	case BPF_FUNC_page_to_pfn:
+		return &bpf_page_to_pfn_proto;
 	default:
 		return bpf_base_func_proto(func_id);
 	}
diff --git a/scripts/bpf_doc.py b/scripts/bpf_doc.py
index a6403ddf5de7..ae68ca794980 100755
--- a/scripts/bpf_doc.py
+++ b/scripts/bpf_doc.py
@@ -549,6 +549,7 @@ class PrinterHelpers(Printer):
             'struct socket',
             'struct file',
             'struct bpf_timer',
+            'struct page',
     ]
     known_types = {
             '...',
@@ -598,6 +599,7 @@ class PrinterHelpers(Printer):
             'struct socket',
             'struct file',
             'struct bpf_timer',
+            'struct page',
     }
     mapped_types = {
             'u8': '__u8',
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 1ad1ae85743c..885d9293c147 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -4960,6 +4960,14 @@ union bpf_attr {
  *		**-ENOENT** if *task->mm* is NULL, or no vma contains *addr*.
  *		**-EBUSY** if failed to try lock mmap_lock.
  *		**-EINVAL** for invalid **flags**.
+ *
+ * long bpf_page_to_pfn(struct page *page)
+ *	Description
+ *		Obtain the page frame number (PFN) for the given *struct page*
+ *		pointer.
+ *	Return
+ *		Page Frame Number corresponding to the page pointed to by the
+ *		*struct page* pointer, or U64_MAX if pointer is NULL.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -5143,6 +5151,7 @@ union bpf_attr {
 	FN(skc_to_unix_sock),		\
 	FN(kallsyms_lookup_name),	\
 	FN(find_vma),			\
+	FN(page_to_pfn),		\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
-- 
2.34.1

