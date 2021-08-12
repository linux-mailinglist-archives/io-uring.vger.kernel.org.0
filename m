Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 370443EA6D2
	for <lists+io-uring@lfdr.de>; Thu, 12 Aug 2021 16:52:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238170AbhHLOwy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 12 Aug 2021 10:52:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236114AbhHLOwv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 12 Aug 2021 10:52:51 -0400
Received: from mail-oi1-x230.google.com (mail-oi1-x230.google.com [IPv6:2607:f8b0:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 939E9C061756
        for <io-uring@vger.kernel.org>; Thu, 12 Aug 2021 07:52:26 -0700 (PDT)
Received: by mail-oi1-x230.google.com with SMTP id u10so10754034oiw.4
        for <io-uring@vger.kernel.org>; Thu, 12 Aug 2021 07:52:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=GDmYv7hJX4PL/KMS0FEdgYmGuDsOaSNUuRLd8J0CAMs=;
        b=wFKHfwOcKyh7hN0JZhMbxZ97EoW+HAacl/8QbfDgAew5UGwh7NsVCDrPJ4xGVk3jTA
         djngAUq0ETRJV3jj33OeCX0FJlvn8mjPiDNoUrqGYV+M0R2w1AKIdvagLLDtYDor0054
         KcvOgzBwMr04BYG8W98u6ChZY4mL7XtCBW/weUL2RpOalxj+wEINM6Z58Pr3zd4l6r0c
         iLGLeH0dvumdNaFTRoJTAPiKJ4kgMqCCKNoMMNHjj8bzkcz/7AeBPXDLp7zNQG4qz7rA
         D5xiZ/+c0E6PRmz4oe03hOMgbWLlIRlriua+Z6XH9+/386d/kN9KtRnJjYW8aHqAXMnG
         kW7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GDmYv7hJX4PL/KMS0FEdgYmGuDsOaSNUuRLd8J0CAMs=;
        b=SaCeYah08fh3vSLZwdgFaJJcAJjwRuazIJOh+GxezC5o4oRtqU3qljVV2b3BOxOdFx
         F7m248GgCKEzsDo8bsK56AYLMUMQs8SlOMherz9dAhCyRA2rlUhEF/EOaIPpL4hC/fOS
         QzvHrQAK1kR4cAETWQ5c4uMSMvwAbvWqsAND7g6Mpi2IVQbpIGoNHUxYi3cBkKpq1Jhw
         U7KSvJFiBMnym44aJ+G/bY1reVFfI+NDnblnrjZDd/Q1WFi9bfYFjrXzlGIMeSfj+eod
         tppbx7CTGGba5zgLBPJRdK2tohxuzp3yMeHJxkMi3UoJn3+ZwO33PpPHQWN/AVNZ083Y
         ig6w==
X-Gm-Message-State: AOAM530brsQ6Sx7hOrIW75wNSX7+NRfTVn1zYP7TKw1oCLxKJYsJT7L/
        kGZ9QrY4YLrXMQufWVkb/bxKOA==
X-Google-Smtp-Source: ABdhPJzE5vOhU6C/TvtIpSKRSYqo6cQuY7IPne7vtwJ+ViOWzZNok5UlQWdhFWdRjpyFfgVo8yIsRg==
X-Received: by 2002:a05:6808:641:: with SMTP id z1mr12334669oih.108.1628779945982;
        Thu, 12 Aug 2021 07:52:25 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id h17sm644489otl.74.2021.08.12.07.52.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Aug 2021 07:52:25 -0700 (PDT)
Subject: Re: [PATCH 6/6] block: enable use of bio allocation cache
To:     Christoph Hellwig <hch@infradead.org>
Cc:     io-uring@vger.kernel.org, linux-block@vger.kernel.org
References: <20210811193533.766613-1-axboe@kernel.dk>
 <20210811193533.766613-7-axboe@kernel.dk> <YRTH5T6R7PMpWaBF@infradead.org>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <ba6e8ca0-1220-4051-e599-c693465eb6a5@kernel.dk>
Date:   Thu, 12 Aug 2021 08:52:23 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <YRTH5T6R7PMpWaBF@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/12/21 1:04 AM, Christoph Hellwig wrote:
> On Wed, Aug 11, 2021 at 01:35:33PM -0600, Jens Axboe wrote:
>> Initialize the bio_set used for IO with per-cpu bio caching enabled,
>> and use the new bio_alloc_kiocb() helper to dip into that cache.
>>
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> 
> This seems to be pretty much my patch as-is..

It is, sorry I'll fix the attribution.

-- 
Jens Axboe

