Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA2C92A50DB
	for <lists+io-uring@lfdr.de>; Tue,  3 Nov 2020 21:28:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729069AbgKCU2g (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 3 Nov 2020 15:28:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727688AbgKCU2f (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 3 Nov 2020 15:28:35 -0500
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86184C0617A6
        for <io-uring@vger.kernel.org>; Tue,  3 Nov 2020 12:28:35 -0800 (PST)
Received: by mail-il1-x141.google.com with SMTP id p10so17328467ile.3
        for <io-uring@vger.kernel.org>; Tue, 03 Nov 2020 12:28:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hhzfw14IyWG6DNw/8xIPvxtuo1AosvVepesLayzc1jI=;
        b=MEBRQvG/vYLAshiGV4kuALF27cC6Y4yqzWxkXHyNd2w0DTJ/fRB/Boab9HLBzFWitq
         3GHT7G5ZXhNrP7f3MEXfPqDU0OgkTs8mt8uei5Eba8SY6nIy28hpDVnUrbTnWIIu+cFT
         rYFFQOT20TRlUq9ohKWbJdwmHkyMRBLfFZpS2je80oMPZyLk+wLbB6kf/SaEzKsa4vcM
         jb1hrAC/5GriB2r/NYamlBp97gbK0TBuWf0J/7hhdKYssrfytBql+/T3clKAXQeS3qVk
         79rQwJlh8/Pdy/lPn6WvxcTQ/mrahq6vt2WUU49XxeUwGU5KC425lUc3BIwU2bCdTFsT
         BlzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hhzfw14IyWG6DNw/8xIPvxtuo1AosvVepesLayzc1jI=;
        b=HzDp8qX3E6RKUeMKUPxVWtfghuJe8+0mwO0CBZzvlxnaTZMq6aFJSuee0QFjLuHy8g
         wD+FTKiEURwUruZ9NWaxqlvqrhbCYQWY6M+1aDprS/rrgrYQuYlP75Rft5klJONXT5pE
         A+awnObl5Tk+SSF63fLP1QBnst34Xye/DSXwxustMIdcP/1ePMr1rAD26UMc5NUAdQ8x
         /Y5jEpYa0wFrJpFV0HIt44dMrpLXOpLX5kr6Rk6cnzI0DCCsXmtP3WI1Z7a2wdAzTj1V
         +tmq9FYrAu9c2XdvuPgMcYoFMsFLhso5pY6m4QXkv5EQo2PDZ4B0VNxTe0tFwtAiCcL6
         iLeg==
X-Gm-Message-State: AOAM5301YKVz+5MsEYHiecAx9hGijDvTorjlqRBZVa5478WWUywj2Yyt
        4Ffj0Fxx6kqjgoC2k3Zt/I11FWMYATNNwA==
X-Google-Smtp-Source: ABdhPJzTPZCBAvmKij6vTVX592CcLzxjcwpkKMRQWtZ8ENyECsQpsV19GFo9nXNHYGn3HolN5zY6UQ==
X-Received: by 2002:a05:6e02:f0e:: with SMTP id x14mr15138161ilj.307.1604435314572;
        Tue, 03 Nov 2020 12:28:34 -0800 (PST)
Received: from p1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id d6sm13472902ilf.19.2020.11.03.12.28.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2020 12:28:34 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/4] io-wq: cancel request if it's asking for files and we don't have them
Date:   Tue,  3 Nov 2020 13:28:29 -0700
Message-Id: <20201103202832.923305-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103202832.923305-1-axboe@kernel.dk>
References: <20201103202832.923305-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This can't currently happen, but will be possible shortly. Handle missing
files just like we do not being able to grab a needed mm, and mark the
request as needing cancelation.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io-wq.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index 02894df7656d..b53c055bea6a 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -482,6 +482,10 @@ static void io_impersonate_work(struct io_worker *worker,
 		current->files = work->identity->files;
 		current->nsproxy = work->identity->nsproxy;
 		task_unlock(current);
+		if (!work->identity->files) {
+			/* failed grabbing files, ensure work gets cancelled */
+			work->flags |= IO_WQ_WORK_CANCEL;
+		}
 	}
 	if ((work->flags & IO_WQ_WORK_FS) && current->fs != work->identity->fs)
 		current->fs = work->identity->fs;
-- 
2.29.2

