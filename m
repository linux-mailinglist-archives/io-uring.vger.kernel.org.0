Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B9EC74293C
	for <lists+io-uring@lfdr.de>; Thu, 29 Jun 2023 17:16:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231778AbjF2PP7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 29 Jun 2023 11:15:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231638AbjF2PP6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 29 Jun 2023 11:15:58 -0400
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 474C31BD1;
        Thu, 29 Jun 2023 08:15:57 -0700 (PDT)
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-66767d628e2so703150b3a.2;
        Thu, 29 Jun 2023 08:15:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688051757; x=1690643757;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qccKYp1AYuLT7GaG2xqJdVkZtWkl4Hon6oeAGOJVG9o=;
        b=FPirHep/dRCRIRtVtWB4zEdOwQyomPy/bVmo5toyA8ErJNR0lH6yTYM4wQ5j1kl8HO
         G2f7JNPyK7IehoR33djsmqQEMPiHjUhwKYPkYcqHWFdYrwk6vWljDFHS17pU06qyarwR
         bQVT1XYJAEFyC+K+zxVno5Z9Ar7AnFs0KJwkrOf6ZFPCpkQIpjmS1r3xoIZ1HHChsoGp
         dUX32UCqJVLawzaUxkuz/c125oosU18rLixHPVRZv5bLnYWJ0X9dMhTAfIRtXtKGIVVH
         QRTJnRm5kCM8IQUJtY8LbkaSN05s/7trn8kn0WdgH4wgOnSoFTH2PQxV94xYsan+lZgL
         qXEw==
X-Gm-Message-State: ABy/qLZ2vlk417tnJTaOJC/qfOhU3SBx+Dt02tBNeJWKcT8O8lpmYXhD
        3P8lYN/Z3BNvccN/Skbl7vQ=
X-Google-Smtp-Source: APBJJlGyZ1UKPPOKrKHSQ6VdlmgU0fE9xg8EakgcqFmnS7khGAVYo81mwX7BkeKiQ9Kpxr+S9FcqSA==
X-Received: by 2002:a05:6a00:150c:b0:64f:7a9c:cb15 with SMTP id q12-20020a056a00150c00b0064f7a9ccb15mr273446pfu.11.1688051756513;
        Thu, 29 Jun 2023 08:15:56 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:9df8:7301:777:30db? ([2620:15c:211:201:9df8:7301:777:30db])
        by smtp.gmail.com with ESMTPSA id a19-20020a62e213000000b0063f0c9eadc7sm3191514pfi.200.2023.06.29.08.15.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Jun 2023 08:15:55 -0700 (PDT)
Message-ID: <a0c8d74a-dcfe-78a7-74bd-4447ed6944dc@acm.org>
Date:   Thu, 29 Jun 2023 08:15:52 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v2 1/1] Add a new sysctl to disable io_uring system-wide
Content-Language: en-US
To:     Matteo Rizzo <matteorizzo@google.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
Cc:     jordyzomer@google.com, evn@google.com, poprdi@google.com,
        corbet@lwn.net, axboe@kernel.dk, asml.silence@gmail.com,
        akpm@linux-foundation.org, keescook@chromium.org,
        rostedt@goodmis.org, dave.hansen@linux.intel.com,
        ribalda@chromium.org, chenhuacai@kernel.org, steve@sk2.org,
        gpiccoli@igalia.com, ldufour@linux.ibm.com, bhe@redhat.com,
        oleksandr@natalenko.name
References: <20230629132711.1712536-1-matteorizzo@google.com>
 <20230629132711.1712536-2-matteorizzo@google.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20230629132711.1712536-2-matteorizzo@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/29/23 06:27, Matteo Rizzo wrote:
> +static int __read_mostly sysctl_io_uring_disabled;

Shouldn't this be a static key instead of an int in order to minimize the
performance impact on the io_uring_setup() system call? See also
Documentation/staging/static-keys.rst.

Thanks,

Bart.
