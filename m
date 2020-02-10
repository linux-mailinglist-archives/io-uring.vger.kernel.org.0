Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BA34157E7F
	for <lists+io-uring@lfdr.de>; Mon, 10 Feb 2020 16:12:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727604AbgBJPMV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 10 Feb 2020 10:12:21 -0500
Received: from mail-il1-f172.google.com ([209.85.166.172]:41086 "EHLO
        mail-il1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727347AbgBJPMV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 10 Feb 2020 10:12:21 -0500
Received: by mail-il1-f172.google.com with SMTP id f10so481363ils.8
        for <io-uring@vger.kernel.org>; Mon, 10 Feb 2020 07:12:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=DC2+sdPWNWPxzMc7onDS1Inn0CO1O4agtwuAZa01kog=;
        b=zyK1UAW19vxIcCDZnAWfRwgF3nag7wKwYX94tTZAOzIDC/GurYAVQqyvmt7JhbFH2j
         oFksCRiq5vM1/ARjnWLrg1oxLJGsumOM+AM/047amb9vlBVp9y0s19OZWVf5qA75Pjd8
         88F573jK/WOQXkVumx9Z7kZlpmJqbJRtE95guQ6dM3xuKD3zvm7D5K4RTLiAdjLub/+a
         I1BESeC93N98dfTxywuG/DhCVuLapcS81S95Vw2mrHyucUD0RHdSYyjiDsEg4Ojg0tHm
         UQ7/yDXxJ74916pIWoIPBcYcDu0cnCMsjiY6txIzKD/3lUvzTsyIUG/d0U/OEl9zoS53
         0c+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=DC2+sdPWNWPxzMc7onDS1Inn0CO1O4agtwuAZa01kog=;
        b=Z79mscJCLLjZzKxSDudu8xRjKBmn8TzdcjhnP8uZuT1fz5O1pDHyHMBbcnwQmqHzDs
         96bpeHPTA0Ydd7cBrK8VHT9FxNIupjRVIKwAKQejuCbQojJxVx1zEF0/RiamarNbkGjY
         if7zeElvL+/Jxojd7mQYq1/aWxXEyVFY3nPf09nKdzLAewfiDxET1J9ROzDCamho7ect
         wKDYlYiJaTX6hjk3217JJyduqhw4jekcpYViCwY76STBcTWSc9UNnpj2wCCk+jZKMIL0
         hCll5svrVrdKo6YEaBWS+jYo3bbkW67tJAmjtINHgFA2Ku6qzvSA/yeWhItQNEByue/a
         FRUQ==
X-Gm-Message-State: APjAAAXAdHuoWpTDwZAJjsNa7AEaQ5+jMY6DL8ao+g8n7xx3QFimuS2Q
        ogPlrJSgf8vkvK8p1ag6OI7WSdtw22M=
X-Google-Smtp-Source: APXvYqw3enAE9T8NDUPr1g3+qZ/9LN7BMN4fjvd32ydmynFW2rgUOZlUP5Daba8Sg8Qrr0cC7Vc4pQ==
X-Received: by 2002:a92:60f:: with SMTP id x15mr1768376ilg.181.1581347539332;
        Mon, 10 Feb 2020 07:12:19 -0800 (PST)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id j17sm124575ild.45.2020.02.10.07.12.18
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Feb 2020 07:12:18 -0800 (PST)
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: TODO list item - multiple poll waitqueues
Message-ID: <81c68aa5-1ea4-3378-58c2-4bb9c6d779ad@kernel.dk>
Date:   Mon, 10 Feb 2020 08:12:17 -0700
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

Hi,

This has been on my TODO list for a while, just haven't gotten around to
it.

The issue is that some drivers use multiple waitqueues for poll, which
doesn't work with POLL_ADD. io_poll_queue_proc() checks for this and
fails it:

static void io_poll_queue_proc(struct file *file, struct wait_queue_head *head,
			       struct poll_table_struct *p)
{
	struct io_poll_table *pt = container_of(p, struct io_poll_table, pt);

	if (unlikely(pt->req->poll.head)) {
		pt->error = -EINVAL;
		return;
	}

	pt->error = 0;
	pt->req->poll.head = head;
	add_wait_queue(head, &pt->req->poll.wait);
}

since we just have the one waitqueue on the io_uring side. Most notably
affected are TTYs, I've also noticed that /dev/random does the same
thing, and recently pipes as well.

This is a problem for event handlers, in that not all file types work
reliably with POLL_ADD. Note that this also affects the aio poll
implementation, unsurprisingly.

If anyone has the inclination to look into this, that'd be great.

-- 
Jens Axboe

