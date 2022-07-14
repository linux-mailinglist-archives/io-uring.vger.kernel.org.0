Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 202A6575456
	for <lists+io-uring@lfdr.de>; Thu, 14 Jul 2022 20:01:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238568AbiGNSBt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 14 Jul 2022 14:01:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbiGNSBs (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 14 Jul 2022 14:01:48 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AFEA675BA
        for <io-uring@vger.kernel.org>; Thu, 14 Jul 2022 11:01:48 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id j12so1104236plj.8
        for <io-uring@vger.kernel.org>; Thu, 14 Jul 2022 11:01:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=V1iy1vUeILeAV0qo9g7bPFBJLX2IU18nkgRTbbV8PUk=;
        b=js3+HmzsuIQpk6AG6k05fL58nizaerjSLXmKfGB1v/6LwdPP5LxRd2/sdokMskIiIM
         OXxQsSheucM4adSo2ZSBeJYShWQVMYMJl+WXVnTZjsVw6sh+tFuKq5iQD0T5DxH8y0Y8
         Amohtexk2XSoYj02En8gqGasGqv9KB90qZYL/tglW4fRe3NBowiet5kOYNnUmNF27YqO
         zuxqfnDfkaY+9UixUK3ZbjPY6JyteF9Rgc5lp/e7wV35UQBBpl2a9Qh93bEnghQNSbjj
         DfjTgT6+bjvuHJntplv66pxFgo3M5JpPAwTBmRuN82Emu8JplFbAUKN+tzkNKmHA9IkU
         2TQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=V1iy1vUeILeAV0qo9g7bPFBJLX2IU18nkgRTbbV8PUk=;
        b=JXsxSOQihVjnQCPN8b9lZs0ldBAbCZKW7EsUWVSjbBPuBhUlsG6HvNKy4Izsg0sykW
         wJ2G2r+dCye5CiTB947rFR7A11q53qXSSO4gFXCUE+F+DVjZKPIdJwLzy/TOdeZR8E3z
         3yqrDZSww/KtYBDdfW79n51IhJByIOoIaWZazZIg89c/3L7dGoUZ7tSWrlY2KP0O2Nff
         /r9wVjX06RuMzLGtFbTY58LakJZ/oagM5091U+y9ieE5AQ+Py0nKLYU7A8POn+lQ9gTH
         0J+Q9UPYKYfvgdsMap7ludq9ZJAmoJYCttTUtDJOT/DuhIk9igRYis4pPzWdJoxw6uLt
         WYfw==
X-Gm-Message-State: AJIora8pDv1r8FkSDm8xOrkLKVTvVhcO025sxA2qRDBjLEmTNzPVtc25
        9c5/dd8nGLHWBo68c2xW2Xk5+A==
X-Google-Smtp-Source: AGRyM1syTNaCjxw536eKW52IhJhUXudDEwzByga0M13aUEVEy2hnwcxAzI2ejqtxPS6Wo69/KBM9cA==
X-Received: by 2002:a17:903:2686:b0:16b:d663:5b4f with SMTP id jf6-20020a170903268600b0016bd6635b4fmr9669451plb.129.1657821707684;
        Thu, 14 Jul 2022 11:01:47 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 124-20020a621982000000b005289ffefe82sm2029313pfz.130.2022.07.14.11.01.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Jul 2022 11:01:47 -0700 (PDT)
Message-ID: <7dd48665-c6f5-f51a-00af-e1c416ff78e4@kernel.dk>
Date:   Thu, 14 Jul 2022 12:01:46 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH RFC v2 liburing 0/2] multishot recvmsg
Content-Language: en-US
To:     Dylan Yudaken <dylany@fb.com>, asml.silence@gmail.com
Cc:     io-uring@vger.kernel.org, Kernel-team@fb.com
References: <20220714115428.1569612-1-dylany@fb.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220714115428.1569612-1-dylany@fb.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/14/22 5:54 AM, Dylan Yudaken wrote:
> This series adds an API (patch 1) and a test (#2) for multishot
> recvmsg.
> 
> I have not included docs yet, but I want to get feedback on the API
> for handling the result (if there is any).
> 
> There was no feedback on v1, but in v2 I added more API to make it
> easier to deal with truncated payloads. Additionally there is extra
> testing for this.

I'm going to shove this in for some testing. We have a bit of time to
play with before the next release, might make sense to attempt to mature
it in tree.

-- 
Jens Axboe

