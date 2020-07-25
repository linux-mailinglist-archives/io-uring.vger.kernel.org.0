Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBCCE22D87F
	for <lists+io-uring@lfdr.de>; Sat, 25 Jul 2020 17:45:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726842AbgGYPpv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 25 Jul 2020 11:45:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726694AbgGYPpv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 25 Jul 2020 11:45:51 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67265C08C5C0
        for <io-uring@vger.kernel.org>; Sat, 25 Jul 2020 08:45:51 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id mn17so6895863pjb.4
        for <io-uring@vger.kernel.org>; Sat, 25 Jul 2020 08:45:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=apI2WcJ3cP5FsW9oyoPGDSlj3mRPg7fg8dqub0Wmbo4=;
        b=v4icdX9kWxOZeUO5ELZ1K73Z9LAbBLKvy4/zy1iCOp4KWy3nECABg9CclsI0VZxFAK
         uQWtGoeokU9MYoGfPjRZoJX7tnehinFZzAcq6z70B4M15PQOZl1uNXGzHFXm9zwBu8OT
         chhRWn6cZfbWTkEPWEyJopF3QVpu8fkHeH1cy1Dh0wFgo7qZYCFGPDGAMMpx9P0dz0XB
         3T6paT/LNEO3RtpdxIWMyfiw6sTZ6x+HStlNnp8SJ4lmGwPwpzCOjf1ZJjN8+iUSuviP
         4ou/XTWhJtKrnlCGvwUqdQJYMQYYZmThambposi4P5bLqJBPANBb4N0ZtPgspLV8Ul+8
         Q/uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=apI2WcJ3cP5FsW9oyoPGDSlj3mRPg7fg8dqub0Wmbo4=;
        b=EvTf6hH+/RO50EJz8V8d2EfxPyn9TXz2WEH+gukldC5BDl1bG2SxIL863IQySWlMW8
         ypJ7DSHih2MldFR6oJ6NdXECHh2H2IrunF22QEWu9YbKsCOzIjk34Ij78V2+5FD3QRIy
         UglEGmqX2iYwyoKSx3byqe2xMsD/uNvI7fZqvY0zrGAAsGHIdqLdpG8TSr91P9mhPu/m
         CfW/mKymxVqx2YiKGMUEi/JeBC5OG7mO6R9Fd2F5hgS+S2MFlq+5mzhFCk1WTeHYAUmx
         NRxTWoFelGKNmIjkFyW10/sQ28gaBZzz4Cqrw/OW78tidASLsaEOBA+z1+F5uC+GFUZH
         SfOg==
X-Gm-Message-State: AOAM531mTvuBBmq/IFzNq24mcAtqOX+F3lWYlAnl6RPEjP1f5bgKpQom
        NV5JRkwqLMFuXLve4LZLBs1nZktIobY=
X-Google-Smtp-Source: ABdhPJw7irQXosYQpbdoOjsdcMFcX+/M//ckPmTpEhQ0NIAAXHBXef4q8EAB0+2KRghkuZH2xiRhzA==
X-Received: by 2002:a17:902:c3ca:: with SMTP id j10mr13133835plj.171.1595691950293;
        Sat, 25 Jul 2020 08:45:50 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id kx3sm8912952pjb.32.2020.07.25.08.45.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 25 Jul 2020 08:45:49 -0700 (PDT)
Subject: Re: [RFC 0/2] 3 cacheline io_kiocb
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1595664743.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <467e93fb-876d-e2a5-7596-4b9e21317d67@kernel.dk>
Date:   Sat, 25 Jul 2020 09:45:48 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <cover.1595664743.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/25/20 2:31 AM, Pavel Begunkov wrote:
> That's not final for a several reasons, but good enough for discussion.
> That brings io_kiocb down to 192B. I didn't try to benchmark it
> properly, but quick nop test gave +5% throughput increase.
> 7531 vs 7910 KIOPS with fio/t/io_uring
> 
> The whole situation is obviously a bunch of tradeoffs. For instance,
> instead of shrinking it, we can inline apoll to speed apoll path.
> 
> [2/2] just for a reference, I'm thinking about other ways to shrink it.
> e.g. ->link_list can be a single-linked list with linked tiemouts
> storing a back-reference. This can turn out to be better, because
> that would move ->fixed_file_refs to the 2nd cacheline, so we won't
> ever touch 3rd cacheline in the submission path.
> Any other ideas?

Nothing noticeable for me, still about the same performance. But
generally speaking, I don't necessarily think we need to go all in on
making this as tiny as possible. It's much more important to chase the
items where we only use 2 cachelines for the hot path, and then we have
the extra space in there already for the semi hot paths like poll driven
retry. Yes, we're still allocating from a pool that has slightly larger
objects, but that doesn't really matter _that_ much. Avoiding an extra
kmalloc+kfree for the semi hot paths are a bigger deal than making
io_kiocb smaller and smaller.

That said, for no-brainer changes, we absolutely should make it smaller.
I just don't want to jump through convoluted hoops to get there.

-- 
Jens Axboe

