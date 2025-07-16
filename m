Return-Path: <io-uring+bounces-8704-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 675EFB07F38
	for <lists+io-uring@lfdr.de>; Wed, 16 Jul 2025 23:02:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A982716B76A
	for <lists+io-uring@lfdr.de>; Wed, 16 Jul 2025 21:02:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52B1F256C9E;
	Wed, 16 Jul 2025 21:02:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RfMvSHCR"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E04B4A11
	for <io-uring@vger.kernel.org>; Wed, 16 Jul 2025 21:02:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752699776; cv=none; b=P5Rd8nv62D4qsooyZxpbijVIf5kFN5o3z3KgE87dE40kE2YXto/9lwkppARhxll07xOhnagOFbxN4v7XDqhYUyFkQ8JFRt5uAVfx7lJdkg4SEWwNzoiFikrym0Hs1+CGpMSsmLJhKjtydTuJQ1oJP8cWjDBIn9X5JREwGvw7/fI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752699776; c=relaxed/simple;
	bh=MLh7oEzP1VfUIXe2jFKUA3lHQ/w8PPddQQgcvrg5iGM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=BQaLbr+/IPnjUp5Pf0JTSQSuJBfcEAQMJSHU8B4GxUtfwW0JtCP/Lgq9x+lCKA4nu0Uki7mPX/jn1KyDLVqxBsKMGZ8ZxbpSoblJgigXaeHS9xTurulr6D5Agz0VawojZFkDZodhVYIZsvln12S8Wi3RoTUukfWdwRLaDhzuBnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RfMvSHCR; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-aec46b50f33so49454766b.3
        for <io-uring@vger.kernel.org>; Wed, 16 Jul 2025 14:02:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1752699772; x=1753304572; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=awjkGEny+FXNQg6BoGX8ocCjNTbs1sw16aO6k1le/qQ=;
        b=RfMvSHCRQgp9NbyZwrtXL7zfR054NodsG5sOE8dpm2XHEnbm2AaT7d3KriLQw8rzTq
         S2/MZvhaETALoCr8TNLJ7EDwPoA9k/kmb1jLWPTI3Pm+AXZY30YecA1O3CKt1pcKCI/W
         TRw+pa/ZXJRH+L7hb+Mmt/tqNjZTDpgboAJAcgNv/COYPd92esFqJZoRpWI+d/2E1QIA
         Zn6E7luuhx7+TEIdNT7zou7Ft5tCMVF1+itjx2FPnnEyTw6ZRdMYu1q0rlfzN2Acdixd
         RijcI6jwsMK8OctIYRn8pIov81mww2nQptRX52peanetvUenbp2e3sOzwi52Gx42jLSO
         xpXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752699772; x=1753304572;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=awjkGEny+FXNQg6BoGX8ocCjNTbs1sw16aO6k1le/qQ=;
        b=HJagl/kHcaC6efg3H6r42k/ykBdw4p7eMqGWStU1sKh7shoWWNBHblWdrpbEwiUY5V
         V3jH9h7rOTxQpwUNrdfRLts7axcmWPDu9ON0VTBihs4rMqlpr9oicjhsFZ98ar56ga70
         //cB0btllgf840CQ4pgYK/uzcPuoEfwgtb+r5lZhaD7aRYPWP5zsIIQc6rUqLqT5o2GS
         VlrxU1uEQE7dQ8xI3yv1PLbyHj10z1a9tIayTN64Nh4jeN/8RNBGKHiC1LktLl7GVZpL
         j5z03y/zIvwyqpRRfM8c1FhxpX7G2V9eSnCbn2VDApVy0fKSDtIm5Lu+RKzaXgSuOGyP
         LQIg==
X-Gm-Message-State: AOJu0YwrundRCbICd9BS4SoA8rPB4lEXRvMUZdWwoixiAbev0L5E9B21
	KiBYZg+hacdD/ztylzho0za6dJSeMOFCPld+vYV/9DT9ugcCY+3VL2pQoglkyA==
X-Gm-Gg: ASbGncsKRoQUQsoOrcj5fyfnf3OZ1WXOgMw0WIG0MhShAKNu0x0w9Eij1VpIgxZuHzz
	wx4ljJaRJKIY+PBMMLtKS2i6W3K44KnBzLciOgxAdNpuDWZTk1eJU9b/vAeQVt/9JDgjzGPc3eK
	qh1nNSHSN1vEG6vHXV16ST7pgeMJxmm4Cg5/thMM1IXYBCyCqx2cs0elioRWWrxS425LTkI6jzX
	f+HsS7VKHpbqiaKPyLM9/ahN1cJkE9p+HqEA+6zerinYiLDrYuxmChV3RZanqFlCoCU6u9vie2v
	W2m8lIVSK5qxo4+XoX6oHwL55MFcl+dYL0zjrYxJ3wnBDw2Jg0F8n/uvBZnxIGpxLzvZrk2THQ2
	uBa3YFU6CFM95rmn8uRcDb1xk59Ym37rnYBBBVoVyHwQn
X-Google-Smtp-Source: AGHT+IHk7PhjXARKfR9QWgcb0sF0NDOvHeJsNt2Mv0MMpJ5L3w+3GZO/K8q81TPwJe+9e7BrTsdNtQ==
X-Received: by 2002:a17:906:ef05:b0:ae6:ddc5:ce70 with SMTP id a640c23a62f3a-ae9cddd5f3amr436428466b.20.1752699772142;
        Wed, 16 Jul 2025 14:02:52 -0700 (PDT)
Received: from 127.0.0.1localhost ([85.255.234.71])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ae6e8264fd2sm1254007466b.108.2025.07.16.14.02.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Jul 2025 14:02:51 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	dw@davidwei.uk
Subject: [PATCH 0/2] account zcrx area pinned memory
Date: Wed, 16 Jul 2025 22:04:07 +0100
Message-ID: <cover.1752699568.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Honour RLIMIT_MEMLOCK while pinning zcrx areas.

Pavel Begunkov (2):
  io_uring: export io_[un]account_mem
  io_uring/zcrx: account area memory

 io_uring/rsrc.c |  4 ++--
 io_uring/rsrc.h |  2 ++
 io_uring/zcrx.c | 27 +++++++++++++++++++++++++++
 io_uring/zcrx.h |  1 +
 4 files changed, 32 insertions(+), 2 deletions(-)

-- 
2.49.0


