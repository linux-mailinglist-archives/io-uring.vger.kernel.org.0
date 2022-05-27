Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FEE553644F
	for <lists+io-uring@lfdr.de>; Fri, 27 May 2022 16:47:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233342AbiE0Or5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 27 May 2022 10:47:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239311AbiE0Orz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 27 May 2022 10:47:55 -0400
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2ADF13C4DF
        for <io-uring@vger.kernel.org>; Fri, 27 May 2022 07:47:53 -0700 (PDT)
Received: by mail-io1-xd32.google.com with SMTP id y12so4852701ior.7
        for <io-uring@vger.kernel.org>; Fri, 27 May 2022 07:47:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=RHpa9xrqExhgJcL2c4UAxvIyhlzi2HKiDzAjUo/YTM4=;
        b=djhEeCRiT6kKSPmrRPz77Y0RNu/qryPtpQwpb86fazrGO2URzJTBZqXBwALLSBEbft
         N2tHcGOcVmemuLyMafYlyQOagUWb8dMuWAX99LShnccmjWXI55GIuQAvEZYC2QxaEH7U
         dNunWvibn3qfIb/qt0yYGSQaXUUe61Z6bPDSZ725hxKVyuU3TqSrQ43kjK0FXVBRwDmh
         IAeVgAkzi+5cTtlEQQtCLnwMXmTnInGp9Fo2ys3RQ0v9XyP83B2si1calw8dwRA8WKnW
         CnRpoAex71gTgHHY8SKyDHux5h/SrLeZm6kovYVP2GT8rjFOau5K/cZPrIlwjWWjrbZZ
         pYqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=RHpa9xrqExhgJcL2c4UAxvIyhlzi2HKiDzAjUo/YTM4=;
        b=ujBLMYxE1XuA4/ifWa3lPAVcCn36j5W+EE2+lsNeUZKc/GHVnQ26BDGxefD2DpjE9r
         h/q18ImTiFspWg34bGJxymyMtbgvOWy3WTULP4zS3tiwcmglXbVDX/EoYCVWQSs9zeYT
         hzqI5B0IHgofkGVfZT4AEcYGVxj6VXg2Wt9HUWHxDojuzI42RO50d7mX7TlCC08MunX3
         5G22l4yl7Ye6FgZS+MWSBr32ahk4wVFN7gTVGd+8U9SyLpeYfBNrlb3jMTiIz7bYAVyp
         8gRsM49pLPOXAGjTr3L9l86JmnB1ic9KUWVIn4HyCBXeuZY1kgoD/mA0/tKNPwL927Bo
         7KhA==
X-Gm-Message-State: AOAM531Uz/HijNSWpiqUQLZbRSADtQ5tdU02/jU7qP0lGxQkyn07b0de
        3GhAGoJhaJjG3b0uZxFitIWdRQ==
X-Google-Smtp-Source: ABdhPJyk5pEsRbg1toMZoW8GdOh7Nh9pqdLEAITfzzzRLzubqIdOvA2lsU2bBb/+BxxF8bLlR2k8ag==
X-Received: by 2002:a6b:3b52:0:b0:65e:4af7:3d8e with SMTP id i79-20020a6b3b52000000b0065e4af73d8emr18717305ioa.162.1653662873198;
        Fri, 27 May 2022 07:47:53 -0700 (PDT)
Received: from [192.168.1.172] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id w10-20020a056638378a00b0032e583132e4sm601842jal.123.2022.05.27.07.47.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 May 2022 07:47:52 -0700 (PDT)
Message-ID: <9052c627-0134-54a4-ca0b-1eb808e6bb82@kernel.dk>
Date:   Fri, 27 May 2022 08:47:51 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: Erroneous socket connect pass?
Content-Language: en-US
To:     "Weber, Eugene F Jr CIV (USA)" <eugene.f.weber5.civ@mail.mil>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
References: <60DCCBD6DDA29F4A9EFF6DB52DEE2AB1D866F5D3@UMECHPA66.easf.csd.disa.mil>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <60DCCBD6DDA29F4A9EFF6DB52DEE2AB1D866F5D3@UMECHPA66.easf.csd.disa.mil>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/27/22 8:29 AM, Weber, Eugene F Jr CIV (USA) wrote:
> 
> Hi,
> 
> Thanks for creating liburing. Great stuff.
> 
> I **may** have found a bug. I would expect a socket connect using
> io_uring to fail as it does using connect() if the port is not setup
> to listen. In the simple test case attached it does not. If this is
> pilot error, please let me know what I'm doing wrong, or why my
> expectation is incorrect. Version information is in the code header.
> Please let me know if any additional information is needed.

The return value of io_uring_wait_cqe and related functions isn't the
completion result. It's simply if we succeeded in waiting for one or
more events. It could never be the completion result, because consider
what happens if you have multiple requests in flight.

You need to look at cqe->res for the completion result of the request.

-- 
Jens Axboe

