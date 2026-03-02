Return-Path: <io-uring+bounces-12525-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 2J5aOBzJpWnEFgAAu9opvQ
	(envelope-from <io-uring+bounces-12525-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 02 Mar 2026 18:30:04 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 5ADEC1DDD27
	for <lists+io-uring@lfdr.de>; Mon, 02 Mar 2026 18:30:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 27D75304B381
	for <lists+io-uring@lfdr.de>; Mon,  2 Mar 2026 17:29:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 21E1042DFFA;
	Mon,  2 Mar 2026 17:29:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="cczm6zxJ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-dl1-f98.google.com (mail-dl1-f98.google.com [74.125.82.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5EBB42EEB1
	for <io-uring@vger.kernel.org>; Mon,  2 Mar 2026 17:29:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772472566; cv=none; b=ot6Uz8yoJbAnUlJmNbcCr/mR5gq2IwqqhgmLdf/DnHLNPjT14kyJh/mgc2Vo4s2++V9SJawA5k8kP6nyIJI3jo1isH10p8ZT2RBVYV9ffMq50FTgIOJIGRu6mR03ArrHE24aKckEpyn9RcKsb+FqAF6DBzgcG0ekJVhoojvCQWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772472566; c=relaxed/simple;
	bh=leoJQLYUVaLoPMfpnaJ83Ki6TjRT6ZQ1hoz2AIfe5rc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J/H0aXeDTgF3BwCUk0gcG65x1493ofFUOTZZiOSdQHZqr+AyhfwSaYR40n6m5kKzopAkOChSd0Gg3zSO0woHzYyRLRwWz14WL6lIGjs3RYa6KIdoRlQh73xCPNE3x6lT1yIr7eQK+Vfv26KTqENdfQb+uq+72/hcmtbO7o01r9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=cczm6zxJ; arc=none smtp.client-ip=74.125.82.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-dl1-f98.google.com with SMTP id a92af1059eb24-1277863a912so404436c88.0
        for <io-uring@vger.kernel.org>; Mon, 02 Mar 2026 09:29:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1772472564; x=1773077364; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bC/PSnv7yOwEPTd/AMtRMqWpAAmzjzQLzKujNS/xPPY=;
        b=cczm6zxJiC0VuqWJSZE9D7jhV/ZxSeYWcVxp3OioQllDMv+9A2SNiLHyGnkQRzreUe
         /WHuBhV5O5Zv/ezYWvJ6utuwgjOAooyd50JwIGI1aogjn84so63Ji9EBasgiGMp00O4G
         A/E9Yt7YF4pWHHB6umnNf+UEgvyxf1H9RxCbpKW3TkryCSn1GVETegI37R0yc/O1bWLc
         Fz0Lq4zh3t/OBkQAxHNBjyTF/Gju2mDwY5iB7zy8ZZuTncwoLPoHmvuX4DnF0bO799QM
         eiJpMv3wP6o4TlraLvko+nc0YrrNKe3IVChXpPB8B6alnBJ+3rn59VCE8A477nxnWckL
         4gtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772472564; x=1773077364;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=bC/PSnv7yOwEPTd/AMtRMqWpAAmzjzQLzKujNS/xPPY=;
        b=cvz7k9Hc/bk8jEw9M2A9mlfN5Y+ew/IF2UptK5WxpSPQX1hc5Xfi8WkUJsvPwNqJeC
         k4tKt8N4KJz+P2UuC2xC/vyVPpPaGzl1loUNpsbwp4jrvoK8EILVN5mS89sZyfPLHMIr
         v5F5HPApkkiyRieyMI87VIwBwcE2x+xtSvLzgfukVd0v0N6kmBKTU50j9Sl1606o9AG1
         fL9ktiUgH0T5dUBR6zFfFDKVOFZz7o4TLwjGa76+xQIcRkIYhT0VeNgHQNzOCkeGM/HP
         MnT3L2eaXxuLpQti0jhmVFvBOXNnjjbVnFVghif+Nt3tUt0JVxl+OC2NmF/0LO01OZW7
         /fqw==
X-Gm-Message-State: AOJu0Yz/ugbQKMndwpIz7ZDnV+pvmx4tpzZJvd2So/jH+6fSSxo8tPLP
	0XamozSNO0J/5PxA9YyPn+Zc/E2xKMIw6WCo/DMJRiAsTDens8x8jvBS0IU/qO9E28kwIxzrKpM
	4sNAgwoZLJc9qWIPVIJgnL1l9BLr47nBfPonR
X-Gm-Gg: ATEYQzxGQcmTbzTbuBWk5nKk8cfacXhAzRSdbSE7Uy9OTmVkoIYrVeV/m4V1ZwYAMfy
	41N530qS1tweAaVYwnRIkC9k9CRAfxegOk1rDmYVmjJH+/AxiwRRGVHBC8EInLlay4GFiOQyNAL
	zVqFyn1XjTjLn8YtdD4oT76l3ClRj/m94hhSCuXeuh1NLH2uTa5EoclObhu3aa1IsPqey5xCIpO
	EmbiWbMOOslnLdl7RHkfWJK7w69wPKVJRydvn/7wsPG5DQ2PqCQWNw1ow8YYLK3+Z7wRtVR668B
	MYCQ9rA9prrHz1jt75zIZuh6lB2fpoq6Biktt6FCQuzqSqPT1Tio0h4/byUP5UZzwz3XF6UXVnU
	Wyh2NoKakdh1l6iq/Fsxaw8wyUoiu4XBcdh2jdbA6MXXMhiVKhua29g==
X-Received: by 2002:a05:7300:724c:b0:2bd:db75:c28b with SMTP id 5a478bee46e88-2bde1e90dd9mr2349446eec.7.1772472563561;
        Mon, 02 Mar 2026 09:29:23 -0800 (PST)
Received: from c7-smtp-2023.dev.purestorage.com ([208.88.159.128])
        by smtp-relay.gmail.com with ESMTPS id a92af1059eb24-12789a20cd1sm2213499c88.6.2026.03.02.09.29.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Mar 2026 09:29:23 -0800 (PST)
X-Relaying-Domain: purestorage.com
Received: from dev-csander.dev.purestorage.com (dev-csander.dev.purestorage.com [10.112.29.101])
	by c7-smtp-2023.dev.purestorage.com (Postfix) with ESMTP id 5CDAE3405ED;
	Mon,  2 Mar 2026 10:29:22 -0700 (MST)
Received: by dev-csander.dev.purestorage.com (Postfix, from userid 1557716354)
	id 5A1E8E41FBD; Mon,  2 Mar 2026 10:29:22 -0700 (MST)
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
Subject: [PATCH v5 5/5] nvme: remove nvme_dev_uring_cmd() IO_URING_F_IOPOLL check
Date: Mon,  2 Mar 2026 10:29:14 -0700
Message-ID: <20260302172914.2488599-6-csander@purestorage.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20260302172914.2488599-1-csander@purestorage.com>
References: <20260302172914.2488599-1-csander@purestorage.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 5ADEC1DDD27
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[purestorage.com,reject];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[purestorage.com:s=google2022];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12525-lists,io-uring=lfdr.de];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo,purestorage.com:dkim,purestorage.com:email,purestorage.com:mid,samsung.com:email];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_SEVEN(0.00)[7]
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


