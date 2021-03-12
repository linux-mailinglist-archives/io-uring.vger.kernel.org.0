Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2546339166
	for <lists+io-uring@lfdr.de>; Fri, 12 Mar 2021 16:36:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232287AbhCLPf2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 12 Mar 2021 10:35:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232182AbhCLPfL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 12 Mar 2021 10:35:11 -0500
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D95AC061574
        for <io-uring@vger.kernel.org>; Fri, 12 Mar 2021 07:35:11 -0800 (PST)
Received: by mail-il1-x12c.google.com with SMTP id e7so2911857ile.7
        for <io-uring@vger.kernel.org>; Fri, 12 Mar 2021 07:35:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UxzvUOjJYdEYU2eBntdKYBuhHyZ+x0453Ml4IqA7G5U=;
        b=YKlsrInCDAzrYP4kXVFtrAdV5Cj73i0bGkaDiRYjMcbQ6NXaaLeBlBXwlwdYPSnz2p
         KzFP4WDMW1wSzrJ5sutGZNyiMButHmcbKrCh/NKG/2xiglsw/ud6IHqJelhGEDWcaf2+
         cRrOCPOyAQuG8OrW089136fCtRwN4l5HEIsbHbtLg3ejow4pn7B/dVXv9TLPHvfNRD9J
         4WUXiJzuP1ruy5HG3ubcbnNxDZ+rKR1cR4hv+AEhQ1+HXjUVBUJHS8+36BDWO9N9ZhH1
         5CRImTyIzrdqEDTL2KTZTXx/U4iQGQyFXm5V063OVUhcEI8NE8QuqAxgI7AShifkrGAb
         f0Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UxzvUOjJYdEYU2eBntdKYBuhHyZ+x0453Ml4IqA7G5U=;
        b=Gb+YekdAIYQi6I4RiUyEfgitea+gEqa1h1ZdL4pxojVbJ6jYPI73Az2PTb4IkCSbW5
         A3xGvF3E4GKQkMUUK5aMzHoWlHBZMRceCQEE9gTVVaRoEl/WMxD4xA2ikTsm4JgiatVa
         lxWK2Uo8r3z3gRVvWWFrT1IGZgqRWt974tyOyY46zSbsdTIPb0YUDmrmFLEX7LcjE5Mm
         VXeRIoFwz/nuM4SJIzDCmxpnDopaUrgPacgYuqYKjcex/sKurT2NgylAOdekAizW8vqM
         4jSyYCHsgTuJsH4Otyx+NXsYJbTpSzzUJIZz4iqu6Zg7tj2hr+p+MeeRHzUuiLOxjn8o
         ZksA==
X-Gm-Message-State: AOAM530lbYkMTwIyAIMajRlz29ciNEfTsZqG3p0Pw10ZigBX5h/M/2Uw
        yM7t/07YwwaXawoSeoAFrtXL3qmwbPhBhw==
X-Google-Smtp-Source: ABdhPJxfsQ5MQo8s6JAbLdzY3AvA1piqWBEQGAiKQNIUuxvdojUAPAtIVnW6L/T8KjfeJM7G4RQb3A==
X-Received: by 2002:a92:4a0e:: with SMTP id m14mr3263790ilf.117.1615563310422;
        Fri, 12 Mar 2021 07:35:10 -0800 (PST)
Received: from p1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id v4sm3060863ilo.26.2021.03.12.07.35.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Mar 2021 07:35:10 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/2] io_uring: don't check for io_uring_fops for fixed files
Date:   Fri, 12 Mar 2021 08:35:04 -0700
Message-Id: <20210312153505.1791868-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210312153505.1791868-1-axboe@kernel.dk>
References: <20210312153505.1791868-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We don't allow them at registration time, so limit the check for needing
inflight tracking in io_file_get() to the non-fixed path.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 6c62a3c95c1a..c386f72ff73b 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6113,10 +6113,12 @@ static struct file *io_file_get(struct io_submit_state *state,
 	} else {
 		trace_io_uring_file_get(ctx, fd);
 		file = __io_file_get(state, fd);
+
+		/* we don't allow fixed io_uring files */
+		if (file && unlikely(file->f_op == &io_uring_fops))
+			io_req_track_inflight(req);
 	}
 
-	if (file && unlikely(file->f_op == &io_uring_fops))
-		io_req_track_inflight(req);
 	return file;
 }
 
-- 
2.30.2

