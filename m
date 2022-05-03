Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F025F518FB7
	for <lists+io-uring@lfdr.de>; Tue,  3 May 2022 23:08:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235492AbiECVHU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 3 May 2022 17:07:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229818AbiECVHT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 3 May 2022 17:07:19 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2DED3FBE9
        for <io-uring@vger.kernel.org>; Tue,  3 May 2022 14:03:45 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id w5-20020a17090aaf8500b001d74c754128so3422780pjq.0
        for <io-uring@vger.kernel.org>; Tue, 03 May 2022 14:03:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=7O2TD+ItgZf75PGd5yqC2U7A8M10Uaxid1XmDB2349g=;
        b=5bsFHw6SSOpSu3QUxvDUWRie0pfK+8Ho6xW5TVr4haGCr/QlqXXpoGD5ThiCoKwWd+
         2f3nCKQ+dKyicFvL/y8IrydSQ/eO3Xynkp3GDDgVDJSeAny/IfKGyNUzPWAWFNhdS5F7
         I4O0PlgJtic1kgKfa6CGAi8o8rk0ZIsMv4lWlxthHIrl6rta1g8i6FtjC7OviEyMiCYu
         ludtVzlfzRSRjDgHY8dVfiCF98BDCFjn6Ju5fkcfeJ4qJ0e8K5lS3A8AVcR6ZoIsWGVS
         ZhyIwytx1/rcY9IplWkM/wAsScZgmQo34o0YBURIwtiqvofbxmLKX8GMuNZpDDqqLFkC
         5K5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=7O2TD+ItgZf75PGd5yqC2U7A8M10Uaxid1XmDB2349g=;
        b=cYAEj82+KlJhhlZNpXJjDoF1LU21piPqMY+LjNYjiT3XfDTsyx+dxb25VNNpF8jhvk
         Bu6zFxLdOUIbcvg3nhIF6kaKzyRTCjkvCirAaiZI87Z0ZKXo1kV91aU/WBqm2aGw/oHJ
         S0F1I44+eZAqTzfNBlZxVs/6TjC9d5AZBoEJ+8K9SFOWar1mgjcokpdozRuvZADoBZc/
         JrNABVyMOPsxSMDVXFi3b4L4SwDisNEPUien0aUTuZm3ZsFhxTn1mVbMQ+hP/ii+560R
         6LpqZSV5lWkVOcPrXo4rTXb/W9BsYSodk8YOQ4jbNGeOwTzDwpMV23/8HpLsO05SPxNz
         ySLQ==
X-Gm-Message-State: AOAM5333EK3lstz5ylRnZqYNK2+SsHb7a0BtDjqEebUfPAib8Pc6E137
        rFt8DbXsJefD42lZiTApdP2Whw==
X-Google-Smtp-Source: ABdhPJzJJ+3peYbkCbOTkLGnoxZ4Hs4morKS+37sPXOzfeqnayu56CQnb48+1yScE5j35StPLtsMZA==
X-Received: by 2002:a17:90a:e7c3:b0:1dc:5d85:9fd0 with SMTP id kb3-20020a17090ae7c300b001dc5d859fd0mr6803731pjb.168.1651611825328;
        Tue, 03 May 2022 14:03:45 -0700 (PDT)
Received: from [192.168.4.166] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id w37-20020a634925000000b003c15f7f2914sm13016955pga.24.2022.05.03.14.03.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 May 2022 14:03:44 -0700 (PDT)
Message-ID: <81793f8c-3c3e-a378-7db7-dd7a739edd72@kernel.dk>
Date:   Tue, 3 May 2022 15:03:42 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH v3 1/5] fs,io_uring: add infrastructure for uring-cmd
Content-Language: en-US
To:     Pankaj Raghav <p.raghav@samsung.com>, hch@lst.de
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        asml.silence@gmail.com, ming.lei@redhat.com, mcgrof@kernel.org,
        shr@fb.com, joshiiitr@gmail.com, gost.dev@samsung.com,
        Kanchan Joshi <joshi.k@samsung.com>
References: <20220503184831.78705-1-p.raghav@samsung.com>
 <CGME20220503184912eucas1p1bb0e3d36c06cfde8436df3a45e67bd32@eucas1p1.samsung.com>
 <20220503184831.78705-2-p.raghav@samsung.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220503184831.78705-2-p.raghav@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/3/22 12:48 PM, Pankaj Raghav wrote:
> From: Jens Axboe <axboe@kernel.dk>
> 
> file_operations->uring_cmd is a file private handler, similar to ioctls
> but hopefully a lot more sane and useful.
> 
> IORING_OP_URING_CMD is a file private kind of request. io_uring doesn't
> know what is in this command type, it's for the provider of ->uring_cmd()
> to deal with. This operation can be issued only on the ring that is
> setup with both IORING_SETUP_SQE128 and IORING_SETUP_CQE32 flags.

A few minor comments below.

> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index c7e3f7e74d92..b774e6eac538 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> +static int io_uring_cmd_prep(struct io_kiocb *req,
> +			     const struct io_uring_sqe *sqe)
> +{
> +	struct io_uring_cmd *ioucmd = &req->uring_cmd;
> +
> +	if (req->ctx->flags & IORING_SETUP_IOPOLL)
> +		return -EOPNOTSUPP;
> +	/* do not support uring-cmd without big SQE/CQE */
> +	if (!(req->ctx->flags & IORING_SETUP_SQE128))
> +		return -EOPNOTSUPP;
> +	if (!(req->ctx->flags & IORING_SETUP_CQE32))
> +		return -EOPNOTSUPP;
> +	ioucmd->cmd = (void *) &sqe->cmd;
> +	ioucmd->cmd_op = READ_ONCE(sqe->cmd_op);
> +	ioucmd->flags = 0;
> +	return 0;
> +}

I'd define

	struct io_ring_ctx *ctx = req->ctx;

here. And you should read 'rw_flags' and return -EINVAL if it's set, so
we can be backwards compatible if flags are added later. Probably read
eg sqe->ioprio as well as that isn't directly applicable (it'd just be
set in the command directly) and -EINVAL if that is set. Ala:

static int io_uring_cmd_prep(struct io_kiocb *req,
			     const struct io_uring_sqe *sqe)
{
	struct io_uring_cmd *ioucmd = &req->uring_cmd;
	struct io_ring_ctx *ctx = req->ctx;

	if (ctx->flags & IORING_SETUP_IOPOLL)
		return -EOPNOTSUPP;
	/* do not support uring-cmd without big SQE/CQE */
	if (!(ctx->flags & IORING_SETUP_SQE128))
		return -EOPNOTSUPP;
	if (!(ctx->flags & IORING_SETUP_CQE32))
		return -EOPNOTSUPP;
	if (sqe->ioprio || sqe->rw_flags
		return -EINVAL;

	ioucmd->cmd = (void *) &sqe->cmd;
	ioucmd->cmd_op = READ_ONCE(sqe->cmd_op);
	ioucmd->flags = 0;
	return 0;
}

> +static int io_uring_cmd(struct io_kiocb *req, unsigned int issue_flags)
> +{
> +	struct file *file = req->file;
> +	struct io_uring_cmd *ioucmd = &req->uring_cmd;
> +
> +	if (!req->file->f_op->uring_cmd)
> +		return -EOPNOTSUPP;
> +	ioucmd->flags |= issue_flags;
> +	file->f_op->uring_cmd(ioucmd);
> +	return 0;
> +}

We should pass in issue_flags here, it's a property of the call path,
not the command itself:

static int io_uring_cmd(struct io_kiocb *req, unsigned int issue_flags)
{
	struct file *file = req->file;
	struct io_uring_cmd *ioucmd = &req->uring_cmd;

	if (!req->file->f_op->uring_cmd)
		return -EOPNOTSUPP;
	file->f_op->uring_cmd(ioucmd, issue_flags);
	return 0;
}

and then get rid of ioucmd->flags, that can get re-added as the copy of
sqe->rw_flags when we need that.

Agree with Christoph on the things he brought up. If possible, please
just respin this patch with the suggested changes and we can queue it
up.

-- 
Jens Axboe

