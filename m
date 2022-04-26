Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1118B50FDD5
	for <lists+io-uring@lfdr.de>; Tue, 26 Apr 2022 14:55:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350253AbiDZM5w (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 26 Apr 2022 08:57:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350308AbiDZM5w (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 26 Apr 2022 08:57:52 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6F6B17E21D
        for <io-uring@vger.kernel.org>; Tue, 26 Apr 2022 05:54:44 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id b15so17885046pfm.5
        for <io-uring@vger.kernel.org>; Tue, 26 Apr 2022 05:54:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=ZqW7zvBAkMd51AgVSVsJQFVitcUOc0dr0M/KiG1Psiw=;
        b=ODcY1qBX6Jq+yj5zj0HaI/wmj86npUEaej2F8o1gOQnRrPXw1zqDu9Ax+0Y/QTG+9T
         YWwBiNe3fIsIYg6UWfFQIfo27clvFYHBNj7nxyYSAVgCEQRwS4fqBYVkQZa38ja17arl
         CPPbMbUGC1vD/agaiaKnXzJWvjupHwXJxWf4zJTkj33kYbRIpBaLOvWA3UN5KmagjYKK
         GZfSR/Wy6Wv2bCDhewowP/Nrd1Fx48sKl0VhJ8qjQC9e2XEzIFfRIFacRKXJkhWyf8mx
         Q2rVyXctRIyxNPl0u50UWN0c5i1wgUY8vTvmUjGk2t7AlMlUWRoIPbSXvxI/yxrrR2+x
         iLqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ZqW7zvBAkMd51AgVSVsJQFVitcUOc0dr0M/KiG1Psiw=;
        b=v+7y7E3Cp2wpffqIdNtBd4yFWsyR7jlI4OG3YUUY0nUbCYuO0TrkSllCs7NpARLvvQ
         K2eJHmjoxZ7pUsQBaWdo7oyplNrCp2ej0zGcRriQIJfrVSF5+LFUYE6Y60on4+j11rg/
         suxtv152dR0+Fhnfco90RYNVQxrdYooJOQrVjowDR5+sHc0nlN/qES3oHlqNOkL3yc4R
         DtQ5Af2j5DXsRxT+fmfEXDKmmUDDvcHba4ohWVMpOywyPQikq2ndXPDWpRYStl3cQ14L
         kM3Ekiy3sGDWfT+YJqqUpRD2tlNfz271phkgX8fJINWdERERNEPSc2WVnY6vFkz0sS7T
         Lb+A==
X-Gm-Message-State: AOAM530DsLKCseD5yIuleeVqKfXqj+z6ObPJwPLIV6u/MGDyytCCpwxF
        zsJaM/kPuJyYM9mfYq8FSFS1JcdKV6r8iTkx
X-Google-Smtp-Source: ABdhPJxhyyQ2DDiUpHZz1TcTaVa3xu5irO0mNpVNFYiW2LXOJcclBaQ0v0hEZa+PUPh+qjKSRnv2Uw==
X-Received: by 2002:a63:e355:0:b0:39d:7956:6d3c with SMTP id o21-20020a63e355000000b0039d79566d3cmr19527497pgj.385.1650977684229;
        Tue, 26 Apr 2022 05:54:44 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id o34-20020a634e62000000b0039cc4376415sm12803817pgl.63.2022.04.26.05.54.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Apr 2022 05:54:43 -0700 (PDT)
Message-ID: <9c8c0f8d-3495-b411-7ef4-27bbc0dc1141@kernel.dk>
Date:   Tue, 26 Apr 2022 06:54:42 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH v3 00/12] add large CQE support for io-uring
Content-Language: en-US
To:     Kanchan Joshi <joshi.k@samsung.com>, Stefan Roesch <shr@fb.com>
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        kernel-team@fb.com
References: <CGME20220425182557epcas5p2e1b72edf0fcc4c21b2b96a32910a2736@epcas5p2.samsung.com>
 <20220425182530.2442911-1-shr@fb.com> <20220426113741.GA22115@test-zns>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220426113741.GA22115@test-zns>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/26/22 5:37 AM, Kanchan Joshi wrote:
> On Mon, Apr 25, 2022 at 11:25:18AM -0700, Stefan Roesch wrote:
>> This adds the large CQE support for io-uring. Large CQE's are 16 bytes longer.
>> To support the longer CQE's the allocation part is changed and when the CQE is
>> accessed.
> 
> Few nits that I commented on, mostly on commit-messages.
> Regardless of that, things look good.
> 
> Reviewed-by: Kanchan Joshi <joshi.k@samsung.com>

Thanks for reviewing it.

-- 
Jens Axboe

