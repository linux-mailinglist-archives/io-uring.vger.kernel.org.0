Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 321AC155FC8
	for <lists+io-uring@lfdr.de>; Fri,  7 Feb 2020 21:40:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727005AbgBGUkt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 7 Feb 2020 15:40:49 -0500
Received: from mail-io1-f67.google.com ([209.85.166.67]:47092 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726947AbgBGUkt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 7 Feb 2020 15:40:49 -0500
Received: by mail-io1-f67.google.com with SMTP id t26so912251ioi.13
        for <io-uring@vger.kernel.org>; Fri, 07 Feb 2020 12:40:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=3BM9iBf4tMcWhkoBVwztjm/p/O6pxExGy748ew7vpgY=;
        b=z4t1eM0SRWDjgRgoaNVTVOYujuVJX8MrHV0Im41TK4N7inBN+BwXjsVbHFkTQPPDU7
         Yg3bywHGF9WeySOK6m1ezpz0kKUAM9ngv/YnpOqJRELwOEWU7S7Lk1D+5HIfDx7/KhXu
         CbZHXejktq63SUMI+9aNldGmebWO7kGhGyVRuxd1ORc29d5cOsPtaDFCe1VYoXXyc9sx
         D4AKpFIzbaBXWfiZJa6Q42+wylaHtos5ukmIzFB28NvQV+2wqgvZEn98EWyRpzbha8ks
         vOukWAl++QOvFOuBXA0zh1PzO+r24yWQ8BM4RMufjHzdSq2aVhpE6wuHCGjSsJiL1uKV
         0+LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3BM9iBf4tMcWhkoBVwztjm/p/O6pxExGy748ew7vpgY=;
        b=eLaLF1POYl6af+Zm5DpjsZ+ziF920HC5z6dp6MQpxh+31dCgej5ZlA4T3ibq/B+VH/
         +jwhkCfxG87lUtB8oVp0aJyG+Po1aeSMJMRGo4Unzt6EvZtvYVG/fHKRIVfQB/kwBcxV
         VCUGfBRJeSfR2nM+sLIRwx/bEsQX+e+DNytKcatF3f9N1EhXdJ/rYIMiQk+FdmkruY0O
         0YehJjSwloK5THwkOMEOoH9kTtkxg9gnMBJmnK0xemM7pEcCbQsZvwm8jgLc5z9PxaMR
         USgG/9XIJZrSX+76X2EqNpt0tLOQqkp0o/zCFO+/evTpuZ1e6OxCm/eME1MJvRuH1657
         3UsA==
X-Gm-Message-State: APjAAAW+H7sGKtSGSotXMexxV82hc91K890O8AC5x361Xx9Myh8GspZK
        NmbzXK/HxsmUcRco7BgDD+XvUg==
X-Google-Smtp-Source: APXvYqzL03OKDTfogu7XZwKuY5hY1MbhonUl8I+mCoRD4r5tI7HjIZ8mQ73aXqfQxlyLg8XDIOll9Q==
X-Received: by 2002:a6b:fe0f:: with SMTP id x15mr261039ioh.219.1581108048552;
        Fri, 07 Feb 2020 12:40:48 -0800 (PST)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id t2sm1671968ild.34.2020.02.07.12.40.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Feb 2020 12:40:48 -0800 (PST)
Subject: Re: [PATCH] io_uring: fix iovec leaks
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <03aa734fcea29805635689cc2f1aa648f23b5cd3.1581102250.git.asml.silence@gmail.com>
 <bb0aeec6-9dc4-2b58-a93e-ee37c38a919c@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <e9e28cfb-fad0-ea23-48e0-461c10acccc5@kernel.dk>
Date:   Fri, 7 Feb 2020 13:40:47 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <bb0aeec6-9dc4-2b58-a93e-ee37c38a919c@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/7/20 12:09 PM, Pavel Begunkov wrote:
> On 07/02/2020 22:04, Pavel Begunkov wrote:
>> Allocated iovec is freed only in io_{read,write,send,recv)(), and just
>> leaves it if an error occured. There are plenty of such cases:
>> - cancellation of non-head requests
>> - fail grabbing files in __io_queue_sqe()
>> - set REQ_F_NOWAIT and returning in __io_queue_sqe()
>> - etc.
>>
>> Add REQ_F_NEED_CLEANUP, which will force such requests with custom
>> allocated resourses go through cleanup handlers on put.
> 
> This is probably desirable in stable-5.5, so I tried to not change much.
> I'll hide common parts in following patches for-5.6/next.

I appreciate that, it's worth keeping in mind for stable bound patches
for sure. Thanks, applied.

-- 
Jens Axboe

