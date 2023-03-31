Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADB586D257B
	for <lists+io-uring@lfdr.de>; Fri, 31 Mar 2023 18:29:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231858AbjCaQ3V (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 31 Mar 2023 12:29:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233243AbjCaQ3G (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 31 Mar 2023 12:29:06 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EC202C9CF;
        Fri, 31 Mar 2023 09:24:50 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id t10so91607528edd.12;
        Fri, 31 Mar 2023 09:24:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680279843;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fZ96KdlSjaTBWKPocTxX5k5WrsmRj+TV7Rw8W1wVnGM=;
        b=TF0OmCsbgoJUYml8K92YWwE+T4riDvgJs28wgP7CjyOsheWLONhapiaZhrEsyp6c3M
         ePj6RLGqbk2v0OBto7H99YuhEbrHOjoiAGF7R5w3R3JeWOWqLKvtp60PKFEsvN/1Qzg+
         mF4+/zjp52PUW1ZdjsEqFi/aSK+bwTf26x//jBzfHuv/jVV8ggWSYOF8sm8M/ImDDVqj
         EaOZHnfj+6kj7q8hUFJpmprt+xXQw5UJXZNEbRac54Ru69gt18VYjOSgstt+fm0n64PS
         LLI3H5l7F+Mt+MSfnnc6Qx5S+m/HxQ5ZG2sCU59md16HYHyZMxR4eOv1IprLSCoouE7u
         OQKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680279843;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fZ96KdlSjaTBWKPocTxX5k5WrsmRj+TV7Rw8W1wVnGM=;
        b=S8rx9pIVAHC4o5yZYDWum3EfRp5y/aFJVshva5gw0MpiZmNOnm2igdWWJDIkiu+X+U
         n/bKZLSXTG08eGXozyCFPvsjClTfRH1ByWJzbYBbupbCU5TyOEL666nrovjugYqvlYfs
         hlbP4L88WNyEgqW1gLaXrme8wpszziq8x2Fb4O6pBXDAuj7i94rnm8fKBBGphaQsyWj6
         v4T2R0J4Wix3iK9Dsu5ecQd8wypHlznGeX0CyKPbHbw7FyA6GyDiax+ZbAhsZJBXMhpB
         nnO4r5U6q6lPk81GQKZbnM/zbOLjJG3t7EEYfjD5p8fRx4lDtaUvGnt8uT7snooOttoV
         rT4w==
X-Gm-Message-State: AAQBX9dV7byw2eUgo1FYtg2LLfd8EFWCQsbYVA5Jl7MtB6wibrEKmMb1
        P/a8Z9WybYGwULojHJDcvi8=
X-Google-Smtp-Source: AKy350Ze/bKls+PHzw3So//3rROZjAjZefaQKfUK0ASS2p3CwKAQrBrll5FRL9Zg7oZIj2Q0CD0xwg==
X-Received: by 2002:a05:6402:10d8:b0:4fb:2296:30b3 with SMTP id p24-20020a05640210d800b004fb229630b3mr26345810edu.15.1680279843125;
        Fri, 31 Mar 2023 09:24:03 -0700 (PDT)
Received: from [192.168.8.100] (188.28.114.40.threembb.co.uk. [188.28.114.40])
        by smtp.gmail.com with ESMTPSA id k17-20020a50c091000000b004fa99a22c3bsm1216289edf.61.2023.03.31.09.24.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 31 Mar 2023 09:24:02 -0700 (PDT)
Message-ID: <f0dfaa17-fc0e-459e-41ea-8131d558fddb@gmail.com>
Date:   Fri, 31 Mar 2023 17:21:48 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.2
Subject: Re: [RFC 00/11] optimise registered buffer/file updates
To:     Gabriel Krisman Bertazi <krisman@suse.de>
Cc:     io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-kernel@vger.kernel.org
References: <cover.1680187408.git.asml.silence@gmail.com>
 <87h6u111te.fsf@suse.de>
Content-Language: en-US
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <87h6u111te.fsf@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/31/23 14:35, Gabriel Krisman Bertazi wrote:
> Pavel,
> 
> Pavel Begunkov <asml.silence@gmail.com> writes:
>> Updating registered files and buffers is a very slow operation, which
>> makes it not feasible for workloads with medium update frequencies.
>> Rework the underlying rsrc infra for greater performance and lesser
>> memory footprint.
>>
>> The improvement is ~11x for a benchmark updating files in a loop
>> (1040K -> 11468K updates / sec).
> 
> Nice. That's a really impressive improvement.
> 
> I've been adding io_uring test cases for automated performance
> regression testing with mmtests (open source).  I'd love to take a look
> at this test case and adapt it to mmtests, so we can pick it up and run
> it frequently.
> 
> is it something you can share?

I'll post it later.

The test is quite stupid and with the patches less than 10% of CPU
cycles go to the update machinery (against 90+ w/o), the rest is spend
for syscalling, submitting update requests, etc., so it almost hits the
limit.

Another test we can do is to measure latency b/w the point we asked a
rsrc to be removed and when it actually got destroyed/freed, e.g. tags
will help with that. It should've been improved nicely as well as it
removes the RCU grace period and other bouncing.

-- 
Pavel Begunkov
