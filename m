Return-Path: <io-uring+bounces-12675-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GM/NE9x3tWln0wAAu9opvQ
	(envelope-from <io-uring+bounces-12675-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sat, 14 Mar 2026 15:59:40 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 5914E28D968
	for <lists+io-uring@lfdr.de>; Sat, 14 Mar 2026 15:59:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id BEF5B3008683
	for <lists+io-uring@lfdr.de>; Sat, 14 Mar 2026 14:59:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 14CDF377EB9;
	Sat, 14 Mar 2026 14:59:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="BuxjKJXi"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oo1-f51.google.com (mail-oo1-f51.google.com [209.85.161.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE116378D9A
	for <io-uring@vger.kernel.org>; Sat, 14 Mar 2026 14:59:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773500368; cv=none; b=Jrfd1c0ZNKj+OkcndcbXNOgUQpy3petWOTdQwFOvQWkc2K8+sI0hDFlOoz39PgsBgczDyjmjMaUDccZPmmkfDlll9g58XqHc8iRAPEXA4Wfw6Ig8UFfhF9noSXcKrp2aZiWoLQ6G+nnujB47NeI7/ntGVZlQDHPnpGbzsbKKDBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773500368; c=relaxed/simple;
	bh=KLcSNOqCFDXvaHVoMeWHpX2akl520aXV25bX+lXYjz0=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=bYFOWfVDRp0ewgeMW86pJ+DuYbDpPoopSk+Tmuck8iD1Q886BbzQBlyULcd8V6rs/HkenvUFgH0taZJW6N3gDHIL1/Uwd10BaV62ganGZpbHCkViRRXGtDZWNdlbx/61uTO10oeEaLAwsrmhzre/xX8GxupaI/pZMz2WIqxcuqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=BuxjKJXi; arc=none smtp.client-ip=209.85.161.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oo1-f51.google.com with SMTP id 006d021491bc7-662f30d3f1fso2431242eaf.1
        for <io-uring@vger.kernel.org>; Sat, 14 Mar 2026 07:59:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1773500364; x=1774105164; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=/azV0psF+bS6fSEg6CZibIvOravefm+Ono+X2PE8EVE=;
        b=BuxjKJXi2+4eOEqBCQr3V/Oiw8Y8eECbM7aACMyBettHvrtxGVch1LA7w9oTWScE9x
         jXUQ8eYQ644o0Er4haS0v/KXweLM4IBfLWBIoRmYQwzwxo3Wl8UTdx1HVYGGjJy5n7XS
         C9grTZZlC43fFvapieA5XwHv6XRnMl9PzJdR+TFMvNmPIvczaLmnQRVzTf744TuEM9X+
         TBnnXURi/FZRwkhHwe85beLGvDOxVyN4z5oVH6w54k2mi5HSNpSiC30fDzPqCMKoDjMU
         0CX91guUM3c+cMw6jzkcHu8CXvVTgCvzQy2MdxT2W6eAaxdpwfsOG1hZdyumHKJemX4r
         V5Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773500364; x=1774105164;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/azV0psF+bS6fSEg6CZibIvOravefm+Ono+X2PE8EVE=;
        b=eusXwE3B5kUZDUDD+ZgPrcdHxVp5defpR/n3lLUQAogivqiNckFBC2jkM0zx+TLfiM
         hd3CKqx3l4tIXSaaKJOf66arHcbbUyU3+B6yC6xz1spBC2b6kU+pQcwlMKW40naMtSoy
         vomV6e5QGXqpKs8AEgdc/hK/nAzvnXpyPzb+q+gHx05SxCrq7kozWuL9E8TybThRAqme
         elp4k+nDKNIuxiVURd+YpnDUUdG364Gy7B6lbvZHkOpwTQkwGeb14xeaNy65T4e7O/d1
         iHaUZqAU+SuQ+34C140yM+GX0bMz/YMwTYw5U4Ba4P4CDlEPI8DygWxcrL7WKswif9+B
         WAwA==
X-Gm-Message-State: AOJu0YxX+HPhzSvwgY/LTFuPyztnnYyeXjr3TGUwTwHl9VTjFCUWEWgO
	56B9AksQa9vizXDUFgO+PZudZ56BvSJmfU0Z/+GTlQgFZ2Bi28YZTI7fuNoHWU47/OUco4WfYlD
	esoPfmsQ=
X-Gm-Gg: ATEYQzxyWZnPeAe/x8t7Kf5jQmHaGqTc+VihRagRszEU2bUzELaMRA4/RJJROLWUInW
	LtfT4JAAezqO5lDCWMCH/mSeBY61QgGGOc+0VyVYAZmd071C9poYWKktKVE1WHDgoYO282nscrb
	Mz+JCCD81Yh7Zy0LDukbesDBNDtQB5mh27/SaT+LuVcM4bA9UeIo2I0qbViPTI0BLQeHnt0oYZ+
	o+p084mc2ssm4sFK1lKnPXi1Hk8MGX50CBv897HcXC8Koeht/jcTCl3DffvGuqgnDwciJUuohXc
	PuRH6NHuKfRBeFThFzK/pm2Vf3PPi3m6hDaAem0Zsbon1iUwSzTnclRspfPyml7IjXGe1tZVwu4
	IrYZtZgqBeodEzbtlYxMRoQT67Xedr6J3KwGBG/b+pS4P5LXnNXoe/bG1m57zG7N8dxTmiCgc4s
	PW4fTwdpkS1CLDPHW+GWu52tzx6Zvj87RQQbZyiWwx1YYL9RhHpYBjl7hJ3S/tmWb93iwV
X-Received: by 2002:a05:6820:628:b0:67a:222e:ae6f with SMTP id 006d021491bc7-67bda4999fcmr3653386eaf.26.1773500364250;
        Sat, 14 Mar 2026 07:59:24 -0700 (PDT)
Received: from m2max ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-67bc93065e7sm7303137eaf.9.2026.03.14.07.59.22
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Mar 2026 07:59:23 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Subject: [PATCHSET for-next 0/2] Replace io_ring_ctx bitfields with flags
Date: Sat, 14 Mar 2026 08:58:04 -0600
Message-ID: <20260314145920.86796-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	DMARC_NA(0.00)[kernel.dk];
	TAGGED_FROM(0.00)[bounces-12675-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,kernel-dk.20230601.gappssmtp.com:dkim]
X-Rspamd-Queue-Id: 5914E28D968
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Hi,

No functional changes here, just gets rid of the bitfields in ctx
and replaces then with a single int_flags member and a set of flags.
This makes it more obvious that these are manipulated and checked
together.

 include/linux/io_uring_types.h | 32 +++++++------
 io_uring/eventfd.c             |  4 +-
 io_uring/io_uring.c            | 82 +++++++++++++++++-----------------
 io_uring/io_uring.h            | 10 +++--
 io_uring/msg_ring.c            |  2 +-
 io_uring/register.c            |  8 ++--
 io_uring/rsrc.c                |  8 ++--
 io_uring/tctx.c                |  2 +-
 io_uring/timeout.c             |  4 +-
 io_uring/tw.c                  |  2 +-
 10 files changed, 81 insertions(+), 73 deletions(-)

-- 
Jens Axboe


