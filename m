Return-Path: <io-uring+bounces-7060-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D7CBA5DD6F
	for <lists+io-uring@lfdr.de>; Wed, 12 Mar 2025 14:09:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CD3EC170E32
	for <lists+io-uring@lfdr.de>; Wed, 12 Mar 2025 13:09:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93F5A24500F;
	Wed, 12 Mar 2025 13:09:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=furiosa-ai.20230601.gappssmtp.com header.i=@furiosa-ai.20230601.gappssmtp.com header.b="o3NkZ7ex"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AECD23F376
	for <io-uring@vger.kernel.org>; Wed, 12 Mar 2025 13:09:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741784981; cv=none; b=o1KUJwBhEBO6467lUxafqeMKk7WqIWDYy/t3kJIeRFvoVb9LUZWvEkQP/bT5hXH66YMQ8U34ihTJnFPECfcMCVUI8gRywjIR9u89zTz3g2t9lW+ED99kRkLz+uINiid2iitQTtIsx9q2hrQqw2Y+eBV9q6meOqoNMdTdCdlkJ50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741784981; c=relaxed/simple;
	bh=Vv8RYYNN32jkVSIlC3HEqjsVMtw6rjCGH2BUjDQtq4w=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=IZFnwGnmQA3h4EeyK6Rtcl5kQM738D3KMpjVfDW5U9WBtKhlffWI9IIV92fKv+9mCylqQJPRPXc4/SNOB+6tRqOf+Z6Ncw/7yCgrinx8oOxi5sVrzLNRJuO1PqgTvjpBQmWR1faePcONmniEsVypkvZKiX7AzH2Hhm4EH0qTTs4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=furiosa.ai; spf=none smtp.mailfrom=furiosa.ai; dkim=pass (2048-bit key) header.d=furiosa-ai.20230601.gappssmtp.com header.i=@furiosa-ai.20230601.gappssmtp.com header.b=o3NkZ7ex; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=furiosa.ai
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=furiosa.ai
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-22403cbb47fso128499165ad.0
        for <io-uring@vger.kernel.org>; Wed, 12 Mar 2025 06:09:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=furiosa-ai.20230601.gappssmtp.com; s=20230601; t=1741784979; x=1742389779; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=DjzZK8IYtDnC7MfW99ZbF8PngYp+A/NXbbGv9fyWHAs=;
        b=o3NkZ7ex9okIONmJbBbPVyagkm2/DybIppMTlcDYqE1R7MxbQVxdEFheKsJvKguIvk
         FuXZ666QwzfbosnzS2v7m9LKjuCbCZXZtFuVYthZFMQXZL4vPp9wFkkSPfpMGOPyiEzD
         AUuosU4RmcImdlEcMNK3NE62Qcfxmk1Eexc/vtJqd/Klce7s7StREDACzlY8pDz7GNAm
         PShJYSK/93f45LjiaWyAqhXLxgM26hjDGgsL6yCX6T0owV9Y328/k2p4AMk4p27QZlxn
         +NvGztp6cLz3s02x+9FpJ51Asm1E66fECGwVeaH0EdKKfzp4TTqnx9v8ulBZGG4GB0V5
         v1QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741784979; x=1742389779;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DjzZK8IYtDnC7MfW99ZbF8PngYp+A/NXbbGv9fyWHAs=;
        b=lS9XcPYFNckwKD1sztD2k18fRB0RGiHnqjUWH5YqB0xN44wQrm3OiPgEQ21vP9MLUS
         53xjXqL6wIjnWz8RojXgG+I65xYPgRnxTYmAUG9wkugeS2qhqWqU63Gf8kDJffFgqcyI
         ibpr7yH1tZI6qeHYCpnNkFAShwJXYpn70yTjjFwHa+u6qEwSwV0ob4Oi22pEC+UqinPY
         y0l2/YxtS8T//GRFXm9T65CWV6a8EOGnVhrH4P00mkdavW/NGy+R/DrV4Kf97o14Z4Zw
         O5jRGzSZbstUzjKHZ7YwT8dq30LYh/C7JBOscfbVp7nHj2i+8YgMGX0CvCQa3j5L3uFM
         8D7A==
X-Forwarded-Encrypted: i=1; AJvYcCWeffNRlfdMtjbF0Xmg7u4Z6tZqCfAVs+GiRr0AV4D8BtLUPsMBUupc+o679byZ8u/DCzDmrM5kZw==@vger.kernel.org
X-Gm-Message-State: AOJu0YwRXpUeXOSM3vmY+FkYfvpC0/liW5tLlXEn60uL/eiQJto1zm+L
	YpHbqkJUCojOS2zfVxdNl2eIA9KjNh/EwR+Pqx/4hcOYzN0zbkiyliFG6pCAyFhS3kBOZPBGGll
	a
X-Gm-Gg: ASbGncuqdfpz5zLCdMeT4gEe15OGgCu8teDH6/SiBqcT0auXn9Wn8YXUdnagZRdsMbS
	1RPuuFS02o4j4Ua90Hha/z/Ksm0CLnoi8MqrF+YAbhrXogJdqhXASvO/aIKW8vy9KpWzO8HnH/u
	OZJ3am0tTICGSF4BO/3i4NBCfuWv8K4FThwbBYOEBRCMT7L065iKjAprksMf/iYMVz3UxLaRLJ+
	LCjB+9hUCDfytq8KUmG+wVhdOsEpnr3fDPw6S1joMBX8taaIoUnb0Vs/kgblob0A3s7+ZHPgbAi
	ZCxJm6Ly1FRELykp3wEeOvKQ29dwwLfucdXUR7O/cS4m0WbxwDthmeWr5VDhI1oRpJt3xLE9y6R
	R+Ji7
X-Google-Smtp-Source: AGHT+IEw/moyxYqrtJLyuuYhHY0pdrsP5qeyzccAp7ltN9DQfF3V5SgWTYBCiqpn4Sv+xnF5QXan6A==
X-Received: by 2002:a05:6a21:648f:b0:1f5:70af:a32a with SMTP id adf61e73a8af0-1f570afa5a2mr24970418637.32.1741784979399;
        Wed, 12 Mar 2025 06:09:39 -0700 (PDT)
Received: from sidong.sidong.yang.office.furiosa.vpn ([61.83.209.48])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-af5053a85c2sm9432299a12.10.2025.03.12.06.09.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Mar 2025 06:09:39 -0700 (PDT)
From: Sidong Yang <sidong.yang@furiosa.ai>
To: Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Josef Bacik <josef@toxicpanda.com>,
	David Sterba <dsterba@suse.com>
Cc: Sidong Yang <sidong.yang@furiosa.ai>,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-btrfs@vger.kernel.org
Subject: [RFC PATCH v2 0/2] introduce io_uring_cmd_import_fixed_vec
Date: Wed, 12 Mar 2025 13:09:20 +0000
Message-ID: <20250312130924.11402-1-sidong.yang@furiosa.ai>
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

v2:
 - don't export iou_vc, use bvec for btrfs
 - use io_is_compat for checking compat
 - reduce allocation/free for import fixed vec
 
Sidong Yang (2):
  io_uring: cmd: introduce io_uring_cmd_import_fixed_vec
  btrfs: ioctl: use registered buffer for IORING_URING_CMD_FIXED

 fs/btrfs/ioctl.c             | 27 ++++++++++++++++++++++-----
 include/linux/io_uring/cmd.h | 14 ++++++++++++++
 io_uring/uring_cmd.c         | 31 +++++++++++++++++++++++++++++++
 3 files changed, 67 insertions(+), 5 deletions(-)

--
2.43.0


