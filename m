Return-Path: <io-uring+bounces-7033-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 48CBCA57C42
	for <lists+io-uring@lfdr.de>; Sat,  8 Mar 2025 18:18:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C6D231889710
	for <lists+io-uring@lfdr.de>; Sat,  8 Mar 2025 17:18:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27E3F156230;
	Sat,  8 Mar 2025 17:18:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Z8tdmJ7B"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70F391537A7
	for <io-uring@vger.kernel.org>; Sat,  8 Mar 2025 17:18:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741454326; cv=none; b=Ue9E+i60vEx8WVwveM7YGH4DCZ3wKpRX1snuTy3Bo2urEzA2WIhaz4ZI6TuzeJgd8v4HSc5cKYlSj8LAGS7M7XrnOvNZruyqKXWlRCmXSsoJ/AMAdR7URqwqg4OmsaX5zpbousMLm/9wCvLBaM5vhBEHCdYVud+NsF+hZkOa1x4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741454326; c=relaxed/simple;
	bh=gUa1LarUC8hQLrE2Cuk0HrRXN4E10np5pin6SxNIxs8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=nMXv6I5g0uIj5UV1+gTIpHAjnL3JGQOAZcRkSZr5jqDZVeB1jdaoyHSNVd0yCzvXWtslog0NeyAluM/n51O8s7LTQATYmHKO4IdFm+TJjbsxOpoXElJjk9n0Q0AkxBHzOfwaAW2V8sUUbzAS+qEkdag6R2/S7Xzr2aQzVjl6eA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Z8tdmJ7B; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-38f2f391864so1568589f8f.3
        for <io-uring@vger.kernel.org>; Sat, 08 Mar 2025 09:18:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741454322; x=1742059122; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=/eqYsIouvwZDCjQ6miaN33+bwSRQgMaKVBkDlIABfBU=;
        b=Z8tdmJ7BLO0yj+eG/+2ZIGUmwJEah1D1CQyj5OhtKFy8y1E/EVHga8c7vjTl3FyQtP
         X+X7/ncG2+nR12ChciprFN0N8jFUymyMQQ29XVfBFD5FtgHlNFaMNRjIUgCngzUdhci1
         pQ5WmY+GB9WRWSxzl8MWV437HWuiZ6C/sKZSS4HwXJ1QZqckydcfw/M02vEklZeRjPIx
         BkHG7Jb6CY35W+mbZrArN1NKHKDheQBmtJC7/GXf1s/+xzQGKvBFkokOnE3YlCkWnfbI
         inFyHMqyI2kRwSEXWRWwJqx3m1mPH5sxOQWPMO7D8zQXNu5v4zeN6R0vc1B2VP6jEpAB
         iePw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741454322; x=1742059122;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/eqYsIouvwZDCjQ6miaN33+bwSRQgMaKVBkDlIABfBU=;
        b=gFUGWQ5DRHPKt9ZVJ3GsmTF0izO3HlCT3Nhkh0a8Zooa7C5sn3b2K7hzIEFSaSEFwL
         xFGdsm9EvVn/+hn84ucuhvqDzmuECDL94DNpZK3OxN+u0u5NslI4Nsdhk/7TvVlWQmbD
         gGvL7Agx4EqUwzPzpJaS8uJfNAL89O+EfOZ3lerReKpWgqOoXJkx8gHXJRQqyVJQcD26
         HIWec6mH+pRpzPiHTk2cEGja4OVQCunmaLgzkHrhXEyFrLNjHUj9n3xa3/BEQndbesBt
         Nt8Sfd8ctHGUgVsPJ7KqkNCalQs0M4SFbvm05i51z4IvlvSMN2T6pnB+jkmXfXKHBPzo
         P03A==
X-Gm-Message-State: AOJu0YyHHLdJBzSeFgrMxnoDycsPpSR0M34dXS/AhGoBst2OCNNy7FIg
	vJX8Q6qawGZ6ckI1gP1BLXDswDh4b+icJ/mqEpMxlKzzjdzf/72WB/G/Tg==
X-Gm-Gg: ASbGncvA/8QdR4p1+zSTNmooACxkYYtPafTMtj0UXZ1FJkcP5ikmekUtzXBwJsETyEZ
	Ywhdmbhjr1mH2TKrOFYm/yyJ663isknTP84iRn3Jpr8Eez7rHYIcBJ4VjVHCcaA4J5rCqjBFXya
	JiXcI4UZzQDRk/O5KdMXK8j7FcJxJHimyPd/HBjkEE/R6Jj2AkX49oEWU0+xkT/v5KQxeGTAEa1
	5T9dRzp5mOOwLGvh/9pRNIj7IifryFi6wZsimNJHTzsLri/CURrRc8La7O/sVDKbmMJlTR+sDJW
	f645wDOPTfmExBLuno44YhWcQVEqWl+eEFTMtS4Pwig4JYYAXAuSp7ttow==
X-Google-Smtp-Source: AGHT+IFoT/IgrSRltR3XmL7xgg2iSR+SQAJWXvsQjb2Pme2MkJTg7l4pElH7bJMoOs45UlMdNMtX9Q==
X-Received: by 2002:a5d:6d04:0:b0:390:f0ff:2bf8 with SMTP id ffacd0b85a97d-39132d05f78mr5325261f8f.10.1741454322154;
        Sat, 08 Mar 2025 09:18:42 -0800 (PST)
Received: from 127.0.0.1localhost ([85.255.236.160])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3912c015c2csm9196679f8f.49.2025.03.08.09.18.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 Mar 2025 09:18:41 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 0/2] improve multishot error codes
Date: Sat,  8 Mar 2025 17:19:31 +0000
Message-ID: <cover.1741453534.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Unify error codes between normal execution path and multishot. It's
a dependency for other work, but it should stand well as independent
cleanups.

Pavel Begunkov (2):
  io_uring: return -EAGAIN to continue multishot
  io_uring: unify STOP_MULTISHOT with IOU_OK

 io_uring/io_uring.c |  5 +---
 io_uring/io_uring.h | 19 +++++++------
 io_uring/net.c      | 66 +++++++++++++--------------------------------
 io_uring/poll.c     |  5 ++--
 io_uring/rw.c       | 15 ++++-------
 5 files changed, 38 insertions(+), 72 deletions(-)

-- 
2.48.1


