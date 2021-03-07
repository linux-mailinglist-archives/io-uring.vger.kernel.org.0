Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0C9D33046E
	for <lists+io-uring@lfdr.de>; Sun,  7 Mar 2021 21:08:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232812AbhCGUH5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 7 Mar 2021 15:07:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232805AbhCGUH1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 7 Mar 2021 15:07:27 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0200FC06174A
        for <io-uring@vger.kernel.org>; Sun,  7 Mar 2021 12:07:26 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id j12so5684759pfj.12
        for <io-uring@vger.kernel.org>; Sun, 07 Mar 2021 12:07:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=lP0AOmnmE0RlNX1Qey3m0KOuK7BxMB8XH1muu16EVrM=;
        b=0BQu0K2CZZfBClBCI+UvgPN4G8zKGhMugS5j9hQuJBXLMh4sv12coMCL6Ztj/1H+It
         zV9SSWOd1ZrIFjtK+CJfLQ4AB/0UUZCnst98So2ALAZ0OB0Tk6rqW7R4s96GIySx/lRq
         UDJt9r7ZcSpjF/HCjiySJXlWH6Cl+cwhz4MNE6iwMldqJLJC6RKj/k57ikCqMwyLPOZa
         7Czxot7v0XwNzCYXMnbFGwU/sMRUmsBtlvK6VSwcbAld+DPhfsH1KDO3BpwMS/e3NdIg
         khGaR0lHe7tQ3Yx5pW3hSKAtILXN7NHT4qRAqQjWI7xb1Sn6H+HB8jw+MW4XSGYivIWR
         Qiuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lP0AOmnmE0RlNX1Qey3m0KOuK7BxMB8XH1muu16EVrM=;
        b=SeEaNHcbS9KAukiCh5GPABUafEH6CX4WkSfhVIK7WAM2Z3NoWumJkJ0ELBj54stwGa
         DrOPCACTYwIZa4a3Y9V4DFf+mUVW2N/KrdahervgygnrZFDRk1xFN7ZYLkJqnZhJX8Wl
         bYfTK33n8hGJbFeLvnWQnVGXUifWO92U7AoSsZx+xR83983X89yZyjSNr39Div3Mqwtm
         GSWt3ZiC82CEk7hZrrPjm5D31vqb7sJ08jGE+Wtvu3rCNVxEBWQF5MLKXeu82zLbcN/C
         mrxLTcbwQCx3YOirrhHi/fR7O7uHN85LwjHbzmEw1to7aPi/4aVo2b2eHecR5C7o4Y6I
         0zKg==
X-Gm-Message-State: AOAM530HtZCrUwjWbc6Vjz9NV9lKcQED6BoLg9qifdpX+WwuM+cRVHeg
        2kdjUnyI2mbgBMzthNGAA6kHp9vHuWPztg==
X-Google-Smtp-Source: ABdhPJx80V6eu8GKGMzBQix9b43E1Jp82NJe3/BQuB9JdK0NJawDkt8oSlzVSHRngIqoo7btthdpCw==
X-Received: by 2002:a62:3181:0:b029:1df:4f2:16b3 with SMTP id x123-20020a6231810000b02901df04f216b3mr18127493pfx.24.1615147646144;
        Sun, 07 Mar 2021 12:07:26 -0800 (PST)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id x1sm8212365pje.40.2021.03.07.12.07.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 07 Mar 2021 12:07:25 -0800 (PST)
Subject: Re: [PATCH 5.12 0/2] Restore sq_thread 5.11 behavior
To:     Stefan Metzmacher <metze@samba.org>, io-uring@vger.kernel.org
References: <20210307105429.3565442-1-metze@samba.org>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <c6346c71-8043-a80c-dca1-732f6ec2456d@kernel.dk>
Date:   Sun, 7 Mar 2021 13:07:24 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210307105429.3565442-1-metze@samba.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/7/21 3:54 AM, Stefan Metzmacher wrote:
> Hi Jens,
> 
> I guess on top of your "io-wq: always track creds for async issue"
> we want to following to patches in order to restore the sq_thread
> behavior of 5.11 (and older) with IORING_SETUP_ATTACH_WQ.
> 
> - io_uring: run __io_sq_thread() with the initial creds
> - io_uring: kill io_sq_thread_fork() and return -EOWNERDEAD
> - io_
> I've not tested them, but they compile and as far as I read the
> 5.11 code, they should restore the old behavior.

Thanks this looks good, I'll apply them. There's really no point
to the fork handling of SQPOLL anymore, since the unshare code
went away.

-- 
Jens Axboe

