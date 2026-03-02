Return-Path: <io-uring+bounces-12520-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id wHw9MPjIpWnEFgAAu9opvQ
	(envelope-from <io-uring+bounces-12520-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 02 Mar 2026 18:29:28 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 330021DDCD6
	for <lists+io-uring@lfdr.de>; Mon, 02 Mar 2026 18:29:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id B8C383025C52
	for <lists+io-uring@lfdr.de>; Mon,  2 Mar 2026 17:29:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6386F42DFEA;
	Mon,  2 Mar 2026 17:29:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="GBnhs3gE"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f98.google.com (mail-ot1-f98.google.com [209.85.210.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0980A41B37F
	for <io-uring@vger.kernel.org>; Mon,  2 Mar 2026 17:29:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772472564; cv=none; b=B6IhWy4ARErnIECHo45UF4uZI21RfiY424DCBLOn2U5oJ+1miOqtSDipnags8h+UcPbOJ/2uUrbwuKQtV6C9oEzsCsUpxJX45WJWExysdY7HbkntnpSY4rWYQSZ+N8hsLtO+XeMBlG2EpGq9yFQEcEuuX5VKA3SyDdq50Dtd0fg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772472564; c=relaxed/simple;
	bh=tNf7vH82DXpbm+18bIBSTYtImsiPs9CXTfqOFBdoftQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=SObqp7jq4Xt2A8zZCPNasJs/ycm/tEe9Pyf0C2GI1jV/6JE2DHPWelRf1WBXBlF0O9e2/I6IWs3TS6M5+i+e+04NWLUv1bsTvb2dA81c0octI7CuFxgspWaT99Xjd34e553fcjgYmb40K0sifT7Av6jAVOLrk0xdbqaYcqZCLcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=GBnhs3gE; arc=none smtp.client-ip=209.85.210.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-ot1-f98.google.com with SMTP id 46e09a7af769-7d2ebc06f66so806457a34.0
        for <io-uring@vger.kernel.org>; Mon, 02 Mar 2026 09:29:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1772472562; x=1773077362; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=tuZ5NgGmMK+fSDZK0DCtbPhVzRqmyqfPDxUv7waUs3k=;
        b=GBnhs3gEv2XJ9e/TqDIGG6W2GX1y+S8h3LdvpIrP9lkeU8qUl7gHZdVmCyIiVwy7BZ
         bAnkk+42Rkc1c5xEgi8nhd7uVTfqCRJwQb/Mln+RuUynnO9l1oySpyFyG0vjvpF3Av5b
         Iyy9Z76C+YgyId5vjEHV1sTPWaW2DXix2jkduMjGh6K08+rdb+0N9B3IvkTKlenDvwjR
         AlXuX7ft1LOCfKPonXgb1z5FXDwdhcaOfGRf4bKgkQ0bput7qUJMsC0XOXWLz7w5TYzi
         cb/jZTPTvrY37MAtfxcemvuv1QlmLBIC+9ee0U3iES7Ry43k+VzNalJWsVM6u3f/w5Gg
         1g0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772472562; x=1773077362;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tuZ5NgGmMK+fSDZK0DCtbPhVzRqmyqfPDxUv7waUs3k=;
        b=Hgk2z7RduoJjNibTk+XYB613QlfmTovFTJ7EueOuNJSVqnq/8EkFFG2nkIqNtYK+81
         cJSPjVlWgMGyHTByB5+uhXtlxJPxIxxK/vPb5v7PPA9DWRUfFFhG3lXBEEtUmw7Te7Mb
         UXLj28GNEc23IAcnX+6XyNPmm1SI8jRAjnbVVAw+uYFT5mzosT2UMBfb0wB/gLY2QAGD
         DkTp+npJ5VQeLKwLKJz8QDbNhMO8i+an/LNL35G/CJdfLauxDJ+1KYUC+nFjafiTawiF
         PKjdZLsagxzqnJsDwSS0JFnXCal/7KG+SYxHEdHHAi0+6MiFwSq69vc8t7IyJMJCcV+a
         0XPw==
X-Gm-Message-State: AOJu0YxmL4CKxTjNiKurYQ26nqLHcJn/hSIrFGqRCyjEE6wVFzwXMKrT
	3zwmEXJE3cyCxSijHuMe8t89kvO7ODVgEmUIm9gv+31OdDcYLFokIveLlD9D5Ir2s4VBGggiUOv
	Wt8XHHuTd+SeOuweb+ttQrbJiBNcf45J8SOdW
X-Gm-Gg: ATEYQzzbt1kV8tlWkbCI9HXhCacdeO4OGZiRDnUtD3Sv8Y/6W+ONV7ROHnN5n3gn8Vd
	H9rRfTjLEywQZZMAgNFcLk3u5BWDWFM2namZg4lOSzYDfv/QJUtwDMyHBoqLoDysLEoFfnFvvmP
	3U/OEYFutGOy5NDvYAewdgIpEb4nIBizHY1uEDVa1bF1Jxs8c2oDi4By+1ZvVW3VaQ4rxx5pTzN
	ZKxbVgFkkMm+jtFDm/QcCiHZR+JLoMMDG3iW4XltxazdYnsGg4Keti+X6R9AM8UC/979GH8LbSC
	knVmn7tpf3fouboPRsh6PQfxfI+PoOFVgRyJfvM0Pbhc2lH6UTUJ+NrMlSnSdBtMKuxllghfFYs
	UspRJTlyylnIhouEZFn6t1OEjGnlUBdD5NqocesMTS4SZljQKWzcYGw==
X-Received: by 2002:a05:6830:718b:b0:7d1:474a:191f with SMTP id 46e09a7af769-7d591a02761mr7098900a34.0.1772472561822;
        Mon, 02 Mar 2026 09:29:21 -0800 (PST)
Received: from c7-smtp-2023.dev.purestorage.com ([208.88.159.129])
        by smtp-relay.gmail.com with ESMTPS id 46e09a7af769-7d5865024ffsm1764607a34.4.2026.03.02.09.29.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Mar 2026 09:29:21 -0800 (PST)
X-Relaying-Domain: purestorage.com
Received: from dev-csander.dev.purestorage.com (dev-csander.dev.purestorage.com [10.112.29.101])
	by c7-smtp-2023.dev.purestorage.com (Postfix) with ESMTP id 09317340199;
	Mon,  2 Mar 2026 10:29:21 -0700 (MST)
Received: by dev-csander.dev.purestorage.com (Postfix, from userid 1557716354)
	id 00D5AE41FBD; Mon,  2 Mar 2026 10:29:20 -0700 (MST)
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
Subject: [PATCH v5 0/5] io_uring/uring_cmd: allow non-iopoll cmds with IORING_SETUP_IOPOLL
Date: Mon,  2 Mar 2026 10:29:09 -0700
Message-ID: <20260302172914.2488599-1-csander@purestorage.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 330021DDCD6
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
	TAGGED_FROM(0.00)[bounces-12520-lists,io-uring=lfdr.de];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo,purestorage.com:dkim,purestorage.com:mid];
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

v5: perform one iteration of iopoll when min_events == 0 (Claude)

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
 io_uring/io_uring.c            | 19 ++++++-------------
 io_uring/opdef.c               | 10 ----------
 io_uring/opdef.h               |  2 --
 io_uring/rw.c                  | 11 ++++++-----
 io_uring/uring_cmd.c           |  9 ++++-----
 7 files changed, 19 insertions(+), 39 deletions(-)

-- 
2.45.2


