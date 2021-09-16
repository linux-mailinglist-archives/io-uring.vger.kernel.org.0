Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBCCD40D174
	for <lists+io-uring@lfdr.de>; Thu, 16 Sep 2021 03:54:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233291AbhIPBzv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Sep 2021 21:55:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229816AbhIPBzv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Sep 2021 21:55:51 -0400
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC062C061574
        for <io-uring@vger.kernel.org>; Wed, 15 Sep 2021 18:54:31 -0700 (PDT)
Received: by mail-io1-xd2d.google.com with SMTP id z1so5989284ioh.7
        for <io-uring@vger.kernel.org>; Wed, 15 Sep 2021 18:54:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=Spse/bHxUW8qExECpiVTJ/boNy9sMY+f+rtCz/a8Aho=;
        b=gTm/ml9fOS++19oN/eaL97wTdBR9g3WCMjwRXJPjf2IOUyrB3imJjeDQQHld6jXiUa
         nZZczlPYuNGDJS7ICmlSgQUOnxaJTZg4H57oCd56Oey2xh+fIpPlv+BCm3rn2mOu6/dP
         QO9WvmDa62KYKfyy2iMJPMdK/b3LzOolOYX0F+i0eaosOUJ4Wct8+fEItb3jh33R92hZ
         +zlar84bJH9cU0ETxY2ZrDr8q4oPZOnMEpDQgXsRe4OB245CdaRjgpNtnFwS8hKVtSmD
         6MSZX9eJ5zHAB+o2gJs4tf5fRAKvmnyVkQD7Q+DkvUn0hEbs+nuPznKKDscM6YEGceem
         z9SA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Spse/bHxUW8qExECpiVTJ/boNy9sMY+f+rtCz/a8Aho=;
        b=ADjAqRU1wAWrj0d0PNuU3oXvRvF8We2fye+CNLWZ6l83D64FxDt2zELoJtMEhUqx0T
         Yh/YmgWeXXks8VjJ4E0B68wPMqogec6AkxvY8mDDBECfNSff0bZzmQZnh331Bs3HQOrR
         TfQROfjZJltgT0EE+Q3TJ/IGa2jHOBw1IJS2oWnfH1nXOqWOvwI0pu5iMaLBJHgCbVYk
         5MCWbo4Pl6dVobneDz4+J9ItQtZTjjsgF9NoqCtqgGdXEgjK3IqGG5qKyu9lK9mKKoZU
         L/AHboN0os8qu8tCDa3PayjMy125oiKXZ1u3b7JRiQzIr4eP2dvmC2IC8WAyAc3frWiB
         G8Sw==
X-Gm-Message-State: AOAM532A3wbFru2eTfuMjRR0Qw3jKjaxBJcCwehoe7z+uHGovVO1FBhD
        dR/NABvRbvyxgrOji9Revfss9Z6apT/IFw==
X-Google-Smtp-Source: ABdhPJwRVWWw89OORTBGsJzKFKHlAk/pJ2k1hh/yQL2+JHcTX9pE3XL+oa84uZ8tTkDvFS0xsvqHAA==
X-Received: by 2002:a5e:c807:: with SMTP id y7mr2388571iol.87.1631757271106;
        Wed, 15 Sep 2021 18:54:31 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id p11sm918365ilh.38.2021.09.15.18.54.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Sep 2021 18:54:30 -0700 (PDT)
Subject: Re: [PATCH v2] io_uring: move iopoll reissue into regular IO path
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <f80dfee2d5fa7678f0052a8ab3cfca9496a112ca.1631699928.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <76f6779a-85a2-7877-8b03-44fd46684d7a@kernel.dk>
Date:   Wed, 15 Sep 2021 19:54:30 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <f80dfee2d5fa7678f0052a8ab3cfca9496a112ca.1631699928.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/15/21 4:00 AM, Pavel Begunkov wrote:
> 230d50d448acb ("io_uring: move reissue into regular IO path")
> made non-IOPOLL I/O to not retry from ki_complete handler. Follow it
> steps and do the same for IOPOLL. Same problems, same implementation,
> same -EAGAIN assumptions.

Applied, thanks.

-- 
Jens Axboe

