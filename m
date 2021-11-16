Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D2A2452A2B
	for <lists+io-uring@lfdr.de>; Tue, 16 Nov 2021 06:59:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240362AbhKPGBu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 16 Nov 2021 01:01:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240161AbhKPGBm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 16 Nov 2021 01:01:42 -0500
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64953C061231;
        Mon, 15 Nov 2021 21:42:46 -0800 (PST)
Received: by mail-pl1-x642.google.com with SMTP id m24so6464471pls.10;
        Mon, 15 Nov 2021 21:42:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=u0lClWPrvD/K1h3LgglE1rPein98w8QPLX7xeqet6rg=;
        b=nIqUjdyXfJIJlTHhj+Wzyv5kOeWFHiXSJZu1cjHSdZG33TPnsO5MB5aE1C4JRgbtaA
         mmhKCAE2v4vfeZS8dZyaB3lwRc023VndgcC/ExPox3+4v3mjg8dHhbARHl1NYWFYfOY3
         JkBfc1Yk/ZgIMZocQUQnP+XsrCr3KO1PZKwp1j6PrDgRO2dDh3zhcwJoTZwI5uNBK/MH
         xgxszz7O26rszx8vfFXErmfnomFI0sDoPR8U+EEv43b+mccAYfqTuEqPJknnqKqUotO3
         yPdZqUlX1lOc0cf5SPZjgTYVd0TWGOHfMYtu4YCIJG56ntaOU6JFOt44q69q7Y3kAB7I
         73qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=u0lClWPrvD/K1h3LgglE1rPein98w8QPLX7xeqet6rg=;
        b=A5MSi2YKDzd8AjitE2dJKq+G1l2y3zeFE2p8rzjrDs6DmktTjl9UikjKzZp/5EGNO7
         o5gQYLL6Aq4SxcI6DH7PbH5EhvHnWqLb8HmoXbP6lPBbbDWbkUjZ65rJsZo2Z7u26Ym5
         Nn67jenQ1ReJ5gy4rwgiuFjfAXgPiKyT2+a1gUHa3hw8sgC303hgn/ITLqVKX6rmL1iT
         h5cpmq2FBS64GOzGGB68NNEU/rEcJWTuTiYSuibKUvq4495JaTUdeliV5PO0sZF6HS33
         bBv1A3OC3PBlb+lIPmhS6Xzc1zz/276b9pUQMxb6cxCQdZgT2AYF3uEhfC1c4bIZBCyB
         1gkQ==
X-Gm-Message-State: AOAM530DMoPu42PQVM7VC0HU2xXhRnk0sGJshVqjLz4xynjFSBkqoFKD
        405zlVmGP60ANXx8Nq9EnbDIjn7FmVw=
X-Google-Smtp-Source: ABdhPJxBGz/SRjgi7l0L6Q8eXVANhWP0NXj0Z57F/L2e+Rs3ReTGP+o5KTksilGOD6ZaEh1ojs4kUg==
X-Received: by 2002:a17:90a:4b47:: with SMTP id o7mr35592429pjl.92.1637041365620;
        Mon, 15 Nov 2021 21:42:45 -0800 (PST)
Received: from localhost ([2405:201:6014:d064:3d4e:6265:800c:dc84])
        by smtp.gmail.com with ESMTPSA id ne22sm1002573pjb.18.2021.11.15.21.42.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Nov 2021 21:42:45 -0800 (PST)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Pavel Emelyanov <ovzxemul@gmail.com>,
        Alexander Mihalicyn <alexander@mihalicyn.com>,
        Andrei Vagin <avagin@gmail.com>, criu@openvz.org,
        io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH bpf-next v1 2/8] bpf: Add bpf_page_to_pfn helper
Date:   Tue, 16 Nov 2021 11:12:31 +0530
Message-Id: <20211116054237.100814-3-memxor@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211116054237.100814-1-memxor@gmail.com>
References: <20211116054237.100814-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=5296; h=from:subject; bh=vnwFxGdaJpBG++VBChgGlEBqIAnV9UjRswVX4pSbVSY=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBhk0S6qXxy7qrRuQKRRKAIPrBzMZcEaYxS3VShsUn5 OQUSrtCJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYZNEugAKCRBM4MiGSL8RyhmCEA CscqOFYalotS2DTRoBPvy+r8xLyKJ9AzMEnwRUfcK8OrSzIJn1n8mjRyGwBLnkShbC94pmq54fcxXx 0WJDgl0PUrIhxw2FIDbSOTI+RciU1hO9DSY6cH0dCa5JF6WpDBim2rDb+4UUs2tR9f0TOGKTUvummc DBBLKcgdrMbBh4fedbPK5UgB8elzM+BNFyvOgrkOfCBiiUjI312Y0qrM8TxK9XJjrsGQp90KTPwMP8 C2eg2HRa0yhmTwpCXqJWAYTz2yAPWyM/EYhV1nZfTqFM0zcc/CIqCjwJtV0d7Ccj1UzxIGa3lq9HoP q0X2aQPvQOO29lW/t+yf0sRsNE+VKqGkUAcAQAtdfQ3oL2+IUXmYT3LfArA4zrv30TpRX+M0sJXCOi v3L2MWELIX6XB00e+waSAi9dN1WU02dCILGZBpkQJm3Q70XrZRHSmT5DlXEc6ZaV5lcpySztIE9A7G mgc1FVeMk+mEVmTSRgiUtDJ5RhR8tEeN9YCwFqA8VYCUq0wA4Uort0i/mWa2KZmQOt7UJwjB8LsgH8 pFioVZsNj3J8uDiFf8LtR5F4nISevNB3Jn3/fR3DvLgmOQrnbOOFqNib6tlrNuuhUN1h5Mtig38IiB MgQLSNT6evdzBFcBY4rEsGQ+UcpQ2ZMocvXot1b0sszN4WPKQsr3NUPzryIA==
X-Developer-Key: i=memxor@gmail.com; a=openpgp; fpr=4BBE2A7E06ECF9D5823C61114CE0C88648BF11CA
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

In CRIU, we need to be able to determine whether the page pinned by
io_uring is still present in the same range in the process VMA.
/proc/<pid>/pagemap gives us the PFN, hence using this helper we can
establish this mapping easily from the iterator side.

It is a simple wrapper over the in-kernel page_to_pfn helper, and
ensures the passed in pointer is a struct page PTR_TO_BTF_ID. This is
obtained from the bvec of io_uring_ubuf for the CRIU usecase.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 fs/io_uring.c                  | 17 +++++++++++++++++
 include/linux/bpf.h            |  1 +
 include/uapi/linux/bpf.h       |  9 +++++++++
 kernel/trace/bpf_trace.c       |  2 ++
 scripts/bpf_doc.py             |  2 ++
 tools/include/uapi/linux/bpf.h |  9 +++++++++
 6 files changed, 40 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 46a110989155..9e9df6767e29 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -11295,6 +11295,23 @@ static struct bpf_iter_reg io_uring_buf_reg_info = {
 	.seq_info	   = &bpf_io_uring_buf_seq_info,
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
 static int __init io_uring_iter_init(void)
 {
 	io_uring_buf_reg_info.ctx_arg_info[0].btf_id = btf_io_uring_ids[0];
diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index ddb9d4520a3f..fe7b499da781 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -2166,6 +2166,7 @@ extern const struct bpf_func_proto bpf_sk_setsockopt_proto;
 extern const struct bpf_func_proto bpf_sk_getsockopt_proto;
 extern const struct bpf_func_proto bpf_kallsyms_lookup_name_proto;
 extern const struct bpf_func_proto bpf_find_vma_proto;
+extern const struct bpf_func_proto bpf_page_to_pfn_proto;
 
 const struct bpf_func_proto *tracing_prog_func_proto(
   enum bpf_func_id func_id, const struct bpf_prog *prog);
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 3323defa99a1..b70e9da3d722 100644
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
index 25ea521fb8f1..f68a8433be1a 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -1212,6 +1212,8 @@ bpf_tracing_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
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
index 3323defa99a1..b70e9da3d722 100644
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
2.33.1

