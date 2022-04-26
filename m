Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE593510150
	for <lists+io-uring@lfdr.de>; Tue, 26 Apr 2022 17:03:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348454AbiDZPGt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 26 Apr 2022 11:06:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348182AbiDZPGs (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 26 Apr 2022 11:06:48 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AF856D4FC
        for <io-uring@vger.kernel.org>; Tue, 26 Apr 2022 08:03:41 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id kq17so13528923ejb.4
        for <io-uring@vger.kernel.org>; Tue, 26 Apr 2022 08:03:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=C6G9SgucYL2CMjHU7k2Ctcqcxoq8B9zBMPFc+v8ONPI=;
        b=EnkVdErq1wc1RL4g6RYN8qI3ROnE2rpY57udOjgzhCOTVR0DBRtQYpN36aFzzzq/ni
         viZNbbtN2wCQPAEUrecJvjWr0ZCt6wpdp31UTpucpO4GAoh6n3/7uV70zlGXkxq7z61t
         BLSqJVDyuIS75ft2dzrr02NBLo28IrXgYYovFmzzepGrYEfo5CddMnp2W3TwA/GYh0xV
         IpjFgWeNmOJsTLou+bp4LTJ7KM+6P70P6KV6zE8BxcYwOmz2dMuuhQOf0Tyc5Oy/tu9M
         ca4kaGCYir0hA4Z9540EjiIBjZYNwU3TrrrwNXhsQEyHH0zRNB+iocMc2LURa9qSX7/o
         8E+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=C6G9SgucYL2CMjHU7k2Ctcqcxoq8B9zBMPFc+v8ONPI=;
        b=hAd9S4jlJH2r1THHuG2j4S/cl7dgS/e4mfkn7/nnWUBmzgtaSYXFVbCJr4MKUmQpY/
         4tI/txqCUbXvpw102HHU/Bii9JVuhm/KSP/e9YG/oh76H7IOuYGaLjJ6+KpQ8em4LDHp
         lmA5gjmOXzbNK0P7dLZshWT64tJymuARauth04vO2gKbFWxh8X8sa0wQcaVGNY7uiZtH
         chUzQEzR1Iwa+zTMqwuxgONQ5tqk584A1K/GQv40l8pY3hy25OICBHBEpYzMSSYLbHKL
         TlfVSas0iW4Uav8VRYtkAdTlPAnGcl6Gnw1aRE7LtfvzW+n93A7Yb/ecxoF07oGqVj2v
         VwCA==
X-Gm-Message-State: AOAM532+yNS+IPA0oWxb8RvSrKLkMW+c2bqE8nFkayFZX81IC5+zzWWg
        ClLl2TWG3bTVTi38kpnUNU4=
X-Google-Smtp-Source: ABdhPJyreRtsTZgh67qVXe8Jdgy80zLej+JbDfwvXMzcb/eRVGR0vMCXyS/eOmzR6/kgZl/5Ab1PqA==
X-Received: by 2002:a17:907:2159:b0:6f3:a307:d01d with SMTP id rk25-20020a170907215900b006f3a307d01dmr7210396ejb.760.1650985419232;
        Tue, 26 Apr 2022 08:03:39 -0700 (PDT)
Received: from [10.0.2.15] (93-172-44-128.bb.netvision.net.il. [93.172.44.128])
        by smtp.gmail.com with ESMTPSA id h8-20020a1709066d8800b006e09a49a713sm5043182ejt.159.2022.04.26.08.03.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Apr 2022 08:03:38 -0700 (PDT)
Message-ID: <a85e2dd8-a9c6-6fbb-30b3-40087ac1c77d@gmail.com>
Date:   Tue, 26 Apr 2022 18:03:30 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH 2/6] io_uring: serialize ctx->rings->sq_flags with
 atomic_or/and
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <20220426014904.60384-1-axboe@kernel.dk>
 <20220426014904.60384-3-axboe@kernel.dk>
From:   Almog Khaikin <almogkh@gmail.com>
In-Reply-To: <20220426014904.60384-3-axboe@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/26/22 04:49, Jens Axboe wrote:
> Rather than require ctx->completion_lock for ensuring that we don't
> clobber the flags, use the atomic bitop helpers instead. This removes
> the need to grab the completion_lock, in preparation for needing to set
> or clear sq_flags when we don't know the status of this lock.

The smp_mb() in io_sq_thread() should also be changed to
smp_mb__after_atomic()

-- 
Almog Khaikin
