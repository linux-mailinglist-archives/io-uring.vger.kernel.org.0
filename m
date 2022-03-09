Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2B244D25DE
	for <lists+io-uring@lfdr.de>; Wed,  9 Mar 2022 02:14:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229985AbiCIBMS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 8 Mar 2022 20:12:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229943AbiCIBL5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 8 Mar 2022 20:11:57 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AA831520C2
        for <io-uring@vger.kernel.org>; Tue,  8 Mar 2022 16:54:26 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id z3so595520plg.8
        for <io-uring@vger.kernel.org>; Tue, 08 Mar 2022 16:54:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=X+hIDIVjHO6LGkXM0+QFRkB6SfIRAAsbD4jjzcc0akc=;
        b=DDNhbec9n4vDtcJL0BuO5eDb4cSkBGYrG5wwTwBFdKoL3n7ATvS1gb9+pcW0/dgDyl
         1d5Eh5tWzWbqZ+YjeVPpTKuxf/5qjL4oWq4uEv36HaxfohGIp8IFme7cWfH1NZ5j0xZo
         mBY0DHOFIWvlWl0EyDqb1kwWI22bie6Z1TFkKYZPebyMplA2NUZ7he/CcgSSIiqU57H0
         MIx0rfYifHtmC3aeq5BB9Mf/u076cPuQ5ZnEKtAWTIIVA4/1LHQd6or6ubiglOCD7tsv
         PHUQfXr+CCSNx/A5qtcbpIfko/s8hNGnj5HpzhBdr7edSqjMrpIyE93p9JARTXREs34x
         /i4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=X+hIDIVjHO6LGkXM0+QFRkB6SfIRAAsbD4jjzcc0akc=;
        b=WIYxJhzI4VEN5cII8ShmsQNk5+N9ROFkdNWbQu2scmGvcpZb0tdYR3BXvzBR8b8lFY
         NGJ7wCHJL9jiweM9oL4VjZuUaPkha8hAcr5xg0aJ+wtCeAXV7Lc4E468pGX1W89g/ND/
         Ro5tQ5okMVBv9mzdk+ZF5XFHI01V18JPIk2yANYTHlaBqUz7gHr7WQCIQ+nVgZUfV/fR
         02t7b0YGpWAhsp+etIz7ph3lXLbLh8iuBsnnIdCy+XwLtEDxR5IrWbm48ZukEg0OuCvB
         OUXMCGi5AJuPj1pyE/AR2uCTf5pgYjIEt8XoVo4hbHZUJyChnuoCY830pWt5kkyBeuiZ
         4LbA==
X-Gm-Message-State: AOAM5335tOmndQKUqHNcDqKHpwJWF3/7Y333+28fVONsn/vgmh3deOfs
        XLbPtRwdTz292cdn0RVOCge3ZQ==
X-Google-Smtp-Source: ABdhPJwetVnpbxsnEbhw3gNfTZ6thnsFgnw08XA0JyAYgma9/do5dC/G+QLHFJ7fHLOHafD2zOFZsg==
X-Received: by 2002:a17:90a:19d5:b0:1bc:a5db:b655 with SMTP id 21-20020a17090a19d500b001bca5dbb655mr7774866pjj.46.1646787265178;
        Tue, 08 Mar 2022 16:54:25 -0800 (PST)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id e16-20020a17090a119000b001bfa3a0d21asm281656pja.40.2022.03.08.16.54.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Mar 2022 16:54:24 -0800 (PST)
Message-ID: <612546a3-5630-f1d4-f455-ef2bf564c83e@kernel.dk>
Date:   Tue, 8 Mar 2022 17:54:23 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH v5 0/2] io_uring: Add support for napi_busy_poll
Content-Language: en-US
To:     Olivier Langlois <olivier@trillion01.com>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     Hao Xu <haoxu@linux.alibaba.com>,
        io-uring <io-uring@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
References: <cover.1646777484.git.olivier@trillion01.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <cover.1646777484.git.olivier@trillion01.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/8/22 3:17 PM, Olivier Langlois wrote:
> The sqpoll thread can be used for performing the napi busy poll in a
> similar way that it does io polling for file systems supporting direct
> access bypassing the page cache.
> 
> The other way that io_uring can be used for napi busy poll is by
> calling io_uring_enter() to get events.
> 
> If the user specify a timeout value, it is distributed between polling
> and sleeping by using the systemwide setting
> /proc/sys/net/core/busy_poll.

I think we should get this queued up, but it doesn't apply to
for-5.18/io_uring at all. I can fix it up, but just curious what you
tested against?

-- 
Jens Axboe

