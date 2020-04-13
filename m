Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (unknown [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B48C1A61B3
	for <lists+io-uring@lfdr.de>; Mon, 13 Apr 2020 05:16:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728513AbgDMDQY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 12 Apr 2020 23:16:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.18]:48206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728460AbgDMDQY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 12 Apr 2020 23:16:24 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0693AC0A3BE0
        for <io-uring@vger.kernel.org>; Sun, 12 Apr 2020 20:16:25 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id r20so2276695pfh.9
        for <io-uring@vger.kernel.org>; Sun, 12 Apr 2020 20:16:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=8bEzcUDDaCSykXkp2rnmE8KpSpfoLOOKVmfgPSqGehk=;
        b=Jlv0YrgWFsHLHGXyG9khYpXY76rrUJZOxeo/dFknQUfGHAG+cJvFJXtJBA7j2ET8R3
         Ffmz1LAyK3zhVH4/LmFtyIie/q/pvsReMZLfuRk5gLBXbBjP+3VjYT9AfXoo6Eb45CIQ
         A0D602R6HzxY9BWIzbqBe1eR6ccmhohidr90JFjzWBni/fUfSzNMBLwXkY/jpKXUe7LD
         TwzaNaLfQJeTQ/L+z/Ylxj+6KkkWWQ7TI5F3DVSqB3ewtKAaR2sx5e6Q/sugRzFdmNck
         g8Rd4eF/iHtgmD5l36HziiD+1mjO8gGIjWdtGU/2WFlgUj8NKFgcWwfgJXc8h4x+7evT
         2FQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=8bEzcUDDaCSykXkp2rnmE8KpSpfoLOOKVmfgPSqGehk=;
        b=gyta5kdtcLVp0vHjVWReEwKVCt3AdlWzlAMmhXURMr68D2AO/7/WwYY+NLTzLEggLs
         s7NQBTWg/fH+nDnOD4fw4+GavAGHPUooQs4Y4iIa4atM/I3Upf8B8foljax3REJW2IL/
         m3tQOYMtheBliG7C2HQJsaRDORx1y/kWm5AOzEwBk+i2ABGNm4W0k4XCUjYf5BKO0cWo
         Ad8iOPsGMhpLfc57J84PIPMKnAA3ehI96GPMxgAcHsfWRwuCiVJpvXwQqHuxdSAVtMd7
         dnLvAN44iz8s5yCDWMB5jCxghQX2Dyb5XuntXPww9BaZ/IbnWtm3M/TtzeYq1dFKL0tt
         9xRA==
X-Gm-Message-State: AGi0PuZrOqdd+Te7T+f2jRizrR5Ftusfj5ujOijsK2ArybjgspBdWqF2
        JXyMKgotp25xhDADseOHgeh78Q==
X-Google-Smtp-Source: APiQypKSjHRMHt+SryyfL6mqhvcmremQ1H2+o9gWFbGeqVvfml3qtdF2o/ApiKVJBZToxNbLJlUcYg==
X-Received: by 2002:a63:9355:: with SMTP id w21mr15825997pgm.424.1586747783473;
        Sun, 12 Apr 2020 20:16:23 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id a22sm976852pga.28.2020.04.12.20.16.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 12 Apr 2020 20:16:22 -0700 (PDT)
To:     io-uring <io-uring@vger.kernel.org>
Cc:     Pavel Begunkov <asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: correct O_NONBLOCK check for splice punt
Message-ID: <947c5026-cfa3-5a48-701c-28e46ac061bf@kernel.dk>
Date:   Sun, 12 Apr 2020 21:16:21 -0600
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

The splice file punt check uses file->f_mode to check for O_NONBLOCK,
but it should be checking file->f_flags. This leads to punting even
for files that have O_NONBLOCK set, which isn't necessary. This equates
to checking for FMODE_PATH, which will never be set on the fd in
question.

Fixes: 7d67af2c0134 ("io_uring: add splice(2) support")
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 68a678a0056b..0d1b5d5f1251 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2763,7 +2763,7 @@ static bool io_splice_punt(struct file *file)
 		return false;
 	if (!io_file_supports_async(file))
 		return true;
-	return !(file->f_mode & O_NONBLOCK);
+	return !(file->f_flags & O_NONBLOCK);
 }
 
 static int io_splice(struct io_kiocb *req, bool force_nonblock)

-- 
Jens Axboe

