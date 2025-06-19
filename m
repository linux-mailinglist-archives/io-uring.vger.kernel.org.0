Return-Path: <io-uring+bounces-8435-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 57955AE0DFE
	for <lists+io-uring@lfdr.de>; Thu, 19 Jun 2025 21:28:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 098DF188EA34
	for <lists+io-uring@lfdr.de>; Thu, 19 Jun 2025 19:28:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 79665246BDD;
	Thu, 19 Jun 2025 19:28:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="N0R2zRDu"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f100.google.com (mail-ot1-f100.google.com [209.85.210.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 322251E7C32
	for <io-uring@vger.kernel.org>; Thu, 19 Jun 2025 19:27:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750361281; cv=none; b=QCErFvxpC4f0NVp6LyNb1GcHPryDJm0yBGhB4p5MW4GG/9DZy1e3ug3rv1XCPNFIaJg1S8eSTNkiiuH/4kvIMen0w+kN82X/oeeOFH2NKP3s7k2xtp/RbXFQkc4Y7wArHgxpKK6sbsMR2PBCkDluwp7zKXtKztpbcwowv1d1O0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750361281; c=relaxed/simple;
	bh=K4VZVi3xDLWT0DEl3LNGUBjrD17+mi5NFECXhkIiWrY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ScyGPFjYdaedO/KAEOtIM5vMV5fZHLIk6d956qO9VFm1zZIDUmoT9y0A8yrbfVPz5vRhkzdIOeFLPZcnjYL87fzNrfGZMhT+3aHK0WlIvmDuSlCzRPT8d6VTFhxeF380ZLLcQKrO4xayKBYfubrQfIeKYuQZgT2eZScyGB1THvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=N0R2zRDu; arc=none smtp.client-ip=209.85.210.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-ot1-f100.google.com with SMTP id 46e09a7af769-735b7028ca9so264746a34.0
        for <io-uring@vger.kernel.org>; Thu, 19 Jun 2025 12:27:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1750361277; x=1750966077; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Pd50J9nYsG0TeiIeJPqTSZq8OKqwb6u/EH2G1EHnbLs=;
        b=N0R2zRDuoRfzgfUiO1AcWFzICfQ3al3GoC94JDFHhiABvJd5154MlbhJm9MDthWHGU
         WiSAJGST5UQXcWz+uDSOquTk3dscvMlcMsMrgsMj/MS1xmir6HPpvlE0eoarK4ALIt66
         jUQV8oDZkm2ThMXGcQJTY6EIw5rrZcLP0wVu1kDOku1p4miBTc41fbHQLI3XzMUhxG7J
         lvHoM0S4QjRz8CjJ9xxnDuLdu+3eNtczDXBMkSGNKsQDY1W/hLLLgX9fg3l7tM4QDyyW
         UXkPVeevwhCItJZNCfxPX/Y7zZOVH3WgczUz7MORJJKvxEqy7Jy6S4ynv76c53SBqYeF
         6rsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750361277; x=1750966077;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Pd50J9nYsG0TeiIeJPqTSZq8OKqwb6u/EH2G1EHnbLs=;
        b=Wymuk4uB0ZOUK+oEK1FxnF0MWfhxf1rs1XHrJNow6kuCELQeaGZNI5FAxtsZqUn9DS
         viciUqoDrFErWUEBMZR2F+6AGiRdm66R7h9cFuGZJlSkuzq4tDQ8sKmBBGWn/BaLjsNg
         /dOmQ+OU2q2/71hFk0jTuYalaFua8Fko8z8iN9qC6dR6uBK9gy6AwFTYgNoZHXnvT/aP
         mqm/7Wxyl+TKQBLXiYXA9TQ26rEkYdtSjN6wAFxesEzpGyK9mtRhcFMcwV32RuaoyM0k
         IK7z7J9x8CKORKgivEA1mWD0hNnSp64aw9ryox/POmB2vYP+pYwiBIFpBzY4rIirbuxX
         7wpQ==
X-Forwarded-Encrypted: i=1; AJvYcCVBydN+3kA3pMeCYMbB1lK1QEvSIbAnREAhQdCkCKvvwRg0WwfcSj8BL09deQN9khgVI555VFKkqw==@vger.kernel.org
X-Gm-Message-State: AOJu0YyyLLw4+dq/rwToOHZp7yM+QTDyIwmaDR8IbEumWVGs1V9RZfzT
	gz2w5x9/7w1l5EdmVTfjo7lW2oOXQnKXimFcxVsFVC1bEws95FB8Ed2gYByn0cOBDwDU2pVL4bn
	Za1mu2sDWz9S3zFToiZCu8W++U8MSjFQxBc4t
X-Gm-Gg: ASbGncuwheyRldMYGnix3gdXoKLVpaCg5b53oFdxx7ZpDr5Q2enMIv9vYJGGFGhdh/g
	RHPXn+Vaf6DBQljNhYQANxh3Vd3TEaece3uVAjpEJke7xVJN7pmqkBPtt0tW1fatcKwg54hs7hD
	Vqw+fyHhw9q8sqo+u65+r6SHlW76biSChJkDWAkEQAAW3RV22rsghjA1x1IWrBZHjp7rpoYfQyF
	t+sOjZKhFiFV7rzUhNbjiKiNtcT1NVN0SuQRq1QYsi5Rotl5IYMYE7WErHyadp0h5HIQmmYqa9r
	G4CdREmuKsekg5IQoIfhc/hQDcuvnhFs7rzC4+xtBPfxzfAimY7+apI=
X-Google-Smtp-Source: AGHT+IFJTkxUOsR6hHqwhzCVU/31oTbq4J6u3JvNzvDfBfkf4G2km3lw6QOOl6Hu+u0klImFrFzJNZ4BngML
X-Received: by 2002:a05:6871:205:b0:2ea:9842:68e2 with SMTP id 586e51a60fabf-2eeee56f4e5mr63594fac.10.1750361277182;
        Thu, 19 Jun 2025 12:27:57 -0700 (PDT)
Received: from c7-smtp-2023.dev.purestorage.com ([208.88.159.129])
        by smtp-relay.gmail.com with ESMTPS id 586e51a60fabf-2ee8a78e987sm17874fac.32.2025.06.19.12.27.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Jun 2025 12:27:57 -0700 (PDT)
X-Relaying-Domain: purestorage.com
Received: from dev-csander.dev.purestorage.com (dev-csander.dev.purestorage.com [10.7.70.37])
	by c7-smtp-2023.dev.purestorage.com (Postfix) with ESMTP id 34E5034031F;
	Thu, 19 Jun 2025 13:27:56 -0600 (MDT)
Received: by dev-csander.dev.purestorage.com (Postfix, from userid 1557716354)
	id 32ED7E4410B; Thu, 19 Jun 2025 13:27:56 -0600 (MDT)
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
Subject: [PATCH 1/4] btrfs/ioctl: don't skip accounting in early ENOTTY return
Date: Thu, 19 Jun 2025 13:27:45 -0600
Message-ID: <20250619192748.3602122-2-csander@purestorage.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250619192748.3602122-1-csander@purestorage.com>
References: <20250619192748.3602122-1-csander@purestorage.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

btrfs_uring_encoded_read() returns early with -ENOTTY if the uring_cmd
is issued with IO_URING_F_COMPAT but the kernel doesn't support compat
syscalls. However, this early return bypasses the syscall accounting.
goto out_acct instead to ensure the syscall is counted.

Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
Fixes: 34310c442e17 ("btrfs: add io_uring command for encoded reads (ENCODED_READ ioctl)")
---
 fs/btrfs/ioctl.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 913acef3f0a9..ff15160e2581 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -4827,11 +4827,12 @@ static int btrfs_uring_encoded_read(struct io_uring_cmd *cmd, unsigned int issue
 
 	if (issue_flags & IO_URING_F_COMPAT) {
 #if defined(CONFIG_64BIT) && defined(CONFIG_COMPAT)
 		copy_end = offsetofend(struct btrfs_ioctl_encoded_io_args_32, flags);
 #else
-		return -ENOTTY;
+		ret = -ENOTTY;
+		goto out_acct;
 #endif
 	} else {
 		copy_end = copy_end_kernel;
 	}
 
-- 
2.45.2


