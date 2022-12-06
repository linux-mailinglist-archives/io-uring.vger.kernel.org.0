Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29ED66449C0
	for <lists+io-uring@lfdr.de>; Tue,  6 Dec 2022 17:53:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234971AbiLFQxs (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 6 Dec 2022 11:53:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231990AbiLFQxr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 6 Dec 2022 11:53:47 -0500
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BA08223
        for <io-uring@vger.kernel.org>; Tue,  6 Dec 2022 08:53:46 -0800 (PST)
Received: by mail-io1-xd34.google.com with SMTP id h6so4312047iof.9
        for <io-uring@vger.kernel.org>; Tue, 06 Dec 2022 08:53:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=IIobkFc8+r1LnSRyVhyVnlejzYVDaAKKEF43tgDC9p0=;
        b=Z4IGxJ0UxmIFqYvmxUW2lCg83tCTSVFUEJAHXdEv1StiJQG8yLzvA9V87c9AeQWX37
         S120vVywNpGzyNa2SunLiwI+RGJ5QkQumlM8Ob5JYByEhppwdR5G7BsYoQ9JhHSWDGdZ
         jVq/bRrDzdxSpZfWnja46P66PWzWoPZzNzsiKBr1PtH+eQVE7VaUiuvD6LQIBoBdSYq1
         UbUR+Nn+68pxKP8b+wGubqr03Lu6ZgzNP2lQfT/SeMlr+1v+j2ipTpxB+T99LRDIz4Uq
         Itx0ipaKWNv60WpLrsm2CM+w+GOqbyqL5+iNUqVQIIgk5cOkgIKhblwtAD03bmis+bfj
         gRQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IIobkFc8+r1LnSRyVhyVnlejzYVDaAKKEF43tgDC9p0=;
        b=4c5M5iSGXrdnz8z94xHG5eabQOovS/I2yyBUxF06Ta1WOzPRA0jUL2cc4LEzY2RUlD
         ZVBt8F2xt9JljT18v7KK9y6Tdty4VKZTk4ClVESj2fUPEwpTrCiTKaKb2k02G80nkbnv
         4K1IpXzVKK+tB0A9kto6KfIhjAMT2XFR65B8ftM3RvEWrbr1eAdiwO0bNbNn2Ay/+7Ls
         FCTkK740h2tBlWi5jMrVcNagkPDZ4kJDSL4P9xukgnXKeD3G0WP6olx+P7XJewXRdfDu
         m+u0sQuOC+VA99Xm7lnnX2LIDDhQflyKDGBR5UBN+WfucGnh/jaw+hABT142mC0ozXjn
         Fc7w==
X-Gm-Message-State: ANoB5pk1uXgqCrTB7AlucrzIoIC0AzwS9VqxpK2PmVnaYCKfM75vugxz
        DHnc3yte6EY0O8oJCpDMI3kGfbPTaTmUwXP7BQQ=
X-Google-Smtp-Source: AA0mqf5/J9FevO6/waWJ5uVrzAtYaDQ/WkS93xhjSWUefEK5wmlucuHnLVw3GU76VlJ12CksAUAWKA==
X-Received: by 2002:a02:856a:0:b0:389:ce3b:6bc0 with SMTP id g97-20020a02856a000000b00389ce3b6bc0mr21373459jai.61.1670345625519;
        Tue, 06 Dec 2022 08:53:45 -0800 (PST)
Received: from [192.168.1.94] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id f7-20020a028487000000b0036cc14af7adsm6908231jai.149.2022.12.06.08.53.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Dec 2022 08:53:44 -0800 (PST)
Message-ID: <1d2905ba-8d76-b54c-a812-a1b3fde05d13@kernel.dk>
Date:   Tue, 6 Dec 2022 09:53:41 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH for-next 0/7] CQ locking optimisation
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1670207706.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <cover.1670207706.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/4/22 7:44 PM, Pavel Begunkov wrote:
> Optimise CQ locking for event posting depending on a number of ring setup flags.
> QD1 nop benchmark showed 12.067 -> 12.565 MIOPS increase, which more than 8.5%
> of the io_uring kernel overhead (taking into account that the syscall overhead
> is over 50%) or 4.12% of the total performance. Naturally, it's not only about
> QD1, applications can submit a bunch of requests but their completions will may
> arrive randomly hurting batching and so performance (or latency).
> 
> The downside is that we have to punt all io-wq completions to the
> original task. The performance win should diminish with better
> completion batching, but it should be worth it for as it also helps tw,
> which in reality often don't complete too many requests.
> 
> The feature depends on DEFER_TASKRUN but can be relaxed to SINGLE_ISSUER

Let's hash out the details for MSG_RING later, if we have to.

-- 
Jens Axboe


