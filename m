Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9547550ADC
	for <lists+io-uring@lfdr.de>; Sun, 19 Jun 2022 15:30:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236353AbiFSNaS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 19 Jun 2022 09:30:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236209AbiFSNaR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 19 Jun 2022 09:30:17 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95EBDBC2A
        for <io-uring@vger.kernel.org>; Sun, 19 Jun 2022 06:30:15 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id f16so6634602pjj.1
        for <io-uring@vger.kernel.org>; Sun, 19 Jun 2022 06:30:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=qsWJveRVJ+rzEF3S6gtML0ueB6DztLzZjfV5He5GAAc=;
        b=fh0ojCfTstPtefu0P/T3oYVz2MVHR1HS2BBLKK5OuKfLnZB2DQIvHI9o5oZ/EJPbdB
         ZwKn2EQEDQaJYG93vj00+/caSlgscWj1rV6V2JAbsA5tvruV6tu8wsY7x3qV0/gLyslJ
         4VR2uQguqtuXRZxKNWsOwIA5ykf+D3C4XUqC46gRk+rtR7PflVFk3TbKMEz58z5ogPVi
         7ugZGIOcy/EVYQD0oYKqyPTa6wXu58bCBcpxrUCUSf2k6bnfcOAFmapYc3m8TDTVBxnR
         8UBJ+v4NQvVdTw7zEGU4ObRdDHjAEUEmcfJlzkbVD0xeoUeDAC0Ck/OA8B5gevphl0Jd
         FRmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=qsWJveRVJ+rzEF3S6gtML0ueB6DztLzZjfV5He5GAAc=;
        b=25nCzj00rRR2T/bTBtxbDUZrhjq2d81i4xjioQUo8e/X3CDVLGbVbK8xE2wVn7Scjh
         Nzfekzq1bBleGEjqwAx1wderB1EQvd/3Op4/O4GdQVlvwx/7XHEHjeB3fUg+D0NY8Omv
         dYNLjJDg45jOcevC3I9vxlvnFr5jMZcybIsNrhaOniZE1cF2lUkX3w+Hn3oFZ/GzebuN
         /Ye+A3q0zeGiQTCqK14XNWrhoql5BA1ablwPtRAzuj37u09bT1zS9+lj/Tnos2S2L+ga
         Nn0B4HhAvrPt+ePFxy8DtXGlKlZNUmEqQiodNHb5KehJ6Kr5EzUt0qYWYpgZa1ly5XY6
         5hRw==
X-Gm-Message-State: AJIora/W4TQAacgF8s9+KmfRRQex7YagdLemaD1qodG6GfHYFL52xpOm
        JfwnnsEwgRefRF+XKGJXFAOsKg==
X-Google-Smtp-Source: AGRyM1u1FyF5W0YzzAi9oFOFOYDuooDUFNv54uZQ1DeF6x0RZLpaNiw3eDq+oKTa0xri4aZddy7PHg==
X-Received: by 2002:a17:90b:2688:b0:1ec:8d19:1da5 with SMTP id pl8-20020a17090b268800b001ec8d191da5mr7342595pjb.114.1655645415043;
        Sun, 19 Jun 2022 06:30:15 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id m9-20020a170902768900b00163ffe73300sm6791138pll.137.2022.06.19.06.30.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 19 Jun 2022 06:30:14 -0700 (PDT)
Message-ID: <91584f2b-f7bb-ec20-8b27-62451e2b19e0@kernel.dk>
Date:   Sun, 19 Jun 2022 07:30:13 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH for-next 6/7] io_uring: introduce locking helpers for CQE
 posting
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1655637157.git.asml.silence@gmail.com>
 <693e461561af1ce9ccacfee9c28ff0c54e31e84f.1655637157.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <693e461561af1ce9ccacfee9c28ff0c54e31e84f.1655637157.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/19/22 5:26 AM, Pavel Begunkov wrote:
> spin_lock(&ctx->completion_lock);
> /* post CQEs */
> io_commit_cqring(ctx);
> spin_unlock(&ctx->completion_lock);
> io_cqring_ev_posted(ctx);
> 
> We have many places repeating this sequence, and the three function
> unlock section is not perfect from the maintainance perspective and also
> makes harder to add new locking/sync trick.
> 
> Introduce to helpers. io_cq_lock(), which is simple and only grabs
> ->completion_lock, and io_cq_unlock_post() encapsulating the three call
> section.

I'm a bit split on this one, since I generally hate helpers that are
just wrapping something trivial:

static inline void io_cq_lock(struct io_ring_ctx *ctx)
	__acquires(ctx->completion_lock)
{
	spin_lock(&ctx->completion_lock);
}

The problem imho is that when I see spin_lock(ctx->lock) in the code I
know exactly what it does, if I see io_cq_lock(ctx) I have a good guess,
but I don't know for a fact until I become familiar with that new
helper.

I can see why you're doing it as it gives us symmetry with the unlock
helper, which does indeed make more sense. But I do wonder if we
shouldn't just keep the spin_lock() part the same, and just have the
unlock helper?

-- 
Jens Axboe

