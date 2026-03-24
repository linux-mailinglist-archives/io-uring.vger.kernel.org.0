Return-Path: <io-uring+bounces-12829-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cOgxNCHAwmmjlQQAu9opvQ
	(envelope-from <io-uring+bounces-12829-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 24 Mar 2026 17:47:29 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 73BFD31951F
	for <lists+io-uring@lfdr.de>; Tue, 24 Mar 2026 17:47:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 2620330AB639
	for <lists+io-uring@lfdr.de>; Tue, 24 Mar 2026 16:39:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C7D33FADFB;
	Tue, 24 Mar 2026 16:38:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EXCjbd4n"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC8993F23A1
	for <io-uring@vger.kernel.org>; Tue, 24 Mar 2026 16:38:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774370327; cv=none; b=WC7qaHjnh6BnEfuzbMg4J+6eVYY65016bQZlUgkmopdyDealsef4NkXWujH8MN59bpRGxKHFFoovutKWf06Zscxel/joBFVxW3xZ0nUvmUpz3SSfZPj7DzT3jiHi7UGBiG3tcgf7jLffI+onLG09ugB1k8tIxkmOvQfVX20h4mI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774370327; c=relaxed/simple;
	bh=UOvR3XhovobpqynbHGCU0fQNnvU65IjeegMHC/thJIA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PiqqTIsesHNe5VSWLZkgW/uZtfagqZBBldWRdRQUyWQrisnCzxnSqx9kJxODc6cBcqkdpa1nfk6DWlw5oCV2w04lm89QEqOt9AlH4JKkIn93fkwx3m8d9rRJZA+BBc2M/YAQHZy1DoUyIcMqjSoEsWD3Ehn0slOXXyGwy3kn5dw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EXCjbd4n; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774370325;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VbFekKwlwoU0LVMo/vSEonlhfTZg1THOxfIgQfbCYAg=;
	b=EXCjbd4nRlE3SuaMuUZtRf3/7SH3jj1GZiTEDitCnZgDMAVV3q/drGnD7KkBV5dor9W2bQ
	vaQa/icWHDMBYUWobqpSxz9fUThLzg1gy1wkSk/bsT9VZ7XhHva1v2cSCJ+1zEqr3vpY8F
	zfog+NsQZCB/T99oKM/i0EiypCu+KXE=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-15-ySqUa4I0NWSbuQOfiAzPgg-1; Tue,
 24 Mar 2026 12:38:43 -0400
X-MC-Unique: ySqUa4I0NWSbuQOfiAzPgg-1
X-Mimecast-MFC-AGG-ID: ySqUa4I0NWSbuQOfiAzPgg_1774370322
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 66BC1195608E;
	Tue, 24 Mar 2026 16:38:42 +0000 (UTC)
Received: from localhost (unknown [10.72.116.133])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 77E361955F21;
	Tue, 24 Mar 2026 16:38:41 +0000 (UTC)
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>,
	io-uring@vger.kernel.org
Cc: Caleb Sander Mateos <csander@purestorage.com>,
	Akilesh Kailash <akailash@google.com>,
	bpf@vger.kernel.org,
	Xiao Ni <xni@redhat.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V3 09/12] bpf: add bpf_uring_buf_dynptr to special_kfunc_list
Date: Wed, 25 Mar 2026 00:37:30 +0800
Message-ID: <20260324163753.1900977-10-ming.lei@redhat.com>
In-Reply-To: <20260324163753.1900977-1-ming.lei@redhat.com>
References: <20260324163753.1900977-1-ming.lei@redhat.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[redhat.com:+];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12829-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ming.lei@redhat.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	RCPT_COUNT_SEVEN(0.00)[8];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 73BFD31951F
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Register bpf_uring_buf_dynptr() and bpf_uring_buf_dynptr_rdwr() in the
verifier's special_kfunc_list so they can produce LOCAL dynptrs.
Without these entries, the verifier cannot determine the dynptr type
for the __uninit output parameter.

We cannot reuse the existing bpf_dynptr_from_mem() helper because
kfunc PTR_TO_MEM returns are always marked MEM_RDONLY by the verifier
(meta.r0_rdonly = true), but bpf_dynptr_from_mem() requires writable
memory (ARG_PTR_TO_UNINIT_MEM).  A dedicated kfunc with a
special_kfunc_list entry is the only way to produce a dynptr from
read-only kernel-provided memory.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 kernel/bpf/verifier.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 159b25f8269d..42d0672336e1 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -12531,6 +12531,8 @@ enum special_kfunc_type {
 	KF_bpf_session_is_return,
 	KF_bpf_stream_vprintk,
 	KF_bpf_stream_print_stack,
+	KF_bpf_uring_buf_dynptr,
+	KF_bpf_uring_buf_dynptr_rdwr,
 };
 
 BTF_ID_LIST(special_kfunc_list)
@@ -12611,6 +12613,13 @@ BTF_ID(func, bpf_arena_reserve_pages)
 BTF_ID(func, bpf_session_is_return)
 BTF_ID(func, bpf_stream_vprintk)
 BTF_ID(func, bpf_stream_print_stack)
+#ifdef CONFIG_IO_URING_BPF_EXT
+BTF_ID(func, bpf_uring_buf_dynptr)
+BTF_ID(func, bpf_uring_buf_dynptr_rdwr)
+#else
+BTF_ID_UNUSED
+BTF_ID_UNUSED
+#endif
 
 static bool is_task_work_add_kfunc(u32 func_id)
 {
@@ -13590,6 +13599,9 @@ static int check_kfunc_args(struct bpf_verifier_env *env, struct bpf_kfunc_call_
 				dynptr_arg_type |= DYNPTR_TYPE_SKB_META;
 			} else if (meta->func_id == special_kfunc_list[KF_bpf_dynptr_from_file]) {
 				dynptr_arg_type |= DYNPTR_TYPE_FILE;
+			} else if (meta->func_id == special_kfunc_list[KF_bpf_uring_buf_dynptr] ||
+				   meta->func_id == special_kfunc_list[KF_bpf_uring_buf_dynptr_rdwr]) {
+				dynptr_arg_type |= DYNPTR_TYPE_LOCAL;
 			} else if (meta->func_id == special_kfunc_list[KF_bpf_dynptr_file_discard]) {
 				dynptr_arg_type |= DYNPTR_TYPE_FILE;
 				meta->release_regno = regno;
-- 
2.53.0


