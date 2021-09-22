Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CB864149FB
	for <lists+io-uring@lfdr.de>; Wed, 22 Sep 2021 15:00:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230092AbhIVNBp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 22 Sep 2021 09:01:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229969AbhIVNBp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 22 Sep 2021 09:01:45 -0400
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 521F2C061574
        for <io-uring@vger.kernel.org>; Wed, 22 Sep 2021 06:00:15 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id q205so3198765iod.8
        for <io-uring@vger.kernel.org>; Wed, 22 Sep 2021 06:00:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=525EEqu+FWbQcWo2+TUcQLgVs/syE0y5hg62VGR5FSI=;
        b=rl46uXJGD9ELqiTrbo3Rozlm6Ehi3HZT8a67scE6GrP60q8TTA/alKAtVtWmSOy2bu
         xcdeWK/1q9SQtyCeD/xFKFcVxsivbZQiNVj8gfGfJROXghb4ohArhl/dzA4PwYjzcqRd
         qF/uAygVAeJsO7PfXzLZHZw6yvETDoC/+DLDgAvpzozaGvtohqATT2AwROmhI8geY0G1
         20mMiYk+ZxGfCt1vMd83+6SE1ll7pJ++cBbqf4CIQRoL+k+LcGKC0E/NkKhaOyM7KL3e
         LiNg+iNvf2j5ZcfsS3SmJE3Zqa2VYxKPOWfcGXiAUlvyoPoBWOVndZKJ7WPUlMOMauWF
         O9/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=525EEqu+FWbQcWo2+TUcQLgVs/syE0y5hg62VGR5FSI=;
        b=BaXL4hEOLkiE8hzHTufZ13rx0k3WB0sR95bYd7y1RhGfVlv17MaJHO0QdUCTj36Squ
         3FsoXLzux5mZ86xi2FU5QXzZnWJ6tRoY6c1xIlLLtg32coYEhW8vMYwmqmeIOitDwTYD
         0ab1YK0UP70xUkd39PvfiEQWn3otJxfIUN8yDslXBM64llwJJyML3010WyULio144Q5A
         TBgwJpH3vaLlaK+fO2sRp86heMKCloHjNUhtBd6bCP35zzceKv/C3q78IPULSzgpgfTD
         oqL3+B11c/y0Kc9BQl9H1D5gkXEevT0Eo+LqufRv1hcEKJeQpzOscGf32xIsxSyvxz6V
         dbXg==
X-Gm-Message-State: AOAM532JtarPdvFt2zCZEOKjrLPuHwzV+cxlT3rY3/mslb+GVWa/Ja/s
        83gydjDbUvdU79VuuVgiv2z+kToqZKaMLw==
X-Google-Smtp-Source: ABdhPJzLhNlyaoo9Zz4NhLTt7zs4+TsjXNTdUCkKQMnMU9OExS0sjPavbrIuLsI+cEB6EraQe3tXbw==
X-Received: by 2002:a6b:ec03:: with SMTP id c3mr4312505ioh.179.1632315614628;
        Wed, 22 Sep 2021 06:00:14 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id p65sm954005iof.26.2021.09.22.06.00.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Sep 2021 06:00:14 -0700 (PDT)
Subject: Re: [RFC 0/3] improvements for poll requests
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com
References: <20210922123417.2844-1-xiaoguang.wang@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <e630ade9-4a14-3ec5-4dc3-a394ba071f09@kernel.dk>
Date:   Wed, 22 Sep 2021 07:00:11 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210922123417.2844-1-xiaoguang.wang@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/22/21 6:34 AM, Xiaoguang Wang wrote:
> This patchset tries to improve echo_server model based on io_uring's
> IORING_POLL_ADD_MULTI feature.

Nifty, I'll take a look. Can you put the echo server using multishot
somewhere so others can test it too? Maybe it already is, but would be
nice to detail exactly what was run.

-- 
Jens Axboe

