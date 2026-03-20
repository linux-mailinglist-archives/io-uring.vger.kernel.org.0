Return-Path: <io-uring+bounces-12764-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id wOLrJfCRvWnY+wIAu9opvQ
	(envelope-from <io-uring+bounces-12764-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 20 Mar 2026 19:29:04 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id B7B2B2DF6B5
	for <lists+io-uring@lfdr.de>; Fri, 20 Mar 2026 19:29:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id A16E5301FB74
	for <lists+io-uring@lfdr.de>; Fri, 20 Mar 2026 18:28:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE11A3D1714;
	Fri, 20 Mar 2026 18:28:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="m/LYiVHX"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FC1D3E6DDA
	for <io-uring@vger.kernel.org>; Fri, 20 Mar 2026 18:28:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774031325; cv=none; b=KXL3H7pQebZrNaIqj4u7z6Vv+e3F0vhtyekGfNLqVwGjjDTCM9kGkdwusNBy1y/YL0K7VHv1fIxV27kM5rq8+5/rZiIoYB01wV/4amU6sm++Rsun8cLXzrhLpQZemaRj6UMxKNPq6Ym1WQLd45cvD8i4kHe/yk2KJgQMqZ8JZ0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774031325; c=relaxed/simple;
	bh=P5Hp8E3zfcxicKGpGG3E5XFkia4eFcFZGJyTqMBAIHw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=qFPe4aOWRG++PIRPLWNVtHF4Ha0/6jGiJUolyyeKadenaBZD/tL9NXW+z4mUgkc2yYworJDf5T4DDvGw5K/N7DJg/H4drhiKTUfB26kd4ugfuAVjIVKaI4YutYb/geyzImP0AJupVMf4Vp7nP0uLdiWf91YKpB7y1+KT7UuDJT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=m/LYiVHX; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-486fb14227cso21949615e9.3
        for <io-uring@vger.kernel.org>; Fri, 20 Mar 2026 11:28:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1774031322; x=1774636122; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=9fisT1MxI/mh7qUk99d+V3DA8M3Q1UdGA67QDCcBAUE=;
        b=m/LYiVHXLL4+7oYfcDH4EavC5Y6Z0grAKkTmFiZWn4Z+gw9aRAu8M/XM+QBlK1d4Fe
         +aHqZryUn4qsEbOwLDHvCfTKdg82rRa7G2Xulq2/R71n4W094nNS7aisG3+an6N4YndT
         fiMitKfn/sUQ3p/+bkz6pQluR1sZGU48WxDGCCyIoGUzLK5eRLwIXFS7vzODdCCcsA5F
         W/6pLQDMdzLpxYdka6vXege2ibvErUG6GQNroF3DAVsi9sEPG816OOZykjgVAAbrjb3b
         pYVp9CbJQdXHQQ+bTs2T+RYsjuM7d3EXv5X9s+BCqScWTE/UuEjnIavvV4TbGY47VWPV
         q1dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774031322; x=1774636122;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9fisT1MxI/mh7qUk99d+V3DA8M3Q1UdGA67QDCcBAUE=;
        b=R3ImuLZS7Z/vQTkHWW0ZjzIPejMpCn+bvAeiM7Gjvnx4PmhM2FjS6bltDIABGBhbNX
         nwcaWXi5QCcwmpaB3/WEScJS6iFzEnqgDBRHzeaqKpqIJ3ver9gsNxq7lfiWszvC9/YN
         kNUo9Aa9Yf2DOy8lxbXbLtcRcJT/NXXPOSNWk3iPd4c5VA7j6V4r6Aw68CEOL6SziTpv
         cZYAsDYwMtiX+9alwL8wfjzuEBhW17Bco/APM5zgaAny05Q4PohgTU/gogD5Myo0H1rd
         YCPQWaKxM/vSsOgtUUgaD8Bihy2sRQJG8O/FEhUqe+wg9T5MFZVwDfzmZVlmGfZlSbnx
         1LMA==
X-Gm-Message-State: AOJu0Yws6WJ+XXmuwmihEeL1w4/sgXvQpk5se/hQZC7fv5m+puSi+ppS
	4tGclihQDByPt43a1NdmC8WkpOH6I8GGLiZj2pKRgrhwAvRKXr94t5YRNrysQICYcFM=
X-Gm-Gg: ATEYQzxNPD5XvPph2XGEO6QHViFMItIp+xUuL1ot7BzHgqG611tHzs9nCdwjcutlFAO
	VSxn/y4bzxse8rbKHBR4XLixhuSW+HXP2NcGiPK3sgpWv5fWzAcgEkJ7iJX+9XEk8/EWj13CKMd
	Z1IK8U26KhGcKlg3cW3XY5dpzilwtyikrQZd/mrdsQSGyclU2djK3Y/kWC34HDu59UHUxEQ1uy4
	WtQ/l/4A0A+413qu4tm/C1mhYNIangXmVYQI5P7J/4vUTEANB5GDt/+EJM4N5yuAOAVQosyFzyk
	pHRcDJrwpRWGnTrAIiOkvk1+ZHv7rZPKKARwq2PQd/0BK4w+IdjwjkEG6RmWsL3nSW4gLgQwqzV
	K4XPDFm/+R4yiyJ/U98LJ5E5jvPTqvi1YKmPd83R7mC/whFx6oEhFvSKs9+PwLpLqfoTCPyfv6D
	3PMw6sj/nNRiinCdcn9ty8JxIhMKcjcEd7W+J0czVoulbAppDN/v4/WdESXQ==
X-Received: by 2002:a05:600c:3483:b0:485:7f45:f71f with SMTP id 5b1f17b1804b1-486ff0293fdmr61652515e9.32.1774031322114;
        Fri, 20 Mar 2026 11:28:42 -0700 (PDT)
Received: from ddp-thinkpad.tail20b0d.ts.net ([80.208.222.2])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-486fe7e2665sm92433725e9.6.2026.03.20.11.28.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Mar 2026 11:28:41 -0700 (PDT)
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
Subject: [PATCH v2 0/2] New IORING_OP_DUP
Date: Fri, 20 Mar 2026 18:23:39 +0000
Message-ID: <20260320182341.780295-1-daniele.di.proietto@gmail.com>
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
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TAGGED_FROM(0.00)[bounces-12764-lists,io-uring=lfdr.de];
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
	NEURAL_HAM(-0.00)[-0.604];
	DKIM_TRACE(0.00)[gmail.com:+];
	TAGGED_RCPT(0.00)[io-uring];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: B7B2B2DF6B5
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

Changes since v1:
* Implemented dup to direct descriptors as well
* dup from fd to fd is now atomic
* Punt to io-wq if the operation might sleep
* Removed prep() check on fd
* Avoided use of IOSQE_FIXED_FILE flag

v1: https://lore.kernel.org/io-uring/086190ca-1c34-448f-a565-aa41f671971f@gmail.com/T/#t

Daniele Di Proietto (2):
  io_uring: Extract io_file_get_fixed_node helper
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


