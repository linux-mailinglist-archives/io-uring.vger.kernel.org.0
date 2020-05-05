Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 172311C63C7
	for <lists+io-uring@lfdr.de>; Wed,  6 May 2020 00:16:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728853AbgEEWO6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 5 May 2020 18:14:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727089AbgEEWO6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 5 May 2020 18:14:58 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C891C061A0F;
        Tue,  5 May 2020 15:14:58 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id s8so4555620wrt.9;
        Tue, 05 May 2020 15:14:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=NkgPAsy9lSzo3kxMReN42Y08VUHN5reHbw+z8ImJXIY=;
        b=bvAF6W1JpPt1n6ZX78LNYpc4YdzdAmFWsBVBSU8JK022z0fZveO4klYAUkmbg78P1d
         qVQrILr1FvfUgSm9eh1F40lNs0G3hMPdDyDKKo0fMsPowI1YCNDSSBkNHGSshMdcoTI7
         3MJj20w/XWXEBrEZDdJJSxWZjTQJtEgbLLL3Bjw4P6OPSsToOUadlasfRuCfkZjMZVWj
         CmO3wzhRB6Ehcc6Yyp8xz8HaOo/uDzcmnyQVAHq6j02Bl3u+cBDOsQYBTyt8OR/rswlR
         +ZCRcqDLKWfJ5LAEpvpgB140Tm33A3yDIhc+EfaowP1M5NyGo7RyoyxF3EoCSQDJhLyt
         YJxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=NkgPAsy9lSzo3kxMReN42Y08VUHN5reHbw+z8ImJXIY=;
        b=TKpuREPBSYkf3W4Ij4oWP+2NCMXfBOvS9lriYqDg9zq7FuPfed+SN4w3+T+8aRreIn
         jokPwW59BE/TNSK+uX2gDVr4T2NKscH6JHL74xbuafMvaxdk1qWewsqHH9wGpMCU6uY+
         a8dMWXvsDEZKKmf1xpeqeyMlJ1Hs6svFAyg6HYK4UuyHe2IUvxuBGI1yhMKvU6HX2pZ4
         mySUgYajgHcbx8djVBOKtPf/K27KnRoL7MQ1Iyj/ZODl07iTQfzy000x4PtSSzGHryZB
         +pMQHbjyuGjk0k7nGI+dSCqTxl2LUe9tYWqywLrfEDJoIYMBl+BoZFW5DCwwET6aQ9eg
         jYnw==
X-Gm-Message-State: AGi0PuYfcAAvZnLEBFhzqGe4mvfLOuuWrr5Ukh5TA+HgBu3PHDOO2VeK
        /WBC1b/itYfxCT8e7bUUz6Unt0Kr
X-Google-Smtp-Source: APiQypLYE9uKCc7TkhkBa6EXZuNMtWY/KlS5bXFCIG3n5Rfh9vrZHBj7IIVvjiKyqAA6P+n+grVq7w==
X-Received: by 2002:a5d:570c:: with SMTP id a12mr5966901wrv.80.1588716896314;
        Tue, 05 May 2020 15:14:56 -0700 (PDT)
Received: from [192.168.43.168] ([109.126.133.135])
        by smtp.gmail.com with ESMTPSA id d18sm5511441wrv.14.2020.05.05.15.14.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 May 2020 15:14:55 -0700 (PDT)
To:     Clay Harris <bugs@claycon.org>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Jann Horn <jannh@google.com>, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
References: <51b4370ef70eebf941f6cef503943d7f7de3ea4d.1588621153.git.asml.silence@gmail.com>
 <20200505211029.azfj2c4scoh6x2kx@ps29521.dreamhostps.com>
 <2146b60d-d982-59c4-33d3-a5e6ad68fc8e@gmail.com>
 <20200505220032.fm5vqf3xuaucnjle@ps29521.dreamhostps.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH for-5.7] splice: move f_mode checks to do_{splice,tee}()
Message-ID: <c202b074-1cb8-8bf0-3d42-c6c5dd68f2ee@gmail.com>
Date:   Wed, 6 May 2020 01:13:50 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20200505220032.fm5vqf3xuaucnjle@ps29521.dreamhostps.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 06/05/2020 01:00, Clay Harris wrote:
> On Wed, May 06 2020 at 00:38:05 +0300, Pavel Begunkov quoth thus:
> 
>> On 06/05/2020 00:10, Clay Harris wrote:
>>> On Mon, May 04 2020 at 22:39:35 +0300, Pavel Begunkov quoth thus:
>>>
>>>> do_splice() is used by io_uring, as will be do_tee(). Move f_mode
>>>> checks from sys_{splice,tee}() to do_{splice,tee}(), so they're
>>>> enforced for io_uring as well.
>>>
>>> I'm not seeing any check against splicing a pipe to itself in the
>>> io_uring path, although maybe I just missed it.  As the comment
>>> below says: /* Splicing to self would be fun, but... */ .
>>
>> io_uring just forwards a request to do_splice(), which do the check at the exact
>> place you mentioned. The similar story is with do_tee().
> 
> Okay.  I'd been thinking that since you were moving the file mode
> checks into io_uring that the previous place they were called wasn't
> on the path.  Evidently, you're just moving the mode checks earlier.

I move them from sys_splice() later to do_splice(). Even though the patch
doesn't touch io_uring directly, it fixes a problem in there. And as a nice
addition, it looks prettier and removes a couple of useless checks.


-- 
Pavel Begunkov
