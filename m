Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C49EC75D71E
	for <lists+io-uring@lfdr.de>; Sat, 22 Jul 2023 00:05:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229887AbjGUWFm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 21 Jul 2023 18:05:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229592AbjGUWFl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 21 Jul 2023 18:05:41 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 765522690
        for <io-uring@vger.kernel.org>; Fri, 21 Jul 2023 15:05:40 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id d2e1a72fcca58-6686ef86110so1596006b3a.2
        for <io-uring@vger.kernel.org>; Fri, 21 Jul 2023 15:05:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1689977140; x=1690581940;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=0cBZEoQQem4cOhXtPiiuZ5uCO3Wh+uERMJ5V9e4H/pA=;
        b=dUIDsEB4tx+dck8QbLPbk5fieGm22y2WE04JvO6RaSjjsLC2FfbwiYKm9nJymN6Mzk
         o7Dxgve3QRwHgCamVAh/3QyieXmMp9jaMFnJLUZbocHDZF9G7uVqnDAxWbRNq617qNMd
         jjNx6hX+sx0XN5Xz7Ij5nI7bhF743OFTO+Bvas2h4DI7B+UhNauaJX9pEJ2oYDQfLbrM
         9/6/iHf4gMYTE4I/DR9mUT3wx2PnwcFDBl15F+cadw+du2aN/fwGVfEJ6eCq/YxcBEqv
         kcJj6rYMpwfI6OXF7ovSHcs1lJ4YgWURZQHgyLDmwCjnBhWKt+3SzeL4A5WlWhUZOLh2
         3o3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689977140; x=1690581940;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0cBZEoQQem4cOhXtPiiuZ5uCO3Wh+uERMJ5V9e4H/pA=;
        b=hEl8xV2WEsTMVFdkNfVoWnvmc788ifNiuTnxYtQRqrsCtWBdJX+9/3jhPwN2BaJ/8v
         cBlsZO6G/9RvEsCNR93Zkl9csS5QSR1LKCi/pUdFqOg3hO6kHFr0SWAHknyPafxEcqsJ
         WYuAqrFNq7rYQ1F8tqjBAxU/nBqY9DYJyTQtet3yUF+Mj4WT5R8DL9CcXALNlgyWpyaH
         wJTG8eRhKqq+xPZbcG0yJLtEbnmi68BHI5NQVUavyft61+RoP5ey3Mz3++0ePFXTzmTE
         RARj6+9UljVLvF6mCgvG9TKvdw+N3na3De5Lh2oizL4Ea8ITJPif9kyaheAZrYQkANhC
         MZrA==
X-Gm-Message-State: ABy/qLZSF8ulBwTYCagHNy5y4i8t9Wjl16QisEU8FfxxvrtFGXrTxm8J
        z8h4SeZ+CBWHoABcn9k/UjQaQim96LGawTGXa04=
X-Google-Smtp-Source: APBJJlFFG5U58bnh3eRJnl5ruaDdsnbrZ9ODOpNeSwroCbD7hPkwJ5Q5o64T0NuUOfAJjBbVc5ogpw==
X-Received: by 2002:a05:6a00:22d1:b0:67e:bf65:ae61 with SMTP id f17-20020a056a0022d100b0067ebf65ae61mr1445909pfj.28.1689977139897;
        Fri, 21 Jul 2023 15:05:39 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-119-116.pa.vic.optusnet.com.au. [49.186.119.116])
        by smtp.gmail.com with ESMTPSA id y21-20020aa78555000000b0064d47cd116esm3396400pfn.161.2023.07.21.15.05.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Jul 2023 15:05:39 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qMyFk-008vBc-25;
        Sat, 22 Jul 2023 08:05:36 +1000
Date:   Sat, 22 Jul 2023 08:05:36 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, linux-xfs@vger.kernel.org, hch@lst.de,
        andres@anarazel.de
Subject: Re: [PATCH 8/8] iomap: support IOCB_DIO_DEFER
Message-ID: <ZLsBMGe/X62e92Tz@dread.disaster.area>
References: <20230720181310.71589-1-axboe@kernel.dk>
 <20230720181310.71589-9-axboe@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230720181310.71589-9-axboe@kernel.dk>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Jul 20, 2023 at 12:13:10PM -0600, Jens Axboe wrote:
> If IOCB_DIO_DEFER is set, utilize that to set kiocb->dio_complete handler
> and data for that callback. Rather than punt the completion to a
> workqueue, we pass back the handler and data to the issuer and will get a
> callback from a safe task context.
....
> @@ -288,12 +319,17 @@ static loff_t iomap_dio_bio_iter(const struct iomap_iter *iter,
>  		 * after IO completion such as unwritten extent conversion) and
>  		 * the underlying device either supports FUA or doesn't have
>  		 * a volatile write cache. This allows us to avoid cache flushes
> -		 * on IO completion.
> +		 * on IO completion. If we can't use stable writes and need to
> +		 * sync, disable in-task completions as dio completion will
> +		 * need to call generic_write_sync() which will do a blocking
> +		 * fsync / cache flush call.
>  		 */
>  		if (!(iomap->flags & (IOMAP_F_SHARED|IOMAP_F_DIRTY)) &&
>  		    (dio->flags & IOMAP_DIO_STABLE_WRITE) &&
>  		    (bdev_fua(iomap->bdev) || !bdev_write_cache(iomap->bdev)))
>  			use_fua = true;
> +		else if (dio->flags & IOMAP_DIO_NEED_SYNC)
> +			dio->flags &= ~IOMAP_DIO_DEFER_COMP;
>  	}
>  
>  	/*
> @@ -319,6 +355,13 @@ static loff_t iomap_dio_bio_iter(const struct iomap_iter *iter,
>  		pad = pos & (fs_block_size - 1);
>  		if (pad)
>  			iomap_dio_zero(iter, dio, pos - pad, pad);
> +
> +		/*
> +		 * If need_zeroout is set, then this is a new or unwritten
> +		 * extent. These need extra handling at completion time, so
> +		 * disable in-task deferred completion for those.
> +		 */
> +		dio->flags &= ~IOMAP_DIO_DEFER_COMP;
>  	}

I don't think these are quite right. They miss the file extension
case that I pointed out in an earlier patch (i.e. where IOCB_HIPRI
gets cleared).

Fundamentally, I don't like have three different sets of logic which
all end up being set/cleared for the same situation - polled bios
and defered completion should only be used in situations where
inline iomap completion can be run.

IOWs, I think the iomap_dio_bio_iter() code needs to first decide
whether IOMAP_DIO_INLINE_COMP can be set, and if it cannot be set,
we then clear both IOCB_HIPRI and IOMAP_DIO_DEFER_COMP, because
neither should be used for an IO that can not do inline completion.

i.e. this all comes down to something like this:

-	/*
-	 * We can only poll for single bio I/Os.
-	 */
-	if (need_zeroout ||
-	    ((dio->flags & IOMAP_DIO_WRITE) && pos >= i_size_read(inode)))
-		dio->iocb->ki_flags &= ~IOCB_HIPRI;
+	/*
+	 * We can only do inline completion for pure overwrites that
+	 * don't require additional IO at completion. This rules out
+	 * writes that need zeroing or extent conversion, extend
+	 * the file size, or issue journal IO or cache flushes
+	 * during completion processing.
+	 */
+	if (need_zeroout ||
+	    ((dio->flags & IOMAP_DIO_NEED_SYNC) && !use_fua) ||
+	    ((dio->flags & IOMAP_DIO_WRITE) && pos >= i_size_read(inode)))
+		dio->flags &= ~IOMAP_DIO_INLINE_COMP;
+
+	/*
+	 * We can only used polled for single bio IOs or defer
+	 * completion for IOs that will run inline completion.
+	 */
+	if (!(dio->flags & IOMAP_DIO_INLINE_COMP) {
+		dio->iocb->ki_flags &= ~IOCB_HIPRI;
+		dio->flags &= ~IOMAP_DIO_DEFER_COMP;
+	}

This puts the iomap inline completion decision logic all in one
place in the submission code and clearly keys the fast path IO
completion cases to the inline completion paths.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
