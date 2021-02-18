Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB5D031F2DA
	for <lists+io-uring@lfdr.de>; Fri, 19 Feb 2021 00:16:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229656AbhBRXQp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 18 Feb 2021 18:16:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbhBRXQn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 18 Feb 2021 18:16:43 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FA6CC061574
        for <io-uring@vger.kernel.org>; Thu, 18 Feb 2021 15:16:03 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id ba1so2183864plb.1
        for <io-uring@vger.kernel.org>; Thu, 18 Feb 2021 15:16:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=Y52WbCfP/fv9/ojmQbYQNCpX6siOqBrq1+eW+Ocw4iY=;
        b=a43VCldpStXHjdjcP35rlFsg49Dtfye/5A/ObgCyHltk91bsAy0Z4PaULHo6hID71B
         y32Fj1bFx+JERnj+H8RI2qDHlVYyBgCr3SdQL7VnrZ4yPhJeLzKo1AqA2Cg8RDL+FsT6
         LFE51b82or70eTl3A7y/gOefm1w8IXmqLA1X6p3uNnlqTa2fmRRoGtS70ixrMtvWgCbf
         4BD1Q1kGFapmzv2ZDYZ5fum65ndenWtno7LVRJjskvWX2PTHF8XCQ0O2lwzqHCg3abOz
         w9R2lbrcG0DOBZTgVCrU0gh6lkpu54/bVbnNWgoc7R1vjI/QXkGh1ooBqOtpko0YtUjM
         HPGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Y52WbCfP/fv9/ojmQbYQNCpX6siOqBrq1+eW+Ocw4iY=;
        b=b6joDrrFg7fRQSk7wtz3AcX++9b5BJ6NQQBrkw6FtgbduxhXN0tCm5Ntaqmbp/ceWO
         pHETs90qGygOGDJAuoI1xS3pJxdJl3bB8vnej8vbdG3msuTMqeOlA4dSNh5e6wNH5mOD
         3v4fjqsuhD3K+0EvwsmHz5PGr6FxhOAxFTFgcz6y+FXLJgLEty3M1zEMP13m9nOLlU11
         9jGCGBbF6qFZWBVqIH7KUBcd04ffqGsn9gArZ2YB5tOi9DcPGRJIp9KUdyfmRkbGlbUq
         OyWRs9OUslM9w8c5uFk13laMzNQPBBWWyTkzR0H/lTqskJkzL5218+XBjdRxwX/OsNz8
         gcgA==
X-Gm-Message-State: AOAM532dvFbf9dZ1uT9SQHFOikNuSic08waRit7OCs622uswXRT9aUOd
        b+YMG0rZEObM2xVlU78WOQ28uJS/xko2bQ==
X-Google-Smtp-Source: ABdhPJx7tAfjfg22Cgjb7gvTdlorySoWSv5APMB3ml7bW523+y24J1AYsCQuJBm6uFtZSOlxwrUzSQ==
X-Received: by 2002:a17:90a:bd0f:: with SMTP id y15mr6140889pjr.141.1613690162801;
        Thu, 18 Feb 2021 15:16:02 -0800 (PST)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id n11sm6387528pjk.38.2021.02.18.15.16.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Feb 2021 15:16:02 -0800 (PST)
Subject: Re: [PATCH 0/3] fix nested uring_lock
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1613687339.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <74273334-2598-fcbd-549c-78816583b0ce@kernel.dk>
Date:   Thu, 18 Feb 2021 16:16:01 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <cover.1613687339.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/18/21 3:32 PM, Pavel Begunkov wrote:
> 1/3 is for backporting, two others are more churny, but do it right,
> including trying to punt it to the original task instead of fallback,
> aka io-wq manager.

Thanks, applied 1-2 for 5.12.

-- 
Jens Axboe

