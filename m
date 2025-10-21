Return-Path: <io-uring+bounces-10081-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 3308DBF800B
	for <lists+io-uring@lfdr.de>; Tue, 21 Oct 2025 19:58:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 203924EC13D
	for <lists+io-uring@lfdr.de>; Tue, 21 Oct 2025 17:58:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E11A34E757;
	Tue, 21 Oct 2025 17:58:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="zWQIt/oM"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f173.google.com (mail-il1-f173.google.com [209.85.166.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8255634E765
	for <io-uring@vger.kernel.org>; Tue, 21 Oct 2025 17:58:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761069527; cv=none; b=VPht5jCfMvVBu4JtvP7D6i04ERE+j7rGOhPKydECRZGazoPSvQ6YsX5msODfrFF/5O9aIwAjRpVZ6JFfw6dtI/JxT1Jh6H2raYVtQOQRrnM/ql7rpascMapn+ap9Fj/EvMUXhkihJO8dkD3T99kH5GZDA7S3KyXGG5QJUZaMDrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761069527; c=relaxed/simple;
	bh=G3UuCJx9QIJZ9IX8c0CLkyXlOUx4crHWu9YIC6qjz5I=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=rAgxBHnT5kZFy0dQdRXMTvN+AlZlAhr3Jgc/J466h7Df8vF6+W8bf3OxBvi++j1qPM3UOXG0R/BFRU1GQqDZ96IBBnA/FO1+qY0LSKF/Bsx6x/GBOvy6aGXFKgYVNMV+Z1jjoyBGbN/EATu8rVD5ClDLmnOLMTjxqg6z38ihmZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=zWQIt/oM; arc=none smtp.client-ip=209.85.166.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f173.google.com with SMTP id e9e14a558f8ab-430d06546d3so34033385ab.3
        for <io-uring@vger.kernel.org>; Tue, 21 Oct 2025 10:58:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1761069523; x=1761674323; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=C8uMCfA2jrJkwiCNzxzIwomFvI8fbL5Nhw6XVrrznvo=;
        b=zWQIt/oMruopfWgutxpu80YKIwugKTVmDq+zBaD7kGdHTJzeU9dwBT0KpA9crK8qK8
         Po1e3uiTmU886HbdAanptbIa8z3cLSAdB/9dv7h7b9CyWOr7peqhF7+vsYF61HOdRPPI
         tsTxuFYXoFuxCEd1Daex622W7J/+pV/xUCAUeVxGHvkFK2AXv81rorBp/ahXP/LKtCi/
         bzE2UER6ICzfvzJIq1yelygOkBIAiA7VdBlG+h3U/AwnX9hIvmw3H5KjIuGHQYR7mRfM
         56t03E8O0Jv8eIdpYHa6yYgXsZm8vaJtI0q53+lr+6bSV7604m9aWFQKzDmUlqOIkzKA
         zCSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761069523; x=1761674323;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=C8uMCfA2jrJkwiCNzxzIwomFvI8fbL5Nhw6XVrrznvo=;
        b=eYgi/PoJNljnWRENbIgXjU2MBLdWRagmODGGjLHfvi7ciz8Nqdog2SZ9ZsFrXxF/63
         NACu8I8PnElo3d/gK8wnG0sgBsBkPaCpHMMco4gOav9g/8g5hbqsmUJY+Rby8aJRIb4Q
         NaapE5plCxrznc9sHz+LjXatiic2kAV48nA6UxgjCpSScnLPQt8NgSlVvNY11fK8NEHH
         1hyy7c5L+W2+2Gt/PsHpPGekosPOj507ySHfVT1kxFT28BLs+ZLXPM/DasBd6Vve300V
         xbjpryI4ZBvEMftA1VruB4J9dcbWD9kTD3DNMGl4YUPEqT+FogpAhb4hA8Jq5NvszQK5
         zVBg==
X-Gm-Message-State: AOJu0YwoqrwDMAg0QPR3s1hc1k/ptyspaPmsBOaneqCvsha+oPQzE2EX
	dDwpJKr0eaLJLnY86uEtYAlAEt+z5t4wAF1ukksqLhrgCQuJGmgw+6igRfxrn5ekqFi0d7Q/NvT
	zq/IBHz8=
X-Gm-Gg: ASbGnct/vYuJcjKXJxfe/H2BObRFVUoYu2Ggwke1nEvlRUE3RiLZUvHAHb41TlGUuES
	6+wZwxefbP9Nrc/bgPnRmb5wUQJumdy/9ckYH0FThx/FGJVwdAd83+c/8OrTeRWOScFll4RJ0EQ
	d5IoTw7CsA+GBVoqsYFAalUaUdPQpVO+ieo7XIAaNO0Vz4M0bmjZQBA8Q2ccDSe3Oj92Ug1vn63
	BeAEZSzKGXmCUCRqDCiD5ymIZzOraHNIVg9bGLLTNhCrpBSmPpzfFeMYejSecvGUd6ehGvBhAmA
	dcqYduMPRuAcgiwb6bDJbZp7uC6mabgR7oaFzS6NuyOUmBUhWwmBHqO6/hNSpxKjQmPfKku/X5i
	lu1Z6OZmwKpdy+ujBjA1NLuYA+BmUIhtjH/5a81dLiA4H6I3d3hwTB+2phkBV4isnej3lXA==
X-Google-Smtp-Source: AGHT+IH/N6BNX002XJu0v2jTENmear6LE0GeA+V5ZSTBc7VJfsjb+/3OZFBpLfYhBqYTq+v3gVjrEQ==
X-Received: by 2002:a05:6e02:3e06:b0:430:9f96:23c7 with SMTP id e9e14a558f8ab-430c524fcd9mr252194865ab.4.1761069522997;
        Tue, 21 Oct 2025 10:58:42 -0700 (PDT)
Received: from m2max ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-93e866e0afbsm419906339f.17.2025.10.21.10.58.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Oct 2025 10:58:42 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: changfengnan@bytedance.com,
	xiaobing.li@samsung.com,
	lidiangang@bytedance.com
Subject: [PATCHSET 0/2] Fix crazy CPU accounting usage for SQPOLL
Date: Tue, 21 Oct 2025 11:55:53 -0600
Message-ID: <20251021175840.194903-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

Fengnan Chang reports [1] excessive CPU usage from the SQPOLL work vs
total time accounting, and that indeed does look like a problem. The
issue seems to be just eager time querying, and using essentially the
wrong interface. Patch 1 gets rid of getrusage() for this, and patch 2
attempts to be a bit smarter in how often the time needs to get
queried. Profile results in patch 2 as well.

 io_uring/fdinfo.c |  9 ++++---
 io_uring/sqpoll.c | 67 +++++++++++++++++++++++++++++++++--------------
 io_uring/sqpoll.h |  1 +
 3 files changed, 53 insertions(+), 24 deletions(-)

[1] https://lore.kernel.org/io-uring/20251020113031.2135-1-changfengnan@bytedance.com/

-- 
Jens Axboe


