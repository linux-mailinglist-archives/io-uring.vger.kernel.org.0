Return-Path: <io-uring+bounces-3877-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B02EB9A95EE
	for <lists+io-uring@lfdr.de>; Tue, 22 Oct 2024 04:04:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4BFA5280F1A
	for <lists+io-uring@lfdr.de>; Tue, 22 Oct 2024 02:04:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1242E80BF8;
	Tue, 22 Oct 2024 02:04:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Of70IkKf"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27B721E51D
	for <io-uring@vger.kernel.org>; Tue, 22 Oct 2024 02:04:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729562675; cv=none; b=kXXShKnVom2CR/bbQ73fR6+MPK+fY8Ow7kaZiQc8HPu4K3oNeUPbIGBc1PAybMxz3ccK+RMfB05+NI7FRiPWt7oFw43zh+iXTey7SjNT9WN4SQ+a47sCnWWu8yyYfazlRQYnpE+FYpmDC1sCt2zcWu6Do3juQV73aUpbt3F+RC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729562675; c=relaxed/simple;
	bh=BS90CRV9rXfnn+z03X/V7wLNSnOiatxkafcUQ+BY8sk=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=GpVRByogB2iMEVLQm5baKnPfPUiSRcunyxqyaQ4NjoGMv6DbE8h762U27wYvtlMbFHfOUYE7zHVDh+nbw4L4TL+31ASdhTEnxeZXgKu5zztmgkhbKzxvaxcTahlifzTKJ1QqT/6Jsb/WGedUsefJLEip3MSM2OyGBc7ny7e8jrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Of70IkKf; arc=none smtp.client-ip=209.85.215.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-7ea7ad1e01fso3416660a12.0
        for <io-uring@vger.kernel.org>; Mon, 21 Oct 2024 19:04:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1729562670; x=1730167470; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=0Z6Gsq7Meve17Kbm9asaYPaIeKOa4ZFIm4dVWj8CiV4=;
        b=Of70IkKfLOnypyePd8L5hGOBpsDbdc/ZwiVxyPEEiYZrj9LeUb/5N5G3FTNwPj6FqB
         1YhKsy5niLb53zVUFEV6v5/FBmo7sXg7AMLTxkRcKnQy6irfYyo6EGdNxnJ7iwTeuRUK
         qRP77eq1taVvQeEyQ5Cezz36i8+iVW8zmH3rCxaXM1xNpEMNTWRozzXaFDCCSqyzHL9x
         oJKuXHs143f30ChtB23UuHAa+kgpJdNh2SODUM1b/MCv3AvxrBV37YsSmNXWRZi90xHq
         pvOT/sDmAVbumbfViPljGLTd1P6GM5L/4M9t+PUHWF9jRyzGMVoRpNi+hiidktI02k6m
         Rf+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729562670; x=1730167470;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0Z6Gsq7Meve17Kbm9asaYPaIeKOa4ZFIm4dVWj8CiV4=;
        b=ffX344It++mDxY8OI1Z53AndDv4RHC1CKptydgJwp/fFZEEyTH8xsy29e54Ce+HY3n
         gamckpSB8N9v4gEbcKMfXePKInJBjRL1dBLfcqkCugqmFp6AAQ/XkPN+EkcMx3lKLJDJ
         yMuKIlmCUprtZUPKDkPMHDpMzfxCZz2cL+YuMHOV/gV3QvlRFP2vaD6a8jrmEjLTEMRx
         C2Q/wQQ2lWvscW7hbEPs2/tKhq2Ho6xVEppAfbOkZb/Um4AKyhkvjZwfI+cpQg8uKJzw
         p+uymGL0VX8OzTDpkRnoqlxEQzystFGltd+RsrZDXLQcbwPbT++FRKJ45KmJPdRutBIR
         I7+w==
X-Gm-Message-State: AOJu0Yw+NlDKCyFn2dQQUxZrblSxXXXLQoVVkZI3GXoboe7veHUwu0Mv
	JEsYGi1Way165GZnaECBbBy99RC+71LvKBZLvKo2SKUUN8xb8gJiMDs1lJ25ZvtIg99Oe5+DhQh
	a
X-Google-Smtp-Source: AGHT+IGVAEs/5WlzEoD10/DnNXA1zYw8fAUlBppAgLx95jLy7twvjSeSLHHW9/JMk85Ul0DYi4qiYA==
X-Received: by 2002:a05:6a21:7747:b0:1d8:a9fa:f7fe with SMTP id adf61e73a8af0-1d96c29621fmr1721948637.10.1729562669546;
        Mon, 21 Oct 2024 19:04:29 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7eaeab58820sm3845534a12.52.2024.10.21.19.04.28
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Oct 2024 19:04:28 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Subject: [PATCHSET v2 for-next 0/4] Get rid of io_kiocb->imu
Date: Mon, 21 Oct 2024 20:03:19 -0600
Message-ID: <20241022020426.819298-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

There's really no need to keep this one in the io_kiocb, so get rid
of it.

Changes since v1:
- Lock around uring_cmd import, and also add a comment on why it's
  safe to split the import as long as we've assigned the resource
  node.

 include/linux/io_uring_types.h |  3 ---
 io_uring/net.c                 | 29 ++++++++++++++++-------------
 io_uring/rw.c                  |  5 +++--
 io_uring/uring_cmd.c           | 22 +++++++++++++++++-----
 4 files changed, 36 insertions(+), 23 deletions(-)

-- 
Jens Axboe


