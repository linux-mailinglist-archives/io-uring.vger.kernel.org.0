Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53B0451C7A7
	for <lists+io-uring@lfdr.de>; Thu,  5 May 2022 20:36:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381187AbiEESff (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 5 May 2022 14:35:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385156AbiEESaK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 5 May 2022 14:30:10 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12ED6140DD
        for <io-uring@vger.kernel.org>; Thu,  5 May 2022 11:20:45 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id c14so4290814pfn.2
        for <io-uring@vger.kernel.org>; Thu, 05 May 2022 11:20:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=1wleVqZQjFGRt46QIYxqPep0CD/JCBA/ddZDSj+HddI=;
        b=HN5+C6RfB8Rji1MsNRalF9wxLyomoBX3GImk2iWU2RcgKCVSd+HLDPDA6U3CVNqobx
         LQ4O6fTv9ixniphwKYtBn0GRdyzBYp7m+5Kl9OzdTvx55HdY7lo0V+NIw+uX8S9Z1t+k
         Si6GLcRxA4QvtyYS2hjRH6jyo6VQtFsB9dTqPLxttvmzv42BxaDGzgmgmlivenXvS8s7
         8/1GVeFa+r0sghvXGFPSE3y8nqacKaDL4ABWM5R+++hVFMWzgDLNywyCIK79BW2O3C6y
         ycz+fO+sbS+wbArMe1BAnLwIQVVV1G8InKWU9jyJC9wGkCU3znBaw0xxCfWsVHqQXfuX
         8VCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=1wleVqZQjFGRt46QIYxqPep0CD/JCBA/ddZDSj+HddI=;
        b=fNOZFxXCJt05IoZeZ/G+ILbqcrH8lKeiQFKeWkzxb3Z38U/H+B+wN6EOkbLrnirGTD
         3P/9yNu0bxeXg0amvod/Cl0+OECHYhIQKqJs9qKqTwwVfuFPDCJFuzWRwhZCZQH++tG8
         CVnlhV73gDAKNl0t4fthaQSBqrfRRZXiq4SykIFdORsjnPRY34fv8yecW50dMZoLTQK6
         JFmnSlm3P35Z7mjnEZyYcyiBVcjztVn0G2lVPtTm9oj2oW6NCauFgCZExTQHQGluwfKk
         7uGh/kOQXtvfuF4xhTPF7YT2QXP6ZO2zwdL3bi6k1spAWYeD+OqdDpbO9kt91y/wgDDz
         3zgA==
X-Gm-Message-State: AOAM533oMLTJVu6f3Pa2egVvfAvd3Ect4Lmyyc2V6ESkqIVVRAEWgNg2
        0Sie5agUTe9BIaM/3PazLCKMwQ==
X-Google-Smtp-Source: ABdhPJzv4gHa7MpsIdjCMkM5gCRgVPL0TG5ZiLod7uVPMmwscXff8JCY/HmX8uEPJPGxDurpbscjYg==
X-Received: by 2002:a05:6a00:140f:b0:4e0:6995:9c48 with SMTP id l15-20020a056a00140f00b004e069959c48mr27012945pfu.59.1651774840056;
        Thu, 05 May 2022 11:20:40 -0700 (PDT)
Received: from [192.168.4.166] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id c24-20020a17090aa61800b001cd4989fec6sm5675834pjq.18.2022.05.05.11.20.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 May 2022 11:20:39 -0700 (PDT)
Message-ID: <d99a828b-94ed-97a0-8430-cfb49dd56b74@kernel.dk>
Date:   Thu, 5 May 2022 12:20:37 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH v4 0/5] io_uring passthrough for nvme
Content-Language: en-US
To:     Kanchan Joshi <joshi.k@samsung.com>, hch@lst.de
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        asml.silence@gmail.com, ming.lei@redhat.com, mcgrof@kernel.org,
        shr@fb.com, joshiiitr@gmail.com, anuj20.g@samsung.com,
        gost.dev@samsung.com
References: <CGME20220505061142epcas5p2c943572766bfd5088138fe0f7873c96c@epcas5p2.samsung.com>
 <20220505060616.803816-1-joshi.k@samsung.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220505060616.803816-1-joshi.k@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/5/22 12:06 AM, Kanchan Joshi wrote:
> This iteration is against io_uring-big-sqe brach (linux-block).
> On top of a739b2354 ("io_uring: enable CQE32").
> 
> fio testing branch:
> https://github.com/joshkan/fio/tree/big-cqe-pt.v4

I folded in the suggested changes, the branch is here:

https://git.kernel.dk/cgit/linux-block/log/?h=for-5.19/io_uring-passthrough

I'll try and run the fio test branch, but please take a look and see what
you think.

-- 
Jens Axboe

