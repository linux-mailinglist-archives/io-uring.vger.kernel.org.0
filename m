Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 781991FC34D
	for <lists+io-uring@lfdr.de>; Wed, 17 Jun 2020 03:22:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726497AbgFQBWY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 16 Jun 2020 21:22:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726270AbgFQBWX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 16 Jun 2020 21:22:23 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D4A8C061573
        for <io-uring@vger.kernel.org>; Tue, 16 Jun 2020 18:22:23 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id bh7so163208plb.11
        for <io-uring@vger.kernel.org>; Tue, 16 Jun 2020 18:22:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ogxybo4MdHs28HOhXfwasso1PPZyKVxoypFtELVJ1Jg=;
        b=Bv7PPVx4w586PI5r4yiNz+L3wovnEAWfN95eMJvMfGsLoPwTADbmtKzNLCqRV/uNX5
         bKYaK4+LJhONZjjE/7PL2ejfzhwIbyYSsfkErEB4JQUDoBw43rPuvTJcHm2zknNqkE5T
         o9bXNJUbv29l7arSvNQm+quA7qQvDMq+NfsPbynY1MUWqtc+VGfKUAqYLpl64DqNaZGY
         iiIV083j+2NKUVvn58hHzRLUlpibLIhCDsqI5HKl8hrZ7N33aMWUffvFbdSjbZ1NL09R
         z0X6Vx1R/9PBAYWiaEmllwq6i/M3hcVVjWMbqmR+sg9tBpf8AH/Glj8Fo4JbELx58IrC
         XPRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ogxybo4MdHs28HOhXfwasso1PPZyKVxoypFtELVJ1Jg=;
        b=PNKLsyUpclEncMVggbjeEYuBSgYVRNXh5TbJaiKXjDD1n+wMya9EjdTJSogKcOz2tM
         ERsq5ie7yM/sGo+ZjvK52Nre3EwBS9xu++wCxSRqqjNQs/HnjDY6BK94sKSxoK0l5vS6
         dL5yTOuub/IYcpCvCMIOU3FFqslOzLiFEmgRN2nuAjHv7CXUMYqgzzA7/9dFLZFvDxbL
         /rGNYwMfiN49dtF3VM4kCPQgfx+ahYLsCR3MLy48tR+47RU5fFuF+Mg9iAiSy2csgKCU
         UWHIHusKW4zl53MPtUv222VGxw6c+u5ha1C8XJDVkrP1LryqBmGWnwR35yk0zowBtVE8
         cS9w==
X-Gm-Message-State: AOAM533H/GSwJAB1eMUyn7Yc9QrH4GfC1Qa4UAh1xFlFqz8r/KVo7LKR
        9a9mZBHRcZ9abDbXgPLURP+79LycmXzOzg==
X-Google-Smtp-Source: ABdhPJw82uYXF11N1QHlyM5M3vA6oQNMzI6AXdXJ9+3nbG8WztZRm+iIqJsvHp615UuQYEY8ref/QA==
X-Received: by 2002:a17:90a:266f:: with SMTP id l102mr6061403pje.190.1592356943018;
        Tue, 16 Jun 2020 18:22:23 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id n4sm3579987pjt.48.2020.06.16.18.22.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Jun 2020 18:22:22 -0700 (PDT)
Subject: Re: [PATCH v2 0/2] add proper memory barrier for IOPOLL mode
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org
Cc:     joseph.qi@linux.alibaba.com
References: <20200615180638.19905-1-xiaoguang.wang@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <f2759615-7e6d-7aa9-6d31-71f86a5bb81e@kernel.dk>
Date:   Tue, 16 Jun 2020 19:22:21 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200615180638.19905-1-xiaoguang.wang@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/15/20 12:06 PM, Xiaoguang Wang wrote:
> The first patch makes io_uring do not fail links for io request that
> returns EAGAIN error, second patch adds proper memory barrier to
> synchronize io_kiocb's result and iopoll_completed.
> 
> V2:
>   fix uninitialized req reference in the second patch.

Thanks, applied.

-- 
Jens Axboe

