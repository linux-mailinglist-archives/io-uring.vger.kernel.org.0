Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DAAE3EC9D8
	for <lists+io-uring@lfdr.de>; Sun, 15 Aug 2021 17:12:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234332AbhHOPMz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 15 Aug 2021 11:12:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232558AbhHOPMy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 15 Aug 2021 11:12:54 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6937C061796
        for <io-uring@vger.kernel.org>; Sun, 15 Aug 2021 08:12:24 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id w13-20020a17090aea0db029017897a5f7bcso23414368pjy.5
        for <io-uring@vger.kernel.org>; Sun, 15 Aug 2021 08:12:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=imSoyKTeUR+bgnKkHR56BAV9e5dhaT/9hmoW62kZVKY=;
        b=kHg8XUzvJ8+ImAVpbwGlCs8HWPkY4Wk39lkFJY8Uf4ytm+OSvcoMeKQqeENTqU5Auj
         HgHGJjZDwNLSCoOheL9hA2YnObuU+V0b4awXzOsQCi0jQiFGHNijc0uNkKGqdwdH4eQ8
         9llJk81kqzLEie3sZ31vs/YXXys2wyqL6dGJTi9QyBOvrdP/3/+dyLxdl1+jGxyGQL42
         ikogaM429oIADf3RZgmiuaGAuY2Tp/tpZDx1LlBZj8c1UW4tXSnd1Zw6eJhxVIB2w43l
         2nLFx6BZUw4Flf39Sn6vqBQ5v6iXD2kAGyxYxqRc7YjRn85zhcFMj87EbnED81qHqguB
         jgDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=imSoyKTeUR+bgnKkHR56BAV9e5dhaT/9hmoW62kZVKY=;
        b=NlxvdoIGeFaUUnDEfkUCl10tB2md6TnLU+q1nVgmZzsi06aZfTG9XIOLKTMKY9glDM
         2akLCqZJ0srVGc3/TuJyJRga7qfYVc1ymWumOOxntVSXf8351ziJCOzhbvTTLGK7g4cE
         WFKeabtUos1N0J90AvvjrV5Rmv11aaixdnEu1/O5hT9XruDKgJhjyqAh4DnFeEaVYRRO
         D8bCUpsTbYrBakV85q6YdmLOQRGfdd2fLP42W70FeqwZhCRhNFS5wH6gFWqFSPLkiBtG
         wHhV0KvtIg0aZq5xlgkmU2pGGwNPWVeiOT7nS6s714tUAcH8Jjp/D7k48ojiJHv/42XT
         mfng==
X-Gm-Message-State: AOAM5328gwVs9m0pxkI+zyoSNPc18F12a4okm/Mm0Cat8hFe9BtwQB/r
        DsgkxC7vLXK9EodULkwvaXIquQ==
X-Google-Smtp-Source: ABdhPJxRkUmCOkTUKPlXtwFJ6aCJutXEU7oa5lp1sRclt4li858xphe+DzyINcp7sGvGXfnjcMNT5A==
X-Received: by 2002:a63:450e:: with SMTP id s14mr11676887pga.252.1629040344381;
        Sun, 15 Aug 2021 08:12:24 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id gl12sm3853584pjb.40.2021.08.15.08.12.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 15 Aug 2021 08:12:24 -0700 (PDT)
Subject: Re: [PATCH v2 0/4] open/accept directly into io_uring fixed file
 table
From:   Jens Axboe <axboe@kernel.dk>
To:     Josh Triplett <josh@joshtriplett.org>
Cc:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Stefan Metzmacher <metze@samba.org>
References: <cover.1628871893.git.asml.silence@gmail.com>
 <YRbBYCn29B+kgZcy@localhost> <bcb6f253-41d6-6e0f-5b4b-ea1e02a105bc@gmail.com>
 <5cf40313-d151-9d10-3ebd-967eb2f53b1f@kernel.dk> <YRiNGTL2Dp/7vNzt@localhost>
 <a2bd1600-5649-c4be-d2a9-79c89bae774a@kernel.dk>
Message-ID: <e404f278-bfca-0cff-92b7-6d4cdc93ff60@kernel.dk>
Date:   Sun, 15 Aug 2021 09:12:19 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <a2bd1600-5649-c4be-d2a9-79c89bae774a@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/15/21 9:05 AM, Jens Axboe wrote:
> On 8/14/21 9:42 PM, Josh Triplett wrote:
>> On Sat, Aug 14, 2021 at 05:03:44PM -0600, Jens Axboe wrote:
>>> What's the plan in terms of limiting the amount of direct descriptors
>>> (for lack of a better word)? That seems like an important aspect that
>>> should get sorted out upfront.
>> [...]
>>> Maybe we have a way to size the direct table, which will consume entries
>>> from the same pool that the regular file table does? That would then
>>> work both ways, and could potentially just be done dynamically similarly
>>> to how we expand the regular file table when we exceed its current size.
>>
>> I think we'll want a way to size the direct table regardless, so that
>> it's pre-allocated and doesn't need to be resized when an index is used.
> 
> But how do you size it then? I can see this being used into the hundreds
> of thousands of fds easily, and right now the table is just an array
> (though split into segments, avoiding huge allocs).

I guess that will just naturally follow by registering the empty set of
a given size initially. So should not actually be a problem...

-- 
Jens Axboe

