Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08DAD2E1C5A
	for <lists+io-uring@lfdr.de>; Wed, 23 Dec 2020 13:45:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728618AbgLWMpp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 23 Dec 2020 07:45:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728614AbgLWMpo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 23 Dec 2020 07:45:44 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 269BDC0613D3;
        Wed, 23 Dec 2020 04:45:04 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id i9so18521094wrc.4;
        Wed, 23 Dec 2020 04:45:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Jaj4wwk2cpL92Bf2RNDnuKHKMQpm0P2e//A2PU6Aln4=;
        b=DZGO6f8CnWZp0wO2SxfQADNUfYOnsJuBODJIi91TPBipb/+B6TUdzRr07a93Cc1Wnw
         JrB3AXy6z+tOT3B5MyGuKNVbBJiZCNLr8V5sK/HjKoOaJlVmZ772fDMEtqrypfX1uOi1
         OvryNewuk3sImUSI2lsYWKklb/F/Lfqse8crSQz0ePd9VcsevVXHqrvMryl13LXapCkx
         vkxvxe0r8f2iQgaPcx3TNGAlSGQFTPHlXBh8bPPqQ7OLZ9SHy9ICgE6zEMY6EohGayip
         cPUR5v0nl+hZYzyo3Kr70RAi/qcXlAIVYyxpVraEmN8AkHVcO4V5dLQyK+AMCr9QSATB
         mTJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=Jaj4wwk2cpL92Bf2RNDnuKHKMQpm0P2e//A2PU6Aln4=;
        b=B4K9AVHiN2xyaFoy7bfPViphoRtK2Y6CQTbq2ipwl3jUGNmZOUAlgqnKZyg+Q3a1SN
         yCAMHU/oSsVN8Pw+L8hf3MHFs3cc/d9V2fn/XKzgjxfS0Q/FzxAgO0YIqv7FiKxkUZz0
         ScY6DQmxMaI8rbwwCSUu1SIzoDYUfo6Iu5wKz6wrPoQPvkTDXCx/aReUvky7Qf94AJFY
         cUjlP5OUuFojoEgSRSpXJPk13f3Tus+BW/TSDB2VaBCFskjhLqv8sjOXuLns6lBuHRBd
         lQlY5yPAIiDPE12vwPF8vI0NkqIOHeFO7Lmz7Rt4TgPFeLgDHlETgkPJoE+07da4HW29
         aOUg==
X-Gm-Message-State: AOAM532E6wxjySEg+hZpcTdrYhrRYCmKNIn1Rm2enqCNNFI/CcZepO/l
        GJ5k4rJ5yTp3oNTqaTLWbVWuAr/xC9/YkQ==
X-Google-Smtp-Source: ABdhPJz+dUWP/lnmFE+K6X7F/q71LIP3Z0GshDGOiHrUrjkBJs8CXJvqChBijrMxD9YEaSuNTBsVeQ==
X-Received: by 2002:a5d:6503:: with SMTP id x3mr29155876wru.151.1608727502693;
        Wed, 23 Dec 2020 04:45:02 -0800 (PST)
Received: from [192.168.8.148] ([85.255.233.85])
        by smtp.gmail.com with ESMTPSA id 94sm38080771wrq.22.2020.12.23.04.45.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Dec 2020 04:45:02 -0800 (PST)
To:     Stefano Garzarella <sgarzare@redhat.com>,
        Yejune Deng <yejune.deng@gmail.com>
Cc:     viro@zeniv.linux.org.uk, axboe@kernel.dk,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1608694025-121050-1-git-send-email-yejune.deng@gmail.com>
 <20201223103623.mxjsmitdmqsx6ftd@steredhat>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH] io_uring: remove io_remove_personalities()
Message-ID: <3c013151-37de-1ef0-e989-9f871665d650@gmail.com>
Date:   Wed, 23 Dec 2020 12:41:39 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20201223103623.mxjsmitdmqsx6ftd@steredhat>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 23/12/2020 10:36, Stefano Garzarella wrote:
> On Wed, Dec 23, 2020 at 11:27:05AM +0800, Yejune Deng wrote:
>> The function io_remove_personalities() is very similar to
>> io_unregister_personality(),but the latter has a more reasonable
>> return value.
>>
>> Signed-off-by: Yejune Deng <yejune.deng@gmail.com>
>> ---
>> fs/io_uring.c | 25 ++++++-------------------
>> 1 file changed, 6 insertions(+), 19 deletions(-)
> 
> The patch LGTM, maybe as an alternative you can leave io_remove_personality() with the interface needed by idr_for_each() and implement io_unregister_personality() calling io_remove_personality() with the right parameters.

Right, don't replace sane types with void * just because.
Leave well-typed io_unregister_personality() and call it from
io_remove_personalities().


Also
 * idr_for_each() - Iterate through all stored pointers.
 ...
 * If @fn returns anything other than %0, the iteration stops and that
 * value is returned from this function.

For io_remove_personality() iod==NULL should not happen because
it's under for_each and synchronised, but leave the return value be 

io_remove_personality(void *, ...)
{
	struct io_ring_ctx *ctx = data;

	io_unregister_personality(ctx, id);
	return 0;
}

-- 
Pavel Begunkov
