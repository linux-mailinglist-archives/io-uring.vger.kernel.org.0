Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B46B536405C
	for <lists+io-uring@lfdr.de>; Mon, 19 Apr 2021 13:22:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238253AbhDSLWs (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 19 Apr 2021 07:22:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235872AbhDSLWs (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 19 Apr 2021 07:22:48 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8811C06174A
        for <io-uring@vger.kernel.org>; Mon, 19 Apr 2021 04:22:15 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id r7so21592974wrm.1
        for <io-uring@vger.kernel.org>; Mon, 19 Apr 2021 04:22:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+51m49IpLy+16QroNKEeYIZZwAa/qnyodXGmQQeD92M=;
        b=X5Yi/y3wlUE6CkdPp+9MlPn6g+9PJlRmBcIWhEux/ukTNKlqwQXUpqwwY+Zu6iPCGU
         ZkxgmKKqvZox2ADg7vfhpH3Vp2+amSsyMmnFWHBlhd+ZO5Tr6l1mpdNwtvEqBd2O0P2Q
         IYw1GquDfXrOuKpOjGX/ErsrRpP/IA+Luaai0unHpI/uAbKIhmtaMAGaxKo85iUZsbnj
         x9TQsjkM7wrnsXWr5UfzWz5j3UABZWmIK0bYSVugoXL/h2Huqc/VzucZXZi/Czva/+VP
         eYOhD0l7XT5Huo/WZaJnKP+NasGAZdE0Xp3zDirGR94xtk0tDsxnPokZAJw3j9H9ADOH
         LD9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+51m49IpLy+16QroNKEeYIZZwAa/qnyodXGmQQeD92M=;
        b=bW1w3mvE2AH8V19bFU4w2aaHCwJK+xlFnX0V3HE69GZWdTUSeQcCwxXGdyUGjjP0hm
         PN2xXcOdMiPcoNpiXTjFbh6PpjsuEL0yp+KnTzF2zo3lv5Zu8O8HcQDXtfI1727eo5EP
         ajzEsIIu7rwHw6yE4WQUniAX5sHdrUD633o0FowteMATdttCRcjvMMDgjBQy6xGT04bc
         vmzoUSTT2NuAgxdJp2fY+o19j60X8hVbH4gkRkNXNBa+sMHJpSSad7/ZJUd4lDCEX6Px
         /JQQqJEvQkLPM1enkonL1lWVTNlS/SBLjf+QBoJ8zU08MoaijnciMbv3hVFNJPanAhqN
         ImPQ==
X-Gm-Message-State: AOAM530Wm1DKg/jPpL+y1lVek3hzPy2dSmvlO+uyWdI+YVDbFhMEcado
        AZ2YwWIyqC3XGDUCt1swYDOeIm3bhfSmBg==
X-Google-Smtp-Source: ABdhPJytvBtgbmKB7CLI7jbDSQhpt0x4QmGLbtxMbmbAVK0puIQF1C1hwItjaApxT5hgRN3DllVFxA==
X-Received: by 2002:adf:dd49:: with SMTP id u9mr13848288wrm.337.1618831334252;
        Mon, 19 Apr 2021 04:22:14 -0700 (PDT)
Received: from [192.168.8.197] ([85.255.232.103])
        by smtp.gmail.com with ESMTPSA id y19sm6198686wmj.28.2021.04.19.04.22.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Apr 2021 04:22:13 -0700 (PDT)
Subject: Re: [RFC] Patch for null-ptr-deref read in io_uring_create 5.11.12
To:     Palash Oswal <hello@oswalpalash.com>
Cc:     axboe@kernel.dk, io-uring@vger.kernel.org
References: <CAGyP=7cWH6PsO=gbF0owuSXV7D18LgK=jP+wiPN-Q=VM29vKTg@mail.gmail.com>
 <a08121be-f481-e9f8-b28d-3eb5d4fa5b76@gmail.com>
 <CAGyP=7c7vOXoOet-ZdF46Z1nkvE3odqJXQKSeX9cx+rQ4FDtWw@mail.gmail.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <d346085f-8b9b-d620-1e0c-aa78fee8db13@gmail.com>
Date:   Mon, 19 Apr 2021 12:22:12 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <CAGyP=7c7vOXoOet-ZdF46Z1nkvE3odqJXQKSeX9cx+rQ4FDtWw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/19/21 12:10 PM, Palash Oswal wrote:
> The last commit I have is fe0d27d7358b89cd4cc43edda23044650827516e

I assume your bug happened in io_uring_create(), and if so
fwiw confirm that your patch looks right ...

> (v5.11.12 release)
> 
> I see that the commit you pointed me to was merged by
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=9278be92f22979a026a68206e226722138c9443d
> is on top of 5.12-rc2. Is my patch needed for the v5.11 tree?

... if the mentioned commit fixes the issue, then we should
backport it, because
1) there is more to that patch, so should be done in any case 
2) stable _highly_ prefers to take commits from upstream, but not
newly crafted ones.

However, that might be useless because a large chunk of patch
that's to be ported soon.

-- 
Pavel Begunkov
