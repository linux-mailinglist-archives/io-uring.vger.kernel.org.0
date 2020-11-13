Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECC542B2958
	for <lists+io-uring@lfdr.de>; Sat, 14 Nov 2020 00:51:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726064AbgKMXvg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 13 Nov 2020 18:51:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726039AbgKMXvf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 13 Nov 2020 18:51:35 -0500
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCD62C0613D1
        for <io-uring@vger.kernel.org>; Fri, 13 Nov 2020 15:51:35 -0800 (PST)
Received: by mail-pf1-x442.google.com with SMTP id x15so7639019pfm.9
        for <io-uring@vger.kernel.org>; Fri, 13 Nov 2020 15:51:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HaWEXOOzp0G5PGuT13KqPWJP+jk04JTlKifBH6RTAOo=;
        b=gb+XV5ZVRfA6hix5UjzYxIe9JuVVLtPkSSvfuhfYYoEqN25sGDQvGgSDbBcDioa4Dg
         6v2YpB2dpt2xr1WYlsz/4cBdCHAAQEYHK7qzAPrW8ilATFtVZ9ltfgDRRnIRchI3656u
         /9mH/c/oo0C//jTTbjpR19oPgSn4mAqqhJNoTGElIEp8tTHDYKM/JV8Tebhw0/RpjPNU
         muus8y2InqtMHCOPmdxqZEh1nDSrMRpHX5Fz1UoWf6kOTaE1yDpB91vMrP4MscaHFUv6
         03kRZEgk39zSv2yzwYUbtKDyuh/q8NQBz31OHRAl2fRwecE0b6WZgpQO3w+w3J9k4oOa
         9A8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HaWEXOOzp0G5PGuT13KqPWJP+jk04JTlKifBH6RTAOo=;
        b=JV1hxdEzHoQ4YL2dBsN/ij//ASvy3XPX3APytdcW11d2XbQRSEFTmr3BZJRWWBZhQP
         vIos4/GjYiuYqUxlMmlVtv7WJryvSeOd8tB5qx1uxdb4WLcYAizg153ZQ2WDKFJF/stc
         AJ70883xBNmQi2bglIEGWv3EJ0D2BXNZWHRSXw7ZGkRvLMjrXulQY9iIaAckEfe/iLt5
         uBHtObWY+blgc+d1OQMYRx8Tt5aWWxk04zEkwnn2NNrC8Giv2ZDVktoNwikxDxBvFy0e
         5VJ1xCAL1IoKjsrqZrHWi2SNQSSZjaDddYpW2zDq8Iipusp+lcNdHpvsENW8kR4Y86je
         ariA==
X-Gm-Message-State: AOAM5314K8lsCHL4+lHoR0vEwgBJXn4mxdcS2+KU4Q+/xsOOYfluZN5j
        9p4aeiFUmTabc4T5yEOcU4BDoxS3tVd4AA==
X-Google-Smtp-Source: ABdhPJwazhxFulfC1R2Z8DYiIl5deV3SevC5P9d1sE3fFvPTZjxz9rrdeyuMbNYJhj5A/XpSgVMpwA==
X-Received: by 2002:a62:6586:0:b029:164:1cb9:8aff with SMTP id z128-20020a6265860000b02901641cb98affmr4113296pfb.64.1605311495167;
        Fri, 13 Nov 2020 15:51:35 -0800 (PST)
Received: from p1.localdomain ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id n4sm2634751pgh.12.2020.11.13.15.51.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2020 15:51:34 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/2] proc: don't allow async path resolution of /proc/self components
Date:   Fri, 13 Nov 2020 16:51:29 -0700
Message-Id: <20201113235130.552593-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201113235130.552593-1-axboe@kernel.dk>
References: <20201113235130.552593-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

If this is attempted by a kthread, then return -EOPNOTSUPP as we don't
currently support that. Once we can get task_pid_ptr() doing the right
thing, then this can go away again.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/proc/self.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/proc/self.c b/fs/proc/self.c
index 72cd69bcaf4a..cc71ce3466dc 100644
--- a/fs/proc/self.c
+++ b/fs/proc/self.c
@@ -16,6 +16,13 @@ static const char *proc_self_get_link(struct dentry *dentry,
 	pid_t tgid = task_tgid_nr_ns(current, ns);
 	char *name;
 
+	/*
+	 * Not currently supported. Once we can inherit all of struct pid,
+	 * we can allow this.
+	 */
+	if (current->flags & PF_KTHREAD)
+		return ERR_PTR(-EOPNOTSUPP);
+
 	if (!tgid)
 		return ERR_PTR(-ENOENT);
 	/* max length of unsigned int in decimal + NULL term */
-- 
2.29.2

