Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F2351534EF
	for <lists+io-uring@lfdr.de>; Wed,  5 Feb 2020 17:05:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727511AbgBEQFM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 5 Feb 2020 11:05:12 -0500
Received: from mail-il1-f195.google.com ([209.85.166.195]:40281 "EHLO
        mail-il1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726973AbgBEQFM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 5 Feb 2020 11:05:12 -0500
Received: by mail-il1-f195.google.com with SMTP id i7so2290900ilr.7
        for <io-uring@vger.kernel.org>; Wed, 05 Feb 2020 08:05:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=Ro/JXxhb6fw5qhCk5bQIEJar86Lbd1JTMDnrvXuIV4U=;
        b=yUPqJ3jzwFieQL/5BZRPu4H0WRWwlT5nKvTswUken+f+XokvK/Y2BDmFYVcwoM55fH
         E6IXP0IjFXq/HiXab6CQt9UgY4XcUaBrfw+NrIVZu9+hMcHAP/um/RXzdbI1Vcaw5rlG
         swFws0EZyn4OyMjkmnDrDszvSgkehnMyE2CR2KMrGtUNzBJjj05MfrbNxa2AFB4r90mT
         gcwu3CukLDOSE6cWiv8HO9Y4/n4QWbsbMIJPBdlguDqnts1acIYV2mTyWPjh9PsC2odi
         yJINYbfarCl9O2HZbmxMvWozwpfupGIr1O4B9IEGhYhEga9ln0pQd02Gz11l+ZFF28Lt
         dqqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Ro/JXxhb6fw5qhCk5bQIEJar86Lbd1JTMDnrvXuIV4U=;
        b=Ht9/02MHI4fmVxHjdWY5SLDO6vP/g7+8kmEGHQI8oT40Mz77SENzChUIf6vzXsUJvS
         f4zQ0jqD6G82yrEGRZbh+Ob5yyC+JbG0B8Kk9GaHftmD1htdIPbI6qobC9DL/SrTAlYu
         cxbtO9g9ogM3rI/ShL/Z1OHArVBch524MpB3AB0GxvW+G+j3JNCSoa8xphGd3m1AGNmM
         k2FDcEl2TtELGVjIHBFJPjHZpv3SrZ8Fbjwgk9hgkqWu5SIyAH3NXth1EomIaGDEDS9G
         4H3OLLBIfqVG+DN7gAkT7HxEDje1aMOmeQWKl59t0SylHQTFtty7udhU5s6P0/6CZxQH
         5dwQ==
X-Gm-Message-State: APjAAAVGAw5RCb53H96PPVnPva2FNm3haSuMuavNScAT7fqvhWILhKAt
        SRdzHxab92x1dzH/EOC0ysU2FA==
X-Google-Smtp-Source: APXvYqylwHIZDtu9aIEeijvNn8AMoRetp0DgOjDxJslUe4m10dMnz5SGv2BsR+ZugAOm1RQscfIiTQ==
X-Received: by 2002:a92:7a05:: with SMTP id v5mr32067440ilc.122.1580918709973;
        Wed, 05 Feb 2020 08:05:09 -0800 (PST)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id t15sm10386974ili.50.2020.02.05.08.05.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Feb 2020 08:05:09 -0800 (PST)
Subject: Re: [PATCH] io_uring: fix mm use with IORING_OP_{READ,WRITE}
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <951bb84c8337aaac7654261a21b03506b2b8a001.1580914723.git.asml.silence@gmail.com>
 <df11c48e-f456-3b64-88d1-6012b1ac2bc8@kernel.dk>
 <d9a15d32-a20b-a20f-9ea4-3ac355c15bb2@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <c6cc1e97-f306-e3f0-3f7b-9463fdbbc5a5@kernel.dk>
Date:   Wed, 5 Feb 2020 09:05:08 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <d9a15d32-a20b-a20f-9ea4-3ac355c15bb2@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/5/20 9:02 AM, Pavel Begunkov wrote:
> On 05/02/2020 18:54, Jens Axboe wrote:
>> On 2/5/20 8:46 AM, Pavel Begunkov wrote:
>>> IORING_OP_{READ,WRITE} need mm to access user buffers, hence
>>> req->has_user check should go for them as well. Move the corresponding
>>> imports past the check.
>>
>> I'd need to double check, but I think the has_user check should just go.
>> The import checks for access anyway, so we'll -EFAULT there if we
>> somehow messed up and didn't acquire the right mm.
>>
> It'd be even better. I have plans to remove it, but I was thinking from a
> different angle.

Let me just confirm it in practice, but it should be fine. Then we can just
kill it.

-- 
Jens Axboe

