Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0006B5A12BD
	for <lists+io-uring@lfdr.de>; Thu, 25 Aug 2022 15:52:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236250AbiHYNwO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 25 Aug 2022 09:52:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234550AbiHYNwN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 25 Aug 2022 09:52:13 -0400
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C8B4DF54
        for <io-uring@vger.kernel.org>; Thu, 25 Aug 2022 06:52:12 -0700 (PDT)
Received: by mail-io1-xd33.google.com with SMTP id z72so16009236iof.12
        for <io-uring@vger.kernel.org>; Thu, 25 Aug 2022 06:52:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=SvVAJQFyOC243WTmG1AJjR0BNAH5e3HC7kt68w5W/fE=;
        b=P7VJbCSQS0juaWFCfq5RDEH/lrCM32UR2v8b+OpESLKm3e6omlHv6ZPJ1MuqnjT6iY
         wSIuWy2fgyyTrRQuPEMD+B237eCQqRcR/gpLUKM+Bq+pcJXNKxp794JcTVXxdiCbMakU
         MlnDawj2ORZF3YIwCKGFZb0l68BXL1Y18cjsXaHr9w2YsviQWneMMXAx0W9iDZnmFXTo
         /eIBbhtDqYtBGd8kCGZFIhhrc/DRJfCKvWkNJTb9eglczFsN992Euak9VmvQG02vbT/Q
         TW/nYvRNGnm+QllR7z9cZFfniItzU5du1Nmdvt21mjDtSPu6/6XiYD9tXKXJ+gJo/9D9
         WzJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=SvVAJQFyOC243WTmG1AJjR0BNAH5e3HC7kt68w5W/fE=;
        b=cJ0kbJUeits14vSWdGzZpVskH66Do9AaBvMesii7/IRLZwsUIVXVDffdec6qgf/Or0
         I3GumZ6IE/6sq0xzAwDnZcrzf37GYHhJIzZl0y9/Ql89SsINryJ+eFAGmKrgYD/WlHdQ
         LHQE9e2Xs04u5toetbOts6NZlBsZR+/D2aZJUojOaFInfKiQM2LbRqra9OfH8TFEyEip
         DVpy4m/ybaiJjJjaFv3AeUYhHxOqZlaxGyDewbDfNMEXk4MolcyF7pzfdeb7uI2zfviH
         074BMOI6TtuyP40/LNaF0dQHQ0BPY4jYPuPsb8FZ1C1sVkn9MhbvtBCrQRfLeVThUilG
         PViA==
X-Gm-Message-State: ACgBeo3fJ29GetRYOZfcqnIdFQHcdcXHdlAH3oqtjylAIRUXsAHDktcX
        lsrZmMOVmxUoSR58BjskhhrMVw==
X-Google-Smtp-Source: AA6agR5t9EQZWyP/gVzCbQTBF0ohO+b1jxGMLOoVws3AM8aYBV2IkGyct64Uz186YgnZjvTlDj3FSg==
X-Received: by 2002:a05:6638:248c:b0:349:fddf:b80c with SMTP id x12-20020a056638248c00b00349fddfb80cmr1883084jat.261.1661435531792;
        Thu, 25 Aug 2022 06:52:11 -0700 (PDT)
Received: from [192.168.1.94] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id c22-20020a023316000000b00349bbbdcb95sm1023851jae.42.2022.08.25.06.52.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Aug 2022 06:52:11 -0700 (PDT)
Message-ID: <1784b4f3-a66a-50e3-4105-6897c4803f58@kernel.dk>
Date:   Thu, 25 Aug 2022 07:52:08 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.1.2
Subject: Re: [PATCH] io_uring/net: fix uninitialised addr
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <52763f964626ec61f78c66d4d757331d62311a5b.1661421007.git.asml.silence@gmail.com>
 <e77d4686-6a2d-fabf-0e25-b10bd9262984@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <e77d4686-6a2d-fabf-0e25-b10bd9262984@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/25/22 4:13 AM, Pavel Begunkov wrote:
> On 8/25/22 11:11, Pavel Begunkov wrote:
>> Don't forget to initialise and set addr in io_sendzc(), so if it goes
>> async we can copy it.
> 
> Jens, can you amend it into the last commit?
> ("io_uring/net: save address for sendzc async execution")

Yes, I'll amend it. But do we have a test case that hits this path?
Because it seems like that would've blown up immediately.

-- 
Jens Axboe


