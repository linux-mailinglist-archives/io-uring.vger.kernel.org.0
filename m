Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D230836D93A
	for <lists+io-uring@lfdr.de>; Wed, 28 Apr 2021 16:06:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231592AbhD1OFr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 28 Apr 2021 10:05:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229900AbhD1OFq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 28 Apr 2021 10:05:46 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90F61C061573
        for <io-uring@vger.kernel.org>; Wed, 28 Apr 2021 07:05:00 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id p2so29338188pgh.4
        for <io-uring@vger.kernel.org>; Wed, 28 Apr 2021 07:05:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=knIvOzTSjvja5G1sGxGdd2w6Ej+cIjw4n5JFBxu+0+4=;
        b=0swoFcUf2Han/KkySa0e9OJvhw+cP8nFuy5gScpqHy5SQw+LBxXEnRpGT11pihLQRM
         nUuaRNohwWC+1Lm54xDfkR4Il82vKP+tHHno6nkZyWmz60nNjOjnvGgDFhZj2y2IN9dI
         NLcBSRsc/fn8uf92LL1rwRHhvnl/9sJORWhWouQneA149Ez2K6jr6CfyMbEFnjTpMJIg
         lgetc7+c78JFTddr+sGSouC0bVyVAzaQLgjta4Zoab9jLCiKqBVkrvAIHquKSHEQS+c8
         w/SjSgXz3BPXa4Uz1gcpo28H0+y5hP+uXOO9xmBQRWCJHwriExEuApNyWOHFg2NrtO4d
         +CAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=knIvOzTSjvja5G1sGxGdd2w6Ej+cIjw4n5JFBxu+0+4=;
        b=SU2WJ7xOczm7k+LMg+l6SgAE9hRfwjiNRsUABUYY99eH0+ysAMbCxa5eYM/W/BbYRA
         0ahFfznFtF4jPo2SMqGRvSj9era2r+wVsMOAXRtXOvRLzo4D9LfK9zqS6iheFC/2LpL2
         lrt5P8LqV6mW9h38lPsnk2xIHY4ioIvI/wiDdYrnWflvHig2NfKYIw5eftW5nezrMBhB
         toFdPfGUfF5J11pIz50pv4oh9mjmIBojtKkADHgbT5/sI63BqJ63tSMod8gY+jMZqeLa
         maxrecXlYuBOf6sv2zuJG66x3o/8lVtZVPfojB9xQueFPRq+6lMP5PtFnRQmsWw+EWBq
         Uhtg==
X-Gm-Message-State: AOAM533CRdfmNtY9uKsoLgIZyqf7NwIiaB0SdYL1JC4AEMyINg9JYjwx
        LKFfu32uTX6QSJYazKjEy3/+sku55ujWUw==
X-Google-Smtp-Source: ABdhPJxt3Yle1ymlZ6ycFNqMOIw3OfvxQniNvAK0lW0bvnOjQkStprngbRO0QL9li/xa14jWj32e9w==
X-Received: by 2002:a63:f608:: with SMTP id m8mr26355973pgh.54.1619618699262;
        Wed, 28 Apr 2021 07:04:59 -0700 (PDT)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id x62sm5251437pfb.71.2021.04.28.07.04.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Apr 2021 07:04:58 -0700 (PDT)
Subject: Re: [PATCH 5.13 0/3] drain rsrc fix
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1619536280.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <b2e4426d-6d0e-0471-e66e-73207c5fd3d0@kernel.dk>
Date:   Wed, 28 Apr 2021 08:04:59 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <cover.1619536280.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/27/21 9:13 AM, Pavel Begunkov wrote:
> 1/3 is a rsrc-related follow up/fix after Hao's drain fix.
> Other two are simple hardening.

Applied, thanks.

-- 
Jens Axboe

