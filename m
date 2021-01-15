Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8C852F883B
	for <lists+io-uring@lfdr.de>; Fri, 15 Jan 2021 23:16:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726661AbhAOWQF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 15 Jan 2021 17:16:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725863AbhAOWQF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 15 Jan 2021 17:16:05 -0500
Received: from mail-qk1-x72c.google.com (mail-qk1-x72c.google.com [IPv6:2607:f8b0:4864:20::72c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1CC0C0613D3
        for <io-uring@vger.kernel.org>; Fri, 15 Jan 2021 14:15:24 -0800 (PST)
Received: by mail-qk1-x72c.google.com with SMTP id 22so13263861qkf.9
        for <io-uring@vger.kernel.org>; Fri, 15 Jan 2021 14:15:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=pKl6FjvGj9H225+WOwUkpj4FU5eGrAp3ZziPiBP9G2M=;
        b=PBW003QCtw2a0XLKCcwx820aT3y3KtruvpUrjM+B2nZ16CLAU6wlKeabigopSKfyAm
         MFI6CxOXnrS0EWawAKiwsGUcr9IXfEz0Zj8KagGl79nJBh13plHFOsaZKir7YI1iJsPS
         lKmUVijKV6B184ODxY8d6sy83vkK0cRU2hVdkQ4mVdYR4kXCxL3eU0tXUWk+HZuvMAyf
         VrLfZ9Vz1Sczrnf97dYJUzVTw7z0slQSFU+iO2KBpghqShUBFfN0VHlqXs8b2cWD5pbU
         GSmPBQAYK+6zEJf1DMB8KiSl2jpRPnyAQs4290Oq1nq4bJ7FQ3ClvsYXpCMKplExFhUt
         qutA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=pKl6FjvGj9H225+WOwUkpj4FU5eGrAp3ZziPiBP9G2M=;
        b=aE+Wn6w4Wt+xtPTGnus2JEqsdnC+fzBl1Pspy9tJTLxliVxMJ4lkYuCTyLLRYtwmff
         ZKXRqBIB9inzkJsOm0Oo4Owup/ruq2s5KqgfsE39NiXUZXaSkvI5+16od0goO+8ubBlK
         M9o/rZ29coHofb1oTGrRAG8xYazSpSkI/qcbYvjkgCA6xJwQec6wOJmjj49YJsdpLPqc
         U2Eblzh2nsGZgAN5d7PoNtX2yD5FozzHaqTJWhkmBchmb8B3vVHIrXpT9LVnYOnMBzw3
         8spSpDY7DDZtD5Ryd2T6oa3UzVFUs3WYiCisdtfkex7v8rqwS9kYSsMy845IHP8eNR6x
         2k9A==
X-Gm-Message-State: AOAM533NZ3pb6Sb1Mvx23yNdQU+0N3YjNg42ap9AMj8Nt+z6an0F0xTo
        FUAF+ks789IoqjLOShdbRu4=
X-Google-Smtp-Source: ABdhPJzY3CCmKdacQNl3I3Lc3/bTJO1VHvVAcZRh4/8LBnP+ws/WCxTYXnt1bKKOHb6Jvt0mgadVZg==
X-Received: by 2002:a37:b404:: with SMTP id d4mr14345272qkf.183.1610748924240;
        Fri, 15 Jan 2021 14:15:24 -0800 (PST)
Received: from marcelo-debian.domain (cpe-184-152-69-119.nyc.res.rr.com. [184.152.69.119])
        by smtp.gmail.com with ESMTPSA id k64sm6016981qkc.110.2021.01.15.14.15.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jan 2021 14:15:23 -0800 (PST)
Date:   Fri, 15 Jan 2021 17:15:21 -0500
From:   Marcelo Diop-Gonzalez <marcelo827@gmail.com>
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: Re: [PATCH v4 0/1] io_uring: fix skipping of old timeout events
Message-ID: <20210115221521.GA21646@marcelo-debian.domain>
References: <20210115165440.12170-1-marcelo827@gmail.com>
 <7b70938a-3726-ccc0-049d-4a617c9d2298@kernel.dk>
 <20210115183148.GA14438@marcelo-debian.domain>
 <3da76f2e-4941-206d-8881-9452bfce5980@kernel.dk>
 <4cb8b3aa-9759-35f6-863f-99ecf2ec9b32@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4cb8b3aa-9759-35f6-863f-99ecf2ec9b32@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Jan 15, 2021 at 06:48:58PM +0000, Pavel Begunkov wrote:
> On 15/01/2021 18:38, Jens Axboe wrote:
> > On 1/15/21 11:31 AM, Marcelo Diop-Gonzalez wrote:
> >> On Fri, Jan 15, 2021 at 10:02:12AM -0700, Jens Axboe wrote:
> >>> On 1/15/21 9:54 AM, Marcelo Diop-Gonzalez wrote:
> >>>> This patch tries to fix a problem with IORING_OP_TIMEOUT events
> >>>> not being flushed if they should already have expired. The test below
> >>>> hangs before this change (unless you run with $ ./a.out ~/somefile 1):
> >>>
> >>> Can you turn this into a test case for liburing? I'll apply the
> >>> associated patch, thanks (and to Pavel for review as well).
> >>
> >> Yup, can do. I'll try to clean it up some first (especially so it
> >> doesn't just hang when it fails :/)
> > 
> > That'd of course be nice, but not a hard requirement. A lot of the
> > regressions tests will crash a broken kernel, so...
> 
> Ha, they definitely will. 
> 
> Marcelo, replacing reads with nop requests should trigger it as well,
> it's probably easier and even more reliable as we always complete
> them inline (if not linked or IOSQE_ASYNC).

Oh good idea, yeah that's better for sure. Didn't even know that existed :D

> 
> -- 
> Pavel Begunkov
