Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 961B555AA20
	for <lists+io-uring@lfdr.de>; Sat, 25 Jun 2022 14:49:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230187AbiFYMti (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 25 Jun 2022 08:49:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232238AbiFYMti (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 25 Jun 2022 08:49:38 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B740B17AB8
        for <io-uring@vger.kernel.org>; Sat, 25 Jun 2022 05:49:36 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id 73-20020a17090a0fcf00b001eaee69f600so5250381pjz.1
        for <io-uring@vger.kernel.org>; Sat, 25 Jun 2022 05:49:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=W6z9MDdWQAeZFYfWCVPuCMW8m/oKTe3rmhmSSbsLOhk=;
        b=YRPEy5S3ef2dqe5qquLsBoq0wdzJd2R77tG/rR5s+T3AIxH/HYa+Nbu6tAGKQX6lZo
         +v89kFfZR4FOKgBEuIh0WXldhb6hMsYiYJiSjm/zk9eY8E7GYmEm7v123OZpzrcL1z6R
         Gig/5pQrf4HLTUXdDfHfC926DLxqT6f6eSxsho+X+Xq8VRdfq/6Uxyh04vxRZ6E+ICvJ
         DripBisKSePbgv7VxbxyAsAl5fIfAFmPzikrtPqqQRIKxyb+qQC4QUIfUoLtLF5iO6UN
         xXin3wW7lp0VVVbSnjPSbUpUW7wQHCqfpcMV3KD2I7KjsKRmToB8/Ke+PsUJUPQ3/P8T
         RajA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=W6z9MDdWQAeZFYfWCVPuCMW8m/oKTe3rmhmSSbsLOhk=;
        b=qkBJin10xVyWlvsUHhSeNlcTvYin3wZPqA4CRbM8Hqcsmt8Ig9aS2UPwIh/E1Pyk6R
         PQa+8DfHX7+ZYN+3vx3rOMM9mLXDu/0F7PXBV4yUafxHClDO+JZMVoSyA1xnSxxnHCuH
         ndh9Irht2GDkmjLB6LSe33Ej14kSjMYI/xWA3RuWdkQ/b6XI9WC8wiJ0aSPLpQQLMmTn
         6MGxCZSlTeHKxkParMPy2Bh2mIlWzeSnQZ0g40enph8ItRrjgD5IS18DA2tD3/4cnli1
         BGRwgxPxmIqHEVXtgzLeVyciAoerHvD9aExahggP6ig9wx12seuK8AMmh+diXnQ4iIvx
         kgNQ==
X-Gm-Message-State: AJIora8aqOjz7aDOiwFH2B5hYaDPelqGcLadB1XL3VZbwfITz4ijPegM
        a3Rurtv7RiroiOgAhIhq6hGBsg==
X-Google-Smtp-Source: AGRyM1vjmd6c+3t68nRU6r+03rblGvDChHfFhHLaUYTEA7vcdSuFWKsX14nCIDdVtmuS+7KwPKoLhA==
X-Received: by 2002:a17:90b:4c8f:b0:1ec:cdd0:41b7 with SMTP id my15-20020a17090b4c8f00b001eccdd041b7mr4440573pjb.119.1656161376219;
        Sat, 25 Jun 2022 05:49:36 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id l4-20020a17090af8c400b001ed2fae2271sm2461170pjd.31.2022.06.25.05.49.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 25 Jun 2022 05:49:35 -0700 (PDT)
Message-ID: <07dbf3e6-1b60-eab8-12bd-c6045dff0b5f@kernel.dk>
Date:   Sat, 25 Jun 2022 06:49:34 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH for-next 0/5] random 5.20 patches
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1656153285.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <cover.1656153285.git.asml.silence@gmail.com>
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

On 6/25/22 4:52 AM, Pavel Begunkov wrote:
> Just random patches here and there. The nicest one is 5/5, which removes
> ctx->refs pinning from io_uring_enter.

Nice!

-- 
Jens Axboe

