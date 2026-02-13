Return-Path: <io-uring+bounces-12185-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id eHqqOsCYjmnXDAEAu9opvQ
	(envelope-from <io-uring+bounces-12185-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 13 Feb 2026 04:21:36 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 5304E132A1C
	for <lists+io-uring@lfdr.de>; Fri, 13 Feb 2026 04:21:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id CCEE4306296F
	for <lists+io-uring@lfdr.de>; Fri, 13 Feb 2026 03:21:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5256AC8CE;
	Fri, 13 Feb 2026 03:21:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="fPYAWSOl"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-dl1-f100.google.com (mail-dl1-f100.google.com [74.125.82.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1789A1E5205
	for <io-uring@vger.kernel.org>; Fri, 13 Feb 2026 03:21:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770952891; cv=none; b=obRdtakzQp66rrKvPDsLapb83vz9+aAme1Fg+NRbGse/MrgQxfyf/XR7zfYpdTVbZ9esxZ9fyLRleBcHnofk5BJQB7dEwQNxzvqUgD963C4QfBRfneXdvah6rvMLc/D3ZW7vek/g7wftlG4VvDLAxwwUgoT2+GiAQpu+Xdgv140=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770952891; c=relaxed/simple;
	bh=Pk0eKb5jrGWG8Xmev1Uz7ZL4nkZ1Sxp5mFYfnx60VKA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PUHBtrjAf/mNnaLKo4pz9+5xRehSCfPdgGpVY0TkCPa6feIR6GAZ5vtTb682Rj99Gg8MbpWK1Mhoswo0DhROX3Saq3EP+6b9az7WqAMrzvtZrVmZaCjxGupbRGhCZ7UwDXZZ4V5O2F2whuOU8lsKbq3cjBHVzIWvW6FFfYI2NbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=fPYAWSOl; arc=none smtp.client-ip=74.125.82.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-dl1-f100.google.com with SMTP id a92af1059eb24-124a7216c9cso13639c88.0
        for <io-uring@vger.kernel.org>; Thu, 12 Feb 2026 19:21:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1770952889; x=1771557689; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AmRiY+gYv1Yx/1Ht580JCWnZXV60oDsI6NKnjtBd258=;
        b=fPYAWSOlytlHNXVOkuBkLHmckazOerV300QBaEUNsi25QWMiSJKd39lZNYYHc0rpeO
         U9EhH7K8V8ysqXQBxJhTIvFLzRsiuHXYnw8x1nqG/Imn1DifepX/rsfMr/UZ+HS9UQNH
         GOBfmqjeAmq3/dPyb1wtR+7xEHI+WRrGxTjmXt1dD1f4agsfYnrzAIdo8lfbjkVJ3suP
         fdV1sEENvnoO4XeHEiLCLrpiM7tHgB1LWqOz4Z6CszSpFIIus10bsPMxErWNV7ycShlj
         B2A/4+Mx4AGARPohgstevOEHZLz/HS0lXXQA5IZ9St3uXLz2hdWgqXz3LXhYdG/EqPOF
         2p3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770952889; x=1771557689;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=AmRiY+gYv1Yx/1Ht580JCWnZXV60oDsI6NKnjtBd258=;
        b=FVZ1OpYMqLFfGzyI+lvQQeUDS/03tvRvUpIddPJhobohAzJiiAetDUfU2Grn/nPDVH
         sNwAfgxk8qzNT7fbth7R4ehmBwAXIHP4JujcvL1wG9jMPGu4sfBEw7iuBEVNnrD+FaNq
         ihWqMimFiaPqkTVmdhjuuWFPVcjvhlXagKK7n40COre0Ja5mpbeYWhJTkF6Uwu9PAB5P
         HjmmgPKDZtCQB0FUE3/uMh6Xh/JZPqnZPOSkcXjuD3ezF3i5yQ3vbUaKAkF545fzF911
         I/Z5J6mamoyYY0mFo3RxnkKIvgWTCashzMMBUmV5IcRZvgFxH/oMT6vA4syAkOAIWOUo
         J3Dw==
X-Gm-Message-State: AOJu0YziZsOCa88ijyYPWsI1iQVWRtuA2A8acMcvGrXnctR38JAXkqTQ
	7dGlpgp3JYo2AWfE3EXuj/QFjjaQ4Va3YhfjAW2PlAcOBisO3PUym+VVo3RBjo654N2FrhIbWpi
	S6l26CzG2RsCGKHnduBZqQT+LflzDnaaxlhYQ
X-Gm-Gg: AZuq6aJVZeKbXbn+veHqBoJLS8y++NVaqgUDvcUpzsgjn1L7COwU7dzep6JQRStyMEJ
	4T2rmLKAczR4v+/WS73eAb7Ds2yFS+2T1keLZ/Pk9HgqRQGO70603xc0FJt9xwV2cTk5lsMIaD9
	rvAB1MJJBzNmvgjUgmPP58qqlkIuyNm14PLFVIU40PT5TdeVj9ERoo+k2VCj4WNFl9mIqyv8xv2
	jrEy+CmOpvTEyote6ZLOM3qNOuWYXsiOTQy2yf0GCAbzfpKbYloc380WrjdkI3mXiHHH4UazH6Y
	sRJu+wT5P/MyRPxPY9q/fYUQnaG4lJpawe7Wkfcw+eGEf3z7PbxFuWiMETL3O2LclGTZ0nCE7v5
	xkrMWwu2XD7tuZCSnukgpo6V/xbblJGj4vM8hRAVrOukcihFRZj9+OA==
X-Received: by 2002:a05:7022:6283:b0:11e:3e9:3e88 with SMTP id a92af1059eb24-1273996b276mr248941c88.6.1770952889051;
        Thu, 12 Feb 2026 19:21:29 -0800 (PST)
Received: from c7-smtp-2023.dev.purestorage.com ([208.88.159.129])
        by smtp-relay.gmail.com with ESMTPS id a92af1059eb24-1273a0db6d1sm104957c88.4.2026.02.12.19.21.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Feb 2026 19:21:29 -0800 (PST)
X-Relaying-Domain: purestorage.com
Received: from dev-csander.dev.purestorage.com (dev-csander.dev.purestorage.com [10.112.29.101])
	by c7-smtp-2023.dev.purestorage.com (Postfix) with ESMTP id 1D294342244;
	Thu, 12 Feb 2026 20:21:28 -0700 (MST)
Received: by dev-csander.dev.purestorage.com (Postfix, from userid 1557716354)
	id 172D3E41DCC; Thu, 12 Feb 2026 20:21:28 -0700 (MST)
From: Caleb Sander Mateos <csander@purestorage.com>
To: Jens Axboe <axboe@kernel.dk>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sagi Grimberg <sagi@grimberg.me>
Cc: io-uring@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Caleb Sander Mateos <csander@purestorage.com>
Subject: [PATCH 3/3] nvme: remove nvme_dev_uring_cmd() IO_URING_F_IOPOLL check
Date: Thu, 12 Feb 2026 20:21:19 -0700
Message-ID: <20260213032119.1125331-4-csander@purestorage.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20260213032119.1125331-1-csander@purestorage.com>
References: <20260213032119.1125331-1-csander@purestorage.com>
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
	R_DKIM_ALLOW(-0.20)[purestorage.com:s=google2022];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12185-lists,io-uring=lfdr.de];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,purestorage.com:mid,purestorage.com:dkim,purestorage.com:email];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[csander@purestorage.com,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[8];
	DKIM_TRACE(0.00)[purestorage.com:+];
	TAGGED_RCPT(0.00)[io-uring];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Queue-Id: 5304E132A1C
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


