Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECC181F5F90
	for <lists+io-uring@lfdr.de>; Thu, 11 Jun 2020 03:40:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726361AbgFKBkj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 10 Jun 2020 21:40:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726163AbgFKBkj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 10 Jun 2020 21:40:39 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F4CEC08C5C1
        for <io-uring@vger.kernel.org>; Wed, 10 Jun 2020 18:40:39 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id z63so1012294pfb.1
        for <io-uring@vger.kernel.org>; Wed, 10 Jun 2020 18:40:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=rAVjwDE1YQNexj2tuztG00TSNSIMXta4Z0XlVbeaKyY=;
        b=KOgY4dn1RDtFEv5le+jydJNJJs4GpT4KM2L7flHPEDh2kV5gIFbN4xce5zD+IWzv1n
         BoSCLX6LwVeSt7ybLNPpHp4OqFQVWv9gLlXqbdW45LDdA9b9jbQarTjMgGjA0eEuipxT
         zGuy1+P6KjoF7+71MYVnrqm8meqQ/2icv7SkzanQq1rgsAgdLZKvl+fVIhPqM8crWzk/
         7QjiJ5wdADoWNx/g1dAIckE3igW/l2P9gfHCKNCTbF0ffPrOdEjsrBSfIjBEqtn92hqs
         /moN5dGMWGzPuCw3qRs+M7eBvWUXYouaqdBTYuj4InxLNw91cDg639acJ+Ow5RlJmyRd
         hKwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rAVjwDE1YQNexj2tuztG00TSNSIMXta4Z0XlVbeaKyY=;
        b=VtC+5q4wLS0Pu+Gbxq72k945xoDppy6wlObQmZE1kDDPWi9rY1aQfMAGAY51X/pcP/
         XnjU+oUpmzrBNmZyB/bxmfX/t+QW/fi7Ra+YDgWzO+rg7yE3Ec32XV8xQXXCiY6Oo8rv
         T3n1Y5L1n2FOaSx+PzHPoZribXuMh5TyUowgxWYyUDdKgyWxIi8uRmo63EjrN9aEezzj
         cS7/rq3gStvHzJgBwfJDMpJ29HMBmdxqFfSBjAolKhF7YxjVua0dRaM9MZe/G6mHScCb
         4D+I3U43mZ16vNwPnM/699nT8fbB1COrkBPU3GbseCxqC1RSHU19ZXHPHVrho6BzRXa2
         N3QA==
X-Gm-Message-State: AOAM531/bm0Ko6PqXfR/QH8bO/1m3GtRE6NpSUifVtp9fELOVb5eBoBQ
        E96Qd5XVibeofo8+e1l8ld0ec/Z2GSK+Sg==
X-Google-Smtp-Source: ABdhPJxrfG7dA4djhvtWiGPLR80xL8TuOz4qfjRqrQK3rHBjbuRi8QeR14OuHsnycW9+Okanm3wpfw==
X-Received: by 2002:aa7:82cb:: with SMTP id f11mr5188700pfn.81.1591839638568;
        Wed, 10 Jun 2020 18:40:38 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id q65sm1173385pfc.155.2020.06.10.18.40.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Jun 2020 18:40:38 -0700 (PDT)
Subject: Re: [PATCH] io_uring: add EPOLLEXCLUSIVE flag to aoid thundering herd
 type behavior
To:     Jiufei Xue <jiufei.xue@linux.alibaba.com>, io-uring@vger.kernel.org
Cc:     joseph.qi@linux.alibaba.com
References: <1591769708-55768-1-git-send-email-jiufei.xue@linux.alibaba.com>
 <fba0cf9c-1d9a-52d9-29d9-fce01b0a8a06@kernel.dk>
 <84caca8b-1e34-cc70-c395-c826b7415f35@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <6666d2d5-e85e-57e0-b6a9-077ab20f2340@kernel.dk>
Date:   Wed, 10 Jun 2020 19:40:36 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <84caca8b-1e34-cc70-c395-c826b7415f35@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/10/20 7:36 PM, Jiufei Xue wrote:
> 
> 
> On 2020/6/11 上午8:01, Jens Axboe wrote:
>> On 6/10/20 12:15 AM, Jiufei Xue wrote:
>>> Applications can use this flag to avoid accept thundering herd.
>>
>> So with this, any IORING_OP_POLL_ADD will be exclusive. Seems to me
>> that the other poll path we have could use it too by default, and
>> at that point, we could clean this up (and improve) it further by
>> including that?
>>
> Sorry, I have sent the wrong patch. I think the flag should be determined by
> user, I will send the new version soon.

That's sort of what I assumed as well.

-- 
Jens Axboe

