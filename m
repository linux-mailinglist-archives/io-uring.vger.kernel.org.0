Return-Path: <io-uring+bounces-7091-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2286AA651FB
	for <lists+io-uring@lfdr.de>; Mon, 17 Mar 2025 14:58:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4F0DA1890C3E
	for <lists+io-uring@lfdr.de>; Mon, 17 Mar 2025 13:58:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 601202405E9;
	Mon, 17 Mar 2025 13:57:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=furiosa.ai header.i=@furiosa.ai header.b="gwSr+gjo"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D170923FC49
	for <io-uring@vger.kernel.org>; Mon, 17 Mar 2025 13:57:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742219876; cv=none; b=glUuDhsAQT6jARKMqpMiJySrCVxduJ265DvmXLeoWbISVEmU2Ycqigt38LZQ+u9DDw7A/Wtz7juuTF486M9QGBk0XlIuzJLGovRb+VSnbCIPaNfrCSUhaHzCD+a9QeqWU+Sgmj7uDPcLXhK5w/Lg5YpYUp9HpJLDmNzuHq04GaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742219876; c=relaxed/simple;
	bh=wGoKlRovkcSIj/T7hxHTG3NpPue/tx6XfmWqTslw2qk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kt5/alCBnEtLa4FYGx2AuniYFTzoC5GAo9C9MTMgI+gTWT56W58QKYSv3M3MVeFtnzunxap+azUWKBfUUqo3D7Hys5q3Cup3M+OTijpGQmnoSJxQwPAUHh45opZTEIwOcEP8QxN+VWbEXudjIFHAUP9CL3q7QNKwDJQfyntCNtc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=furiosa.ai; spf=none smtp.mailfrom=furiosa.ai; dkim=pass (1024-bit key) header.d=furiosa.ai header.i=@furiosa.ai header.b=gwSr+gjo; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=furiosa.ai
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=furiosa.ai
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-2ff64550991so2406850a91.0
        for <io-uring@vger.kernel.org>; Mon, 17 Mar 2025 06:57:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=furiosa.ai; s=google; t=1742219874; x=1742824674; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=0Bz/g5TokYhhZnry08jrr2seVYJeiHTnX0+tpRF1Wak=;
        b=gwSr+gjoSXt+8cIttEF9oJqRHXWdjxfkQhFXg5i/MbcF2cRdaciLBpSCQjZ8SoJy/T
         1YpfaJUywVuqZZEsijol1hsS9APsXLKEJgEruSGMoJXS9Rmyka3TpxG0Ww/QAEvI7dP/
         Vj1H2Eug9scKyawaWxm9RgTl2mWU94VsrXEnI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742219874; x=1742824674;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0Bz/g5TokYhhZnry08jrr2seVYJeiHTnX0+tpRF1Wak=;
        b=E+Am5JZdjsJScKTn+r6RMytas5+iNBOV2tGURTsVzDcjbRN2rYBBhBg1YoZkcmjHyr
         NRUqzdr/ByUZzN97keJuMCIijv6V0KIW35zCojuSKmn5DinWCkRyTs2+2SW31UHZoJMk
         txck2EoqRSK/mwx3B6//J/IdyPSiyZUhB+fQbZGTtydOshv/G2FhZXJExJUTTiRtbiTx
         LYWKE5yU3gGwLmc/K40jRxryQCVxfRMFkNxB2xLEueTg4nGQvovmGDkGGLZWFCmmmlPy
         ZtN8G4LJrB0csJUaAdUT+p9jJYH46P3bfzGqx+I61jz2Tm5B1loYGl0bsSHtMvRwmiEI
         FGyA==
X-Forwarded-Encrypted: i=1; AJvYcCXFkTdIR6qEOZUybY5szp7zHS8bk4b8gmDRwOb+sZg4aOwejl4Q+ZLQzCoYUdXV5dfF4Cd+Qe6WZg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw7ESDnUTF4TsW/Sev00SqVQWkKoIG7bBuatnDv9IgofRN0XnxS
	G5QrwKkPjZABhRzz/2WGW7OBn/Lo9T9MEyeKwZQ7xUcmXJ/ZZ6lekL3FKSCDXdk=
X-Gm-Gg: ASbGncuU2D360Nvgm5EGzpfP+yjMrAk6XVAJRpDWcRmqTIIAj35tEqw1jaz0H2vz53k
	pnzxYO184KyCEQQYyNx8ntaVATyIY2rhzpgADr/1TdU/0h4bRa3cLvjrTbP1pcKIST3B/widSoy
	+yGAVxWxJM7mFS708CI41lmsvED3/Tv4B63tJDlVLweczvfVDUCkrMW6HTsYNZigsq7JRl9zfr3
	MigEbFWbHfsgHBdMpq2Wg5elhnr21OJNLlro2qAFgdHKWcZRdVXkOOK3piMfgc+rlno/MSV0igW
	HeDVgxda0u7tXEpFBflNhhWU0s+CHfhZb9E3J4r/kMuvAtvO84T5TWs0OUxWtZb9OQyzedfy/5o
	cZxIw
X-Google-Smtp-Source: AGHT+IGjeD5qKqA+5dvmm+hH7T9m3tyf3Uwy0/XL7H36bYl9iyVycjQQb3s6qqGRky9DCPwWyGrndg==
X-Received: by 2002:a17:90b:2707:b0:2ee:c918:cd60 with SMTP id 98e67ed59e1d1-30151ca0e05mr15523148a91.20.1742219874094;
        Mon, 17 Mar 2025 06:57:54 -0700 (PDT)
Received: from sidong.sidong.yang.office.furiosa.vpn ([61.83.209.48])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-30153b99508sm5993742a91.39.2025.03.17.06.57.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Mar 2025 06:57:53 -0700 (PDT)
From: Sidong Yang <sidong.yang@furiosa.ai>
To: Josef Bacik <josef@toxicpanda.com>,
	David Sterba <dsterba@suse.com>,
	Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>
Cc: linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	io-uring@vger.kernel.org,
	Sidong Yang <sidong.yang@furiosa.ai>
Subject: [RFC PATCH v4 0/5] introduce io_uring_cmd_import_fixed_vec
Date: Mon, 17 Mar 2025 13:57:37 +0000
Message-ID: <20250317135742.4331-1-sidong.yang@furiosa.ai>
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
for new api for encoded read/write in btrfs by using uring cmd.

There was approximately 10 percent of performance improvements through benchmark.
The benchmark code is in
https://github.com/SidongYang/btrfs-encoded-io-test/blob/main/main.c

./main -l
Elapsed time: 0.598997 seconds
./main -l -f
Elapsed time: 0.540332 seconds

Additionally, There is a commit that fixed a memory bug in btrfs uring encoded
read.

v2:
 - don't export iou_vc, use bvec for btrfs
 - use io_is_compat for checking compat
 - reduce allocation/free for import fixed vec

v3:
 - add iou_vec cache in io_uring_cmd and use it
 - also encoded write fixed supported

v4:
 - add a patch that introduce io_async_cmd
 - add a patch that fixes a bug in btrfs encoded read

Sidong Yang (5):
  io_uring/cmd: introduce io_async_cmd for hide io_uring_cmd_data
  io-uring/cmd: add iou_vec field for io_uring_cmd
  io-uring/cmd: introduce io_uring_cmd_import_fixed_vec
  btrfs: ioctl: introduce btrfs_uring_import_iovec()
  btrfs: ioctl: don't free iov when -EAGAIN in uring encoded read

 fs/btrfs/ioctl.c             | 35 ++++++++++++++++-----
 include/linux/io_uring/cmd.h | 14 +++++++++
 io_uring/io_uring.c          |  4 +--
 io_uring/opdef.c             |  3 +-
 io_uring/uring_cmd.c         | 60 +++++++++++++++++++++++++++++++-----
 io_uring/uring_cmd.h         | 10 ++++++
 6 files changed, 108 insertions(+), 18 deletions(-)

-- 
2.43.0


