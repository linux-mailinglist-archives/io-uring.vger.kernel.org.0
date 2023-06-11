Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A19472B0B6
	for <lists+io-uring@lfdr.de>; Sun, 11 Jun 2023 10:12:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229902AbjFKIMD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 11 Jun 2023 04:12:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229552AbjFKIMC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 11 Jun 2023 04:12:02 -0400
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8723E2D70;
        Sun, 11 Jun 2023 01:12:00 -0700 (PDT)
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-3f7364c2ed8so7860865e9.0;
        Sun, 11 Jun 2023 01:12:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686471119; x=1689063119;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nWpDQmZNg8zKVk12QskQ7NNS05C4fI/JmZBKLdKyu8Q=;
        b=egzgeU6eN8CK2MkKKsyWwFYv6fpkcQu0G2xFHRwd6xh3utM7FNd6LsGgu8fwFve8Ji
         mKWOs8U5yHZugDl4ZucKo0dNN+6obLiK9RK9K15NXL33Gdom25mxVTV9jumr1u02puL+
         FoYj9InERLTA6lYmcqvmarxe1oYXHisaFMy9yk58XPNHomDjgxat8fPdgIECS1u2H4ae
         ea3mdtlQW3Pde1w/nu8bCG3WlN1OL1bQEJRh6l6I4/V0KLpRJ5OPkp54kWYuZY9+o23z
         B6rx5OHWcs9HrGdlPKI1K2Vthvi6pldTt+Wp74lXZ5llbPN2RFq8M6rxQA+C4J9VsJEF
         ZX3Q==
X-Gm-Message-State: AC+VfDxsNOJpeK525x8ASlPBAzk9Bjep4ONx8r1jvOz40wLe9ZT3vCeq
        3KQmHt8jT80AenFU+yWk4CU=
X-Google-Smtp-Source: ACHHUZ64frQa+gMpcjF6rcObCQafPY4X/Q7kQS32yU1aAfWzdv9vipvatKYvGhgIIc8uqziiaG7ZjQ==
X-Received: by 2002:a05:600c:468a:b0:3f7:f519:355f with SMTP id p10-20020a05600c468a00b003f7f519355fmr4980461wmo.0.1686471118935;
        Sun, 11 Jun 2023 01:11:58 -0700 (PDT)
Received: from [192.168.64.192] (bzq-219-42-90.isdn.bezeqint.net. [62.219.42.90])
        by smtp.gmail.com with ESMTPSA id 14-20020a05600c024e00b003f8044b3448sm7366451wmj.9.2023.06.11.01.11.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 11 Jun 2023 01:11:58 -0700 (PDT)
Message-ID: <9a43577d-5e69-88ee-62ab-e92524b1ed87@grimberg.me>
Date:   Sun, 11 Jun 2023 11:11:57 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCHv2 1/2] block: add request polling helper
Content-Language: en-US
To:     Keith Busch <kbusch@meta.com>, linux-block@vger.kernel.org,
        io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        hch@lst.de, axboe@kernel.dk
Cc:     joshi.k@samsung.com, Keith Busch <kbusch@kernel.org>
References: <20230609204517.493889-1-kbusch@meta.com>
 <20230609204517.493889-2-kbusch@meta.com>
From:   Sagi Grimberg <sagi@grimberg.me>
In-Reply-To: <20230609204517.493889-2-kbusch@meta.com>
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
