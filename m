Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FE614252F3
	for <lists+io-uring@lfdr.de>; Thu,  7 Oct 2021 14:25:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241310AbhJGM1n (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 7 Oct 2021 08:27:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241197AbhJGM1n (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 7 Oct 2021 08:27:43 -0400
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E178C061746
        for <io-uring@vger.kernel.org>; Thu,  7 Oct 2021 05:25:50 -0700 (PDT)
Received: by mail-io1-xd35.google.com with SMTP id n71so6592293iod.0
        for <io-uring@vger.kernel.org>; Thu, 07 Oct 2021 05:25:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=SgWdgIC6+lca12Dh9F1TkmskSTYyo4p0U/CoUQEmy7g=;
        b=Nmj6nsWK+73g8FsIkb/y3mThQBBXUks96/6WqOMJqby3KYmO7L59GX/IJpDw5IYY+O
         amff5bv6icSQt7mKom94wycKZdXmtW1etPDXY07+4apKA5y3nh6aLMdW6gZ5Q55ZOoGy
         05GGDEcTn5qe48DIt2aaAyNaKX02Slabx//BCnsZmp/JCckD8gOMmhR3c/itwwPsvShR
         Au5tF6HpTvAnfMKb+vGnwCUd+2MMAqhrO8kZMG9ZB7+e8/hbNvg8TViBRUuwHf61AKeJ
         dU8OuGWUrw1PE3pKvKD3g4GeIeZYeNhGvrMZ4UK92SpJCt6j2lTT5t65aqoPpLJoqnKT
         xdmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SgWdgIC6+lca12Dh9F1TkmskSTYyo4p0U/CoUQEmy7g=;
        b=eocProcksmG0iJZ+GI+/mrwbzO7TFHc7mILWBlL/rvXfLg+Z1R/CR2LL5L0qjpauro
         1S5VN00KzLszhLUBHtjDWhherAOk1A0sQR4k+oebqapIp2d6KauJO02AF3+QOap2dgKE
         5kbcU2Cy4PmT2EKktBNDCOG/d87DBTrRnUMMF/TRKng2i8UG6VNa/36NTM7OCGIaI7IS
         eMzkQGrKTvvMmkUSDSnjO29RVeOshTtfxZdTMbZpquPkMq8egPU+S4WPO6Opai6oWO2B
         LmoQEhfLdR4xT7Vk7MNRe9miFlpeC8h+5xpTa1xCS6nNZtgUHtOtviEP5uR5TaG5n37h
         X7BA==
X-Gm-Message-State: AOAM530ihHzcFuJ3j4Nb0xx/mK2EiGy3SZtbm7g76t8h/rYWsyfgm1qq
        3kovmBT8nctW2gI119Ko0xGdEA==
X-Google-Smtp-Source: ABdhPJxNmn/ahzCFjlsEh63oaPfyZrmKf+tpnoClGjWIcely3WNh846/oTfkwGiy7dRbliJ4kgcfGA==
X-Received: by 2002:a02:8643:: with SMTP id e61mr2655266jai.97.1633609549232;
        Thu, 07 Oct 2021 05:25:49 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id o11sm15735670ilu.0.2021.10.07.05.25.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Oct 2021 05:25:48 -0700 (PDT)
Subject: Re: [PATCH v2 RFC liburing 1/5] test/{iopoll,read-write}: Use
 `io_uring_free_probe()` instead of `free()`
To:     Ammar Faizi <ammar.faizi@students.amikom.ac.id>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>
Cc:     Bedirhan KURT <windowz414@gnuweeb.org>,
        Louvian Lyndal <louvianlyndal@gmail.com>
References: <a8a96675-91c2-5566-4ac1-4b60bbafd94e@kernel.dk>
 <20211007063157.1311033-1-ammar.faizi@students.amikom.ac.id>
 <20211007063157.1311033-2-ammar.faizi@students.amikom.ac.id>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <6d4adcec-0b75-6501-c79c-8a2c9f296fae@kernel.dk>
Date:   Thu, 7 Oct 2021 06:25:46 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20211007063157.1311033-2-ammar.faizi@students.amikom.ac.id>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/7/21 12:31 AM, Ammar Faizi wrote:
> `io_uring_free_probe()` should really be used to free the return value
> of `io_uring_get_probe_ring()`. As we may not always allocate it with
> `malloc()`. For example, to support no libc build [1].

Applied, thanks.

-- 
Jens Axboe

