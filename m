Return-Path: <io-uring+bounces-1843-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 8CE3D8C1475
	for <lists+io-uring@lfdr.de>; Thu,  9 May 2024 20:06:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D4A4AB219CF
	for <lists+io-uring@lfdr.de>; Thu,  9 May 2024 18:06:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD857770FF;
	Thu,  9 May 2024 18:06:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="dVBrBlMx"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f50.google.com (mail-io1-f50.google.com [209.85.166.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49E6C74BED
	for <io-uring@vger.kernel.org>; Thu,  9 May 2024 18:06:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715277993; cv=none; b=FXx9sKx9fZokXb6CIVDCmBJ67r/XQJ/gYMMvYH7Bvcj1rpTfBpqcCLf/Z5QqZuuJQTlaN94eYdpB945y9TQAxtQsow5Mi6/24JBDZwIFpdXtFE8TEJ7/yd4Qk2ex9bcVJwUTENOIXsqFgr+RH/DPVxQM6hmEXDidjUiLzy4nPsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715277993; c=relaxed/simple;
	bh=nJvf0+19Ak6nMFO86nEpkL3u66B7rYi6FXxb2XlHaao=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=OnyEumzHwqxx6enT194Gvf5q/jDcgdvgdSw/emrLTFOTdgHg1NihE2w2t5b/1J75VA3naLHDG7vE2bqkxK2CS7rcv06CA6OXXtbJ1eP5k8NPoMtYaLsUs9n97pEqJgCCLaxr/01OjULYosbG8X4NbON0dcm1SHCq15FJEk778ko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=dVBrBlMx; arc=none smtp.client-ip=209.85.166.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f50.google.com with SMTP id ca18e2360f4ac-7e18fe3164eso9758639f.2
        for <io-uring@vger.kernel.org>; Thu, 09 May 2024 11:06:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1715277990; x=1715882790; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=VuaEukQr5J4tL+gRi+BGlLSodzKp68yXFmo7ZSi6OlQ=;
        b=dVBrBlMxIfqzqYKy+8TEMlw8Dn8xKwX1nMAggEsR3C8S0MowieY/yiQp7Xefmu95Lb
         98ZbwJr88ZgMeMdFGshcjb+hplSpBPY1qW8pe2QNf3ijgSz9yhmsTkrharFJcTtwZTBf
         vBo3hDaeAMC0IaDySp24hQpZNw+b/oKhFEWVKebSRUUPEz2M2SyeJpkPDYNn1HylppzG
         bh6uhSvcKpzZUgokNelbnQSS6ns50KohOLKhCY+h6/Az4OA0f/7dLX2rGR9j89uta58h
         uGqPLN14yimIfzxn7/uuYmbxrLSTe5U7IhLlG67T62hGyFzkEBq9JZfN2WcOSp1ElkBR
         Euhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715277990; x=1715882790;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VuaEukQr5J4tL+gRi+BGlLSodzKp68yXFmo7ZSi6OlQ=;
        b=jn7OYt7YU1D1L0gqXtCP9ai7UdDZp8wIV5FzNOdDg753B25GWh8vizMp8i8GdJGRg7
         eVZdBtgPAAsOi84QGyFo1MJIHK6//2bQFw9KB3xuH2ivPTgdGeDtdKNLjDiVhKagk1p5
         xa6eQoVPSiFCgRCrzoOp2u4qERO/uXCFHzgsZMQbsvqL8wt2/YdOfAX+85e1SDUVHZYf
         xdh91l9tnYB7c2jKYXfHgwkRdo6BQWLBNYeq3EJz1fcmh4tAvQjcoc+l7KNLytL9tD8L
         t8L+FXRZlRsNWruJeyoEVjkTHDOkJkp5vPqMo0IyGycBXGQQTmzgptNqziXKcHmrMScR
         rR2w==
X-Gm-Message-State: AOJu0YxHWD3DrxKoEK4h1mD//Keaq9iv2qmW9k/m7NR/kjbXm80B4tZ5
	p5GY5CnyQshtN/melD0KenaAZ+F2bLWCV+mcjHWGXowePeA4SayHCyACBdjOJbaAx1c1lLJ89UR
	r
X-Google-Smtp-Source: AGHT+IGlgkx997Vi/uU0WCbQDYcHNPDaGv6PRCSt8JvQCfR93Xc8AcpWOapgSvjFHzDeEcG2Y2vj0g==
X-Received: by 2002:a6b:d203:0:b0:7de:e04b:42c3 with SMTP id ca18e2360f4ac-7e1b5022577mr62443939f.0.1715277989657;
        Thu, 09 May 2024 11:06:29 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-7e1b23ab4f6sm19468739f.50.2024.05.09.11.06.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 May 2024 11:06:29 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org,
	netdev@vger.kernel.org
Cc: kuba@kernel.org
Subject: [PATCHSET RFC 0/4] Propagate back queue status on accept
Date: Thu,  9 May 2024 12:00:25 -0600
Message-ID: <20240509180627.204155-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

With io_uring, one thing we can do is tell userspace whether or not
there's more data left in a socket after a receive is done. This is
useful for applications to now, and it also helps make multishot receive
requests more efficient by eliminating that last failed retry when the
socket has no more data left. This is propagated by setting the
IORING_CQE_F_SOCK_NONEMPTY flag, and is driven by setting
msghdr->msg_get_inq and having the protocol fill out msghdr->msg_inq in
that case.

For accept, there's a similar issue in that we'd like to know if there
are more connections to accept after the current one has been accepted.
Both because we can tell userspace about it, but also to drive multishot
accept retries more efficiently, similar to recv/recvmsg.

This series starts by changing the proto/proto_ops accept prototypes
to eliminate flags/errp/kern and replace it with a structure that
encompasses all of them.

Then patch 2 changes do_accept(), which io_uring uses, to take that
as well.

Patch 3 finally adds the basic is_empty argument to the struct,
and fills it in for TCP.

And finally patch 4 adds support for this in io_uring.

Comments welcome! Patchset is against current -git, with the io_uring
and net-next changes for 6.10 merged in. Branch can be found here:

https://git.kernel.dk/cgit/linux/log/?h=net-accept-more

 crypto/af_alg.c                    | 11 ++++++-----
 crypto/algif_hash.c                | 10 +++++-----
 drivers/xen/pvcalls-back.c         |  6 +++++-
 fs/ocfs2/cluster/tcp.c             |  5 ++++-
 include/crypto/if_alg.h            |  3 ++-
 include/linux/net.h                |  4 +++-
 include/linux/socket.h             |  3 ++-
 include/net/inet_common.h          |  4 ++--
 include/net/inet_connection_sock.h |  2 +-
 include/net/sock.h                 | 13 ++++++++++---
 io_uring/net.c                     | 26 ++++++++++++++++++++------
 net/atm/svc.c                      |  8 ++++----
 net/ax25/af_ax25.c                 |  6 +++---
 net/bluetooth/iso.c                |  4 ++--
 net/bluetooth/l2cap_sock.c         |  4 ++--
 net/bluetooth/rfcomm/sock.c        |  6 +++---
 net/bluetooth/sco.c                |  4 ++--
 net/core/sock.c                    |  4 ++--
 net/ipv4/af_inet.c                 | 10 +++++-----
 net/ipv4/inet_connection_sock.c    |  7 ++++---
 net/llc/af_llc.c                   |  7 +++----
 net/mptcp/protocol.c               |  8 ++++----
 net/netrom/af_netrom.c             |  6 +++---
 net/nfc/llcp_sock.c                |  4 ++--
 net/phonet/pep.c                   | 12 ++++++------
 net/phonet/socket.c                |  7 +++----
 net/rds/tcp_listen.c               |  6 +++++-
 net/rose/af_rose.c                 |  6 +++---
 net/sctp/socket.c                  |  8 ++++----
 net/smc/af_smc.c                   |  6 +++---
 net/socket.c                       | 15 ++++++++++-----
 net/tipc/socket.c                  | 10 ++++------
 net/unix/af_unix.c                 | 10 +++++-----
 net/vmw_vsock/af_vsock.c           |  6 +++---
 net/x25/af_x25.c                   |  4 ++--
 35 files changed, 147 insertions(+), 108 deletions(-)

-- 
Jens Axboe



