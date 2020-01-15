Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 890D313B8D2
	for <lists+io-uring@lfdr.de>; Wed, 15 Jan 2020 06:12:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725942AbgAOFLM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Jan 2020 00:11:12 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:40975 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725857AbgAOFLM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Jan 2020 00:11:12 -0500
Received: by mail-pl1-f196.google.com with SMTP id bd4so6329694plb.8
        for <io-uring@vger.kernel.org>; Tue, 14 Jan 2020 21:11:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=pw6MDcWJ0pS875gQUB6BW7r9AtIeSPd2Z4nXwTJoeK4=;
        b=AcT9u5qsyVt6js9XaR8UWJTtR1/lC+hMcDvQA2/FhTxdIHIKTC3p78AXRtBv9ZG3no
         WB85Ru3Ksah9j//zzfSfL4UzJde0ZUns4eqbWVbeVhgpeV793BTmxOQh1OvPhr+pb0Eb
         saJQiE8ucXT1oYled/gWlB/Nd8poMSTmgd2XbKPlFltP6BpYxpOcoQX2vG+bcFR5UZt9
         ES0hAiY4/jAuZVlYP14z/ennsyMJj/k7IsyjAfNk2tNJyD5FEuOeQ4U0Zfr5pMf9BC7h
         +ZeV4hbLNk7F2WGuBSVYb/k40g52udg60JZkIZF+iukaxP8RTmEOhVjmnqkr0l2OQrtF
         9FWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=pw6MDcWJ0pS875gQUB6BW7r9AtIeSPd2Z4nXwTJoeK4=;
        b=PfzvQd4+gD6j489BQZlMolMrEqZjBpUojxz7MSr1JLLp6Wzs2hI3oroGIiAVFLyBLT
         d9l0VZqNgUjdIymG3Xng70zX1AIYoaMBDs5xxpYnZpYIKUde3HZy+ME86JhXx9iAQ5mI
         eA7vSYiUKTsN0jtaaeiEWi67UxP1YIUyWbkRVIfPZtD/JukM9QEI6iGn6qEYil7LfgvJ
         Z5XOXruJynOPS9lx19fiR7iRjApUW+HvAPlODXlBNCYa6kUlU/YzQniYfCX86wBwZTZi
         Udu2//yBjhFDh0UzowzRQkdNt5JeEG2zgFqDckgSSPO0gT1lBPKmBGKIXdd6tiTcG78S
         Yyxg==
X-Gm-Message-State: APjAAAVGa5Fvj/Ay8QA6l2adPFkXUCAODJvG5WRcSOZtH0IkGj1t3i4g
        Bhz9JkIbJdXzmddI/MI+VT6sUHALkyQ=
X-Google-Smtp-Source: APXvYqy2/qSbJX1iSZ8LZopUFypHJe4x62k4K75KgioJEq5sltzaxr0fEYkBtutrxFSnmHTPT3JvMg==
X-Received: by 2002:a17:90a:e98d:: with SMTP id v13mr34309270pjy.89.1579065071317;
        Tue, 14 Jan 2020 21:11:11 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id 7sm20490555pfx.52.2020.01.14.21.11.09
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Jan 2020 21:11:10 -0800 (PST)
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io-wq: cancel work if we fail getting a mm reference
Message-ID: <654cbd24-d056-6f23-ceda-e2e77ea5650d@kernel.dk>
Date:   Tue, 14 Jan 2020 22:11:09 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

If we require mm and user context, mark the request for cancellation
if we fail to acquire the desired mm.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io-wq.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index 541c8a3e0bbb..5147d2213b01 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -445,10 +445,14 @@ static void io_worker_handle_work(struct io_worker *worker)
 			task_unlock(current);
 		}
 		if ((work->flags & IO_WQ_WORK_NEEDS_USER) && !worker->mm &&
-		    wq->mm && mmget_not_zero(wq->mm)) {
-			use_mm(wq->mm);
-			set_fs(USER_DS);
-			worker->mm = wq->mm;
+		    wq->mm) {
+			if (mmget_not_zero(wq->mm)) {
+				use_mm(wq->mm);
+				set_fs(USER_DS);
+				worker->mm = wq->mm;
+			} else {
+				work->flags |= IO_WQ_WORK_CANCEL;
+			}
 		}
 		if (!worker->creds)
 			worker->creds = override_creds(wq->creds);
-- 
2.25.0

-- 
Jens Axboe

