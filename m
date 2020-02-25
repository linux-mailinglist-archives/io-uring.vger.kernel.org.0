Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9C6E16EE71
	for <lists+io-uring@lfdr.de>; Tue, 25 Feb 2020 19:55:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730990AbgBYSzR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 25 Feb 2020 13:55:17 -0500
Received: from mail-il1-f172.google.com ([209.85.166.172]:36965 "EHLO
        mail-il1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728051AbgBYSzQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 25 Feb 2020 13:55:16 -0500
Received: by mail-il1-f172.google.com with SMTP id v13so115679iln.4
        for <io-uring@vger.kernel.org>; Tue, 25 Feb 2020 10:55:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=xFiwD6W4pffPMEC91vNu4ohAIbsNI8GSrTw4huICYec=;
        b=BhU8o5FUikJyZz0tZlFgpHUaBjvK6xZDSkHLj6tqqo0nxKA3S28DLVTFxtRCg5TZNw
         50LiW2n4Lan/fWwCXfZFMeBBvi83c5bGCkDUR+HIwfMRCpWJWewMuf4rC7pcixhS2CkZ
         BzADQJfSg5b5Sh5X2vbVwohwpPDsofQdYxPosuWrP8sPrpO2fxo3rdXcyK9KxkxPMZJB
         jLf/a/QaD1KHDqwZAfHe2yGmTTprPXQG40EohelxD/oiW+mLBIMno7Zyy6ft0yrEkCED
         /Miqlq51M4csQ74PPNdAkXq/nESpjz+osJwcnbqVnjrsc8nIt+rfFMAh6Nnh/XICiJhe
         DQ5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=xFiwD6W4pffPMEC91vNu4ohAIbsNI8GSrTw4huICYec=;
        b=EawmWsjNUYLeXUhq1kS6AmnutjI8/NizDANGYey68XaEslWPVlFssOhmRWMuSXSYNr
         vJV/oRvi8KysFh1BjzbIYMy+arr5z70iZTtOvvcKImkf3yMg0sCC9disIpS57syctYOj
         MpAufxeibMzDQwEjDVWoEjwHPdj7Zg0jkzrwxB2zFr3alxaR1DG72Zbroo04MP4Ce51S
         3qgeS94bOCwat6mYHLVsXrdFUSHuAUJUbK0D+WBnGx27SAYNvQQ1R/fEvYpIaBlxNOYK
         sZFdrlIQrjFIarRfeeMgNUtLqCJSHmr0s6I+ENEhu2TYkYws7GG9SJpwcVnMICAETsUG
         PMvA==
X-Gm-Message-State: APjAAAVZeV9eB+u32bllFhtECMOrd53+LX2RIvA0k/eTUxeY4lB37R1K
        98Tcb+AZZALtxkyKDsNqWw5l8yAnQ9s=
X-Google-Smtp-Source: APXvYqyJ7gxWSBY/Re1kBd/m61v+X0jz1mgwGjyGblzFKSesVk8iZ0fmszOOmBg+6gwVuhOk5jXgAA==
X-Received: by 2002:a92:5e9b:: with SMTP id f27mr27219ilg.263.1582656915440;
        Tue, 25 Feb 2020 10:55:15 -0800 (PST)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id v5sm5759849ilg.73.2020.02.25.10.55.14
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Feb 2020 10:55:15 -0800 (PST)
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io-wq: ensure work->task_pid is cleared on init
Message-ID: <c3ae0a5d-0557-cdaf-b38e-9d47605c2347@kernel.dk>
Date:   Tue, 25 Feb 2020 11:55:11 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We use ->task_pid for exit cancellation, but we need to ensure it's
cleared to zero for io_req_work_grab_env() to do the right thing.

Fixes: 36282881a795 ("io-wq: add io_wq_cancel_pid() to cancel based on a specific pid")
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/fs/io-wq.h b/fs/io-wq.h
index ccc7d84af57d..9e9419c08bc1 100644
--- a/fs/io-wq.h
+++ b/fs/io-wq.h
@@ -88,6 +88,7 @@ struct io_wq_work {
 		(work)->creds = NULL;			\
 		(work)->fs = NULL;			\
 		(work)->flags = 0;			\
+		(work)->task_pid = 0;			\
 	} while (0)					\
 
 typedef void (get_work_fn)(struct io_wq_work *);

-- 
Jens Axboe

