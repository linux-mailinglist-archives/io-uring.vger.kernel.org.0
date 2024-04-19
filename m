Return-Path: <io-uring+bounces-1589-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id EFB1B8AAD54
	for <lists+io-uring@lfdr.de>; Fri, 19 Apr 2024 13:08:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A5C2F1F220DD
	for <lists+io-uring@lfdr.de>; Fri, 19 Apr 2024 11:08:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1CDC480600;
	Fri, 19 Apr 2024 11:08:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WLKCnbJ1"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B4127F7C9;
	Fri, 19 Apr 2024 11:08:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713524926; cv=none; b=fICP6NgJBkMWbRsDocYdyDgb+Zv6erIpQH674QcZoBYh7J4XTfeUBvGWg0ooZLBy7ZtTZkynMLrfQPWb4W2oJM/OZ1uqOe7ZDkgBb5Ktw8N9R9JfMagSzbzIG5dxo/KXHpy1la6MK2li1WYScuXmevzBV213GE+l6mtRGsLUwqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713524926; c=relaxed/simple;
	bh=smqyOBR5ExWRQZS/akMGCa8vQ2leCPNtLysIs/HUbvw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=U+u81qJkjC+SSbUVtADHI916iT/UvgHQukMT7pYT0W6NwITT47fElGKZ1XpCmX0aKlaYfuivFSXOTtyTLLSDvFPQgC5OTP4ZioTEEixoRarD0D+Ay+NUnoRWdyLN6hUvLeWIGINKVJrJiRGWwrMzOGuBwo23QPxqAqOgDLZyhJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WLKCnbJ1; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-a5565291ee7so210686966b.2;
        Fri, 19 Apr 2024 04:08:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1713524922; x=1714129722; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=NnZhMrUZqGRI3vIgYFB4ebY43U9G9SiQu0xqMryWhDA=;
        b=WLKCnbJ1QqD0Ucs+vM1q+Za/1ITJMMpFS+E7zMYsLARwWsgdde55FWyICnw8wUKzGQ
         PBUbuKv/cTf0pW8xKyV87BeFKbnk0KxwWLmN9t3VgK6gktx9i2vmGaWhGjpJFRiRXp+O
         Z08OTUX3NiWYDeDSguDXfbGZ1EptjzqWVWwJq8oFfuZoYTvYqiDrR6KAy0k8vFCEQn/5
         UxupsxLoZ3g76/05X1hMoOF4qf8blhtuGCg8UyfixKy/AzgjZmz6EET0ruFXC6mVzjCm
         AgAVlw1sqvc4sjOhscc4WTFkz13yJTbu09ZYim9W0pm638YlHUfyymuLYJj4nrjHzTJ6
         03XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713524922; x=1714129722;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NnZhMrUZqGRI3vIgYFB4ebY43U9G9SiQu0xqMryWhDA=;
        b=wrULvaz0G9zdwZ2Dty9+8ap2hqLxBqH1ldx5GUNkfzax1yD4b2JNCc7hvN1gDmJ74T
         +x1GTWrb2ddU1SLhe/BVwtqkaniP6TDsmfwpWTpwD8Yy9T55mGGZiirDeSJF/2N/zrmE
         xL4jDaoPQPBG87+4w6GRrC43XEqhMilJT1QQn35LhsbdSF1HOxAbpDwMZSlXVMiSmveo
         V0NCgOsyTPcS7zlQL8tMHffipFG89HdNKIF/6O0DP9gzOno7KQEaRG/L+lgvkeitsuIb
         mJZrx72ix6oDEvp1U8O4zPp2ZwEltEEthv+yiCCtKCvenuENd2QtRIVgQsHqDk7b8aF7
         BuAA==
X-Forwarded-Encrypted: i=1; AJvYcCWiq7vi4K5YsMl7Yd35lD+xr/poqEHCBJ3w43ri6z7F+11ksCAoOZs7N9rVpYB1y1osp/hFEJON2q0yx6tNYOE9Xicf9/7IRbdChZutkuJazHntnMLM2xjmHzyG
X-Gm-Message-State: AOJu0YyGutNTxLsp3lwOAaClAM4tY13BZUZPvukPgLkXAbYHlscj87f9
	sxZXX1skiP7c2lTIiOPAGqLhHc1Ut+dp9qDx3IQgayXPDwbCF3IREqDoVQ==
X-Google-Smtp-Source: AGHT+IFFriJFsUnRrRu7HMBSLly/rtS8cinsWTH9ta/+o0dmkBTmaPB9zq5hLrUgZJ2Zq5CyXnzdXQ==
X-Received: by 2002:a17:906:f8c5:b0:a55:5ddd:e5f6 with SMTP id lh5-20020a170906f8c500b00a555ddde5f6mr1225529ejb.28.1713524921685;
        Fri, 19 Apr 2024 04:08:41 -0700 (PDT)
Received: from 127.0.0.1localhost ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id z13-20020a17090655cd00b00a4739efd7cesm2082525ejp.60.2024.04.19.04.08.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Apr 2024 04:08:41 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org,
	netdev@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com,
	"David S . Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	David Ahern <dsahern@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
	Jason Wang <jasowang@redhat.com>,
	Wei Liu <wei.liu@kernel.org>,
	Paul Durrant <paul@xen.org>,
	xen-devel@lists.xenproject.org,
	"Michael S . Tsirkin" <mst@redhat.com>,
	virtualization@lists.linux.dev,
	kvm@vger.kernel.org
Subject: [PATCH io_uring-next/net-next v2 0/4] implement io_uring notification (ubuf_info) stacking
Date: Fri, 19 Apr 2024 12:08:38 +0100
Message-ID: <cover.1713369317.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Please, don't take directly, conflicts with io_uring.

To have per request buffer notifications each zerocopy io_uring send
request allocates a new ubuf_info. However, as an skb can carry only
one uarg, it may force the stack to create many small skbs hurting
performance in many ways.

The patchset implements notification, i.e. an io_uring's ubuf_info
extension, stacking. It attempts to link ubuf_info's into a list,
allowing to have multiple of them per skb.

liburing/examples/send-zerocopy shows up 6 times performance improvement
for TCP with 4KB bytes per send, and levels it with MSG_ZEROCOPY. Without
the patchset it requires much larger sends to utilise all potential.

bytes  | before | after (Kqps)
1200   | 195    | 1023
4000   | 193    | 1386
8000   | 154    | 1058

The patches are on top of net-next + io_uring-next:

https://github.com/isilence/linux.git iou-sendzc/notif-stacking-v2

First two patches based on net-next:

https://github.com/isilence/linux.git iou-sendzc/notif-stacking-v2-netonly

v2: convert xen-netback to ubuf_info_ops (patch 1)
    drop two separately merged io_uring patches

Pavel Begunkov (4):
  net: extend ubuf_info callback to ops structure
  net: add callback for setting a ubuf_info to skb
  io_uring/notif: simplify io_notif_flush()
  io_uring/notif: implement notification stacking

 drivers/net/tap.c                   |  2 +-
 drivers/net/tun.c                   |  2 +-
 drivers/net/xen-netback/common.h    |  5 +-
 drivers/net/xen-netback/interface.c |  2 +-
 drivers/net/xen-netback/netback.c   | 11 ++--
 drivers/vhost/net.c                 |  8 ++-
 include/linux/skbuff.h              | 21 +++++---
 io_uring/notif.c                    | 83 +++++++++++++++++++++++++----
 io_uring/notif.h                    | 12 ++---
 net/core/skbuff.c                   | 36 ++++++++-----
 10 files changed, 134 insertions(+), 48 deletions(-)

-- 
2.44.0


