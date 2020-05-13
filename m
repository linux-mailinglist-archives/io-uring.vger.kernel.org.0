Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93A5F1D1E82
	for <lists+io-uring@lfdr.de>; Wed, 13 May 2020 21:04:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390206AbgEMTEf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 13 May 2020 15:04:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2390021AbgEMTEe (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 13 May 2020 15:04:34 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1C2CC061A0C
        for <io-uring@vger.kernel.org>; Wed, 13 May 2020 12:04:34 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id u5so163313pgn.5
        for <io-uring@vger.kernel.org>; Wed, 13 May 2020 12:04:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:references:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=Fjbes6VC2iWTd+ryGntivNrc1JAuEQiR1l7gNHyh0WI=;
        b=GMPuEOR4QfLTR8PXyjiJIel/W8HC8IdY9DIRrLhOUqvllM84iYHmhBV/ULeo/e8dsj
         b+Lsi98ZinwLuH5ZzkJZ8pcjkUq5i+PYOhO/VbJq07w0vNciCvUnBiJ9f/qvKI1fxmZs
         45+MiWsWFrJJhpQYakJwaLd7bt0WyC8m3yBBWPFPcVgwTEXG6HFfMfs2dk67deE96K16
         0GhNCwZn8bxDlbTiBEeMlKHUYH+J9K+xYcPFsKzZqoUi5dJCmbtx+BJssx7OaIlzSVlj
         wJz+IEI5RonG3efKU3raOGwkVx6fArNvl6xVZa2AaR/KpZIcEyE8aVB4siaCsg5tykQ+
         3qtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Fjbes6VC2iWTd+ryGntivNrc1JAuEQiR1l7gNHyh0WI=;
        b=Hb4LsWYUL7vAUOxkq87YYrJNAfm7nYxalpaF46DlhF6wN500S99gV0HWzu6PWBcT73
         wKUwKJ/0BT4xxeSmhtE1jjtJENH1ql4nujT7aEORq+9dt5EVS2tPaln4wgSD8S4Z4yLn
         8WBXmixiFcZPYV+jNSPi+Hn5uQaWs1bmzvV5/qSD5vZe34RzdOcZJvbc8HZEV2zZGBeh
         PmmjIzu2t9b49lf98hiK+0iUPtaphsFMoVuENB3a8dv6AqbP2WadDcR4KwB14mKkOLiX
         uCdgLie6LrhYuq54pRFY8jzpVYlxIWYAokceC/QzyuhUKSvnLuP8aBDyv9zJmYdTBqJj
         o4yw==
X-Gm-Message-State: AOAM530t8p7FO7cvpLK5S3SxZdlk4DxeXOeSmO91fmoKv2skDmmNwNq1
        4jqUhgoMUvnok3dddI9AHEQb08VhuZo=
X-Google-Smtp-Source: ABdhPJwHFgC7yibu4nQLweCCLZen0vfL/3EiTRFPxum5ZXB2FEh+VqGuY+idhCTv/bbKc/2v0G+8pA==
X-Received: by 2002:a63:1e62:: with SMTP id p34mr739850pgm.12.1589396674455;
        Wed, 13 May 2020 12:04:34 -0700 (PDT)
Received: from ?IPv6:2605:e000:100e:8c61:4833:bff6:8281:ef26? ([2605:e000:100e:8c61:4833:bff6:8281:ef26])
        by smtp.gmail.com with ESMTPSA id m7sm266343pfb.48.2020.05.13.12.04.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 May 2020 12:04:33 -0700 (PDT)
Subject: Re: regression: fixed file hang
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring <io-uring@vger.kernel.org>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
References: <67435827-eb94-380c-cdca-aee69d773d4d@kernel.dk>
Message-ID: <e183e1c4-8331-93c6-a8de-c9da31e6cd56@kernel.dk>
Date:   Wed, 13 May 2020 13:04:32 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <67435827-eb94-380c-cdca-aee69d773d4d@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/13/20 12:45 PM, Jens Axboe wrote:
> Hi Xiaoguang,
> 
> Was doing some other testing today, and noticed a hang with fixed files.
> I did a bit of poor mans bisecting, and came up with this one:
> 
> commit 0558955373023b08f638c9ede36741b0e4200f58
> Author: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
> Date:   Tue Mar 31 14:05:18 2020 +0800
> 
>     io_uring: refactor file register/unregister/update handling
> 
> If I revert this one, the test completes fine.
> 
> The case case is pretty simple, just run t/io_uring from the fio
> repo, default settings:
> 
> [ fio] # t/io_uring /dev/nvme0n1p2
> Added file /dev/nvme0n1p2
> sq_ring ptr = 0x0x7fe1cb81f000
> sqes ptr    = 0x0x7fe1cb81d000
> cq_ring ptr = 0x0x7fe1cb81b000
> polled=1, fixedbufs=1, buffered=0 QD=128, sq_ring=128, cq_ring=256
> submitter=345
> IOPS=240096, IOS/call=32/31, inflight=91 (91)
> IOPS=249696, IOS/call=32/31, inflight=99 (99)
> ^CExiting on signal 2
> 
> and ctrl-c it after a second or so. You'll then notice a kworker that
> is stuck in io_sqe_files_unregister(), here:
> 
> 	/* wait for all refs nodes to complete */
> 	wait_for_completion(&data->done);
> 
> I'll try and debug this a bit, and for some reason it doens't trigger
> with the liburing fixed file setup. Just wanted to throw this out there,
> so if you have cycles, please do take a look at it.

https://lore.kernel.org/io-uring/015659db-626c-5a78-6746-081a45175f45@kernel.dk/T/#u


-- 
Jens Axboe

