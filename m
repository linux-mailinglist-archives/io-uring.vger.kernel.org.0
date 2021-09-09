Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAD53405A4C
	for <lists+io-uring@lfdr.de>; Thu,  9 Sep 2021 17:41:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231342AbhIIPmq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 9 Sep 2021 11:42:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231274AbhIIPmq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 9 Sep 2021 11:42:46 -0400
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0B4EC061574
        for <io-uring@vger.kernel.org>; Thu,  9 Sep 2021 08:41:36 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id n24so2849240ion.10
        for <io-uring@vger.kernel.org>; Thu, 09 Sep 2021 08:41:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=t3dLIjSDSNPBxGKTFd2AaK579dkNRpPO9cjwemBKf6E=;
        b=VGzCqZ7AvLtjzIbvvimH2VASco70G0wtzuVdoOXFXF6JZvGbDWgfrYhxKz0tXFfr2O
         xk2e4yNJASC/1C+FdVxU/l54qIqG5rl950nRxDyfjtLjgYbZMWGsCGF6qLXJMl7ZkgTm
         YzbHEpyOx1ceTuLttczaloOmIB+J+ag9e1IjxFBaL5Ka8Nh+TU/ox8Fz3fWFGKGzjTwS
         ikfhZHjUUb5PSNT+wVrL3OH0fka36EGbBUEDNseW2FBY1OTi/FQ84chu9hRR+6qILQnQ
         Oun+rurot9hFSnDoDJXR636jKUC0Bw6FFhsdd1pDA1iNcNS12g4LTehFOIkJK/Q6KZYf
         22Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=t3dLIjSDSNPBxGKTFd2AaK579dkNRpPO9cjwemBKf6E=;
        b=wpvyQF+uAPXJ13WmTobLKoa+UTVfRdDYApmNnikmsYaDsn7JKT43tNWnILB0h+tQ56
         u5GYy2E0Lx4HPMxBdmuClt7Oj6kCVxZCQdjO/SBYqZSXicm7noEyJpqFfc+e7LIM53/+
         8iLkg0zDE11HjJL6QfuVzTF3BhnWjEWvAmPt/gf1GgThGjFXmOD3ebQr3yx2cq7yZm0p
         QZUjLzijHCSeErkcFbgF70liN3Shd0mBWX7ZzXshaAczmAxPHUkGVktWMC3n+RBV1loG
         MIXyZTSlglEkI9mMm3sv6TA8pzkYHV3F+R9t0daNEkQBDpBboy3G076VAxjqmi83U1MX
         hqCQ==
X-Gm-Message-State: AOAM530xDflcgqdXl7S8owESMaZ4O0U2itqt6/uWpQ4suoTgyTmScr6+
        +qHPtOryQ7EB471Wf4pgTf54W9dtUkqctw==
X-Google-Smtp-Source: ABdhPJzcnosmtU8J+qnAxuqr53fi07AdncwXezopHX4eyI9+A13eZJRd2LNPWvlzUHZ1cMrzSc+cPw==
X-Received: by 2002:a5e:990e:: with SMTP id t14mr3280426ioj.75.1631202095922;
        Thu, 09 Sep 2021 08:41:35 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id d12sm1016947iow.16.2021.09.09.08.41.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Sep 2021 08:41:35 -0700 (PDT)
Subject: Re: [PATCH] io_uring: fail links of cancelled timeouts
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <fff625b44eeced3a5cae79f60e6acf3fbdf8f990.1631192135.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <674c0c92-cd4b-6bfd-09a0-9785294e8aac@kernel.dk>
Date:   Thu, 9 Sep 2021 09:41:35 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <fff625b44eeced3a5cae79f60e6acf3fbdf8f990.1631192135.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/9/21 6:56 AM, Pavel Begunkov wrote:
> When we cancel a timeout we should mark it with REQ_F_FAIL, so
> linked requests are cancelled as well, but not queued for further
> execution.

Applied, thanks.

-- 
Jens Axboe

