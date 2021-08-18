Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77B473F0491
	for <lists+io-uring@lfdr.de>; Wed, 18 Aug 2021 15:26:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236365AbhHRN0d (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 18 Aug 2021 09:26:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233722AbhHRN0d (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 18 Aug 2021 09:26:33 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96F5CC061764
        for <io-uring@vger.kernel.org>; Wed, 18 Aug 2021 06:25:58 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id x4so2224405pgh.1
        for <io-uring@vger.kernel.org>; Wed, 18 Aug 2021 06:25:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=qnkVcwdzdoQ7ElvLpgt+X+JMwwMev/3CrKKq7Vk2u2Y=;
        b=erAmwvoIuwo7aTCcYNrGn1hatfhXA8CM/WcSPbwsyJcbbj+z/kZ0UPJbo+WYNGJ6KB
         sTW6oqxscjs6NZccvOHCYrWAxyiI4yWk3xPfvHACMhrquBqvN8DPaCfYc+igZwxMX8ru
         mwAb/GackNykr6oo3mkhTDpT6isPSecuCBhs2PEbAJIwJOFigWqg6j9wvlwce5nmbiVt
         nyxEvXU2MbY07znCZqg/AGxBWggT/axW07Q2duAE8EHF495J6qqsgLLAg0dk4f2926r7
         2DdGX2n0nYF6D5Lssxbj9DLByRTYmH67zNVqRsv4Vc4cwmixkCFjdvwpEli5E5YxrUj5
         VMUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qnkVcwdzdoQ7ElvLpgt+X+JMwwMev/3CrKKq7Vk2u2Y=;
        b=Ulwopw3ifoCMUlNXyzCON2O/2EBMLqrp6ocs8DLBf+MSAxxmwcWyaSy6MsKvY1lrDN
         pmaQw9wn9ncuJ2FkpNKtHQ5w0//+/A/W1kvSoO3DkjZkuD7uo7cYIC1hH2taJXA5hOY5
         7fTReHklPHVa8iSQCO5kx36rtHUIqQsFWTlpJnqFYjNrqPLjS0FzLYnSeiH0YrZrnj6F
         j8Wa2BKyrS3I6zPmteZrR2iDn6hX8yxuBfYky4pM808zgxRzi6HUgqd5ZGjg3pzIDK9L
         GuZe+askjOCixOh5s9GsKbTcAG3b9qP23fVu49/3I6t813ztDMh/UUnRDavi6IFGD99D
         elbQ==
X-Gm-Message-State: AOAM5315Yr2L1JSs7YR/FKV2FE0/XF9jNmDvSOcMvXm1QkPb1GrKb3hy
        d5gq06z3sMuw/lJFICvV9V9p5aStTof5ZKGL
X-Google-Smtp-Source: ABdhPJxsVvH9Aa0JomGjF2x7bbIhzOC8c57lsirMlmKzmF17QKQONXmRO0XfPsAWBRbb/4CpdkzOZQ==
X-Received: by 2002:aa7:88d6:0:b0:3e1:4732:e8e3 with SMTP id k22-20020aa788d6000000b003e14732e8e3mr9365944pff.14.1629293157909;
        Wed, 18 Aug 2021 06:25:57 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id w130sm6414586pfd.118.2021.08.18.06.25.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Aug 2021 06:25:57 -0700 (PDT)
Subject: Re: [PATCH for-next] io_uring: fix io_timeout_remove locking
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <d6f03d653a4d7bf693ef6f39b6a426b6d97fd96f.1629280204.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <d53e65aa-17a6-745c-e885-a6ba381f4efe@kernel.dk>
Date:   Wed, 18 Aug 2021 07:25:56 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <d6f03d653a4d7bf693ef6f39b6a426b6d97fd96f.1629280204.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/18/21 3:50 AM, Pavel Begunkov wrote:
> io_timeout_cancel() posts CQEs so needs ->completion_lock to be held,
> so grab it in io_timeout_remove().

Applied, thanks.

-- 
Jens Axboe

