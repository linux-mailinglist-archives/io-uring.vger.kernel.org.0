Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AA6E2ED2FC
	for <lists+io-uring@lfdr.de>; Thu,  7 Jan 2021 15:48:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726165AbhAGOrf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 7 Jan 2021 09:47:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725965AbhAGOrd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 7 Jan 2021 09:47:33 -0500
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 530F0C0612F5
        for <io-uring@vger.kernel.org>; Thu,  7 Jan 2021 06:46:53 -0800 (PST)
Received: by mail-il1-x132.google.com with SMTP id w17so6915091ilj.8
        for <io-uring@vger.kernel.org>; Thu, 07 Jan 2021 06:46:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=ooMYkwJKsD31aRQVhm9BjeZqNfqq/7y33tQ9T0DroAA=;
        b=Fz4K3yYSyraPJLRiT087YqflP5hyy2Dmi/VithcUKETICgCTikzrjka/SD6I/hkvAg
         qkEpM3RiQrXO5ph2uqrW2zIbyEfpiD8gR24uSV6rOG+mCmvLnwSAblNQZMZkzo3Cs0eD
         Tpn9CDKKEI6SwMGuki/hHAeROh29nFEbTi7RaU29pVWgt7AxN5knruBIiZLT8Tp5kMHj
         s15CduI5tpOkAE+JZGp/AN3/H6Z/2PcKmSi3N+h1gfAjeFQKpOO/9VV2RvBUTrbrh3uR
         nwciWBDc8oSE8iIE++4acmhyh9G8C7gHqstkkSVNfpq5cKk1V0/Uma7eqjrlGg5hx/iL
         0xvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ooMYkwJKsD31aRQVhm9BjeZqNfqq/7y33tQ9T0DroAA=;
        b=EBkp5hCCrDb591vrIG7VJ1yUyIVmR1hto9iYpraNfmJTjDJlZ6rIep3/jioyygdjvn
         hVGrIrXG6bCA/6HUMmefHd/yskCbT85osXnvloswuAz3Ts/+Nk54wpp+MDK4mrPOIfnR
         EQFS6vFfAowgQQIOSThJKOpjTNem0PbHNlmjZOw8ZhWHhrIfU94GnrCm+slyWoR+Aogw
         4b6tVQGJJYA6Jh015Z52Py2f+w6O2hnK5X5hhgX/2WDXIv5A90T6n2ySOgtzD+mUQkTD
         xwsI6Psb6wjT+9KE2d4E5+r88FSWK2DpZOW2fyOnQocUsAlnze5ladH9rrGTffO9DquD
         X0Sg==
X-Gm-Message-State: AOAM53272+rLdg1Kdq37LfqZBBTokLTbfAXQcv2f3VpqW4QlVJSbvutN
        Oy8ELQlzldddiz2gqxYjTcYKIztScMS0Ow==
X-Google-Smtp-Source: ABdhPJzQHdPZxbaQkP2EF9XRAznH8FmWQ39fhlG4ahUSkoAAvQBBCpXBwcTl/txFjThWRh6hkOicsQ==
X-Received: by 2002:a92:444e:: with SMTP id a14mr9254127ilm.129.1610030812546;
        Thu, 07 Jan 2021 06:46:52 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id 1sm4951036ilv.37.2021.01.07.06.46.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Jan 2021 06:46:52 -0800 (PST)
Subject: Re: [PATCH liburing] tests: test fixed file removal order
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <31d6fcb0f328966c5f68c7629d123a5b0f783331.1609966277.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <79681ad7-2bb0-d8b6-9764-2fba1f2e7d8e@kernel.dk>
Date:   Thu, 7 Jan 2021 07:46:52 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <31d6fcb0f328966c5f68c7629d123a5b0f783331.1609966277.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/6/21 7:46 PM, Pavel Begunkov wrote:
> Do two file removals on a fixed file that used by an inflight request
> and make sure it goes well.

Applied, thanks.

-- 
Jens Axboe

