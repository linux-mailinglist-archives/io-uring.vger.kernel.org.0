Return-Path: <io-uring+bounces-1520-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1CA2B8A2EA1
	for <lists+io-uring@lfdr.de>; Fri, 12 Apr 2024 14:55:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C93A3283C61
	for <lists+io-uring@lfdr.de>; Fri, 12 Apr 2024 12:55:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B3DF59165;
	Fri, 12 Apr 2024 12:55:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="l3TdVzDi"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F5E955C3B;
	Fri, 12 Apr 2024 12:55:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712926536; cv=none; b=uzt1arPMkEARv1Rhn4r8m0pgK1SVpowBpFfBYKDgZU/ZnFo/FAe09pUEyWj0AFG+Bh5sRFjof9e3HAyxNhXXRXIXAlx5PlWSx8FcQSaRDlOYdIpRQ1rKPGj8FMy2ls4Ccvil5D6+NWKgIhzC8VnsiQuqCcFnI3MRGnnQuyD/eDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712926536; c=relaxed/simple;
	bh=p2okjA2/g7vmiU48jZj+UlbVjl0tEs82O0QdWeoQ7is=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=pY0lTWCn6UOVL0GHk8AWV01h/f/cn/8Ajp0BWOfHzRKsl3RevXc8cQxI4NRvEf93zqwK1lNSlOfIaay5QqwpNf8kKBfnVtfbgSaN4GM/Z76wSccTjd/IQTgsmGEozad8ybPk3w5lHKceM4Xt3YTb/dUqdcuigL72z5x5RVaVHiw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=l3TdVzDi; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-a450bedffdfso112949766b.3;
        Fri, 12 Apr 2024 05:55:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712926533; x=1713531333; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=bDPMCbsH8/SO37RrvlFkYjYFSAU01e5TAcsYj3b81KY=;
        b=l3TdVzDiT3z2zmQH0fEEaYRXU5Pv/6V59xs2p6LdjegDKBJi5IUihl9/CCK6ltO2WS
         8tIZzmwKcQEjlO6cnzaRwcJnME2iqYsI7xNiwIxrt9PbFydLpZv4Od78vUte5bpBfc49
         TQ1cXJXJvRreBL3dusO+PUgTlLqXsvyAGTBUuHxprDB7jbn8v8e4nR3dV1HY2fV7DoRl
         V4n0z01LRHg8DZq/St830qR0C9K4yf2WR4HECWr5xzrtT1/uKursmUXx2R/+sCKcKUrD
         bU1WPfz8X6qFD09adu+hPCFLlqhSrR/Qy13OKAAJSbKtt3ld9z8INiBSNcw2M6Rq8DPH
         sTgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712926533; x=1713531333;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bDPMCbsH8/SO37RrvlFkYjYFSAU01e5TAcsYj3b81KY=;
        b=BH9yew4WlNDnhGX/jGK8v80ni0FXrJk5rv0/cRr+XDmFU5hT9NlKqHHRq8pI2fGA5q
         ShSjsA4hUbXoWqziJtznKQIqjscJd11wLvfzZIgvDJp96U2S80wFHSBpYBh8Qj64S2W8
         xyQu9NKYxyKDql01oyDfo1/ri2nNdCieAer9LEn3cLg+HGk91vy9CZOS3Kjt1c3enBlz
         TaFzoE3Gej1Cjd2prViJVs787XI67kAC1CAIi8La1DS3GXisxQjKMFwkyLPCEDVygh50
         aDl+CnqIZ2+MlHK03YU3JewJ+M0YAi4dL0MWtDjt001ukiRRVBYqKCjd6aXzmum3gcRr
         v1rA==
X-Forwarded-Encrypted: i=1; AJvYcCWDjTfnh3K0m7C93zzC3mpWL4psxpthIJx3SEcyL75tUBmG16RfSBAVPnoZ1V9X0pY4ouOf7ABT4DAoU4r15ZdoUjw+d8mk
X-Gm-Message-State: AOJu0Yz/gYueGCoff24sjA5i7bh20vjZlfR9kf+rq/NBC5uG7K1z2Mcw
	HO5biyhN2ZemunmLzaQf5GYNJ/XMvWA8Upy6Iw6ZBfFugrJ2luihs7OY3g==
X-Google-Smtp-Source: AGHT+IF27AMxS0uh8gRLuQ0xyyvrA9eBlLImA3Cl0mZ4yM/q1gGDrh4+Trfgok2Gy9+zGVHnIyEFUQ==
X-Received: by 2002:a17:906:4c5a:b0:a51:82e1:ef52 with SMTP id d26-20020a1709064c5a00b00a5182e1ef52mr1534839ejw.11.1712926532524;
        Fri, 12 Apr 2024 05:55:32 -0700 (PDT)
Received: from 127.0.0.1localhost ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id qw17-20020a1709066a1100b00a473774b027sm1790903ejc.207.2024.04.12.05.55.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Apr 2024 05:55:32 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org,
	netdev@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com,
	"David S . Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	David Ahern <dsahern@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Subject: [RFC 0/6] implement io_uring notification (ubuf_info) stacking
Date: Fri, 12 Apr 2024 13:55:21 +0100
Message-ID: <cover.1712923998.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

io_uring allocates a ubuf_info per zerocopy send request, it's convenient
for the userspace but with how things are it means that every time the 
TCP stack has to allocate a new skb instead of amending into a previous
one. Unless sends are big enough, there will be lots of small skbs
straining the stack and dipping performance.

The patchset implements notification, i.e. an io_uring's ubuf_info
extension, stacking. It tries to link ubuf_info's into a list, and
the entire link will be put down together once all references are
gone.

Testing with liburing/examples/send-zerocopy and another custom made
tool, with 4K bytes per send it improves performance ~6 times and
levels it with MSG_ZEROCOPY. Without the patchset it requires much
larger sends to utilise all potential.

bytes  | before | after (Kqps)  
100    | 283    | 936
1200   | 195    | 1023
4000   | 193    | 1386
8000   | 154    | 1058

Pavel Begunkov (6):
  net: extend ubuf_info callback to ops structure
  net: add callback for setting a ubuf_info to skb
  io_uring/notif: refactor io_tx_ubuf_complete()
  io_uring/notif: remove ctx var from io_notif_tw_complete
  io_uring/notif: simplify io_notif_flush()
  io_uring/notif: implement notification stacking

 drivers/net/tap.c      |  2 +-
 drivers/net/tun.c      |  2 +-
 drivers/vhost/net.c    |  8 +++-
 include/linux/skbuff.h | 21 ++++++----
 io_uring/notif.c       | 91 +++++++++++++++++++++++++++++++++++-------
 io_uring/notif.h       | 13 +++---
 net/core/skbuff.c      | 37 +++++++++++------
 7 files changed, 129 insertions(+), 45 deletions(-)

-- 
2.44.0


