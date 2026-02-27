Return-Path: <io-uring+bounces-12479-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id sOnrATQcomnqzQQAu9opvQ
	(envelope-from <io-uring+bounces-12479-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 27 Feb 2026 23:35:32 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 81B941BEB90
	for <lists+io-uring@lfdr.de>; Fri, 27 Feb 2026 23:35:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 384AC3131431
	for <lists+io-uring@lfdr.de>; Fri, 27 Feb 2026 22:35:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E696547AF4E;
	Fri, 27 Feb 2026 22:35:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="VQLoDKup"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f98.google.com (mail-ot1-f98.google.com [209.85.210.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C0B9478E4D
	for <io-uring@vger.kernel.org>; Fri, 27 Feb 2026 22:35:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772231710; cv=none; b=YMuDFn+GK2hogWNQpYjyicmMyiK0/ZIPRkMXoT/m3foyI4+QkUEhne2hIwDwIktRYb64Z6+zU/FSEakPFvY4rFNYNS4tdWsbsrizNBlSH2c4YdgKQSU7yJVBiEzMueHj7zAZa4y+PiatPRVELzO8V/VWD2n2MvBvJ1DsDEHvZxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772231710; c=relaxed/simple;
	bh=leoJQLYUVaLoPMfpnaJ83Ki6TjRT6ZQ1hoz2AIfe5rc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mb2VPIgRvvoGMRX0nSL68X+lLSEcOCGZiUO3T6/uJl/U+kgdswKWJCFVbxq6VxwCzioCUQdvHAOHFsswEJJS6naNkTgY1YnAJhzRpKzClZwtS6D/qs70ZPCK1tmfXz/apx8GKE2tooPY5ZzAoNOKBs09HH9BMGGm564KUfmHWEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=VQLoDKup; arc=none smtp.client-ip=209.85.210.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-ot1-f98.google.com with SMTP id 46e09a7af769-7d2ebc06f66so391052a34.0
        for <io-uring@vger.kernel.org>; Fri, 27 Feb 2026 14:35:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1772231708; x=1772836508; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bC/PSnv7yOwEPTd/AMtRMqWpAAmzjzQLzKujNS/xPPY=;
        b=VQLoDKupuJgNIOaqL0VxdWMOv18q3vC5o3ztF0azusyMRSoQch0qaspgKAjsJUtceh
         lulR0nNdkJPApr5t+zMi87OCFAWGjEc/7EawCV0R1FRSG4ngMI32THlxxLNBM1zfMfaB
         8MothmsbvU71hANd5ipcLYmMUVahnWX+Bu0x7CmfPWyiIjsjS6SbT9qNMxPAiL8altMM
         dDzSD6RiSpvVuj+hMQRiFFa+Cl0uKEJOd818TyoTUJieQGk7+ncwTP2fs/GqV39hceOh
         35jBm1DuHHPbT18XiBHVZGzaWuWUbAKOnsrpQQnO8rFJs4LLe9URaDNfQBD/4ky4m+qG
         nOdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772231708; x=1772836508;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=bC/PSnv7yOwEPTd/AMtRMqWpAAmzjzQLzKujNS/xPPY=;
        b=umR+jCYIlWwOyHdb3FzBm/Tz9Sk4iS73E4oy1JTKLMtcXZyNTCnFPmAr6z5YBwTngv
         eA9bCcG4w083UrAo9gTSZM0tqlaQLuTCehttPvbSpHGmoHLtClPBuS2WC3YeGezgou56
         EPirPhWb4zASONzSsV19ezFCeqJrzCyVOopMMg//tb3ccWMIxqB5X3U+y0s5mmowzPSP
         RtGUwOBbbXw60y8VFz3UJEnv8wo/xbQR4TB2eiuasRIIalpwLg/8mBM7uFpjpcUGyNMN
         H/BlXY4WpbJdOGoSH+zZMae+kR74cXuBDxUovhxcoHRcU+Mkp9QssYEYaw/idJkIyMiG
         UPQg==
X-Gm-Message-State: AOJu0Yz91Q8Mn0BhkiT4yNjZzBIHG+8CSWuz4QGT++WKHrL4ZGjmg5J5
	JRSR4D/MCMIusNC97zfe55k2DkKtjjle4AtWVwkWv6n8vggBgqio7Cz5CocfBjAPIW0V6nlLuEy
	Vo7OoQrMJaWZVzR72dqX1plJ2jAanxXyVlYBQ0XPQpp+DYmTWuzbt
X-Gm-Gg: ATEYQzz9m251mWAssgQ2yZdppiJ0h4BhKi9R5y+rA/kSMYDBOrs34cRE1Z1R/YudjrT
	XrRQPp6mPbgKlnhfm4Xk0nI+k1S7Ewpw6dSxhjpdLbrJ1YjihAQdLQtoQw5/2x+5kWZrYYANlgz
	UF/oCfFmLa7CoUkUGOIzp5B82IQZWGY0fH2FbT9IYmUKW7QdIP5ZqVLWVBNrjyP2A7nEBmJYVmA
	srUtaxWnm16aNm8AgyIppakQ5dsGZL1SXcLY9hD6PbwnXZBR1XEiEycBXwSefD4sevF8mlBpx8o
	LU07UjkdoHya7KGw4tMNRQQy4F/5mhV76Ga6jkmX9OqFtRwn2xMkW3S7d8KzBAU6jramfn9rtiz
	e+e+jQinODEAPyG61oKlf3m7k6K3kZyORVj+Y7Y4=
X-Received: by 2002:a05:6830:91e:b0:7d1:4980:2537 with SMTP id 46e09a7af769-7d591bccd6amr2761555a34.4.1772231708517;
        Fri, 27 Feb 2026 14:35:08 -0800 (PST)
Received: from c7-smtp-2023.dev.purestorage.com ([2620:125:9017:12:36:3:5:0])
        by smtp-relay.gmail.com with ESMTPS id 46e09a7af769-7d58644a35asm829296a34.1.2026.02.27.14.35.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Feb 2026 14:35:08 -0800 (PST)
X-Relaying-Domain: purestorage.com
Received: from dev-csander.dev.purestorage.com (dev-csander.dev.purestorage.com [10.112.29.101])
	by c7-smtp-2023.dev.purestorage.com (Postfix) with ESMTP id 8A93F3420C0;
	Fri, 27 Feb 2026 15:35:07 -0700 (MST)
Received: by dev-csander.dev.purestorage.com (Postfix, from userid 1557716354)
	id 86A24E420D8; Fri, 27 Feb 2026 15:35:07 -0700 (MST)
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
Subject: [PATCH v4 5/5] nvme: remove nvme_dev_uring_cmd() IO_URING_F_IOPOLL check
Date: Fri, 27 Feb 2026 15:35:03 -0700
Message-ID: <20260227223504.1162421-6-csander@purestorage.com>
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
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[purestorage.com:s=google2022];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12479-lists,io-uring=lfdr.de];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,purestorage.com:mid,purestorage.com:dkim,purestorage.com:email,samsung.com:email];
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
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Queue-Id: 81B941BEB90
X-Rspamd-Action: no action

nvme_dev_uring_cmd() is part of struct file_operations nvme_dev_fops,
which doesn't implement ->uring_cmd_iopoll(). So it won't be called with
issue_flags that include IO_URING_F_IOPOLL. Drop the unnecessary
IO_URING_F_IOPOLL check in nvme_dev_uring_cmd().

Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
Reviewed-by: Kanchan Joshi <joshi.k@samsung.com>
Reviewed-by: Anuj Gupta <anuj20.g@samsung.com>
---
 drivers/nvme/host/ioctl.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/nvme/host/ioctl.c b/drivers/nvme/host/ioctl.c
index 8844bbd39515..9597a87cf05d 100644
--- a/drivers/nvme/host/ioctl.c
+++ b/drivers/nvme/host/ioctl.c
@@ -784,14 +784,10 @@ int nvme_ns_head_chr_uring_cmd(struct io_uring_cmd *ioucmd,
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


