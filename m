Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF03B340D66
	for <lists+io-uring@lfdr.de>; Thu, 18 Mar 2021 19:43:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232732AbhCRSnM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 18 Mar 2021 14:43:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232326AbhCRSnE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 18 Mar 2021 14:43:04 -0400
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76D0BC06174A
        for <io-uring@vger.kernel.org>; Thu, 18 Mar 2021 11:43:04 -0700 (PDT)
Received: by mail-io1-xd34.google.com with SMTP id v17so3378213iot.6
        for <io-uring@vger.kernel.org>; Thu, 18 Mar 2021 11:43:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=GAfAjjIzpAnMtL+e+2rg+bzNmZbbBb4hoURr3TnuGmg=;
        b=HBjVNr3ZI3O21Z4iiMNWqaEbye2kw38MoSNoiuZrmgo8OnBsFemlVxnIPVqUmkoPnQ
         5uiBVXR6p6CZU+pSqbWSe01XaMq2BDcgkkii6idM9cmuKD2DKrlXyfycWgxaIz9wlvLM
         ZrrmVaeCWgv3ob0H5qh0ChPEg5m3l/Ki+j6tt4l3YZArZCNy7Aatj41wCw1p1+hb2hXd
         BWJzy3WRPX3Tqv36tklFVxyhigTU219w6sezgzxOjUyS4/u9b1kYmbsRD1a+1g9Pn4WQ
         kDFeZID2X1HFIVZxnTM1LQZ2UzZKxNgMe7wq8wKELzv2sboGco+bD4hjIAcbabcxV3NH
         vDFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GAfAjjIzpAnMtL+e+2rg+bzNmZbbBb4hoURr3TnuGmg=;
        b=o/c3kOSJZnIaz4Q13EYCS93T7NXltkD6MdlMZZXOUfD0qwkGNuMUlQWumse1expDtl
         MtCfSFntkmmQSq5XQBaXpAijTFQwp2Eo0ZEa9zKX4EFfY/x3zceLsdTn+CY+b/I6Z/19
         xfJ/v+D+wohk/jsAzg8VuH8Gd7EsEmnlw8acXzLesH6QV9xDRiCkADltwpPgcOpAIrGF
         1lZyCp8kbyFWeNTEyeG8TOxEdvqZkyixtAX4i3RQUig/ROc9yZ5RMjLggJcFQR7zAFQI
         7RH2ooTHGYlSzygVHlwFFPp1/YqAfuUgxCwI/bgzH/Sd5gxLruEa47/ZT64qVdmr4MTY
         pIqA==
X-Gm-Message-State: AOAM533aEAG2zRYuwuarZWRUnZH5DCItAyeoX2HG4BIbCBEjJdMq4ilI
        NeKSNNTnn/sQTPwKdIGJ8UqJww==
X-Google-Smtp-Source: ABdhPJzWzPzho8ZT0+KUlv1G3Jurw1DDsHU7AjdcFIe66b8PLKXWcO2VCObNi0d/rVtOh7VPQnN7Eg==
X-Received: by 2002:a02:9986:: with SMTP id a6mr8288138jal.46.1616092983893;
        Thu, 18 Mar 2021 11:43:03 -0700 (PDT)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id r18sm1444188ilj.86.2021.03.18.11.43.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Mar 2021 11:43:03 -0700 (PDT)
Subject: Re: [PATCH 4/8] io_uring: add support for IORING_OP_URING_CMD
To:     Christoph Hellwig <hch@lst.de>
Cc:     io-uring@vger.kernel.org, joshi.k@samsung.com, kbusch@kernel.org,
        linux-nvme@lists.infradead.org, metze@samba.org
References: <20210317221027.366780-1-axboe@kernel.dk>
 <20210317221027.366780-5-axboe@kernel.dk> <20210318054254.GC28063@lst.de>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <97b0c789-7230-e38b-4c06-97dc3c42b858@kernel.dk>
Date:   Thu, 18 Mar 2021 12:43:02 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210318054254.GC28063@lst.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/17/21 11:42 PM, Christoph Hellwig wrote:
> On Wed, Mar 17, 2021 at 04:10:23PM -0600, Jens Axboe wrote:
>> +/*
>> + * Called by consumers of io_uring_cmd, if they originally returned
>> + * -EIOCBQUEUED upon receiving the command.
>> + */
>> +void io_uring_cmd_done(struct io_uring_cmd *cmd, ssize_t ret)
>> +{
>> +	struct io_kiocb *req = container_of(cmd, struct io_kiocb, uring_cmd);
>> +
>> +	if (ret < 0)
>> +		req_set_fail_links(req);
>> +	io_req_complete(req, ret);
>> +}
>> +EXPORT_SYMBOL(io_uring_cmd_done);
> 
> This really should be EXPORT_SYMBOL_GPL. But more importantly I'm not

Did make that change in my tree yesterday.

> sure it is an all that useful interface.  All useful non-trivial ioctls
> tend to access user memory, so something that queues up work in the task
> context like in Joshis patch should really be part of the documented
> interface.

Agree, and I made some comments on that patch to how to make that situation
better. Should go in with this part, to have in-task completions for
finishing it up.

>> +static int io_uring_cmd_prep(struct io_kiocb *req,
>> +			     const struct io_uring_sqe *sqe)
>> +{
>> +	const struct io_uring_cmd_sqe *csqe = (const void *) sqe;
> 
> We really should not need this casting.  The struct io_uring_sqe
> usage in io_uring.c needs to be replaced with a union or some other
> properly type safe way to handle this.
> 
>> +	ret = file->f_op->uring_cmd(&req->uring_cmd, issue_flags);
>> +	/* queued async, consumer will call io_uring_cmd_done() when complete */
>> +	if (ret == -EIOCBQUEUED)
>> +		return 0;
>> +	io_uring_cmd_done(&req->uring_cmd, ret);
>> +	return 0;
> 
> This can be simplified to:
> 
> 	if (ret != -EIOCBQUEUED)
> 		io_uring_cmd_done(&req->uring_cmd, ret);
> 	return 0;

Good point, will do that.

>> + * Note that the first member here must be a struct file, as the
>> + * io_uring command layout depends on that.
>> + */
>> +struct io_uring_cmd {
>> +	struct file	*file;
>> +	__u16		op;
>> +	__u16		unused;
>> +	__u32		len;
>> +	__u64		pdu[5];	/* 40 bytes available inline for free use */
>> +};
> 
> I am a little worried about exposting this internal structure to random
> drivers.  OTOH we need something that eventually allows a container_of
> to io_kiocb for the completion, so I can't think of anything better
> at the moment either.
> 


-- 
Jens Axboe

