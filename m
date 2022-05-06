Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6143F51CEF3
	for <lists+io-uring@lfdr.de>; Fri,  6 May 2022 04:17:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1388300AbiEFCUg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 5 May 2022 22:20:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1388297AbiEFCUf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 5 May 2022 22:20:35 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12B5760045
        for <io-uring@vger.kernel.org>; Thu,  5 May 2022 19:16:54 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id p6so5548964plr.12
        for <io-uring@vger.kernel.org>; Thu, 05 May 2022 19:16:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=SobKQmbF1fKCHMmPWDVkqQstRTu1KoW1l73xQAN+d9Y=;
        b=SjeuZvQM+koWskDGbzXd+jrXvXy0jpIOlPb97l9XjeAkAFMEtUOic95cMKkp9wsqDL
         IbSzfdLMoQ37iDRd0NINzkquwRClLL9Y8ffnl8N2BvuqB3/b8avdqGxR6tTGJ0BT+p2X
         jZmJ5eZGF1LtWXvXJMrloG3WS3AVUhGXi/yd1kd8KrZ93mDRtL9+U7hEqYocYnYZwSmI
         I8gDkvO6lRXAHRU6Umufvq0UIhbrmqi3XRkqRe1yvC589+6NxzSs6tNPHoJuKPEVXTxG
         qceY8a2QqsOW4ywTpVTcJkmZrphT+IuMcPfm1bqoqKF13pL75VQQiclvYjRZPxHZl4Bn
         nE4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=SobKQmbF1fKCHMmPWDVkqQstRTu1KoW1l73xQAN+d9Y=;
        b=wvhC5CVHzBrvp4OlSMd5DKbsQta05ERHhHG14togXZ2gTfb/16J50DmikAa1+PHmDr
         kBVxZsuKRL7ltWKp7VcxVsJ1ytvXT9UG0ORDrJXfzE3dXiLyN5FrhD+9/ce85cj7uQZv
         WGiQHDMAfQC1007tL93Lqzobbn/ekQm2SkeTwwam5ZfAHMvefIUQNvy5YWT2o0IQXHdf
         21M2W7eZ2o0lI7XAqYCDCl9mLxRuiQoXJfkmJj4DHa66FXnTQjij22uEfBIKmcdKGdjg
         tfTgG/tZX1n1WN8UPfoNMmIH450mOfpHzcgfGi1pHuOuMRtLaTJzoc6zLgiTj7ic04hU
         n89Q==
X-Gm-Message-State: AOAM533iaqIWU/YCKIxOQoBbFFB9X8s5o+X0otPV5J+sIAgAgPeqbRFi
        bmriCVmBuyd+iE8Mut/Ixrfhul9KlY2fQQ==
X-Google-Smtp-Source: ABdhPJyvxeWW6xAMVmfxkAArQMbJYLnVVM4g+5G/bs+5RVlqE8t9aXu0LinrUmSITFrmDwVHNxizFQ==
X-Received: by 2002:a17:902:c24c:b0:15c:fa6f:263c with SMTP id 12-20020a170902c24c00b0015cfa6f263cmr1234139plg.66.1651803413500;
        Thu, 05 May 2022 19:16:53 -0700 (PDT)
Received: from [192.168.4.166] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id mu6-20020a17090b388600b001d960eaed66sm2227957pjb.42.2022.05.05.19.16.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 May 2022 19:16:52 -0700 (PDT)
Message-ID: <7d54523e-372b-759b-1ebb-e0dbc181f18d@kernel.dk>
Date:   Thu, 5 May 2022 20:16:51 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: linux-stable-5.10-y CVE-2022-1508 of io_uring module
Content-Language: en-US
To:     Guo Xuenan <guoxuenan@huawei.com>, asml.silence@gmail.com
Cc:     lee.jones@linaro.org, linux-kernel@vger.kernel.org,
        io-uring@vger.kernel.org, yi.zhang@huawei.com, houtao1@huawei.com
References: <dd122760-5f87-10b1-e50d-388c2631c01a@kernel.dk>
 <20220505141159.3182874-1-guoxuenan@huawei.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220505141159.3182874-1-guoxuenan@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/5/22 8:11 AM, Guo Xuenan wrote:
> Hi, Pavel & Jens
> 
> CVE-2022-1508[1] contains an patch[2] of io_uring. As Jones reported,
> it is not enough only apply [2] to stable-5.10. 
> Io_uring is very valuable and active module of linux kernel.
> I've tried to apply these two patches[3] [4] to my local 5.10 code, I
> found my understanding of io_uring is not enough to resolve all conflicts.
> 
> Since 5.10 is an important stable branch of linux, we would appreciate
> your help in solving this problem.

Yes, this really needs to get buttoned up for 5.10. I seem to recall
there was a reproducer for this that was somewhat saner than the
syzbot one (which doesn't do anything for me). Pavel, do you have one?

-- 
Jens Axboe

