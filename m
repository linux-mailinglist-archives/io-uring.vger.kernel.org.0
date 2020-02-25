Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D039C16F008
	for <lists+io-uring@lfdr.de>; Tue, 25 Feb 2020 21:27:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731780AbgBYU1W (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 25 Feb 2020 15:27:22 -0500
Received: from mail-io1-f49.google.com ([209.85.166.49]:37688 "EHLO
        mail-io1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731779AbgBYU1V (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 25 Feb 2020 15:27:21 -0500
Received: by mail-io1-f49.google.com with SMTP id c17so762218ioc.4
        for <io-uring@vger.kernel.org>; Tue, 25 Feb 2020 12:27:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=fAtT4L4U7oomgy/BzItygR3kXhB+kb2WttLTcrOLhVY=;
        b=doQjkw8YvvEHlsMbXUvrxoCYyhS+KL7vrqaDGzPre7HUmDJzo9NJMYxIutBeRH0/nn
         NNGxih5wPpDKDRMn/YgCqScDOsEiRYVZXjjKrWNfqvSyZkF+BKcPbqBMmP6iJlFPWH07
         4de0ctX1mu6YTdO/i6igUgtuQyKOQ1DmezFEMDFz/ef5Z2chYGU556tsQU5Gx7RRrpOx
         1TVLjKX2qOlIkrYxRlb03w7/oZrHGzB6zDiVQfQjSa6x4nBQHJg/jRuIii+9BVeXivsE
         0Htq0vQ1pI9FjyMDZivim85bmSET04b6AHn4eNZVx2d8ui8BYK0qIPCIs98w+GcEWgDr
         162w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=fAtT4L4U7oomgy/BzItygR3kXhB+kb2WttLTcrOLhVY=;
        b=VVrqYkFrYFCoG/nZn4Mj7Xed8aJGPXdiPQrIynMPRqRAucQw3UedHSmYZIxGXy4mql
         YrEeqHJoQr64U9hAXxps9UcsEnFMbu6sHRZ5tJC2n+jqnS9oI7ewh3cODqaealH1Y4nh
         ZZvcCghiqwg5CoH2odT0+IzPWabJL0EXe6m9VJPoecnFd52ldtpVAtSX6I3MA3LnNj45
         gf7VxOuxdtiBWim+uaoaWMeeAsDeVKMU5VQNyP0+etRrQLUqB0mRz9WAP6WwlOpMlGdE
         wLTkEoKKTSRX8GLeg30i7smv7qX6+Vt6N8/Xbs1m9wQHb/pbSZsUQvCWZr1X/TIOx46f
         q7HA==
X-Gm-Message-State: APjAAAWI9BRlfo1DEDuZtMlM6IvtiEBK9PzxJVty6j8edcVD2sRu7/pt
        uNAucADMXYCuJNleWo0O9RHto3FVvMw=
X-Google-Smtp-Source: APXvYqzTzLaML809lG4OwkMK1EOZbct6YSXtiYqHKwrIvX5U2w3rGRFimvoeUZ9V4gHGLDEHtqKXAg==
X-Received: by 2002:a6b:e506:: with SMTP id y6mr670994ioc.209.1582662440636;
        Tue, 25 Feb 2020 12:27:20 -0800 (PST)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id z8sm5820208ilk.9.2020.02.25.12.27.20
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Feb 2020 12:27:20 -0800 (PST)
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: pick up link work on submit reference drop
Message-ID: <1c5f074e-22dd-095a-6be7-730c81eeb1b1@kernel.dk>
Date:   Tue, 25 Feb 2020 13:27:19 -0700
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

If work completes inline, then we should pick up a dependent link item
in __io_queue_sqe() as well. If we don't do so, we're forced to go async
with that item, which is suboptimal.

Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/fs/io_uring.c b/fs/io_uring.c
index ffd9bfa84d86..160cf1b0f478 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4531,8 +4531,15 @@ static void io_wq_submit_work(struct io_wq_work **workptr)
 		} while (1);
 	}
 
-	/* drop submission reference */
-	io_put_req(req);
+	/*
+	 * Drop submission reference. In case the handler already dropped the
+	 * completion reference, then it didn't pick up any potential link
+	 * work. If 'nxt' isn't set, try and do that here.
+	 */
+	if (nxt)
+		io_put_req(req);
+	else
+		io_put_req_find_next(req, &nxt);
 
 	if (ret) {
 		req_set_fail_links(req);

-- 
Jens Axboe

