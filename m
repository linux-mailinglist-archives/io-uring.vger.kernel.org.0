Return-Path: <io-uring+bounces-12478-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SDVLCiMcomnqzQQAu9opvQ
	(envelope-from <io-uring+bounces-12478-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 27 Feb 2026 23:35:15 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 9DE8D1BEB71
	for <lists+io-uring@lfdr.de>; Fri, 27 Feb 2026 23:35:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 86A40301DC2A
	for <lists+io-uring@lfdr.de>; Fri, 27 Feb 2026 22:35:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93ED347B409;
	Fri, 27 Feb 2026 22:35:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="G3vY3kzy"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qt1-f226.google.com (mail-qt1-f226.google.com [209.85.160.226])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2947043E9ED
	for <io-uring@vger.kernel.org>; Fri, 27 Feb 2026 22:35:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772231710; cv=none; b=D7VatRvnbnbNsR+JVpkL2/VVTeEccpZZmXVOINQVzoP37cbwwHzel2kjyHAGY+4KAObl85lMFfZBaf0Dpb03eG8olik/HYqK+u19EFi1/+VrWLQ5yy5hWwwvQmx6b/Lto1Hk6DstTTWPeRk48/KeYcNXcuLwOpubdCK6mo6B5Oo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772231710; c=relaxed/simple;
	bh=NBvNotESp7kUasR2rqxc9z9U7+RvFpA7PAQQGkHDOZA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ce5M98Uy9SnbnFvP2mhdE0ldtvQhNbdDP5iP6MiS9ioR9uLeWR78VrWUlF/YHcIfzyDmaElgVUKN5O/tn0MM3aOD0A4FBLqgQ2oRUFJu3m1cAvdGD+Ze1W9D2wZOmlXs0rtHRZMMlNaLfh6a87WpQFYAO5Uq2k6Zy+bh7zhsjLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=G3vY3kzy; arc=none smtp.client-ip=209.85.160.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-qt1-f226.google.com with SMTP id d75a77b69052e-5032ee7bf6fso3109511cf.1
        for <io-uring@vger.kernel.org>; Fri, 27 Feb 2026 14:35:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1772231708; x=1772836508; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YA4oP39D1EwOno4AkPegcttVQHiaILWd3dC9XNEopg8=;
        b=G3vY3kzyejLtNBv6NJe3Cbqb8SpZ7L52IpzXBZlXoMY8BwfLKsGxyEbJeFlyoG+c8g
         l7U0S+WGmR3UobhDwpdBoI8ngxlYwLPpDxbq/KnlP4MGO95zXS8v6sDG4hNlmgttOvYm
         561bR+xEV+rHfGP6Biy/5laBlP98t5UiUCMw/e6mA1VGmGcqgGiPQbRBio+5yfctdPK7
         jGJMBO1tdQoVa6UfxRYci/QHuHBATeMGixRdehNbH3jRFiE9ojfJXvIwkwRPmYfpTuDG
         35UpU/keLpt+OuQPebIIhJUXYFDbHxh6bZFfZIE/VdONneVkzJSBBtLk4/ajFXAF0DUt
         6zLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772231708; x=1772836508;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=YA4oP39D1EwOno4AkPegcttVQHiaILWd3dC9XNEopg8=;
        b=bKSVUrDusbk89ExuX/cjSJ/JL7conWuegGeEQmNwSHfbzsKf0LMn5HkyzJhbIxrDx3
         Jph6t5yi+puuFWJOL3f8ql3Awp6G1IAtbMAKzID7A3EDJP5c7juT2WVxJhN/l1c8MAHW
         Rp/2w/aACv0EA/UgyKSBC9TnBCnZcWs73D/qL/KzgL3m+8UX+muk5S6WVWVxURW8xOV6
         sfcO+KC0VXzZv0evm3PaC+aIiIb2Mw+vQKfAKVTIhT0pbik4oD0C5rV1lgNc++cEelXC
         iXSx/K0eEGwt2Sr7CGsIlLKuNtdkgA+SLhEcCwP64yK7w3NUVp58BXumX1MNuMmhO2Hv
         AkYA==
X-Gm-Message-State: AOJu0YyGpCrW1hM+rr8uVGXd7u9YyMzzyhGCzoA45woTYC/okV8NQqGC
	Spe+y5miIsfNGD4DGF/jk8an0kilImPAODC5NSo/PqqDNLHvnFjWSYrE30yZ6h4X2uQ3MkVzdOL
	oLwt93ha0DKdS0eCAcM1RXg8EvywZvhpt217C
X-Gm-Gg: ATEYQzxLoBZEGH3e1dn8lD0JCFCpbuMFFQ9k100S6DjiVwWzocxucybCq1Y8Un3cbw4
	HgNKz9KZxPbDVf+x7LY/GUn+/QWHy7Ey55OIrWfcybgiu6X0JwrMAGiEQoTBNMfvklxABZ3pBVE
	hf2TrYNkTMk4/AMRGflkaaEhqlA9s9z3jyuhL6c7VK2FRnyCHcoNAbkYiJBeS3rCRjbjth8hOTI
	SgGiggqo+chM7ErJ8tpumZ0XDVAPOQ1wIK7K+2M4p2wWxA/rMeYDFCMb+YI8jII7/Jwk50EncAJ
	ZNRduQKvIubHFNcTRSX0s2X8XTlENfZshn+tkgE+OOwtOeAAN5Yr/LguEv3oTsJY5ZFsKqZjpBe
	NC0K8TQP60YcaS+7i8LRjrNlNcTU7FHRiO7Ho6ymtNEeoaJyqkyPOoQ==
X-Received: by 2002:a05:622a:178f:b0:506:bfa3:55c8 with SMTP id d75a77b69052e-5075297bae4mr45875231cf.5.1772231708069;
        Fri, 27 Feb 2026 14:35:08 -0800 (PST)
Received: from c7-smtp-2023.dev.purestorage.com ([208.88.159.129])
        by smtp-relay.gmail.com with ESMTPS id d75a77b69052e-50744a78567sm7946111cf.6.2026.02.27.14.35.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Feb 2026 14:35:08 -0800 (PST)
X-Relaying-Domain: purestorage.com
Received: from dev-csander.dev.purestorage.com (dev-csander.dev.purestorage.com [10.112.29.101])
	by c7-smtp-2023.dev.purestorage.com (Postfix) with ESMTP id 55B0C341F2A;
	Fri, 27 Feb 2026 15:35:07 -0700 (MST)
Received: by dev-csander.dev.purestorage.com (Postfix, from userid 1557716354)
	id 51DE3E420D8; Fri, 27 Feb 2026 15:35:07 -0700 (MST)
From: Caleb Sander Mateos <csander@purestorage.com>
To: Jens Axboe <axboe@kernel.dk>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sagi Grimberg <sagi@grimberg.me>
Cc: io-uring@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Anuj Gupta <anuj20.g@samsung.com>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Ming Lei <ming.lei@redhat.com>,
	Caleb Sander Mateos <csander@purestorage.com>
Subject: [PATCH v4 4/5] io_uring/uring_cmd: allow non-iopoll cmds with IORING_SETUP_IOPOLL
Date: Fri, 27 Feb 2026 15:35:02 -0700
Message-ID: <20260227223504.1162421-5-csander@purestorage.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20260227223504.1162421-1-csander@purestorage.com>
References: <20260227223504.1162421-1-csander@purestorage.com>
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
	DMARC_POLICY_ALLOW(-0.50)[purestorage.com,reject];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[purestorage.com:s=google2022];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12478-lists,io-uring=lfdr.de];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[csander@purestorage.com,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[11];
	NEURAL_HAM(-0.00)[-1.000];
	DKIM_TRACE(0.00)[purestorage.com:+];
	TAGGED_RCPT(0.00)[io-uring];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Queue-Id: 9DE8D1BEB71
X-Rspamd-Action: no action

Currently, creating an io_uring with IORING_SETUP_IOPOLL requires all
requests issued to it to support iopoll. This prevents, for example,
using ublk zero-copy together with IORING_SETUP_IOPOLL, as ublk
zero-copy buffer registrations are performed using a uring_cmd. There's
no technical reason why these non-iopoll uring_cmds can't be supported.
They will either complete synchronously or via an external mechanism
that calls io_uring_cmd_done(), io_uring_cmd_post_mshot_cqe32(), or
io_uring_mshot_cmd_post_cqe(), so they don't need to be polled.

Allow uring_cmd requests to be issued to IORING_SETUP_IOPOLL io_urings
even if their files don't implement ->uring_cmd_iopoll(). For these
uring_cmd requests, skip initializing struct io_kiocb's iopoll fields,
don't set REQ_F_IOPOLL, and don't set IO_URING_F_IOPOLL in issue_flags.

Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
Reviewed-by: Kanchan Joshi <joshi.k@samsung.com>
Reviewed-by: Anuj Gupta <anuj20.g@samsung.com>
---
 io_uring/uring_cmd.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index b651c63f6e20..7b25dcd9d05f 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -255,13 +255,11 @@ int io_uring_cmd(struct io_kiocb *req, unsigned int issue_flags)
 		issue_flags |= IO_URING_F_SQE128;
 	if (ctx->flags & (IORING_SETUP_CQE32 | IORING_SETUP_CQE_MIXED))
 		issue_flags |= IO_URING_F_CQE32;
 	if (io_is_compat(ctx))
 		issue_flags |= IO_URING_F_COMPAT;
-	if (ctx->flags & IORING_SETUP_IOPOLL) {
-		if (!file->f_op->uring_cmd_iopoll)
-			return -EOPNOTSUPP;
+	if (ctx->flags & IORING_SETUP_IOPOLL && file->f_op->uring_cmd_iopoll) {
 		req->flags |= REQ_F_IOPOLL;
 		issue_flags |= IO_URING_F_IOPOLL;
 		req->iopoll_completed = 0;
 		if (ctx->flags & IORING_SETUP_HYBRID_IOPOLL) {
 			/* make sure every req only blocks once */
-- 
2.45.2


