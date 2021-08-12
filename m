Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC4C13E9BA6
	for <lists+io-uring@lfdr.de>; Thu, 12 Aug 2021 02:35:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231901AbhHLAfY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 11 Aug 2021 20:35:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231649AbhHLAfY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 11 Aug 2021 20:35:24 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 315EFC061765
        for <io-uring@vger.kernel.org>; Wed, 11 Aug 2021 17:35:00 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id a8so6447861pjk.4
        for <io-uring@vger.kernel.org>; Wed, 11 Aug 2021 17:35:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=ocUIRncY2FfPzn11jfLmEgUcnvvcOnjFuPvVkm7GVio=;
        b=DCVvqTws7MpyNabHEkOPQGT0qn5c5YZpPC219L6GEGhdA7umKsHppQ2odmqX2yRCjh
         XbXE5VH9PJ5FdMvhvHUrY195T5T1ITk+YtDLhvSxwA00Lv/QGC0MY6PG4j4dk7Vm8sm5
         DDz+OvsG/8XWHd/YQ+cPDAgrn0GIHXASeh/Exsuy6NJXbsV6xucSsRhX0itfaF8en8Vi
         TgsB5B8OQ3bTcj1yO5Qa2oB00inQiEX0PrwoYSrrCiCc55gaKF7/puFtgPJbM4HvZTG0
         Jx/yjuToXO0jRNsfDswsd/D6d3H8MeNWwnTTPfRhVCvgkkNh5Zq+H3NS+WSpnKsQmzLe
         72GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ocUIRncY2FfPzn11jfLmEgUcnvvcOnjFuPvVkm7GVio=;
        b=i6OYAFk/e8dO5x8LVJfjeJeOb1WBofL2qnftTx7JlXo7eIloTdWRhpPGCJ14X3CVz5
         Dd08Utu3cVPJV9BhMzRXzQ6BzsQ9J+PPhicAt237h3JYnCwLpRSxBc2bsOOVVM0WozMe
         TZDMW+PqQmmKu0oCcE8o50s98UcTEDLhLJ9Rh89NR4JqV3tTTnhChT3DfgKBQK9iRXwX
         CCezRib+EAc/Wnne+wDAQlngELodHelDqoxUj0rKvXoFnMac4m3uw+HLL5T7EekUcUf6
         Q3on6AwEcMroO8sV28h8OeavrVCMJcXxsBtlpGWtAuZsWE+rUXULg877nbKK4wsgzM4O
         dw1w==
X-Gm-Message-State: AOAM5330P8yUAhOIrae1AoA2BQ31bHqUt/KkQkjn/GBBjrNEDGvDo7jc
        FgX31b61cHKT+BdUrpzEKarzp6r1dTXM/nbi
X-Google-Smtp-Source: ABdhPJzt5KKSVUI3t7zk7cTJpqavz2+9oyw/N4IY3QrQkbbom6HcHAyCERB/sUzPn9iG659ZDvfbpg==
X-Received: by 2002:a17:90a:fa3:: with SMTP id 32mr13734984pjz.68.1628728499378;
        Wed, 11 Aug 2021 17:34:59 -0700 (PDT)
Received: from ?IPv6:2620:10d:c085:21e1::1569? ([2620:10d:c090:400::5:2cf3])
        by smtp.gmail.com with ESMTPSA id c21sm758043pfo.193.2021.08.11.17.34.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Aug 2021 17:34:58 -0700 (PDT)
Subject: Re: [PATCH v2 0/5] skip request refcounting
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1628705069.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <908f9da2-7877-0400-2f0e-b0447b677595@kernel.dk>
Date:   Wed, 11 Aug 2021 18:34:57 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <cover.1628705069.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/11/21 12:28 PM, Pavel Begunkov wrote:
> With some tricks, we can avoid refcounting in most of the cases and
> so save on atomics. 1-2 are simple preparations and 3-4 are the meat.
> 5/5 is a hint to the compiler, which stopped to similarly optimise it
> as is.
> 
> Jens tried out a prototype before, apparently it gave ~3% win for
> the default read test. Not much has changed since then, so I'd
> expect same result, and also hope that it should be of even greater
> benefit to multithreaded workloads.
> 
> The previous version had a flaw, so it was decided to move all
> completions out of IRQ and base on that assumption. On top of
> io_uring-irq branch.

This is really nice, both in terms of how the series is laid out,
but also the reasoning behind it. I can't shoot any immediate holes
in it, let's get it queued for 5.15.

-- 
Jens Axboe

