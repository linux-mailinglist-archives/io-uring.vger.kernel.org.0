Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E040D434A9F
	for <lists+io-uring@lfdr.de>; Wed, 20 Oct 2021 13:58:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229702AbhJTMA5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 20 Oct 2021 08:00:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbhJTMA5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 20 Oct 2021 08:00:57 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30B4AC06161C
        for <io-uring@vger.kernel.org>; Wed, 20 Oct 2021 04:58:43 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id g2so18420485wme.4
        for <io-uring@vger.kernel.org>; Wed, 20 Oct 2021 04:58:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=ohh53GWuiLTufNK0Dq6WD6xqEmxetmL8igHhwGtU7Zo=;
        b=Nr5pMS1J3KjAuBn7UN1SvGdv5fHAHBMCBS98IOqjinpUGVhzPEFkGmeNyG0DKZj3uy
         CD1rGsHd2UqT/Zx0Nja0q97a2EfVtvxtp3EC9ZUyXgXZ237sLQmA2EcmUez+AoBf/gYr
         m33sMkBJVu9Skhh8VLxD7NPC0NsX3mFJ5dCc3MFnMEorN60tSU81LxE9oadoIn1JLRT3
         CPTIWSCcxI8eMVrCm6PE/kGHwtj0AVlOUDgAoe3RcpKiPA8GTCQf+vbuJRY3DO502IW0
         PIimrLsVTmWPmDEv4y0URAJy7FF8mxm1YaRhwxn21GkrBjfk5B1eLEsLS0Fiv0r3Bb1/
         DsYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ohh53GWuiLTufNK0Dq6WD6xqEmxetmL8igHhwGtU7Zo=;
        b=apJlqpey3j+jxB/Wes+1SxbjXQ4d4LPK9dXl4OguScx/15Ncbny2yl7kcMNtAxdR1J
         h4bIXJPAiT058W5n6vZ9YFq7YYf8cXkTMspFJOu9VkZUNAwqGuHgy5rTmWKkyaKo6RQN
         bCptvwUCl44UgX3ClbX/zWij8nGDTkTB0OtE2z92qzl8yzVOcVJZwLEQMReC5B7ca1YT
         yCsPhJvM63m4wy/FX8e6mDXB6nF3uvlPzlCF8oChLya1IwjiE+Vs8Ov/GeIR9X/+xGeO
         EkWibZXyah6p7s89I8+Do5YCpVIMO/DzBzDZvpEG4P8AJpmjE7EMyIC96rGgumfU82mN
         i0kA==
X-Gm-Message-State: AOAM533Tr2EK7YkfEdhZo/XEqhsuTL+4NjbdcLIiY/Lb+2l9dHALuBRS
        tK1PvMzEQLSq0HoNV1Cnv5fHp5RUtbg=
X-Google-Smtp-Source: ABdhPJwszshVQLtqO1B2Mgveeys0E63BonlPCmh4jHdBbEJ9wOmlS2SrbCM98m8rg8q7a1u/QYpXDA==
X-Received: by 2002:a05:600c:5128:: with SMTP id o40mr12921922wms.81.1634731121588;
        Wed, 20 Oct 2021 04:58:41 -0700 (PDT)
Received: from [192.168.43.77] (82-132-229-137.dab.02.net. [82.132.229.137])
        by smtp.gmail.com with ESMTPSA id z1sm1902753wre.21.2021.10.20.04.58.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Oct 2021 04:58:41 -0700 (PDT)
Message-ID: <1e3b5546-5844-bbed-e18a-99460a8ae3e4@gmail.com>
Date:   Wed, 20 Oct 2021 12:58:44 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: Polling on an io_uring file descriptor
Content-Language: en-US
To:     Drew DeVault <sir@cmpwn.com>, io-uring@vger.kernel.org
References: <CF44HAZOCG3O.1IGR35UF76JWC@taiga>
 <70423334-a653-51e3-461c-7d09e7091714@gmail.com>
 <CF47IHLKHBS7.27LZVJ5PQL4YU@taiga>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <CF47IHLKHBS7.27LZVJ5PQL4YU@taiga>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/20/21 12:44, Drew DeVault wrote:
> On Wed Oct 20, 2021 at 12:15 PM CEST, Pavel Begunkov wrote:
>> Not a canonical way, but both should work (POLLIN for CQEs).
>> Do you have a simple test case for us to reproduce?
> 
> Hm, no, I cannot. I must have faced another bug, I was not able to
> produce a minimal test case and my attempt to reproduce my earlier bug
> in a larger test case was not succesful.

Sounds like polling is ok, let us know if there is any problem

> 
> One issue which remains is that attempting to use REGISTER_FILES on
> io_uring A with io_uring B's file descriptor returns EBADF. I saw a
> comment in the kernel source explaining this, but it's a bit contrived
> and the error case is not documented.

Surely should be updated if not mentioned

-- 
Pavel Begunkov
