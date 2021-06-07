Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAB8439DB64
	for <lists+io-uring@lfdr.de>; Mon,  7 Jun 2021 13:32:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231347AbhFGLdw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 7 Jun 2021 07:33:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231214AbhFGLdv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 7 Jun 2021 07:33:51 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B810C061766;
        Mon,  7 Jun 2021 04:32:00 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id c5so17160804wrq.9;
        Mon, 07 Jun 2021 04:32:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Uxb/A2MPjXbzASHgkfy5YKJHStSLK7BqExmqWzuI9d8=;
        b=rKYLxOVBkYBEiIuEmWQ1i67DYBA3NJInMYDNtkTA+2EDZydoj5dM1WRyR9jSX5c+5I
         cuuNjOwJaouNFGCBn0daD9Nm0pB70MC/vN1Uafd/Zq7UtoD7CKg0Zo7Bw7AGFZ+aZyec
         6kOEHSsQFy3Vm2r4lwJloMm4WqZesN0cpyUn0Ao8z6/nbx7kUnfkD+F47TsXsqVAGnr5
         SVlQwsrB/ihmrG0Q91cu/bH38V4t8DOPd1+asWa85wv2rNAawmnyx7nOhgG4toGLBPkk
         2bhiKy5EYYTY/H2/xl0bFA0zSq8Imb9eDj9OizAZRkBZdBP2rBjDDpJyAHbOI9ClPRKt
         ZaWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Uxb/A2MPjXbzASHgkfy5YKJHStSLK7BqExmqWzuI9d8=;
        b=UcFWa1TVuSMdCeqaHoNamHmyjmTh7KNLnNB6Pu27bIOx2EyGPxwB8NkmwykgLpVqF+
         voL9VrXScftw+6YVgnsNK6SfFuTS/Cu1LsmZd38h9vEymo52ZAect4cnwmpixfVGAOOC
         7XPLPn6fjXc0fgWG2lGuSjLONlrcF93JE9D2El475M9DmA+73ERXSZxUQV2Uj4ftCmYm
         6lLWKMFhnVNQVu9TjYEmd2TDXbrnEvuR2lhi2Q3KiuGtQGmcLRWRVZkCLPhwZLgrDAgG
         4XbbzK2qlIOoPiZaZwn9W3sZgG8LsWrO4ifC6oylIXGrb7uU7B1CIB3q2LyrFSNoNtCB
         op6Q==
X-Gm-Message-State: AOAM533NNuLQoNZSi6ILZ+nRqFfWuquPNf6urUTVCffTMmAMfRV4il/Z
        nqaST0CjK6y5qhTuk5f2fpnwLFpYAq7kFCfL
X-Google-Smtp-Source: ABdhPJyXzTxXdRFsNQTRJTztyPbxgKUGoZhvQksk6HeUu8Xgw5RMarJdOACZU+aW775/RLr5rzYIfw==
X-Received: by 2002:adf:f207:: with SMTP id p7mr11098933wro.275.1623065519049;
        Mon, 07 Jun 2021 04:31:59 -0700 (PDT)
Received: from ?IPv6:2620:10d:c096:310::2410? ([2620:10d:c092:600::2:457c])
        by smtp.gmail.com with ESMTPSA id x10sm5090086wrt.26.2021.06.07.04.31.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Jun 2021 04:31:58 -0700 (PDT)
Subject: Re: [RFC 4/4] io_uring: implement futex wait
To:     Thomas Gleixner <tglx@linutronix.de>,
        Andres Freund <andres@anarazel.de>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Darren Hart <dvhart@infradead.org>,
        Davidlohr Bueso <dave@stgolabs.net>,
        linux-kernel@vger.kernel.org
References: <cover.1622558659.git.asml.silence@gmail.com>
 <e91af9d8f8d6e376635005fd111e9fe7a1c50fea.1622558659.git.asml.silence@gmail.com>
 <bd824ec8-48af-b554-67a1-7ce20fcf608c@kernel.dk>
 <409a624c-de75-0ee5-b65f-ee09fff34809@gmail.com>
 <bdc55fcd-b172-def4-4788-8bf808ccf6d6@kernel.dk>
 <5ab4c8bd-3e82-e87b-1ae8-3b32ced72009@gmail.com>
 <87sg211ccj.ffs@nanos.tec.linutronix.de>
 <20210603190338.gfykgkc7ac2akvdt@alap3.anarazel.de>
 <87v96tywcb.ffs@nanos.tec.linutronix.de>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <131a59af-a625-27b3-433e-ff8b7c36753e@gmail.com>
Date:   Mon, 7 Jun 2021 12:31:48 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <87v96tywcb.ffs@nanos.tec.linutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/5/21 1:43 AM, Thomas Gleixner wrote:
> Andres,
> 
> On Thu, Jun 03 2021 at 12:03, Andres Freund wrote:
>> On 2021-06-01 23:53:00 +0200, Thomas Gleixner wrote:
>>> You surely made your point that this is well thought out.
>>
>> Really impressed with your effort to generously interpret the first
>> version of a proof of concept patch that explicitly was aimed at getting
>> feedback on the basic design and the different use cases.
> 
> feedback on what?
> 
> There is absolutely no description of design and obviously there is no
> use case either. So what do you expect me to be generous about?

That's a complete fallacy, the very RFC is about clarifying a
use case that I was hinted about, not mentioning those I described
you in a reply. Obviously

-- 
Pavel Begunkov
