Return-Path: <io-uring+bounces-12339-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IDM9AZpHl2m2wQIAu9opvQ
	(envelope-from <io-uring+bounces-12339-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 19 Feb 2026 18:25:46 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D0CE16128D
	for <lists+io-uring@lfdr.de>; Thu, 19 Feb 2026 18:25:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id EA5EE305C2B3
	for <lists+io-uring@lfdr.de>; Thu, 19 Feb 2026 17:23:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5523834E770;
	Thu, 19 Feb 2026 17:23:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="JhqBpFnk"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f97.google.com (mail-oa1-f97.google.com [209.85.160.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0681234D93C
	for <io-uring@vger.kernel.org>; Thu, 19 Feb 2026 17:23:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.97
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771521788; cv=none; b=t8JvDGstbSKBPRguG7PuALMYb2tudOR2rN9uTz5OPgyflVmIVaUgLkI2ycpW5rX+D4Y35d7CFzxMsZKbF+F5VrwQZysnoyfRFKSpzf9sLF4nJSS7wTWP5j+4AjhHylVK4O436CXHXGBub+UTn9b7e3aX4bcy1B8IY047kJqdrZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771521788; c=relaxed/simple;
	bh=Bhj4aiASHpjApLPV5AkP0Nhd4Rfthu3VwAg+PhlnxMQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jBOCLLYC3Ye0OJJW6NqGnnpxOzx9663Tcak82kGxzuKt72oduABoaonpm/IzUev6pqdyaxsv5YXbqGv1rsrLrHP2t/L0I2WxL3T4bQvrsXIn3VIHwujUcVK4oAqWLT/C/NmSiRNA51/u0j4eByL/5xNnkkgJjrBur4WApGW1Fk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=JhqBpFnk; arc=none smtp.client-ip=209.85.160.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-oa1-f97.google.com with SMTP id 586e51a60fabf-40947c81b31so53559fac.1
        for <io-uring@vger.kernel.org>; Thu, 19 Feb 2026 09:23:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1771521786; x=1772126586; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=obCm5pzMRQ/8I1Vfr0khOkZYqQ5KtFU6UC00Ngu3CF8=;
        b=JhqBpFnktg0dwmw9rjeNR/DO8jQvMaAQu/2WrYsOYDY4BjtIWMZL2L6kP6IaQ/9XlK
         qKv7aOqaTbh8dENF3QQ64OSsROiUsmxtUgA2coPLNR8iHqvPvKetMlQYl8sesrD0vWBB
         6XaoUpVzoOSCUM5c1KjyASGIfV5Vncp2Ub0HhcucGhLNWMNdc1ERdbpI/Vlu2ABfyLGf
         WUXrvl5pVDQDzqIQjWD2libgj3yOY/uXtBb+DtvL3tT1X9mTPLXZkLbWBsoCPo/UmG58
         zcociB2q0LpGRXg3sRb03FBiKLmgQhq9qSu02XJM601wXxYnl6+aZe8HZgWJWu3T50w0
         DagQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771521786; x=1772126586;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=obCm5pzMRQ/8I1Vfr0khOkZYqQ5KtFU6UC00Ngu3CF8=;
        b=YSbRIa0H/tDpBhNZTMtj18YeU1AwPsAFC/T54yoVWgAgecmyrunJngJ7JcosYUx7Z9
         5B0TucXUWBosngXUORp6jGiXQsFRuq7gYd1bGKRjjlORoAVLxXkIE8xcPNH4symH/JK0
         nn8tmIHsr2EGhkibw358+XUmT2inh6TNYg77xOyzN51vt/o2OsBsE34arnoV+XnroBl8
         +cBBE8OIX4+QnXRog9tdzy5D2b4kjhEoLB+T9qAUJC2Qxrry1C0Q1BAdjokp6Pq3UCe0
         MSSvxdF+dqwVRNDbGtCXrzcq6KWDBdg7E8XkqWU/JVizpQz8anNlvPJ1Y3e2cio6SIJk
         rC2w==
X-Gm-Message-State: AOJu0YyEPZydEB2CtfnNKDI09T11Ls43+tOsRaluGrRe1jKL1cndEYtk
	upXtbIu9UQopHWaQhZSMfVGx97/lAiSDwktg72AafBLu4owq+H4YfljlEeBl9R+EHLrUwoVwRCh
	5N3ugUguBNS+dEiaudof9cr9joQLOLyuLeXACO1hpcRcPqPkubBXE
X-Gm-Gg: AZuq6aIjwO2NeDvQW3ujYXDn63RT1IP32NgPSRkxmKFF/FLmrGWfxv1GKHGCPvIVplI
	mL11LqWSLtDb0iQAmZNAPDrSdOG1kMRVCGkmn0teG8uTJWMIBu2FpOgHCwKKvj94HZDEyZ+jIuV
	/Mq2f4h5pH4HJuWxry4yDaGt9sURXpnfkPNaGJmSTFplxa7xh6kegqn0Y/qeC5oIOHIjzHf5rwt
	Qd0P9AspttmTAI9g4TfAvVcvnVx6UjE92GaDyF/E/L+ZWw7bE3O89DjEXyyHjF9ohuwpr4smbQF
	hDvDIY9M73s6y9Nnt9m0sqtpF2uDyk3mFzUcRHSy3G8m0mSOGm9LS9vVvJPQYhsoeVyMY9jLiOG
	2i89Bcq3l1zQ3ZPNxriLDaMUlSmPMCTGyr5BraUg=
X-Received: by 2002:a05:6871:7387:b0:40e:a686:aab with SMTP id 586e51a60fabf-40eeec921cemr9445158fac.8.1771521785894;
        Thu, 19 Feb 2026 09:23:05 -0800 (PST)
Received: from c7-smtp-2023.dev.purestorage.com ([2620:125:9017:12:36:3:5:0])
        by smtp-relay.gmail.com with ESMTPS id 586e51a60fabf-40eaf0f0a97sm4297650fac.13.2026.02.19.09.23.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Feb 2026 09:23:05 -0800 (PST)
X-Relaying-Domain: purestorage.com
Received: from dev-csander.dev.purestorage.com (dev-csander.dev.purestorage.com [10.112.29.101])
	by c7-smtp-2023.dev.purestorage.com (Postfix) with ESMTP id 63475342224;
	Thu, 19 Feb 2026 10:23:05 -0700 (MST)
Received: by dev-csander.dev.purestorage.com (Postfix, from userid 1557716354)
	id 5D2C1E41AE3; Thu, 19 Feb 2026 10:23:05 -0700 (MST)
From: Caleb Sander Mateos <csander@purestorage.com>
To: Jens Axboe <axboe@kernel.dk>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sagi Grimberg <sagi@grimberg.me>
Cc: io-uring@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Anuj gupta <anuj1072538@gmail.com>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Caleb Sander Mateos <csander@purestorage.com>
Subject: [PATCH v3 4/4] nvme: remove nvme_dev_uring_cmd() IO_URING_F_IOPOLL check
Date: Thu, 19 Feb 2026 10:22:27 -0700
Message-ID: <20260219172228.429479-5-csander@purestorage.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20260219172228.429479-1-csander@purestorage.com>
References: <20260219172228.429479-1-csander@purestorage.com>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12339-lists,io-uring=lfdr.de];
	FREEMAIL_CC(0.00)[vger.kernel.org,lists.infradead.org,gmail.com,samsung.com,purestorage.com];
	DBL_BLOCKED_OPENRESOLVER(0.00)[purestorage.com:mid,purestorage.com:dkim,purestorage.com:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_NEQ_ENVFROM(0.00)[csander@purestorage.com,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[10];
	NEURAL_HAM(-0.00)[-1.000];
	DKIM_TRACE(0.00)[purestorage.com:+];
	TAGGED_RCPT(0.00)[io-uring];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Queue-Id: 9D0CE16128D
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


