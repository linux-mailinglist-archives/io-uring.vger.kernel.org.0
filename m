Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E00C92B682A
	for <lists+io-uring@lfdr.de>; Tue, 17 Nov 2020 16:03:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729077AbgKQPCh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 17 Nov 2020 10:02:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729020AbgKQPCg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 17 Nov 2020 10:02:36 -0500
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A26AC0613CF
        for <io-uring@vger.kernel.org>; Tue, 17 Nov 2020 07:02:35 -0800 (PST)
Received: by mail-il1-x130.google.com with SMTP id x18so4920296ilq.4
        for <io-uring@vger.kernel.org>; Tue, 17 Nov 2020 07:02:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=USEZy0yeFz15cyAvdoj/wM1NOcO7VFx1mjGtJ4PlWeI=;
        b=EqMLmIWhEzBaTbFR9qZRdnUG6sRePRKeGiCNMOKQFuazflAx/ydAa9a92h+WKVP/Xa
         bwW26oH3qq5TMkOZe7Q/Zx7+ARi62F7v2rfpnhUi2V5G2HWkGIwcpaM4BzDPGcZAs3SH
         7Wk/+zIEllN2V/BW+Wwh4RtMa4YpQ+u2WsT+HaW9NoKIXHD9uEgJQRu1TjW/M6sadAdI
         Y8ZhZqWD2xM8L0xV5QJWCNbtmf4tLwPHckU3/p+11INfs7QFHmde2dcQgCq5DDbY0nRZ
         ZLcHBwy4vKPlWxWBqsZ8a7EM6Q735AfzFfLFFvZRHllnbkTFHWxNi2bSZvGHUBun02gO
         dkQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=USEZy0yeFz15cyAvdoj/wM1NOcO7VFx1mjGtJ4PlWeI=;
        b=oD0OYIu01sEeV9Dtl04Rml4oL7KxzL8LXzqIFL3xKa4FFWPKQWXq23gPp7kLiIB1ga
         usIgGD8ckuJFWYoV7GJosjIRJpqGSLPSN5zWJAUcLq61JmHkMuTegAd4lxfhkpWQILQf
         /hxIy0VlnC24FyJvF8JvJb5wfnZ6f08kQntmZ3eIdTpEpu/aBWieA2rS3nvg5LgPyP0w
         G7FQz+loDgQfnVgxXSmF7H184ZJRLD8A2AwIbHMcoC9tJhhiNtT2yBGH9NkRjHNuKLvt
         UzKyqvmMXXNYbWm+JxNOIxWp9xqqlF62yuvtvK4KkjRBRBvSWjwPPcEyZ3ZdqVWNucFH
         JVMw==
X-Gm-Message-State: AOAM532sSYDlAJ4oaYlPDp2Catsa39nk4h8Fwaq9VDZJJJ5EXyTOcciK
        HVVniEIU7tSUJSQyH3uVahnT/OrtOk/Q5w==
X-Google-Smtp-Source: ABdhPJwnq83JJpppA4bIC9pmzyLn2JVCORIklIq8Fazn6y3X1+TKt8INBljq80iuKrtzQaS0E/52vQ==
X-Received: by 2002:a92:3210:: with SMTP id z16mr11507628ile.159.1605625353903;
        Tue, 17 Nov 2020 07:02:33 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id t16sm13411197ilh.76.2020.11.17.07.02.33
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Nov 2020 07:02:33 -0800 (PST)
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: don't double complete failed reissue request
Message-ID: <048d9d23-76b6-5a59-f682-2dff3e668da9@kernel.dk>
Date:   Tue, 17 Nov 2020 08:02:32 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Zorro reports that an xfstest test case is failing, and it turns out that
for the reissue path we can potentially issue a double completion on the
request for the failure path. There's an issue around the retry as well,
but for now, at least just make sure that we handle the error path
correctly.

Reported-by: Zorro Lang <zlang@redhat.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/fs/io_uring.c b/fs/io_uring.c
index f05978a74ce1..b205c1df3f74 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2578,7 +2578,6 @@ static bool io_resubmit_prep(struct io_kiocb *req, int error)
 	}
 end_req:
 	req_set_fail_links(req);
-	io_req_complete(req, ret);
 	return false;
 }
 #endif

-- 
Jens Axboe

