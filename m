Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F345D76A610
	for <lists+io-uring@lfdr.de>; Tue,  1 Aug 2023 03:11:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230032AbjHABLB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 31 Jul 2023 21:11:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229883AbjHABLA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 31 Jul 2023 21:11:00 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23F4EE67
        for <io-uring@vger.kernel.org>; Mon, 31 Jul 2023 18:10:59 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id d2e1a72fcca58-6874a386ec7so164804b3a.1
        for <io-uring@vger.kernel.org>; Mon, 31 Jul 2023 18:10:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1690852258; x=1691457058;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=T9oOk/sPnLg6KhqSvwUl5pntzMREa+KBoJXO16yvhfA=;
        b=J2TB1OyCMu4HNerikMm/NOwGn10gdNBuagcqXfWCVAmpk+iD/u896RLxXyRF86lCcs
         2XWvLhh0fziq8BrU5kVmb32QWEsHO1YJdvwImp2c0xT+3xwHIsM7UvuoPTL5pj2IFhZp
         aLGVrMXSHGQeB2BJUDlcr2SCTYYTK+zvRuTor+ndEJBmQkIHxp6t2do/dPJSMaKONRQX
         4qWpY9561ZGRmYSot9leaMX7aPKUiA16kzpf/ejFK+K0KTsM71jx0eoaaICG8BVO88DE
         xfe0N/oUiRBnEKoVaxR0jtaOC9A5xfIrVmb52eKlQybaqfnfdG5sz8TCBkaRRB0YOV5b
         9C9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690852258; x=1691457058;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=T9oOk/sPnLg6KhqSvwUl5pntzMREa+KBoJXO16yvhfA=;
        b=M/YFuFxglZW5XI3FPEh7MKC8FxP93hwqBv5CRo1HvzFjG3QyIQO6FscU7oslr4QFtm
         ofrpdyF/JBXNU2oXp2Go+A81hi4sn4gz5pmPkK/Ow/AkzSjWDMv2BjroBQdIJpLzU7G1
         qwOW2dE6+BIKEnOHLDzAxHvjeICF68hJm73k8OxPC2WSKj3yNd2MeBkLG74fW9RjqGwL
         TQ1f51lZJ8o1ThOCAuEJMmA3tHLz3sth4XqsnIS7tzR5XGEG87XOYJTFtM5FfbPn9T0f
         tncKQnreAvrmzzLbBvUpe06GUbY+r4CBJAO5z2XSruGVW+7h2rdVHrKv16sk9jME+JGe
         7Tww==
X-Gm-Message-State: ABy/qLb+lSZW9DYKSY4hcEvSv0aF41fKd5XpRvB8aGiK2umM9/dearel
        /2immPM6qCA/XMwj6cIoJA5vrXTAqJ/Y+yNtnjE=
X-Google-Smtp-Source: APBJJlERjeMCGQPa1VVzmXh07dQUE7nclh1dmf1iaeJHVml2AXf3Cu/FDIePJwaoxfJeBlc1Wh8xCw==
X-Received: by 2002:a05:6a21:33a6:b0:134:1671:6191 with SMTP id yy38-20020a056a2133a600b0013416716191mr10411955pzb.0.1690852258551;
        Mon, 31 Jul 2023 18:10:58 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id c5-20020aa78c05000000b00682562b1549sm8110251pfd.24.2023.07.31.18.10.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 31 Jul 2023 18:10:58 -0700 (PDT)
Message-ID: <a522b094-efbe-6634-540c-6566f4ae9d62@kernel.dk>
Date:   Mon, 31 Jul 2023 19:10:57 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH liburing] github: Fix LLVM packages conflict
Content-Language: en-US
To:     Ammar Faizi <ammarfaizi2@gnuweeb.org>
Cc:     Nicholas Rosenberg <inori@vnlx.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>
References: <20230801010434.2697794-1-ammarfaizi2@gnuweeb.org>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20230801010434.2697794-1-ammarfaizi2@gnuweeb.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/31/23 7:04?PM, Ammar Faizi wrote:
> Recently, the CI hits the following error:
> 
>   The following packages have unmet dependencies:
>   python3-lldb-14 : Conflicts: python3-lldb-x.y
>   python3-lldb-17 : Conflicts: python3-lldb-x.y
>   E: Error, pkgProblemResolver::Resolve generated breaks, this may be caused by held packages.
> 
> Fix this by removing preinstalled llvm 14 before installing llvm 17.

Great thanks, was just looking at this today and was going to email you
about it.

-- 
Jens Axboe

