Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D96E0560395
	for <lists+io-uring@lfdr.de>; Wed, 29 Jun 2022 16:48:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233563AbiF2OsP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 29 Jun 2022 10:48:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232039AbiF2OsO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 29 Jun 2022 10:48:14 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D76E23A2
        for <io-uring@vger.kernel.org>; Wed, 29 Jun 2022 07:48:11 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id x1-20020a17090abc8100b001ec7f8a51f5so19712825pjr.0
        for <io-uring@vger.kernel.org>; Wed, 29 Jun 2022 07:48:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=j9QY6RTs/vZDRd9DL3nbJ9URH+e5+TAsGyTSdpd/7IQ=;
        b=HY7vxJVbCG524z6WZnnyf5RkHp9eENfeCpYPpIrO1uEeoSzmRWplVgWFzVWVNOEcH9
         E0+09ON45TGzhC0X2XLLQ2jXA3d4LBXCNH32jaKf0PC5YR6YlYFUzUKphZXwcMZaO/ZC
         P5VlY53+7Onza2Ixcj3THEu9ccD0AjQfdgyprySZXeu7hWH9f8TxTQ5z3JeISbkdU2LQ
         Vmjgk1oYjNaWS1IDHsej+aL5kEFyP26qvLDKzeEueIlQAd11YSIIr2QNrOrIb08FB5cS
         sT1bKCrRXUWasmkqzEbEwjaEKbi/WSBdUSkT2mICHIUywxiXivdYyQdrrFsj0y1ZCK4z
         z23A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=j9QY6RTs/vZDRd9DL3nbJ9URH+e5+TAsGyTSdpd/7IQ=;
        b=MWuakrXmvd2GC5BV/5AM8Okttj6gr/FaOL2omsHLGAtu1fVgkr0Uy3ca2U9Pi5JhxY
         v/+A7CpEOpoEXgTOzAvdWGBcrLpJ58ubvkaJsxTvmwtS2IgBB5zI5gEQSzNgZu74Lyz3
         uT1gRN3uxhlNSrRhtHKaKzPTt7eGZJaO9GRbPOki/cLqfWBFJUHCPG+PU0bfJEAy1f8T
         CCR85I5/nWXQtZ4bGsVCDdvonROXstFn1J33DfPpkSFOvGW28FY7R7iCHfAnANXQbc0x
         xDhRPLU/QhAC91ayXChN5X3Uh8f+2qjiOHI+eN8pWy/1CJgiCsfVUFYZVIo13ZJixkQr
         Tbsg==
X-Gm-Message-State: AJIora+7fdzC/fkMd5brfsz8+NNjuWBi2f1phQLulpu3eBuhEzRczEa9
        dVV+Kj9/fkooI4Hnx4lfMxAXPw==
X-Google-Smtp-Source: AGRyM1tgAn2Ra0cO7A71VMpC8uikH8OLrY6DxNxbN7C2vhSgvjRdX3uFRlpIibiYeaItY7nkDtr4cg==
X-Received: by 2002:a17:902:8bc1:b0:16a:187c:8719 with SMTP id r1-20020a1709028bc100b0016a187c8719mr10973822plo.43.1656514091347;
        Wed, 29 Jun 2022 07:48:11 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id h24-20020a635318000000b0040dffa7e3d7sm5946217pgb.16.2022.06.29.07.48.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Jun 2022 07:48:10 -0700 (PDT)
Message-ID: <a2a07e28-4955-4b60-d2c4-2bfde114d6e9@kernel.dk>
Date:   Wed, 29 Jun 2022 08:48:09 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH liburing v1 5/9] arch/arm64: Rename aarch64 directory to
 arm64
Content-Language: en-US
To:     Ammar Faizi <ammarfaizi2@gnuweeb.org>
Cc:     Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        Fernanda Ma'rouf <fernandafmr12@gnuweeb.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Hao Xu <howeyxu@tencent.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@gnuweeb.org>
References: <20220629002028.1232579-1-ammar.faizi@intel.com>
 <20220629002028.1232579-6-ammar.faizi@intel.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220629002028.1232579-6-ammar.faizi@intel.com>
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

On 6/28/22 6:27 PM, Ammar Faizi wrote:
> From: Ammar Faizi <ammarfaizi2@gnuweeb.org>
> 
> In the Linux kernel tree, we use `arm64` instead of `aarch64` to name
> the directory that saves this arch specific code. Follow this naming
> in liburing too.

I don't feel too strongly about this, though I do think the linux
kernel is wrong in this regard and liburing is doing it right :-)

-- 
Jens Axboe

