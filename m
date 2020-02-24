Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29D4F16AF75
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2020 19:42:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727736AbgBXSmD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 24 Feb 2020 13:42:03 -0500
Received: from mail-io1-f65.google.com ([209.85.166.65]:40235 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727426AbgBXSmD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 24 Feb 2020 13:42:03 -0500
Received: by mail-io1-f65.google.com with SMTP id x1so11326816iop.7
        for <io-uring@vger.kernel.org>; Mon, 24 Feb 2020 10:42:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=tjHFEgpJvfWVSPhmnkum+hhTAu1SXcz2WXEk1dX9ik8=;
        b=YnLfyfk6DV9AG5fOdUHG3JfOO42OSOz+JPSX51u4xU+kPw9PYPSjRvjElfF1Bem/+m
         6xJUcTzH/1LdxYq5W0YjRb+C/Pc0mfgMjdKg/uI6N5uAao5nfjV1xJkJrTHy0KD8Agvw
         OxgKEIONXaxl/zzKlhL1Awuwvcaeo4xOTMvvIqe0rUl+acZCvfJJ4gYEy/0LyLFWtXpb
         U361pmpF6VwaqtiU6Q4P0JEwuRo4QdggMyd8hZ+1OAFoM1PKgtn7rLFJSzgabE/yNLGM
         iygrIdJVgpRoaWu+CIbRgnOLAT1dml+ObdAxof4q3szPGIGB4jRKvDMyOybkuXx9EviU
         /FtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tjHFEgpJvfWVSPhmnkum+hhTAu1SXcz2WXEk1dX9ik8=;
        b=ZbXPO4GTnKw2FLac5jVBFXwvzeAQv6jkf3Rw47dYd82RoH80f1BXsxMF8Z0ksLnIY2
         cziPoKii8P4dC3ZCsxdBJsUJQy7I84Lig0n3G/+JisZlVD9VuUd1QD4VFtuiwcHn9vUE
         lvi9F65+OIimv4zeOAIDJ2cBhbiYVdlHK5l2l05sWCao+YTG5qPm3LpRPwW7yEa/xRyB
         oJRZAcuWLgtDryOn1Dfo3QCx2f+j+6wVo3mPI39sUfZbguKrsL1qdkcYRLz9B4SowIaz
         p9Ox8j2ohJT+uFx3iAfcQSj1sD3NDIbGHq/Z0O2ucBWok/WF4mS8VkW9OaBsWwvJBsKr
         +Fzw==
X-Gm-Message-State: APjAAAWAPQ7FHMBxPql/NJNnE3kWQ1Puk4z5MD/Uq9xk8o6barujbYCm
        iCQ62trDY7jO7rNpFgoDJ1d4IYIT76A=
X-Google-Smtp-Source: APXvYqzR1Vssb/eQMJ/Tc0yQaV4kiD7Aw3Dpjmt7g8uypCC+iJ9KgHRpNrjqsatw3g5/qrtIp2G43A==
X-Received: by 2002:a5d:9a85:: with SMTP id c5mr51808350iom.266.1582569722365;
        Mon, 24 Feb 2020 10:42:02 -0800 (PST)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id v63sm4610427ill.72.2020.02.24.10.42.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Feb 2020 10:42:01 -0800 (PST)
Subject: Re: [PATCH liburing v5 2/2] test/splice: add basic splice tests
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1582566728.git.asml.silence@gmail.com>
 <aa79d4a192bd1a8e68beddfb177618c1cdacf381.1582566728.git.asml.silence@gmail.com>
 <56c83973-db0f-cc25-4b78-6c9a74431d2a@kernel.dk>
 <060087a8-a6c1-b44c-1b7c-3fc0de3a4a5d@gmail.com>
 <12eb524a-cc65-48e1-d82e-5e3d07ff444a@kernel.dk>
 <20e51d15-82d8-3e91-a1ca-36dccd9d30e7@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <89272517-d4c4-1a0f-f955-af2b1c1a337f@kernel.dk>
Date:   Mon, 24 Feb 2020 11:41:59 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20e51d15-82d8-3e91-a1ca-36dccd9d30e7@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/24/20 11:39 AM, Pavel Begunkov wrote:
> On 24/02/2020 21:33, Jens Axboe wrote:
>> On 2/24/20 11:26 AM, Pavel Begunkov wrote:
>>> On 24/02/2020 21:23, Jens Axboe wrote:
>>>> On 2/24/20 10:55 AM, Pavel Begunkov wrote:
>>>>> +static int copy_single(struct io_uring *ring,
>>>>> +			int fd_in, loff_t off_in,
>>>>> +			int fd_out, loff_t off_out,
>>>>> +			int pipe_fds[2],
>>>>> +			unsigned int len,
>>>>> +			unsigned flags1, unsigned flags2)
>>>>> +{
>>>>> +	struct io_uring_cqe *cqe;
>>>>> +	struct io_uring_sqe *sqe;
>>>>> +	int i, ret = -1;
>>>>> +
>>>>> +	sqe = io_uring_get_sqe(ring);
>>>>> +	if (!sqe) {
>>>>> +		fprintf(stderr, "get sqe failed\n");
>>>>> +		return -1;
>>>>> +	}
>>>>> +	io_uring_prep_splice(sqe, fd_in, off_in, pipe_fds[1], -1,
>>>>> +			     len, flags1);
>>>>> +	sqe->flags = IOSQE_IO_LINK;
>>>>> +
>>>>> +	sqe = io_uring_get_sqe(ring);
>>>>> +	if (!sqe) {
>>>>> +		fprintf(stderr, "get sqe failed\n");
>>>>> +		return -1;
>>>>> +	}
>>>>> +	io_uring_prep_splice(sqe, pipe_fds[0], -1, fd_out, off_out,
>>>>> +			     len, flags2);
>>>>> +
>>>>> +	ret = io_uring_submit(ring);
>>>>> +	if (ret <= 1) {
>>>>> +		fprintf(stderr, "sqe submit failed: %d\n", ret);
>>>>> +		return -1;
>>>>> +	}
>>>>
>>>> This seems wrong, you prep one and submit, the right return value would
>>>> be 1. This check should be < 1, not <= 1. I'll make the change, rest
>>>> looks good to me. Thanks!
>>>>
>>>
>>> There are 2 sqes, "fd_in -> pipe" and "pipe -> fd_out".
>>
>> I must be blind... I guess the failure case is that it doesn't work so well
>> on the kernels not supporting splice, as we'll return 1 there as the first
> 
> I've wanted for long to kill this weird behaviour, it should consume the whole
> link. Can't imagine any userspace app handling all edge-case errors right...

Yeah, for links it makes sense to error the chain, which would consume
the whole chain too.

>> submit fails. I'll clean up that bit.
> 
> ...I should have tested better. Thanks!

No worries, just trying to do better than we have in the best so we can
have some vague hope of having the test suite pass on older stable
kernels.

-- 
Jens Axboe

