Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3D3443424D
	for <lists+io-uring@lfdr.de>; Wed, 20 Oct 2021 01:49:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229784AbhJSXvx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 19 Oct 2021 19:51:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229707AbhJSXvw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 19 Oct 2021 19:51:52 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EAEEC06161C
        for <io-uring@vger.kernel.org>; Tue, 19 Oct 2021 16:49:39 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id o24so7699294wms.0
        for <io-uring@vger.kernel.org>; Tue, 19 Oct 2021 16:49:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=4yZEDuFkdr2NwFjXen/8pLOFxKFFafDArTKiHlE8EXM=;
        b=gHRVWLN+mYRBwu2psWLAbysgFgzPKYEBaz7zPWByzEp5CDrnD/SoU2J87CDor0ap97
         hQLAmMRxwpPmJl+d3dPH/VVjoLHHfWSipP831w/cz8MCXN3rL4ZkNIwZ6VpHHFD4nwCi
         sn+X7y8BAQa7vE/owC4hWQ4JEIoGqs2/4XuiNEeTcLqueM0H4BcYePpyPVdOFGwaZZNc
         LPNaeeIqW46HXVSBymHrNliwyMWpoVRKO5awHVer5TF5qulNxmQwDzv0pAXLUDi+QwAT
         LHh9T0VlMSianFaThxdXV2zmApNWXuA8DsXIGknG5h3NWkCD0wmdWuEYz7lGxaFtKaVi
         yUuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=4yZEDuFkdr2NwFjXen/8pLOFxKFFafDArTKiHlE8EXM=;
        b=yJPHrMMSArRh85ynVsH918vkFf44T07On186aOnaNHDfb9nqqxP0Y6Q5187KCLd0dP
         eKYcKI8bSTLx3tgP/1mEQqQ6AtjYtvEfNSxeqOZksqQt2q43UjEOANytYD9gKhGKo2Tt
         R7zkdvn5B9LYaFGjcabGOzRCIvdjtc/eG126B6SwsxaXhVVC548R5L4VqQEa0kN+afJ/
         qmN1aJYY/i6yM7fE+2FlbyVojiTe2u9G57ur+tnhPyrxUXyXcgMteqxLQREl0Bzh/IfR
         uF9CXOrMuLaFUDTrYl4Ly5n7Co1aiUgpmA2SYDmHqnolYkNv6TFbIDIP9h7M5GngQOy3
         /6/g==
X-Gm-Message-State: AOAM530IIji2/cGQEFMNpGVjdNDoDtgZEdgrsjkEML1s8jtAvw4m3W45
        ftpCCTrsnvnIFMajBLdR7we4bQMRn6AhbQ==
X-Google-Smtp-Source: ABdhPJzqvw06quk/8IAC4oiuEYyoAVUNS7rTFMmRaXR1E82GsDQBQ3u4iK74TbCDczuug/nQg/GLhA==
X-Received: by 2002:a1c:f213:: with SMTP id s19mr9547543wmc.169.1634687377770;
        Tue, 19 Oct 2021 16:49:37 -0700 (PDT)
Received: from [192.168.8.198] ([185.69.145.194])
        by smtp.gmail.com with ESMTPSA id m8sm365523wri.33.2021.10.19.16.49.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Oct 2021 16:49:37 -0700 (PDT)
Message-ID: <45520603-274f-265c-30e5-ffb11d27170e@gmail.com>
Date:   Wed, 20 Oct 2021 00:49:39 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH v2] io_uring: split logic of force_nonblock
Content-Language: en-US
To:     Hao Xu <haoxu@linux.alibaba.com>, Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20211018133431.103298-1-haoxu@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20211018133431.103298-1-haoxu@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/18/21 14:34, Hao Xu wrote:
> Currently force_nonblock stands for three meanings:
>   - nowait or not
>   - in an io-worker or not(hold uring_lock or not)
> 
> Let's split the logic to two flags, IO_URING_F_NONBLOCK and
> IO_URING_F_UNLOCKED for convenience of the next patch.

Gone through all locking sites, looks good

Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>

-- 
Pavel Begunkov
