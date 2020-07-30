Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAFB223391C
	for <lists+io-uring@lfdr.de>; Thu, 30 Jul 2020 21:34:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726746AbgG3Tev (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 30 Jul 2020 15:34:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730434AbgG3Ter (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 30 Jul 2020 15:34:47 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6C0AC06174A
        for <io-uring@vger.kernel.org>; Thu, 30 Jul 2020 12:34:47 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id e64so29408463iof.12
        for <io-uring@vger.kernel.org>; Thu, 30 Jul 2020 12:34:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=S2cxBjoQxqxK4peClB1baOHSFoZL+Yj5o/jId09Ervw=;
        b=yV0lYXoR+mqd/SzhhBLEqFe2z/OHz5ZaPxBuVNBV2Bu2Yc+gK98PiKbSSaxOA8fZQJ
         xPaW6ZYdYndj0dCUQlYGJUyuWi+TkvwoN1//Rt8BUkiJ9Jh0BKYPI+oztdDLbnRz7YeD
         qsuA7hhHZWiGed5zySaE9JpdPjc6IqaicExOpvsR72LlQVc9PmhSQPavwo/BKSwyZjMi
         Y5hy8hDT1HknicHEl2VvsRA4nbliyB5Zyz8MdmfFd5guleqQE3myjmV5ZqkYA5V4NXuN
         zCYfIq2BgDRWoQQ5jgWzaonHRDR7zf0hO/Q/XnNuQqhOFd8s8j4WwK6uMdeq+LBz7cMy
         QtXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=S2cxBjoQxqxK4peClB1baOHSFoZL+Yj5o/jId09Ervw=;
        b=g7DMB6df18Q+3RXBBseFYZnkVzPPpho9VNY5vtpytdwJ2Lta9MtHZ5k4F1j0t+rE5z
         77aRUVZLQWliMC925roHRcoKpvGPggZBM6S0kVu5lZXxycR1tY0/EkFPmtJjgbW43GUw
         OMzU1qiHpjj9c5Xjl5x8p49xWHai41vLow4ydOkK1rLKqxUa3B/SUAp5m+iHv2dToJ0q
         q7l/LLW5hHSgZv8CLBNgbpJeE4S9SE+QpEXLEoZyasSCzkyU/jMKW9h09l/foePM6d9H
         u4Cz2gM8yjYc7oiagt87xV4c+VxRXaybZWDKcA4Z2fLmebopXwkyhXDkq7r3xAq+IA8h
         bp4Q==
X-Gm-Message-State: AOAM530uDL/g4m+OWEwpQI9ZPTJKrhmUQC/ESMee+oenNEQJTa8+aZ27
        PVIXFvhxqPfT5t227xkd3vDNzQ==
X-Google-Smtp-Source: ABdhPJyGX3EoUChA60mN8Z9VraISoHTk8hPnjL2b4aDG0Dd5gnLyRZYKRdS5SjnJFFEHslJH4WODZQ==
X-Received: by 2002:a5e:980f:: with SMTP id s15mr132306ioj.5.1596137686835;
        Thu, 30 Jul 2020 12:34:46 -0700 (PDT)
Received: from [192.168.1.58] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id 142sm3466284ilc.40.2020.07.30.12.34.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Jul 2020 12:34:46 -0700 (PDT)
Subject: Re: KASAN: use-after-free Read in io_uring_setup (2)
To:     syzbot <syzbot+9d46305e76057f30c74e@syzkaller.appspotmail.com>,
        io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        viro@zeniv.linux.org.uk
References: <000000000000a3709905abad9335@google.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <fcb86aa5-3b91-bf85-7d3a-8ca2a60e05d9@kernel.dk>
Date:   Thu, 30 Jul 2020 13:34:45 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <000000000000a3709905abad9335@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/30/20 1:21 PM, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    04b45717 Add linux-next specific files for 20200729
> git tree:       linux-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=173774b8900000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=ec68f65b459f1ed
> dashboard link: https://syzkaller.appspot.com/bug?extid=9d46305e76057f30c74e
> compiler:       gcc (GCC) 10.1.0-syz 20200507
> 
> Unfortunately, I don't have any reproducer for this issue yet.
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+9d46305e76057f30c74e@syzkaller.appspotmail.com
> 
> ==================================================================
> BUG: KASAN: use-after-free in io_account_mem fs/io_uring.c:7397 [inline]
> BUG: KASAN: use-after-free in io_uring_create fs/io_uring.c:8369 [inline]
> BUG: KASAN: use-after-free in io_uring_setup+0x2797/0x2910 fs/io_uring.c:8400
> Read of size 1 at addr ffff888087a41044 by task syz-executor.5/18145

Quick guess would be that the ring is closed in a race before we do the
accounting. The below should fix that, by ensuring that we account the
memory before we install the fd.

diff --git a/fs/io_uring.c b/fs/io_uring.c
index fabf0b692384..eb99994de5e2 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8329,6 +8329,11 @@ static int io_uring_create(unsigned entries, struct io_uring_params *p,
 		ret = -EFAULT;
 		goto err;
 	}
+
+	io_account_mem(ctx, ring_pages(p->sq_entries, p->cq_entries),
+		       ACCT_LOCKED);
+	ctx->limit_mem = limit_mem;
+
 	/*
 	 * Install ring fd as the very last thing, so we don't risk someone
 	 * having closed it before we finish setup
@@ -8338,9 +8343,6 @@ static int io_uring_create(unsigned entries, struct io_uring_params *p,
 		goto err;
 
 	trace_io_uring_create(ret, ctx, p->sq_entries, p->cq_entries, p->flags);
-	io_account_mem(ctx, ring_pages(p->sq_entries, p->cq_entries),
-		       ACCT_LOCKED);
-	ctx->limit_mem = limit_mem;
 	return ret;
 err:
 	io_ring_ctx_wait_and_kill(ctx);

-- 
Jens Axboe

