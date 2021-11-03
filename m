Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32EC944416D
	for <lists+io-uring@lfdr.de>; Wed,  3 Nov 2021 13:24:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231869AbhKCM1E (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 3 Nov 2021 08:27:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232098AbhKCM0y (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 3 Nov 2021 08:26:54 -0400
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A8B4C0432C8
        for <io-uring@vger.kernel.org>; Wed,  3 Nov 2021 05:23:05 -0700 (PDT)
Received: by mail-io1-xd33.google.com with SMTP id n128so2439154iod.9
        for <io-uring@vger.kernel.org>; Wed, 03 Nov 2021 05:23:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=DrOhpIctO7PhQ7YDylmNaRziU4qxlandQOuzAvwA6Gg=;
        b=nzGiv4ff8p/vtNP+vuCrSxOs+ifVucT0lJ2It127pujtvQ2kAQTQvAOa9y0diqhUju
         zND+EZV0/yNoV6BgW5TzHyxd5SuMRNzVeuBUSqQQaalC1S0X+g0F7pJMZL3LH8znwSSh
         0cGGZzCPrjDxLKe/JNmWJukAFCy5pXl/FAzd2w9t3YTe1zC/jQWP/RbKd8UnCUQKU3Wb
         VVq7BZ81KqY1aVXHqOkXwSx6aVHxcA8/rVJDXfkl5E5k+l6ddoKpF/1IRwr0KauIqnJj
         YWVS+U5GHmzyJTk8I83BweLDaU5VwC7Ji7BRRwFOdYln8M0eI8kRzMeyHflCnfoX9M5X
         djuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DrOhpIctO7PhQ7YDylmNaRziU4qxlandQOuzAvwA6Gg=;
        b=3BK7pNbL8NBGkujgzKuvAsyWs+/mDBeRcY0mfB/ChOknNnA7egOL+RFKVKXf2UdPsW
         GJpgKzH8cvlpzpWtaQx/9klNjbyz0SgIEb/3vjqN1GYOI50kigW798Essc8v/w7M7oyI
         OKE2WPHlgf7Z3ftQUu1uk5i2Wz39ujaMv0S3zUVaRYj5Ij+sYjdeplM7vv/oYxAPlxD3
         4PTeCvtP2A3wDcWVKtQpFn3O31zm+YGXCi8Psyo89Xdi4CVBIh1HARumqEMe7Rsu7VPJ
         AyPNTgXaWVIMmP98GnmiPFS3uqTQ/iiIWD5WQygND7vS7k1s3aCShon9Ok1nTVjZWYEI
         7Ddw==
X-Gm-Message-State: AOAM532cA7PNjVkjyEBzbg+qUX/hSvzbUnuVWVkfgyyYZECNd9ki/tnA
        yeChFI8Vfdv87WBTRkM5b27pqg==
X-Google-Smtp-Source: ABdhPJzPiGS7fdjlMQ39eXTDd0OEScccbJemtK8GqutFnWINWUSFcROHYqM1VuqXLzgbXWP3XkDz2Q==
X-Received: by 2002:a02:cb42:: with SMTP id k2mr18747570jap.25.1635942184737;
        Wed, 03 Nov 2021 05:23:04 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id q1sm1028716ilc.88.2021.11.03.05.23.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Nov 2021 05:23:04 -0700 (PDT)
Subject: Re: [RFC] io-wq: decouple work_list protection from the big wqe->lock
To:     Hao Xu <haoxu@linux.alibaba.com>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20211031104945.224024-1-haoxu@linux.alibaba.com>
 <153b3bed-7aea-d4bb-1e5b-ffe11e8aabc1@linux.alibaba.com>
 <3c633538-7469-dc8c-561f-9fed7bfa699e@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <ef805eea-7e90-9782-d59c-dff349d17490@kernel.dk>
Date:   Wed, 3 Nov 2021 06:22:58 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <3c633538-7469-dc8c-561f-9fed7bfa699e@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 11/3/21 6:17 AM, Hao Xu wrote:
> ping this one.

I'll take a look at it, we do have some locking concerns here that would
be nice to alleviate. But given that the patch came in right before the
merge window, probably too late for 5.16 and I put it on the backburner
a bit to tend to other items that were more pressing.

-- 
Jens Axboe

