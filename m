Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B1107ACB91
	for <lists+io-uring@lfdr.de>; Sun, 24 Sep 2023 21:16:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229591AbjIXTQr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 24 Sep 2023 15:16:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjIXTQq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 24 Sep 2023 15:16:46 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE8A1FC
        for <io-uring@vger.kernel.org>; Sun, 24 Sep 2023 12:16:39 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id 5b1f17b1804b1-40506bfca64so17472265e9.0
        for <io-uring@vger.kernel.org>; Sun, 24 Sep 2023 12:16:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1695582998; x=1696187798; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NK5cn1/xmIIHPiXYY/HJsi658tn2gfxhEpi1T1hoO/o=;
        b=QwNTeEcsS+8lTRbF9xsx4hUO1/gxJxfjld1IR04phbiRiqULyRO33vSSghbwY47F+h
         87t4nbjw3XoNpOQbEI9M0Rr2CyK4n9n7DmYqmx7qakZ6QHbJ2cm2X9Rzow8mKuk+/3O2
         wHuPL43bD8t0LECy0PJbX9nvytbg82mJHUfMrTsiCCM7sSY4rzBcBZle7VSkgnAgGiVk
         fVS+N+35nDWfgQ5sBdnlI+1kKYX8bJd2ZThdHj2q14vrB7V9nIXfsUg00XRMFKxA6h1h
         Dc5ymzzCsTCP5aSSfCRTqG7T+7DFY9j4zlgTHkjFPOv1Xy+s2Dh30qYMgg5YNFM3dc+B
         XZ/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695582998; x=1696187798;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NK5cn1/xmIIHPiXYY/HJsi658tn2gfxhEpi1T1hoO/o=;
        b=pLM9AiPpX/eEmZ5OTzsdmWmXdeRsnDsRbqbGDi7Z57cpCG3efbkdImxC6Qbv2Y/qOW
         NJHfXJuQn4WzwFaO2crrNdGD5CGQAojYGSp/O7j7anYgHjiFcLtMzFBwjhHucSj4c8Bu
         +/1kz6J0i7f5ZkgDCW1kdlB/p7xVd1A+wju6SMnukFC74suWPzE0F5HO424I1JA+sYJB
         2c7kbKsBehO61u9qIjXldRBDkqYwsMYb4XXobW5Jno6lni7Ee/ThkpgFfLwGuLZoABct
         rhTOIRVAk0x720hHmPGlpuSep1ubAkw4VdRmgEP7NkRxGu3uviKlgKQJEUrtarsdSddB
         EngA==
X-Gm-Message-State: AOJu0YyX/JJKiF+11OcA4F9L26BkpIHk+icoh5Oj08awhcrV9VYiczMn
        ITvFwJo5zZ8uKMUGKHkUBCvd2AaZhmIf7V5PfjbKLBKo
X-Google-Smtp-Source: AGHT+IGxhoMYvyCe0mBOK4yZ7dAhMAk0MKDCDCAPi0AzlMpEBEbQC5MHIvwOJzzY7sF+3HYqWyUykg==
X-Received: by 2002:a05:600c:5107:b0:3fe:21a6:a18 with SMTP id o7-20020a05600c510700b003fe21a60a18mr4242979wms.3.1695582998198;
        Sun, 24 Sep 2023 12:16:38 -0700 (PDT)
Received: from [172.20.13.88] ([45.147.210.162])
        by smtp.gmail.com with ESMTPSA id z9-20020a05600c114900b004058e6379d8sm1607939wmz.23.2023.09.24.12.16.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 24 Sep 2023 12:16:37 -0700 (PDT)
Message-ID: <0efd39ee-5eb0-43a6-9b4f-51b819ab19a8@kernel.dk>
Date:   Sun, 24 Sep 2023 13:16:36 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [xfstests generic/617] fsx io_uring dio starts to fail on
 overlayfs since v6.6-rc1
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
To:     Zorro Lang <zlang@redhat.com>, linux-unionfs@vger.kernel.org
Cc:     io-uring@vger.kernel.org, fstests@vger.kernel.org
References: <20230924142754.ejwsjen5pvyc32l4@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <02c1c68c-61a0-4d93-8619-971c0416b0e6@kernel.dk>
In-Reply-To: <02c1c68c-61a0-4d93-8619-971c0416b0e6@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/24/23 11:52 AM, Jens Axboe wrote:
> On 9/24/23 8:29 AM, Zorro Lang wrote:
>> Hi,
>>
>> The generic/617 of fstests is a test case does IO_URING soak direct-IO
>> fsx test, but recently (about from v6.6-rc1 to now) it always fails on
>> overlayfs as [1], no matter the underlying fs is ext4 or xfs. But it
>> never failed on overlay before, likes [2].
>>
>> So I thought it might be a regression of overlay or io-uring on current v6.6.
>> Please help to review, it's easy to reproduce. My system is Fedora-rawhide/RHEL-9,
>> with upstream mainline linux HEAD=dc912ba91b7e2fa74650a0fc22cccf0e0d50f371.
>> The generic/617.full output as [3].
> 
> It works without overlayfs - would be great if you could include how to
> reproduce this with overlayfs.

Try this. Certainly looks like this could be the issue, overlayfs is
copying the flags but it doesn't handle IOCB_DIO_CALLER_COMP. So it
either needs to handle that, or just disabled it. Seems like the latter
is the easier/saner solution here, which is what the below does.

diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
index 4193633c4c7a..d6c8ca64328b 100644
--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -410,7 +410,7 @@ static ssize_t ovl_write_iter(struct kiocb *iocb, struct iov_iter *iter)
 		real.flags = 0;
 		aio_req->orig_iocb = iocb;
 		kiocb_clone(&aio_req->iocb, iocb, get_file(real.file));
-		aio_req->iocb.ki_flags = ifl;
+		aio_req->iocb.ki_flags = ifl & ~IOCB_DIO_CALLER_COMP;
 		aio_req->iocb.ki_complete = ovl_aio_rw_complete;
 		refcount_set(&aio_req->ref, 2);
 		kiocb_start_write(&aio_req->iocb);

-- 
Jens Axboe

