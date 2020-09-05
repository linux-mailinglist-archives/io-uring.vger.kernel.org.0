Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C8AE25EB7A
	for <lists+io-uring@lfdr.de>; Sun,  6 Sep 2020 00:34:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728751AbgIEWe6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 5 Sep 2020 18:34:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728103AbgIEWe6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 5 Sep 2020 18:34:58 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75FF4C061244
        for <io-uring@vger.kernel.org>; Sat,  5 Sep 2020 15:34:57 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id g29so6179639pgl.2
        for <io-uring@vger.kernel.org>; Sat, 05 Sep 2020 15:34:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=OeKueWk70M80zoIDIl3E0LarBdwm/qSIVHDs7UncQTA=;
        b=MKprC42NrWb5PIgG12OwhQJPDlLcU3jDoA1ocJ+QfpCEGiftaCZOQCB68a0K0PLvcM
         kAjG2mkuctPakGDdeRkPnPFoOqdLm680O9pDWIvz4n0EOhSMhhgw1OsJjCQPchE19uXm
         bHau/ovZd5bUszKFeqwtsKQ9KGKPkNCv53u6YdH+ah8uwzZuSkwlNljEz0XNBXahQoJp
         gtHRI55Fnp1GKMww8GF6bF1Vu+437UjGtrRHCUjeEgPYJsEbUIbPCzUUubnMxTxU1bHY
         0y0MxA/6kdFR8Zo1rAeMvaL0PsZYesoM+RASCG5/PF3vj0oBatRmxtm18ZtkkFg+cGoz
         6sDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=OeKueWk70M80zoIDIl3E0LarBdwm/qSIVHDs7UncQTA=;
        b=GMOOM5RXD9DwbvxO82V/mD6kdKP0Vdt+bVv3bKONbYWHcibGtVQypUL3q9LZxAMRBy
         1QVlZ2lP2uzQ+8afOEt++zqLOvmDB23o384468BHvHw57voGVmkHkjDh9cxdgar+jeYe
         QKMplUJ2wAM0MsWHCN4pk2haocDmTUGiylbaFhfmo7nGT6uZX8kw21O0kL8Uii3Ny7sR
         dimhswNlzIwQwySuK71sYKXWjF5od4ARas4i1Rw8E4/uB8fAlbf47hcbzN4yJAlufkQ+
         /ICGxhzumEpysRQHbFiC0toqIA9GX7zZRf0T76wvyYoT6P18UXxVYO/7V0XQtHf9LHTZ
         XFkQ==
X-Gm-Message-State: AOAM533ElEuO6f/yJ1tWdRpufOqOkkLG5RtOoRgjT6Bdecr5Ftr2sGq8
        E9pRy1lLUeKDv4e3y/J7/q9z78bkOQH0SBv1
X-Google-Smtp-Source: ABdhPJwdMqw3IfUToUqhstLXS/4+MjpEc81uYdZwcYFT+ELODuHKKcvcX/pszthIyn2JMEBQSl6rwg==
X-Received: by 2002:a63:ea4f:: with SMTP id l15mr11597395pgk.434.1599345293442;
        Sat, 05 Sep 2020 15:34:53 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id gm17sm3002498pjb.46.2020.09.05.15.34.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 05 Sep 2020 15:34:52 -0700 (PDT)
Subject: Re: [PATCH 0/4] iov remapping hardening
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1599341028.git.asml.silence@gmail.com>
 <8381061c-e2e8-6550-9537-2d3f7a759e92@kernel.dk>
 <4140076d-9aa6-ffb8-81a1-f8c1820ebfd2@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <2203dd86-b639-9978-11e2-4c3c7282f048@kernel.dk>
Date:   Sat, 5 Sep 2020 16:34:51 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <4140076d-9aa6-ffb8-81a1-f8c1820ebfd2@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/5/20 4:15 PM, Pavel Begunkov wrote:
> On 06/09/2020 00:58, Jens Axboe wrote:
>> On 9/5/20 3:45 PM, Pavel Begunkov wrote:
>>> This cleans bits around iov remapping. The patches were initially
>>> for-5.9, but if you want it for 5.10 let me know, I'll rebase.
>>
>> Yeah let's aim these for 5.10 - look fine to me, but would rather avoid
>> any extra churn if at all possible.
> 
> These applies cleanly for-5.10/io_uring. It should conflict with

Great, I'll queue them up then.

> yours req->io shrinking patches, but it seems you haven't queued
> them yet.

Which ones?

-- 
Jens Axboe

