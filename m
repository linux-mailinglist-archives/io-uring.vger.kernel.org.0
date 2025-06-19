Return-Path: <io-uring+bounces-8431-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EF38DAE0DF5
	for <lists+io-uring@lfdr.de>; Thu, 19 Jun 2025 21:28:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8D0863B0F17
	for <lists+io-uring@lfdr.de>; Thu, 19 Jun 2025 19:27:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C306244698;
	Thu, 19 Jun 2025 19:27:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="Ud5etnuA"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qv1-f100.google.com (mail-qv1-f100.google.com [209.85.219.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73F5E30E83E
	for <io-uring@vger.kernel.org>; Thu, 19 Jun 2025 19:27:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750361279; cv=none; b=K/uGNTwYyrp9wri2iEV6vqLocwTPJJG+zZCF0oTSuLplwdVa9tIlYEsJ3ptnyGPoSbvQ6BRVtpq5J4rvx600jngWBYagf47hRpkth0VG3ESTXl1yn2wVpkr+KaKHSBG3d6Cwm4gt7/CtQyM6Nc8BN8S6yO40qtU1GVq7wnpr1+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750361279; c=relaxed/simple;
	bh=sijI63S00ZgLzoop5Ca6++6nAMYhSyYN82X6IBrZOM4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=E7YebFU4V/MDnKneeXRaO+0NvgzPEh9Y4YOWQW8l8bUdQmxwROUaR9V68bcAosknAiCYOnpNGJVeki0KljDH2MG/taVRaAu6VxQb6zK7XYCnuWgJTLsD5qsSn4h7sr1YcLplJVLlkXLRKKEQW2f6V/OheHi+JH9z56nGNTuhdU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=Ud5etnuA; arc=none smtp.client-ip=209.85.219.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-qv1-f100.google.com with SMTP id 6a1803df08f44-6fb514c8e18so1013006d6.0
        for <io-uring@vger.kernel.org>; Thu, 19 Jun 2025 12:27:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1750361276; x=1750966076; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=UgbxT3rUHbJcwXp+d4U0s8gCt8pvR9AU1IXgLNjEg00=;
        b=Ud5etnuAFg21/3ql02kuJSUljsqKzAeZ0DCGWdyOWTJYz9kEhQQG8Baf60AVfCcf6R
         9UgVg2Nzl7xAhI3eSH6qiE9Fw1KZRDp67Em2P3eXYq6wtvc8RcPG070krEZXIqXxibal
         /OoR14V4CHN6To0O275iNfbbtIBR2Uflj5MEM+MxH7YzGphdujNkj1jkmWrnwlvJrY4r
         eUmaj+Cgs/6n1f9Tq0TCgs5Dj/Xrn2r91tnCvNYnFxtyTVtrJZSJi/VyXB8EluAXJbFn
         acWY2aTqNc37YfIeWTKo8DhOR58rtGooyZDUqrG7G+ymFlEretM6754Gps4yA114P6vz
         IoDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750361276; x=1750966076;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UgbxT3rUHbJcwXp+d4U0s8gCt8pvR9AU1IXgLNjEg00=;
        b=tLptfdSUueSwxbqlrv1JwK4lqx4pY/bXOit+Hd/jV6i21SinGBA37CN/pJUNMh66CN
         v5Nv5SIuxyToy39mDXXf3sVMmNiarl1M6ePgPZ4pwHkV2hHPql3tQkkFF6CEqIsYaEu/
         k6w/fjj/DPmwD9kxleEUN+EBmsPVouSsDAVK/Mri+GjqP4unj7klt39MdbjBxPEdzadL
         cQn9KOq/69xuOvS2SeRK4dPjsNYIP1oUPBnQrv/VSzLSyAxbEC7Tqp+aqRT3k4NsI2IF
         tq+GWBpf1BqhHKuxZxyXF7qApu6nJETA/wyBdi7cvXkpjGkpeGMaP9uAsOCF/b7sOlaa
         amFw==
X-Forwarded-Encrypted: i=1; AJvYcCXr2t98pW+6I7F7jMSewloPxromq9VTOjzqGvC9zoOeyJUHIwv2CmeaCLHlWmK7sjZ/iODC4ET4IA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx8spuoySCTIP6IRKXluVZZ2jjNMZsKImXKs7yof8/Pu90Zt2aB
	xqdVgRiD48xiq4Drm2uq6cKbNxT6IyOpzrv6gwk1c4Ya8PoE2ecNICjcmLX6NK4b/R6zS4A4JtP
	eGIPqQqerU2xee79sSiQMl9hovtLxfFY9BzY3fRfupWq49D9nt0v6
X-Gm-Gg: ASbGncuT5we+Ty8V2NXjvWJQIc75hxObtksgMxPxp3GN6bTvBtwk9MdVy9zv9XMmv8q
	rMrHonP6SDgC0m7VveChh6ZeGhbVBF0+4H3ROiPPvZJk0uH8NGYqM3GFgdqu+B66TZT2pct265L
	lzgS38e1AfdASzNGjpiHvyDF6F7RYJzTZoBG1Odhr0LNn5y4GYDV0fEp49e1aCzIHbjDQi8gGdM
	z0YPLPWaFcybXta9PTuvssFQsPuKBPifRVK/cb7P9EQUU/O3Tc9TctZWZGYqi38/aRljnrFkonR
	C+WHrU2DTq1EBbOR1rj/5HBZ8o25gVZntaCxU3Zu
X-Google-Smtp-Source: AGHT+IHz10o1j4yWo0MElDZwSQq9lzFuxMzdz16AoaaK4BkVl1R49On+ZMbhjl9V+Kl3D2KIomY0GccVT6QO
X-Received: by 2002:a0c:f096:0:10b0:6fa:b8a1:abaa with SMTP id 6a1803df08f44-6fd0a2ff22bmr2120546d6.0.1750361276346;
        Thu, 19 Jun 2025 12:27:56 -0700 (PDT)
Received: from c7-smtp-2023.dev.purestorage.com ([2620:125:9017:12:36:3:5:0])
        by smtp-relay.gmail.com with ESMTPS id 6a1803df08f44-6fd095627c8sm299176d6.70.2025.06.19.12.27.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Jun 2025 12:27:56 -0700 (PDT)
X-Relaying-Domain: purestorage.com
Received: from dev-csander.dev.purestorage.com (dev-csander.dev.purestorage.com [10.7.70.37])
	by c7-smtp-2023.dev.purestorage.com (Postfix) with ESMTP id 70C423400E6;
	Thu, 19 Jun 2025 13:27:55 -0600 (MDT)
Received: by dev-csander.dev.purestorage.com (Postfix, from userid 1557716354)
	id 6B9D1E4410B; Thu, 19 Jun 2025 13:27:55 -0600 (MDT)
From: Caleb Sander Mateos <csander@purestorage.com>
To: Chris Mason <clm@fb.com>,
	Josef Bacik <josef@toxicpanda.com>,
	David Sterba <dsterba@suse.com>,
	Jens Axboe <axboe@kernel.dk>
Cc: Mark Harmstone <maharmstone@fb.com>,
	linux-btrfs@vger.kernel.org,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Caleb Sander Mateos <csander@purestorage.com>
Subject: [PATCH 0/4] io_uring/btrfs: remove struct io_uring_cmd_data
Date: Thu, 19 Jun 2025 13:27:44 -0600
Message-ID: <20250619192748.3602122-1-csander@purestorage.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

btrfs's ->uring_cmd() implementations are the only ones using io_uring_cmd_data
to store data that lasts for the lifetime of the uring_cmd. But all uring_cmds
have to pay the memory and CPU cost of initializing this field and freeing the
pointer if necessary when the uring_cmd ends. There is already a pdu field in
struct io_uring_cmd that ->uring_cmd() implementations can use for storage. The
only benefit of op_data seems to be that io_uring initializes it, so
->uring_cmd() can read it to tell if there was a previous call to ->uring_cmd().

Introduce a flag IORING_URING_CMD_REISSUE that ->uring_cmd() implementations can
use to tell if this is the first call to ->uring_cmd() or a reissue of the
uring_cmd. Switch btrfs to use the pdu storage for its btrfs_uring_encoded_data.
If IORING_URING_CMD_REISSUE is unset, allocate a new btrfs_uring_encoded_data.
If it's set, use the existing one in op_data. Free the btrfs_uring_encoded_data
in the btrfs layer instead of relying on io_uring to free op_data. Finally,
remove io_uring_cmd_data since it's now unused.

Caleb Sander Mateos (4):
  btrfs/ioctl: don't skip accounting in early ENOTTY return
  io_uring/cmd: introduce IORING_URING_CMD_REISSUE flag
  btrfs/ioctl: store btrfs_uring_encoded_data in io_btrfs_cmd
  io_uring/cmd: remove struct io_uring_cmd_data

 fs/btrfs/ioctl.c             | 41 +++++++++++++++++++++++++-----------
 include/linux/io_uring/cmd.h | 11 ++--------
 io_uring/uring_cmd.c         | 14 +++---------
 io_uring/uring_cmd.h         |  1 -
 4 files changed, 34 insertions(+), 33 deletions(-)

-- 
2.45.2


