Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E715E33D59F
	for <lists+io-uring@lfdr.de>; Tue, 16 Mar 2021 15:24:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235273AbhCPOXm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 16 Mar 2021 10:23:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235176AbhCPOXP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 16 Mar 2021 10:23:15 -0400
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D45FC06174A
        for <io-uring@vger.kernel.org>; Tue, 16 Mar 2021 07:23:13 -0700 (PDT)
Received: by mail-il1-x12a.google.com with SMTP id i18so12771435ilq.13
        for <io-uring@vger.kernel.org>; Tue, 16 Mar 2021 07:23:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=mG0otpdBlgKByCH9h0shmT85CsQKGZouNXNl9JM+Wxc=;
        b=hfdrWqzsLvlGX4Q50uqQT09TLseF1z/iacpQWRxCdf6Tg6zNmyoLgdQ9FE3svb932Y
         697nZiz/Jjk5kNwjp39whl7UwToqz5U18TY3rJizC9devmxaqgBROqM0p84PW8U3POG9
         wINIPF1Qi/gFVgLqxl6D1+qOfTCxRgxgbNcHccKvRXGy242HXbbMh8O89Z1LWblohvjS
         FY1r2UPmbhke9CYuWbgYu0zTDryFUeKU13CH5MzvT5XWOF/W1BCYRnnobQ92VigpFsYw
         Twnb31yi29N/cAwJtN/dLG6a+A6tvdF7DE3pLh3eers4spzkPYVlza1gsOST9v3odHGw
         MqJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mG0otpdBlgKByCH9h0shmT85CsQKGZouNXNl9JM+Wxc=;
        b=jZM6fBTbFXGhe2P2vtDECcE3ExZyB0VTx+2F3rfoGNZAkmao0MraGQbNtq7x5/3obX
         LRiMgs16AQZoCGOTp4RzRvjL0vBeSHfQC6zymt2mvtHqhgMExXr7ugZ1Sdpd6DoLK5Wl
         JunWGS5Pw974/FfrST4TKIuIi0SYIPvz4yAS7oC2jgovlWsRdooNeQOtGRdg05dlEiRF
         HFtiW8HKDydN0XtlGjTD41uMPJTiizjCNG34hE+t7F7/xmQ06VJ6EbK41tIZO9G6Iz2Q
         h+YOFc1S+8b/p51GeiJ+RxxBFPg4nokWpnFlMZwISD53grf0/1nNwnDeHiPGMVN97O8O
         vekg==
X-Gm-Message-State: AOAM531K9d+PY4wwTpEdd/Y7c2Iw+vPBxJQ8ndqiMziOyYJl7t1ywGnm
        DKXe9u6gDJN37C4L6RbrkZo7rbdnxyVogQ==
X-Google-Smtp-Source: ABdhPJyMxEVJWeDYfdlxzopwSkeIAIsMF6n8tDth1JJT9dy6ZGlCYdxE+ijvjJUUHyZGlzRnxLTtaQ==
X-Received: by 2002:a92:c102:: with SMTP id p2mr3775243ile.227.1615904592330;
        Tue, 16 Mar 2021 07:23:12 -0700 (PDT)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id r3sm9452901ilq.42.2021.03.16.07.23.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Mar 2021 07:23:11 -0700 (PDT)
Subject: Re: IORING_OP_RECVMSG not respects non-blocking nature of the fd
To:     Norman Maurer <norman.maurer@googlemail.com>,
        io-uring <io-uring@vger.kernel.org>
References: <371592A7-A199-4F5C-A906-226FFC6CEED9@googlemail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <e83c9ef0-8016-2c4a-9dd0-b2a1318238ef@kernel.dk>
Date:   Tue, 16 Mar 2021 08:23:11 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <371592A7-A199-4F5C-A906-226FFC6CEED9@googlemail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/16/21 8:00 AM, Norman Maurer wrote:
> Hi there,
> 
> I think I found a bug in the current io_uring implementation. It seems
> like recvmsg currently not respect when a fd is set to non-blocking.
> At the moment recvmsg never returns in this case. I can work around
> this by using MSG_DONTWAIT but I don’t think this should be needed.
> 
> I am using the latest 5.12 code base atm.

This is actually "by design" in that system calls that offer a "don't
block for this operation" (like MSG_DONTWAIT here) will not be looking
at the O_NONBLOCK flag. Though it is a bit confusing and potentially
inconsistent, my argument here is that this is the case for system calls
in general, where even O_NONBLOCK has very hazy semantics depending on
what system call you are looking at.

The issue is mostly around when to use -EAGAIN to arm async retry, and
when to return -EAGAIN to the application.

I'd like to hear from others here, but as far as io_uring is concerned,
we _should_ be consistent in how we treat O_NONBLOCK _depending_ on if
that system call allows a flags method of passing in nonblock behavior.

-- 
Jens Axboe

