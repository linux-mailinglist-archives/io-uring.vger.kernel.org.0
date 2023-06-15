Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA4A7731A33
	for <lists+io-uring@lfdr.de>; Thu, 15 Jun 2023 15:40:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344462AbjFONkX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 15 Jun 2023 09:40:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344229AbjFONji (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 15 Jun 2023 09:39:38 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 107523C35
        for <io-uring@vger.kernel.org>; Thu, 15 Jun 2023 06:38:20 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id d2e1a72fcca58-6584553892cso1906560b3a.0
        for <io-uring@vger.kernel.org>; Thu, 15 Jun 2023 06:38:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1686836258; x=1689428258;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gNUKvq1f2fPVIon6l0YzXfgd6FlRDBSHq7wAWbzvj2I=;
        b=flAMMBYgJBeFy66IwkkmQLyeg9wKcLCDWR6DRCXb57F1RoUVhVdHGJqgmtxczRH57R
         my6oKxp2XoRguD94TcFKU9RuWK/jweawjfMyeTj49OwhiO/xoaUe8A9S7PNunJXrtfyt
         Az22NNINYuV1WHu08ktHIWdwKFKZ8/0Ek87pqPR3HjrX6novVillhpT8dL0KMEyMygiH
         qP9RkhE3ALnILFlSh7hxfb0jjJv5fwSbEt0vTwlFjRKHn8K6fpycRRIgeS22PrqBzDjQ
         ntS6uuDGIf/dyf+Vf3HaCypsXrvcGrU193xROQqhSNz13cmKBmFSe/jKMmFqBrLuEbOr
         fsQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686836258; x=1689428258;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gNUKvq1f2fPVIon6l0YzXfgd6FlRDBSHq7wAWbzvj2I=;
        b=KC5KKh/6YB814G5zi0fS8NH50cwlZB857BZiKORTCa3WuJWBINRgJFDYpKCT2ro3gW
         xJrtmplJ+Gec5cRAAmWyTimONrVMNjp5m63mVXOMs+PFj7nMFHBB51h00GB7crR0uQYd
         3X0t2JLhARP6a5C21OdYm2piwkvPngfWKH3kTNgsq5Ft6+OTyuOmqSvFtcBMKscloQCd
         WA5UL7z8zm8Vs/KaGNa5rvcDP0bUIHsb+4CcS2eUffIUudSxsbGKw9uHHIP1k030jf+q
         vnIErYnshn6aNPDbsa772Xp2aTaItsXmgt+P/OymnPu9RutX1wiPIV65u1Y79w5NAELy
         HgDg==
X-Gm-Message-State: AC+VfDyNJOC95KaW7nSrnDl4okDG7L7nLUvpT+ZQucaU9lslJvRh6aA+
        dt+gMXRqJEKUIie9gQ1fK17ZGw==
X-Google-Smtp-Source: ACHHUZ4opAqcTtMFCaB8V993Ma17+PA1z1Sbk4Kq2cSpgeQuBmBHlS1XK5+Dd7Mie0TbM1nvegdYyg==
X-Received: by 2002:a05:6a20:42a5:b0:116:696f:1dd1 with SMTP id o37-20020a056a2042a500b00116696f1dd1mr23464104pzj.4.1686836258489;
        Thu, 15 Jun 2023 06:37:38 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id t13-20020a62ea0d000000b00660d80087a8sm12009948pfh.187.2023.06.15.06.37.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Jun 2023 06:37:37 -0700 (PDT)
Message-ID: <763cc719-f62d-529c-a1fd-75cb2554a84b@kernel.dk>
Date:   Thu, 15 Jun 2023 07:37:36 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH] tools/io uring: Fix missing check for return value of
 malloc()
Content-Language: en-US
To:     cymi20 <cymi20@fudan.edu.cn>
Cc:     "ammarfaizi2@gnuweeb.org" <ammarfaizi2@gnuweeb.org>,
        "asml.silence@gmail.com" <asml.silence@gmail.com>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20230615125045.125172-1-cymi20@fudan.edu.cn>
 <34898926-681e-1790-4303-e2b54e793a62@gnuweeb.org>
 <ec762677-f8d4-94ab-e7b3-adee45a052a1@kernel.dk>
 <F5DC6786-D8E5-435F-8FDE-ABD4DD692367@fudan.edu.cn>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <F5DC6786-D8E5-435F-8FDE-ABD4DD692367@fudan.edu.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/15/23 7:26?AM, cymi20 wrote:
> Actually this checker is driven by inconsistency, it find almost all
> callsite of malloc() in this module has Null check, except this
> callsite.

1) don't top post
2) don't send html emails

But more importantly, actually check the code before making wrong
statements like that.

The patch is pointless.

-- 
Jens Axboe

