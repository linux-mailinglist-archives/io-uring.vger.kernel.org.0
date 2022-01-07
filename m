Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5862487A3E
	for <lists+io-uring@lfdr.de>; Fri,  7 Jan 2022 17:23:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232495AbiAGQXP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 7 Jan 2022 11:23:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231599AbiAGQXP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 7 Jan 2022 11:23:15 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11818C061574;
        Fri,  7 Jan 2022 08:23:15 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id u25so24150173edf.1;
        Fri, 07 Jan 2022 08:23:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=7ksVNQ+2KGXbOrVS8Wvzq1UTTH4v+seanY4gowafB9k=;
        b=fHCJR5cZeorxot9V7bzo9/Y6XvMMTmjmaFV//hLEL183Pu2SYBDs+bzSwkd4dCd9RB
         N878Y6mY/7p6gR5hRcQ9C6CHxod/Fb24BXLnD2rdXh2FAziT5IfsljnNrSTCsHi0U1zx
         HimCq9owjeS58+e0sgzgo8VPLR8DgbEv4TBN7fF1PrlAN1EIg3U9t60c55jCGnB8ITvO
         AFOYlMrY3W94jAqbg6oKGw3mzgvnOCTPrEzkVLQ0sThGlLEKDsejPPxChT0KcHrUDHKD
         UOph2yKcAlm1apDhPF0kp5IVBkz1NM2vZqHPoMcw8jhmjctTIANoYTChBcCYyjymPJNA
         Xu6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=7ksVNQ+2KGXbOrVS8Wvzq1UTTH4v+seanY4gowafB9k=;
        b=rz3t9j1Bdbzo4HDJsCCSZPY4mQZk8sa4VpdD5mSOIxodWkxiLTEosAXDw1ebLtVYwn
         kAjcJDtQd6ewfD01c6Sqn3OlkB+v4u+qyCaFibph++94F9CUVoJVix9ExE6FI3FJYi1T
         yQmP4zFcTd5VrHEojmRAQjMvq5ug1AAwD2mH6TzkKIxHH1oSOJw6X0hfhhocv3t0AziL
         F+mPDrieoGWR4t0mKnqSCAFnzObW2AGIAOFQmC5LKkeC7RNM4ab+mySK8RniatITE2h6
         vKLbS8EkdJ40FGoHw3kynARLmmlZH6rpyb+/OVbT/dt9gusb11oYYpsRys4Vd++iqFc3
         pmmQ==
X-Gm-Message-State: AOAM530IYtolaopAtMBtpfUfYa3n2y+uJPoR6P8OHNMB+6EqM6FIWcqn
        4pcGfKn37ZBC8ccAMpxdQag=
X-Google-Smtp-Source: ABdhPJzcuXRWso/d6jreO6uu/Rv9QdY34wlneTJLzuyx+U+n3mMypmDrYbBk5aX++QSNQI3o9tyfDA==
X-Received: by 2002:a17:907:c17:: with SMTP id ga23mr46416747ejc.127.1641572593653;
        Fri, 07 Jan 2022 08:23:13 -0800 (PST)
Received: from [192.168.8.198] ([148.252.128.4])
        by smtp.gmail.com with ESMTPSA id 16sm1527241ejz.34.2022.01.07.08.23.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Jan 2022 08:23:13 -0800 (PST)
Message-ID: <e8f2a002-4364-18e4-41a4-228cd364feef@gmail.com>
Date:   Fri, 7 Jan 2022 16:22:44 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: Observation of a memory leak with commit e98e49b2bbf7 ("io_uring:
 extend task put optimisations")
Content-Language: en-US
To:     Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        io-uring@vger.kernel.org
References: <CAKXUXMzHUi3q4K-OpiBKyMAsQ2K=FOsVzULC76v05nCUKNCA+Q@mail.gmail.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <CAKXUXMzHUi3q4K-OpiBKyMAsQ2K=FOsVzULC76v05nCUKNCA+Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/7/22 15:00, Lukas Bulwahn wrote:
> Dear Pavel, dear Jens,
> 
> In our syzkaller instance running on linux-next,
> https://elisa-builder-00.iol.unh.edu/syzkaller-next/, we have been
> observing a memory leak in copy_process for quite some time.
> 
> It is reproducible on v5.15-rc1, v5.15, v5.16-rc8 and next-20220106:
> 
> https://elisa-builder-00.iol.unh.edu/syzkaller-next/crash?id=1169da08a3e72457301987b70bcce62f0f49bdbb
> 
> So, it is in mainline, was released and has not been fixed in linux-next yet.
> 
> As syzkaller also provides a reproducer, we bisected this memory leak
> to be introduced with commit e98e49b2bbf7 ("io_uring: extend task put
> optimisations").
> 
> Could you please have a look how your commit introduces this memory
> leak? We will gladly support testing your fix in case help is needed.

Thanks for letting know
I think I know what it is, will get back later.

-- 
Pavel Begunkov
