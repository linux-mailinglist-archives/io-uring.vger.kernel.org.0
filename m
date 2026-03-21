Return-Path: <io-uring+bounces-12776-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SJVYGkgov2k6xAMAu9opvQ
	(envelope-from <io-uring+bounces-12776-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sun, 22 Mar 2026 00:22:48 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id BF2342E7A18
	for <lists+io-uring@lfdr.de>; Sun, 22 Mar 2026 00:22:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 52E943011116
	for <lists+io-uring@lfdr.de>; Sat, 21 Mar 2026 23:22:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90FB52E9730;
	Sat, 21 Mar 2026 23:22:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XXs3Brlt"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51A3B2D5925
	for <io-uring@vger.kernel.org>; Sat, 21 Mar 2026 23:22:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774135353; cv=none; b=cIYNjOEzI1hJ88Lihgs6bx10YtvG9dWXT5X8LFPbi0mx7v4zqTx3JSHMfgUkL93qytU/t3eGHswTqLQ4i0fNit/Bq8VIUz8MCgw3AVxNfNUzTluNXW/8s0q4EuA1fncDrAocDbL7F7nTCSLxsIV6vjH8WbQsYoILARTWQI8sD6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774135353; c=relaxed/simple;
	bh=UaxvNqszre9c0sz3+btyqg9Gq0GYUJG2+7kup9nE+OQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Oxq4F3a9ux8FhhC/RvFk9UgSp1qXrpXEPNAZzyZnemLpd6vPlyS2vRXn0jdFn1iMLFZZTtQvagnt/qGzSI1ukm1UwTy9BeY+Nt6NWjjTG5vI27Xxp9qHB3ab/9hJR7EKnCYXtMCUOR1VxZ8eSLWs0cpz8qH0i0tzu/KDaSVwMEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XXs3Brlt; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-439b2965d4bso1131384f8f.2
        for <io-uring@vger.kernel.org>; Sat, 21 Mar 2026 16:22:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1774135350; x=1774740150; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=nv4o2v3uHPxntCmHjgj3+r2/LEn9pVdHbSqfA14Nq34=;
        b=XXs3Brlt86ETZyJY+FB2jX8oExdzhpYtIQXXqop0zKNXBNEfZDsB2fxMjkCpAZKlie
         pogmOSiEIVPXnW10cCy66Ifb+BTKzGzQHXgYhItFER8HQuGz9luXuh0RJWbA9K7LBghw
         x38PkwGk+qPzgvgewnMjPagzz4DeTBOmLwaHA/XC7v4BCbW1MoX8hwgDxnu8rNd5YPYY
         S4rZfoD/yZTH/3WPKtieqO2VWsm4IyyEolkNa4+tQj/GPcYMZsimSv5SgJd5z5AAmtzc
         fIrymVKeMYYAjckFSorFjJDzqdp01lCq/SX01WVEsB/nHUT3iTm4jUyyigl3Fg9Suker
         r3dQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774135350; x=1774740150;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nv4o2v3uHPxntCmHjgj3+r2/LEn9pVdHbSqfA14Nq34=;
        b=nSyK2IHHDoCypdQY4b6bPUmhNH2ufrBWmBaDUDpjmQJAJolgRCE0JZyDSVq7of+Jl7
         d+yFzOOTaVXBVnh+cJDEoqUzrNW6/iRhyCKg5FF64Q9PZapMO2MuyS2pXaBCPW6rcHEP
         ZEilNPmCY4IQfLOrEgujM4tKNeoH44rsU5sPJ09CvA0LTFFIGD1FG2NVjX3TZ6NmuoL+
         kLw3JcoR1pw3c8wpzB6zkEpnhOFJ92bj3Fn3j0etfm/U2aslAuEcidhMnTigxvJ7w2zX
         wXoRzSTJ4tFy9z5X2Jjg0Y/CElYmj3OpBa7hkvDgjx+rbhFParMp1dKcK/+gU6MeaP2p
         EFQw==
X-Gm-Message-State: AOJu0YyfryD2K1Y/XTH+as0UCzYGC8DKvAVRZ8sSmrPxAZDuDxE3EGZT
	bk4cJXGj1BFbrnEiyBMQy2E9NQW0CQrLZT47Q4BYqw0bX4/ELW/T7vfWQWRi8ybQn/k=
X-Gm-Gg: ATEYQzyT2l3jdvr14iDTAreYFIwOBWKXFaia9NZvL+r12BXPAOdyHs2vsQoFxCMyLOF
	6aPxXsLGN/nkl/pJ/Cng85+bfLn9aa1W6m9FuiRSLIbnFBVs4barlxPO/+++fMOpLW/K6p6l/QS
	drDMwyEXR5M+0/Rre/AM/3Non+lVNt2/uIbKOkKzWzlgC41alzoAaWkQmGwnvdKWqiNB1gFRupv
	DruBCSCVlzBvyaN2553vEK2XLsVCyQaFacgE/UGZuiiL7TRwh5g9dUsxHi1GIxqwDfcGFmlbJd5
	R+8nncOWbtzP31tD/FoqX2uTclr/1m/EYYepzYpBEz62mAEy224Vurp/6C4u8KSu4OE0jFX202H
	EUOyjN8xmT9B5maMR8U7u8oKo165zkM0k6TmIDsLmbOyDMiPJFccmHIcJ0POlRhw1ZGarcIMQXY
	uO1xebJSsco5beBttJA6FHjrZst3sPjPtCqcWUYLtRMmexAHCJwdzaK13FeuE=
X-Received: by 2002:a05:6000:a8e:b0:43b:3cdc:9429 with SMTP id ffacd0b85a97d-43b64243307mr9698070f8f.1.1774135350250;
        Sat, 21 Mar 2026 16:22:30 -0700 (PDT)
Received: from ddp-thinkpad.tail20b0d.ts.net ([95.141.20.197])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43b6425eeb4sm15609897f8f.0.2026.03.21.16.22.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Mar 2026 16:22:29 -0700 (PDT)
From: Daniele Di Proietto <daniele.di.proietto@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	Keith Busch <kbusch@kernel.org>,
	Pavel Begunkov <asml.silence@gmail.com>,
	linux-fsdevel@vger.kernel.org,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Daniele Di Proietto <daniele.di.proietto@gmail.com>
Subject: [PATCH v3 0/4] New IORING_OP_DUP
Date: Sat, 21 Mar 2026 23:21:38 +0000
Message-ID: <20260321232142.911280-1-daniele.di.proietto@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TAGGED_FROM(0.00)[bounces-12776-lists,io-uring=lfdr.de];
	RCVD_COUNT_FIVE(0.00)[5];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[kernel.dk,kernel.org,gmail.com,vger.kernel.org,zeniv.linux.org.uk,suse.cz];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[danielediproietto@gmail.com,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[9];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	DKIM_TRACE(0.00)[gmail.com:+];
	TAGGED_RCPT(0.00)[io-uring];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: BF2342E7A18
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

The new operation is like dup3(). The source file can be a regular file
descriptor or a direct descriptor. The destination is a regular file
descriptor.

The direct descriptor variant is useful to move a descriptor to an fd
and close the existing fd with a single acquisition of the `struct
files_struct` `file_lock`. Combined with IORING_OP_ACCEPT or
IORING_OP_OPENAT2 with direct descriptors, it can reduce lock contention
for multithreaded applications.

Changes since v2:
* Split the fs/ changes into separate commits
* Minor fixes, as suggested
* Avoided use of gotos in io_dup_to_fd() with guard(), as suggested

v2: https://lore.kernel.org/io-uring/20260320182341.780295-1-daniele.di.proietto@gmail.com/T/#t

Changes since v1:
* Implemented dup to direct descriptors as well
* dup from fd to fd is now atomic
* Punt to io-wq if the operation might sleep
* Removed prep() check on fd
* Avoided use of IOSQE_FIXED_FILE flag

v1: https://lore.kernel.org/io-uring/086190ca-1c34-448f-a565-aa41f671971f@gmail.com/T/#t

Daniele Di Proietto (4):
  io_uring: Extract io_file_get_fixed_node() helper
  fs: Export expand_files()
  fs: Export new helper do_replace_fd_locked()
  io_uring: Add IORING_OP_DUP

 fs/file.c                     | 102 ++++++++++++-------
 fs/internal.h                 |   5 +
 include/uapi/linux/io_uring.h |  17 ++++
 io_uring/io_uring.c           |  20 +++-
 io_uring/io_uring.h           |   2 +
 io_uring/opdef.c              |   8 ++
 io_uring/openclose.c          | 180 ++++++++++++++++++++++++++++++++++
 io_uring/openclose.h          |   4 +
 io_uring/splice.c             |   6 +-
 9 files changed, 298 insertions(+), 46 deletions(-)

-- 
2.43.0


