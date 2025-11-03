Return-Path: <io-uring+bounces-10329-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id C3B0AC2DBD0
	for <lists+io-uring@lfdr.de>; Mon, 03 Nov 2025 19:52:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id BD4194E3601
	for <lists+io-uring@lfdr.de>; Mon,  3 Nov 2025 18:51:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2606E31D741;
	Mon,  3 Nov 2025 18:49:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="NvFGwvi8"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f45.google.com (mail-io1-f45.google.com [209.85.166.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20575324B26
	for <io-uring@vger.kernel.org>; Mon,  3 Nov 2025 18:49:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762195785; cv=none; b=Y5m8hakhTL/LwDLW1viaZkcMMfppc9KJFJROeWR/CyNl0EmfcVAx+sxOf3jRCq0dq4aF7EAYAk2sEXStIBvqBcXyWCHfUqv02lgdIC4yzS9HyqcpoQ9a38IgcrN3io3HoHJPMEvBQRSG9RPB77O29EgA4toPUqWNI37kyzrGXTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762195785; c=relaxed/simple;
	bh=2IDWo6Y1McKJ1swbFBFhNUZEI4m/UAB8Wd/B4bpY1B8=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=sjmQKLi4KDoJg8RR7T3rSue14pL9/LEM/uYV6oe+IDdeFEoay9hFFELreOljEKiWqS6oSGhB3ZA9PCTlPYgqcR+qPGj+SSwf1zMisFJa/zUc/xs2Lvo9LMGAfKcKwOGk/jrB+tzeccF6NfUkn1rg2Mc6KDFY2/8Lah29BrVXMZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=NvFGwvi8; arc=none smtp.client-ip=209.85.166.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f45.google.com with SMTP id ca18e2360f4ac-93e7c7c3d0bso477975939f.2
        for <io-uring@vger.kernel.org>; Mon, 03 Nov 2025 10:49:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1762195781; x=1762800581; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=ax/0vjum0RbG7U1BSS8HnhO7dk16wYriUAUnnZe5UQg=;
        b=NvFGwvi86Wag8zUB0IzbLHW2g2K8sDdH4+reTOJ74i7wFJwpGrcNAHR6cRCoZQ59Q8
         ZQe/RRqzVvGUnXbAjlOpdu6q5WAzSDNbyRyoT1+LH/J81VfNERNCFGrtouLe46eWLN4R
         zRRd9bGhQWX9myxcG+xO3xtDRQgPRmycR3bS2vSlgYIrHFb40NTViZGP/DFKzVS6tHzL
         0eefy+96w9R1y9lqvsWeBTk0a2UZLyM9viVv9fsjVjINX7PRnKJR/rCi3MC5fUTftcOG
         QiRz09+//xg0cRf9u9tIS+d6nk5RsIRRm89aukqCOQ61UjqbITYRhXwnqcMfHotyz9lc
         MJgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762195781; x=1762800581;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ax/0vjum0RbG7U1BSS8HnhO7dk16wYriUAUnnZe5UQg=;
        b=s52VnrSkevwIrD35Pjyl968WxAafjXB50EgAgNOONk4j/lI/AK9kv49dZ5sJKL+psA
         r1IaXUfvu1SRsyytS/+9BtlVXghtkX1HdFFulKZxg7DROh611qkEV1OoPCgaJS9fetWK
         taWDmtQpiYan4MN5XFAs5BqbW9E/OylVpurJ2ldBoIcavH0IngX/ypAb7N5nF00cihdG
         SJ7E62xsll1keQEt03YnRzpj2yjYSb8D1OqKcjbz2RL85A/zyRFGzofyIHf8YC83DOrY
         Md9LQ4vs7h9bn3VfawZYNEcA1fvFP0fu6ooXGcEMO21efBjUvsivvbpRji8ZiqrNzfhW
         a+WA==
X-Gm-Message-State: AOJu0YxH4WVWNMUkZDDSxlaQ8pEmChtvW61HsFLToeZB9BuYzut375nV
	Zolj/nT2CClqYELAntY8YajlGodoy+c8w7tSi2qX3I/7ljY/3zjgAZpAAj9G/3jdKdqtWEaEdwN
	pzzl4
X-Gm-Gg: ASbGncsjaaf5DAWPCgAoPiO7u4pEOVQoxajNUxUZL73NNwAdpd8/UHSe2K1d5YLhvmZ
	iLHvouPeMLhzOyaczJ2ewPWvwcO6D6b3GZgVY7kQ6pvVtGuIXk0XPCl7rhj5wk6lwkCQdTiudip
	U+LrGWpF+bJvG9HsyFAg4atwt8Hv4bsXCiplxeVhdsfm0Hz28vBdASFg5BRL5vihW6Z2ddVvC14
	jwm9s+xVSUTZv1kn6GooDY7iiQ6uDaCALL+NhL6pk1b3MgWX6pL3IV+uTsCvQe+tXL/enc94w3E
	mNgMGe3CEtAmRJeGV3YuS4SOSldtJvRTkg2LPn/NbjTWw0ImPYpAlZYIX1O3NzLbaEuPFVMhqyi
	Rgx/j51SzodmeWnTzh0bllujFF5rwxetj4/JFQb1zby2cC4AFqSJ9GKf7KWA68JyktCKwvw==
X-Google-Smtp-Source: AGHT+IEW1Zb3TBUW8iSv3H8oMMTBxzGHmV9jpfd+nF4BdE8ga3o0/EI9aayfIyJ5DWUDxqbMAouSEg==
X-Received: by 2002:a05:6e02:270a:b0:433:2aad:9873 with SMTP id e9e14a558f8ab-4332aad9b89mr72061815ab.29.1762195780685;
        Mon, 03 Nov 2025 10:49:40 -0800 (PST)
Received: from m2max ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-43335a2224bsm4572985ab.0.2025.11.03.10.49.39
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Nov 2025 10:49:39 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Subject: [PATCHSET 0/6] Various minor cleanups
Date: Mon,  3 Nov 2025 11:47:57 -0700
Message-ID: <20251103184937.61634-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

No particular theme to this "series", it's mostly just moving code
around a bit to more appropriate spots, and removing dead declarations
that are entirely unneeded. Mostly in preparation for moving more of
the cancel code into cancel.c and out of io_uring.c.

No functional changes in this series.

 io_uring/cancel.c   | 44 ++++++++++++++++++++++++++++++++++++++++++++
 io_uring/cancel.h   |  2 ++
 io_uring/io_uring.c | 44 --------------------------------------------
 io_uring/io_uring.h |  3 ---
 io_uring/memmap.h   |  5 -----
 io_uring/net.c      | 14 +++++++++++---
 io_uring/notif.h    |  8 --------
 io_uring/rsrc.c     |  4 ++--
 io_uring/slist.h    | 18 ------------------
 9 files changed, 59 insertions(+), 83 deletions(-)

-- 
Jens Axboe


