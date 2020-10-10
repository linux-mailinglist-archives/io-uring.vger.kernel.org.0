Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2230028A3F1
	for <lists+io-uring@lfdr.de>; Sun, 11 Oct 2020 01:12:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731233AbgJJWzh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 10 Oct 2020 18:55:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730550AbgJJS6q (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 10 Oct 2020 14:58:46 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A914FC05BD39
        for <io-uring@vger.kernel.org>; Sat, 10 Oct 2020 11:58:41 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id g12so13899946wrp.10
        for <io-uring@vger.kernel.org>; Sat, 10 Oct 2020 11:58:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=GFK4+zi01hNdrif/rvUk3gGE2sX+e2zHHKv9hVzSI78=;
        b=MxnF4TWdOKDIfswaRPUmeQNYtseflvwPtGKy2G5qrPtxTEdOlAcn3yj6zKpGIYiy0T
         dqBpPPYtpZn5vnoldrNaVWBKAghRkEz9+wMRPXwC6RVp+WdAy9no5Yv6kDFi1VIJGvM4
         T0FeuCjfIGStLMxl4OPsigp4qBvJVe5osIqFti0rpswRztgtM4LK0R5GKNT1UGL8zLWR
         dqrrjZNwy33em6WVUS2MJnSRZhlkm3aYyZHaoAFQFzTt/UeG5hRZZ5/ZoATQ15xX6zoF
         C3QOystLxOLKvvDAgcryc0Ukq5UYYBUyR4pC5hxAyCbFGaIho5itHASSXzzsdedKnRRD
         3dEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=GFK4+zi01hNdrif/rvUk3gGE2sX+e2zHHKv9hVzSI78=;
        b=XG4RRFSivcCyEewDkyXYO1Hy97YhJ177Ary7W3ru43/+jdX2Nz2i72yU6d/sp/Yjql
         9zLfxzlc8n+aLctLGvKpRtjslhYasjkD9/ZIZVAL2BHBJCShAODwyHSk618l/n63ADFe
         qJNiCUY/x0+F8erGpzVfQrucLMEmcAQUtyw0RadbtW539lP02WAutTKodpY0mCoVv1/4
         tP8PtHQqxeHyoGX+HXTYsOGGBdtwr/etrytn+CVQ3jXdX7Fcq1JrM5Mb+fsKGTACzrWt
         Pv0RvqB5/sjdCQT99NBu+cpRSpA6XLHaoZcCEm3dK9IHA5e9dDzbUSqbXfwxLZKE+ac1
         vA8A==
X-Gm-Message-State: AOAM531Yo/VHLyUG8FCIyP9OfnTKFqHqX1f1Qw949iRg68bGwCIjcjPB
        ok5YrGFvsKsosULa1soM4nZfKn2P6/bC3g==
X-Google-Smtp-Source: ABdhPJwfWJSBm2MdMyAfScXTjcI5A96LYx7RAyzb+cE2Zt7PZBruQge6Eiym9sLqXVWIw5urScg4qw==
X-Received: by 2002:adf:92a1:: with SMTP id 30mr21303321wrn.269.1602356320341;
        Sat, 10 Oct 2020 11:58:40 -0700 (PDT)
Received: from [192.168.1.79] (host109-152-100-164.range109-152.btcentralplus.com. [109.152.100.164])
        by smtp.gmail.com with ESMTPSA id s125sm4414763wms.42.2020.10.10.11.58.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 10 Oct 2020 11:58:39 -0700 (PDT)
Subject: Re: [PATCH 01/12] io_uring: don't io_prep_async_work() linked reqs
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     Roman Gershman <romger@amazon.com>
References: <cover.1602350805.git.asml.silence@gmail.com>
 <26fb33734fee5294f3d20b8be9cf52848056a630.1602350805.git.asml.silence@gmail.com>
 <4b92981a-5469-615f-02e6-6f3f75d7ff3f@gmail.com>
 <0100dd0b-41fa-08c0-7644-5a06b9553a1e@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <7c24fa93-f52f-993b-b5bb-e196f5e41434@gmail.com>
Date:   Sat, 10 Oct 2020 19:55:52 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <0100dd0b-41fa-08c0-7644-5a06b9553a1e@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/10/2020 19:49, Jens Axboe wrote:
> On 10/10/20 12:45 PM, Pavel Begunkov wrote:
>> On 10/10/2020 18:34, Pavel Begunkov wrote:
>>> There is no real reason left for preparing io-wq work context for linked
>>> requests in advance, remove it as this might become a bottleneck in some
>>> cases.
>>>
>>> Reported-by: Reported-by: Roman Gershman <romger@amazon.com>
>>
>> It looks like "Reported-by:" got duplicated.
>>
>> s/Reported-by: Reported-by:/Reported-by:/
> 
> I fixed it up.

Great, thanks!

-- 
Pavel Begunkov
