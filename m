Return-Path: <io-uring+bounces-11890-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id EDdbIXWacmnBmwAAu9opvQ
	(envelope-from <io-uring+bounces-11890-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 22 Jan 2026 22:45:25 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 249956DE9B
	for <lists+io-uring@lfdr.de>; Thu, 22 Jan 2026 22:45:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 85E75300B27E
	for <lists+io-uring@lfdr.de>; Thu, 22 Jan 2026 21:45:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B75F83A8FFD;
	Thu, 22 Jan 2026 21:45:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="e3L57Ppl"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qk1-f226.google.com (mail-qk1-f226.google.com [209.85.222.226])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64FF73815E7
	for <io-uring@vger.kernel.org>; Thu, 22 Jan 2026 21:45:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769118321; cv=none; b=KNmEVhHdT6VDuV9N4Lf+NzBap1BE7MhkON90hCNoBiysTqk0N1A0M4c1wP5Xp4Kh2KS84+8aIHjav4CDbXNuW3oZWfrcmKgypguecHiWhgcjHKdzSIjcDpXz+YL8pHnWTJqPPzZhPzXUKVQltBjPkBLAfwe+Dztur8m3IC7GKOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769118321; c=relaxed/simple;
	bh=LbXg6ikigd7m35dkXWzyE1HtQnksbRISnpxx2+K+xRU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=OR4kMaN3KTelVvINCZSd2471K/hu1K5PrzQ/1KNv5I9eKnPF1JpZxJDlkEhSVix+LglFTZI61fRakKNOqwt1DUH6ZPU9El5WFrMsRAD4MEvFr8F2A23BthZzxb1iyxXcPqhwe76ScWSPlQlo9qZZdp42XTA5axo/8X6nxHdDPqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=e3L57Ppl; arc=none smtp.client-ip=209.85.222.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-qk1-f226.google.com with SMTP id af79cd13be357-8c5369cd163so11619385a.0
        for <io-uring@vger.kernel.org>; Thu, 22 Jan 2026 13:45:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1769118309; x=1769723109; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=t6txbsgs8HpHiW8iS6Y8jI3CsFaklT7+HURLNdFd524=;
        b=e3L57Pplq7XI2bikqPb0CEi2qa2KR40SHxsaMHL0rozNbyrv0Q+j4RfjPu4Nx8hQd2
         7mr4abHvMNVs8d4BLa/8K29MnY3i8Ec5qEP7ccDLlMov8uzqjvkq6wmeY3/mUce9sL9Z
         5jvDWbJctB27EKfJU+XbBfeBRBZrFE11xEdcWNw6TDWgrekEvrZmIPFOkZjv9QpXnzmY
         nN5S6FF5VoFFPChefMxS2sdUyD+O4ZrC/5rzk2scc2663k897L0ne5XmP9yt/hBzgVpD
         GEXbo11Cv1ZRiyf2X8qk6DtBt6DaQwy+5BRKYOLzpCTm37TzJTSZRGiMrWXiCMwEhdtb
         C/6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769118309; x=1769723109;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=t6txbsgs8HpHiW8iS6Y8jI3CsFaklT7+HURLNdFd524=;
        b=HdH+73P4/nEDp8/MmSP0oPcN6NhjbXQdVdSZaCdAZGB22T3GQOSCueQpNPJ+y3kGbA
         56Pn7mEAG8+ncE1GEUMhW/Q463h7aj0Gh7dGNJetpSf53gPCoqZpQc6GBIVYDAPxsJvy
         1PbRJkI7xxvbMVej8jzJvvDlaCauNKQdR5tKxKqfxP7aTP05DaVqKqMmvxF7tuwL1Aly
         f3JnVlIEP2049HrkCJISBZTa63XhyvXa0XavID19v4plpcJtPYbYvOWQORHaLjOvf5F2
         66kjWl5yWPFRZNOAOmLTVfboerGRNchRg6dIwjzCQo82DV5sHs2c7xEilxJ1WbdfJ47N
         CZVg==
X-Forwarded-Encrypted: i=1; AJvYcCUK4ZeUNDcjgjHlXMjDCgywovrNmvOyfe6ptTC5xY81ILC089SBRtLmYt5kb2ymjl0mDBG5+lpzeA==@vger.kernel.org
X-Gm-Message-State: AOJu0YwCxLMLMJ+0MBEZb9YN3YrRZLoXmaWdhxKzZzJkb4CkTbpEfrwP
	uhZ5l+MMNtnb9rwRkAjUv18CmIbpNPRY9ttA2bkZepf7yFeiolX7rLqHNdWE2zxyDs1B+m1fpXi
	ecBrjPJSRC8CHnlc1xaktjdk78JVKIqyLkfDv
X-Gm-Gg: AZuq6aJigf2Mws5uCsv7Fp0cb241jrYePOsEPulfQBWlgBv+2ex6r6OdPOL1x7j8drB
	r6f0U/ewzXwCsym/qn5lXf8w2que2s7JLr+KpkyfOnMfYG9WrtDampq0+qsM/mFss6uBuqwPx8t
	t5EoLyoKWTe/lMnbQb8Q7kSqmAJGMO36myFguI4DY4JYZ4IENGYByasnNHMtgq4Ewi6E7yzwSLm
	Dg8vszMsgCegD0MXWLcgSUDae28BYYVk9SX1q8yD0w+q+WOqbzpDkzjGOsmV9KocrOnf7ojnqt9
	4QGeNPB+23j1K4DOYOuw3wdrnUVKO1BiZDc/aizYpovEJmB1KnuFetB2HPvH4MHtVTUpm5wOPRn
	YA0M4M6+IehvXFaM+pd0rzHnZFVgVslRkqQO5bHIPqQ==
X-Received: by 2002:a05:620a:29d3:b0:8b2:df32:b900 with SMTP id af79cd13be357-8c6e2d95f5cmr97390285a.4.1769118309206;
        Thu, 22 Jan 2026 13:45:09 -0800 (PST)
Received: from c7-smtp-2023.dev.purestorage.com ([208.88.159.128])
        by smtp-relay.gmail.com with ESMTPS id 6a1803df08f44-8949187ffd9sm527916d6.20.2026.01.22.13.45.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Jan 2026 13:45:09 -0800 (PST)
X-Relaying-Domain: purestorage.com
Received: from dev-csander.dev.purestorage.com (dev-csander.dev.purestorage.com [10.112.30.204])
	by c7-smtp-2023.dev.purestorage.com (Postfix) with ESMTP id 93B7D340572;
	Thu, 22 Jan 2026 14:45:08 -0700 (MST)
Received: by dev-csander.dev.purestorage.com (Postfix, from userid 1557716354)
	id 8113CE41BBE; Thu, 22 Jan 2026 14:45:08 -0700 (MST)
From: Caleb Sander Mateos <csander@purestorage.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Caleb Sander Mateos <csander@purestorage.com>,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] io_uring/rsrc: take unsigned index in io_rsrc_node_lookup()
Date: Thu, 22 Jan 2026 14:45:04 -0700
Message-ID: <20260122214506.88529-1-csander@purestorage.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[purestorage.com,reject];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[purestorage.com:s=google2022];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[purestorage.com:+];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-11890-lists,io-uring=lfdr.de];
	RCPT_COUNT_THREE(0.00)[4];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[csander@purestorage.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	NEURAL_HAM(-0.00)[-0.997];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns];
	TAGGED_RCPT(0.00)[io-uring];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Queue-Id: 249956DE9B
X-Rspamd-Action: no action

io_rsrc_node_lookup() takes a signed int index as input and compares it
to an unsigned length. Since the signed int is implicitly cast to an
unsigned int for the comparison and the length is bounded by
IORING_MAX_FIXED_FILES/IORING_MAX_REG_BUFFERS, negative indices are
already rejected on architectures where int is at least 32 bits. Make
this a bit clearer and avoid compiler warnings for comparisons of
signed and unsigned values by taking an unsigned int index instead.

Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
---
 io_uring/rsrc.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
index d603f6a47f5e..4a5db2ad1af2 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -88,11 +88,11 @@ int io_validate_user_buf_range(u64 uaddr, u64 ulen);
 
 bool io_check_coalesce_buffer(struct page **page_array, int nr_pages,
 			      struct io_imu_folio_data *data);
 
 static inline struct io_rsrc_node *io_rsrc_node_lookup(struct io_rsrc_data *data,
-						       int index)
+						       unsigned int index)
 {
 	if (index < data->nr)
 		return data->nodes[array_index_nospec(index, data->nr)];
 	return NULL;
 }
-- 
2.45.2


