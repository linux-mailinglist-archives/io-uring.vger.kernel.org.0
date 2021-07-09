Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C21463C25D8
	for <lists+io-uring@lfdr.de>; Fri,  9 Jul 2021 16:24:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229561AbhGIO1B (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 9 Jul 2021 10:27:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbhGIO1A (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 9 Jul 2021 10:27:00 -0400
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BCB9C0613DD
        for <io-uring@vger.kernel.org>; Fri,  9 Jul 2021 07:24:17 -0700 (PDT)
Received: by mail-io1-xd2d.google.com with SMTP id d9so12580720ioo.2
        for <io-uring@vger.kernel.org>; Fri, 09 Jul 2021 07:24:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=W89R1F3lmFIEh6J0k0hyHEUv5nTnWAPkyMFIHtBnhfo=;
        b=p9sKBuyGCheNt+HUBypyhlH3M4+3lM6YbKE52U2apTBemdNiugWiDaRlVwf5CYz41k
         1N7w9zXKqBprKGD7y841eM4cnr6k3QYl8JfMuA+bEdnoUYbbN30p1RliVBbTSgzkdX9c
         UvCB5Iv1iNYOXBw3zDoBnmOMlLWbgQi2/luFb/JW3jv2ZeGD0SRGdId9YgbcYC7sx5aV
         Br+2/jLG9IjBRrmvj644mEcstjQmbefIPh+VK+8Fpf5IPJEbm9jHjScr8TAtkq0i7LB7
         H29ACDCnWEDtyRdlosBfYdKlv1gTIuBV6DW60rf57PuSH8VOWxheGpYimDx0iFu8GTzR
         NHqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=W89R1F3lmFIEh6J0k0hyHEUv5nTnWAPkyMFIHtBnhfo=;
        b=Gjv6RxZR4idB+te3bHG5rR6H4XY5LeJpcptI4KtFGzJIMN6AtTtaN5uveKiMfjn5PC
         Eeu56Uw6cG9jXBBWZ3fkrY08j/aDiKJZCfp0KEiDP8vyoJ0gCFozRV/N4LmEiTvRRXeD
         485DzZSmKkqNmq8gxIpk0H7EIJWld+HudIJYfXlBheLbzprXd8GRuBAMzK4yLHSBx7qN
         NOdMoMBrUElNM1BhEPmPRS+OQHRBHbNVsfJ77wtH5TbxriVxouS78reYCCzsXr1H31jI
         Nau16nQGB5BPAHPZxkY7mlgM5ONuAwRN+cDtL1FWCIOcyFxIp3lPXTl7wK3aRAnsINVr
         zrBw==
X-Gm-Message-State: AOAM533D049lEpMjEJMCyEWIPrXgAFtWnoYoJzFwW8oeICX5151hM7Xx
        29XGNkyUmtqak3Q0BPjVCWqcRg==
X-Google-Smtp-Source: ABdhPJxdWAd/lxVQzlvUbOdcXXjolChwecZ22Lfe0VFBNooRpg2t6L1YPpW3U5jbQ2ZcSBsPd+FSlw==
X-Received: by 2002:a02:2b21:: with SMTP id h33mr15142749jaa.31.1625840656722;
        Fri, 09 Jul 2021 07:24:16 -0700 (PDT)
Received: from [192.168.1.134] ([198.8.77.61])
        by smtp.gmail.com with ESMTPSA id a6sm2902820ili.21.2021.07.09.07.24.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Jul 2021 07:24:16 -0700 (PDT)
To:     io-uring <io-uring@vger.kernel.org>
Cc:     Colin King <colin.king@canonical.com>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: remove dead non-zero 'poll' check
Message-ID: <b8001f35-ffe1-26df-85aa-0b40f8907e0e@kernel.dk>
Date:   Fri, 9 Jul 2021 08:24:14 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Colin reports that Coverity complains about checking for poll being
non-zero after having dereferenced it multiple times. This is a valid
complaint, and actually a leftover from back when this code was based
on the aio poll code.

Kill the redundant check.

Link: https://lore.kernel.org/io-uring/fe70c532-e2a7-3722-58a1-0fa4e5c5ff2c@canonical.com/
Reported-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 7167c61c6d1b..d94fb5835a20 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4956,7 +4956,7 @@ static int io_poll_double_wake(struct wait_queue_entry *wait, unsigned mode,
 
 	list_del_init(&wait->entry);
 
-	if (poll && poll->head) {
+	if (poll->head) {
 		bool done;
 
 		spin_lock(&poll->head->lock);

-- 
Jens Axboe

