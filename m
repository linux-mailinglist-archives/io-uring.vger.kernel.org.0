Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC5C0246EC6
	for <lists+io-uring@lfdr.de>; Mon, 17 Aug 2020 19:36:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729682AbgHQRg3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 17 Aug 2020 13:36:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729777AbgHQQRp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 17 Aug 2020 12:17:45 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E96CC061389
        for <io-uring@vger.kernel.org>; Mon, 17 Aug 2020 09:17:38 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id r4so7767910pls.2
        for <io-uring@vger.kernel.org>; Mon, 17 Aug 2020 09:17:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=PFgP2wR/mwXErQQXndAtSLvq6wligvkEEpkXQwDfmCA=;
        b=bWOZ/sqrswc9ts/yapH5l5Lbw1uoB3ShQMAFR6ktsJ9j3NuXIFzXaTRsNvriq7xFfE
         gPe8Ze4/D+3ohPO9lVUWY5S1CoG2FO+eBl406JcJDgHEZr2cN1jIPQnoZK5NqDpEbs6C
         1IwnMNfTM7Zuu/FuQ8dz55HdSP2EWbGqrI3ZfUvkcRU9ICNwRZSTexADnBGopSMGiJL7
         NdgPAgMPz5E8dtza5crxR7/i4gLFZl/I8OXvlKO3jvvTeSw+uEnyKiG3i5esh6ckdANb
         Ph79yuKoQ/PSB55f343FqJo59QDjP6RRENz7P6UKXv9vIh+HV69v3V9LNZU/w2DnxsHX
         Mifw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PFgP2wR/mwXErQQXndAtSLvq6wligvkEEpkXQwDfmCA=;
        b=GSbdRfCp6rB3itq4hB39feNeD97ve3y9ZfUIXI6naTc+5lMBYZShVN2niKY3B7a4mZ
         sG5T8QcBZnc5nb696Vper/dQXCG0KcW7lPrrN87oQDzN1v5Hq2J6bDgsyVmGwzL5xrk8
         +ph/Pn2iiBncO0Dbm2io61ihJID/EVgUIanx/tyNVSsaZ4EOenNk4Xa7VvNOXWheGoRu
         HQoYyxrcsxpWFKPLqqvtN4XnBBTDbqpBd+TpRJ/9aIYh89nSWb9OP7+F7EwLg6Vp1HTN
         BQlDZLRimSM5cHRkGwpaIcodm3KFKQTVAtuMQF1r2ZWe225DJti9T/3JejOYeWrxzyjT
         LPnw==
X-Gm-Message-State: AOAM530mNV39RFqQ6vTmxJCzXnnAloY/4ppGHsBoxfRaRUl7NqvhrjA4
        WU+3NhbbyBChc4kVL4A9vT3aEhc/SMbLxaFy
X-Google-Smtp-Source: ABdhPJxRr55QhOdtn/mtJdVUGinXCsbnAYUF1F0tn4y4mHi7ticLXa0Ig9bqLC6El9hPaCFK2YreEQ==
X-Received: by 2002:a17:90a:1d0f:: with SMTP id c15mr13558718pjd.180.1597681057249;
        Mon, 17 Aug 2020 09:17:37 -0700 (PDT)
Received: from ?IPv6:2605:e000:100e:8c61:ff2c:a74f:a461:daa2? ([2605:e000:100e:8c61:ff2c:a74f:a461:daa2])
        by smtp.gmail.com with ESMTPSA id y1sm21873994pfr.207.2020.08.17.09.17.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Aug 2020 09:17:36 -0700 (PDT)
Subject: Re: Very low write throughput on file opened with O_SYNC/O_DSYNC
To:     Dmitry Shulyak <yashulyak@gmail.com>
Cc:     io-uring@vger.kernel.org
References: <CAF-ewDrOHDxpSAm8Or37m-k5K4u+b3H2YwnA-KpkFuVa+1vBOw@mail.gmail.com>
 <477c2759-19c1-1cb8-af4c-33f87f7393d7@kernel.dk>
 <CAF-ewDp5i0MmY8Xw6XZDZZTJu_12EH9BuAFC59pEdhhp57c0dQ@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <004a0e61-80a5-cba1-0894-1331686fcd1a@kernel.dk>
Date:   Mon, 17 Aug 2020 09:17:35 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAF-ewDp5i0MmY8Xw6XZDZZTJu_12EH9BuAFC59pEdhhp57c0dQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/17/20 8:49 AM, Dmitry Shulyak wrote:
> With 48 threads i am getting 200 mb/s, about the same with 48 separate
> uring instances.
> With single uring instance (or with shared pool) - 60 mb/s.
> fs - ext4, device - ssd.

You could try something like this kernel addition:

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 4b102d9ad846..8909a1d37801 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1152,7 +1152,7 @@ static void io_prep_async_work(struct io_kiocb *req)
 	io_req_init_async(req);
 
 	if (req->flags & REQ_F_ISREG) {
-		if (def->hash_reg_file)
+		if (def->hash_reg_file && !(req->flags & REQ_F_FORCE_ASYNC))
 			io_wq_hash_work(&req->work, file_inode(req->file));
 	} else {
 		if (def->unbound_nonreg_file)

and then set IOSQE_IO_ASYNC on your writes. That'll parallelize them in
terms of execution.

-- 
Jens Axboe

