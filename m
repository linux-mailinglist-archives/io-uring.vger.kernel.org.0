Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 639CA3F3F85
	for <lists+io-uring@lfdr.de>; Sun, 22 Aug 2021 15:37:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231836AbhHVNhm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 22 Aug 2021 09:37:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230495AbhHVNhl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 22 Aug 2021 09:37:41 -0400
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3092C061575
        for <io-uring@vger.kernel.org>; Sun, 22 Aug 2021 06:37:00 -0700 (PDT)
Received: by mail-io1-xd36.google.com with SMTP id q3so1033464iot.3
        for <io-uring@vger.kernel.org>; Sun, 22 Aug 2021 06:37:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=CqVcqfEbsk88ecJuk0W2j4RvWSSYMm/N/SXcwXVGWvI=;
        b=TGtVtIAkBGZXSWAfkPa57MvO8+EzRfacDLsmM1AaEus2AqVgRxRKLSMDuEOZI1q4yi
         VxasSspASndz7TDUmnvtfCuXjuD+t7D6lBnYxopExPA5kET1a8vX31+tJaCnSDsoo2b6
         HCCGgeWNr/fETuDPtuqGmjTOFyX3NZ2inpvwJ+uBx/Jv8ArxLYS6pMLGDA6lRn8x+j/R
         NCMCnz8+GUcDRe30AE8ncndy4Ll0SJBwx19wnzT1BYrn7YcEhc00Dlsd2R/SsrsRGDUl
         +KJqsBi7FbwUSPS1+TJzPb8pa/Ujn3c4pWUcAzfExw/cenQNO0LrzEin8kXt744CF9db
         FqBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=CqVcqfEbsk88ecJuk0W2j4RvWSSYMm/N/SXcwXVGWvI=;
        b=Z5cyFGdGImI+WMjc9ElOeB4I4C0okU3IqQ8oYfCYBhxish38SRK/TlGoFNmrvqboFz
         RgiaBBblpFYp9mXDpAnq1BldVZQxqjEzRhy5n4Y1lvsuQF3/ErjbZ8WPwRQai7PmnKuy
         RZddgAZVuuBgvhMQ2qSGjfL04dGB5aKZptwVi+a3QqwYg6TwuwAvyt5jh4ovl4OLsFAI
         WclgYIE3XFHMJNUyjuzcRhILx0QpeceLXU4RlPzL2hriQdsejP471kqa8SjGAGttX6iu
         xfMwpGVI2+5FV92bY5YdnMYhJbOh5tgCGYS4ARM9mm08Pho8Jy0EEZ6lB343zNeIFBRM
         NxTA==
X-Gm-Message-State: AOAM532iAbhEmd75Xc+JWx9hWGv96Ys1gqmzo+gjUizUMT9v3FMH4Mus
        kgpfzp+Ebmq3wzvNBFCW+ZcZrckoomX2oA==
X-Google-Smtp-Source: ABdhPJzHsVMMC++WV4AYaFZW6Q/0JKwbq0WagQH523FB51su/8jVOww3Nvqh/2N+0V3qsxkzKjdviw==
X-Received: by 2002:a6b:fc1a:: with SMTP id r26mr22861432ioh.30.1629639419853;
        Sun, 22 Aug 2021 06:36:59 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id b10sm6742980ils.13.2021.08.22.06.36.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 22 Aug 2021 06:36:59 -0700 (PDT)
Subject: Re: [PATCH liburing 1/1] tests: migrate rw tests to t_create_ring()
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <ecb8603a6ffc2e296cf9ed7e6c0f5913c60e6032.1629633967.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <25c6646a-6363-7656-5f81-d63d3270935b@kernel.dk>
Date:   Sun, 22 Aug 2021 07:36:58 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <ecb8603a6ffc2e296cf9ed7e6c0f5913c60e6032.1629633967.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/22/21 6:07 AM, Pavel Begunkov wrote:
> Use t_create_ring() in read-write.c and iopoll.c, the function will do
> all the privilege checks.

Applied, thanks.

-- 
Jens Axboe

