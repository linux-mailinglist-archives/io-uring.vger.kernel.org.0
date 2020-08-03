Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C82AC23B0D4
	for <lists+io-uring@lfdr.de>; Tue,  4 Aug 2020 01:19:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729156AbgHCXSH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 3 Aug 2020 19:18:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728911AbgHCXSH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 3 Aug 2020 19:18:07 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56197C061756
        for <io-uring@vger.kernel.org>; Mon,  3 Aug 2020 16:18:07 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id kr4so963618pjb.2
        for <io-uring@vger.kernel.org>; Mon, 03 Aug 2020 16:18:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=mE1Zo4WQEH1D2xB2gURPFr+G+GxzoBMDDrUhK5+OwFw=;
        b=teumh6vgDlENKBXvNps2s40IxXmmMolX/zwdU6vj+I+rAzmtej4e+I4hWjJVbRIBfZ
         kpTUCYsfLF2CxRHZu+Q+I+k+4wJZ76xv2Voa0HQrNLmk/3kXuAxdU8jqK6lpqRM9JOpV
         j5YjyrxuorlMvw0cAJUlI8bt2HBDD1MJzL634YzjkSBy5ExCsyVPEst45m1VjTJna3BF
         gRln5o5p8Muhl37cjLab4gwQNqbN9iexBBIVAVFo7fT6FOlTfdFZiongiAt7Lp+8mWIb
         KrR1wCzvpN7waxNjDi3qmP+31XH7FSw5MlVsyAezJ8KBEKOldNzlaxosMwUKKaP654t5
         IJog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mE1Zo4WQEH1D2xB2gURPFr+G+GxzoBMDDrUhK5+OwFw=;
        b=nIe52Aa+ZWBc48M9nPspIfL7qchjIbJZZ8s36J0ezcRDD9cdpRZb7lHC3FHWVivfhJ
         b5ma1BRzEzn7AXe4mFDiSwYUrUDHxIpQ3Qm6DiOykyfa4wZRdidQ9nsaYeXG5hvezcLC
         jnjnRf3JK7PrTHYY9CmS2VdkYcXh1qnXT3lsLaQhHlQTkWpBJdP4bsVyaU2JwIoprgBo
         h1J8TgDDuNpYviCUSEy8R1vSdVNvHLcT9cDSEsx38Z08ssqgjkRO6Oc/g2ynCXU9/p2h
         2gV+gMIAMO25mRPqs/bNfa/uiCDtjz7JylMQx77lQueTyl0EgxyP0r7EJ0MsRRgg/sJf
         y2Jw==
X-Gm-Message-State: AOAM531xqFiyV7gyW+LFa4StHZXToLeyd9st54zH5hvuLrb2Lfgr/Pak
        Vt/lmd3o8W6C5/KJPByXPx+QVw==
X-Google-Smtp-Source: ABdhPJyQ5beWiMDHZPKIOLmFs1yKzbJR+bIyuu4IFSXxWGZN6GmcaFXB9zUHuO4PVaq2DzCprWVemw==
X-Received: by 2002:a17:90a:6b07:: with SMTP id v7mr1627114pjj.138.1596496686230;
        Mon, 03 Aug 2020 16:18:06 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id g7sm516252pjj.2.2020.08.03.16.18.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Aug 2020 16:18:05 -0700 (PDT)
Subject: Re: [GIT PULL] io_uring changes for 5.9-rc1
From:   Jens Axboe <axboe@kernel.dk>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <50466810-9148-e245-7c1e-e7435b753582@kernel.dk>
 <CAHk-=wgaxWMA7DVTQq+KxqaWHPDrXDuScX9orzRgxdi7SBfmoA@mail.gmail.com>
 <cd478521-e6ec-a1aa-5f93-29ad13d2a8bb@kernel.dk>
Message-ID: <56cb11b1-7943-086e-fb31-6564f4d4d089@kernel.dk>
Date:   Mon, 3 Aug 2020 17:18:04 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <cd478521-e6ec-a1aa-5f93-29ad13d2a8bb@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/3/20 4:30 PM, Jens Axboe wrote:
>> Adding random kiocb helper functions to a core header file, when they
>> are only used in one place, and when they only make sense in that one
>> place?
>>
>> Not ok.
> 
> I'll move that into io_uring instead.

I see that you handled most of the complaints already, so thanks for
that. I've run some basic testing with master and it works for me,
running some more testing on production too.

I took a look at the rewrite you queued up, and made a matching change
on the io_uring side:

https://git.kernel.dk/cgit/linux-block/commit/?h=io_uring-5.9&id=419ebeb6f2d0d56f6b2844c0f77034d1048e37e9

and also queued a documentation patch for the retry logic and the
callback handler:

https://git.kernel.dk/cgit/linux-block/commit/?h=io_uring-5.9&id=9541a9d4791c2d31ba74b92666edd3f1efd936a8

For the latter, let me know if you're happy with the explanation, or if
you want other parts documented more thoroughly too. I'll make a pass
through the file in any case once I've flushed out the other branches
for this merge window in.

-- 
Jens Axboe

