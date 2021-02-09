Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E608314694
	for <lists+io-uring@lfdr.de>; Tue,  9 Feb 2021 03:43:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229891AbhBICnN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 8 Feb 2021 21:43:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229704AbhBICnN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 8 Feb 2021 21:43:13 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7CEBC06178A
        for <io-uring@vger.kernel.org>; Mon,  8 Feb 2021 18:42:32 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id fa16so733395pjb.1
        for <io-uring@vger.kernel.org>; Mon, 08 Feb 2021 18:42:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tA3NkU7/ZdOeyh4OgJY88cyaW+ePcQQoqdXxwUHc2g0=;
        b=i9PJSBwzTbDZuxA3G0oFraxAmIc9Q+OcH/i6djntpmLkrbYz3Mn9W5HaRFXt/4dtMf
         nZUeJH2F7jrAOxBq+LfjexEH9E7rQ1drsuPKlBaHY6tT2rTCTPExvHQh4joi7SBi9eJT
         RbC46xObuPO4+p/ZLsLWFLhoecrWyWoUkSXV2e+zG1e4ttL1XPIjjY0f42yvCpnK3pD5
         Q4v9l3IfdyZpuxnUwMCWqc/zS58+JqEvPh3WrcEH3MEEUzcrCI2FIX3yliUAWdbQsB7k
         P7w9IzYEpHP/KPHXgZVGLYAsSIe/69YGd55ELeTJOgQhnv1v+c+LJerN75YWVR3jXtBG
         Akdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tA3NkU7/ZdOeyh4OgJY88cyaW+ePcQQoqdXxwUHc2g0=;
        b=bqNVuGqdcEJzDvLauOZeJF8FeczzzYhzzNCF+eJX8jVg9yohb/too1mEWpNM/eUIoi
         N4gfwH+3p7/QjnHSSQhZX/GmNXN2/EFqzAQTUMbg6k485Xaf9xl51IoCYtnelyn+NHZy
         KUoI2PPy+86hiJoqABeF/6+4/C0lrLmfQkhOrf1PTuhgL15T8/Wuck9V9W7v538q0UPi
         r/HXln9F7doIWarAnW4aU2bf2EY+cDXzxFVOOYaolsB0liWwud/nbA3UtQkd5N8GiRAU
         YdMmGqqWALDXWHP8u2VX5IZa5gjBzFm/oREI6oVYeGEatHPNUQ6Tjch7EkCKLJA8HzhR
         gYpA==
X-Gm-Message-State: AOAM530tR4ftXR7WoboImb2Cxke/F3sUbE4/fo36SXH9DirGTBxPKucj
        JRQiErWGg+NVTc/4YToyX2WE+A==
X-Google-Smtp-Source: ABdhPJxtPXnBWIRRunn95nq37MIc/77qYGEHxQk2gdMt3spElLIQtBpYtk8yKNRD8RhX2T6sm9QBEA==
X-Received: by 2002:a17:90b:1c0d:: with SMTP id oc13mr1853885pjb.156.1612838552301;
        Mon, 08 Feb 2021 18:42:32 -0800 (PST)
Received: from localhost.localdomain ([139.177.225.224])
        by smtp.gmail.com with ESMTPSA id m4sm19428755pgu.4.2021.02.08.18.42.29
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 08 Feb 2021 18:42:31 -0800 (PST)
From:   zangchunxin@bytedance.com
To:     viro@zeniv.linux.org.uk, axboe@kernel.dk
Cc:     linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Chunxin Zang <zangchunxin@bytedance.com>
Subject: [PATCH] fs/io_uring.c: fix typo in comment
Date:   Tue,  9 Feb 2021 10:42:24 +0800
Message-Id: <20210209024224.84122-1-zangchunxin@bytedance.com>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Chunxin Zang <zangchunxin@bytedance.com>

Change "sane" to "same" in a comment in io_uring.c

Signed-off-by: Chunxin Zang <zangchunxin@bytedance.com>
---
 fs/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 1f68105a41ed..da86440130f9 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -9519,7 +9519,7 @@ static int io_allocate_scq_urings(struct io_ring_ctx *ctx,
 	struct io_rings *rings;
 	size_t size, sq_array_offset;
 
-	/* make sure these are sane, as we already accounted them */
+	/* make sure these are same, as we already accounted them */
 	ctx->sq_entries = p->sq_entries;
 	ctx->cq_entries = p->cq_entries;
 
-- 
2.11.0

