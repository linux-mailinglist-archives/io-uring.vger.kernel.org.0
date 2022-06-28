Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF71C55EE04
	for <lists+io-uring@lfdr.de>; Tue, 28 Jun 2022 21:45:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231928AbiF1Tpk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 28 Jun 2022 15:45:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230301AbiF1TpV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 28 Jun 2022 15:45:21 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E8FB3CA73
        for <io-uring@vger.kernel.org>; Tue, 28 Jun 2022 12:38:48 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id 68so13136157pgb.10
        for <io-uring@vger.kernel.org>; Tue, 28 Jun 2022 12:38:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=R/m0Mpk7pVuJiIWprQOno/Hpe4AFomZAEcga9jL9YLA=;
        b=bhe/sbwpuGVDQTIiuE1vanGErx/2iYmd4JWtUJ9ONgGYg9xWkpKeD/AFx7lxB4Z/1q
         3/JOWQm0J40kHqjM7KmdJ7b0ORREudvPV3vR2QpJIMz4VsRhAFBhYmfbwJIClZhJFkcB
         ZTkxA1+uiy/3uB2TDvG90iKHTkB6UafPQXBXntJbSIBHIzWKiZbV96ZGLiEqTn3M1u9H
         A9dSVBsWM5F5qxyN8i2cxi6OmDkJEYnkrbAmHAf943MJEU9kNJq9XPps/0BsMk85UpMA
         +YwkTcMRPEYFzgrThZMpITDuq/jmD8Egxrgf6mJiQ3seAVjN7Wa23b/CUgZB14j4tN9v
         XawQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=R/m0Mpk7pVuJiIWprQOno/Hpe4AFomZAEcga9jL9YLA=;
        b=P5ikZgH+V3mYDFULJIBQmquLorMM3Z8YUWbXkg7W+brJZxrY04PpQb/tAK5nlhhlLC
         fCYQAQhc2l+XCNUpkQuy6sJjniTQCfzKUw6P5wMFb7ok400B6wuMQMNPrE7kn5fN9JEY
         Cd23Fh0n7ZqVZOfU7UDL3JAZsKiXXYzLSd/RNs07Aw/XLzQWfCIF6cisscBZ8DluWBkg
         wHBsTMRPN7q6V1yJWofgtAJo7z5vYiL47uCsf2JwnSDn/xQnjupwNqqMo9bC+ho1Zp9R
         fPpviBFReDAc7UdZTJBe4y9PPJCk3tfUCLFzHJFumRsA83lCicEiWzbUYNONAAsoYUu/
         OdRg==
X-Gm-Message-State: AJIora/n0wCOkk894vMHoDnyVXJ5CqXMcBejA5O32Ov32CmmnIB50ghn
        WKDdcGqyRU9o34ArruZfssFjvQ==
X-Google-Smtp-Source: AGRyM1seN+3lufLgwt0RnuEk9fybZPgxUv9NUsBwylD1Xh4AvsqeKC6WmitZPWs5OCP9YsaX9dJAfg==
X-Received: by 2002:aa7:96dd:0:b0:525:8869:df13 with SMTP id h29-20020aa796dd000000b005258869df13mr6354581pfq.14.1656445127638;
        Tue, 28 Jun 2022 12:38:47 -0700 (PDT)
Received: from ?IPV6:2620:10d:c085:21e1::165b? ([2620:10d:c090:400::5:f46f])
        by smtp.gmail.com with ESMTPSA id g4-20020a655944000000b003fe4da67980sm9595041pgu.68.2022.06.28.12.38.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Jun 2022 12:38:47 -0700 (PDT)
Message-ID: <37147b0c-4b11-37df-6c4a-ee2dfeb9cbb7@kernel.dk>
Date:   Tue, 28 Jun 2022 13:38:44 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH][next] io_uring: replace zero-length array with
 flexible-array member
Content-Language: en-US
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
References: <20220628193320.GA52629@embeddedor>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220628193320.GA52629@embeddedor>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/28/22 1:33 PM, Gustavo A. R. Silva wrote:
> There is a regular need in the kernel to provide a way to declare
> having a dynamically sized set of trailing elements in a structure.
> Kernel code should always use ?flexible array members?[1] for these
> cases. The older style of one-element or zero-length arrays should
> no longer be used[2].
> 
> [1] https://en.wikipedia.org/wiki/Flexible_array_member
> [2] https://www.kernel.org/doc/html/v5.16/process/deprecated.html#zero-length-and-one-element-arrays

Thanks for sending this separately. As mentioned out-of-band, we already
have it like this in the io_uring.h header in liburing.

Applied for 5.20.

-- 
Jens Axboe

