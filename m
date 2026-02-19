Return-Path: <io-uring+bounces-12322-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qB/4F+ZqlmkqfAIAu9opvQ
	(envelope-from <io-uring+bounces-12322-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 19 Feb 2026 02:44:06 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id D119515B69B
	for <lists+io-uring@lfdr.de>; Thu, 19 Feb 2026 02:44:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 35A97303AAB0
	for <lists+io-uring@lfdr.de>; Thu, 19 Feb 2026 01:43:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7AF3266EE9;
	Thu, 19 Feb 2026 01:43:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="YICb4H+S"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-dy1-f228.google.com (mail-dy1-f228.google.com [74.125.82.228])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37BE823BD1D
	for <io-uring@vger.kernel.org>; Thu, 19 Feb 2026 01:43:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.228
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771465427; cv=none; b=f6VJNZl/gscHs0QDuU1DXUrg6BaqNxNv+Rt5Sr0k8WmFdf4Yx20UB2PR80vzGug+FUOQkgz1BgNJPa/9qOEElijiKXK07fYnmcFrdVmzmgMzCJegkGENJdUmqQfcRc0uPK72JM8A47EBP9INruo8qnDuEzk3ZUHdpYY5IEwsUTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771465427; c=relaxed/simple;
	bh=Pk0eKb5jrGWG8Xmev1Uz7ZL4nkZ1Sxp5mFYfnx60VKA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BbOcRCQ3ZLZ3ccLZH9UZCc22xNG2caJ4IaUtGko6mONyLBtTQ9d2jJY8/hXh48HM3N03WIC/6C1Y2xjCoc+pgq6iG2lJhAPyup0imPPIPiXtI20u6da6B2qy8rQs2x83y8wBNxie4/aE91d8Ct0WMPHwzwA6gK7mxOIzrHNsGfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=YICb4H+S; arc=none smtp.client-ip=74.125.82.228
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-dy1-f228.google.com with SMTP id 5a478bee46e88-2b866f98574so7528eec.0
        for <io-uring@vger.kernel.org>; Wed, 18 Feb 2026 17:43:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1771465425; x=1772070225; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AmRiY+gYv1Yx/1Ht580JCWnZXV60oDsI6NKnjtBd258=;
        b=YICb4H+SfryGpAmH7wZAcU94IZ4zlL92VTqiOZoLdG1yGzBzARypMvRp8XP7K9vSpZ
         Yf2PZ09G+ytr/JnEdzwaeGSn/+aJIhgpAsilNXIKTXhIq0fbyyAhmJOJwX7mUpPMaJ+3
         jaE52bM2IvuvresRMc7XxS5xsrmI1jLkjosWYQU+8XopHm7iWDJuvCemgOtyQtivClSh
         TIp2Ggu+JYr9fOT63mUz5RLeipQA89cVXxQpJZVvxTOw5lD7JhlQjnOjAdQ5cm2szANg
         RM6KkR+u1gqczDRTilJGlv+eEK2S4I7OD468r6v0XClLS8ztoL5gg9ETx0yaPxqdUmsc
         ArDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771465425; x=1772070225;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=AmRiY+gYv1Yx/1Ht580JCWnZXV60oDsI6NKnjtBd258=;
        b=wdDjEPNuQe/5EENgj4+1rHSoFTXomdbl21vOhrF5J2Qk/FXRBFlR6+oO6uHmzoyoBN
         xphaJyLqZ+FkSeF53reYFy3faYO/SW4BJ91RF4X3rnH33Z1Grzmfq5+JHFGigsnv1/8M
         UXeg/dyoOGX2G5IgtPgT2wHY84Pwt3cOn975de4h5qjrH1biLlnGI69652G/8cCR8LDE
         FjZgBpOFC+gPKFff4BYaLVX8MHm1HNZmZoLZuh6SNo8B+tpJBa4SFvP2LvMMv4iIZb7F
         jNGT9bNr9CQ02l/dRRKpoK3pqAF/XTzRVZYmAAnFY0J//R7rcLlu8lAEY3N9nq3JXGuo
         LL1g==
X-Gm-Message-State: AOJu0Yzg3IKirKx68gKb4McMc0oSh0ahrwuG302dgGgvJOmPqnNGsyyS
	RhURIg9jQF+lWGGPAlts3UvyC0wgbDwUXa0d+ibkEIqVLkf9Tf2/iczeRViBjy/QxFEdFhpKP+l
	gioEfvA65beQ+4TgxwpTdAIxhhXTc+GVQDPap/gYexQCHebNp00/y
X-Gm-Gg: AZuq6aLXniLjoEEGx9mXJqC5hpS02h9zFuuLKFITWQ/pWxiGMEbijl5kU17g0WoTHgG
	U/rV36ktaBmKaEGuIB9wLsjdgAf6KQB+mFGoC4BrAhNlpkwNjNG/n5KxwApb8I6orooPpIyJ9zd
	LpVRohaZEOkSbfu0LJQJ64J9WFa/X32sE3LRGF26n+UapoLp5Zm3pZZtikwPkVKZWv/i+PLt09r
	4jZDMdNdIcmqLtiPTYqEdFgWg6DYSrAmUiW5PQ5DnRJdOjJA+1PbJA6//5XGwAlF3u3XEoi1+Ol
	od21h7HN4UXgEfx+SflPTbu0fB6BTeH/R+Ca9qbqi5tAHY5lpEJk9MvkMJicKOhmEdXYWm5zChI
	xqkzFH6xe4TMl2yI/RLqOAQ73foco7oJogV5e2TI=
X-Received: by 2002:a05:7300:3b04:b0:2ba:673b:e328 with SMTP id 5a478bee46e88-2baba13781amr4428856eec.9.1771465425201;
        Wed, 18 Feb 2026 17:43:45 -0800 (PST)
Received: from c7-smtp-2023.dev.purestorage.com ([2620:125:9017:12:36:3:5:0])
        by smtp-relay.gmail.com with ESMTPS id 5a478bee46e88-2bacb64f67esm1955371eec.11.2026.02.18.17.43.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Feb 2026 17:43:45 -0800 (PST)
X-Relaying-Domain: purestorage.com
Received: from dev-csander.dev.purestorage.com (dev-csander.dev.purestorage.com [10.112.29.101])
	by c7-smtp-2023.dev.purestorage.com (Postfix) with ESMTP id 4019C3422C8;
	Wed, 18 Feb 2026 18:43:44 -0700 (MST)
Received: by dev-csander.dev.purestorage.com (Postfix, from userid 1557716354)
	id 3B4D1E41D2F; Wed, 18 Feb 2026 18:43:44 -0700 (MST)
From: Caleb Sander Mateos <csander@purestorage.com>
To: Jens Axboe <axboe@kernel.dk>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sagi Grimberg <sagi@grimberg.me>
Cc: io-uring@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Caleb Sander Mateos <csander@purestorage.com>
Subject: [PATCH v2 4/4] nvme: remove nvme_dev_uring_cmd() IO_URING_F_IOPOLL check
Date: Wed, 18 Feb 2026 18:43:35 -0700
Message-ID: <20260219014335.9061-5-csander@purestorage.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20260219014335.9061-1-csander@purestorage.com>
References: <20260219014335.9061-1-csander@purestorage.com>
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
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[purestorage.com:s=google2022];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12322-lists,io-uring=lfdr.de];
	DBL_BLOCKED_OPENRESOLVER(0.00)[purestorage.com:mid,purestorage.com:dkim,purestorage.com:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[csander@purestorage.com,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[8];
	NEURAL_HAM(-0.00)[-0.999];
	DKIM_TRACE(0.00)[purestorage.com:+];
	TAGGED_RCPT(0.00)[io-uring];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Queue-Id: D119515B69B
X-Rspamd-Action: no action

nvme_dev_uring_cmd() is part of struct file_operations nvme_dev_fops,
which doesn't implement ->uring_cmd_iopoll(). So it won't be called with
issue_flags that include IO_URING_F_IOPOLL. Drop the unnecessary
IO_URING_F_IOPOLL check in nvme_dev_uring_cmd().

Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
---
 drivers/nvme/host/ioctl.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/nvme/host/ioctl.c b/drivers/nvme/host/ioctl.c
index fb62633ccbb0..fa489c1979db 100644
--- a/drivers/nvme/host/ioctl.c
+++ b/drivers/nvme/host/ioctl.c
@@ -783,14 +783,10 @@ int nvme_ns_head_chr_uring_cmd(struct io_uring_cmd *ioucmd,
 int nvme_dev_uring_cmd(struct io_uring_cmd *ioucmd, unsigned int issue_flags)
 {
 	struct nvme_ctrl *ctrl = ioucmd->file->private_data;
 	int ret;
 
-	/* IOPOLL not supported yet */
-	if (issue_flags & IO_URING_F_IOPOLL)
-		return -EOPNOTSUPP;
-
 	ret = nvme_uring_cmd_checks(issue_flags);
 	if (ret)
 		return ret;
 
 	switch (ioucmd->cmd_op) {
-- 
2.45.2


