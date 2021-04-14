Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F057535F8E4
	for <lists+io-uring@lfdr.de>; Wed, 14 Apr 2021 18:25:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352694AbhDNQVK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 14 Apr 2021 12:21:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233512AbhDNQVJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 14 Apr 2021 12:21:09 -0400
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 851A6C061574
        for <io-uring@vger.kernel.org>; Wed, 14 Apr 2021 09:20:48 -0700 (PDT)
Received: by mail-io1-xd2d.google.com with SMTP id j26so21206652iog.13
        for <io-uring@vger.kernel.org>; Wed, 14 Apr 2021 09:20:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=An7tjwghUcDSrRWHv4fxmJz+XK/PDM8R4CE19X4GFR4=;
        b=sixQogoMvi1Eh983Pll8WQ03LgDKNqFv6osaJU1DZr2+tpV3C4XXR97y7PobtqarWC
         tSb8PPX3pPn7McR0f9+bxY1Mcvb/eH9ePSmZsvVS+6KckvIIg+l/CudtBfEOSKrD6ckr
         fa/Q2RZcC+OCil0gSSFlS8dDwp0NibjpVdQLjb9Zx0oJtxzCqFqxDW17JHFfECGWIUsz
         u/jCtFIQfyiZUp3iGvzPLX6RgPEnht3oiqkhIvUaDjT71l590QeWcgV6fDOMPNULVG2q
         OI26hYvU9i3wVuaIWH+EeXSfgnG4dZ1AVeID+s/YBmKUMbr7jKCK65bn9uyQQbjYDyiP
         BL6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=An7tjwghUcDSrRWHv4fxmJz+XK/PDM8R4CE19X4GFR4=;
        b=brgmjb7LB5nIob+2c5Y9AZe3fTessH9BcCXnvMM1JSab7HOdaiA9w8OTd40AlilJJs
         SAoEEVcI01SjRG14rR00KhuXX1JiSHUyUlWy+FGoISpjHMBWbHp0jjSnqonOnAMI8l2s
         DvU+h2W99VnUqzyJuxUBbk/QNVlVNGJN6tyxH3fsv4gMtSh0w+9ppgxAI1dPvNJyrFeZ
         Gb4INktjSzkg+nwD1RBnNhIw16jcRJ6ZCIH3rGY+slCa5jkOLK32DpSfX25aJZX08aLk
         KSFjajUoI+W5U2CNanq+gLYpbEyoUB2ryCGkzpKpfjCxtJ+Yk6KP/RmXcDxgYXkZGAn/
         jyOw==
X-Gm-Message-State: AOAM533sW11P3ro5fKX7obxWEXoOIsG1D2ZHYEnLoEt4PU6FYI7lMQnm
        BMeuLCpA/2YUHCkw7EedtZ05apI/hfP64A==
X-Google-Smtp-Source: ABdhPJwUcPXgcxWHM3qZ2STR59KzxUNKSsDVAQmBwJOLByOZwS5IxXf2XkYHaX7U9ru1FhuABGsA6Q==
X-Received: by 2002:a02:850a:: with SMTP id g10mr39494916jai.140.1618417247395;
        Wed, 14 Apr 2021 09:20:47 -0700 (PDT)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id d18sm8579994ioo.50.2021.04.14.09.20.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Apr 2021 09:20:47 -0700 (PDT)
Subject: Re: [PATCH v2 5.13 0/5] poll update into poll remove
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1618403742.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <66cf75ca-05d9-2c92-1038-253377ba0fd5@kernel.dk>
Date:   Wed, 14 Apr 2021 10:20:46 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <cover.1618403742.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/14/21 6:38 AM, Pavel Begunkov wrote:
> 1-2 are are small improvements
> 
> The rest moves all poll update into IORING_OP_POLL_REMOVE,
> see 5/5 for justification.
> 
> v2: fix io_poll_remove_one() on the remove request, not the one
> we cancel.

I like moving update into remove, imho it makes a lot more sense. Will
you be sending a test case patch for it too?

-- 
Jens Axboe

