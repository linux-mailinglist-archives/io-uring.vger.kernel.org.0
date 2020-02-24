Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E23B16AF3A
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2020 19:33:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727426AbgBXSdu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 24 Feb 2020 13:33:50 -0500
Received: from mail-io1-f67.google.com ([209.85.166.67]:35166 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726652AbgBXSdu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 24 Feb 2020 13:33:50 -0500
Received: by mail-io1-f67.google.com with SMTP id h8so11340900iob.2
        for <io-uring@vger.kernel.org>; Mon, 24 Feb 2020 10:33:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=LLbWN2bCBNy+632AhXdrrz19FVF7kjb51V4FGwtKiG0=;
        b=NWo1ErFUn1SUZzVKQ/TPSmjUJhpV1Ov5DiDwl2FnG3pAbWQ0cc/VPx2MFvt3LmDYfM
         3MWd4cUoxSCvtQUT8RW7cJMJ9RdJBjRqfWY7trYrYXeCfN/e2XVK5TN072a4xp+b3WIk
         xkPO0GNJlVXTMQ07WpjysHWZJtpAxXvzVR2tbz39FxQjOe8O4BNbDfg2oyymLB1ytBOO
         V/g2q0EoUU7cX0Dr6lLAKQRVa5qBHw7k+qu11m1xmIl7H8qC6/pNzOk3+Wg8ZV3jEajs
         hMlobMZD8F7unmZJM+dP81nk9S1M+gOjSqL1u0RxqgRMpM4/syFQR37M7AtbS3nBsaQn
         fRyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LLbWN2bCBNy+632AhXdrrz19FVF7kjb51V4FGwtKiG0=;
        b=H6U9PV9N/sw7tjN91xie91m8CIhRaXusL+xqeMoNfa24KXbkRAObeYp4tygPmj/uqt
         +r3ad60LwQFw18CDYAOCWnWglEC2rKMU0bWlqjm/2j+lgNYrVi3F1jH3SvWJEskHm2yB
         uhgJWmX8u3NQdE0u9meipfNy/whGFnzr84EuFbZcWzla8VISqJbM1QKIExDsuEHJHk3J
         cAOVrc2n+906RHoperZxVy2xMFNIp88YUg2KpOrGWvhGZg7k+3pSzgomNetcs+GSjoir
         pgvXILvyccuZBuXTz4TGHR5VxEB7O+LaFcGesZ926S2lDCYGFsMrUqw6UEp+rhO4Nr0a
         vR1w==
X-Gm-Message-State: APjAAAXRPrEgiqapP70PWgga8rZr7At8kvBRjzcrr1UD7Exr1mcEdhL0
        GFnvibuZUjVJClYQq+506LZN7qK8dDE=
X-Google-Smtp-Source: APXvYqx0JETfcnB/iNczqqohClx+ev9QC+oA4PUK1oSsGrNdX+k64XzcNsLo/7NxygRcAXFkar89Yg==
X-Received: by 2002:a5e:9748:: with SMTP id h8mr53699555ioq.121.1582569229151;
        Mon, 24 Feb 2020 10:33:49 -0800 (PST)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id h4sm3149506ioq.40.2020.02.24.10.33.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Feb 2020 10:33:48 -0800 (PST)
Subject: Re: [PATCH liburing v5 2/2] test/splice: add basic splice tests
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1582566728.git.asml.silence@gmail.com>
 <aa79d4a192bd1a8e68beddfb177618c1cdacf381.1582566728.git.asml.silence@gmail.com>
 <56c83973-db0f-cc25-4b78-6c9a74431d2a@kernel.dk>
 <060087a8-a6c1-b44c-1b7c-3fc0de3a4a5d@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <12eb524a-cc65-48e1-d82e-5e3d07ff444a@kernel.dk>
Date:   Mon, 24 Feb 2020 11:33:46 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <060087a8-a6c1-b44c-1b7c-3fc0de3a4a5d@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/24/20 11:26 AM, Pavel Begunkov wrote:
> On 24/02/2020 21:23, Jens Axboe wrote:
>> On 2/24/20 10:55 AM, Pavel Begunkov wrote:
>>> +static int copy_single(struct io_uring *ring,
>>> +			int fd_in, loff_t off_in,
>>> +			int fd_out, loff_t off_out,
>>> +			int pipe_fds[2],
>>> +			unsigned int len,
>>> +			unsigned flags1, unsigned flags2)
>>> +{
>>> +	struct io_uring_cqe *cqe;
>>> +	struct io_uring_sqe *sqe;
>>> +	int i, ret = -1;
>>> +
>>> +	sqe = io_uring_get_sqe(ring);
>>> +	if (!sqe) {
>>> +		fprintf(stderr, "get sqe failed\n");
>>> +		return -1;
>>> +	}
>>> +	io_uring_prep_splice(sqe, fd_in, off_in, pipe_fds[1], -1,
>>> +			     len, flags1);
>>> +	sqe->flags = IOSQE_IO_LINK;
>>> +
>>> +	sqe = io_uring_get_sqe(ring);
>>> +	if (!sqe) {
>>> +		fprintf(stderr, "get sqe failed\n");
>>> +		return -1;
>>> +	}
>>> +	io_uring_prep_splice(sqe, pipe_fds[0], -1, fd_out, off_out,
>>> +			     len, flags2);
>>> +
>>> +	ret = io_uring_submit(ring);
>>> +	if (ret <= 1) {
>>> +		fprintf(stderr, "sqe submit failed: %d\n", ret);
>>> +		return -1;
>>> +	}
>>
>> This seems wrong, you prep one and submit, the right return value would
>> be 1. This check should be < 1, not <= 1. I'll make the change, rest
>> looks good to me. Thanks!
>>
> 
> There are 2 sqes, "fd_in -> pipe" and "pipe -> fd_out".

I must be blind... I guess the failure case is that it doesn't work so well
on the kernels not supporting splice, as we'll return 1 there as the first
submit fails. I'll clean up that bit.

-- 
Jens Axboe

