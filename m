Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BE416BBE88
	for <lists+io-uring@lfdr.de>; Wed, 15 Mar 2023 22:09:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231791AbjCOVJP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Mar 2023 17:09:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232285AbjCOVJD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Mar 2023 17:09:03 -0400
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A8194C26
        for <io-uring@vger.kernel.org>; Wed, 15 Mar 2023 14:08:49 -0700 (PDT)
Received: by mail-io1-xd2a.google.com with SMTP id h83so696236iof.8
        for <io-uring@vger.kernel.org>; Wed, 15 Mar 2023 14:08:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1678914528; x=1681506528;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fN7hOg0hyD5Uv2gg8ttIpEpN6wysp44Fx0ar0ZCj2b8=;
        b=Q2FoxcRYKL78nJ2C5MFiVvR8QSE3X6bSbLMYxC7lxGiMol3E/CwJOygoDx9yq2q6Za
         Mk04iWk6ACNuCvrjUiOBIo+lgtaJhwI4/6xLfaTi1Z9K90/5LFl6W4Dscop6VKKHIm8t
         a/DU384gr2B9N5AdppLLEqW2WnTtrH/NpYvTqRx6fibuIxblOCzgtCRlQK0um+v3Pmsl
         tVA24y6JsZGlAjFEm5JMwB0CCA3kocKKzC0KRVjonRJ+o1SVByzSE9180PtCxwxYT5FE
         JEZSe3S7wL+u919u8xb1zCjfgVl2H9dApRzIjDLDQcj4PoSp3awgdegtctZW8WLWg/DO
         hvrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678914528; x=1681506528;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fN7hOg0hyD5Uv2gg8ttIpEpN6wysp44Fx0ar0ZCj2b8=;
        b=o8pZa4xJm2ZsS8lOCgicrbatgMn1DaQnceyBjeSjd3HqJviME5bRjRl26EuFzu5EfA
         +yMSSmU/1lEgW/4m6z/XtXMN4VfYw4QscHl6X+p/8FJGQknuWAmSafKi/JQx9yVhWGl6
         ee7WW34vyVKrl5iX5BL6rt8zWvQa59lXvPTWbgEH1QMLjPMffZD80qlLdtarebbs5v+F
         JwQ9yJzLJUD6Rqz7Vd41vW5onT1YInQkeM+VFSTx/XTLiVDnj2Xz+aeMFW/57lD1uQF6
         H5ClQErgwz5etMkhrY1AtO6xGsVWq5pdRnyBU2zyKXlp3OF+uL8+0AYXaPAp6NKtqpF7
         v6pw==
X-Gm-Message-State: AO0yUKViAMDNXVehZtF8ON5vC41tSeyqfKZBGOb58HSHRFdP6+IISnFw
        odxQu6OKXKJi9QF9v3zGrnWLSQGdCPPrhj7gIR/VWg==
X-Google-Smtp-Source: AK7set+FYNEe1T/s9a1r0Oz1xnXYdBB/53tjQyOWVbt+D1su7gQm+eqsOrVhBL8a9Wr6r5TPuH+NuQ==
X-Received: by 2002:a6b:14d2:0:b0:72c:f57a:a37b with SMTP id 201-20020a6b14d2000000b0072cf57aa37bmr2371735iou.2.1678914528424;
        Wed, 15 Mar 2023 14:08:48 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id k23-20020a5d97d7000000b00740694b5f43sm1977480ios.46.2023.03.15.14.08.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Mar 2023 14:08:48 -0700 (PDT)
Message-ID: <4b09b903-ffed-8fc7-482a-eabcf152c98b@kernel.dk>
Date:   Wed, 15 Mar 2023 15:08:47 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCHSET 0/5] User mapped provided buffer rings
Content-Language: en-US
To:     John David Anglin <dave.anglin@bell.net>,
        Helge Deller <deller@gmx.de>, io-uring@vger.kernel.org,
        linux-parisc <linux-parisc@vger.kernel.org>
References: <20230314171641.10542-1-axboe@kernel.dk>
 <0eeed691-9ea1-9516-c403-5ba22554f8e7@gmx.de>
 <3dcf3e0c-d393-cb95-86ab-00b4d8cf3c75@gmx.de>
 <88b273f6-a747-7d2e-7981-3d224fdac7be@kernel.dk>
 <19dcf149-9ee7-048e-193c-accf297d7072@bell.net>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <19dcf149-9ee7-048e-193c-accf297d7072@bell.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/15/23 3:04?PM, John David Anglin wrote:
> On 2023-03-15 4:38 p.m., Jens Axboe wrote:
>> For file-verify.t, that one should work with the current tree. The issue
>> there is the use of registered buffers, and I added a parisc hack for
>> that. Maybe it's too specific to the PA8900 (the 128 byte stride). If
>> your tree does have:
> The 128 byte stride is only used on PA8800 and PA8900 processors. Other PA 2.0 processors
> use a 64 byte stride.  PA 1.1 processors need a 32 byte stride.
> 
> The following gcc defines are available: _PA_RISC2_0, _PA_RISC1_1 and _PA_RISC1_0.

Ah perfect!

> /proc/cpuinfo provides the CPU type but I'm not aware of any easy way to access the stride value
> from userspace.  It's available from the PDC_CACHE call and it's used in the kernel.

model		: 9000/785/C8000 - Crestone Peak Mako+ Slow [128]

I guess that's why it worked for me. OK, will ponder how to define that,
I think just going lowest common denominator is enough for now.

-- 
Jens Axboe

