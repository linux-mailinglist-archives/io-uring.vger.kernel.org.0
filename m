Return-Path: <io-uring+bounces-12878-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id OJXGEc3Axmm8OQUAu9opvQ
	(envelope-from <io-uring+bounces-12878-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 27 Mar 2026 18:39:25 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 47451348801
	for <lists+io-uring@lfdr.de>; Fri, 27 Mar 2026 18:39:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 1CC4630157C7
	for <lists+io-uring@lfdr.de>; Fri, 27 Mar 2026 17:27:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C901E3C6613;
	Fri, 27 Mar 2026 17:26:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VabE14im"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6C0E2F4A14
	for <io-uring@vger.kernel.org>; Fri, 27 Mar 2026 17:26:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774632419; cv=none; b=r79SdAxWZC92RPglsZFROi5YlXmqRyHa2zr2FYyUkegTdMrMZkg5APEdY3QjFTPWeqZCqUMCMgqGVSLaIpm8zVobND5gspqkDDj/pmhmndTP8L2RvhW8s+SUvw4d4vgdxlp5Jb/S4p/Wu6a2MXbaZj+bnqGtsMGBXkEScnVGJ7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774632419; c=relaxed/simple;
	bh=xMwHSmgnCqS+cu6HqPdJb5Zd3gTLgi0cCu97eZ9z+4A=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Xfq7mOYaH7E3WvxueZEOq+I+pYWYfuMKNA1sQs62WYcGToTpiPY6f5jYdTxRXmVT0926cOz0ceMjLKuiNS7/5YirsGpIPrcgzLlvO2pI3aVltoVmwSBdD+RC+HTbtqQhl2vIL30cgK5BsMbJRWI/0C/C5hqxuQDiISndlgUPbrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VabE14im; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-829a9d08644so1293472b3a.1
        for <io-uring@vger.kernel.org>; Fri, 27 Mar 2026 10:26:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774632418; x=1775237218; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=V/OqKVDnNkI3pPQXGb5GniLyKGuIc/3G1wP7wfOC4s0=;
        b=VabE14imZoSYBm9glbjL2GFz7FS9zUFhGjw5AhEdXvGQrP+Sp5MSDnmBQcJGK8LBbX
         Hx5NByeA5OhxOLhUnE+XDXS9UPKKHGpsa4wkbbu8wMLj4ZX34u5wAkzKM4JclgwKVBPv
         DsMsGLkFJ6dOobXgvzT4Dv0Z4fKD88vBDp9s7RJ8gE2a70NceBDibwpCK0OQmk1XWqLq
         849ARc/36sbi5qTe1jBsnVQACsqFxOQ6n9xC7i5gxpulf9VT0/1J+NGTXiZJmmmLAG3m
         xGZlnheMf8cgM7+kiXVwYWkeP+DivQfxKVK9IWg75upGnM0TawmzEiQZoNzxA8cOzWkp
         gk0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774632418; x=1775237218;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=V/OqKVDnNkI3pPQXGb5GniLyKGuIc/3G1wP7wfOC4s0=;
        b=LVEvUMmEHK6ln/833OnRN93oGGICinTg4NaITvLo3/KdfgctxWhKgOItgUA3fPcbk7
         nYIYX+Mw6ZgScdflvua02fHvhFZiLURoHYAQZajfEmqz0KQzzzH9YZXVFm1kapaxErj3
         +HWoiUZuYZoSC7gnDiJhuW3Qdw+ZDaIIDD4I/Y6YN79toO7kupm14ucVcSsjR7x/p78b
         tFUbn6YOBtCl8QuQyihiItFVV0nbaQBGqJ5WDekigV88mYruz/NHZM6+YtllT0UscSS4
         v1IK19hB7TK7wbrfk0jQSyzKqEFQauWwZhZv7B5fjziBbUpEYL48HY9lwVtjKpaBjkso
         yL9w==
X-Forwarded-Encrypted: i=1; AJvYcCUIEIsvEYM8He2qXqAbRT4ncH0XfllMEFE/MUpMA9TEIGT8LHQF3vTpfvr8VbG1JelFZP67zom6mw==@vger.kernel.org
X-Gm-Message-State: AOJu0YzYEwA8Mc2vlG0IAcwGTP1wiMQJ15mHB3eUvkZhMwvvyfYFKNk0
	O16dUTxwl9IJhcCXC5k1WNhkKZtqbN6iFI3kcw7/GrRsS1AtUzEEaOMmVdgO3g==
X-Gm-Gg: ATEYQzxTODMf5mOjT5zMz+eJKEARq715uDtuws4nci73u+NwBGK0h4WQVuNpdp1MkCC
	y1/m3sBsFRtuPccxR+wsCRnj4aRe33OW5pDSJo1SdGqGPXwgEefCupNBgvG+fU0hTT8qkwNcNc0
	iu92uk9MeZ8f9frPdplwe5HQZy8zvyGrXjIWXxN4KTn2S9I9qAIeNCa+TMGYZPBmVKV440f/qZw
	t3Fp2vBSC0jvsWqpFxrKPMmOle2ZeWpSMdMc7zQJ7uKBLLvE+LI+mIb1nCFErJA2FmgYetnygPU
	z/V5BMg4QLk2pLQr+x2cZKRm68vGVBsBwXO84LAXPiow9TMWDeWlJRFOlfPHItK1jVSzGuELLDU
	edEfq2Hq4chfeC1V3HM0ep4yA14kQKpBKknEat+JmQf9OnNJeB/FBDfyXlSnsZhKYVk0EG7oJKu
	RkYJzIYW0daCZL6z0jnQ==
X-Received: by 2002:a05:6a20:7292:b0:39b:f8d1:a603 with SMTP id adf61e73a8af0-39c87846320mr3674264637.22.1774632417977;
        Fri, 27 Mar 2026 10:26:57 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:53::])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c7685ce9091sm2192865a12.24.2026.03.27.10.26.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Mar 2026 10:26:57 -0700 (PDT)
From: Joanne Koong <joannelkoong@gmail.com>
To: axboe@kernel.dk
Cc: csander@purestorage.com,
	asml.silence@gmail.com,
	io-uring@vger.kernel.org
Subject: [PATCH v4 0/5] io_uring: extend bvec registration and add mem region lookup
Date: Fri, 27 Mar 2026 10:26:26 -0700
Message-ID: <20260327172631.3380702-1-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [0.84 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[purestorage.com,gmail.com,vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12878-lists,io-uring=lfdr.de];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	RCPT_COUNT_THREE(0.00)[4];
	PRECEDENCE_BULK(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	FROM_NEQ_ENVFROM(0.00)[joannelkoong@gmail.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	NEURAL_HAM(-0.00)[-0.999];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 47451348801
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

This series refactors and extends the io_uring registered buffers
infrastructure to allow external subsystems to register pre-existing bvec
arrays directly and get information about the ring's registered memory region. 

The motivation for the patches in this series is to make fuse zero-copy
possible. These patches are split out from a previous larger
fuse-over-io_uring series [1]. The fuse changes that build on this patchset
are in [2].

Thanks,
Joanne

[1] https://lore.kernel.org/linux-fsdevel/20260116233044.1532965-1-joannelkoong@gmail.com/
[2] https://lore.kernel.org/linux-fsdevel/20260324224532.3733468-1-joannelkoong@gmail.com/

Changelog:
v3: https://lore.kernel.org/io-uring/20260324221426.3436334-1-joannelkoong@gmail.com/ 
v3 -> v4:
* Add comment about io_uring_registered_mem_region_get() locking (Jens)
* Return info in a new struct io_uring_mem_region_info (Jens)

v2: https://lore.kernel.org/io-uring/20260324182157.990864-1-joannelkoong@gmail.com/
v2 -> v3:
* drop patch that makes buffer release callback optional
* add patch for renaming/exporting IO_IMU_DEST / IO_IMU_SOURCE

v1: https://lore.kernel.org/io-uring/20260324001007.1144471-1-joannelkoong@gmail.com/
v1 -> v2:
* update io_kernel_buffer_init() to take bitmasked dir directly so callers can
  set both dest and source

Joanne Koong (5):
  io_uring/rsrc: rename
    io_buffer_register_bvec()/io_buffer_unregister_bvec()
  io_uring/rsrc: split io_buffer_register_request() logic
  io_uring/rsrc: add io_buffer_register_bvec()
  io_uring/rsrc: rename and export IO_IMU_DEST / IO_IMU_SOURCE
  io_uring/rsrc: add io_uring_registered_mem_region_get()

 Documentation/block/ublk.rst   |  14 +--
 drivers/block/ublk_drv.c       |  22 ++---
 include/linux/io_uring/cmd.h   |  53 ++++++++++--
 include/linux/io_uring_types.h |   5 ++
 io_uring/io_uring.c            |   2 +-
 io_uring/rsrc.c                | 152 +++++++++++++++++++++++++--------
 io_uring/rsrc.h                |   5 --
 7 files changed, 186 insertions(+), 67 deletions(-)

-- 
2.52.0


