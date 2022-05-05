Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3394F51C189
	for <lists+io-uring@lfdr.de>; Thu,  5 May 2022 15:56:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380227AbiEEN57 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 5 May 2022 09:57:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380051AbiEEN56 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 5 May 2022 09:57:58 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FFF758E45
        for <io-uring@vger.kernel.org>; Thu,  5 May 2022 06:54:16 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id bo5so3706331pfb.4
        for <io-uring@vger.kernel.org>; Thu, 05 May 2022 06:54:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=ODL/RZp3B3RfrFH5GlLl86qa0DgQB+nmVNbtBUgHocc=;
        b=NS3DBt+ILaQtVBQLrA0NoEjJCJFhRoyZCB/Kw2nO7Bv80S7rbh8LSdFLipJA/Z/tz+
         WPs3kGZo4JrIR19XIVbSSTyMyuTW0NmioDgx1NXFdzTqA3vtGeTcM8joftbZU0WoOs6Q
         KuDNsgfRC321/2L4zPaFNtEW8aSlvNT5YH2I2Nt+r2IBzjV5fOET5ieWk1spJ2wWsrnL
         N5xm0CCC+DL8jAnEMP2gSpzYAyy4E9byrObe17Hh5g197gXVrmnzYcg77rqvF0N+Mu0E
         u8x9tpv1dVImAfGl/8PVRIZzJn6CRVrQtyKJFGr3mGPmAOEDX6Ke/4N8ryOVn5pdsvmY
         USUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ODL/RZp3B3RfrFH5GlLl86qa0DgQB+nmVNbtBUgHocc=;
        b=SAegwMuisk6U75+GMiUvHnwdbMQPd9kTui95EUEAEc7bJaBDk31osfTunvHD0jF8YG
         fS5aM1jxU2QSTiGMluLNOXn17DhAKIFw3lb875bLbtHMDa8IIgqgmnrPDJk9wGTtvMF/
         9+ieSvh25w3H225dy7RjAEdKBgO6ScLlb+0dDN8Mohb/FkdVMgiAOm4AI5Vqt4i/GFoM
         Ul1RkleEcHInbB0UW6Nv3KqdkHmuwEBfOszvLDSJrvsEUYzQYs0ItSCWJaX4pqJa5yEG
         N86atQxXJXfFz2V9lpTaEGDAKxqcnBUZ2N1+Awbz06nd2mdQw0paRuPXq9Mk4R5V+dVn
         4yiw==
X-Gm-Message-State: AOAM533xIqDxki3viejNWqkOXkZnYAnMRhPYTv84ysE0tx8rmNC2udHy
        qJxO6wv0v/TCdV8ItDAqLWcsQg==
X-Google-Smtp-Source: ABdhPJxWuqQiO4TJLigOa7txXWeQbIwY3pwXIa2+sxXkpiFsFG0B1d7FswwCnpZfv9bi+QTFQiRMMA==
X-Received: by 2002:a63:a18:0:b0:3c6:12b1:a8d0 with SMTP id 24-20020a630a18000000b003c612b1a8d0mr3114898pgk.534.1651758855507;
        Thu, 05 May 2022 06:54:15 -0700 (PDT)
Received: from [192.168.4.166] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id f12-20020aa7968c000000b0050dc762813fsm1409512pfk.25.2022.05.05.06.54.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 May 2022 06:54:15 -0700 (PDT)
Message-ID: <a91d43b7-9d97-385e-190f-a26b078d2f36@kernel.dk>
Date:   Thu, 5 May 2022 07:54:13 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH v4 1/5] fs,io_uring: add infrastructure for uring-cmd
Content-Language: en-US
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Kanchan Joshi <joshi.k@samsung.com>, hch@lst.de,
        io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        asml.silence@gmail.com, mcgrof@kernel.org, shr@fb.com,
        joshiiitr@gmail.com, anuj20.g@samsung.com, gost.dev@samsung.com
References: <20220505060616.803816-1-joshi.k@samsung.com>
 <CGME20220505061144epcas5p3821a9516dad2b5eff5a25c56dbe164df@epcas5p3.samsung.com>
 <20220505060616.803816-2-joshi.k@samsung.com>
 <f9051783-5105-45ba-99b3-bc5d9254656d@kernel.dk> <YnPVtiRbYBYCGkCi@T590>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <YnPVtiRbYBYCGkCi@T590>
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

On 5/5/22 7:48 AM, Ming Lei wrote:
> On Thu, May 05, 2022 at 06:52:25AM -0600, Jens Axboe wrote:
>> On 5/5/22 12:06 AM, Kanchan Joshi wrote:
>>> From: Jens Axboe <axboe@kernel.dk>
>>>
>>> file_operations->uring_cmd is a file private handler.
>>> This is somewhat similar to ioctl but hopefully a lot more sane and
>>> useful as it can be used to enable many io_uring capabilities for the
>>> underlying operation.
>>>
>>> IORING_OP_URING_CMD is a file private kind of request. io_uring doesn't
>>> know what is in this command type, it's for the provider of ->uring_cmd()
>>> to deal with. This operation can be issued only on the ring that is
>>> setup with both IORING_SETUP_SQE128 and IORING_SETUP_CQE32 flags.
>>
>> One thing that occured to me that I think we need to change is what you
>> mention above, code here:
>>
>>> +static int io_uring_cmd_prep(struct io_kiocb *req,
>>> +			     const struct io_uring_sqe *sqe)
>>> +{
>>> +	struct io_uring_cmd *ioucmd = &req->uring_cmd;
>>> +	struct io_ring_ctx *ctx = req->ctx;
>>> +
>>> +	if (ctx->flags & IORING_SETUP_IOPOLL)
>>> +		return -EOPNOTSUPP;
>>> +	/* do not support uring-cmd without big SQE/CQE */
>>> +	if (!(ctx->flags & IORING_SETUP_SQE128))
>>> +		return -EOPNOTSUPP;
>>> +	if (!(ctx->flags & IORING_SETUP_CQE32))
>>> +		return -EOPNOTSUPP;
>>> +	if (sqe->ioprio || sqe->rw_flags)
>>> +		return -EINVAL;
>>> +	ioucmd->cmd = sqe->cmd;
>>> +	ioucmd->cmd_op = READ_ONCE(sqe->cmd_op);
>>> +	return 0;
>>> +}
>>
>> I've been thinking of this mostly in the context of passthrough for
>> nvme, but it originally started as a generic feature to be able to wire
>> up anything for these types of commands. The SQE128/CQE32 requirement is
>> really an nvme passthrough restriction, we don't necessarily need this
>> for any kind of URING_CMD. Ditto IOPOLL as well. These are all things
>> that should be validated further down, but there's no way to do that
>> currently.
>>
>> Let's not have that hold up merging this, but we do need it fixed up for
>> 5.19-final so we don't have this restriction. Suggestions welcome...
> 
> The validation has to be done in consumer of SQE128/CQE32(nvme). One
> way is to add SQE128/CQE32 io_uring_cmd_flags and pass them via
> ->uring_cmd(issue_flags).

Right, that's what I tried to say, it needs to be validated further down
as we can (and will) have URING_CMD users that don't care about any of
those 3 things and can work fine with whatever sqe/cqe size we have.
IOPOLL also only applies if the handler potentially can block.

Using the issue_flags makes sense to me, it's probably the easiest
approach. Doesn't take space in the command itself, and there's plenty
of room in that flag space to pass in the ring sqe/cqe/iopoll state.

-- 
Jens Axboe

