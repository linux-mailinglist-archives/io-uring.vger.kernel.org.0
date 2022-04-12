Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8C1D4FE461
	for <lists+io-uring@lfdr.de>; Tue, 12 Apr 2022 17:12:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242537AbiDLPOi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 12 Apr 2022 11:14:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350304AbiDLPOg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 12 Apr 2022 11:14:36 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B4715DA02
        for <io-uring@vger.kernel.org>; Tue, 12 Apr 2022 08:12:18 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id q3so5801741plg.3
        for <io-uring@vger.kernel.org>; Tue, 12 Apr 2022 08:12:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:references:in-reply-to:content-transfer-encoding;
        bh=o1I72wHCuNc1ckb8DR5pmh9SArkXzs4YhMyoFxVlnnU=;
        b=o3cCDHBl0gI6jAvOWL/TUknKSsqJGY64myF3/jVKwfxQ9pYLn3SL4ESvszIG1m8Z2K
         eXyRXvRgPrMr0KvOFHnDp+ZnsilLtXiSTStbFnJW4WWp1v359FZH11z+ZAQhx0cBJomK
         xl9Bc4/2vnq+QiPn5PbPO3epGDbIJ8nVxUxvpdjO5ZDMiAbqHUkSRbZqN6wPlHv/0JUX
         9+WwTbSxRxPT0TzwYOhTjfg+DpL8Y4+MveJrGWK+hskVGHRTrZ8V7qjG8F2/jUZS+gho
         AS98RAG7Usmw/dbUhowQvmCTpHXmNfZTOf4Hn5XV59kMFGYMMmbZqd2k28IUlvka2PKv
         Xi2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:references:in-reply-to
         :content-transfer-encoding;
        bh=o1I72wHCuNc1ckb8DR5pmh9SArkXzs4YhMyoFxVlnnU=;
        b=frfyp70JDZUIaZwHOwU+ed0pL0iXAOkHteQuKkHx5XSgwpiUCRZyu5y6QJJ9pIINJu
         0XWU4g2Ep0KT5pFhCrgNcTzDpiBsdeuinGpGIz1Rh2FSqCqU3feLU3O6qVrP2b/Mq0Sm
         irwwB7Gb8+4jHaylAi0+WYU3/Pmrvo0xk0OPi6DHWJMgKn6YcPOdZRzzWew3NjeQmqgY
         Uy5+yjWVg3zlNXjEEWc7UiX9HNMdZVh7gB90u0BG132qYwNNOFIBt5pR/L0N8I2PDf+c
         Ot7hFJ8Z2oct8kMcdCVeMnNlBAmpPdJTqDXrCTuvSlLYzHUl8i4Yg2f60zReb1CU23WV
         d9+w==
X-Gm-Message-State: AOAM530HVv75xK40gLK/cdwpAo2SBYGV+b7z2PuQJlFEdAZ1wEjczaLO
        64Iy+CP86s4XHB7xbTrYI+mHrA==
X-Google-Smtp-Source: ABdhPJzfWJzfStc0etAO9C8sHpa+WopvIUX4UlX9voi12yWO9ssQ9lBtGX0eb10Kyvgz8ke7ngRD/g==
X-Received: by 2002:a17:90b:1044:b0:1cd:2d00:9d23 with SMTP id gq4-20020a17090b104400b001cd2d009d23mr3031007pjb.124.1649776337873;
        Tue, 12 Apr 2022 08:12:17 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id y26-20020a056a00181a00b004fe3a6f02cesm26764759pfa.85.2022.04.12.08.12.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Apr 2022 08:12:17 -0700 (PDT)
Message-ID: <e564cc69-b234-d4d3-fd80-94a57fbf6070@kernel.dk>
Date:   Tue, 12 Apr 2022 09:12:16 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH next 0/9] for-next clean ups and micro optimisation
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1649771823.git.asml.silence@gmail.com>
 <3a0e08f1-ec78-f91c-e260-318b6bda1335@kernel.dk>
In-Reply-To: <3a0e08f1-ec78-f91c-e260-318b6bda1335@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/12/22 9:05 AM, Jens Axboe wrote:
> On 4/12/22 8:09 AM, Pavel Begunkov wrote:
>> nops benchmark: 40.3 -> 41.1 MIOPS, or +2%
>>
>> Pavel Begunkov (9):
>>   io_uring: explicitly keep a CQE in io_kiocb
>>   io_uring: memcpy CQE from req
>>   io_uring: shrink final link flush
>>   io_uring: inline io_flush_cached_reqs
>>   io_uring: helper for empty req cache checks
>>   io_uring: add helper to return req to cache list
>>   io_uring: optimise submission loop invariant
>>   io_uring: optimise submission left counting
>>   io_uring: optimise io_get_cqe()
>>
>>  fs/io_uring.c | 288 +++++++++++++++++++++++++++++---------------------
>>  1 file changed, 165 insertions(+), 123 deletions(-)
> 
> Get about ~4% on aarch64. I like both main changes, memcpy of cqe and
> the improvements to io_get_cqe().

Ran the nop tests on the 12900K, and I see about an 8% improvement
there, going from ~88M to 95M. I didn't split and check which part
made the most improvement.

-- 
Jens Axboe

