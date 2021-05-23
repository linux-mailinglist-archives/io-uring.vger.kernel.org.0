Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6ECFF38DBF3
	for <lists+io-uring@lfdr.de>; Sun, 23 May 2021 18:40:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231829AbhEWQmX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 23 May 2021 12:42:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231815AbhEWQmW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 23 May 2021 12:42:22 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 650E8C061574
        for <io-uring@vger.kernel.org>; Sun, 23 May 2021 09:40:55 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id q25so803995pfn.1
        for <io-uring@vger.kernel.org>; Sun, 23 May 2021 09:40:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=KOyMvExjnlM9sNp7VXjD9yQI194mX6S08Oxf3waUeHQ=;
        b=wJy+KMmJNW9tonQIOoJx92nsPOOKvdeoTJopqzk2UWgXfFkEojzT+Ull0d5dlGd6PM
         JzreXRRtL8zSXNwfpTs59u84WWA5CMqykO9QohsAmCQi4jLm1a7YBnzq9gj0P1JFc1m8
         1A+EwAw6RpFQp8n/KSXxXVtpgHGVE8Wv7LLiL/X6rP9NHcbZ/7/Ez3qMpr/aJ6AToSYX
         DMUij5zSVICu5xsdswjZI26F81QHaFktVaaFwkelGX9/SyiG6fOyvlUn5+Jtl3JtO2iq
         wJVjGWhhu/fs5EaJvDVW7VbNZZ5PYz3pYX5qxYG1zClnkN42xJtOUxT/fhm1oACBBSow
         6fEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KOyMvExjnlM9sNp7VXjD9yQI194mX6S08Oxf3waUeHQ=;
        b=WESVpHBMDUDDcLri6dYuBuLz43XevcBi3s8LB0HQbXIJRnpivsA9y7lPmVcjvX3PEO
         QG7q/KBTfY4kDIbfcZpL50AqIrLw+JHUw/AGJW+rsIHh6S6El9/eetEJfilJTp25VPiZ
         wV7wZrns06f7U54aeUabQMos1RuQucg+ziH5Uwh8+XYDvImlKpqjCPLCdKQ7lMY1KH5K
         FjQbDEwk+3OkmHXhvXTLYy98gLmpPpvvnqofjxUMYi3sCMxr5oeALhxFdVYl8ozcdZ84
         8wqDSpKo3/uQofRAvHtuJqMoLOTRVCMG6rqGSMHFewtY9cws0Ud9ebvWe4BfABdnLMw/
         dKWA==
X-Gm-Message-State: AOAM531UeTD0JnsiroFq3jRg8EM6yON1e/i7TmX7Qe1+vCQ2QhCw3+9o
        FmwajXJbMJ1Izkn3r2nlwE4bQg==
X-Google-Smtp-Source: ABdhPJzhzSyZeUngq9caWEE60Cd87ZIC0aND9k3x6LfSfriVLonFs+4Iz6nPt4qilBuhp6tbtS3C0A==
X-Received: by 2002:a63:5511:: with SMTP id j17mr9523659pgb.191.1621788054905;
        Sun, 23 May 2021 09:40:54 -0700 (PDT)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id 23sm9831384pgv.90.2021.05.23.09.40.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 23 May 2021 09:40:54 -0700 (PDT)
Subject: Re: [PATCH] io_uring_enter(2): clarify OP_READ and OP_WRITE
To:     Drew DeVault <sir@cmpwn.com>, io-uring@vger.kernel.org
Cc:     Pavel Begunkov <asml.silence@gmail.com>
References: <20210523162012.10052-1-sir@cmpwn.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <e7142141-9598-81bd-6d4e-e965e8a30d55@kernel.dk>
Date:   Sun, 23 May 2021 10:41:00 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210523162012.10052-1-sir@cmpwn.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/23/21 10:20 AM, Drew DeVault wrote:
> These do not advance the internal file offset, making them behave more
> like pread/pwrite than read/write.

They do, if -1 is used as the offset. Care to update the patch and include
that clarification?

-- 
Jens Axboe

