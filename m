Return-Path: <io-uring+bounces-1144-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 104088808FF
	for <lists+io-uring@lfdr.de>; Wed, 20 Mar 2024 02:23:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id ACC971F2438F
	for <lists+io-uring@lfdr.de>; Wed, 20 Mar 2024 01:23:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C91B1364;
	Wed, 20 Mar 2024 01:23:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="A1hqkPPY"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f174.google.com (mail-oi1-f174.google.com [209.85.167.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C20CF7464
	for <io-uring@vger.kernel.org>; Wed, 20 Mar 2024 01:22:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710897780; cv=none; b=lArlaARKpgd5F/aAPpU87tS3AQdJLKtKX1yyQIUX45yc6YN/DDurJaUam+tvz7qCWCjSc7gpkElYCWWoTxK3dTJpdrzHGnMpkRYPtgwB/JO7SRMJ0/+TZCqtEdrt0ApJjLJEj0dCtIl7QSwVcKLGLw/AR5nf5iP3vQM18VTVXNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710897780; c=relaxed/simple;
	bh=nemSNv3ziVdWQb6MMl5+J7M28HRk4nM1lQAPS9uV4/Y=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=IYzEYUcf+UFobq/j/7ArzL9BzN+pekG0xEbbFfa+4ltSUB/z3/XiEoNKz51SFiqInF40U0zu8Aq0vcyz+nTsVcLWDDGYDS3+o4ihxTexsPtcK3neqmhLcTpKKgV/R7X7NSVeyFHqqkQ/Kxt22uzV1Bx2Nbhr2VL3MH9djbRKe5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=A1hqkPPY; arc=none smtp.client-ip=209.85.167.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f174.google.com with SMTP id 5614622812f47-3c383516de2so828462b6e.0
        for <io-uring@vger.kernel.org>; Tue, 19 Mar 2024 18:22:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1710897775; x=1711502575; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=xUofXNWmE22u9Ao72msqtfMixrXYFX4Sp8PV/6XiPq4=;
        b=A1hqkPPYTWAcR9KeT4IrEQtZXftd4Gc7xpsIf2SVruAQW0DjmaffC3cE+GGAItP77W
         LpDf7rOhziasgtFbBCh4qb06gS3P8cXeju44UnOcJ6zqv9g3DeVriolxcVI/D4N31+zb
         pNR/ui+2r0jXVTbhC20DEj8yXk+8WzMhYHGBy1r42lvE8sTKuD5dPWbvA1e15mQI1Yr2
         sJCqnL1LIw0SB/WH3/9cl5pOP3pjgWZbqqPl5I+gufDK9UmvpFsxMq/JtBROQyW0ZG1X
         LDIgjrnYAUHb91GKDLSZA4uFnvTLENsZ4UnvxZ3z4BeghD2xfpen9tFNVT1xOX6GGivI
         YfhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710897775; x=1711502575;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xUofXNWmE22u9Ao72msqtfMixrXYFX4Sp8PV/6XiPq4=;
        b=xSVFLo3kjHv1fi9lHNc5490pUSRiT/x9X/ZWJpIgBHrWnlmkDQsd7CgYUjCv3zxS93
         Qf/jgCH24udHWxHuIi/cKMJb7+h7lBY7stSV6A/PMVQGWF5PVoGtMmSfZXqO9SreOWdp
         nwYaebrMdcLBG8GxxPo8g0qBgG7nmpkdyhURzgk5+c37BSsETi672PBlB21hJUVB+vMC
         Afdy79uWb9Ih0Ij+4SS68PkP+qy/Y6IHI5Yhr4v5pxsDnSCRTVmnbReJQ9MyE+8shJF7
         EOwx0d1Q0ts636fUYqTATl8FYRyJIzF2Xp7Cp0RltDeMKcX9CAfcRfsrdh6dQwUYBSFA
         CtiQ==
X-Gm-Message-State: AOJu0YzobWOdoWlMPfMAUfpLIsaG1VMxiPkMwmQmQhJpxebghw46zjJq
	k41shMXPiUmPTGAUYwmhcLBUkkYZbgwoUNQMYoM0ykuYHPtASb+M9NsNXFG/16jnSMFE1HAuiDr
	9
X-Google-Smtp-Source: AGHT+IFgSRBruc1GNsBuMi7I4qc85NrFz/C0kdwu3Cg+6JY1LExwawaP9mPscOIvHd6eYem4eGAakQ==
X-Received: by 2002:a05:6808:1897:b0:3c3:7eb0:aca4 with SMTP id bi23-20020a056808189700b003c37eb0aca4mr4324071oib.5.1710897775357;
        Tue, 19 Mar 2024 18:22:55 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id v22-20020a634816000000b005dc26144d96sm9618007pga.75.2024.03.19.18.22.54
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Mar 2024 18:22:54 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Subject: [PATCHSET 0/15] Get rid of ->prep_async()
Date: Tue, 19 Mar 2024 19:17:28 -0600
Message-ID: <20240320012251.1120361-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

This patchset gets rid of on-stack state, that is then fixed up and
copied if we need to go async. Having to do this fixup is nasty
business, and this is the main motivation for the change.

Opcodes are converted to setting up their async context at prep time,
which means that everything is stable beyond that. No more special
io_req_prep_async() handling, and no more "oops we can't proceed,
let's now allocate memory, copy state, and be ready for a retry".
By default, opcodes are now always ready for a retry, and the issue
path can be simplified. This is most readily apparent in the read/write
handling, but can be seen on the net side too.

The diffstat reflects that, but doesn't even tell the full story. Most
of the added lines are trivial, whereas some of the removed lines are
pretty hairy.

Lightly tested - passes all tests.

 include/linux/io_uring_types.h |   2 +
 io_uring/io_uring.c            |  42 +---
 io_uring/io_uring.h            |   1 -
 io_uring/net.c                 | 539 ++++++++++++++++++-----------------------
 io_uring/net.h                 |  10 +-
 io_uring/opdef.c               |  65 +++--
 io_uring/opdef.h               |   9 +-
 io_uring/rw.c                  | 536 +++++++++++++++++++---------------------
 io_uring/rw.h                  |  27 ++-
 io_uring/uring_cmd.c           |  77 ++++--
 io_uring/uring_cmd.h           |  11 +-
 11 files changed, 613 insertions(+), 706 deletions(-)

-- 
Jens Axboe


