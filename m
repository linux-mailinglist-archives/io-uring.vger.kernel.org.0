Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A085136949B
	for <lists+io-uring@lfdr.de>; Fri, 23 Apr 2021 16:27:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231628AbhDWO1x (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 23 Apr 2021 10:27:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbhDWO1x (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 23 Apr 2021 10:27:53 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1019DC061574
        for <io-uring@vger.kernel.org>; Fri, 23 Apr 2021 07:27:17 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id kb13-20020a17090ae7cdb02901503d67f0beso4585172pjb.0
        for <io-uring@vger.kernel.org>; Fri, 23 Apr 2021 07:27:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=I/sCEjAn1KcweuUrqcZNHBunhc8WDdErjIFPx+v1zoM=;
        b=ZlwDFTSb7pX1TWIfECxM8+vjMJQECFtUoiiwdLGhz2z1M42CBrpc/xCFj00V+8Cz2E
         R40FQ35gouCNVRjWu0yT9sQsMbqbzTOpVhbjekRs+CESohSCscYClKq1IY59qvRGEsWH
         LbeYGMBFFFSBVAA6sRjzhZFvw4fH16B4Q1Gw3UimflCubQAs5XbZKjSzdkjFQR57YDK7
         FsykLPKmPWZxok11MNNlQtT9jgExdXZ5OYoP0UYnkbS3MBiNvNhaNiWiBFICYRMCQAq8
         VJUkc2NjoLa25SxteaOp1vD0O3416iyosdRcnA0HozOwKLxyu+MCnlGS2ilETe/dKnxI
         MA+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=I/sCEjAn1KcweuUrqcZNHBunhc8WDdErjIFPx+v1zoM=;
        b=FG3AUHHeZw7spsL2ZGbdF8P3uRLq47T82zSn60yXzoW3s/LMIFn9QuummFACK26Fen
         JLoBSuir+xQ5+GtT0KgcxzD4Y8gCtXeA1S/Ef5EUyXqD5oN0J5EBH7pgEfEssXw2KEgO
         653Tobv55oNMN48JV+wueGvM7Ayks8NO3PkUayBVwnWztSwN1aOcec7kZlD3Q6o9yaHy
         5wW57j675t2v2NPKw7QhPctBgMHKYorO58OLHEOGU/hSzewVpWj4cSf/OtdYmz3XmAjm
         b35jZBT8k3gDBj4cOaAu1dXd4iHEHqETqcM0WkrzZjfszAqpuH6sJ7Htge/Jy984Zsan
         TjMg==
X-Gm-Message-State: AOAM533aPK/84S8vVyfCDieFfBAphdM+a/il6MI+/wR3RcMqnXTnANt0
        bzLIlI92G6C5tfnwD7Dqpp4xGQ==
X-Google-Smtp-Source: ABdhPJyzMQGTfgRqe82Pe9e6I38mVIPoAwhcYRyczop+J2cU+sFIeXTiW7+sNLM4R1cN1XhIwNuLAg==
X-Received: by 2002:a17:90a:c501:: with SMTP id k1mr4673079pjt.101.1619188036616;
        Fri, 23 Apr 2021 07:27:16 -0700 (PDT)
Received: from ?IPv6:2600:380:497c:70df:6bb6:caf7:996c:9229? ([2600:380:497c:70df:6bb6:caf7:996c:9229])
        by smtp.gmail.com with ESMTPSA id o127sm5114524pfd.147.2021.04.23.07.27.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Apr 2021 07:27:15 -0700 (PDT)
Subject: Re: [PATCH] io_uring: check sqring and iopoll_list before shedule
To:     Hao Xu <haoxu@linux.alibaba.com>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
References: <1619018351-75883-1-git-send-email-haoxu@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <3f897cae-028b-0728-1473-5f6a08877745@kernel.dk>
Date:   Fri, 23 Apr 2021 08:27:17 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1619018351-75883-1-git-send-email-haoxu@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/21/21 9:19 AM, Hao Xu wrote:
> do this to avoid race below:
> 
>          userspace                         kernel
> 
>                                |  check sqring and iopoll_list
> submit sqe                     |
> check IORING_SQ_NEED_WAKEUP    |
> (which is not set)    |        |
>                                |  set IORING_SQ_NEED_WAKEUP
> wait cqe                       |  schedule(never wakeup again)

Applied, thanks.

-- 
Jens Axboe

