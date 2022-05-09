Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5474D5201F7
	for <lists+io-uring@lfdr.de>; Mon,  9 May 2022 18:10:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238959AbiEIQNJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 9 May 2022 12:13:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238947AbiEIQNI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 9 May 2022 12:13:08 -0400
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDE792764CE
        for <io-uring@vger.kernel.org>; Mon,  9 May 2022 09:09:12 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id f2so15823721ioh.7
        for <io-uring@vger.kernel.org>; Mon, 09 May 2022 09:09:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=fCvLOr8+eHkzeHyWMYW7RF71t3Gl1LCKsc2kzaAVZOM=;
        b=QlT+8onnX75/tEvfJkYh9kLNZ+hsPPZPdpIbHZXl8kpppooGxKYmuoC6vLZclgirkt
         wTUJPGqs70408FK5mHAO6rN9wR9jArSexSqpr6Zv4jIqknRuMdyECi9FKHFSFDVoLPPl
         pZDYCqKxHpQUtd2fiQH7UKzkf1FxOOgh+o8EheT71+7rFS7zEoRna5dzBgP8KNcJCJVt
         0ALV6L2qoolorwBEsM8jk2TyDagowC44jDNzNgJ317AhCVW3oR+3ULHcLKoc/ehyGVSe
         PNDbAyAOih/dVPedbHz/cvsnG+m6NWT9W+OBW0zbsEnECBTCokUFrm5/lL3Qqa8HR5w7
         dCvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=fCvLOr8+eHkzeHyWMYW7RF71t3Gl1LCKsc2kzaAVZOM=;
        b=0mEXp1qXd0/rCv2Pxprg75863c/JjKALnTsm/U62E6+F2hr2uWu9XuBjscFp8qGOE0
         7JUUYGR88ebAzoxFoCrc7TKOjLcmLmVO7iYrp5O/ZIDx3dx8c+fCRNow1nqXM/Fso7Ev
         /kFBH2ccvGiYMG337wmPZr4sZ+0b9YV+y815BsNjsS9Ue5BEv17+E38m658yAB7OFN4E
         AeFlBV6Y4cTaRXHuPiKF1x2Q+olJYx6r4EL5dJLrUepqqWPZgbOGUwEx4y2V5vDAAvjX
         5lmYcdTeiub9P5yOSyjUiYkw1V84qqvIam9u43UbfN0/3AfDAfBg0AdvQ/0CKclLSa3s
         Ti5Q==
X-Gm-Message-State: AOAM530a90UPxaZjdbU07J4H2Q33s+/o34dd8Nq92SeEmuv+Oazi4CT+
        dvOgJnF3/QpOirpOi4FKyOq9SQ==
X-Google-Smtp-Source: ABdhPJwzjjBY5XZM0KYyqpPJe2/GevSYJOkjWwTkr5Kimpk+Ej1+gNb4IcMUqD9aX0MOZbgLExD9rg==
X-Received: by 2002:a05:6638:372c:b0:32b:604c:ec04 with SMTP id k44-20020a056638372c00b0032b604cec04mr7108749jav.84.1652112552162;
        Mon, 09 May 2022 09:09:12 -0700 (PDT)
Received: from [192.168.1.172] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id cp20-20020a056638481400b0032b75b98013sm3695366jab.148.2022.05.09.09.09.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 May 2022 09:09:11 -0700 (PDT)
Message-ID: <9c833e12-fd09-fe7d-d4f2-e916c6ce4524@kernel.dk>
Date:   Mon, 9 May 2022 10:09:10 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [RFC PATCH] ubd: add io_uring based userspace block driver
Content-Language: en-US
To:     Ming Lei <ming.lei@redhat.com>
Cc:     linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        io-uring@vger.kernel.org,
        Gabriel Krisman Bertazi <krisman@collabora.com>,
        ZiyangZhang <ZiyangZhang@linux.alibaba.com>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
References: <20220509092312.254354-1-ming.lei@redhat.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220509092312.254354-1-ming.lei@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/9/22 3:23 AM, Ming Lei wrote:
> This is the driver part of userspace block driver(ubd driver), the other
> part is userspace daemon part(ubdsrv)[1].
> 
> The two parts communicate by io_uring's IORING_OP_URING_CMD with one
> shared cmd buffer for storing io command, and the buffer is read only for
> ubdsrv, each io command is indexed by io request tag directly, and
> is written by ubd driver.
> 
> For example, when one READ io request is submitted to ubd block driver, ubd
> driver stores the io command into cmd buffer first, then completes one
> IORING_OP_URING_CMD for notifying ubdsrv, and the URING_CMD is issued to
> ubd driver beforehand by ubdsrv for getting notification of any new io request,
> and each URING_CMD is associated with one io request by tag.
> 
> After ubdsrv gets the io command, it translates and handles the ubd io
> request, such as, for the ubd-loop target, ubdsrv translates the request
> into same request on another file or disk, like the kernel loop block
> driver. In ubdsrv's implementation, the io is still handled by io_uring,
> and share same ring with IORING_OP_URING_CMD command. When the target io
> request is done, the same IORING_OP_URING_CMD is issued to ubd driver for
> both committing io request result and getting future notification of new
> io request.
> 
> Another thing done by ubd driver is to copy data between kernel io
> request and ubdsrv's io buffer:
> 
> 1) before ubsrv handles WRITE request, copy the request's data into
> ubdsrv's userspace io buffer, so that ubdsrv can handle the write
> request
> 
> 2) after ubsrv handles READ request, copy ubdsrv's userspace io buffer
> into this READ request, then ubd driver can complete the READ request
> 
> Zero copy may be switched if mm is ready to support it.
> 
> ubd driver doesn't handle any logic of the specific user space driver,
> so it should be small/simple enough.

This is pretty interesting! Just one small thing I noticed, since you
want to make sure batching is Good Enough:

> +static blk_status_t ubd_queue_rq(struct blk_mq_hw_ctx *hctx,
> +		const struct blk_mq_queue_data *bd)
> +{
> +	struct ubd_queue *ubq = hctx->driver_data;
> +	struct request *rq = bd->rq;
> +	struct ubd_io *io = &ubq->ios[rq->tag];
> +	struct ubd_rq_data *data = blk_mq_rq_to_pdu(rq);
> +	blk_status_t res;
> +
> +	if (ubq->aborted)
> +		return BLK_STS_IOERR;
> +
> +	/* this io cmd slot isn't active, so have to fail this io */
> +	if (WARN_ON_ONCE(!(io->flags & UBD_IO_FLAG_ACTIVE)))
> +		return BLK_STS_IOERR;
> +
> +	/* fill iod to slot in io cmd buffer */
> +	res = ubd_setup_iod(ubq, rq);
> +	if (res != BLK_STS_OK)
> +		return BLK_STS_IOERR;
> +
> +	blk_mq_start_request(bd->rq);
> +
> +	/* mark this cmd owned by ubdsrv */
> +	io->flags |= UBD_IO_FLAG_OWNED_BY_SRV;
> +
> +	/*
> +	 * clear ACTIVE since we are done with this sqe/cmd slot
> +	 *
> +	 * We can only accept io cmd in case of being not active.
> +	 */
> +	io->flags &= ~UBD_IO_FLAG_ACTIVE;
> +
> +	/*
> +	 * run data copy in task work context for WRITE, and complete io_uring
> +	 * cmd there too.
> +	 *
> +	 * This way should improve batching, meantime pinning pages in current
> +	 * context is pretty fast.
> +	 */
> +	task_work_add(ubq->ubq_daemon, &data->work, TWA_SIGNAL);
> +
> +	return BLK_STS_OK;
> +}

It'd be better to use bd->last to indicate what kind of signaling you
need here. TWA_SIGNAL will force an immediate transition if the app is
running in userspace, which may not be what you want. Also see:

https://git.kernel.dk/cgit/linux-block/commit/?h=for-5.19/io_uring&id=e788be95a57a9bebe446878ce9bf2750f6fe4974

But regardless of signaling needed, you don't need it except if bd->last
is true. Would need a commit_rqs() as well, but that's trivial.

More importantly, what prevents ubq->ubq_daemon from going away after
it's been assigned? I didn't look at the details, but is this relying on
io_uring being closed to cancel pending requests? That should work, but
we need some way to ensure that ->ubq_daemon is always valid here.

-- 
Jens Axboe

