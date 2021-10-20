Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A9F5434958
	for <lists+io-uring@lfdr.de>; Wed, 20 Oct 2021 12:48:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229952AbhJTKur (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 20 Oct 2021 06:50:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229921AbhJTKuq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 20 Oct 2021 06:50:46 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF8C2C06161C
        for <io-uring@vger.kernel.org>; Wed, 20 Oct 2021 03:48:32 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id 186-20020a1c01c3000000b0030d8315b593so486622wmb.5
        for <io-uring@vger.kernel.org>; Wed, 20 Oct 2021 03:48:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=v+sPSzq5zVG7qlS3kFSINGyuCQDlQwVj5gBxiNCHUq4=;
        b=MtMZPWQx/l2X9VtcUYvbCsVE6cvcSAVJnZxZqm+UkdX3GeDIoVWmFnj62hGU65gpEb
         VmVMEkKMD4tucnEpYDAJaHgc8Ka9G4bdNQPwxv9Sdpw4mJQ6FdZqZEFE1wX7D8bVognW
         4k1ND2wFXZe+y34M6Djen7IgTggMeP5mv6vQacM9g9aDLFEJfq/eFjxFWW1mnM40CWMt
         HnR/WNqobpOEFxh9RtC1ZjaNiuWWAhFGit74brTUXCXV88Lb/yVaT53p3s0JroDuFaP9
         +TGUUpiIb9/qiAoG7md9lsajNqrn5jgvAwryB/5TcPSL+iSstW4WqpIOO0Br4bCK614Z
         ps4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=v+sPSzq5zVG7qlS3kFSINGyuCQDlQwVj5gBxiNCHUq4=;
        b=R1SMkfXOMd0ED9oBvhxFrodcKiiR1EoSrSd+dZAy+KxZF3weUslOTkbXIuPNXaa2Nb
         A9P7LJWOocehPTf6z+lJYDvuwzY3qxmIrU0473o7EC8WkVJRbqiRnUhiq6UWPjbYec5E
         8yQ6h8rJvpjP2VJNVGUnZ7Cbkp5vq3tSAtwaCjA1MyHfO33Wfby0B7hnzKaiWZUaInuM
         7vWX9YIEZqidogXeT9pkzDvjSfPvtSkfpF4OIRuT2Gp1nuT2XJFcsOd5ZX1q3L+WFgYJ
         PJ0RltLztDGeOHdcZtaDO5GGdBIGKKDPdTqIg/vHmwP5dVNydApxN6HPSlTkM4py5oUj
         SYuw==
X-Gm-Message-State: AOAM530ffPocYIple7gxsOHnZIVtZsQIhVDChhOQFQLzD1iGoyG7LG+I
        wzSbD7XosoHcBk1FfLo2OLU=
X-Google-Smtp-Source: ABdhPJzSzx7SU6eOA3OjwkrF/Jwmr1ChmhE4/RNW8sLXyy3r8XJn23jlMqJT73uoSCaELb2ylu/KZQ==
X-Received: by 2002:a05:600c:378f:: with SMTP id o15mr12747474wmr.63.1634726911305;
        Wed, 20 Oct 2021 03:48:31 -0700 (PDT)
Received: from [192.168.8.198] ([185.69.145.194])
        by smtp.gmail.com with ESMTPSA id d9sm1652409wrm.96.2021.10.20.03.48.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Oct 2021 03:48:31 -0700 (PDT)
Message-ID: <67458cdf-9645-cd3b-bf83-ec5329bc160d@gmail.com>
Date:   Wed, 20 Oct 2021 11:48:34 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH 5.15] io_uring: apply max_workers limit to all future
 users
Content-Language: en-US
To:     Hao Xu <haoxu@linux.alibaba.com>, io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
References: <51d0bae97180e08ab722c0d5c93e7439cfb6f697.1634683237.git.asml.silence@gmail.com>
 <67688dc3-e28a-5457-0984-90df0f2bcfc5@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <67688dc3-e28a-5457-0984-90df0f2bcfc5@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/20/21 09:52, Hao Xu wrote:
> 在 2021/10/20 上午6:43, Pavel Begunkov 写道:
> Hi Pavel,
> The ctx->iowq_limits_set limits the future ctx users, but not the past
> ones, how about update the numbers for all the current ctx users here?
> I know the number of workers that a current user uses may already
> exceeds the newest limitation, but at least this will make it not to
> grow any more, and may decrement it to the limitation some time later.

Indeed, that was the idea! Though it's a bit trickier, would need
ctx->tctx_list traversal, and before putting it in I wanted to take
a look at another problem related to ->tctx_list. I hope to get that
done asap for 5.15.

-- 
Pavel Begunkov
