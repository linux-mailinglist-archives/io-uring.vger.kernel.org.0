Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BA771BE387
	for <lists+io-uring@lfdr.de>; Wed, 29 Apr 2020 18:14:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726456AbgD2QOl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 29 Apr 2020 12:14:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726423AbgD2QOl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 29 Apr 2020 12:14:41 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB3BAC03C1AD
        for <io-uring@vger.kernel.org>; Wed, 29 Apr 2020 09:14:39 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id a7so942665pju.2
        for <io-uring@vger.kernel.org>; Wed, 29 Apr 2020 09:14:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=7j8oJSJh74cOdpoQmTWMqrvUjoFeike3SkN0HS9R2XQ=;
        b=mTTxDunzXuO4VN9+EEk2z0Vf8m9s0JooqJeIIS4O/qC7pDYT49fPnEEgYAvsl1G59k
         FAZynv0UFiySltXMsezccoNq0C6FaaCqYI4btGxbJEbCJHYpzDt0M76ekpCVcC0IiDs9
         ntQK7/Z0y9iVN7XMlMiMv+7UPhKtQAgYtQkt3U6uZysK4qC7Ti6Hdr1NG/BeQmlsiRfx
         qnqAZwN7NhOHgskW+DuBLiTgo70iS5iHGM51/ZQ9jcYVHT0EghU/8AGpcFbh72YoBePk
         N5dWvcKD9cdQkGNepZfrT8MZ0cO5JYXs9SyfdHAHa2KofaQPoD2C3+mHJhS5/F1T8dXR
         eBwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7j8oJSJh74cOdpoQmTWMqrvUjoFeike3SkN0HS9R2XQ=;
        b=ik+G1oqDRKMQVGTFG4ZO9ZQjonpcG+L85SXkoRCx3NeGAmuua7dFSKuC9Kpkrh2LHy
         IXGe1QD9l+teYG805PD1rFKRqGaawzIvSKH9NF1Csiez/X85Um9WgkStSp9hjxJHCRk3
         HdYE9WgXhV6Fc3hykROlwelkYh0WEDbXIXbErlQP+wWQcN5EE1SxVCXFb2ZufnpFRFpl
         myVaaos2TUgCl47iVDtbhXZE4pJGLXq5kCNdrhsOpnsSUFuqoiigmo8r60S0RKEVkhIa
         hNKz32ACMMqkylv28fkRNjtQT4L7Ef0dHiaifFH0ypneku1Fct4WjUZn+8ERZhA7CCVd
         3wSw==
X-Gm-Message-State: AGi0PuaGzQLC1alC99pGUhVeFEj5kXYCtG0d7z0+Bc+GpR4B8LAiJsbN
        KrSpOjPPLOESxaHBZeG+YUgfyuOmYNx9+g==
X-Google-Smtp-Source: APiQypLsQt4z2ATx7ix62pnaPAuZ7j7Mr/vMOOTjM5V0Vrw2RHYDeV0Ic2hq3m1QwvY1djNj6oxNmA==
X-Received: by 2002:a17:902:b08e:: with SMTP id p14mr19072794plr.326.1588176878650;
        Wed, 29 Apr 2020 09:14:38 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id t20sm4825710pjo.13.2020.04.29.09.14.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Apr 2020 09:14:37 -0700 (PDT)
Subject: Re: Build 0.6 version fail on musl libc
From:   Jens Axboe <axboe@kernel.dk>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     =?UTF-8?Q?Milan_P=2e_Stani=c4=87?= <mps@arvanta.net>,
        io-uring@vger.kernel.org
References: <20200428192956.GA32615@arya.arvanta.net>
 <04edfda7-0443-62e1-81af-30aa820cf256@kernel.dk>
 <20200429152646.GA17156@infradead.org>
 <e640dbcc-b25d-d305-ac97-a4724bd958e2@kernel.dk>
Message-ID: <6528f839-274d-9d46-dea6-b20a90ac8cf8@kernel.dk>
Date:   Wed, 29 Apr 2020 10:14:36 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <e640dbcc-b25d-d305-ac97-a4724bd958e2@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/29/20 9:29 AM, Jens Axboe wrote:
> On 4/29/20 9:26 AM, Christoph Hellwig wrote:
>> On Wed, Apr 29, 2020 at 09:24:40AM -0600, Jens Axboe wrote:
>>>
>>> Not sure what the best fix is there, for 32-bit, your change will truncate
>>> the offset to 32-bit as off_t is only 4 bytes there. At least that's the
>>> case for me, maybe musl is different if it just has a nasty define for
>>> them.
>>>
>>> Maybe best to just make them uint64_t or something like that.
>>
>> The proper LFS type would be off64_t.
> 
> Is it available anywhere? Because I don't have it.

There seems to be better luck with __off64_t, but I don't even know
how widespread that is... Going to give it a go, we'll see.

-- 
Jens Axboe

