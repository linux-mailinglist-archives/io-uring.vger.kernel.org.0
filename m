Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0E6A4341EA
	for <lists+io-uring@lfdr.de>; Wed, 20 Oct 2021 01:14:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229668AbhJSXQU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 19 Oct 2021 19:16:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbhJSXQT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 19 Oct 2021 19:16:19 -0400
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D2E4C06161C
        for <io-uring@vger.kernel.org>; Tue, 19 Oct 2021 16:14:06 -0700 (PDT)
Received: by mail-io1-xd2e.google.com with SMTP id s17so22289157ioa.13
        for <io-uring@vger.kernel.org>; Tue, 19 Oct 2021 16:14:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=l589jzxw5CEZLp2EiFnT9CdUcOBqG74pCOyCzYrTEfA=;
        b=t8+tgaYFGt8n85jGIdo1gRoMGZ3F3FeQt5CAn10QJ3HE4Dd5kyn3wij2YsEna2txwY
         5oShGuG31IAVzOjpuRhNp55gK9u9HuI6LtRt3r5GofuBCl9UO2SPPA3hWO3FcR+tC2No
         YAUWTz9KwMRG+2ePXlIOwzDFqUwhzT6v3msiwOTXq+hdEUiIqrCn+VOFor4TyRhZi8J1
         XhG1Nd8VxaLF8pvfzomDEBi+Tcf6k8Qd4dF8p60hR0Pjhu2LSmvFX7jdPliufeBTlLpZ
         BTfEJhzCT+soAnmwynbZvdDrnTdkDDrQO7Jym4xnMt1unaDEIczdddZpbJIZgSlbITok
         qwBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=l589jzxw5CEZLp2EiFnT9CdUcOBqG74pCOyCzYrTEfA=;
        b=07jSV7u2JW96xjRnMBEtdjPD01e+LnasMzz9rCfevg7M7VCZlvVAsfnOqa4vOPV09E
         DMXGJYFZv9UiR+JaRK18RAUVt7JhDxAvIaFpAMSjCZuQG1f/6IzAyDKlPCmrcMnTZv71
         EBaEZ+7x0dgMZJp5D7QBgFhkQBs5Gl9Z2VxTJQXFwCTNjlpx3rYZDS2WnbHZI0wFYeGL
         Mv7o9tVOrKJBYc+B3MZpyC+wznRLybKAWG+uwANmxufytOuQOa2Nvv48QeHskvtoLTiq
         HxqLS1QmMuR8FkkyjN/+wm+pBVa8Ir9syijklyIdA73tq/ize0ubbzAjOdJeZ2sshmz1
         F5rg==
X-Gm-Message-State: AOAM530MdkarrgTCVFEmiEt2xCRrY3LHzY8NJuEvZWLm1S5zq1b7Crx2
        G0pO5Y+iEI/4EFlGWuWGjvGHu/tryNjNew==
X-Google-Smtp-Source: ABdhPJwqESqUGLGR3VBe0SdO1+cUgNAXKYeF5DBTANaexrjvM3UZlagyfq32xpUInHptNwNKQPyuxQ==
X-Received: by 2002:a05:6602:29c2:: with SMTP id z2mr21328255ioq.73.1634685245597;
        Tue, 19 Oct 2021 16:14:05 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id m10sm234536ilh.73.2021.10.19.16.14.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Oct 2021 16:14:04 -0700 (PDT)
Subject: Re: [PATCH 5.15] io_uring: apply max_workers limit to all future
 users
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <51d0bae97180e08ab722c0d5c93e7439cfb6f697.1634683237.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <752c43b7-18ff-648e-b694-df8e9ff123e4@kernel.dk>
Date:   Tue, 19 Oct 2021 17:14:03 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <51d0bae97180e08ab722c0d5c93e7439cfb6f697.1634683237.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/19/21 4:43 PM, Pavel Begunkov wrote:
> Currently, IORING_REGISTER_IOWQ_MAX_WORKERS applies only to the task
> that issued it, it's unexpected for users. If one task creates a ring,
> limits workers and then passes it to another task the limit won't be
> applied to the other task.
> 
> Another pitfall is that a task should either create a ring or submit at
> least one request for IORING_REGISTER_IOWQ_MAX_WORKERS to work at all,
> furher complicating the picture.
> 
> Change the API, save the limits and apply to all future users. Note, it
> should be done first before giving away the ring or submitting new
> requests otherwise the result is not guaranteed.

Thanks, let's do this for 5.15. I've added:

Fixes: 2e480058ddc2 ("io-wq: provide a way to limit max number of workers")

-- 
Jens Axboe

