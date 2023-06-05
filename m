Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25F8A723379
	for <lists+io-uring@lfdr.de>; Tue,  6 Jun 2023 01:03:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232055AbjFEXDh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 5 Jun 2023 19:03:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229873AbjFEXDg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 5 Jun 2023 19:03:36 -0400
Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E46998;
        Mon,  5 Jun 2023 16:03:35 -0700 (PDT)
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-4f4453b607eso804926e87.1;
        Mon, 05 Jun 2023 16:03:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686006214; x=1688598214;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nWpDQmZNg8zKVk12QskQ7NNS05C4fI/JmZBKLdKyu8Q=;
        b=ieEdtxLcPOoa41BNpRUY8SWKdsD1hUkVRoQ/3GpvxOIqVR3ofSl+M390lyt6qNRzcb
         8+NSjdjIOCRfNZY+hDB4iUQKWMBinX0q/dvuXlz1VlwJv/Fk4OwG4Q5d6rXYdIiaCjbm
         2dVTcyPn3POpfxUVBa60D3apg6dEEi6KP3NJHLme9JIhCnss5ZwejOykonTiOo3VbyKS
         e+cmzrL7/yWFE64PeXdXBsyAgEyaOnVMz2U1nXBLGyfFULO09kCHkF+GszEqpUokjrBf
         1EAd6OWewT+d5vuM/5BXWiM4RtPELjdtMZB35cddA0rTNyoicLMgjnxo7SQdzweLNm8j
         9xBQ==
X-Gm-Message-State: AC+VfDxcv0Lwq/s5A/yMhkZwEWV0bkjf1StUN4MkBhR2QI5VpA9/6kBE
        UxblUbzV30DsnxTEiSm/3GI=
X-Google-Smtp-Source: ACHHUZ5heC6RO5iwssXv/7QicJFpzgXr4CeRZuzfl4n1vcrP+cd/jbhE/6OmnSPD42SmqB7HS//AxQ==
X-Received: by 2002:a05:651c:381:b0:2b1:c077:8d9 with SMTP id e1-20020a05651c038100b002b1c07708d9mr227353ljp.4.1686006213574;
        Mon, 05 Jun 2023 16:03:33 -0700 (PDT)
Received: from [10.100.102.14] (46-117-190-200.bb.netvision.net.il. [46.117.190.200])
        by smtp.gmail.com with ESMTPSA id w13-20020a2e300d000000b002af25598f07sm1610684ljw.78.2023.06.05.16.03.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Jun 2023 16:03:33 -0700 (PDT)
Message-ID: <3c78324e-0c00-8fe9-9827-a278e7b1ecad@grimberg.me>
Date:   Tue, 6 Jun 2023 02:03:31 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH 1/2] block: add request polling helper
Content-Language: en-US
To:     Keith Busch <kbusch@meta.com>, linux-block@vger.kernel.org,
        io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        hch@lst.de, axboe@kernel.dk
Cc:     joshi.k@samsung.com, Keith Busch <kbusch@kernel.org>
References: <20230530172343.3250958-1-kbusch@meta.com>
From:   Sagi Grimberg <sagi@grimberg.me>
In-Reply-To: <20230530172343.3250958-1-kbusch@meta.com>
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

Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
