Return-Path: <io-uring+bounces-6599-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EC638A3F849
	for <lists+io-uring@lfdr.de>; Fri, 21 Feb 2025 16:20:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 696D4420868
	for <lists+io-uring@lfdr.de>; Fri, 21 Feb 2025 15:20:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34090210F6B;
	Fri, 21 Feb 2025 15:19:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GQBlMv14"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CCBF21148F;
	Fri, 21 Feb 2025 15:19:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740151191; cv=none; b=edMoyNdPIMlAak+cLUn8Y7N58VH+EoV8YDMpp0B4F6T0GXBMnXViOw572E6izIUjUReQJNL+WgvVstHsFZe41UclVbDn1yDVIFXasCWiwLYGgmW9raXQ6G6ZE7pD+xkGmB5ogSjMCfh5zqKSGMMdxYhgzW5CMnZ02hpkce46SNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740151191; c=relaxed/simple;
	bh=0Sfi5OhsmXDc0XGmKqmk2NvefOoyLYkNnDfLKFL8czg=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=oNd8Ny+K+P0h0g1CFh2nUQ6jqoy/DxXD8C5ZHsSq6hSfh90PkpjwbJAqKeroErBogDeoVqOeq5vQi/o9nOgn8Vv3fYoK/SvGfIJJP7Z4MBgiM2M1jd/FcQQoiE1ddPRMcACyBerxXSgGaopWe6WqvAwnNp2qerccrOb91m32vxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GQBlMv14; arc=none smtp.client-ip=209.85.167.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-545316f80beso2043995e87.1;
        Fri, 21 Feb 2025 07:19:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740151187; x=1740755987; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=TsCVMsET+UHJUAvFwcMuiLqRvzL8dXcTNPDug2riv8k=;
        b=GQBlMv14+9D9b62RRJsOZpALcR8Pnh4SgJTOiHwb+PmR7Uy+U4XgrGb8fTwEqiqxPv
         5RUliIvLJQx5vNHyQiwQNtZUufg5ihSUBvGqR9gzBPp4YeMc1phv766hRJcpopOxo++h
         ci/2hDGJNzxrK7hBZh7qvhzpLPFPfqwdiMYMf0Cmt8mf78fk13LvzaVkpH3dKCTmOJDx
         X6JMsOzp2qD2WAhaOaaNfco32wvuSoBq2KSdEQt2vxSKPZ1dPrfgDBK/H2GYyUUwNhT6
         jUDSZ6dUHBCRfPyvS0+SCJsVo/ZhMzsu5HwEzvkB9k33+3S4VrpRg6uURk3zCWrkoQP3
         t+Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740151187; x=1740755987;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=TsCVMsET+UHJUAvFwcMuiLqRvzL8dXcTNPDug2riv8k=;
        b=hH8fKmI9vK+vR7m3scdcJzy12qHFij7U6KNoC+f2bgTbc6V0CFpKiilzvLIq3nr1b3
         doVUZaeHiEUkpuMJSGSEkY2VDAkkQAnJZlWZmcnrTeitztb5oTO5ExFJ5yFfz6hslTUA
         8WlHCZCnWR0ae4BicnNqRU6Blop5hZfXuN9aIwOwgnKcaiZwkvbPVj0/JxMFDYwt/ePC
         EEF2Qxu8e9LKvQDvJ2srFSSxB1My8ZKpEy35az/4vyg75Z3GX/sCN2xnpZgGP++ju3ez
         L5LYEo5xs9VAqeNSr/KyyKuJdV7O6H+bnG8hI2hIOg0daUy3D75GO05g72Hekq6/OC1s
         ra5Q==
X-Forwarded-Encrypted: i=1; AJvYcCUgRzySfsNiSrtXHloG7qWXpmBGh4V9mVTjZWM1RY+ZMLx3tuHh0eemRppkIhUvv3oHmpbDjlVLqQ==@vger.kernel.org, AJvYcCWnKOB+zkZ4859vLBiQAedWT56XUM0g0JboUmQWlh4Cgp9kH4LIv7eSKbWKTMyNGKJbsIRArKZCV5i6SILvGw==@vger.kernel.org, AJvYcCXyISTw9HX2gYTsE30UIo4d9oKxnJ2bCpvBv8X/5HiKLnD7ztNPAsi/4RURjno1ADzWNmfUziJxbi2KyNtT@vger.kernel.org
X-Gm-Message-State: AOJu0Yw3qst5fbTvvYOCa/rsSE8w/7omsr8cDvk/uKxnqW+2et1bLT2l
	kUSCuw+K0pXjOiihlPHaWKYq1kTSHfTdVRKP1QKpLBjwivvXOkM6e5Fn49LDWIfdVhzlNs+eQOR
	SEMSsZv11nhDnG6H9Ovai/pxlCBO2jYlu
X-Gm-Gg: ASbGncvcVLLwaAfqA8SPWnLeG5Q66AI1M1Xu+1S2XzexYaVsOHU1RV3jESbsa99kfVb
	9C0vVkhkclEff/VYHUkfGjqgWxu80SkxPnDhJ6q1HKNgBoDeAhEJDL9RAHdqBnaqIeAeXDd1DjQ
	Ysha7cULFZUJdVzgGa9FLFYhe8iAWIRuaWja7Z+A==
X-Google-Smtp-Source: AGHT+IHq4qLBz9m2NFhBpeqJ4xzYrCtbHSLby1iC6TO1KwEL2ALcorCpci5X/OlhxzeL2mxeMbL7CXJXSKSSCVGVnxU=
X-Received: by 2002:a05:6512:3b07:b0:544:13e0:d5b4 with SMTP id
 2adb3069b0e04-54838ede5b9mr1329754e87.10.1740151187041; Fri, 21 Feb 2025
 07:19:47 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Moinak Bhattacharyya <moinakb001@gmail.com>
Date: Fri, 21 Feb 2025 09:19:35 -0600
X-Gm-Features: AWEUYZnvdT7tjZcJDsWqhEFZoe3RD5rXqne-b-tMkyFB4ytnTpybHbigd0_tFjA
Message-ID: <CAKXrOwbkMUo9KJd7wHjcFzJieTFj6NPWPp0vD_SgdS3h33Wdsg@mail.gmail.com>
Subject: [PATCH] Fuse: Add backing file support for uring_cmd
To: Miklos Szeredi <miklos@szeredi.hu>, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Add support for opening and closing backing files in the
fuse_uring_cmd callback. Store backing_map (for open) and backing_id
(for close) in the uring_cmd data.
---
 fs/fuse/dev_uring.c       | 50 +++++++++++++++++++++++++++++++++++++++
 include/uapi/linux/fuse.h |  6 +++++
 2 files changed, 56 insertions(+)

diff --git a/fs/fuse/dev_uring.c b/fs/fuse/dev_uring.c
index ebd2931b4f2a..df73d9d7e686 100644
--- a/fs/fuse/dev_uring.c
+++ b/fs/fuse/dev_uring.c
@@ -1033,6 +1033,40 @@ fuse_uring_create_ring_ent(struct io_uring_cmd *cmd,
  return ent;
 }

+/*
+ * Register new backing file for passthrough, getting backing map
from URING_CMD data
+ */
+static int fuse_uring_backing_open(struct io_uring_cmd *cmd,
+ unsigned int issue_flags, struct fuse_conn *fc)
+{
+ const struct fuse_backing_map *map = io_uring_sqe_cmd(cmd->sqe);
+ int ret = fuse_backing_open(fc, map);
+
+ if (ret < 0) {
+ return ret;
+ }
+
+ io_uring_cmd_done(cmd, ret, 0, issue_flags);
+ return 0;
+}
+
+/*
+ * Remove file from passthrough tracking, getting backing_id from
URING_CMD data
+ */
+static int fuse_uring_backing_close(struct io_uring_cmd *cmd,
+ unsigned int issue_flags, struct fuse_conn *fc)
+{
+ const int *backing_id = io_uring_sqe_cmd(cmd->sqe);
+ int ret = fuse_backing_close(fc, *backing_id);
+
+ if (ret < 0) {
+ return ret;
+ }
+
+ io_uring_cmd_done(cmd, ret, 0, issue_flags);
+ return 0;
+}
+
 /*
  * Register header and payload buffer with the kernel and puts the
  * entry as "ready to get fuse requests" on the queue
@@ -1144,6 +1178,22 @@ int fuse_uring_cmd(struct io_uring_cmd *cmd,
unsigned int issue_flags)
  return err;
  }
  break;
+ case FUSE_IO_URING_CMD_BACKING_OPEN:
+ err = fuse_uring_backing_open(cmd, issue_flags, fc);
+ if (err) {
+ pr_info_once("FUSE_IO_URING_CMD_BACKING_OPEN failed err=%d\n",
+     err);
+ return err;
+ }
+ break;
+ case FUSE_IO_URING_CMD_BACKING_CLOSE:
+ err = fuse_uring_backing_close(cmd, issue_flags, fc);
+ if (err) {
+ pr_info_once("FUSE_IO_URING_CMD_BACKING_CLOSE failed err=%d\n",
+     err);
+ return err;
+ }
+ break;
  default:
  return -EINVAL;
  }
diff --git a/include/uapi/linux/fuse.h b/include/uapi/linux/fuse.h
index 5e0eb41d967e..634265da1328 100644
--- a/include/uapi/linux/fuse.h
+++ b/include/uapi/linux/fuse.h
@@ -1264,6 +1264,12 @@ enum fuse_uring_cmd {

  /* commit fuse request result and fetch next request */
  FUSE_IO_URING_CMD_COMMIT_AND_FETCH = 2,
+
+ /* add new backing file for passthrough */
+ FUSE_IO_URING_CMD_BACKING_OPEN = 3,
+
+ /* remove passthrough file by backing_id */
+ FUSE_IO_URING_CMD_BACKING_CLOSE = 4,
 };

 /**
--
2.39.5 (Apple Git-154)

