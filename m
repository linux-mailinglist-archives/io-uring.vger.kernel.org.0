Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4F722EA08C
	for <lists+io-uring@lfdr.de>; Tue,  5 Jan 2021 00:15:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726749AbhADXNA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 4 Jan 2021 18:13:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727034AbhADXNA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 4 Jan 2021 18:13:00 -0500
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72621C061794
        for <io-uring@vger.kernel.org>; Mon,  4 Jan 2021 15:12:19 -0800 (PST)
Received: by mail-wm1-x333.google.com with SMTP id k10so707145wmi.3
        for <io-uring@vger.kernel.org>; Mon, 04 Jan 2021 15:12:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=obzkBNSGHF6dBR/ceI85LoADRI7lg0YEJ6SFiyPVz+w=;
        b=beYoqU/EfQZZAvvGLuQpf2fv7VXppfFAcNedvjMn0VN8HsP0Lcc3GrlJphhEq+eepr
         SSxdI6UGKpF2h869oBUYCOE3Z+9jX2RoeGfxcqy13vGmlXt0CUGKpGkhw8zM+ujf82X+
         ofgjtawQ5dmQSX3pt/39Y4ijuGRTOShtAQpqEggImrhrCwC1/YODeFFqjqoBIQuQGWg+
         c1Jh5mzy1WvrXY2dLs6lu3SPrggDmsXNBwdAhHn6m/QE5j+NtiVygY4jyZ/JBBLdvbQw
         I1ca8FNnjZqGJZLMloOvk+9KaqgOKhI/dH2kpfIl1DBWcCbPJcO6dWDlBYR0Wefj3mC6
         yc9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=obzkBNSGHF6dBR/ceI85LoADRI7lg0YEJ6SFiyPVz+w=;
        b=BFfjDh/jpY6GdlM5xSGMB/0IIGIv+pi8qqAN8QF1GUoWd9FyZ6FSM9A9QXqo3CmYIV
         km/r6/lqIF8rMYBCVYmKTUuQuvLLnzRn3JIK/8hYS0Xc8kGAyWuCOVH/KCldygFD+oqB
         f7CxLJEsA4Lu1AG18Yg5iaP8zH0uJMzGpaSqxApgwtSE6u7zAZQgEZurIUK4oq6f0KHC
         pRDgEzwHePBAFtdCCnIgnf2hFtvKGquahi6PN2WD52u1lqdmjiTgEjHuoBqNR6H+Ix6e
         E/+W2PMSRXvrTVRbRV+6dhAcr2LjW+39mmX8gwXnsDv7IQc+LezdnGiH2nOfUMETg8Xp
         Qb1Q==
X-Gm-Message-State: AOAM532iO7f/TnWffECImLTrXanXaBlQpfSCM38keRdZaGwPM4bqfPZH
        l6wxynTN/10fHxuquh+AHPfBql8jjuqv7w==
X-Google-Smtp-Source: ABdhPJzJ+9fM+FCuBerDTknLxkYnJbN04/A3Lpk4QmG3JbCZx1dpQ1gmZShY2xYjB+LC+F4egnXbsg==
X-Received: by 2002:a1c:7c19:: with SMTP id x25mr582225wmc.94.1609792964274;
        Mon, 04 Jan 2021 12:42:44 -0800 (PST)
Received: from localhost.localdomain ([85.255.233.205])
        by smtp.gmail.com with ESMTPSA id o13sm73525006wrh.88.2021.01.04.12.42.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Jan 2021 12:42:43 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 0/2] cancellation fixes
Date:   Mon,  4 Jan 2021 20:39:06 +0000
Message-Id: <cover.1609792653.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

[previously a part of "bunch of random fixes"]
haven't changed since then

Pavel Begunkov (2):
  io_uring: drop file refs after task cancel
  io_uring: cancel more aggressively in exit_work

 fs/io_uring.c | 38 +++++++++++++++++++++++++-------------
 1 file changed, 25 insertions(+), 13 deletions(-)

-- 
2.24.0

