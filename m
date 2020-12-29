Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F9942E72D2
	for <lists+io-uring@lfdr.de>; Tue, 29 Dec 2020 18:54:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726156AbgL2RyC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 29 Dec 2020 12:54:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726126AbgL2RyC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 29 Dec 2020 12:54:02 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15E3FC0613D6
        for <io-uring@vger.kernel.org>; Tue, 29 Dec 2020 09:53:22 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id z21so9610406pgj.4
        for <io-uring@vger.kernel.org>; Tue, 29 Dec 2020 09:53:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=sCZwDmA6OVu+Ek601lwnqSa9RMRK6G2LA3WTbDhTL6M=;
        b=R50EeaM9GDdI0foJ8bPLdI0loeeY4gCLwyu1UU9gycUdFw6W7F6luQhVnKMX0Hfphn
         GPoHYSm7koLLydpmGP6yowR6kL4miY+xTU2qz5y/YTfq9olMNQucA891kasXvvx/tTYp
         7pLfZ9uhVO46zfD7f5t5Jli1+hQvcdYr91dYbTHSulLGxKJUG3uJ6qM/85vW1Rf1BUzP
         1PIhbLmVqyikKw11nt/OEM5FbvUfuzxOZ9z3vRKadoU15acOvuklRHQDWz697Emk48GP
         Z7AU/L7dI+Jg3lyfrOO1/tVbmdWqbWvzSyc2JYGHAwD3sr8i2Gx1VBObM5nieqC7XVW7
         DIag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=sCZwDmA6OVu+Ek601lwnqSa9RMRK6G2LA3WTbDhTL6M=;
        b=XgECNr5EDcKP6duHDMx3VN3F2xBVmNBvDO1et3MRV3YCj2/lwhc2ptio0VhtKZVSZ7
         f7HUBteGCmF8SceR2zy0bmwMNe44WMunme+N8Pmb4zWojwJufyQixs4TjJNT1Ev7Dzw0
         MuEWivd8kv9xFeQ0Qi/0JwWLNSeTi6pcya2i3CMgAaJaGBPnzni13SHOZxk/djAvIjyl
         MSEzBjNZo248CDQAHx4zaGnzBBPb2h1xwN6mEodx9O6I4VMhrboC0rfLUZZJ1SRDEX7A
         r1Ic8/HGxmti5TXwlK58tcr/cH2yYslQjpIuEX+twm6EdEGXN5n2KruVtu/mI0NxibQW
         f1Qg==
X-Gm-Message-State: AOAM5308gt7Qw8bYgpq/Of1DCyQ/exemzqyDFvsk5nGBZgu10IYgS2mF
        XBFVSZd3s6BjJjNx2lO+oUJi8Z+qLe2BwA==
X-Google-Smtp-Source: ABdhPJxaAXtVo/mZFJ5CkVB2ssXEU4O9xcrA83IWwACBRiMKA/0sHQv+HFyWkHzMevBOHPONa1H7Yg==
X-Received: by 2002:a65:6152:: with SMTP id o18mr17649696pgv.392.1609264401587;
        Tue, 29 Dec 2020 09:53:21 -0800 (PST)
Received: from ?IPv6:2603:8001:2900:d1ce:f5ec:8788:24db:a0d1? (2603-8001-2900-d1ce-f5ec-8788-24db-a0d1.res6.spectrum.com. [2603:8001:2900:d1ce:f5ec:8788:24db:a0d1])
        by smtp.gmail.com with ESMTPSA id e10sm39409809pgu.42.2020.12.29.09.53.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Dec 2020 09:53:21 -0800 (PST)
To:     io-uring <io-uring@vger.kernel.org>
Cc:     Christian Brauner <christian.brauner@ubuntu.com>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: don't assume mm is constant across submits
Message-ID: <7224e4df-50e9-ffd1-5453-391802fcded7@kernel.dk>
Date:   Tue, 29 Dec 2020 10:53:21 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

If we COW the identity, we assume that ->mm never changes. But this
isn't true of multiple processes end up sharing the ring. Hence treat
id->mm like like any other process compontent when it comes to the
identity mapping.

Reported-by: Christian Brauner <christian.brauner@ubuntu.com>:
Tested-by: Christian Brauner <christian.brauner@ubuntu.com>:
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 7e35283fc0b1..eb4620ff638e 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1501,6 +1501,13 @@ static bool io_grab_identity(struct io_kiocb *req)
 		spin_unlock_irq(&ctx->inflight_lock);
 		req->work.flags |= IO_WQ_WORK_FILES;
 	}
+	if (!(req->work.flags & IO_WQ_WORK_MM) &&
+	    (def->work_flags & IO_WQ_WORK_MM)) {
+		if (id->mm != current->mm)
+			return false;
+		mmgrab(id->mm);
+		req->work.flags |= IO_WQ_WORK_MM;
+	}
 
 	return true;
 }
@@ -1525,13 +1532,6 @@ static void io_prep_async_work(struct io_kiocb *req)
 			req->work.flags |= IO_WQ_WORK_UNBOUND;
 	}
 
-	/* ->mm can never change on us */
-	if (!(req->work.flags & IO_WQ_WORK_MM) &&
-	    (def->work_flags & IO_WQ_WORK_MM)) {
-		mmgrab(id->mm);
-		req->work.flags |= IO_WQ_WORK_MM;
-	}
-
 	/* if we fail grabbing identity, we must COW, regrab, and retry */
 	if (io_grab_identity(req))
 		return;

-- 
Jens Axboe

