Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58C493B9275
	for <lists+io-uring@lfdr.de>; Thu,  1 Jul 2021 15:46:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232081AbhGANs1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 1 Jul 2021 09:48:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbhGANs0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 1 Jul 2021 09:48:26 -0400
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D5C6C061762
        for <io-uring@vger.kernel.org>; Thu,  1 Jul 2021 06:45:56 -0700 (PDT)
Received: by mail-io1-xd35.google.com with SMTP id k11so7569545ioa.5
        for <io-uring@vger.kernel.org>; Thu, 01 Jul 2021 06:45:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=MtH4hu7tnpkqOr3qKNqErRqPafTtQWPcKZtFY6DKyNE=;
        b=1QXFrHOcCew75ZQAcnvAssCXu+0GPydUKRJhetuxIW2LkJaG7qiK5wBXQZytAr1sXX
         HYAeqlaeXvNZAvn1po+vNHYxtBfT4f3awqqv7Aemz0hLtr/oBuaJ0V0zZx0Gb4btPHZg
         96qgqXC2pBA+kMKIk/Vte6BInFlaua3JFYC58tJWFQj8HVfpo0wqptZ6ZTCFqIy90hvA
         efxndwJEeJrjZIT7CxG/axXdcuDOPIcRFJVRWoV5kdpmzgwUAdQqkprLiQWweQ5QeNg0
         uFstrHh7vl5yYVP6VFhWl8myoxF771FjJnPgweYDN2Zs7x0Dmbt+MBnJKuk+oMJbsiFg
         19oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MtH4hu7tnpkqOr3qKNqErRqPafTtQWPcKZtFY6DKyNE=;
        b=iNjuvWpD6Pgb5iuPfm6ogGlPKgGMQxm+qbLb0ca0/nuClJeLK+r7Lcv4LilYbuQ5hv
         E4c+PuDk20T9PUypYHKc8Ijgo21n48z1qcQKTlssttmrLSXmBpcQKwF+wkqPo0I03LDG
         RZbGTuNNP0gMfq9cpVXchyjiCwR/iHeHLRb2hKbFCr8QrlEDQckFtRm1au7VECHgx3H+
         2V/RPRBuDRH8F1C3Yqx7933GqBHLc2KiGxEM1RikNYDuJBKyH3iQZGzgdonw93PM9x0x
         CS98Yb8E+7mYaQxLEHzjt7LGRsaOZb8JenRJUtnx3l4enhx9tQLt+LRbe3qREZyVknxT
         4ndQ==
X-Gm-Message-State: AOAM531URNhfepX8vJiT1YDOWlIhLbUP8sKZG6OV5sN+XPZSC6wPHEOt
        Woye6echMxuy9GUrexfarHLyKcgqEMcjLw==
X-Google-Smtp-Source: ABdhPJytFKggqnQxpP1PYq041U/YvbLVVOLBv2fUZJifwlFN8G8n3qL8BhAGmAtHlfAVUwrxVmDdWg==
X-Received: by 2002:a02:ccab:: with SMTP id t11mr13871856jap.1.1625147155717;
        Thu, 01 Jul 2021 06:45:55 -0700 (PDT)
Received: from [192.168.1.134] ([198.8.77.61])
        by smtp.gmail.com with ESMTPSA id k21sm14497371ios.0.2021.07.01.06.45.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Jul 2021 06:45:55 -0700 (PDT)
Subject: Re: [PATCH 1/1] io_uring: fix exiting io_req_task_work_add leaks
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <060002f19f1fdbd130ba24aef818ea4d3080819b.1625142209.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <c5284516-def2-eb21-e95d-96aeda167c97@kernel.dk>
Date:   Thu, 1 Jul 2021 07:45:55 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <060002f19f1fdbd130ba24aef818ea4d3080819b.1625142209.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/1/21 6:26 AM, Pavel Begunkov wrote:
> If one entered io_req_task_work_add() not seeing PF_EXITING, it will set
> a ->task_state bit and try task_work_add(), which may fail by that
> moment. If that happens the function would try to cancel the request.
> 
> However, in a meanwhile there might come other io_req_task_work_add()
> callers, which will see the bit set and leave their requests in the
> list, which will never be executed.
> 
> Don't propagate an error, but clear the bit first and then fallback
> all requests that we can splice from the list. The callback functions
> have to be able to deal with PF_EXITING, so poll and apoll was modified
> via changing io_poll_rewait().
> 
> Reported-by: Jens Axboe <axboe@kernel.dk>
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
> 
> Jens, can you try if it helps with the leak you meantioned? I can't
> see it. As with previous, would need to remove the PF_EXITING check,
> and should be in theory safe to do.

Probably misunderstanding you here, but you already killed the one that
patch 3 remove. In any case, I tested this on top of 1+2, and I don't
see any leaks at that point.


-- 
Jens Axboe

