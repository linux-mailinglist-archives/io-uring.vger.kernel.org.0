Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DC383EA972
	for <lists+io-uring@lfdr.de>; Thu, 12 Aug 2021 19:28:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235847AbhHLR2x (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 12 Aug 2021 13:28:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235854AbhHLR2v (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 12 Aug 2021 13:28:51 -0400
Received: from mail-ot1-x329.google.com (mail-ot1-x329.google.com [IPv6:2607:f8b0:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44B09C0613D9
        for <io-uring@vger.kernel.org>; Thu, 12 Aug 2021 10:28:26 -0700 (PDT)
Received: by mail-ot1-x329.google.com with SMTP id n1-20020a9d1e810000b0290514da4485e4so5895234otn.4
        for <io-uring@vger.kernel.org>; Thu, 12 Aug 2021 10:28:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=n+HGSJwRPaNZ4bCuiVZymDln4DyvTVJxVO6JKx9EVO4=;
        b=EdiLNdG4pazOvPSm9GIBhrSjrELn9k823olXN2WQqM7Cubvkiif1U0jZwP8J+xTamV
         sJpiTXPE6AwfbhS+nMjKek4+cjdZTy1pEIK8TRbtdEoIlopmzp9EyE9KbDdpKEmaSWN0
         MzfJkzNl724yMlxBehBxZpcI9rBjS3emWc2RjTBqlkfOAvqywMZhd/f3XcoZqDwmU8yl
         vnGx9aPxt2Y9f3VjP+V03Ev++ouCynP8V31d1rrgZJVHJno7CCYmbr11pqDiHfVqiGa6
         VUybuK5e3xtUig3Z+y1ZYiF9hQA8f+x6Ddm8eivKs5MurgTFCnkewhwF5dlSSnfD8h1j
         5etQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=n+HGSJwRPaNZ4bCuiVZymDln4DyvTVJxVO6JKx9EVO4=;
        b=ZqqoDkFpMFrrgV3Le3d/2XVXejLJOmLgxRXEeDbOVBgJ96B+xOPWzzCks3GHbkK7OD
         orLL3epibv4rDUQvEVRBQCg7RyzANHCCHXFqRSHW/oD6RtW5Emnwka7Qbi4K1u/gul/C
         f9Vn+qwLaJhNjLPaHsOOfQ5TzmpTdBK+3o9QzKENn1m73fxrzomfSzsor2ncPrGvyDzH
         F9Wds0abBWgmS1bOKgBTM/UwgZSMOhGHRBMfeouSIa4IYmMMSuqfLWWdVdeR8NaWGylf
         4bYN0+ZB/0tf4Hg25ueYDODh+RPMwYzC/I8GnFukNTxzBCjKhOtQq280jf/xdXtwVEXx
         D9kg==
X-Gm-Message-State: AOAM532PdsDBeLHJGNlZ0mXet8HCr+2L7rOTlAXFGc3zShRrBonZDmm7
        +6ngUMW1yNrhX8liHeW/Vk9PbA==
X-Google-Smtp-Source: ABdhPJwJRGJFXQxSMTHRgf7KQlXYhshYsMUdp76wEugh37Gp3h+2Lu/NVA1bZlbAj8VeydaarM9Wbg==
X-Received: by 2002:a05:6830:47:: with SMTP id d7mr466325otp.108.1628789305649;
        Thu, 12 Aug 2021 10:28:25 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id i16sm754765oie.5.2021.08.12.10.28.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Aug 2021 10:28:25 -0700 (PDT)
Subject: Re: [PATCH for-5.15 0/3] small code clean
To:     Hao Xu <haoxu@linux.alibaba.com>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20210812041436.101503-1-haoxu@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <577c70e9-e40d-c3df-2072-e0bcfe5f75dc@kernel.dk>
Date:   Thu, 12 Aug 2021 11:28:24 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210812041436.101503-1-haoxu@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/11/21 10:14 PM, Hao Xu wrote:
> Some small code clean.
> 
> Hao Xu (3):
>   io_uring: extract io_uring_files_cancel() in io_uring_task_cancel()
>   io_uring: remove files pointer in cancellation functions
>   io_uring: code clean for completion_lock in io_arm_poll_handler()
> 
>  fs/io_uring.c            | 15 ++++++---------
>  include/linux/io_uring.h |  9 +++++----
>  kernel/exit.c            |  2 +-
>  3 files changed, 12 insertions(+), 14 deletions(-)

This looks good, except 3/3 which I think was rebased and then not 
re-tested after doing so... That's a black mark.

Anyway, v2 looks fine, applied for 5.15.

-- 
Jens Axboe

