Return-Path: <io-uring+bounces-12321-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id wNhRONtqlmkqfAIAu9opvQ
	(envelope-from <io-uring+bounces-12321-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 19 Feb 2026 02:43:55 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E14F15B686
	for <lists+io-uring@lfdr.de>; Thu, 19 Feb 2026 02:43:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 388A3302DA37
	for <lists+io-uring@lfdr.de>; Thu, 19 Feb 2026 01:43:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B23724C676;
	Thu, 19 Feb 2026 01:43:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="Dr+L1y1l"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-yw1-f226.google.com (mail-yw1-f226.google.com [209.85.128.226])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C867A1C8603
	for <io-uring@vger.kernel.org>; Thu, 19 Feb 2026 01:43:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771465427; cv=none; b=GsaaoZumb1j25q4RB8iedV7qX6ktQq5URK38g7FHbKP+fkE3S6Byj6kUESNELqPGK0fu6cqE12Ke+unc3+PkZ9iAdj1PNhVvN91sLTdV7Q6N1z8k/eNBL1/lJqcPklYKacgFUnt9UqPlTD+V5yjWY+vo/whcC6L3gAkmNlOkUOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771465427; c=relaxed/simple;
	bh=DZg9VoqdP/QuKYD43YvT2sDv0fFZLN7Cs0lGYnQNZIU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=W39OLNVrc1ZP1nH+Ajna1G1yQCa/03i16YfIzIeoPD/M9tvEd4n0UzdxUb3YwSYzSPhQXmC4zaN6R+I2lU+hTiojDa2Pz6hCYQ3hOQvk8dYe+tcPpdMLY7h7ZQCt52s76KVtJ6KSuFsDUO9wjnxTZYB24r7mSN7SmZhv019XECY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=Dr+L1y1l; arc=none smtp.client-ip=209.85.128.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-yw1-f226.google.com with SMTP id 00721157ae682-794f7552dcaso123557b3.3
        for <io-uring@vger.kernel.org>; Wed, 18 Feb 2026 17:43:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1771465425; x=1772070225; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=CUfTsb5rmJvqQzp2mqu3jDKb9VPW1X5fRtaazVNqCUA=;
        b=Dr+L1y1ldZE5mKf6Y93t3MuA5oEDFTci9s98tz/kzrJjYEaRmkh99SXkpsk1xkS/pH
         9uXo9a1nPeX4kxvVS+WRuM5HYDFCzIxE7C/D2ui6id2CFB8suxvjR0mttjJBEqu+w0G7
         MhFzAJlpX+FEscTKK02TNthMmJn0iVNNRs4xq0dzkbmQiLRmooqrosWx8lTJQ5KsYnHa
         wgkOL+m8Vk3WYZaEnxMWVEqZ0/47uRFW8IX9luA2/IaGr1WeUN1EPxwF3zyEsdUix2Rk
         ymabfQ+9uuJt2nTsZi2qG2puTum8PHOHmufmnAZMDGwnlwLOA/i5qH1b4MI+barjSfZ4
         0DKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771465425; x=1772070225;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CUfTsb5rmJvqQzp2mqu3jDKb9VPW1X5fRtaazVNqCUA=;
        b=QZxXLXkuMw2HBmiQBBzYJ65vjXqAh+FYMXknkSLxl1PTH1oCb8scpgc2XjPxDunRvI
         QHdgoyLgVl2zFylRGlr0uWtSHj/kDC9kQwCL7G3cyjixzN5UliHZIxOcowZZ1MurgVyJ
         ZcToMv/eI1UvxLNynsfodgIbSXfikdPSpQ+XDVRo8EmInJ14GUCc1rGPfuipahSXDFE6
         m46yivHTf2qdqq68ju61GkPXCTqd5LHSfK5Xz/NLft2Z3+YJE5jwV0WQKaHpOGTtatf8
         592sf8O1oCkWKOjGZRqoW7gyWra0dq2S7pw8rUGeQDPOEUgdI3arm8IVlxgnR5p3zKdp
         mxVA==
X-Gm-Message-State: AOJu0YynEC+aGsBGMdq4vFgNCitZTLbQSBJ5IpUGL3LzkmaiHCWyIeTC
	vC2j0iptB/A7So6nI+z2fZ6AlLHJ7dsEome2Ml1PUm7ZC+vP8gTCW/VTQafQ23nGX70rwbRHcod
	yqwLFnhw9t95gRutQUBCpGb1SUb0lApQnR2XN
X-Gm-Gg: AZuq6aLO/28hKwdIzlyNDjr653YYPc2cdTn3nPq0X3eKjXcYp0pUsUEdkISr1+e+FYz
	DEVF6I8m4XfzKln8tAi25gFYYviBDLkfEDHSBYosA59Cer/4Ur+SUl4n0wJ4IHd+BjnvH75VyxB
	rapkfPHbSNG9kAwWbzuZLZQYGhbToDHvXUHLNHaRtc7Q/bkUc1wUgoMyfyEAkHxTEyEf6Bbx82c
	YWCvrRH2q0EMYee5gC5dIcXZeZdR8oM2SSYDDCrjte21oqn8QZd2J/a0HYcHfxJMmZ5OH3IA2D7
	u8BGCHM+udGj8aRDHRboAozuSg7B8vZC+bKw9H1qvVamARxm7B3+QvjUKZ+bPifHrhR9tmFUKmL
	yEPiNTlP024UFiYj1nH00XH7XpbL6VWjMS9z3fQGPS5HXrqeEqhpKpA==
X-Received: by 2002:a05:690c:c50c:b0:797:df7c:3de8 with SMTP id 00721157ae682-797df7c60e3mr73200517b3.1.1771465424811;
        Wed, 18 Feb 2026 17:43:44 -0800 (PST)
Received: from c7-smtp-2023.dev.purestorage.com ([208.88.159.129])
        by smtp-relay.gmail.com with ESMTPS id 00721157ae682-7980516ad33sm705197b3.2.2026.02.18.17.43.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Feb 2026 17:43:44 -0800 (PST)
X-Relaying-Domain: purestorage.com
Received: from dev-csander.dev.purestorage.com (dev-csander.dev.purestorage.com [10.112.29.101])
	by c7-smtp-2023.dev.purestorage.com (Postfix) with ESMTP id 4C28634027F;
	Wed, 18 Feb 2026 18:43:43 -0700 (MST)
Received: by dev-csander.dev.purestorage.com (Postfix, from userid 1557716354)
	id 39FFEE41D2F; Wed, 18 Feb 2026 18:43:43 -0700 (MST)
From: Caleb Sander Mateos <csander@purestorage.com>
To: Jens Axboe <axboe@kernel.dk>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sagi Grimberg <sagi@grimberg.me>
Cc: io-uring@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Caleb Sander Mateos <csander@purestorage.com>
Subject: [PATCH v2 0/4] io_uring/uring_cmd: allow non-iopoll cmds with IORING_SETUP_IOPOLL
Date: Wed, 18 Feb 2026 18:43:31 -0700
Message-ID: <20260219014335.9061-1-csander@purestorage.com>
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
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[purestorage.com:s=google2022];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12321-lists,io-uring=lfdr.de];
	DBL_BLOCKED_OPENRESOLVER(0.00)[purestorage.com:mid,purestorage.com:dkim,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[csander@purestorage.com,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[8];
	NEURAL_HAM(-0.00)[-1.000];
	DKIM_TRACE(0.00)[purestorage.com:+];
	TAGGED_RCPT(0.00)[io-uring];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Queue-Id: 6E14F15B686
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


