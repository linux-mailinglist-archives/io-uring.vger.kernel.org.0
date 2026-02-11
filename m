Return-Path: <io-uring+bounces-12158-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id OBH/IC+bjGlkrgAAu9opvQ
	(envelope-from <io-uring+bounces-12158-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 11 Feb 2026 16:07:27 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 00636125712
	for <lists+io-uring@lfdr.de>; Wed, 11 Feb 2026 16:07:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 2E70E305FC4B
	for <lists+io-uring@lfdr.de>; Wed, 11 Feb 2026 15:06:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34F7A2C032E;
	Wed, 11 Feb 2026 15:06:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="YuXaFKeR"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f65.google.com (mail-ot1-f65.google.com [209.85.210.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CBDB295D90
	for <io-uring@vger.kernel.org>; Wed, 11 Feb 2026 15:06:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770822395; cv=none; b=uzjk90kAAPyia2EfmmXhCfNVfR5s1O2L+VompTc5cizW7oCe3TwXNDTYEBR2qpw6DqtZRMuWN4QgtvEW2odpAmYVudGfUo9Y+BjJZiu2MaMhIvT8PTZpKcQ4pUPCMnfWG9FUxFF69iGlO37AYxRRCA2fEuD585INt1Ecqan3YI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770822395; c=relaxed/simple;
	bh=Ur2H12Ua9CNNew448/VtMyv9yqavPoVJsazEl9i/oiQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pQdeONluFu41e3+ZDL6YWHIpiK5tTyHh2SvAOpOhh9wI/nSUQcSfEuAuYYdp/OnfCiCRiofL5o/6qWCwg9SlAbYqY4Ddh2f4EJhrYEOO+LN/99B1c8n4wNnnzE8WJGJ16Mbyoidprb3BdyOzdr/qlaenoXg7Q4qI1LGVEP0B+b8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=YuXaFKeR; arc=none smtp.client-ip=209.85.210.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f65.google.com with SMTP id 46e09a7af769-7d15b8feca3so2016913a34.3
        for <io-uring@vger.kernel.org>; Wed, 11 Feb 2026 07:06:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1770822392; x=1771427192; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IcnQ81G+uIBrhVGOF+QN/9Ez3LBo5RRyKc7qQzoeHh8=;
        b=YuXaFKeRe6L4IgJrfthsEAZp/iU74jQxcy4WZ5kqn+nSHiOrdMCTiC1wHU0H3j3nZ1
         O7fgHrNIqXINWwcZfMKO7LF+Fb1a59HbE/S6giHf/7sOKSf6yu3wdiizyxAodGirDRVI
         GIvqBieTxsx9RfJFL/BqhB+cClmlTLB8xsTiYIe9sJZiaDkaZ9ijtebMuARwfN/aI+pl
         9+wBfC1WCcdact2qw9TRcjALamakYmIqD8dxnVcHlaEHDHbMUkgYMU4Y23fUDFVxy2nM
         yI5V98cLK8DNBBnRSWIaP0NXOPZriK0FaqUy4p3mveeecJnY1OX7uQRqCF2+dcmPWvFK
         D+sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770822392; x=1771427192;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=IcnQ81G+uIBrhVGOF+QN/9Ez3LBo5RRyKc7qQzoeHh8=;
        b=QTMIG6iKEBvpofYwcORKwn7MNcVasCqsRc74yZGReIiJwo4Fp6kqS1JWyEwnCXUmM1
         wd+zqfLC+iGLO9RBdFPN5B+hDhQsxbZwBNUwu91g1acOrqAmz6OhoR15bt4yqhTk47SU
         Kn4z6/pFMcfXWo65FGh4rO4FZnqh/M0oG5jonw3k9s6zDVSwaXymU6x1NkPPkMYpxSLU
         O/BUIHxpuB7xox46aQjgI0YjFGqcBs9WhRmOT77MR/6d/gi292hBK48Hphsl6eNT5ZcM
         MjeApbYDEy8JjEytslsbfM8MCtcmmqHqsu+kwdvi9WVXnUbyqgS/EEgZWL4oe1m+brJ/
         dsig==
X-Gm-Message-State: AOJu0Yz/+hi4VCtpw3gy3ChwhSFGjZnYEKlAPK4vacjmP1lJLtmQ9qbT
	vPbgML+n+1MUpwi/iB0TWvIpwjWwgAKhnmboiqOw+slDmdsbDZaBdXCZ7HldUsWwrogWqpYNpTX
	+HofZXedy1A==
X-Gm-Gg: AZuq6aIy6fNhZtdr2wcRmrH4g3nVPoi5lSxDgFiuv0O0wPPiYZudrLMkEE1o7PPm5gJ
	siAJ5ON15Edsy96Ul34sTBOUfOdm1InmfFBwnNUOik/x44WJRZYkoJZTo3pV10DeuiMlUC8mER7
	xEEFmwisdVUzGY3vZMCuRAKPAguPM3nPjjK/N4EMShIszRcDNd7fsyDT1Ieo5DR+oAK1t2M9I5W
	gr1KcdeMu6G/dVvq44lV04nVUkuMOC8T3RPOIVFfy3/k0+Z7VtszS7sMzjkrebxwBDcMEyfbka7
	JcSni6rNdNu0Is24RmGzfCqGs1kv9JRKxoVtFWZI46pKko9nEzt4Prn8qYkeKgRrkOveNCdRc42
	Cj7bsF6vvgF4NatGsEhR2flsEjuWIMi+9+W2dmdp5UG/rKaSccAOglMw8EhLwXAr2wh7TTtEZe9
	YlyY9wRA9XyruhW8cpQ1p+DZTohQkG7iB0+aBDYocPdgTC8rLgXOW1Bpqc2GQmK0U8DGF1
X-Received: by 2002:a05:6830:638a:b0:7c6:d0b2:8eb6 with SMTP id 46e09a7af769-7d464411072mr11742100a34.15.1770822391952;
        Wed, 11 Feb 2026 07:06:31 -0800 (PST)
Received: from m2max ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-40eaf16c383sm1462414fac.14.2026.02.11.07.06.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Feb 2026 07:06:31 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: brauner@kernel.org,
	linux-kernel@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/2] io_uring/bpf_filter: pass in expected filter payload size
Date: Wed, 11 Feb 2026 08:01:18 -0700
Message-ID: <20260211150626.136826-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260211150626.136826-1-axboe@kernel.dk>
References: <20260211150626.136826-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12158-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	RCVD_COUNT_FIVE(0.00)[5];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kernel-dk.20230601.gappssmtp.com:dkim,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 00636125712
X-Rspamd-Action: no action

It's quite possible that opcodes that have payloads attached to them,
like IORING_OP_OPENAT/OPENAT2 or IORING_OP_SOCKET, that these paylods
can change over time. For example, on the openat/openat2 side, the
struct open_how argument is extensible, and could be extended in the
future to allow further arguments to be passed in.

Allow registration of a cBPF filter to give the size of the filter as
seen by userspace. If that filter is for an opcode that takes extra
payload data, allow it if the application payload expectation is the
same size than the kernels. If that is the case, the kernel supports
filtering on the payload that the application expects. If the size
differs, the behavior depends on the IO_URING_BPF_FILTER_SZ_STRICT flag:

1) If IO_URING_BPF_FILTER_SZ_STRICT is set and the size expectation
   differs, fail the attempt to load the filter.

2) If IO_URING_BPF_FILTER_SZ_STRICT isn't set, allow the filter if
   the userspace pdu size is smaller than what the kernel offers.

3) Regardless if IO_URING_BPF_FILTER_SZ_STRICT, fail loading the filter
   if the userspace pdu size is bigger than what the kernel supports.

An attempt to load a filter due to sizing will error with -EMSGSIZE.
For that error, the registration struct will have filter->pdu_size
populated with the pdu size that the kernel uses.

Reported-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/uapi/linux/io_uring/bpf_filter.h |  8 ++-
 io_uring/bpf_filter.c                    | 65 ++++++++++++++++++------
 2 files changed, 56 insertions(+), 17 deletions(-)

diff --git a/include/uapi/linux/io_uring/bpf_filter.h b/include/uapi/linux/io_uring/bpf_filter.h
index 220351b81bc0..1b461d792a7b 100644
--- a/include/uapi/linux/io_uring/bpf_filter.h
+++ b/include/uapi/linux/io_uring/bpf_filter.h
@@ -35,13 +35,19 @@ enum {
 	 * If set, any currently unset opcode will have a deny filter attached
 	 */
 	IO_URING_BPF_FILTER_DENY_REST	= 1,
+	/*
+	 * If set, if kernel and application don't agree on pdu_size for
+	 * the given opcode, fail the registration of the filter.
+	 */
+	IO_URING_BPF_FILTER_SZ_STRICT	= 2,
 };
 
 struct io_uring_bpf_filter {
 	__u32	opcode;		/* io_uring opcode to filter */
 	__u32	flags;
 	__u32	filter_len;	/* number of BPF instructions */
-	__u32	resv;
+	__u8	pdu_size;	/* expected pdu size for opcode */
+	__u8	resv[3];
 	__u64	filter_ptr;	/* pointer to BPF filter */
 	__u64	resv2[5];
 };
diff --git a/io_uring/bpf_filter.c b/io_uring/bpf_filter.c
index 8ac7d06de122..4e1dd955c8c4 100644
--- a/io_uring/bpf_filter.c
+++ b/io_uring/bpf_filter.c
@@ -308,36 +308,69 @@ static struct io_bpf_filters *io_bpf_filter_cow(struct io_restriction *src)
 	return ERR_PTR(-EBUSY);
 }
 
-#define IO_URING_BPF_FILTER_FLAGS	IO_URING_BPF_FILTER_DENY_REST
+#define IO_URING_BPF_FILTER_FLAGS	(IO_URING_BPF_FILTER_DENY_REST | \
+					 IO_URING_BPF_FILTER_SZ_STRICT)
 
-int io_register_bpf_filter(struct io_restriction *res,
-			   struct io_uring_bpf __user *arg)
+static int io_bpf_filter_import(struct io_uring_bpf *reg,
+				struct io_uring_bpf __user *arg)
 {
-	struct io_bpf_filters *filters, *old_filters = NULL;
-	struct io_bpf_filter *filter, *old_filter;
-	struct io_uring_bpf reg;
-	struct bpf_prog *prog;
-	struct sock_fprog fprog;
+	const struct io_issue_def *def;
 	int ret;
 
-	if (copy_from_user(&reg, arg, sizeof(reg)))
+	if (copy_from_user(reg, arg, sizeof(*reg)))
 		return -EFAULT;
-	if (reg.cmd_type != IO_URING_BPF_CMD_FILTER)
+	if (reg->cmd_type != IO_URING_BPF_CMD_FILTER)
 		return -EINVAL;
-	if (reg.cmd_flags || reg.resv)
+	if (reg->cmd_flags || reg->resv)
 		return -EINVAL;
 
-	if (reg.filter.opcode >= IORING_OP_LAST)
+	if (reg->filter.opcode >= IORING_OP_LAST)
 		return -EINVAL;
-	if (reg.filter.flags & ~IO_URING_BPF_FILTER_FLAGS)
+	if (reg->filter.flags & ~IO_URING_BPF_FILTER_FLAGS)
 		return -EINVAL;
-	if (reg.filter.resv)
+	if (!mem_is_zero(reg->filter.resv, sizeof(reg->filter.resv)))
 		return -EINVAL;
-	if (!mem_is_zero(reg.filter.resv2, sizeof(reg.filter.resv2)))
+	if (!mem_is_zero(reg->filter.resv2, sizeof(reg->filter.resv2)))
 		return -EINVAL;
-	if (!reg.filter.filter_len || reg.filter.filter_len > BPF_MAXINSNS)
+	if (!reg->filter.filter_len || reg->filter.filter_len > BPF_MAXINSNS)
 		return -EINVAL;
 
+	/* Verify filter size */
+	def = &io_issue_defs[reg->filter.opcode];
+
+	/* same size, always ok */
+	ret = 0;
+	if (reg->filter.pdu_size == def->filter_pdu_size)
+		;
+	/* size differs, fail in strict mode */
+	else if (reg->filter.flags & IO_URING_BPF_FILTER_SZ_STRICT)
+		ret = -EMSGSIZE;
+	/* userspace filter is bigger, always disallow */
+	else if (reg->filter.pdu_size > def->filter_pdu_size)
+		ret = -EMSGSIZE;
+
+	/* copy back kernel filter size */
+	reg->filter.pdu_size = def->filter_pdu_size;
+	if (copy_to_user(&arg->filter, &reg->filter, sizeof(reg->filter)))
+		return -EFAULT;
+
+	return ret;
+}
+
+int io_register_bpf_filter(struct io_restriction *res,
+			   struct io_uring_bpf __user *arg)
+{
+	struct io_bpf_filters *filters, *old_filters = NULL;
+	struct io_bpf_filter *filter, *old_filter;
+	struct io_uring_bpf reg;
+	struct bpf_prog *prog;
+	struct sock_fprog fprog;
+	int ret;
+
+	ret = io_bpf_filter_import(&reg, arg);
+	if (ret)
+		return ret;
+
 	fprog.len = reg.filter.filter_len;
 	fprog.filter = u64_to_user_ptr(reg.filter.filter_ptr);
 
-- 
2.51.0


