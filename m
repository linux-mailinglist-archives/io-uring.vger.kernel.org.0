Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C090C40BCFA
	for <lists+io-uring@lfdr.de>; Wed, 15 Sep 2021 03:14:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231770AbhIOBPV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Sep 2021 21:15:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231865AbhIOBPU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 14 Sep 2021 21:15:20 -0400
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E562CC061574
        for <io-uring@vger.kernel.org>; Tue, 14 Sep 2021 18:14:02 -0700 (PDT)
Received: by mail-io1-xd35.google.com with SMTP id j18so1285440ioj.8
        for <io-uring@vger.kernel.org>; Tue, 14 Sep 2021 18:14:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=3Khs5aZZOAa0vkghDAwrJLJLlL2og03vwiD5udEW5iw=;
        b=Tz8iDgW3Doij9oqTy9X3oWWJ8zj/shdOBFPKA1XezfTYCLp5SfIxJi2e4/xzUWZUBG
         PhVAd8MOo0gjrgZzVu0MVFh14zWm7yOolc9BRIB7AN/qBSMfb5ZB+2vDxyKJ00nGA+g9
         XQRGwUbtluJIt8SBXfRRX7z8CaHUEn3VWCxsDY4H3ajrFRDd6G3EPAyusfU6m9myb5gT
         ecJw+QfWibilbKvsmiSezWMGuSmjWbWL0PhPqz4qASqBY98imegm78AuKm29nF7xEFTM
         cmVlpcNQRmcMHhv/AVQyvS3mTE2w2CAxJK2DzxZYoTIVgv+5DrAMGJab7+4i2GVrStdg
         KTVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3Khs5aZZOAa0vkghDAwrJLJLlL2og03vwiD5udEW5iw=;
        b=JtHNrRFeXJSCw4p6sNuPxvIagagZobX7i93jFAD78C+8HkqQtNQLWWHi6tGyd+w6Vc
         uO5wS62IcmBG2JXNgWIYJNW14LAyoLlzrDL7V/Peqomljm/eu+lWdvYq5tpP/Yljq2hq
         VbzbN/t6fh2J2u7gHxZZkWSS21hHk79zYyPtHvBCV+0g/8XxWg4u8lyaYP7+7GQBcWYe
         AH06QjJt6yPhoQCT4BryDwnRRYhy+gOdfQJdw9JpA0+Io1rHEC2CdGzfoi7HTpwlMr+U
         mU96zzFo8jK4AuzsW7SqDgFHBmXYSiCAYm1G+dcq23IMYZoALKWX9XSxQZNGVdW+lPxt
         9Ozg==
X-Gm-Message-State: AOAM530aYSUHJOIMl5rD0+MVv2u0TR7PERkiv1QI8V7zXeONVjKT3HnE
        I/6sZEe3TNbl2YE8U6wUCjWYudNmpdh4XQ==
X-Google-Smtp-Source: ABdhPJzYwr9JXk34ufOElCT5nDq93Ner81L9MSEk6CEj+cNeB8mcg3VrXUbbTKki6QLsVHkL5R8O7g==
X-Received: by 2002:a05:6638:2257:: with SMTP id m23mr17424963jas.137.1631668442059;
        Tue, 14 Sep 2021 18:14:02 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id a20sm8149573ilt.8.2021.09.14.18.14.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Sep 2021 18:14:01 -0700 (PDT)
Subject: Re: [PATCH] io_uring: move iopoll reissue into regular IO path
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <09c645bdf78117a5933490aff0eea10c4f1ceb0a.1631658805.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <a28f257c-6ab1-8beb-a797-d89c48c3cb62@kernel.dk>
Date:   Tue, 14 Sep 2021 19:14:01 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <09c645bdf78117a5933490aff0eea10c4f1ceb0a.1631658805.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/14/21 4:34 PM, Pavel Begunkov wrote:
> 230d50d448acb ("io_uring: move reissue into regular IO path")
> made non-IOPOLL I/O to not retry from ki_complete handler. Follow it
> steps and do the same for IOPOLL. Same problems, same implementation,
> same -EAGAIN assumptions.

This looks good to me. But I don't think it's against io_uring-5.15?
Trivial reject, but looks like -next to me.


-- 
Jens Axboe

