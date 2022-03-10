Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 883BD4D3F85
	for <lists+io-uring@lfdr.de>; Thu, 10 Mar 2022 04:06:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234714AbiCJDHG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 9 Mar 2022 22:07:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234157AbiCJDHG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 9 Mar 2022 22:07:06 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC57D127555
        for <io-uring@vger.kernel.org>; Wed,  9 Mar 2022 19:06:04 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id v4so4058209pjh.2
        for <io-uring@vger.kernel.org>; Wed, 09 Mar 2022 19:06:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=pyZMJe8UdeK8gUVhAIlxwPaF/UEVAewxBY/dl/StI70=;
        b=D/ANjou3zp6hmPHcBbVRf6Ixj+zxdspzsbDImvcpzHt62mZ+0YOI7D7iUbxhV4KypO
         5ysMKlHY/YQHWU5Tw1q+KNZXIeAZCFCle8X1eD3sXWO79QTrL4fuWHn8ycxZRvGUnGU1
         6UKqI6rpOFAVLK5Z/2q6j9rJ7F3MMcWVHGRvUNLKLP1UYW83DkIKFNr5D3TmufqSyLpl
         Lh9JVvqSuk+9plJ91sMuihVfkheoq7QM42QK9H2PkKRN8cMJICqG9GtKWCVVdXbJcIh8
         YuZYkEjnGDuNBU1NBJ1RjmepbwyrKdKQXn+kJ9t9zFYCiiH/EQjzHm4247OoLQzLSLSR
         36fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=pyZMJe8UdeK8gUVhAIlxwPaF/UEVAewxBY/dl/StI70=;
        b=DI+K/Xwj3sdkdH/EiCyzudCWFR9szlLDoRd8QxtJuTQTITujEyE8HhjdS1OgfmoXix
         QJs14JdaW5mkjEJinZdhgY1YSoxe6B8aNfNJvcwgk8MzSv+sam+fdOIw0stT1S0L+Bsf
         RtDCGT9/4G/XMczQVjiV39zasoWykmvgY3EzFv/hIUXF7ggKhDlkq/4Gtoi/SfENLhjK
         DpdMix/yU8s+2VGdQWrRnX/nOKLGmOQxYQBddwyiLKZXSqasNrlJp8XAWAmQjsZc36ZD
         2Mjm9z+oNl/7RteFmzm4BisV8VG0LJamRwjEzNISVrDxEjbags6aIZRD2inr0tvbWxOi
         qYaA==
X-Gm-Message-State: AOAM531tL+XENv3z7xf1DtBhn8wm3bYu8TlAZoq4W/Z8viwtVJCtjulr
        mHTmnYAKIslekgVr/61qUvdSQQ==
X-Google-Smtp-Source: ABdhPJw4v9dOJb8K6mu/gqZNunlSYWqFLHgVgygLzKq0Z9o9ehrYmtlF0d+G7oFevJQE7CrIG6xsrg==
X-Received: by 2002:a17:90a:8582:b0:1b9:b0da:9ca9 with SMTP id m2-20020a17090a858200b001b9b0da9ca9mr2720675pjn.146.1646881564380;
        Wed, 09 Mar 2022 19:06:04 -0800 (PST)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id o65-20020a17090a0a4700b001bef5cffea7sm9044420pjo.0.2022.03.09.19.06.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Mar 2022 19:06:03 -0800 (PST)
Message-ID: <9c833608-5df8-8281-54e4-056a0db0c84c@kernel.dk>
Date:   Wed, 9 Mar 2022 20:06:02 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: Sending CQE to a different ring
Content-Language: en-US
To:     Artyom Pavlov <newpavlov@gmail.com>, io-uring@vger.kernel.org
References: <bf044fd3-96c0-3b54-f643-c62ae333b4db@gmail.com>
 <e31e5b96-5c20-d49b-da90-db559ba44927@kernel.dk>
 <c4a02dbd-8dff-a311-ce4a-e7daffd6a22a@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <c4a02dbd-8dff-a311-ce4a-e7daffd6a22a@gmail.com>
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

On 3/9/22 7:11 PM, Artyom Pavlov wrote:
> No, ideally I would like to be able to send any type of SQE to a
> different ring. For example, if I see that the current ring is
> overloaded, I can create exactly the same SQEs as during usual
> operation, but with a changed recipient ring.

And since I could still be misunderstanding your intent here, if you
mean that you want to submit sqe to ring1 with ring2 being the target,
then I'm not sure that would be very helpful. The submitting task is the
owner of the request, and will ultimately be the one that ends up
running eg task_work associated with the request. It's not really a good
way to shift work from one ring to another, if the setup is such that
the rings are tied to a thread and the threads are in turn mostly tied
to a CPU or group of CPUs.

-- 
Jens Axboe

