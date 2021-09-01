Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BECF3FE03C
	for <lists+io-uring@lfdr.de>; Wed,  1 Sep 2021 18:42:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344108AbhIAQne (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 1 Sep 2021 12:43:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245469AbhIAQnd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 1 Sep 2021 12:43:33 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9A39C061575;
        Wed,  1 Sep 2021 09:42:36 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id c6so2290300pjv.1;
        Wed, 01 Sep 2021 09:42:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=I/12n8rMfk8oX95Dp/kXhDB9zSufOAz0gOizwOSygwA=;
        b=H7mNS9HMvgMOWRHP97ycjoSDuuEtjVdJIYCUlqa2c0NCNb2NsE4kulK1Mxf2TgcFD4
         J9DHpdMgW5jd9BeLaFDF14Cm0vkRYHdEQaNyuKHjPKX8n87v4jmj4ZDlnLUjjf5eh8sv
         MpwaozggVg9f4wmh0aQA0RvlhAa0nyprm8O45fPcshfXZPd7uRyn9/ZrxMwtule0d7le
         XnxkMgJdyNlwI1lIy6V+ieBs6QyWgmFHgfdQho3Y9mLMYrIn8eIzW90i/uG+oMljT2q/
         xkj27W3WnoA+uPu0AirIYiUeNUy4BR+fQvJK+lADfxrX0PIFZZTjGk5kEV1mwUJ7996J
         Kwqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=I/12n8rMfk8oX95Dp/kXhDB9zSufOAz0gOizwOSygwA=;
        b=dpZ1Od5FB91rUrkt7WASdhXOfS3m9rdFryD56vaWdXMOFm4VNd5mMPB94MfeCyxZD5
         6cB6SwuQz+wtahkwQsQZBlmH9/tlaEfk+VFMbVX6y8Rjdfet0ZZxolyNty1nphuJ93Ly
         sYgJ67vbVVsMvfW5M4unjwuOdVMKC719R6Thf3vcL9wDFFTqHZF6zyvyhunusSKq/eWS
         2xlBChD+nqZScdEXaQ8/GIEmYeB4d2rpEYi29I6fiW9D5u17LuGToF9mtKzbMLu5tA5E
         n4/neth1hTfiyEpoO29LTVkyWwIaGnkZYroh8vaiPzWgPnH3P6nM1+Z7KYcOvPM1HRhB
         Dexg==
X-Gm-Message-State: AOAM5305vmviJJi6kloFzN6eJ40nxS8eDUi8C6NT4hEiTqpPBhiuqT5V
        nIJq5WXV/yoeN8x161hfT7U=
X-Google-Smtp-Source: ABdhPJzQwcGeUv6/mkm0HcKNwdhxquuR3Ys6NzfG789VsUTUjIAf7wjiWW3ti7i6eH/Nu8hLdq1VrA==
X-Received: by 2002:a17:90a:680c:: with SMTP id p12mr219664pjj.33.1630514556035;
        Wed, 01 Sep 2021 09:42:36 -0700 (PDT)
Received: from localhost (2603-800c-1a02-1bae-e24f-43ff-fee6-449f.res6.spectrum.com. [2603:800c:1a02:1bae:e24f:43ff:fee6:449f])
        by smtp.gmail.com with ESMTPSA id 21sm39762pfh.103.2021.09.01.09.42.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Sep 2021 09:42:35 -0700 (PDT)
Sender: Tejun Heo <htejun@gmail.com>
Date:   Wed, 1 Sep 2021 06:42:34 -1000
From:   Tejun Heo <tj@kernel.org>
To:     Hao Xu <haoxu@linux.alibaba.com>
Cc:     Jens Axboe <axboe@kernel.dk>, Zefan Li <lizefan.x@bytedance.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org, cgroups@vger.kernel.org,
        Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: Re: [PATCH 2/2] io_uring: consider cgroup setting when binding
 sqpoll cpu
Message-ID: <YS+teuBxFf4FDR2Z@slm.duckdns.org>
References: <20210901124322.164238-1-haoxu@linux.alibaba.com>
 <20210901124322.164238-3-haoxu@linux.alibaba.com>
 <YS+tPq1eiQLx4P3M@slm.duckdns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YS+tPq1eiQLx4P3M@slm.duckdns.org>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Sep 01, 2021 at 06:41:34AM -1000, Tejun Heo wrote:
> I don't know what the intended behavior here should be and we haven't been
                                                                ^
                                                                have
> pretty bad at defining reasonable behavior around cpu hotplug, so it'd
> probably be worthwhile to consider what the behavior should be.

-- 
tejun
