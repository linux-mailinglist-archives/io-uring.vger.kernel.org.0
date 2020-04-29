Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A04251BE2B7
	for <lists+io-uring@lfdr.de>; Wed, 29 Apr 2020 17:29:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726476AbgD2P3o (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 29 Apr 2020 11:29:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726423AbgD2P3o (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 29 Apr 2020 11:29:44 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81A51C03C1AD
        for <io-uring@vger.kernel.org>; Wed, 29 Apr 2020 08:29:44 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id 7so2413428pjo.0
        for <io-uring@vger.kernel.org>; Wed, 29 Apr 2020 08:29:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=YTXjudnhmyJZbUcUjHIcJm0dpyLijddwqLudbHtOfYo=;
        b=SkN8kKpWESchDs+hK0Lv8K5CedS1YZchcFOOpHp4pMPvNOuldo/7M/gbSUdgXNflaU
         IyAXkkAYoBjqnZM/VIhzGbhN68yBC5Li8S2YZCN4iO5HLR8K3P9j1/maqR4jE9eP1Cn9
         4JqRI7+2Jbcvnf/tCdpj9PNQ8dAAy8mXlQ9D/4ATkNZOyfEWVmbN5Qf8OfzZYz/Zalxd
         X+46O+cHMmJfeRpGsCFxi/juv56JUVQCOQnx8feOiKacPyGwqFG5dYZg2p5w979tfd5P
         yihQ086JIt3SudWbSHIJc3b2NEP4fWUy3qbvd4PlyESky82lpzxzHVFnJyxQKobgxBJL
         Rg8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YTXjudnhmyJZbUcUjHIcJm0dpyLijddwqLudbHtOfYo=;
        b=Vyu3f9uiEngZ4ng8xjz1ppAF9ZJ1tXxlzkMXYUjUNYxCpIMXh2rG7oAj3HacEQAPwV
         t4+6Bw4kLaoH3ttNeoFxqroYYFTXgQYGKRIDS9UylJaa489Vdfkqrb+AY0iYF4jzTHpr
         /+E5ag1dTmG24tRgZjuYqt1t5UISIztGxM0Tcwnqe129YIhflStuusoO6kPnkRg7GmvM
         DFI0c7YPuBDxMeOCuQ+hsz9JRB9UKFEng8EnjETwSbFK93x/oDDFZRMXM9U0BhCjnTGB
         lcc+BiNdQlfSywrWUPWyDZ5OaWRtcV3CDJwOc7dBwdXzoASXuLpJ2rMydxkn1Mc+57iq
         aHOQ==
X-Gm-Message-State: AGi0Pub3fLZGHfZ3HxCrbi4NgQR6uIv0PN5IFns/xOnPS68XfNuRTf4J
        z4yDInh6Ni3iLrCael+Pt4s30CXSQunxuA==
X-Google-Smtp-Source: APiQypI6dJPrzyOFadYnA7ZlPBRAp8Tlf4U165cQIfWYIcHgbnTICa3mdYFW3EAitEmJl37z1Bo5OQ==
X-Received: by 2002:a17:902:b948:: with SMTP id h8mr20701027pls.309.1588174183649;
        Wed, 29 Apr 2020 08:29:43 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id k6sm4741403pju.44.2020.04.29.08.29.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Apr 2020 08:29:43 -0700 (PDT)
Subject: Re: Build 0.6 version fail on musl libc
To:     Christoph Hellwig <hch@infradead.org>
Cc:     =?UTF-8?Q?Milan_P=2e_Stani=c4=87?= <mps@arvanta.net>,
        io-uring@vger.kernel.org
References: <20200428192956.GA32615@arya.arvanta.net>
 <04edfda7-0443-62e1-81af-30aa820cf256@kernel.dk>
 <20200429152646.GA17156@infradead.org>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <e640dbcc-b25d-d305-ac97-a4724bd958e2@kernel.dk>
Date:   Wed, 29 Apr 2020 09:29:42 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200429152646.GA17156@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/29/20 9:26 AM, Christoph Hellwig wrote:
> On Wed, Apr 29, 2020 at 09:24:40AM -0600, Jens Axboe wrote:
>>
>> Not sure what the best fix is there, for 32-bit, your change will truncate
>> the offset to 32-bit as off_t is only 4 bytes there. At least that's the
>> case for me, maybe musl is different if it just has a nasty define for
>> them.
>>
>> Maybe best to just make them uint64_t or something like that.
> 
> The proper LFS type would be off64_t.

Is it available anywhere? Because I don't have it.

-- 
Jens Axboe

