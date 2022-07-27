Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53F86583373
	for <lists+io-uring@lfdr.de>; Wed, 27 Jul 2022 21:22:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237184AbiG0TWr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 27 Jul 2022 15:22:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233329AbiG0TWL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 27 Jul 2022 15:22:11 -0400
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66138DC
        for <io-uring@vger.kernel.org>; Wed, 27 Jul 2022 12:21:15 -0700 (PDT)
Received: by mail-pj1-f47.google.com with SMTP id o20-20020a17090aac1400b001f2da729979so3238289pjq.0
        for <io-uring@vger.kernel.org>; Wed, 27 Jul 2022 12:21:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=26YTF165B9/GL95Dn7MlIrJ2keMRZ4Tsxp/YJDxP5Ns=;
        b=6S/53OP5pS7GguM6TQ3yHne9d4pmI2qTEawsq9b/hGA5uoKXECI0QwIg4ZzyjOyVov
         OlhlfkcVMX0bddQJjGm7lPGBRSonuo/6xaudzKwEGaNmLaW+Lan8w4RqQ7Qugx1WYte+
         kewyDEx8YL7Y5Ixv24gV/aTRICS6XsdL6tiWt31MEBv1CK3xBK3w1tGcRELQFMqYoIja
         JpPStgAzFzeJ8DupLtV0eUxNe9KO0zbIOmfkE5UZSMES3iF8G27KIuYhF4ZKfwp/eUoq
         QCjShWs3wp+EajojRE8jK4WQqHG7TxD3afKbBtkWQ1wfXC3ljmQJZbU59+TJ5XDuuUax
         2YNQ==
X-Gm-Message-State: AJIora8iWE3HWuaDyW7siSeoF5LTJaTc9MEEicNHI4dugP3Xui0t4gRt
        dm4vWYaonc6/7FAUJ0NDOR8AlogdGxI=
X-Google-Smtp-Source: AGRyM1u6q882t8tGE2wQnFXX1efR0m3MJO4Z6icfdZt7GIksqzW8l9qOkfe9N0r4dkmdc0e99vn+qg==
X-Received: by 2002:a17:902:c405:b0:16d:762d:8885 with SMTP id k5-20020a170902c40500b0016d762d8885mr15713994plk.115.1658949674862;
        Wed, 27 Jul 2022 12:21:14 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:a84e:2ec1:1b57:b033? ([2620:15c:211:201:a84e:2ec1:1b57:b033])
        by smtp.gmail.com with ESMTPSA id u3-20020a626003000000b005289eafbd08sm14760838pfb.18.2022.07.27.12.21.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Jul 2022 12:21:13 -0700 (PDT)
Message-ID: <678c7d14-22da-1522-ea41-5dbd21e0c7b4@acm.org>
Date:   Wed, 27 Jul 2022 12:21:12 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH liburing] add additional meson build system support
Content-Language: en-US
To:     Florian Fischer <florian.fischer@muhq.space>,
        io-uring@vger.kernel.org
Cc:     Florian Schmaus <flow@cs.fau.de>
References: <20220727152723.3320169-1-florian.fischer@muhq.space>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20220727152723.3320169-1-florian.fischer@muhq.space>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/27/22 08:27, Florian Fischer wrote:
>   11 files changed, 619 insertions(+), 4 deletions(-)

To me this diffstat tells me that this patch series adds a lot of 
complexity instead of removing complexity. That leaves me wondering what 
the advantages of this patch series are?

Thanks,

Bart.
