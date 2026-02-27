Return-Path: <io-uring+bounces-12476-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id /80zOiAcomnqzQQAu9opvQ
	(envelope-from <io-uring+bounces-12476-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 27 Feb 2026 23:35:12 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 474571BEB6A
	for <lists+io-uring@lfdr.de>; Fri, 27 Feb 2026 23:35:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 8FB023068EF1
	for <lists+io-uring@lfdr.de>; Fri, 27 Feb 2026 22:35:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0871747AF40;
	Fri, 27 Feb 2026 22:35:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="SZyPbJFS"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qv1-f98.google.com (mail-qv1-f98.google.com [209.85.219.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9926B3603EC
	for <io-uring@vger.kernel.org>; Fri, 27 Feb 2026 22:35:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772231709; cv=none; b=AxBayrcELrDoGmAVKOp97KPJeO0mHJSoRYI2qoGZzec/1nsC85WSqOto4NN+qhYGd1RHCU7+/FJ/VgjGYvG2B9OiVzELbWCk9XxYFZFmwU5rz9x5YqqvDUyB01U8/ozhPG03Zyu3SI93kd8KzJwKZHPr7mj2fckTbRBOejBcPUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772231709; c=relaxed/simple;
	bh=4mY3cJ9odN+C0yuy3lnfg6eSnPBftceED+7+u938yws=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Io6WG7bj2qlZJxT3ZxJoIiYXOzsG8ZoWEst3GTjdJ5/rIrTxYlDJ1D8qrefuOlkCI2XDqjrKwNxwloenGI4reDO6BqV01bJKwk2QOdJekYxlG4/x/a/hl3d2pA/X1LeuVa4chx4DaDQSxHWRth3nDngmtZUg/hZc2N7JEwOIn5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=SZyPbJFS; arc=none smtp.client-ip=209.85.219.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-qv1-f98.google.com with SMTP id 6a1803df08f44-899ae5bb086so3430946d6.1
        for <io-uring@vger.kernel.org>; Fri, 27 Feb 2026 14:35:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1772231707; x=1772836507; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=RUIpiL+ETinhgcxbF3zsLQKsMyyJnBp6MmzUqHPBa/s=;
        b=SZyPbJFSpvxYp3BFPtnNaaah/Rd7JXzHV9WisoqBVR9yh9Nn7v9rlklPiytfLc4HFU
         J6hw+7YgMtwDi+Dy062hhNB1T5yn1QnGgCSJcUBzdC8sWYX2LXF7Er0kjEcnAVNwy/6R
         VyncUT36KZLAe+vaCYdRNceIYV/H1mHXGhqzpD2YmNWfOhRZ+mtKqgfkEqeG6Gb1b2bD
         brk0CzvqS7VZax0y+BxEOndqsCmQEWFgPi/C1+0zgCFm05s52z9QHNkW4R/1zRkETxGk
         mDgVw7zUOwekFt0ZzNRRqw2n+iofEVuIhyq0I+BvhtQOlufXPrFl/NyCMJMZl60+yA+g
         3zEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772231707; x=1772836507;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RUIpiL+ETinhgcxbF3zsLQKsMyyJnBp6MmzUqHPBa/s=;
        b=KH3jy7gwO+60g6+vhDXmjNGkMBcsAb86U5yAKXuGMOG8KlFnNtAyQlrkENlsnyseV/
         rM/NynZRUtEP9ubrzGBAt7T1TpbsjM+f6phx+6wpEFDno6V+9Zxp2xYoXlof0IjN3WlR
         3KcAGKKl6uz5lIyVUvvULEaCbiT0oSsvMiQLSkuHdNjAIiflG/VZsIlQe/NUAxhyH3sW
         MibA7B1LysVVwMvt8jWJhOUv/U2N466Tae5l5HhTEPl+gEEgY5Zqt201ti2Xpa1JzEF0
         K9J2JGx5kEpu+S9yYCIgXYhsqjJ3Fks+5WqO8lJ3uGyqvr+U/V4Ja40fFPBnENSbFhTq
         jd2w==
X-Gm-Message-State: AOJu0Yzo87u+rA7JHWeEZ09Vfn+8o7l8K8B6YPK5Jw0V0AG24xRcm+/8
	Q19/auAiHg8X/Br9p6PveqHC+Eyq45pd52OGfpyeolwmz1e3NvtXUmDxEt1MTWESWrCTfSzxP2S
	V2DkJPehdrecfRHiuq3i6oowEMdSeTt3YG4TC
X-Gm-Gg: ATEYQzzoOOGApFALcSbm/4cGQeuXhsPgjthl5Z5+6UsoUBZyOX87QcuWUTnIREfQJG0
	exKewhtI7U8SNOFwppt2EBej8GytNh0j4Uri2iLjUrArTNoq1UZOKlfWd8YV1+LgeVe5Kv2G2eO
	MTta2M6YeJhyjSScsenW9hu7wT0sTWymnyOILfvf1p1T7+hmnd1x5IS0Jqm9RU8OUgBlpAD/7Kt
	OTwVT/WIVdJgz49q4A8cO/M7qu6AiEkEOcb0ljKQ4ZFohTP9lvtgYgs8jbD2fqsPwjnMrlzvlT/
	/JcVSPKS1IwxFhctJwD7Q4zN3S1TeEPcMqzo3ktitXK9xaQ93+j096Q/+YG7lK7zAy0SbybxntC
	/JKsWSm2u009Hrl0QxY6Vyd7p6piX5gc2L2ZUT1+LHJ/dNHeZsQ+xfA==
X-Received: by 2002:a05:6214:800a:b0:897:ac:13f0 with SMTP id 6a1803df08f44-899d1d861aemr47334816d6.1.1772231707333;
        Fri, 27 Feb 2026 14:35:07 -0800 (PST)
Received: from c7-smtp-2023.dev.purestorage.com ([208.88.159.129])
        by smtp-relay.gmail.com with ESMTPS id 6a1803df08f44-899c7154514sm5901616d6.7.2026.02.27.14.35.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Feb 2026 14:35:07 -0800 (PST)
X-Relaying-Domain: purestorage.com
Received: from dev-csander.dev.purestorage.com (dev-csander.dev.purestorage.com [10.112.29.101])
	by c7-smtp-2023.dev.purestorage.com (Postfix) with ESMTP id 9592634076F;
	Fri, 27 Feb 2026 15:35:06 -0700 (MST)
Received: by dev-csander.dev.purestorage.com (Postfix, from userid 1557716354)
	id 8937FE420D8; Fri, 27 Feb 2026 15:35:06 -0700 (MST)
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
Subject: [PATCH v4 0/5] io_uring/uring_cmd: allow non-iopoll cmds with IORING_SETUP_IOPOLL
Date: Fri, 27 Feb 2026 15:34:58 -0700
Message-ID: <20260227223504.1162421-1-csander@purestorage.com>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64];
	R_DKIM_ALLOW(-0.20)[purestorage.com:s=google2022];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12476-lists,io-uring=lfdr.de];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Queue-Id: 474571BEB6A
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
even if their files don't implement ->uring_cmd_iopoll().

Use a new REQ_F_IOPOLL flag to track whether a request is using iopoll.
This makes the iopoll_queue opcode definition flag unnecessary.

The last commit removes an unnecessary IO_URING_F_IOPOLL check in
nvme_dev_uring_cmd() as NVMe admin passthru commands can be issued to
IORING_SETUP_IOPOLL io_urings now.

v4: check non-iopoll CQEs against min_events in io_iopoll_check() (Ming)

v3: fix REW -> REQ typo (Anuj)

v2:
- Add REQ_F_IOPOLL request flag, remove redundant iopoll_queue
- Split IORING_OP_URING_CMD128 fix to a separate commit

Caleb Sander Mateos (5):
  io_uring: add REQ_F_IOPOLL
  io_uring: remove iopoll_queue from struct io_issue_def
  io_uring: count CQEs in io_iopoll_check()
  io_uring/uring_cmd: allow non-iopoll cmds with IORING_SETUP_IOPOLL
  nvme: remove nvme_dev_uring_cmd() IO_URING_F_IOPOLL check

 drivers/nvme/host/ioctl.c      |  4 ----
 include/linux/io_uring_types.h |  3 +++
 io_uring/io_uring.c            | 28 +++++++---------------------
 io_uring/opdef.c               | 10 ----------
 io_uring/opdef.h               |  2 --
 io_uring/rw.c                  | 11 ++++++-----
 io_uring/uring_cmd.c           |  9 ++++-----
 7 files changed, 20 insertions(+), 47 deletions(-)

-- 
2.45.2


