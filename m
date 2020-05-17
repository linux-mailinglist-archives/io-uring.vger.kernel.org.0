Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 413421D6CD8
	for <lists+io-uring@lfdr.de>; Sun, 17 May 2020 22:24:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726707AbgEQUYJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 17 May 2020 16:24:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726271AbgEQUYI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 17 May 2020 16:24:08 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65F39C061A0C
        for <io-uring@vger.kernel.org>; Sun, 17 May 2020 13:24:07 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id f6so3797498pgm.1
        for <io-uring@vger.kernel.org>; Sun, 17 May 2020 13:24:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=xJfh8wtg8VU/LekHNRZntBM6NKqzlnqBAF+Ti06Hbl8=;
        b=LHuXzNp/fpMFbgA1ik1F5h/HtiAQS+OCjQwzHb+xa23pCFiRLx0TtdFIvyQA+AxIpx
         /jsMCSMx7iqg3gNWtdSOGVkLjqlR11osqcF3N5Yc22um85SnUJEF6zKPm4KwX/BRBx38
         iCcZttssvcV95O7sUiVclgdNH0La0eYeMDALNTKiV9oucO13Xnu/mEN6iqoaBzqMQ42a
         ew1rI4eitHe6rkxY2oEkBuVPYMY+Z2oVWQxqdFvu6PXz1a7JPXkv34eNyzSY0jMDtYh+
         hWOXhIHJnlJLDbxFpqm7ZRc2u959myE8pTZ4EeUVGgiYaD+nSkgqxh9sj+e2G2iBydWm
         5L0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xJfh8wtg8VU/LekHNRZntBM6NKqzlnqBAF+Ti06Hbl8=;
        b=peCo1rJew7+AEkJB9/4ZMOtaiWv/yjbnKOSgTcMMaDKKe2L0oHN9S0LgeKxphu4She
         1gJNZYpAJgJjd442rL4xZGCS6lc/ewK6LgmA45do/40tRB1akzYw0/TZadgHD/D5tEqa
         W4HNphnKAqzjFudKJHqaafCr4IVFo34Laz5O35AFMa1oDa+eGR5vLpV4GnM9LBpe1pnb
         tRpgPth5wE7KNikKKdT5V9nyjxxZo6N790wZL6lsU0m2VKIOGbE2HqL3cqfy520qARVj
         PzkL+w8LnsCaGA77aeNiJ8NZ7cHy1yd/Y6CbspELRz7FtGGmNUlg2zkWEaQbhHywcJyJ
         ST/g==
X-Gm-Message-State: AOAM532v4QQeyWantelOtTLJteP/bNRZUlw44BEpf4tGj/tVsf6yKBO/
        DiDJROVyFGbu1FOoNQ3HIayEmQ==
X-Google-Smtp-Source: ABdhPJyc4FAch87vJQNftuA12J+lH1MbWT2+1bsDsoqBKLpyyh2WxakZfnbH2eT/zMgw1sDzw0xCww==
X-Received: by 2002:a62:3241:: with SMTP id y62mr13442754pfy.194.1589747046981;
        Sun, 17 May 2020 13:24:06 -0700 (PDT)
Received: from ?IPv6:2605:e000:100e:8c61:91d6:39a4:5ac7:f84a? ([2605:e000:100e:8c61:91d6:39a4:5ac7:f84a])
        by smtp.gmail.com with ESMTPSA id b140sm6566871pfb.119.2020.05.17.13.24.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 17 May 2020 13:24:06 -0700 (PDT)
Subject: Re: [PATCH for-next 0/3] unrelated cleanups for next
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1589713554.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <6cbfe320-bb8a-3e82-09bf-e08c0cd853a7@kernel.dk>
Date:   Sun, 17 May 2020 14:24:05 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <cover.1589713554.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/17/20 5:13 AM, Pavel Begunkov wrote:
> Independent cleanups, that's it.
> 
> Pavel Begunkov (3):
>   io_uring: remove req->needs_fixed_files
>   io_uring: rename io_file_put()
>   io_uring: don't repeat valid flag list
> 
>  fs/io_uring.c | 47 ++++++++++++++++++++++++++---------------------
>  1 file changed, 26 insertions(+), 21 deletions(-)

Applied, thanks.

-- 
Jens Axboe

