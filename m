Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 024A24364AB
	for <lists+io-uring@lfdr.de>; Thu, 21 Oct 2021 16:47:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231485AbhJUOuA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 21 Oct 2021 10:50:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230072AbhJUOuA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 21 Oct 2021 10:50:00 -0400
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA9B8C0613B9
        for <io-uring@vger.kernel.org>; Thu, 21 Oct 2021 07:47:43 -0700 (PDT)
Received: by mail-ot1-x32a.google.com with SMTP id g62-20020a9d2dc4000000b0054752cfbc59so738067otb.1
        for <io-uring@vger.kernel.org>; Thu, 21 Oct 2021 07:47:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=jXozmuCxICQlBiW4FrmKg95k472yQ4RnrKN8/1rkH/c=;
        b=g6fQWHnf+GWX8RSUw+0MiEuXTId32zKGXElHdXNbe6t5lnqh3y0QUN2L07TXytKc7X
         7vsLCQVZD8zY+/3QE2jKU3T/G22aXYZwzFVO1aEHJnokZxO1gYRDdaxBAg4CQQT/2fRY
         nvYq752+Kc4mCwxuRIOeJsLt6ze504AhLc9nDXo1ZDUtL7GXEyd2CCgmX22dgstkNfnG
         ZNkitcenmeumCTUXxRE4j12dk9XM1nGxg0T1a/78GqC2rlryNKFGeVfkShB1uHodCe77
         /kFAJS5hnp+fxMqSFfRS/mMr7ClFS+i4KJfMBFamMyYep8jORDTsOnA5pBoszrNLAdYA
         UN8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jXozmuCxICQlBiW4FrmKg95k472yQ4RnrKN8/1rkH/c=;
        b=tgZwoTpnxAy3IlQHzlidRHuXM8xRcdO8RaU7XD44mSjaSwGQYOSrlgVAqHGZTGpfxQ
         pD5XB5Lslf0QXlNJ/4vRLqy2aec5x3Dr9Rey7M9IYWPToVSkIaaNSURNxYPVSbk9i+6g
         sR9XrYjrPPLWB4jV4akg4bWO0uZPXJtFOuKDHZLaBXwsS+PtNEwI3o1xCgnHY7jsVkpj
         na9sqaibAGS7sjIU3hc5KKpzFJptBt94vMo+BGl8Os3B/PU1da2C3Y6Pc6v8lg/tyFJT
         5wXpIohT+eWA98w7TCV95IGNsBvfuj77PuKWEMW6E0C2wlR4yRZtQY0XWoAHRxzS6F6/
         lf7g==
X-Gm-Message-State: AOAM530CbOkOwqnQzZGcrRyWhfuJuKcY50M/1eOblAfBoz2JX5q88DwI
        a2vAvJtCl39SdM5Nkne0B4yIYg==
X-Google-Smtp-Source: ABdhPJwzqkDS4pkd+h8zOpQlIeaey+YOTWxKGCO/ZJ4JhkTeAHwiVAdnIToqsWuERa98aqj9sCdtTg==
X-Received: by 2002:a05:6830:101:: with SMTP id i1mr5014184otp.107.1634827663254;
        Thu, 21 Oct 2021 07:47:43 -0700 (PDT)
Received: from ?IPv6:2600:380:783a:c43c:af64:c142:4db7:63ac? ([2600:380:783a:c43c:af64:c142:4db7:63ac])
        by smtp.gmail.com with ESMTPSA id v13sm1129065otn.41.2021.10.21.07.47.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Oct 2021 07:47:42 -0700 (PDT)
Subject: Re: [PATCH v2 0/2] improvements for poll requests
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com
References: <20210924042224.8061-1-xiaoguang.wang@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <eb2b4968-f520-1037-7c1e-491e70faae46@kernel.dk>
Date:   Thu, 21 Oct 2021 08:47:40 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210924042224.8061-1-xiaoguang.wang@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/23/21 10:22 PM, Xiaoguang Wang wrote:
> Echo_server codes can be clone from:
> https://codeup.openanolis.cn/codeup/storage/io_uring-echo-server.git
> branch is xiaoguangwang/io_uring_multishot. There is a simple HOWTO
> in this repository.
> 
> Usage:
> In server: port 10016, 1000 connections, packet size 16 bytes, and
> enable fixed files.
>   taskset -c 10 io_uring_echo_server_multi_shot  -f -p 10016 -n 1000 -l 16
> 
> In client:
>   taskset -c 13,14,15,16 ./echo -addr 11.238.147.21:10016 -n 1000 -size 16
> 
> Before this patchset, the tps is like below:
> 1:15:53 req: 1430425, req/s: 286084.693
> 11:15:58 req: 1426021, req/s: 285204.079
> 11:16:03 req: 1416761, req/s: 283352.146
> 11:16:08 req: 1417969, req/s: 283165.637
> 11:16:13 req: 1424591, req/s: 285349.915
> 11:16:18 req: 1418706, req/s: 283738.725
> 11:16:23 req: 1411988, req/s: 282399.052
> 11:16:28 req: 1419097, req/s: 283820.477
> 11:16:33 req: 1417816, req/s: 283563.262
> 11:16:38 req: 1422461, req/s: 284491.702
> 11:16:43 req: 1418176, req/s: 283635.327
> 11:16:48 req: 1414525, req/s: 282905.276
> 11:16:53 req: 1415624, req/s: 283124.140
> 11:16:58 req: 1426435, req/s: 284970.486
> 
> with this patchset:
> 2021/09/24 11:10:01 start to do client
> 11:10:06 req: 1444979, req/s: 288995.300
> 11:10:11 req: 1442559, req/s: 288511.689
> 11:10:16 req: 1427253, req/s: 285450.390
> 11:10:21 req: 1445236, req/s: 288349.853
> 11:10:26 req: 1423949, req/s: 285480.941
> 11:10:31 req: 1445304, req/s: 289060.815
> 11:10:36 req: 1441036, req/s: 288207.119
> 11:10:41 req: 1441117, req/s: 288220.695
> 11:10:46 req: 1441451, req/s: 288292.731
> 11:10:51 req: 1438801, req/s: 287759.157
> 11:10:56 req: 1433227, req/s: 286646.338
> 11:11:01 req: 1438307, req/s: 287661.577
> 
> about 1.3% tps improvements.
> 
> Changes in v2:
>   I dropped the poll request completion batching patch in V1, since
> it shows performance fluctuations, hard to say whether it's useful.

Sorry for being slow on this one. Can you resend it against
for-5.16/io_uring? It no longer applies. Thanks!

-- 
Jens Axboe

