Return-Path: <io-uring+bounces-8585-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B6913AF6353
	for <lists+io-uring@lfdr.de>; Wed,  2 Jul 2025 22:30:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D3D5A5200FE
	for <lists+io-uring@lfdr.de>; Wed,  2 Jul 2025 20:30:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 650052DE714;
	Wed,  2 Jul 2025 20:30:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cvSsDZqs"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC8E0248F54
	for <io-uring@vger.kernel.org>; Wed,  2 Jul 2025 20:30:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751488232; cv=none; b=FYb0OgXfka1JQqjJ13bM2O7sHAIXugbPhfrUTwVGmTKrp6Nr2TaNdOpUXP2iMzeNSxm14ATP3o5Ny37rag8oHdmNwytTo5L0vQzTaH657ddCCq1y2zeL19KmfLOtKhoheXBdcZqIlp4lACPaxTLIxTG4pveKtV3xnXrcBbpcBBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751488232; c=relaxed/simple;
	bh=5KLh4n9X2cvBK7ndtPjBLIAY8afytChW7yabpSakILI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kEGUIIBctcl07e3/pKBclgj/bNM/gMSYlQnBcbLzw6nXryKv1KSye2b8oltPyi0kxno76evlUNNyWJ5VPsZWRVXUCZznO3Hw2u1puudeMmjSvz0jiAOW2LHfW8nGM4MuRUvTCeIVWS+SeJSJ+91Eyllj0sSVWtY+VI8PVUjKlJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cvSsDZqs; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-236377f00easo59289115ad.1
        for <io-uring@vger.kernel.org>; Wed, 02 Jul 2025 13:30:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751488230; x=1752093030; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=cY26jYg0d16gpE927qCu/X7Sfjc9MIjgUblxRpPhkFw=;
        b=cvSsDZqssSS8oSS1lR1uv6UXBlpxCEcnF92Mj9E8nIXRW73uTi+TtB2X009ixkQn1w
         ofvPvtYgTh80EQdbbVh3lgoK/hSBlv0Ri29kHeQhfws5BJTDC+mBnMJdGmaQFhOQBS0Z
         239Q7rz3wmpDeQydHkuixOqkTZ2XTxu4cGc61cKtOvF7BssOLgRrvtjxaHm+leobObzx
         sr++29Y+TeblwrAKeaJGZJl+eIGxBa3b16WhtceeeqETlvYACROyIKrPiMdkHlr5ujEg
         r4KU59zoRdzAT7Iu67M6yLDSwf2E200erlIjOAYODaye9NCk3QzYj/T3ZAw79L9sWNKg
         0/uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751488230; x=1752093030;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cY26jYg0d16gpE927qCu/X7Sfjc9MIjgUblxRpPhkFw=;
        b=cC4sJnIuBJQ2Bs2LMMe8xOpTZBTOxNSBrRFpuWYShMUZFmV6HXz5qDIw2N7iHUmqwF
         j5xMvVJ2KMcHPzPy+wt1k3IKIIgWhS3ix9+JOkZMmsSUFU+DiajihfypN5PEJgZ4pHYe
         /3dBspiOWXUQqPNuYxaq0jZn59f+mOh+YuXpfya7kPMMFpaI2Q8alafmVNIhRwVTKhKq
         myD56Ns/Eog8xFaXg7qXEZ0Sg7PARMSVR3bnCjMCys36716B3PDAdj54i0QUy/poYLvZ
         aF8G8btUmhjn6pazbxbI/UdTXWXho4lt4pYXPCNjKQbgcg0cmn0gUs7Ttrqen3DxuP9I
         TAfg==
X-Gm-Message-State: AOJu0YyecRgxw9WczpKt9+9tLJIUIv5aJbcQToEQSohC6fTiJ8Luf2pI
	fLeEKyn+wzigJMC49obzS89oX35+dxKJ5bZOhUxe9a8Sa/73iLovvP8FCH5L5d/3
X-Gm-Gg: ASbGncvCz4Ct/dfrvJa+uWPSwNPO/sI3YHhGPCKFMnrbnJF0izqdXuTW+J1tiDZ0hcQ
	LKjJYZjMwTTh5P6QjSjeF74xhwfGdTT5iNaEYFOwUBI5KIwqS0myc1T6N/U8MYEig1R+oLj0D3w
	UXN6vz1y4CIZOlZExlAJRiaCAg/qm15gv1cWUlDSU9gjprnkH40G6HQekmYAUxoRh5P66hB4nig
	GOEju/iehRn7H9UGvvU3SGhQk4YSQjMp56V7bXybz3N8lqugLJs+oya6peF7ki8SP2HKkSY3ieL
	n5EYPotCgy+7JSbB9QZW3YGaCfJgQ8ya/lWdiynECzaWC6e1IHjdPIVy8ci6nyKNeQgycydwtJv
	H
X-Google-Smtp-Source: AGHT+IF7IK+V3xp+/sI4jMc1YIDh5ffUbFdcKXnJk0mJoH1Jg1eaUlzniEmAMbBw8Xxyt/JdjLTfUQ==
X-Received: by 2002:a17:902:f606:b0:235:f70:fd39 with SMTP id d9443c01a7336-23c79624114mr11029255ad.10.1751488229739;
        Wed, 02 Jul 2025 13:30:29 -0700 (PDT)
Received: from 127.0.0.1localhost ([163.114.132.130])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23acb3c7041sm141376475ad.229.2025.07.02.13.30.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Jul 2025 13:30:29 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 1/1] io_uring: don't use int for ABI
Date: Wed,  2 Jul 2025 21:31:54 +0100
Message-ID: <47c666c4ee1df2018863af3a2028af18feef11ed.1751412511.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

__kernel_rwf_t is defined as int, the actual size of which is
implementation defined. It won't go well if some compiler / archs
ever defines it as i64, so replace it with __u32, hoping that
there is no one using i16 for it.

Cc: stable@vger.kernel.org
Fixes: 2b188cc1bb857 ("Add io_uring IO interface")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/uapi/linux/io_uring.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 85600ad0ac08..fe45564579ab 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -50,7 +50,7 @@ struct io_uring_sqe {
 	};
 	__u32	len;		/* buffer size or number of iovecs */
 	union {
-		__kernel_rwf_t	rw_flags;
+		__u32		rw_flags;
 		__u32		fsync_flags;
 		__u16		poll_events;	/* compatibility */
 		__u32		poll32_events;	/* word-reversed for BE */
-- 
2.49.0


