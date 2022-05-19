Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DDC952CF58
	for <lists+io-uring@lfdr.de>; Thu, 19 May 2022 11:27:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236101AbiESJ0c (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 19 May 2022 05:26:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236097AbiESJ0R (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 19 May 2022 05:26:17 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E657258E60
        for <io-uring@vger.kernel.org>; Thu, 19 May 2022 02:26:14 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id t6so6272814wra.4
        for <io-uring@vger.kernel.org>; Thu, 19 May 2022 02:26:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=U7CWZtaUgg241mV7Lt3xruBxG2pYUXKmRKpcYqgh8Eg=;
        b=PYGkNhuK5Y+VcRxXPEdPFo186tRGpytygwARJKMCJCuk1FziFrVCP7xR5sQnGXSieB
         mIoebzr9mrYJB764qpt5v/nmO8uasR45/gruqJwN3B0SRu7NLyiVE0Gbm85QkvQzO0G4
         oNpScDJE7i2dFgmQPo4csIWgV6yf2HUT3GEZBGyapklrVGuCjt6xvyPufVGJh4c7Lekl
         EiJ99vr+pSgYTsOovJ8NhCM19wm/qsi82LdKBrWLTigt1sWGfz541+KsP11DvakTCDjW
         FsP1QEuAxDKYIoRLznW/9BpVCGPCRCQsitqpb/4n4nXT7h0hJXnVmA7P5/v2Uht64UY/
         OCgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=U7CWZtaUgg241mV7Lt3xruBxG2pYUXKmRKpcYqgh8Eg=;
        b=dK2HocGmp1nR7whX1iUi3XDFKy0Gx9T5p0bDDbrg5a/wApqCTu6dV+WHmYhfTu8P9r
         YIm1fvTK2qinv/Bco6jCffK7maAioBNGWzm7sHCzPQoASewGi2Yd4nf8BYN9l/LXVo3J
         ENzsK5aNiGgMwV3SpjYZxf9lkJbH0C7NPM+dB+n6wnjX1nGtXQdIsyP3OzXqz0fW30kU
         Im15faH3eW132U9HmJlZrlWsyyz18X8E41uMr0FNzbz9STd0G1zxmgkkKvrdp81U+Z89
         YUMaW8In4/q+gOzOBW8MRNANTFDiQJP6Pj+PxJttnThu3PkFo/92ohPggExcgJXTkT3/
         v6Gw==
X-Gm-Message-State: AOAM531ABffn/IlsKbayoHRk5L8g3g/6gNdJnQ8+1uCCdVvOjxnkm4Gy
        hc9eo9HIkteIjt9X7NbArx60vw==
X-Google-Smtp-Source: ABdhPJzpigCJ9ZTp35pQMOpSOXDBsHMK2phsvkqXJ9XlfwaT3joEX6NUk0vE/CQ9X3XqRok3v0nKMg==
X-Received: by 2002:a05:6000:38b:b0:20c:53af:747d with SMTP id u11-20020a056000038b00b0020c53af747dmr3038647wrf.22.1652952373417;
        Thu, 19 May 2022 02:26:13 -0700 (PDT)
Received: from google.com (cpc155339-bagu17-2-0-cust87.1-3.cable.virginm.net. [86.27.177.88])
        by smtp.gmail.com with ESMTPSA id b5-20020a05600c4e0500b00397243d3dbcsm2592590wmq.31.2022.05.19.02.26.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 May 2022 02:26:13 -0700 (PDT)
Date:   Thu, 19 May 2022 10:26:11 +0100
From:   Lee Jones <lee.jones@linaro.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [REPORT] Use-after-free Read in __fdget_raw in v5.10.y
Message-ID: <YoYNM0eQPBSUietG@google.com>
References: <YoTrmjuct3ctvFim@google.com>
 <b7dc2992-e2d6-8e76-f089-b33561f8471f@kernel.dk>
 <f821d544-78d5-a227-1370-b5f0895fb184@kernel.dk>
 <06710b30-fec8-b593-3af4-1318515b41d8@kernel.dk>
 <YoUNQlzU0W4ShA85@google.com>
 <49609b89-f2f0-44b3-d732-dfcb4f73cee1@kernel.dk>
 <YoUTPIVOhLlnIO04@google.com>
 <1e64d20a-42cc-31cd-0fd8-2718dd8b1f31@kernel.dk>
 <YoUgHjHn+UFvj0o1@google.com>
 <38f63cda-b208-0d83-6aec-25115bd1c021@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <38f63cda-b208-0d83-6aec-25115bd1c021@kernel.dk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, 18 May 2022, Jens Axboe wrote:

> On 5/18/22 10:34 AM, Lee Jones wrote:
> > On Wed, 18 May 2022, Jens Axboe wrote:
> > 
> >> On 5/18/22 09:39, Lee Jones wrote:
> >>> On Wed, 18 May 2022, Jens Axboe wrote:
> >>>
> >>>> On 5/18/22 9:14 AM, Lee Jones wrote:
> >>>>> On Wed, 18 May 2022, Jens Axboe wrote:
> >>>>>
> >>>>>> On 5/18/22 6:54 AM, Jens Axboe wrote:
> >>>>>>> On 5/18/22 6:52 AM, Jens Axboe wrote:
> >>>>>>>> On 5/18/22 6:50 AM, Lee Jones wrote:
> >>>>>>>>> On Tue, 17 May 2022, Jens Axboe wrote:
> >>>>>>>>>
> >>>>>>>>>> On 5/17/22 7:00 AM, Lee Jones wrote:
> >>>>>>>>>>> On Tue, 17 May 2022, Jens Axboe wrote:
> >>>>>>>>>>>
> >>>>>>>>>>>> On 5/17/22 6:36 AM, Lee Jones wrote:
> >>>>>>>>>>>>> On Tue, 17 May 2022, Jens Axboe wrote:
> >>>>>>>>>>>>>
> >>>>>>>>>>>>>> On 5/17/22 6:24 AM, Lee Jones wrote:
> >>>>>>>>>>>>>>> On Tue, 17 May 2022, Jens Axboe wrote:
> >>>>>>>>>>>>>>>
> >>>>>>>>>>>>>>>> On 5/17/22 5:41 AM, Lee Jones wrote:
> >>>>>>>>>>>>>>>>> Good afternoon Jens, Pavel, et al.,
> >>>>>>>>>>>>>>>>>
> >>>>>>>>>>>>>>>>> Not sure if you are presently aware, but there appears to be a
> >>>>>>>>>>>>>>>>> use-after-free issue affecting the io_uring worker driver (fs/io-wq.c)
> >>>>>>>>>>>>>>>>> in Stable v5.10.y.
> >>>>>>>>>>>>>>>>>
> >>>>>>>>>>>>>>>>> The full sysbot report can be seen below [0].
> >>>>>>>>>>>>>>>>>
> >>>>>>>>>>>>>>>>> The C-reproducer has been placed below that [1].
> >>>>>>>>>>>>>>>>>
> >>>>>>>>>>>>>>>>> I had great success running this reproducer in an infinite loop.
> >>>>>>>>>>>>>>>>>
> >>>>>>>>>>>>>>>>> My colleague reverse-bisected the fixing commit to:
> >>>>>>>>>>>>>>>>>
> >>>>>>>>>>>>>>>>>   commit fb3a1f6c745ccd896afadf6e2d6f073e871d38ba
> >>>>>>>>>>>>>>>>>   Author: Jens Axboe <axboe@kernel.dk>
> >>>>>>>>>>>>>>>>>   Date:   Fri Feb 26 09:47:20 2021 -0700
> >>>>>>>>>>>>>>>>>
> >>>>>>>>>>>>>>>>>        io-wq: have manager wait for all workers to exit
> >>>>>>>>>>>>>>>>>
> >>>>>>>>>>>>>>>>>        Instead of having to wait separately on workers and manager, just have
> >>>>>>>>>>>>>>>>>        the manager wait on the workers. We use an atomic_t for the reference
> >>>>>>>>>>>>>>>>>        here, as we need to start at 0 and allow increment from that. Since the
> >>>>>>>>>>>>>>>>>        number of workers is naturally capped by the allowed nr of processes,
> >>>>>>>>>>>>>>>>>        and that uses an int, there is no risk of overflow.
> >>>>>>>>>>>>>>>>>
> >>>>>>>>>>>>>>>>>        Signed-off-by: Jens Axboe <axboe@kernel.dk>
> >>>>>>>>>>>>>>>>>
> >>>>>>>>>>>>>>>>>     fs/io-wq.c | 30 ++++++++++++++++++++++--------
> >>>>>>>>>>>>>>>>>     1 file changed, 22 insertions(+), 8 deletions(-)
> >>>>>>>>>>>>>>>>
> >>>>>>>>>>>>>>>> Does this fix it:
> >>>>>>>>>>>>>>>>
> >>>>>>>>>>>>>>>> commit 886d0137f104a440d9dfa1d16efc1db06c9a2c02
> >>>>>>>>>>>>>>>> Author: Jens Axboe <axboe@kernel.dk>
> >>>>>>>>>>>>>>>> Date:   Fri Mar 5 12:59:30 2021 -0700
> >>>>>>>>>>>>>>>>
> >>>>>>>>>>>>>>>>     io-wq: fix race in freeing 'wq' and worker access
> >>>>>>>>>>>>>>>>
> >>>>>>>>>>>>>>>> Looks like it didn't make it into 5.10-stable, but we can certainly
> >>>>>>>>>>>>>>>> rectify that.
> >>>>>>>>>>>>>>>
> >>>>>>>>>>>>>>> Thanks for your quick response Jens.
> >>>>>>>>>>>>>>>
> >>>>>>>>>>>>>>> This patch doesn't apply cleanly to v5.10.y.
> >>>>>>>>>>>>>>
> >>>>>>>>>>>>>> This is probably why it never made it into 5.10-stable :-/
> >>>>>>>>>>>>>
> >>>>>>>>>>>>> Right.  It doesn't apply at all unfortunately.
> >>>>>>>>>>>>>
> >>>>>>>>>>>>>>> I'll have a go at back-porting it.  Please bear with me.
> >>>>>>>>>>>>>>
> >>>>>>>>>>>>>> Let me know if you into issues with that and I can help out.
> >>>>>>>>>>>>>
> >>>>>>>>>>>>> I think the dependency list is too big.
> >>>>>>>>>>>>>
> >>>>>>>>>>>>> Too much has changed that was never back-ported.
> >>>>>>>>>>>>>
> >>>>>>>>>>>>> Actually the list of patches pertaining to fs/io-wq.c alone isn't so
> >>>>>>>>>>>>> bad, I did start to back-port them all but some of the big ones have
> >>>>>>>>>>>>> fs/io_uring.c changes incorporated and that list is huge (256 patches
> >>>>>>>>>>>>> from v5.10 to the fixing patch mentioned above).
> >>>>>>>>>>>>
> >>>>>>>>>>>> The problem is that 5.12 went to the new worker setup, and this patch
> >>>>>>>>>>>> landed after that even though it also applies to the pre-native workers.
> >>>>>>>>>>>> Hence the dependency chain isn't really as long as it seems, probably
> >>>>>>>>>>>> just a few patches backporting the change references and completions.
> >>>>>>>>>>>>
> >>>>>>>>>>>> I'll take a look this afternoon.
> >>>>>>>>>>>
> >>>>>>>>>>> Thanks Jens.  I really appreciate it.
> >>>>>>>>>>
> >>>>>>>>>> Can you see if this helps? Untested...
> >>>>>>>>>
> >>>>>>>>> What base does this apply against please?
> >>>>>>>>>
> >>>>>>>>> I tried Mainline and v5.10.116 and both failed.
> >>>>>>>>
> >>>>>>>> It's against 5.10.116, so that's puzzling. Let me double check I sent
> >>>>>>>> the right one...
> >>>>>>>
> >>>>>>> Looks like I sent the one from the wrong directory, sorry about that.
> >>>>>>> This one should be better:
> >>>>>>
> >>>>>> Nope, both are the right one. Maybe your mailer is mangling the patch?
> >>>>>> I'll attach it gzip'ed here in case that helps.
> >>>>>
> >>>>> Okay, that applied, thanks.
> >>>>>
> >>>>> Unfortunately, I am still able to crash the kernel in the same way.
> >>>>
> >>>> Alright, maybe it's not enough. I can't get your reproducer to crash,
> >>>> unfortunately. I'll try on a different box.
> >>>
> >>> You need to have fuzzing and kasan enabled.
> >>
> >> I do have kasan enabled. What's fuzzing?
> > 
> > CONFIG_KCOV
> 
> Ah ok - I don't think that's needed for this.
> 
> Looking a bit deeper at this, I'm now convinced your bisect went off the
> rails at some point. Probably because this can be timing specific.
> 
> Can you try with this patch?
> 
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 4330603eae35..3ecf71151fb1 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -4252,12 +4252,8 @@ static int io_statx(struct io_kiocb *req, bool force_nonblock)
>  	struct io_statx *ctx = &req->statx;
>  	int ret;
>  
> -	if (force_nonblock) {
> -		/* only need file table for an actual valid fd */
> -		if (ctx->dfd == -1 || ctx->dfd == AT_FDCWD)
> -			req->flags |= REQ_F_NO_FILE_TABLE;
> +	if (force_nonblock)
>  		return -EAGAIN;
> -	}
>  
>  	ret = do_statx(ctx->dfd, ctx->filename, ctx->flags, ctx->mask,
>  		       ctx->buffer);

This does appear to solve the issue. :)

Thanks so much for working on this.

What are the next steps?

Are you able to submit this to Stable?

-- 
Lee Jones [李琼斯]
Principal Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
