Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FDD979757C
	for <lists+io-uring@lfdr.de>; Thu,  7 Sep 2023 17:52:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235484AbjIGPrY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 7 Sep 2023 11:47:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245492AbjIGPgj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 7 Sep 2023 11:36:39 -0400
Received: from mail-oo1-xc36.google.com (mail-oo1-xc36.google.com [IPv6:2607:f8b0:4864:20::c36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28FED210E
        for <io-uring@vger.kernel.org>; Thu,  7 Sep 2023 08:36:15 -0700 (PDT)
Received: by mail-oo1-xc36.google.com with SMTP id 006d021491bc7-573128cd77dso169878eaf.0
        for <io-uring@vger.kernel.org>; Thu, 07 Sep 2023 08:36:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1694100972; x=1694705772; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mmqr09NFOdAcxT8GnRxHCgyTgj/fxtGD41pLptP2Au0=;
        b=irlzL6FTIbmbJgRq5Igt9l5zk1JQ3Njqkz6ExRoNCX2C2g7F3yOoYUy4acd/NkjXui
         IRCyx0ofS6KoNY7G7PJ32FGr9v17NWFSxEtw9JIkO35BRbpHi9YNZsy6XwWJEzdVw2KZ
         ZVn4uoS0ZqcPqvu38GXL9dxk7oi/A14p8jzm09WCje/Dn/84+7Io5z+gV9zWBHC4lgo9
         BcoTjL0X9MUxoGbmbbxAu0soNixklKoBz6lB6a5kltFtof0VJUrn1u9lPjvdd5gh3ekw
         TTDoXmvH9AOcsQ2yf/9AuxxglQENo/xPRa4XxFDhrajbuM98JhVDbpwCgbO36/Vc04cI
         bjqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1694100972; x=1694705772;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mmqr09NFOdAcxT8GnRxHCgyTgj/fxtGD41pLptP2Au0=;
        b=kFIf6piynLSgyPuF0gJAwEjttGMVosXbbyy6AyYTmSmZ7ECKV5471gUy9VTJVXgqfC
         qQxUno483JK3ZT0SFGjkdT9xmDONwpYfN4QZNgk2P+LwRffBnqUv7VgeCTV/mYDY3umv
         W21bwuhibJ7jiBUzv+5rEQ24mq8ynvt0CD078nIfmUrT29M52CXKuwKYS2N5uMEbfCME
         o/diB+BeQvZwSMsf7Jb7RzO5HyPcFfllFkYenm4jHTZc5ydrv2jus//ConMQVIHasfuQ
         7g9x257n2UmXTkMfZ3H23wO97UKRlHQ4M0kzgqXDpmSx48GImdrviXkoksVRrnxs+cmM
         MHCQ==
X-Gm-Message-State: AOJu0YxNfEfy18GnJrrrXTmLHekZIVRKneANXQQ/UXWLAIxo5Tj0nske
        /WzQDM9g3qmQSeLkAVPK0bgK+LJDgr0NffWaFWUp+w==
X-Google-Smtp-Source: AGHT+IFAx31pDL9OS0UaQ1QM7P0+U8uqVOMnNbmVkRkKwNCPJEI10DFOozUuRPTBz0NCwjQiG7qxHg==
X-Received: by 2002:a05:6358:51db:b0:13a:cf1d:4a0d with SMTP id 27-20020a05635851db00b0013acf1d4a0dmr14633190rwl.0.1694100972613;
        Thu, 07 Sep 2023 08:36:12 -0700 (PDT)
Received: from ?IPV6:2620:10d:c0a8:11c9::11ab? ([2620:10d:c091:400::5:d08f])
        by smtp.gmail.com with ESMTPSA id l9-20020a0c9789000000b0064c9f754794sm6517636qvd.86.2023.09.07.08.36.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Sep 2023 08:36:11 -0700 (PDT)
Message-ID: <f6be40a3-38de-41ed-a545-d9063379f8e2@kernel.dk>
Date:   Thu, 7 Sep 2023 09:36:10 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2] io_uring: fix IO hang in io_wq_put_and_exit from
 do_exit()
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, linux-block@vger.kernel.org,
        Ming Lei <ming.lei@redhat.com>
Cc:     David Howells <dhowells@redhat.com>,
        Chengming Zhou <zhouchengming@bytedance.com>,
        Pavel Begunkov <asml.silence@gmail.com>
References: <20230901134916.2415386-1-ming.lei@redhat.com>
 <169358121201.335729.4270950770834703042.b4-ty@kernel.dk>
In-Reply-To: <169358121201.335729.4270950770834703042.b4-ty@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/1/23 9:13 AM, Jens Axboe wrote:
> 
> On Fri, 01 Sep 2023 21:49:16 +0800, Ming Lei wrote:
>> io_wq_put_and_exit() is called from do_exit(), but all FIXED_FILE requests
>> in io_wq aren't canceled in io_uring_cancel_generic() called from do_exit().
>> Meantime io_wq IO code path may share resource with normal iopoll code
>> path.
>>
>> So if any HIPRI request is submittd via io_wq, this request may not get resouce
>> for moving on, given iopoll isn't possible in io_wq_put_and_exit().
>>
>> [...]
> 
> Applied, thanks!
> 
> [1/1] io_uring: fix IO hang in io_wq_put_and_exit from do_exit()
>       commit: b484a40dc1f16edb58e5430105a021e1916e6f27

This causes a regression with the test/thread-exit.t test case, as it's
canceling requests from other tasks as well. I will drop this patch for
now.

-- 
Jens Axboe


