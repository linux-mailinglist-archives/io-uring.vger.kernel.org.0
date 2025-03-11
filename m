Return-Path: <io-uring+bounces-7046-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E03DBA5BF68
	for <lists+io-uring@lfdr.de>; Tue, 11 Mar 2025 12:42:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 639BD3B31A4
	for <lists+io-uring@lfdr.de>; Tue, 11 Mar 2025 11:41:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A30825523E;
	Tue, 11 Mar 2025 11:42:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=furiosa-ai.20230601.gappssmtp.com header.i=@furiosa-ai.20230601.gappssmtp.com header.b="unUYzyFL"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA14B2356CA
	for <io-uring@vger.kernel.org>; Tue, 11 Mar 2025 11:41:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741693322; cv=none; b=j5UQfM2eS343+b35s9Vbfts8n6lwVKt62TR+0ViCbOtD97korOR2zjAZDLtFwTg5UF3N0yRjv6cBtKKm86pW/1+fZkohNzNzFKuIayiajJaFs+yrUwwFCeY/Reb0QA/lZ2AMPF8uMyb3a1yBCDRBjCoGKAEArFK9q7+mIsuRqss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741693322; c=relaxed/simple;
	bh=K8h1Ag3DTU1iuA899SLvbmD6xwY/+vHzivqVPw6SPEM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=sy0FYYtsg2CXgWZXvZ3LLuiZMZY0UVHhpOIQ2Y/wuRl0fQcEpjHR3mBL0fpal9cf8akUbFzdhjEpHRXAuk7YXv5eyrbFtbC7d/U6VSS6SWH8M76z8lgZ8ctQ34QrsYNaxBqb1VQqH2/xVtv0W3Od+f7d3WME41N8W/CD2VXXcsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=furiosa.ai; spf=none smtp.mailfrom=furiosa.ai; dkim=pass (2048-bit key) header.d=furiosa-ai.20230601.gappssmtp.com header.i=@furiosa-ai.20230601.gappssmtp.com header.b=unUYzyFL; arc=none smtp.client-ip=209.85.216.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=furiosa.ai
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=furiosa.ai
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-2ff6cf448b8so10648946a91.3
        for <io-uring@vger.kernel.org>; Tue, 11 Mar 2025 04:41:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=furiosa-ai.20230601.gappssmtp.com; s=20230601; t=1741693319; x=1742298119; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=MA/dse0ICF/ii1I0pjbS4LieVE/QLWT9sr4+LkG47XY=;
        b=unUYzyFLfxsUKi65f6JV68/phAuaun5DAq4nRLNY3GBNX3VhPQIZwyL84Vp7whAP5n
         TIP433csQRbgPoelnoGfzMkjGM9YXWV6DDm4bFL3z+O/yc5aeMM9VtWE1mpY11Dkysx2
         Evc04+/GbuuZNuRxGWEAE9I71R5uLyiJiSL55/ofVfceLJWfa9p2q2tuw8hRoV7tT1QD
         hE1jL3/n2Vx0Yl1Cf7b5I/BrBvB2xjERMli8EXwnL/939fRyYY8GQAVwSDSi63XuTd7X
         LVT5wqm5aERC1V2yvvdvviJJvmigOjqj/N4xhW+tIR0FtCNgzmIj2dEZy7zd+4snJZeo
         ilQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741693319; x=1742298119;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MA/dse0ICF/ii1I0pjbS4LieVE/QLWT9sr4+LkG47XY=;
        b=UVK0oL98gjnhy+QnGc9ndwFeS/Ns+h4OBe0QQ3Fwg1zM8TXFnusmPsj5eIAQgIdrtw
         IaA82F5yCE+Af/O8QcJuizDuNcPicihtbkiDwInfZW9SwBIZrRN8Q1moub6p/LFrQOg9
         a1AYyewW51QDW47ZbgZdMHQ6dmsAM+6bqxMhEU2aKQAcek9Mk8obfZIR0HG54BumquI+
         Ob9OlIjg1DT5/wa/almaASXx+OsZydRtR9L5fCfaxskNfQdryf1W4AHehbJ8G3nwrGst
         HpNDbvFo4Iuvqc1YfQcHTsOOCP91+buE99dwUdPSWNpOS5zVWXjp0WlT/AKKXXZU9xHK
         8NMg==
X-Forwarded-Encrypted: i=1; AJvYcCWZn6VrHHK5Q3PXSvRaqLOq7foyWdUSnipJQrahLZyrIxIvfohpDIitNObUswUdFKq6tX+TxoVDtw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yzxsno/5KHx0FaHVqJLbk8RoyMXiUfHwlHiaCvyCCg1Vt2ibBO3
	DaPo6iYIBdle9/Nxnd2BKZd8mmkDLuGX/C4OhCAIjCC7VOODg0EVIsOX2Ih40/k=
X-Gm-Gg: ASbGncuiJwDhZP/HH9HLGPdZINdcQhtzXB1cEnVo8wM83FBGldgRuylwU5+/oB1iDP6
	K3GdJcwgYLoanmNIz5dzgKbCa1V2FbcRw3AIuqRHAwsx7Os4bK4wLlFHJs5i/Fhjnh5xZLvTY/f
	AnW9UAOrp7IOi2ft7zykf2cC3eI4l257Gzycoa8tszdmP0XX8wE+WibyVFrrpxhSyEBQYR6eUCx
	uoglLKFlosxPXyZZ51SdctP92YLXfYb85AnVb7z4uXjcxLPdkucf5ooEJeUNx8U+w9WmmwII1mu
	Zez31rXZpHmPImr0tMxfgKpCtpgGXKZaG3MagOZ5Uj3bCGP9p94FLoa9Z8A/r+Hkx+CGrwEEV5G
	cssz9
X-Google-Smtp-Source: AGHT+IFzE9A1jtPzwbrU7Qxi5WrE/iLJ1gwUE4+oXkgzZWgtb2kVGpHneIlCN7fSLf3qIQvdqoqg9w==
X-Received: by 2002:a17:90b:3147:b0:2ff:58a4:9db5 with SMTP id 98e67ed59e1d1-2ff7cf480e9mr24563107a91.30.1741693319056;
        Tue, 11 Mar 2025 04:41:59 -0700 (PDT)
Received: from sidong.sidong.yang.office.furiosa.vpn ([221.148.76.1])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2ff4e7ff8cfsm11647817a91.37.2025.03.11.04.41.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Mar 2025 04:41:58 -0700 (PDT)
From: Sidong Yang <sidong.yang@furiosa.ai>
To: Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Josef Bacik <josef@toxicpanda.com>,
	David Sterba <dsterba@suse.com>
Cc: Sidong Yang <sidong.yang@furiosa.ai>,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-btrfs@vger.kernel.org
Subject: [RFC PATCH 0/2] introduce io_uring_cmd_import_fixed_vec
Date: Tue, 11 Mar 2025 11:40:40 +0000
Message-ID: <20250311114053.216359-1-sidong.yang@furiosa.ai>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patche series introduce io_uring_cmd_import_vec. With this function,
Multiple fixed buffer could be used in uring cmd. It's vectored version
for io_uring_cmd_import_fixed(). Also this patch series includes a usage
for new api for encoded read in btrfs by using uring cmd.

Sidong Yang (2):
  io_uring: cmd: introduce io_uring_cmd_import_fixed_vec
  btrfs: ioctl: use registered buffer for IORING_URING_CMD_FIXED

 fs/btrfs/ioctl.c             | 26 +++++++++++++++++++++-----
 include/linux/io_uring/cmd.h | 14 ++++++++++++++
 io_uring/uring_cmd.c         | 29 +++++++++++++++++++++++++++++
 3 files changed, 64 insertions(+), 5 deletions(-)

---

Recently, I've found that io_import_reg_vec() was added for io-uring. I think
it could be used for io-uring cmd. I've tested for btrfs encoded read and it
works. But it seems that there is no performance improvements and I'll keep
find why.

If there is no need to use fixed buffer for btrfs, I think it's good to use
for nvme.

2.43.0


