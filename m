Return-Path: <io-uring+bounces-12815-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4MlAM8TXwWkaXQQAu9opvQ
	(envelope-from <io-uring+bounces-12815-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 24 Mar 2026 01:16:04 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 651632FF772
	for <lists+io-uring@lfdr.de>; Tue, 24 Mar 2026 01:16:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 3EFD93084E44
	for <lists+io-uring@lfdr.de>; Tue, 24 Mar 2026 00:10:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D533E17BA6;
	Tue, 24 Mar 2026 00:10:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CTBERA/2"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B305617C69
	for <io-uring@vger.kernel.org>; Tue, 24 Mar 2026 00:10:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774311021; cv=none; b=C6ZRUqGl6aSfY8t6t7/vCsmCSE5Orw24e540Mnzn96UOnpn3h59dxmGr2CFgMUQbS89C9JJT9lMD8bkRILurDF8HbdZ2WwhgoaTh2RQQ6JLAaJxGXZbbpCqfIFPQB0+nzSxsRcKKLfjQnjshItpD0V67IWX7dEPya1YnR6Y6H7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774311021; c=relaxed/simple;
	bh=kPg+WSX/3w9rtK5s83u9GEDb3rIwG9uCMGDk+fSBaOg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d1pM3sJq8n75njkKRGOJvFiyfhHDw/T1RouXhJZbpaZUj7aP3CwoRGyyTjA8rzZyeFG1wI6NwiE0KhY3aezBMVbsfBmqVkzu/m+ClQBGCvMFaQHjVaFYXLY9Tswm9HfqnpQtZ+DmjqmJKFN+lf649L+/dhK+EG5mzDHlVCkPZEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CTBERA/2; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-35a1cc6e478so409384a91.0
        for <io-uring@vger.kernel.org>; Mon, 23 Mar 2026 17:10:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774311020; x=1774915820; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BQ7zrQH9IBCTkVv+0TDTxarrhF/tMaEGuj/Xnx3/7YA=;
        b=CTBERA/2y6J+jndgMRR0k2xl6U80VaaZpKWlBUgSXFg32mDGYpRzsINMwGQIvonEot
         p6TaqTG2Olhdf0ggUBovyFpqzkrKSBA3xERV9JiBUZOy3nD7uP6jHu2Bcxfl/VJTS8ZX
         hFDMWJl2/yOK0Byjgpm4qjP/3qXa8V8JSbJp8EvvRCbYOo0A9wwgZvec6yqMQdejPJw1
         uB9x7S/GMLkzO0XnLJLlaTZ06J8kW4u6PySuEtMcXlBWIo4Flu7E2td3+xJ+3JfgC36F
         dLqBvuC0OvV8k4vtujwzBOOXFaCkOSD8mr8AoOYrXUeP/gvWhmFDbKopW8eDP8C5sn3I
         w9Bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774311020; x=1774915820;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=BQ7zrQH9IBCTkVv+0TDTxarrhF/tMaEGuj/Xnx3/7YA=;
        b=ptzx4+jURI9j9vIPJkiK6zIooUlIOuCtLKYdJoLiBXnNf+DXWWPAxsZVEdb7WStDP6
         Z62sJyCxiPIAU8MipReyKcRHYIbb8kto4tafkQC2GzyBW+pkpKA6sz+OX3FuZS8sO2qL
         LVtJwHk+KnUmf49bg1IRaFLIEb3O98m0Bvac+LmNdPBARzruMxwWngmqjl5Qvub7LJnI
         NxjK1S90tCWKo6g0NORZYUXc56DTR4Yv45af6b9Dhb0GaCDPMN3MVPNegPVTv3T/Gq4h
         0Z4q0/iYcSrBjcR6VV0j7hy5dYWcgqNww2tgZH2g0HoNRs6v2/p/amc3KwiUR+FjHm0o
         1qUA==
X-Forwarded-Encrypted: i=1; AJvYcCVZYCnwKy82baQvQXbBElr51NoZd9VRtyg/1KScpZUWvmH9jVK7VQYW375x+Ma/GihgsUf00L2BXg==@vger.kernel.org
X-Gm-Message-State: AOJu0YxKbj1alm81q0vrS7Ax+EKpKws30FfeGwD60PwDEUG6tt+FmZMx
	Wj55eGUe7P4JouH1iGEc3yo8VKPHManaplnzPHZXy9p+5WxfSaONq8dV
X-Gm-Gg: ATEYQzzX0yU7XdV3p//Ua5WpeEf58dBXxbBUSd/RVL0raMV3ojopYq1g/44Fec9SbOR
	N1g96TAvCba3tcWlPenlTH7lqivNnP56Pw0//57t3XSkSAEyUknZFrHiGolKuQ+zVGZssQka4bK
	YEvYSHmc/YuJjzW5ltvcFh3h6d8KLpRjdKIvsWgBcOM/y4KtTr3kddwy7LoL7wiBNTbJR6vACCk
	JVfNtLdaYZ55yUPn2PAdb+/YhfV7BYOprnBWXloRjc9ZYstl6Ds2mNx6CyW5A2rdPLmDAG/A04H
	O4jDySke77FRFseLltS1ol0LZOpJKEjvCpPICJNARDi8cwjnbaHmyuSbqcaYI4Qs0Di2t5EDP23
	VysIKqRjA/nHedSxb2fX0aNtiFgaE516nRlsux0ID1BlEV0DeOPe2oETkeG7IUcPofyQL7qVGu5
	0EoGZVfMcFthjvz4s4ksP6vC/FXXAs
X-Received: by 2002:a17:90b:5281:b0:35b:9777:8bae with SMTP id 98e67ed59e1d1-35bd2cb70b2mr13251644a91.21.1774311019900;
        Mon, 23 Mar 2026 17:10:19 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:46::])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c743a7ff961sm7875807a12.5.2026.03.23.17.10.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Mar 2026 17:10:19 -0700 (PDT)
From: Joanne Koong <joannelkoong@gmail.com>
To: axboe@kernel.dk
Cc: csander@purestorage.com,
	asml.silence@gmail.com,
	io-uring@vger.kernel.org
Subject: [PATCH v1 3/5] io_uring/rsrc: allow buffer release callback to be optional
Date: Mon, 23 Mar 2026 17:10:05 -0700
Message-ID: <20260324001007.1144471-4-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260324001007.1144471-1-joannelkoong@gmail.com>
References: <20260324001007.1144471-1-joannelkoong@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [0.84 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[purestorage.com,gmail.com,vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12815-lists,io-uring=lfdr.de];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCPT_COUNT_THREE(0.00)[4];
	PRECEDENCE_BULK(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	FROM_NEQ_ENVFROM(0.00)[joannelkoong@gmail.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	NEURAL_HAM(-0.00)[-1.000];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[purestorage.com:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 651632FF772
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

This is a preparatory patch for supporting kernel-populated buffers in
fuse io-uring, which does not need a release callback.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
Reviewed-by: Caleb Sander Mateos <csander@purestorage.com>
---
 io_uring/rsrc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 1902ab7941ac..3a89eec9265f 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -133,7 +133,8 @@ static void io_buffer_unmap(struct io_ring_ctx *ctx, struct io_mapped_ubuf *imu)
 
 	if (imu->acct_pages)
 		io_unaccount_mem(ctx->user, ctx->mm_account, imu->acct_pages);
-	imu->release(imu->priv);
+	if (imu->release)
+		imu->release(imu->priv);
 	io_free_imu(ctx, imu);
 }
 
-- 
2.52.0


