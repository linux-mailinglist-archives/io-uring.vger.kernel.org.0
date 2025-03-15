Return-Path: <io-uring+bounces-7080-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C191DA6309F
	for <lists+io-uring@lfdr.de>; Sat, 15 Mar 2025 18:23:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 19703174386
	for <lists+io-uring@lfdr.de>; Sat, 15 Mar 2025 17:23:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5ED917995E;
	Sat, 15 Mar 2025 17:23:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=furiosa-ai.20230601.gappssmtp.com header.i=@furiosa-ai.20230601.gappssmtp.com header.b="KnXF5An4"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 251D6202F9C
	for <io-uring@vger.kernel.org>; Sat, 15 Mar 2025 17:23:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742059433; cv=none; b=LpZ+rJ47NNMLFdFwv5Xmo0I3vNxFnbmMcaRBzAeO78wpw+9aQoJXeh1YOp5Y/oNnEI63KLwupzrqxGsSzppGU3QzGNK9M0L3saTz4+aly/NeocMvj1LVkoeQxHYJcJ1WX6JB9y73CgR495F/3ihHa+hT+gu6dxXKs5wYkd9C1D4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742059433; c=relaxed/simple;
	bh=eMiVf6KfqTI5zgd9NGL4oAR5xBqRGI9Xup1XAQCrP2o=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=KjDDZFUFPi9p+dXckT37NfWy4BkV1bHacUbXW+81bjQ0FwQdf5Ku19W+XNWEzIQ9iwTv7Ou4WLaLZ8d6eoEEmp3Y3Cv6QrKLk3/XFiANUs+b7DvzP+9Tt/PLgu1S8ssP56vSpFTafXvo9IRFsAxlGsqFBebNdhhhkH4fRnvQ/vY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=furiosa.ai; spf=none smtp.mailfrom=furiosa.ai; dkim=pass (2048-bit key) header.d=furiosa-ai.20230601.gappssmtp.com header.i=@furiosa-ai.20230601.gappssmtp.com header.b=KnXF5An4; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=furiosa.ai
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=furiosa.ai
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-225df540edcso29566955ad.0
        for <io-uring@vger.kernel.org>; Sat, 15 Mar 2025 10:23:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=furiosa-ai.20230601.gappssmtp.com; s=20230601; t=1742059431; x=1742664231; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=4fOkW6M/g6NHBx2eUo/ctcQ4zIQwQjQgCpK4kWc44uQ=;
        b=KnXF5An4RS51ew0LlHVxKsUl7Q407I0m5pdTa7iXaAVYxayN/lE+EdAfU+voTmSl3V
         qin08og7qFH4OYTMoDJfsNZhTkouGOICu/YBj4ucUVQu3MkmlgnPlPFoYQ9cExhJwIpM
         iKHQ54+bJoiCaVwla7QpgZEIuiKi6LhWE4S86gPXThoiT7heDYgTLdAflxijcjOjdRC/
         SRC+VzmZg9vUDJ6pKUiwye70cMDXYkHO1jTG42OVk41Hjr7QbapclXk1TtOVAcf/RDIy
         mfb6BHl9EVKTBBgkCyttJupi3Z+cKrEHJa5YdGTqT9WoorEq3T0woK0Ltfkh67DtDE6t
         50fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742059431; x=1742664231;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4fOkW6M/g6NHBx2eUo/ctcQ4zIQwQjQgCpK4kWc44uQ=;
        b=kCi8iNSUwbVJwSPA6pBzwB4H/VxwKhR47ULuhpuaULIMRG/WHAWz7IVhZET/PnAf5b
         2gBLvhSccTJeFEbpiDJo/yfV2jHgkqcOlXhGBvJYHJARqXQPJA2SK/zKmDAaTvHGhUWB
         B+aJCV+8VbTu5wazEnbPCbjFG1qfvVc7x/oxgkbBTd06wT5Js3ZP61vDBjKdDXbFgj5+
         bgXTPh8Z0amv56oHSp9FyZWtIkAlgf4bRv+Iis4V7FtnDRgSubEl78MhDadO2n164PXW
         p8PVEZF36AeH2U6VcEwMZVsYo1OfavkorITIzpNfxnUgrPsTkagu7aYXvpCo/sPJYND8
         Iu7g==
X-Forwarded-Encrypted: i=1; AJvYcCWObBTkRUNYUjS9BbhHcHwCbhItkqC/tsXrP249paEtydBXzZJAlZSMJmGBVXvGcieOi4B/QwTk/g==@vger.kernel.org
X-Gm-Message-State: AOJu0YzToxIouS3BUwd1YKRy3bFb2BAMlHYnxJLuxWskZewKqunPkFcI
	AH9rARVqEgjxwn3Dzgo6FCac/dHTGysjzmGQ6nvu4fS2UXoqmnOw70pUCbhXapc=
X-Gm-Gg: ASbGncvUF93IIOIEHhZPbIX8jtFQNVWAhgYfCQsKaw8F94vEGLzTpnJ1VwQMDIhJYrt
	xZScEId0VyIya7kVKl8p5lfq7wrchv3q2X8fdH5KkAbDaSWnBMJKiZJ2s1YHL9CRC33u6UWFhqP
	PVkMbs1VDcvtVANwa1d5E7z7MLL+jlPz7u21UUXMXkpEYn48G3DlnNhVpAhyJaeqp3hipetWE4g
	i+8t4WMbC61n7cIIq3c0xx9AHzdFXb0fdc8F5kwq6myysyLCwtj9J+RNPrgaLqC0yqrGTvK++U2
	XxAvAd51vZf97K9rvFBc3co578CFWpfwS7uP2BSt1Q==
X-Google-Smtp-Source: AGHT+IHKTM3f6+ScrhlzObjxpZKu4z2AtYffjEWvQjvgTGHXpcQR1TE6tL40+vpAUTLVL9K0i9NNag==
X-Received: by 2002:a05:6a20:4388:b0:1ee:c7c8:cae with SMTP id adf61e73a8af0-1f5c2864feamr8994248637.9.1742059431366;
        Sat, 15 Mar 2025 10:23:51 -0700 (PDT)
Received: from sidong.. ([61.83.209.48])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-737115512f0sm4673013b3a.49.2025.03.15.10.23.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 Mar 2025 10:23:50 -0700 (PDT)
From: Sidong Yang <sidong.yang@furiosa.ai>
To: Josef Bacik <josef@toxicpanda.com>,
	David Sterba <dsterba@suse.com>,
	Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>
Cc: linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	io-uring@vger.kernel.org,
	Sidong Yang <sidong.yang@furiosa.ai>
Subject: [RFC PATCH v3 0/3] introduce io_uring_cmd_import_fixed_vec
Date: Sat, 15 Mar 2025 17:23:16 +0000
Message-ID: <20250315172319.16770-1-sidong.yang@furiosa.ai>
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

v2:
 - don't export iou_vc, use bvec for btrfs
 - use io_is_compat for checking compat
 - reduce allocation/free for import fixed vec

v3:
 - add iou_vec cache in io_uring_cmd and use it
 - also encoded write fixed supported

Sidong Yang (3):
  io-uring/cmd: add iou_vec field for io_uring_cmd
  io-uring/cmd: introduce io_uring_cmd_import_fixed_vec
  btrfs: ioctl: introduce btrfs_uring_import_iovec()

 fs/btrfs/ioctl.c             | 32 +++++++++++++++++++++--------
 include/linux/io_uring/cmd.h | 15 ++++++++++++++
 io_uring/io_uring.c          |  2 +-
 io_uring/opdef.c             |  1 +
 io_uring/uring_cmd.c         | 39 ++++++++++++++++++++++++++++++++++++
 io_uring/uring_cmd.h         |  3 +++
 6 files changed, 83 insertions(+), 9 deletions(-)

-- 
2.43.0


