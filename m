Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81B1176C0FF
	for <lists+io-uring@lfdr.de>; Wed,  2 Aug 2023 01:35:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229997AbjHAXfP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 1 Aug 2023 19:35:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230274AbjHAXfO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 1 Aug 2023 19:35:14 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 404531B1
        for <io-uring@vger.kernel.org>; Tue,  1 Aug 2023 16:35:05 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id d2e1a72fcca58-6862d4a1376so1561143b3a.0
        for <io-uring@vger.kernel.org>; Tue, 01 Aug 2023 16:35:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1690932905; x=1691537705;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dkyQ5mGXv5tDN3VlFhqUQ/5LN/Jl3KXt1aFfp7FfZ/k=;
        b=eDBOqb7c1SyBBspA+Na1La+wPcz8m8I0+8U9D4kSNIrM6VSqGxGVToziNzOqykz/g+
         0S0UCOL1DnWNSUQuU9qcTYpaBVM7/S/0kEKUo7lnu2aznuF/vc6arKmEcIwuXm6C+xVz
         RFeRgeI7CyyB6zdJwzh3yc2SzRj/JaF8/Rz0wvMlRr9OOWTaQZgSzJr8FGuoZIikRhVx
         K9Gg53E/FglPMermFMTnqjaG99ohNJUBZ+v3Qe3wEOk85ezPzATiDjr6uFFVHzTXQ3Gq
         /2hfgXuF0utw3b2lD5/4BfC9afF0of3Z+1i2OZEAIHotME7RGJCp4lLkM8xk02kThLg4
         78Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690932905; x=1691537705;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dkyQ5mGXv5tDN3VlFhqUQ/5LN/Jl3KXt1aFfp7FfZ/k=;
        b=E29VGrL4c9x4OCVAvTv0diWWdbtIZ6PQZ5/GhkYJlX+kQgEf9nuM3ZyKOjHSA+pg/q
         GszUfsjblUhyD9ZNAxWWMLCKHPykMEuP1nUTIWYowDr5T9v1YZHQjL4MAay2Lv0AXWo+
         PkKprfUsnqLTrlF7J6c7+UuUFCTJlwuva9n2OKXhkeSzGvw8fIzvPQ/btcqHX0MMmmi5
         aZ+XM/H71KDMKRYRLfenb066BetnVBowdUGg5asfPMCZkiRlpp2jr2qhuMVrydgvhlWA
         5vPM0NG+Q2SfCR2ldon3absyPbK+nj4o8hP33UMBYCaJJiFgx7dhiotf3RpLqQOyxcNy
         2CmA==
X-Gm-Message-State: ABy/qLbH9sBVI+0p4lJBfdKBRRUvLmxbhknAul4qxO1Jt92SqP54LRgo
        9ZhKCgdLMg4foFB43km9Fop4Kw==
X-Google-Smtp-Source: APBJJlEHpNrym5p4+nrbk4k+mBpBpDrGPiFO73CLnUpZ02yjUIRkEJi2h4JqCmMrwWpHyxqIpvrzLg==
X-Received: by 2002:a05:6a00:1d98:b0:682:59aa:178d with SMTP id z24-20020a056a001d9800b0068259aa178dmr11952269pfw.1.1690932904585;
        Tue, 01 Aug 2023 16:35:04 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id x41-20020a056a000be900b0068703879d3esm8933102pfu.113.2023.08.01.16.35.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Aug 2023 16:35:04 -0700 (PDT)
Message-ID: <c033ea82-43af-23f0-e8fb-acb8a6a9571c@kernel.dk>
Date:   Tue, 1 Aug 2023 17:35:01 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [GIT PULL v2] Improve iomap async dio performance
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
To:     "Darrick J . Wong" <djwong@kernel.org>
Cc:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        io-uring <io-uring@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>
References: <98cbe74e-91d8-9611-5ac0-b344b4365e79@kernel.dk>
In-Reply-To: <98cbe74e-91d8-9611-5ac0-b344b4365e79@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/28/23 7:47 AM, Jens Axboe wrote:
> Hi,
> 
> Here's the pull request for improving async dio performance with
> iomap. Contains a few generic cleanups as well, but the meat of it
> is described in the tagged commit message below.
> 
> Please pull for 6.6!
> 
> 
> The following changes since commit ccff6d117d8dc8d8d86e8695a75e5f8b01e573bf:
> 
>   Merge tag 'perf-tools-fixes-for-v6.5-1-2023-07-18' of git://git.kernel.org/pub/scm/linux/kernel/git/perf/perf-tools (2023-07-18 14:51:29 -0700)
> 
> are available in the Git repository at:
> 
>   git://git.kernel.dk/linux.git tags/xfs-async-dio.6-2023-07-28

Darrick, I collected Dave's reviewed-by on all the patches. Same pull
request as this one, only the commit meta data changed:

   git://git.kernel.dk/linux.git tags/xfs-async-dio.6-2023-08-01

Please pull!

-- 
Jens Axboe


