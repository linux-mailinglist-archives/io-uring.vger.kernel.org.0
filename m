Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9433151BFE6
	for <lists+io-uring@lfdr.de>; Thu,  5 May 2022 14:53:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235178AbiEEM4K (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 5 May 2022 08:56:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232388AbiEEM4J (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 5 May 2022 08:56:09 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 641B356216
        for <io-uring@vger.kernel.org>; Thu,  5 May 2022 05:52:28 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id o69so4119659pjo.3
        for <io-uring@vger.kernel.org>; Thu, 05 May 2022 05:52:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=P0v39/mAWrRUi+2wTwtynXpIdWNGo3L9rkeza3agxKU=;
        b=ni7cfQokOGOG7Gqv6CAErGvAkN8dReAFXi8deTYfu5ZuHkIHTne+SJ37JeJB6nmoqS
         8DNZdc7JMaUil+CTVIsxPfbIC7DG40Sbu5M+yTGgGYTtZAb6ZrebsdqZXF5+/SeoOmzL
         7tP4whrypFczYx1S1zjmq3o4un7be++X0rIrONEaUbO7l6tme3EnM4O6D4YLvBZDFL2z
         9ddYA6MwP9Q+UNIb1OYVq1v+80HWMJd/J+doRKiW2i0ehMZJN2iyEBZU/kX/Rj0sLMyA
         XTwe09suJhRIc4bqYkDv4PhMcM9lL3vC5HWHr9YiE3Mwdod7pj3+h+Mk3S3zWOH8DhfW
         NMcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=P0v39/mAWrRUi+2wTwtynXpIdWNGo3L9rkeza3agxKU=;
        b=i/A+Tx0WcPllrBcYdowXafG1HHpWhRZSVrHpVI/nUq9WPhCdA5ymMjst4KM9IvVyEt
         g/zT147xX8/4XIky5amDhqu4nVqraEOWFh5gL+jzYpcz8eWxqw/nK/D1zvr/6XliGlEb
         nIV23l5y8+ytxjRgwEwkRdk4Gy0P3yTyJbMSl/nnoxjKwkpzFiG+nS8BAPaW2g6SlcHp
         cAnaOAmOwrfzKxvXf7Mjm55HmBCVYvfwOowzYBnp1lUWv9ZC9t6DVlmCSEDl09RZwfet
         vR5mnNQ0Yu3mXq97i8CagDoe2cd4DU2WKKrouGI9hKoRI8T53gkwskyH4CScc03xlMIv
         UqUw==
X-Gm-Message-State: AOAM533LSegwEQpkrd0EMh/ra8r1vS3gtB+dT3epEqglkNzmPUYTVfyQ
        32IeUJVyH3JFlPfTqGAM3qXtOA==
X-Google-Smtp-Source: ABdhPJwP8g7QNvIa1qpXfzABwAwh0/VAN3hVjn2WBcMxVuEZsrrgg7DGl6orj8lxASGqvQYWfS1qJw==
X-Received: by 2002:a17:90b:4d8b:b0:1dc:c94f:fc29 with SMTP id oj11-20020a17090b4d8b00b001dcc94ffc29mr1115528pjb.186.1651755147706;
        Thu, 05 May 2022 05:52:27 -0700 (PDT)
Received: from [192.168.4.166] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id h189-20020a636cc6000000b003c18ab7389asm753772pgc.36.2022.05.05.05.52.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 May 2022 05:52:27 -0700 (PDT)
Message-ID: <f9051783-5105-45ba-99b3-bc5d9254656d@kernel.dk>
Date:   Thu, 5 May 2022 06:52:25 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH v4 1/5] fs,io_uring: add infrastructure for uring-cmd
Content-Language: en-US
To:     Kanchan Joshi <joshi.k@samsung.com>, hch@lst.de
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        asml.silence@gmail.com, ming.lei@redhat.com, mcgrof@kernel.org,
        shr@fb.com, joshiiitr@gmail.com, anuj20.g@samsung.com,
        gost.dev@samsung.com
References: <20220505060616.803816-1-joshi.k@samsung.com>
 <CGME20220505061144epcas5p3821a9516dad2b5eff5a25c56dbe164df@epcas5p3.samsung.com>
 <20220505060616.803816-2-joshi.k@samsung.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220505060616.803816-2-joshi.k@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/5/22 12:06 AM, Kanchan Joshi wrote:
> From: Jens Axboe <axboe@kernel.dk>
> 
> file_operations->uring_cmd is a file private handler.
> This is somewhat similar to ioctl but hopefully a lot more sane and
> useful as it can be used to enable many io_uring capabilities for the
> underlying operation.
> 
> IORING_OP_URING_CMD is a file private kind of request. io_uring doesn't
> know what is in this command type, it's for the provider of ->uring_cmd()
> to deal with. This operation can be issued only on the ring that is
> setup with both IORING_SETUP_SQE128 and IORING_SETUP_CQE32 flags.

One thing that occured to me that I think we need to change is what you
mention above, code here:

> +static int io_uring_cmd_prep(struct io_kiocb *req,
> +			     const struct io_uring_sqe *sqe)
> +{
> +	struct io_uring_cmd *ioucmd = &req->uring_cmd;
> +	struct io_ring_ctx *ctx = req->ctx;
> +
> +	if (ctx->flags & IORING_SETUP_IOPOLL)
> +		return -EOPNOTSUPP;
> +	/* do not support uring-cmd without big SQE/CQE */
> +	if (!(ctx->flags & IORING_SETUP_SQE128))
> +		return -EOPNOTSUPP;
> +	if (!(ctx->flags & IORING_SETUP_CQE32))
> +		return -EOPNOTSUPP;
> +	if (sqe->ioprio || sqe->rw_flags)
> +		return -EINVAL;
> +	ioucmd->cmd = sqe->cmd;
> +	ioucmd->cmd_op = READ_ONCE(sqe->cmd_op);
> +	return 0;
> +}

I've been thinking of this mostly in the context of passthrough for
nvme, but it originally started as a generic feature to be able to wire
up anything for these types of commands. The SQE128/CQE32 requirement is
really an nvme passthrough restriction, we don't necessarily need this
for any kind of URING_CMD. Ditto IOPOLL as well. These are all things
that should be validated further down, but there's no way to do that
currently.

Let's not have that hold up merging this, but we do need it fixed up for
5.19-final so we don't have this restriction. Suggestions welcome...

-- 
Jens Axboe

