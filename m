Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 157F02D14F5
	for <lists+io-uring@lfdr.de>; Mon,  7 Dec 2020 16:42:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725866AbgLGPmU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 7 Dec 2020 10:42:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725822AbgLGPmT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 7 Dec 2020 10:42:19 -0500
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79B95C06179C
        for <io-uring@vger.kernel.org>; Mon,  7 Dec 2020 07:41:39 -0800 (PST)
Received: by mail-io1-xd43.google.com with SMTP id n4so13733901iow.12
        for <io-uring@vger.kernel.org>; Mon, 07 Dec 2020 07:41:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=kXDXVzJchbHkKv+1VHtKrnmB0Bbx+G8TrsA7BucO7EA=;
        b=jRqkHr+f9T8hJ6YLu8vnWWMh0inCiTYvGlYL5WbijSadFrQYsu6P+tZtI5RgTOIe08
         2vXw2IcjUoPCAUKKHO0YJ1qUEOZbI7aN/ZMTd57ZXTH0jJng/2fyVV2rfihCbWZGSiEn
         IftTrTUuyFlPC5Vh24kDshFjtlT/+z/ya63RRmRya/6ROmNg3BR5Pf6U2Bq3Aq2QVs/x
         MIllfnrgA2il3+LDlXiWwTDq+/b8H/AwcYybgBlfyxisSF6SSuBkxc2qMhqf2KW/OpSG
         /c/Vjf2Dvuw2hyR/4kYFEwp90s12O5+C2bGXoHLUuSKx96mSLOSp2qA1SzFAhC/rJPhE
         sKTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kXDXVzJchbHkKv+1VHtKrnmB0Bbx+G8TrsA7BucO7EA=;
        b=AvUOkWoO/t+BQ7NU9zUrFcOr0gHNPIJLNFvoWAsBORzOyhksqDcF3f3OzqmyOxvShE
         9jP6AkTgKzBwItKPA9/BESvIn+AmAqkXlcxHQX7V+3TX9YMT31NcorlLF+hxhfnNEYmZ
         tV3VpJdWFnVMiygcHbNghCd32Y9V4tXMik3nL9vw9skOmsotoCyT4J0wCWdvG2yCf14H
         DZdyjDyF77sRSTe0iCQpCViTtoQ+eD26nTODAC64UuCKgLo9zN87sr6qoQMu/akuj1sk
         liGtC5ySe0dCNzl5OpGBcCsMeM8rluO6EELSUwPumJddVnUjBOy395ncmJhpWYJPUDga
         3SJQ==
X-Gm-Message-State: AOAM531bAzXVCj8W8c7rzOl+RMSxtWOwzk31EWzNODbD6WhObT0HpUP2
        8gjTHAbpy5oFgJUYABRY8SXSOPC1AJvHkQ==
X-Google-Smtp-Source: ABdhPJw2nfaMH8a750zuf7X8twvIAErk/C1Xx+eTTcXU5Fy1bY9McEsHhoG4xRMVLUfLN8fwT8vbhA==
X-Received: by 2002:a6b:8ec9:: with SMTP id q192mr21604216iod.28.1607355698549;
        Mon, 07 Dec 2020 07:41:38 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id y3sm7670497ilc.2.2020.12.07.07.41.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Dec 2020 07:41:37 -0800 (PST)
Subject: Re: [PATCH liburing] Don't enter the kernel to wait on cqes if they
 are already available.
To:     Marcelo Diop-Gonzalez <marcelo827@gmail.com>
Cc:     io-uring@vger.kernel.org
References: <20201203160706.4841-1-marcelo827@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <40430f2c-32cb-4153-7ff4-df74e745d718@kernel.dk>
Date:   Mon, 7 Dec 2020 08:41:37 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201203160706.4841-1-marcelo827@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/3/20 9:07 AM, Marcelo Diop-Gonzalez wrote:
> In _io_uring_get_cqe(), if we can see from userspace that there are
> already wait_nr cqes available, then there is no need to call
> __sys_io_uring_enter2 (unless we have to submit IO or flush overflow),
> since the kernel will just end up returning immediately after
> performing the same check, anyway.

Applied, thanks.

-- 
Jens Axboe

