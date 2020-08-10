Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BC75241224
	for <lists+io-uring@lfdr.de>; Mon, 10 Aug 2020 23:12:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726624AbgHJVMR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 10 Aug 2020 17:12:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726547AbgHJVMQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 10 Aug 2020 17:12:16 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC5FCC061756
        for <io-uring@vger.kernel.org>; Mon, 10 Aug 2020 14:12:15 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id t6so737702pjr.0
        for <io-uring@vger.kernel.org>; Mon, 10 Aug 2020 14:12:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=AbNBmcp1K7PMfQnc36EotnyXIaCaiHUPC2Cc3sT2YK0=;
        b=pCbeXqODbxKn5rSnm1+OS3rsR6R1jky67I96zIy2CSpvMX3isCI8Rv3LPnJC+sBqc2
         Nig6XwUfcsqcgg0SJnl2FDCYT9Sz5fAu80BN02YQ+v4+zYvklPvOmHfGreu8m8iwgBtL
         5MDZzCqLbg0Vf0xwxL7lzXHEP4+xOJ4NVyzJTDdCmW840yk4hxvhwQPz+nWWCfdlpSfP
         4/DsfMWmhcJTGbZOrhp0nzY78zcY2B+hzBEA+VDCmBUzIx0D3y1yG2vuK+1e3iOKwW/u
         B7y4f+GHhZC2LSPe1YT/00cvdSYu53vsocmf4yImh/xGgjMMw7mw4YYMBMvIml330bMU
         YhSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=AbNBmcp1K7PMfQnc36EotnyXIaCaiHUPC2Cc3sT2YK0=;
        b=hY0yfFTky+ziotGU+9N1GpXeroRBdiYuvAIZEBiPJthSLSGY/ak7dF+FX2Kn9lD8Zg
         NnWYBK512MomIEUCfYA90xnK/RkwzG5JeGX9extAGievjLjRaiBRz5Dk4ixsyfX+yQVL
         aFl78XvG4C0sEfgoDy3AjHnIgJytlH/GSOxKJ23U4KYbI9NvdRWlab6NEsm/XFmdFZc6
         EBuZcbjAZlKIBTS7LSE4zojqhaygr9B5lH0f7hD9wGB+0GaQLgfaT4PLzwAlY++tRH9n
         nW4RsejddY7UT8FBqYOstpjg7anglgrLmxA2iLhSs7/0WNYkWCKUGoergVYjqDGztpOl
         me+Q==
X-Gm-Message-State: AOAM533eanLlwhDP7P33DTYM0J8/RKSmgmcwrPdv0TRtvqsUzXhBQBpe
        9vKibd4kglq4gYxOCB7GoYlx2w==
X-Google-Smtp-Source: ABdhPJymGWLKlQGYxYeUiMPxprc3H/otdXQsiwITrAfpxopKY0DjNb3C/Dw6dn2vmSSfcfPi3VTbLQ==
X-Received: by 2002:a17:902:d3c6:: with SMTP id w6mr23615228plb.209.1597093935409;
        Mon, 10 Aug 2020 14:12:15 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id c192sm23216743pfc.154.2020.08.10.14.12.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Aug 2020 14:12:14 -0700 (PDT)
Subject: Re: [PATCH 2/2] io_uring: use TWA_SIGNAL for task_work if the task
 isn't running
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Jann Horn <jannh@google.com>, io-uring <io-uring@vger.kernel.org>,
        stable <stable@vger.kernel.org>, Josef <josef.grieb@gmail.com>,
        Oleg Nesterov <oleg@redhat.com>
References: <20200808183439.342243-1-axboe@kernel.dk>
 <20200808183439.342243-3-axboe@kernel.dk>
 <20200810114256.GS2674@hirez.programming.kicks-ass.net>
 <a6ee0a6d-5136-4fe9-8906-04fe6420aad9@kernel.dk>
 <07df8ab4-16a8-8537-b4fe-5438bd8110cf@kernel.dk>
 <20200810201213.GB3982@worktop.programming.kicks-ass.net>
 <4a8fa719-330f-d380-522f-15d79c74ca9a@kernel.dk>
 <faf2c2ae-834e-8fa2-12f3-ae07f8a68e14@kernel.dk>
 <CAG48ez0+=+Q0tjdFxjbbZbZJNkimYL9Bd5odr0T9oWwty6qgoQ@mail.gmail.com>
 <03c0e282-5317-ea45-8760-2c3f56eec0c0@kernel.dk>
 <20200810211057.GG3982@worktop.programming.kicks-ass.net>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <5628f79b-6bfb-b054-742a-282663cb2565@kernel.dk>
Date:   Mon, 10 Aug 2020 15:12:13 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200810211057.GG3982@worktop.programming.kicks-ass.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/10/20 3:10 PM, Peter Zijlstra wrote:
> On Mon, Aug 10, 2020 at 03:06:49PM -0600, Jens Axboe wrote:
> 
>> should work as far as I can tell, but I don't even know if there's a
>> reliable way to do task_in_kernel().
> 
> Only on NOHZ_FULL, and tracking that is one of the things that makes it
> so horribly expensive.

Probably no other way than to bite the bullet and just use TWA_SIGNAL
unconditionally...

-- 
Jens Axboe

