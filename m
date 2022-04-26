Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6344D5101F3
	for <lists+io-uring@lfdr.de>; Tue, 26 Apr 2022 17:33:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229581AbiDZPgH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 26 Apr 2022 11:36:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237431AbiDZPgG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 26 Apr 2022 11:36:06 -0400
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 898E73F30A
        for <io-uring@vger.kernel.org>; Tue, 26 Apr 2022 08:32:58 -0700 (PDT)
Received: by mail-io1-xd2e.google.com with SMTP id g21so20368384iom.13
        for <io-uring@vger.kernel.org>; Tue, 26 Apr 2022 08:32:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=LR/YLQSiTEbxpoqURu1Z8un9GiPFO5XnSLh/MpVXNm0=;
        b=xoEclltp0xxYpjhypk9hxXGpwS5AyjLixMI4M9kS66Ngb5AeQTGnhbYH1UsFHmGlw4
         Eq7aL4OJ0yTAyU74cxW1rVbPKNclSS8QECqfTpXqCJtJrGq1n8G997tLOIColdwkXy7X
         6RjVlZ4o0/ik/xuvYPtdv7qn5rcEnTB6Ntb4reQhAh8hRGTqGJLwSBa32KPCQTPAUgtU
         SRnoKJ9LqLJ/3CP4/KO6IDDMXvEcjOmnzPQlTKzWS+HbKib1lyvq2w1SQOr/Ldb7/OrL
         sAi7Yw99AGMGQboDei91Rr7oTnVqm+8HYfFd6LV5G58sO8uZ8EYw5uMXwN+MNI6DLU5S
         KA/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=LR/YLQSiTEbxpoqURu1Z8un9GiPFO5XnSLh/MpVXNm0=;
        b=UqOYCIfP3teg13uRGLnoHR1q3j1TdviaN5WmUQ6lyJhl7GE5F0Fw3KuO7Sh10zkDam
         GdmriP5tFz01j/cSboQvYVZo76nvUZRmUw2zsttUTp/eQfzXgfkTEHjpJsxac9FEio+1
         6cWiXF0sXxm7d0UTvK7QzLkqJdcQiwoBaebHpjbRNUqMdFYA62mGPqJ9WRFze3aYHw3b
         YaBjt7ysCo1NwrPiZp6I+FCqWAi6Z5+DuFNQAHgumtzrjlKKXuSaUoJevToOidI3QdkX
         plJwFPuQthXr/LSVI8x6niWGHJP60HsS6e6clu+W071AO0iCiaLRxgEJijvc8nRVeGey
         6djQ==
X-Gm-Message-State: AOAM5329ZAx4mygvDFZdbVmmSg0SsVe+a5JvlHB6qR9K56HzkNFKlS3k
        3sDUnCc5gZDPbs/R8T9j7rpI2E2xdFhS3g==
X-Google-Smtp-Source: ABdhPJyixc8015KL8n6O6TSbEJLwlW5w58NRep42BpGwWM1FdPcqZRLDYNylbKXLjo8QIHyUYGAGZg==
X-Received: by 2002:a05:6638:4303:b0:328:95b9:f8b0 with SMTP id bt3-20020a056638430300b0032895b9f8b0mr10388688jab.288.1650987177821;
        Tue, 26 Apr 2022 08:32:57 -0700 (PDT)
Received: from [192.168.1.172] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id k6-20020a056e02134600b002cd812ace1dsm6355689ilr.88.2022.04.26.08.32.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Apr 2022 08:32:57 -0700 (PDT)
Message-ID: <feae3e9e-3ccb-c8ea-162f-41a153536a28@kernel.dk>
Date:   Tue, 26 Apr 2022 09:32:56 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH 2/6] io_uring: serialize ctx->rings->sq_flags with
 atomic_or/and
Content-Language: en-US
To:     Almog Khaikin <almogkh@gmail.com>, io-uring@vger.kernel.org
References: <20220426014904.60384-1-axboe@kernel.dk>
 <20220426014904.60384-3-axboe@kernel.dk>
 <a85e2dd8-a9c6-6fbb-30b3-40087ac1c77d@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <a85e2dd8-a9c6-6fbb-30b3-40087ac1c77d@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/26/22 9:03 AM, Almog Khaikin wrote:
> On 4/26/22 04:49, Jens Axboe wrote:
>> Rather than require ctx->completion_lock for ensuring that we don't
>> clobber the flags, use the atomic bitop helpers instead. This removes
>> the need to grab the completion_lock, in preparation for needing to set
>> or clear sq_flags when we don't know the status of this lock.
> 
> The smp_mb() in io_sq_thread() should also be changed to
> smp_mb__after_atomic()

Indeed, want to send a patch?

-- 
Jens Axboe

