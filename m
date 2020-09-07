Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0248260527
	for <lists+io-uring@lfdr.de>; Mon,  7 Sep 2020 21:33:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728885AbgIGTde (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 7 Sep 2020 15:33:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728879AbgIGTde (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 7 Sep 2020 15:33:34 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4534C061573
        for <io-uring@vger.kernel.org>; Mon,  7 Sep 2020 12:33:33 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id m8so3153043pgi.3
        for <io-uring@vger.kernel.org>; Mon, 07 Sep 2020 12:33:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=3XwvDmKBzMp9+XSG30CgAy62dxOwhGjt/2z4l7F2zxA=;
        b=O5GsyAiabSvRC66TIi/aFns2sOAORzr50Mw6YPtbLB7k3Bub8DtEtt9AKcibcThKSr
         muQQdkVbf6aIml+E07AZsmLbnUQGZpu5jolfDJ2C7KOUCHq2gm2DbZLLFTkXnIRbK2v1
         QXfiuk2N6G3EI9M3eAnFzOl3soWrZmFQmcrcVoS+sopx4FbXjSUOtDn1Y61Ho946Ye/c
         HMCD1Ltk1+sqJnjtCzLk7gfY+0+sH/3UKMy6vcjOjtnojeVOAzVn2XIFiXTxbgP2zdpY
         wy/XeWJ9L9hcMdKu7+hGQB+ZFEU6JZjAKXqagVkHbDavvOCfbsFEDmRFpSSB3uwfYXeW
         p7jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3XwvDmKBzMp9+XSG30CgAy62dxOwhGjt/2z4l7F2zxA=;
        b=ifXum+HTREz0y++in1PQvfQ8eUpvlqh6ZsPAVx9/dmsSv4LL1hdMjCp3ybc6q3rRAm
         S5Hz+nJnv3WhCcn0Ftm+36JWS0br6YdpPgM4WwFEty696gyiJm14XqdTYBCVhYxx7SH+
         LiLpbqS0lObB80wdRHNkf6Mp0wMiM/jq1oJap4IMAELzcgacVDZC+Plc1WX+JLQ13yhc
         Q4km0jgtXvG3I/8m48qLZVvjKBD/zjBvSb6pO+Jg4GDdxteExCKqnTMKbc3Y890VQV7Q
         dnhHRptDs8gIdajrUiTtlJlFznxNxba9/suswAzja+0kXGucOFr5YMi6DHqeuJGb4WMU
         mwkg==
X-Gm-Message-State: AOAM531X5g3pLTFhc4VBKUNJDCzsiasGBlH3CP2tT1zjeIqb0Dvjd3U4
        xvHI/Y3iBfv896TymEgnd4vaWL+ZPgtQPlQo
X-Google-Smtp-Source: ABdhPJxzaHcvsqyDNPYNwpa1HV3DEFkNMELYQDPseKBDN7aCRl6Cehp3GqTwLkAN8TAdkVpq4FgFtg==
X-Received: by 2002:a05:6a00:2bc:: with SMTP id q28mr16132322pfs.61.1599507213083;
        Mon, 07 Sep 2020 12:33:33 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id u14sm16045837pfc.203.2020.09.07.12.33.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Sep 2020 12:33:32 -0700 (PDT)
Subject: Re: [PATCH 2/2] runtests: add ability to exclude tests
To:     Lukas Czerner <lczerner@redhat.com>
Cc:     io-uring@vger.kernel.org
References: <20200907132225.4181-1-lczerner@redhat.com>
 <20200907132225.4181-2-lczerner@redhat.com>
 <bfdf7e5e-06b6-f2e3-7f52-d2a6a32d719e@kernel.dk>
 <20200907171349.bsnw3r4diak3nnab@work>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <14b46abe-0c2c-ebe2-4b37-391811e5747b@kernel.dk>
Date:   Mon, 7 Sep 2020 13:33:31 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200907171349.bsnw3r4diak3nnab@work>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/7/20 11:13 AM, Lukas Czerner wrote:
> On Mon, Sep 07, 2020 at 10:21:56AM -0600, Jens Axboe wrote:
>> On 9/7/20 7:22 AM, Lukas Czerner wrote:
>>> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
>>
>> Is there a cover letter and/or 1/2 patch that didn't go out?
>>
> 
> There is 1/2 patch. Not sure why it didn't go through. I'll recheck and
> try again.

It's here now, just took many hours to get there. Weird!

-- 
Jens Axboe

