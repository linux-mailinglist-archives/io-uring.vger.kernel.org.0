Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 361FF340D72
	for <lists+io-uring@lfdr.de>; Thu, 18 Mar 2021 19:44:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232764AbhCRSoQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 18 Mar 2021 14:44:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232623AbhCRSoN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 18 Mar 2021 14:44:13 -0400
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F2E2C06174A
        for <io-uring@vger.kernel.org>; Thu, 18 Mar 2021 11:44:13 -0700 (PDT)
Received: by mail-io1-xd32.google.com with SMTP id f19so3382316ion.3
        for <io-uring@vger.kernel.org>; Thu, 18 Mar 2021 11:44:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=dcg1y//+DoAkTXSWSFL8u0Yi01QGJS6gRj6Nwc1cgM0=;
        b=XQq4hQ2GavpXdun8/b2ixrOFx72Uj8N6FzkAUpld3TlamNL/NCe51NW51nf3XK0EQ+
         XlCae3vEus8x4R09b5N9bLEfpcjTlQNlL2QdoIWDSElrOvJBm1B0x9xPlHjmXZVRoSxg
         t5fQvaef+Bw3tVOpXtMXmoTrYxD3Dm9GVPfh8sh1lCS9DokUrfsPTs88d8m8Rx94p07r
         XzN9C7XNNqoZINkJhHE50uolL8hMQfFWJ7BU4xX/CvseFVvCPF+uSZZ1vrHdJaJE3AA7
         +DBd087MLPOuBVQWkH3Et97XXwwHvnBrL+KmulR9axC7BIDb7x5UNNB1TrlMv4L+AXBu
         bPyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dcg1y//+DoAkTXSWSFL8u0Yi01QGJS6gRj6Nwc1cgM0=;
        b=PVJ+Eevhr3prYR3iAbRK2oS/Jl+sh/zfMjxvgE8N/JS2EmBnn3XWSYv0YHKkokHaAo
         pRPwoIr/K66bGF1z9B7txhoxOOBb03nGHOYrCYlqggHVdzw/sFAA82MrT6nUulrdux26
         kAgy6LBuSOSBgZpKL26okAyIhDp9ZZmDtSwdl3tFMQbkcLfaUmiqrKwOkLS06Idgu272
         nSPhIiuTMO9GTaTDh82UPvhrIMSfZwVBBrcq5Cz5ThvYkb7T2ARCrCWsR+7wI+yyi2vL
         ilOQQFA7j0ohX0xA4eXysihtG9/Pr5hxs9EIEvXGXdpWhLwDdeeT6ixIGeFJMdJaVOAZ
         ehOg==
X-Gm-Message-State: AOAM5330kAVxOC8X8kHRnY+eBzkLZg12jlzNmDJhkCA5+FxmLrlQL4Cx
        RKXxs02tzQxqMlaEOAub570cVK4ASEkrlg==
X-Google-Smtp-Source: ABdhPJwJRyLj13ds04OCULiOrI0adobTqekGYabE96Pj6mEQ6XF1RKXSQgUlmGiYA2ymNnQkUeD7yA==
X-Received: by 2002:a6b:3bc7:: with SMTP id i190mr11572503ioa.163.1616093052890;
        Thu, 18 Mar 2021 11:44:12 -0700 (PDT)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id h6sm1366812ild.79.2021.03.18.11.44.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Mar 2021 11:44:12 -0700 (PDT)
Subject: Re: [PATCH 6/8] block: add example ioctl
To:     Christoph Hellwig <hch@lst.de>
Cc:     io-uring@vger.kernel.org, joshi.k@samsung.com, kbusch@kernel.org,
        linux-nvme@lists.infradead.org, metze@samba.org
References: <20210317221027.366780-1-axboe@kernel.dk>
 <20210317221027.366780-7-axboe@kernel.dk> <20210318054506.GE28063@lst.de>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <df428685-0729-8d7c-b079-97e9efd6ae15@kernel.dk>
Date:   Thu, 18 Mar 2021 12:44:12 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210318054506.GE28063@lst.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/17/21 11:45 PM, Christoph Hellwig wrote:
> On Wed, Mar 17, 2021 at 04:10:25PM -0600, Jens Axboe wrote:
>> +static int blkdev_uring_ioctl(struct block_device *bdev,
>> +			      struct io_uring_cmd *cmd)
>> +{
>> +	struct block_uring_cmd *bcmd = (struct block_uring_cmd *) &cmd->pdu;
>> +
>> +	switch (bcmd->ioctl_cmd) {
>> +	case BLKBSZGET:
>> +		return block_size(bdev);
>> +	default:
>> +		return -ENOTTY;
>> +	}
>> +}
>> +
>>  static int blkdev_uring_cmd(struct io_uring_cmd *cmd,
>>  			    enum io_uring_cmd_flags flags)
>>  {
>>  	struct block_device *bdev = I_BDEV(cmd->file->f_mapping->host);
>>  
>> +	switch (cmd->op) {
>> +	case BLOCK_URING_OP_IOCTL:
>> +		return blkdev_uring_ioctl(bdev, cmd);
> 
> I don't think the two level dispatch here makes any sense.  Then again
> I don't think this code makes sense either except as an example..

That's all it is, an example. And, for me, just a quick way to test
that everything stacks and layers appropriately. But yes, once we have
something more concrete, this POC can be dropped and then re-introduced
when there's a real use case.

-- 
Jens Axboe

