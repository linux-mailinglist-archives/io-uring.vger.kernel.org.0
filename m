Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BD163630A2
	for <lists+io-uring@lfdr.de>; Sat, 17 Apr 2021 16:29:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236058AbhDQO3b (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 17 Apr 2021 10:29:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233008AbhDQO3a (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 17 Apr 2021 10:29:30 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E748DC061574
        for <io-uring@vger.kernel.org>; Sat, 17 Apr 2021 07:29:03 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id q11so2337952plx.2
        for <io-uring@vger.kernel.org>; Sat, 17 Apr 2021 07:29:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=SlIQBVRVwpA/1zR2QLNnLiM/iAyzGCEsLW3Nw2TTqcs=;
        b=kB5Y25qX43eab8/BRJwPStYx0CsKX7jDOP+QBJ5i3U2FX02IJS36UUhH8IV8ed6cqG
         HKSx9hQzVop84sbmWMXS9prhS58L7UyA3r2lKSrsuMnClb1LraedGkyC5wH8cCM4U7gA
         1bbb6D88xGnaVdUAqW6TTtQ4ilzrIa5gv/O658QFbX8qDKbCINxPwJPMgifJanQD/q+Z
         NjaU4vN52K0fpcILcdD3FRCexq01s9ys/ZJ2ANzXv0Xr34ZC0QAn5kDJsZ7THU1xnYpL
         YrFNBjrUa+ES3JbWh3TYR0bhOQR9mT0kfHfCIYjh0tgMqJdcVryb1KuqnA4yOO/tF9c8
         HuzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SlIQBVRVwpA/1zR2QLNnLiM/iAyzGCEsLW3Nw2TTqcs=;
        b=XTE6gYPswvmq6RppLC+D3azzBr9fzh/+NPn9kxn1lRhUkyCb82cyWyrLSEPwW0SXlR
         ZH8ExpM8K3pdObG6/ddECsFnlQR2ixP+wU6lp3IuMJ2cmUbHufdU1UYYMxLYikf4QFKZ
         x3G/dAEautg8Z5yqtVRHhdWqKcBHFuMYUY56DKs5ZPkGCinIBWGvwbevXArBcJdUKTY8
         5lK8qRFxqRJgnYNyEdRp7syA/cNZ046TVDSRBjs/RfqAEKQ9G4fv4eAiQ3MZITDepeCC
         HqccFOJB0rrgZUdJO8OFEyJWUbA9imav9l9SxOCDQxWp1BHkPfDQ0rbtimjv51BVckCM
         SGsA==
X-Gm-Message-State: AOAM533Oqf7CzmWp70c2KcWIGGzdboC+iqJYjgzeQxesO/N9+Ao132k8
        Ezk0SyF5O3FA5teLQuJ/u2s2nHsd4+QczQ==
X-Google-Smtp-Source: ABdhPJzhZfHE8LTASoJf4L+Ar7IxVfsOjPirCjASYLFZxLkR09VBQEYKh8FiA8gu7c0GVCxOUhnvVA==
X-Received: by 2002:a17:902:ce90:b029:eb:a5fa:3ace with SMTP id f16-20020a170902ce90b02900eba5fa3acemr10842569plg.43.1618669742944;
        Sat, 17 Apr 2021 07:29:02 -0700 (PDT)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id i14sm8028006pgl.79.2021.04.17.07.29.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 17 Apr 2021 07:29:02 -0700 (PDT)
Subject: Re: [PATCH 0/2] two small patches
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1618488258.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <3eef78ca-39a5-ac2d-8baa-ef16798a90e1@kernel.dk>
Date:   Sat, 17 Apr 2021 08:29:01 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <cover.1618488258.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/15/21 6:07 AM, Pavel Begunkov wrote:
> Small patches improving userspace values handling.
> 
> Pavel Begunkov (2):
>   io_uring: fix overflows checks in provide buffers
>   io_uring: check register restriction afore quiesce
> 
>  fs/io_uring.c | 31 ++++++++++++++++---------------
>  1 file changed, 16 insertions(+), 15 deletions(-)

Applied, thanks.

-- 
Jens Axboe

