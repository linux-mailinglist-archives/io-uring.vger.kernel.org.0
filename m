Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2DF762B77D
	for <lists+io-uring@lfdr.de>; Wed, 16 Nov 2022 11:16:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229826AbiKPKQb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 16 Nov 2022 05:16:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229801AbiKPKQa (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 16 Nov 2022 05:16:30 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7B07FFF;
        Wed, 16 Nov 2022 02:16:29 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id z18so25810455edb.9;
        Wed, 16 Nov 2022 02:16:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Gront7ejJFmCvDtHzemtnvgSrNkCJlQgBPYtxrNuErM=;
        b=CqYAmlo8LG1ueo1v4Xey3jPaqxwJYlcXnVA7TMlNT6fNjRlVllMaE4Y1LzDdMULOhe
         0Pbrm6zSbUfK7DZx3YttJHEPpq8NvEfIbM3n56oplvsOQaVdCi0y+RMX3QVTNr5/gg5Q
         ywVHzEnzHbf8DvwUUPTKYG2OcH+uY7Hdp5/9O6rSXnSKCr93Q9M/+jJuTxsTt7CTBE5f
         gijZbZriBLuDXKOZ6MGgZevTV1qTTt6QBalQhQYHuyRcIsN7HAzgNH4z05Z6i9XnLZux
         pJeauYqGFeNKKwn29qYYw0UX6EFG6vA4UkFTRWBZ1f422oYVUd8rpAmCR3TiwGcGQEoq
         qNAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Gront7ejJFmCvDtHzemtnvgSrNkCJlQgBPYtxrNuErM=;
        b=8IkqFo83t+1qi33ziaji6jjzIHwA6sf5wE3wV9HGVSIJ+uNvgHqfZijaCxt6pP3/ej
         O/FJBczKb5FMU/JffeiCxb2+K6jS+EuWWWqPjgLi0CFDWHa3DNlx2KQPy2CORd2AYAN5
         M3L4O4WNqqX+DyR2D7LWOCtyTfkaJfYcyVpTbmRKdAHcIbTtVTKIRI4h7Vgiib0AHLNn
         VcvpGHXT8kmjzo9rkOswet4VSJwmRZKAxMtYeA/9wYVem4HiBJJJImwXT4Lu1fBEn/s6
         YBuIn+NFJ8Jb6s6o0KXfPjMg8TI2Xkl1cnIEmbsYas7QiMbB0XgKMA8yjUovg1F+ZWXb
         weww==
X-Gm-Message-State: ANoB5pmc4d8VcEgxfsa/lD3tw83mbxpZPaWB+CP2uvfEjD3SBhUIlaMe
        wyMGVUnGFhS3yfF+oYxt3iQNwoVG/RI=
X-Google-Smtp-Source: AA0mqf7EVhi/8vWrRzeKojerj0WOo9vffdXq2qvZyaOpaigkUPmD6gcx++ZyuVweWBj+pLYVU4JyGw==
X-Received: by 2002:a05:6402:414e:b0:463:1a0c:4dd1 with SMTP id x14-20020a056402414e00b004631a0c4dd1mr18860162eda.137.1668593788078;
        Wed, 16 Nov 2022 02:16:28 -0800 (PST)
Received: from ?IPV6:2620:10d:c096:310::2eef? ([2620:10d:c092:600::2:79d5])
        by smtp.gmail.com with ESMTPSA id u1-20020a1709064ac100b0078d424e8c09sm6597039ejt.77.2022.11.16.02.16.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Nov 2022 02:16:27 -0800 (PST)
Message-ID: <63a47e31-6d30-6dad-7b8d-1f14a7bd8fd5@gmail.com>
Date:   Wed, 16 Nov 2022 10:14:55 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH v1 2/2] io_uring: uapi: Don't use a zero-size array
Content-Language: en-US
To:     Ammar Faizi <ammarfaizi2@gnuweeb.org>, Jens Axboe <axboe@kernel.dk>
Cc:     Stefan Metzmacher <metze@samba.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>
References: <20221115212614.1308132-1-ammar.faizi@intel.com>
 <20221115212614.1308132-3-ammar.faizi@intel.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20221115212614.1308132-3-ammar.faizi@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 11/15/22 21:29, Ammar Faizi wrote:
> From: Ammar Faizi <ammarfaizi2@gnuweeb.org>
> 
> Don't use a zero-size array because it doesn't allow the user to
> compile an app that uses liburing with the `-pedantic-errors` flag:

Ammar, I'd strongly encourage you to at least compile your
patches or even better actually test them. There is an explicit
BUILD_BUG_ON() violated by this change.

-- 
Pavel Begunkov
