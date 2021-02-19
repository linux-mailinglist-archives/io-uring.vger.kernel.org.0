Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21BEA31FD9E
	for <lists+io-uring@lfdr.de>; Fri, 19 Feb 2021 18:13:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229745AbhBSRKw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 19 Feb 2021 12:10:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229720AbhBSRKv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 19 Feb 2021 12:10:51 -0500
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE3ADC06121F
        for <io-uring@vger.kernel.org>; Fri, 19 Feb 2021 09:10:31 -0800 (PST)
Received: by mail-io1-xd30.google.com with SMTP id n14so6370187iog.3
        for <io-uring@vger.kernel.org>; Fri, 19 Feb 2021 09:10:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=N+770xYH5vETJvOwoseglSZUD6fhuo2bTBIIh+Fb9/0=;
        b=dDfsj3CTd/yxsxcamTWnO8WzBrPZlMczQ80SrlA+Yc90Z0oomvEZXc88xQvYZzznZa
         mR4HmbUMhRYeaBMOvCsg1Drjc65Aqd0ktJYtWuEeiwdC/dW2LBIbYOOaMxHXsDEG7gPN
         lwFMmpmy6ocaHQbEpwcvOfTcQsmVV5QuwmCBGRIuGUIlvhV0EDdidl2Vf1buf6cZfH8U
         yghFAMSiReHUICbaRpJmQXT1OdfFS4zXcsvKXdnbaOMuhysJ4rX/vsSGlVsSdTwFknIf
         MI3ydYJomtRWmj+7Ms5JeE+duHM2PuNn8fFFvP3wrF6mQ8COXWY0EgKubB/O2UA0uGU2
         TBVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=N+770xYH5vETJvOwoseglSZUD6fhuo2bTBIIh+Fb9/0=;
        b=GAgMtNvhhdx2lpUM7mfKzQKFDK3b/TVTZoP+r1PExmTZtIi/mzBiizYZTOVNT7Ey73
         Lb5Gf6qhY3zwWlfpatWB2RronXaApbvLEkmUDPsRwO4NiyepwdFOl6DWuL9xbWMGwoLP
         YfwYcVYP4fqKQw7Hn6aOOOLWe3srG0McZhWp1ASXn05yI1NByhtLVOEOnCsuFjpAHw9h
         gHLz/MO+SuBEa7BpamjW63nBZMBdnTwQZPVQmYmg1iTaYp2CHgosxDa/y6eec/O1soSw
         DP+Oyrt8ofKeXUjtPz6dc9w3qXfTs6d9rHlZldsWaRuEYucqXVyHejVonace75H0DAum
         hfNQ==
X-Gm-Message-State: AOAM531DyJ9/6Ae/d3l6IIrN5JoX5dkyxDWdYLjHffxjvgsyNh2oXVU/
        CN6+3I+ROXsWm3ZfjPX1gDxC75LYUWa07yX5
X-Google-Smtp-Source: ABdhPJyqYJWFbM9l+Lw159qNnKtfXy8DzB1zrzVoHGgBECBFQAknvLMm9gXPlTEcUkeZFX76HB6S7g==
X-Received: by 2002:a02:660b:: with SMTP id k11mr10838580jac.120.1613754631078;
        Fri, 19 Feb 2021 09:10:31 -0800 (PST)
Received: from p1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id o17sm4805431ilo.73.2021.02.19.09.10.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Feb 2021 09:10:30 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     ebiederm@xmission.com, viro@zeniv.linux.org.uk,
        torvalds@linux-foundation.org, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 17/18] Revert "proc: don't allow async path resolution of /proc/self components"
Date:   Fri, 19 Feb 2021 10:10:09 -0700
Message-Id: <20210219171010.281878-18-axboe@kernel.dk>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210219171010.281878-1-axboe@kernel.dk>
References: <20210219171010.281878-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This reverts commit 8d4c3e76e3be11a64df95ddee52e99092d42fc19.

No longer needed, as the io-wq worker threads have the right identity.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/proc/self.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/fs/proc/self.c b/fs/proc/self.c
index cc71ce3466dc..72cd69bcaf4a 100644
--- a/fs/proc/self.c
+++ b/fs/proc/self.c
@@ -16,13 +16,6 @@ static const char *proc_self_get_link(struct dentry *dentry,
 	pid_t tgid = task_tgid_nr_ns(current, ns);
 	char *name;
 
-	/*
-	 * Not currently supported. Once we can inherit all of struct pid,
-	 * we can allow this.
-	 */
-	if (current->flags & PF_KTHREAD)
-		return ERR_PTR(-EOPNOTSUPP);
-
 	if (!tgid)
 		return ERR_PTR(-ENOENT);
 	/* max length of unsigned int in decimal + NULL term */
-- 
2.30.0

