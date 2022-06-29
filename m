Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E96F5606E5
	for <lists+io-uring@lfdr.de>; Wed, 29 Jun 2022 19:03:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231789AbiF2RCu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 29 Jun 2022 13:02:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229845AbiF2RCu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 29 Jun 2022 13:02:50 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D5683A183
        for <io-uring@vger.kernel.org>; Wed, 29 Jun 2022 10:02:49 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id x4so15714295pfq.2
        for <io-uring@vger.kernel.org>; Wed, 29 Jun 2022 10:02:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=u5uvyqIYcD/dpBONpmMI0Aud9ZyD5zk/KpzB1AX3wrU=;
        b=nmT0rrFI4OWRjrm3OF2nMPvASz7Q5fCeeoEd9V2L/nRsulOPn/enRIQFBAwZNf/m4Q
         2ME01i2okajm0iBxBILJ0fNK773b5izgkEuus/Aq4sqvH+o6N2yrfLB/sqSojpTr/44z
         X0dCfhLd4xPKMzv62uk9yFJ07S7mSkP40LAA7HyeAGirvOfz/tnaVyD3Og2f0TND54ML
         8pB0tzsDee7x6PwRuYZt67DicIZC9Gwrp5PZna+cUC9a0g5MdzbEcoxF5+OCbGz/jjNk
         tDqnkNolMqD3YpVZlPv9JPu7vtSD1iloN5t1SUrq1d9cFo9c0wVNUKGrkzic+vCHSOn3
         28+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=u5uvyqIYcD/dpBONpmMI0Aud9ZyD5zk/KpzB1AX3wrU=;
        b=LuFw6M+d9XvG0Fzhu7Lt5dDmYzQ5dYeNguiX7BPjJ/u74K00Vyh06LGGwdMnUTM5iT
         xhb70t4SQeHKuDdifCQCBkEmCWrXPdB2cm1J8bfQRG2ec57B63KNh5g3ndZnCvm8BHuR
         r9PEJ1e/h5ztkqVVaSBJChiOSPk/opp1mFw8fulHeGqqjBDrREfRduNiUg7NTcYyMU7S
         Pyvfx86TS8eeIqGcdGKV1a5Y1Oy6xDpFAajF7zMUJ9L4TC+67INKuTSiXaVrvRQjIy+1
         ifJIN1R7DZXGR57FcvyoOm42KYvEafYucbf0BbPjWAyCHafdcdW5ZCilSpqZr9Wxlawc
         uAeQ==
X-Gm-Message-State: AJIora9mw/yMNQJZLofsBhRl253hxAuW6dDVlEEuLWxJyAEgi2M4PECz
        GSItO/jlUg2mpUtDjDK7Zd8Gy3RvyONDpQ==
X-Google-Smtp-Source: AGRyM1sYkBijZZcx5LINPTUlVBL0JEbGgXgiFUlL0uQV6WFos9aUH/IBVckXAW/tY1bJA4G0vIi74A==
X-Received: by 2002:a63:d1:0:b0:411:885e:1503 with SMTP id 200-20020a6300d1000000b00411885e1503mr2417243pga.65.1656522168724;
        Wed, 29 Jun 2022 10:02:48 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id kk2-20020a17090b4a0200b001cd4989febcsm2470319pjb.8.2022.06.29.10.02.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Jun 2022 10:02:48 -0700 (PDT)
Message-ID: <366e9a2a-dba4-0cc9-4ad9-6ade1baf59f9@kernel.dk>
Date:   Wed, 29 Jun 2022 11:02:47 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH for-next] io_uring: let to set a range for file slot
 allocation
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <66ab0394e436f38437cf7c44676e1920d09687ad.1656154403.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <66ab0394e436f38437cf7c44676e1920d09687ad.1656154403.git.asml.silence@gmail.com>
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

On 6/25/22 4:55 AM, Pavel Begunkov wrote:
> From recently io_uring provides an option to allocate a file index for
> operation registering fixed files. However, it's utterly unusable with
> mixed approaches when for a part of files the userspace knows better
> where to place it, as it may race and users don't have any sane way to
> pick a slot and hoping it will not be taken.
> 
> Let the userspace to register a range of fixed file slots in which the
> auto-allocation happens. The use case is splittting the fixed table in
> two parts, where on of them is used for auto-allocation and another for
> slot-specified operations.
> 
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
> 
> Some quick tests:
> https://github.com/isilence/liburing/tree/range-file-alloc

Can you send in the tests too? Since 2.2 has been released, we can start
shoving in stuff like this too.

-- 
Jens Axboe

