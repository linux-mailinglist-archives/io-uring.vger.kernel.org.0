Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBC6F33F606
	for <lists+io-uring@lfdr.de>; Wed, 17 Mar 2021 17:50:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232558AbhCQQts (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 17 Mar 2021 12:49:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232000AbhCQQtb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 17 Mar 2021 12:49:31 -0400
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E794FC06174A
        for <io-uring@vger.kernel.org>; Wed, 17 Mar 2021 09:49:30 -0700 (PDT)
Received: by mail-io1-xd2c.google.com with SMTP id n132so41685348iod.0
        for <io-uring@vger.kernel.org>; Wed, 17 Mar 2021 09:49:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=1wH2LyRR1+bkK8ozSKChGqdKiq+o6C+KbC3pYm1I//k=;
        b=vx74i421oIidL1AV7IVP9x/MKke8KwPgl0Y/NHP+XkaFldqzFwsFqlHqiB++OfBskX
         sny0d/GsB7SOBY8Tav4jUUjJzHngV91SMwRsadcbUbS2jSz+pxe7cb5JoIaadWd9sLYn
         1uJzR5njwT0U+JfnBjRyc9IOC6WgrJALssO+afnYk+qh6kDNUX7mIh5HEaYe/OhSCJTv
         cwwrSWxOF6GPfsm5Ur44XKUeNbR4N++fQblLIL04axWlKBkLMQiTotp8DA7IwZQh8hXq
         J9E137FEu/TUl/HrdEeQuoYB+veJwHVmGsXPTzf+C2fI21YKGyATEMpc9f7rCrSzTNyI
         rjdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1wH2LyRR1+bkK8ozSKChGqdKiq+o6C+KbC3pYm1I//k=;
        b=OGb/zqRte77za/+aIMwl7z8iKS5DZNAb1lnb0tSX5+Yzm6VT5IBghnlSBpJYiwgUOf
         lb5tqtdJhQHO65WKremxuxC2212QvaQHeeJHhBMTVBjL/bClWZ3Bmo7eAe/ftbHIWxWQ
         XZlLGXcwRtg1WyhzZhDmDZ6KzG3vapg35bO5ECBiNWRdjHeCq2GpAwHdZroxi2vTfbdC
         zEzxjO6oQhxsexg/MoMEZ3R8C3tsK3SMW7a0+ct6nHTwFVNEgupujw9PzoInuRdAfsD7
         w+R7qCmAGr8j8vZCKOSyOGkxsHRJkrsMwJ3YOREa6ODw0fu+2NUqzUTqxLRdhIcdFKxx
         TWnA==
X-Gm-Message-State: AOAM5304avvWN3ZurybFkMwwyNN6jDY8VbxTPsa5RcUwj/3sYwMyNhCf
        VNzZCjwA+YxYjhNv0qRyIFBmG816tUR1xA==
X-Google-Smtp-Source: ABdhPJwuYqaRv3GWQJYe3nx1X6av0DUufct9XitEkVCCQ93kIMY9i5w81Fpt7geD2f0zEp9BWeddYw==
X-Received: by 2002:a02:3304:: with SMTP id c4mr3597808jae.68.1615999770323;
        Wed, 17 Mar 2021 09:49:30 -0700 (PDT)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id s18sm11490637ilt.9.2021.03.17.09.49.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Mar 2021 09:49:29 -0700 (PDT)
Subject: Re: [RFC PATCH v3 3/3] nvme: wire up support for async passthrough
To:     Christoph Hellwig <hch@lst.de>, Kanchan Joshi <joshi.k@samsung.com>
Cc:     kbusch@kernel.org, chaitanya.kulkarni@wdc.com,
        io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        anuj20.g@samsung.com, javier.gonz@samsung.com,
        nj.shetty@samsung.com, selvakuma.s1@samsung.com
References: <20210316140126.24900-1-joshi.k@samsung.com>
 <CGME20210316140240epcas5p3e71bfe2afecd728c5af60056f21cc9b7@epcas5p3.samsung.com>
 <20210316140126.24900-4-joshi.k@samsung.com> <20210317085258.GA19580@lst.de>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <149d2bc7-ec80-2e51-7db1-15765f35a27f@kernel.dk>
Date:   Wed, 17 Mar 2021 10:49:28 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210317085258.GA19580@lst.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/17/21 2:52 AM, Christoph Hellwig wrote:
>> +/*
>> + * This is carved within the block_uring_cmd, to avoid dynamic allocation.
>> + * Care should be taken not to grow this beyond what is available.
>> + */
>> +struct uring_cmd_data {
>> +	union {
>> +		struct bio *bio;
>> +		u64 result; /* nvme cmd result */
>> +	};
>> +	void *meta; /* kernel-resident buffer */
>> +	int status; /* nvme cmd status */
>> +};
>> +
>> +inline u64 *ucmd_data_addr(struct io_uring_cmd *ioucmd)
>> +{
>> +	return &(((struct block_uring_cmd *)&ioucmd->pdu)->unused[0]);
>> +}
> 
> The whole typing is a mess, but this mostly goes back to the series
> you're basing this on.  Jens, can you send out the series so that
> we can do a proper review?

I will post it soon, only reason I haven't reposted is that I'm not that
happy with how the sqe split is done (and that it's done in the first
place). But I'll probably just post the current version for comments,
and hopefully we can get it to where it needs to be soon.

-- 
Jens Axboe

