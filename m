Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E1FF4199CB
	for <lists+io-uring@lfdr.de>; Mon, 27 Sep 2021 18:58:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235404AbhI0Q7n (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 27 Sep 2021 12:59:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235316AbhI0Q7n (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 27 Sep 2021 12:59:43 -0400
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15264C061575
        for <io-uring@vger.kernel.org>; Mon, 27 Sep 2021 09:58:05 -0700 (PDT)
Received: by mail-io1-xd35.google.com with SMTP id y197so23606701iof.11
        for <io-uring@vger.kernel.org>; Mon, 27 Sep 2021 09:58:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=xVNePkrZp1xQKdsfYwtovOw8m9ChxhYfitubKiPN7iA=;
        b=twBAu0AH731zGE/k0jpPz32EhuCDzveSn68SZ9LP/Mry2K0ox0rPMbN/VaRFbtIXXv
         x78J83ZZMo2U3ms20wqx4uNnxDXAvEvEGRItDUvZrSk+BelC/8cjVTscpArl1Mx9fks3
         nXB97OM9Hph5UHyB9JscA31XSpdqoHp2Cs7rE1fc7Uhdfk7R5X4GsH8GNthlV4CRfwKK
         6kDph6ywcCXExDqcC0Lw6R3XrGGNLtJo/K8sO8RSCF6q7pf3CMFPHxHQxv3EMKiZY1Cv
         i/wqjYvc3VpIAxR2QkSziW+SERoMqA+ooshcxAoVwlPqNENJPE/bPvHrlbensYlp0WcK
         eLuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=xVNePkrZp1xQKdsfYwtovOw8m9ChxhYfitubKiPN7iA=;
        b=V+CCRiAduy3mvj9MHrrjPQtxGFVN6e0WNSiTg3C7+nF00AFhwjP7oL/jXlIQ91ce15
         2bnq20Zzn628mbTjgldthE/pOyrgSvZDUkA65cUH64BXn/LgG/94Pj/ur9cO4deYLS54
         Vk599GaYaonhdmlOCv7Vq33TRJKqSfpvLG+xmIoDONSNWX8MPfvEW0qAjB/JWTFHDIu0
         uvqez+nyGLj6XJGZYN4u/jf/BudPWVq3FUlTz65w0OXqT2182Pq1AVIBdZ+0NCJW+HuP
         O7aKM8APsflTvtmXMyMRgeyGE+2FySVBVLFefC2aTQodfM76aiXCWO7Vhi7uIBn3CLPV
         vsxw==
X-Gm-Message-State: AOAM5311wU38dQ1PAiUTdB+96QelL9te1q8xJb5cEtzSxc/AmYcouo6c
        ZStghYFTzvSZVmkoGYIZWkCS6A==
X-Google-Smtp-Source: ABdhPJx+CJGPKz3/Gw78rkjBJ6e107vqNPh7bXOesRjUE70Uxz/zZIhLVOeShDjbUuH//Oio+aNjIQ==
X-Received: by 2002:a6b:5106:: with SMTP id f6mr534706iob.116.1632761884368;
        Mon, 27 Sep 2021 09:58:04 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id f21sm8940578iox.38.2021.09.27.09.58.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Sep 2021 09:58:03 -0700 (PDT)
To:     io-uring <io-uring@vger.kernel.org>
Cc:     "Eric W. Biederman" <ebiederm@xmission.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io-wq: exclusively gate signal based exit on get_signal()
 return
Message-ID: <8b218623-7ce8-cef0-9f70-2e5aa2aeb70d@kernel.dk>
Date:   Mon, 27 Sep 2021 10:58:03 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io-wq threads block all signals, except SIGKILL and SIGSTOP. We should not
need any extra checking of signal_pending or fatal_signal_pending, rely
exclusively on whether or not get_signal() tells us to exit.

The original debugging of this issue led to the false positive that we
were exiting on non-fatal signals, but that is not the case. The issue
was around races with nr_workers accounting.

Fixes: 87c169665578 ("io-wq: ensure we exit if thread group is exiting")
Fixes: 15e20db2e0ce ("io-wq: only exit on fatal signals")
Reported-by: Eric W. Biederman <ebiederm@xmission.com>
Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/fs/io-wq.c b/fs/io-wq.c
index c2360cdc403d..5bf8aa81715e 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -584,10 +584,7 @@ static int io_wqe_worker(void *data)
 
 			if (!get_signal(&ksig))
 				continue;
-			if (fatal_signal_pending(current) ||
-			    signal_group_exit(current->signal))
-				break;
-			continue;
+			break;
 		}
 		last_timeout = !ret;
 	}

-- 
Jens Axboe

