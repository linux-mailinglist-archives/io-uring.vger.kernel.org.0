Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D118F414D5F
	for <lists+io-uring@lfdr.de>; Wed, 22 Sep 2021 17:51:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231712AbhIVPxC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 22 Sep 2021 11:53:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236484AbhIVPxB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 22 Sep 2021 11:53:01 -0400
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56D64C061574
        for <io-uring@vger.kernel.org>; Wed, 22 Sep 2021 08:51:31 -0700 (PDT)
Received: by mail-io1-xd2c.google.com with SMTP id q3so3994574iot.3
        for <io-uring@vger.kernel.org>; Wed, 22 Sep 2021 08:51:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=NNoniwPM+EYYtowb3pj0Cdng0l4936673rUFKZ/IzcQ=;
        b=7Mst6AynbNg1z1IzjKNtbREyuAkHbwobKjMObJbYb9ab76ppdq81sDna1onNJa4bXG
         n8JAS96NLQy/FtpLEhW1PYkCVpMMHQzJN1LsVzzYoBff2qRwP/oqOwcNgwzmH4bbN1tE
         ZqzUSknPWj90cfj80J4M+B47PVBIEUbZ2c8x6j9nkB/SD6MRXWDt4GuDOSETlhMgyc/B
         2nMj+HabpMZd1oHDJzpYbL/mP3789/RC3o9E5WBEkLMQGQaY/JQUMvL8eoetyhvDPhoE
         dHFOQYeI7ccalKwAU5muqcq5wwbu/vz6t0ScNkNN+TC3j719PPfJP52Wu0Uh5iYYlQgC
         V8rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NNoniwPM+EYYtowb3pj0Cdng0l4936673rUFKZ/IzcQ=;
        b=zG1McQc+UyW1wkePD4Ho3k1z312nvYNFxKzbEJB0KXZVVdz5/yoArhusgXsUONoMvN
         vC1nkAebtbDFYCA2mmIXxXclg/VCI0WyR0+9EZcZoysecme8uVaFQE0Z/B/p4Chcj7Gi
         yi9BQOrqaQu1FqJFZq6NFpfu6WMMeZGJwCNw0DnOdL8kq5X0PrKhRkYL102vq+Qd4WVI
         6Im4TGFH+1O9JOzEZokZSI86YCp7EaiJyotudaLL9VYP4agiRDS/72hhAftnRhuQBQYr
         NX6RJ5PUFoNjoKX6N8W+V1zXsv1i3hnAAOdfitAfCZ0RN5F/2VQBOtvHj2JV293H0aAc
         9oJg==
X-Gm-Message-State: AOAM533MO+ZNZhzyVbAzv4DkyKAuqtoeo9nCmOBZwq2X0Rz1qFfOIzrY
        B2MZDv0OWpvS4OLXU/0i4MhOEw==
X-Google-Smtp-Source: ABdhPJxiC5hTaqIgFMMYBN5vq7IIc8hL+tvWJxkPtPTILVsHxoaNOVSvFBGcVz29kiuowdcC822e5A==
X-Received: by 2002:a5e:db44:: with SMTP id r4mr291119iop.56.1632325890387;
        Wed, 22 Sep 2021 08:51:30 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id o11sm1277982ilu.0.2021.09.22.08.51.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Sep 2021 08:51:30 -0700 (PDT)
Subject: Re: [PATCH] io_uring: return boolean value for io_alloc_async_data
To:     Hao Xu <haoxu@linux.alibaba.com>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20210922101522.9179-1-haoxu@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <5aa39c69-331f-0b29-ad94-11001821bacf@kernel.dk>
Date:   Wed, 22 Sep 2021 09:51:29 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210922101522.9179-1-haoxu@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/22/21 4:15 AM, Hao Xu wrote:
> boolean value is good enough for io_alloc_async_data.

Applied for 5.16, thanks.

-- 
Jens Axboe

