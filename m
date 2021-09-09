Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B69FF4058F5
	for <lists+io-uring@lfdr.de>; Thu,  9 Sep 2021 16:25:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244132AbhIIOZw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 9 Sep 2021 10:25:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346523AbhIIOZp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 9 Sep 2021 10:25:45 -0400
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E90D1C120D6C
        for <io-uring@vger.kernel.org>; Thu,  9 Sep 2021 05:57:56 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id q3so2139821iot.3
        for <io-uring@vger.kernel.org>; Thu, 09 Sep 2021 05:57:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=VABmEG9b9K7KXMKEdsbtO2AOGOUleVs4LvAhMORUX6E=;
        b=ro8g0AP+rDSc1PNvQkS0QzyuWk2q4bv+IuvUU0Kv5+1IdDBa4MXGke6rvq0f75eAD5
         qg5YDixkF6ZiHf/3SknIZvlay4JhKnu9nVa3ByvwussmpZAeMK6AjqE32K1DgeHUVh4S
         dpb5KnWxtrWlhEEe7rp3xeIuJjhplRejg+AL2XFaU89iYBevIEbUD0YOWPqaeuM/7HgU
         08nKAG9GcDPkFKt2XuOt/HtCyP/d2q1PzrnhJdty48QG8nxIGhRyyn1f1qaqSvZyqRuS
         SrfpdPZtSx/cEDFYR2eVZaA0U8GrjbHb98vAfMYdQgFbURmP4dJo6Uu6f/oSobWEuVa7
         03kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VABmEG9b9K7KXMKEdsbtO2AOGOUleVs4LvAhMORUX6E=;
        b=4odtm0yCIFcY42sVgme9OXPVYJ/a8qNhusnDz1tqcBBk9+m3qS8dM5kXf2Gs6YhNxc
         HYSsknQK8Ps+oIu6S49zPa2tWBQECPbx9WVIs1uyYF7cgEF0uabvY+5K9+ZXYcYgCiMN
         fh6CCHKj77HELI3n6CdZIK4lvGnjeHtBJGRgKvE4SxZHuT9kdDnvrvgzc1yomqh+UMUl
         aCcpauzuX8ePvwIBo1gni8WouY/C5y/ZuPWTuZXhYJYTuTcYAYpkOfTcPd9m+LJHZe9Z
         IO98fpAqJQNK/LCsRpWF41TpcGf3ilhaxeN/ln0wy/GX0gixJHOIcAsabDucrd78Bf7n
         7bEg==
X-Gm-Message-State: AOAM531bHguTK14xZ4PpgMymWEY95pKPajfJn9oVlF3Zw6culvx/2xt2
        cQ3p/1vz95Wouys1sNldfDKTy06+Iq19RA==
X-Google-Smtp-Source: ABdhPJwWwtIGL3uLWf+cRwo9kITAX63JjUoalJAS4GbBVuc0Y7ZWSZITO0CF6S40w62XoRRmav17Gg==
X-Received: by 2002:a05:6638:2482:: with SMTP id x2mr2755705jat.15.1631192276382;
        Thu, 09 Sep 2021 05:57:56 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id n12sm824027ili.63.2021.09.09.05.57.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Sep 2021 05:57:56 -0700 (PDT)
Subject: Re: [PATCH] io-wq: fix memory leak in create_io_worker()
To:     Hao Xu <haoxu@linux.alibaba.com>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20210909040507.82711-1-haoxu@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <d3351ea9-5389-1cd9-ba11-5df4c030f87b@kernel.dk>
Date:   Thu, 9 Sep 2021 06:57:55 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210909040507.82711-1-haoxu@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/8/21 10:05 PM, Hao Xu wrote:
> We should free memory the variable worker point to in fail path.

I think this one is missing a few paths where it can also happen, once
punted.

-- 
Jens Axboe

