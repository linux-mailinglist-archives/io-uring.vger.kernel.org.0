Return-Path: <io-uring+bounces-12340-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SKdJHK5Hl2m2wQIAu9opvQ
	(envelope-from <io-uring+bounces-12340-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 19 Feb 2026 18:26:06 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 03C4C1612A3
	for <lists+io-uring@lfdr.de>; Thu, 19 Feb 2026 18:26:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 589E7306826C
	for <lists+io-uring@lfdr.de>; Thu, 19 Feb 2026 17:23:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0DC134DCEC;
	Thu, 19 Feb 2026 17:23:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="cHu4L21s"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qt1-f225.google.com (mail-qt1-f225.google.com [209.85.160.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0B3A34D902
	for <io-uring@vger.kernel.org>; Thu, 19 Feb 2026 17:23:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.225
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771521788; cv=none; b=mT1y51Zz71bbZjvcRbV3KrhUDt0JNiQGddAxOeWkQQjtqm9CD1sT9j6wnwKgVgVLBE7DUxGjLGSngJU4wD8hJ9sh6GYuJpwXHoYZLHLyZ7mS6AZV/qmWZL7Fm+JHHMVak35PtqK6yFR1woc3UGm85D5HghKqUi1xmMe+qk8OMXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771521788; c=relaxed/simple;
	bh=rCfwpGZ1zY1oR+FJDyVECm7GFtKYQS+W42K+Nc+4P/M=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=JN8n7Rw8Epgzhs1S4TbH5BYNPldRP2iOChByrb8Yie9r25qWGH5EjNm9vAUu5YG1QZbgI0nCCMNfYQhzSXyLE+WYU+NnX6TitSD/0NWvdWvw9Fpu8a6dR63uszZvJkR5/a0aomRLxfb/b9SDka3nsfPXEkQCQHwi4YqrA6J3J+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=cHu4L21s; arc=none smtp.client-ip=209.85.160.225
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-qt1-f225.google.com with SMTP id d75a77b69052e-5032e59c8d3so1546521cf.2
        for <io-uring@vger.kernel.org>; Thu, 19 Feb 2026 09:23:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1771521785; x=1772126585; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=DQ0IUqmOj4ktterC5Me/w/j1jMtCqZq/q6fvEBLAaBM=;
        b=cHu4L21sm1lQzHZOjVHTAjZfrS5QPtpBMoVq1DAhJpvD0C+xTVc+RkobT/+1s/sOf2
         B8k2iSwn6yzWEKOoywHHMipOlha0zu0u2Ml60Bw9JrMUod6OTD769MxxDocmyIJWg0j5
         xrZ/p7ZGDiFqrGyzfWavBTJ4xe60f8Fp9GnMrwyGbaFxIblmaMHDBo1GhZX7frwNobVR
         sPCmN5T8WPSGp7xfxTJEUuuRoYIRwo6dRVvbZmZumIQ278twRo2t8V1Vs6BR+ZcPsu7K
         RTg3ofoZmuU/DAwN57em/1/i+5kqwYvTynM+nA7c60cHEnOxNOWbjMccOO5bJHzP66Pg
         O/Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771521785; x=1772126585;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DQ0IUqmOj4ktterC5Me/w/j1jMtCqZq/q6fvEBLAaBM=;
        b=Wr7P5Jb7C62Ab0CBaw6WQPou89CaEBZPhTnD8fHRB+N55Ey7nP3068/99Rr8atkvW2
         6pUCzxm7uGfpTCBG33iQnIQgLi5oIpibqh9rcwcVmCrl3Y1eRhT5S3icl8l4PKg1Dok0
         OYok0DPmP6ZaeVWRCXhSN8qDRbFeuKIcdLo0eU0skVTLsyu87snvvOiryjGmsaGxCLGl
         Cr0VtlDj6YlIKXSDyIn02QJcncUXr7LlaThXhLzvFc/w97eU3ewyV+xtBBJb8QT+sb3j
         LwRW9AprYlE4xJPVAW5VEVIi4LYYifldgM+3lP2OCPd/Ug3vbRZV/cdumQ4ku4ASP6QY
         EhZQ==
X-Gm-Message-State: AOJu0YxxVuTM2GRTXgNdNaBVHuCAisQVy1w3z1n+J1Osl4+4ZoR9VS7w
	rA2x8t01t5Gl7N8PwOf6CgHwWHi6hTvW0uYXfNKlcKSl7Sv9HsuekIccKXy5cOh0erjKUWC+bPC
	gdnNwbQ4hXkstGWjRMrEnUejnfPGyBrCkQ2Le
X-Gm-Gg: AZuq6aKZilDio9DQVlxwM4ZHSIx+lunRJhaVDE8rMbkBA5iyjIjJIjDLUWcWh+hz0f4
	ZK2MV5Z0Z5rE9Cs8fBZieZ0oWtv6KZU1l1JqBrmuvNCvrdxcTBzupgQuWUpie5OBVaG0g8tweVY
	z74MLn35b+NhjkvsUfNvT8+89JWHTeOiMoHnOewZpUlSoYT6MbouEd3h1Fd+pEylJqB7aUZJgk4
	xWMMjUbXA280Xwg7c3NtuAwGz7kAJ4uGT+MJP4wurySDL2aWMQWSS4paeSDruPifPjcTDmYOD/D
	vWi+aNqKD8EeeJf4/vN0uo7BAPEE0zfSPb4sUijcYLVkdzFr8jPuCopI92gDoNl9Uk/wCSQcc6U
	FFwLRJojX+vsDcSUxz1LVNA+1FIMQVQqCmaZICC936dXtZsSgSJ02pQ==
X-Received: by 2002:ac8:5ccb:0:b0:506:bb3d:384c with SMTP id d75a77b69052e-506bb3d4c96mr198048761cf.10.1771521785284;
        Thu, 19 Feb 2026 09:23:05 -0800 (PST)
Received: from c7-smtp-2023.dev.purestorage.com ([208.88.159.129])
        by smtp-relay.gmail.com with ESMTPS id 6a1803df08f44-8971cd571a2sm31063356d6.20.2026.02.19.09.23.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Feb 2026 09:23:05 -0800 (PST)
X-Relaying-Domain: purestorage.com
Received: from dev-csander.dev.purestorage.com (dev-csander.dev.purestorage.com [10.112.29.101])
	by c7-smtp-2023.dev.purestorage.com (Postfix) with ESMTP id 995183400C7;
	Thu, 19 Feb 2026 10:23:04 -0700 (MST)
Received: by dev-csander.dev.purestorage.com (Postfix, from userid 1557716354)
	id 7CDCFE41AE3; Thu, 19 Feb 2026 10:23:04 -0700 (MST)
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
Subject: [PATCH v3 0/4] io_uring/uring_cmd: allow non-iopoll cmds with IORING_SETUP_IOPOLL
Date: Thu, 19 Feb 2026 10:22:23 -0700
Message-ID: <20260219172228.429479-1-csander@purestorage.com>
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
	DMARC_POLICY_ALLOW(-0.50)[purestorage.com,reject];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[purestorage.com:s=google2022];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12340-lists,io-uring=lfdr.de];
	FREEMAIL_CC(0.00)[vger.kernel.org,lists.infradead.org,gmail.com,samsung.com,purestorage.com];
	DBL_BLOCKED_OPENRESOLVER(0.00)[purestorage.com:mid,purestorage.com:dkim,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns];
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
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Queue-Id: 03C4C1612A3
X-Rspamd-Action: no action

Currently, creating an io_uring with IORING_SETUP_IOPOLL requires all
requests issued to it to support iopoll. This prevents, for example,
using ublk zero-copy together with IORING_SETUP_IOPOLL, as ublk
zero-copy buffer registrations are performed using a uring_cmd. There's
no technical reason why these non-iopoll uring_cmds can't be supported.
They will either complete synchronously or via an external mechanism
that calls io_uring_cmd_done(), so they don't need to be polled.

Allow uring_cmd requests to be issued to IORING_SETUP_IOPOLL io_urings
even if their files don't implement ->uring_cmd_iopoll().

Use a new REQ_F_IOPOLL flag to track whether a request is using iopoll.
This makes the iopoll_queue opcode definition flag unnecessary.

The last commit removes an unnecessary IO_URING_F_IOPOLL check in
nvme_dev_uring_cmd() as NVMe admin passthru commands can be issued to
IORING_SETUP_IOPOLL io_urings now.

v3: fix REW -> REQ typo (Anuj)

v2:
- Add REQ_F_IOPOLL request flag, remove redundant iopoll_queue
- Split IORING_OP_URING_CMD128 fix to a separate commit

Caleb Sander Mateos (4):
  io_uring: add REQ_F_IOPOLL
  io_uring: remove iopoll_queue from struct io_issue_def
  io_uring/uring_cmd: allow non-iopoll cmds with IORING_SETUP_IOPOLL
  nvme: remove nvme_dev_uring_cmd() IO_URING_F_IOPOLL check

 drivers/nvme/host/ioctl.c      |  4 ----
 include/linux/io_uring_types.h |  3 +++
 io_uring/io_uring.c            | 10 ++++------
 io_uring/opdef.c               | 10 ----------
 io_uring/opdef.h               |  2 --
 io_uring/rw.c                  | 11 ++++++-----
 io_uring/uring_cmd.c           |  9 ++++-----
 7 files changed, 17 insertions(+), 32 deletions(-)

-- 
2.45.2


