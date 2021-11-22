Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 179104597EA
	for <lists+io-uring@lfdr.de>; Mon, 22 Nov 2021 23:54:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230337AbhKVW5K (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 22 Nov 2021 17:57:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229678AbhKVW5I (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 22 Nov 2021 17:57:08 -0500
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CFE6C061574;
        Mon, 22 Nov 2021 14:54:01 -0800 (PST)
Received: by mail-pj1-x1041.google.com with SMTP id j6-20020a17090a588600b001a78a5ce46aso531755pji.0;
        Mon, 22 Nov 2021 14:54:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=J0U/HNFBN/Z88lQm+zSO8qaZA7o/gFCLKw/vkfFioNE=;
        b=hPKPCzmW4HAwe7763b1GWV5uRTmdazrlYavQgQCspnPOlxLoK3DFBfbrOeVAVnWHyH
         9fnRcAZ6SdUFNs4sxL1U8l94tE7jwFlwsbirw93ZjHoywBc4ZmjzVo2fcSlLbah5Dd8f
         2MUhCHP4l0aNRGFwgM91qQXsg65kBOSnozQF6Nfwrq3gk/uy34h5SiNnFhZIJcpZOtTR
         WIytAGg7cNBjnCIYXuw6BnL6a+yug8UeF2jkjAIqmktmdTxTaozRBj71F3bf/EBr36fg
         rZrKrn9XrwWysR0DQefPVvfD0H0jilSPELNSlXc8blWRQKcgN3EsoJFyiXyVVD9EmWa+
         p9xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=J0U/HNFBN/Z88lQm+zSO8qaZA7o/gFCLKw/vkfFioNE=;
        b=tA/aOCnRR7w/sXWjKLGZp5EH/pBaGGGISRxor4GlMzQl4N/NPi4UV6+czsNfPy0kNZ
         k55CLbS6LkdjB7K4lpL4vOt+t5PWXlu5cedP+UAJE3EkNuC9M7yfJ/jaIeususH5R+gS
         2lIZb91uzRg585w+aLhnrENxsJiYB7hWQCE8kPIC+ghewbtIfB3/VTczP3AcQLajfm6K
         pSMumduhOh6l4M9AJyInMrFb3/sryEu/NUiuY1nx/sBjlsCRLdT7SJk+QXQcroKL4tKZ
         nRKitx+8U0mmpZj5Aiov6Oxd8lzQaVmmrtyZE06KVwENdh2hQ5eCNZwO6e3tWEYMaR7A
         vYKg==
X-Gm-Message-State: AOAM531NdoMMnb1mPtXgSKr11zO6gJQpYnQaMNoUIB3dyYr2VdOjK2q6
        0G93G/QWplxZrA0D5CG9U9+A18AlYOA=
X-Google-Smtp-Source: ABdhPJwqMBK5szkR7m4WOI68wXC6C8VFQ5vQhiEkl9Cbul6Prx6bbAnfdFNArAQ0UUUetGbCPVZMrA==
X-Received: by 2002:a17:902:b78b:b0:143:baac:2ebc with SMTP id e11-20020a170902b78b00b00143baac2ebcmr881859pls.77.1637621640610;
        Mon, 22 Nov 2021 14:54:00 -0800 (PST)
Received: from localhost ([2405:201:6014:d064:3d4e:6265:800c:dc84])
        by smtp.gmail.com with ESMTPSA id mi18sm9087756pjb.13.2021.11.22.14.53.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Nov 2021 14:54:00 -0800 (PST)
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
Subject: [PATCH bpf-next v2 02/10] bpf: Add bpf_page_to_pfn helper
Date:   Tue, 23 Nov 2021 04:23:44 +0530
Message-Id: <20211122225352.618453-3-memxor@gmail.com>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211122225352.618453-1-memxor@gmail.com>
References: <20211122225352.618453-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=5140; h=from:subject; bh=rOV5lCBuFH8aSKAIvsZcxefNNOmVSy2xuQE8g9iRW3s=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBhnBrLiVPym0aFm0mjaUr81JCJT5JEQRIq085EtKRY eArmSXOJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYZwaywAKCRBM4MiGSL8RyrnlD/ 9NzSVCy2DuAIPyiz7gDbncEjCy/WH3ZW4/N4LcX/oyoBeDrS9Aj8NO0i8d25yuvoNSb/CiYZiFYPZQ JvGXJF6bj2SvxusP5pzf+nCgtFb95kUfVoI72eTXEmrJxr05F9RpeqVp54ymsWDs3yg3jjng9rWieV qDSTdPYg9fQ76LvltwTrEUlZY9Zj/Ow8z2+wrypmxcGlEWxXwsi5nmweaDMCfUCS1rDcHbWpr3r/Sc jXCwLdhgEiW/IYOpgkIHF/qxWnV1InGiB8vh78tXzdQX8oWhcxDOWmx1EtyCwhZ2uezSZlpwuV1rCf REFYM6hpGAcBd4jhz+g8Tj/cPf/uTQlUJit5G2OKMDBILBhsXp0+rQewiO34dddAvfJnTyzfc0BFP7 UVUi78jm8HRdFwGra45ixL+Q5BVGQ9aeXyzpAGRU/rmt5W6mYslxhrRiMHQb+vL14uSdMV93AYlIMZ o1RdFpYGZQm5sSin3l3cwjfbJh6dGlZFPptS7w8N1ViTpvFkFPy/RRwbw+xmx5O556ik0WXxeV/fKV mUUj1hccTWaVQngSAWAGPkjL57Rd3qOOS8tLWk0FtdnP9cglR5DWQOkGTJrK9MIHNmm7AWtBPacOQ5 0KKzAYXJiXN6sNyVGZux7J8NMLfXo8Pp6FT4TaDMzXgwDXnsFoEpkkH1xXBA==
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
2.34.0

