Return-Path: <io-uring+bounces-6679-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 57C91A426DD
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2025 16:51:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3569217DA9F
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2025 15:46:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DCE6624A04F;
	Mon, 24 Feb 2025 15:46:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="HJn8QpMa"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44F2C25A2B1
	for <io-uring@vger.kernel.org>; Mon, 24 Feb 2025 15:46:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740412005; cv=none; b=mylsYMkFb21rhr3gSRWrzT61iSz3wYNUegWoz7H4oSJREz3WNYkDHqV/OT9p+impCxXN15gF1AOkKbrMK3ZFARiTJYnBks4Y0AQWrPohl7tcmXcEBHForoXDjsmHdiT2GbW4B9Ju25Mnhvdsy56Pw08R+K25T8QQvffCkhJCvjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740412005; c=relaxed/simple;
	bh=sm7VvH9h9vV7qjXwj3nxJnB6WMM61UW30oZ2bNvUYJ4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kVsltvUz17y5ru4O3sR8LtHmJ6qaNPd0sAkS1d5q6E5dQi39j1sbdP357o919+yJavQ3rz07dElOCps0HN6JmYiWkV9GzY/4BfkbUHKS8QvRtJaFrk7UT60H3yzGLaTE2OdRDGZv+4r3K4kdf95BBtOdZIsR3xogKl/QlZLAUDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=HJn8QpMa; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-22128b7d587so87911765ad.3
        for <io-uring@vger.kernel.org>; Mon, 24 Feb 2025 07:46:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1740412003; x=1741016803; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BA3O/j8wZT6WLWjmkMPFmr6fguBjQbcY9LPqDEZVpFU=;
        b=HJn8QpMaPdTOcjDN0E1mBW6nXyrLzTdLGeuTFRAS80v1VGlz36VxgZ5K7Il+DNEOj7
         Ytej8tS+ucluBkOj94BHP3Cf3cvMf4+FjqZClCPtTYhb8LOIZjTLpzSoSPsPELhO+vmF
         gKdEJWhh7hki5JW/xjKd0ipNrkrPD+JlyXjDD5QbGfUeUJ2T0rqLeEXHq7RNxSxN/gI2
         OnQCKAHSjoK8G68LZF1qvga0idAfH5TR63O11kxs6ewyAuqqGTuzWG1IfnRkXcy9Wyeq
         Ie9uUsqsjLGHwEZvMm4AiOcQR/565vi/wln7uGLBICdKpc7646yLyYKIr6TuMC3Y9G9G
         l0aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740412003; x=1741016803;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BA3O/j8wZT6WLWjmkMPFmr6fguBjQbcY9LPqDEZVpFU=;
        b=bhZl/ukFwEq6dv0QvT4/gkQIOtauZFtxSuu2+NGhytZfdJiy7xUV2jTkRizPSIplbu
         B0UriijtuXOnRYX6w0zBnB0xbej93qroDfG7Wbn61ddL1crPfnh74B0QKe6EduEXZ61a
         zIYgtlaSbS1IzPYmliVgg6qZ7LSXhyccWarDVbZM61mgBeOoEaABYRJMoK7/Iv8fwOf5
         /zp+Ls6maIC2HYxBVPKqbY7FA1L6d14x0lZEGOQ142yCf7p0/gkl7fAND3VHyZHuSJgK
         na7jXXZZqlF2ZMk+RADf2UeQXntzirEiiDz/9zkStlTZUNj4GHAeKwjUT+CP8/oWKMwY
         0O+w==
X-Forwarded-Encrypted: i=1; AJvYcCVy5il40gjDSS1wpNwLcns2inJaD0eSnrqgeXqgL1evk/QABChvzEDIXZYExYg2WVX+AZthIVBQUw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw5pYPQx4WOo6H+qQdGfegQLZsZKe42afCMuTjrix4iwAUVoKWL
	lRXsYHKlodY/2B4qDgSwuDYhzve28mh4k0Rskzsbx4LCnD3aPTOc9yNX5xooq5I=
X-Gm-Gg: ASbGnct6dq8zaPvIvmLZgUFuVezOK/4tto4G49zZB6n278NHkwFm0+/oaPc0Mz6Qhju
	4og8ryON+YLpyPcn7zBhiCPy7gkyFCR+hFuCrhyY9UZnfr2j8O6ENHQ+CwjmcjQ/3BVjxhMAoV5
	DiE6UEl3VQ0eFrPLHdgRpW+KCv9La80hv/89io3HjStjeNlgjX/T8Vy5yjj1B+yTUqwBJbWqor6
	MXEsY2KUl2+F5SuKQroLUvncm486MDCoNA4Mc48gD6PqitOYHl42EliZr7WcBPlCir9B57BW4u3
	7dtpBWQOyQDauoYJGEORZJME0xb31bVWouUCvO3+haLNYFz5UrY5oZn00HZUjFsB
X-Google-Smtp-Source: AGHT+IHg9ZHwNJEnJPivE1xnLDn/mbI60Jqe8KMkwz7IVOFyAJnv5FBleRnodiPg42tjVF0G3IdRSg==
X-Received: by 2002:a17:903:2a8d:b0:211:e812:3948 with SMTP id d9443c01a7336-2219fdcac83mr229064755ad.0.1740412003515;
        Mon, 24 Feb 2025 07:46:43 -0800 (PST)
Received: from ?IPV6:2a03:83e0:1156:1:18cb:90d0:372a:99ae? ([2620:10d:c090:500::6:5f92])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-220d537ca99sm180105905ad.106.2025.02.24.07.46.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Feb 2025 07:46:43 -0800 (PST)
Message-ID: <1d8ad1ae-cda2-4eda-9045-3d973693541f@davidwei.uk>
Date: Mon, 24 Feb 2025 07:46:41 -0800
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/2] io_uring/zcrx: add a read limit to recvzc requests
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, lizetao <lizetao1@huawei.com>
References: <20250224041319.2389785-1-dw@davidwei.uk>
 <20250224041319.2389785-2-dw@davidwei.uk>
 <e8cc3c07-6aa5-4aa0-bd6f-5b054f10287b@gmail.com>
Content-Language: en-GB
From: David Wei <dw@davidwei.uk>
In-Reply-To: <e8cc3c07-6aa5-4aa0-bd6f-5b054f10287b@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 2025-02-24 05:11, Pavel Begunkov wrote:
> On 2/24/25 04:13, David Wei wrote:
>> Currently multishot recvzc requests have no read limit and will remain
>> active so as long as the socket remains open. But, there are sometimes a
>> need to do a fixed length read e.g. peeking at some data in the socket.
>>
>> Add a length limit to recvzc requests `len`. A value of 0 means no limit
>> which is the previous behaviour. A positive value N specifies how many
>> bytes to read from the socket.
>>
>> Data will still be posted in aux completions, as before. This could be
>> split across multiple frags. But the primary recvzc request will now
>> complete once N bytes have been read. The completion of the recvzc
>> request will have res and cflags both set to 0.
> 
> Looks fine, can be improved later.
> 
> Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>
> 
> 
>> Signed-off-by: David Wei <dw@davidwei.uk>
>> ---
>>   io_uring/net.c  | 16 +++++++++++++---
>>   io_uring/zcrx.c | 13 +++++++++----
>>   io_uring/zcrx.h |  2 +-
>>   3 files changed, 23 insertions(+), 8 deletions(-)
> ...
>> diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
>> index f2d326e18e67..9c95b5b6ec4e 100644
>> --- a/io_uring/zcrx.c
>> +++ b/io_uring/zcrx.c
>> @@ -817,6 +817,7 @@ io_zcrx_recv_skb(read_descriptor_t *desc, struct sk_buff *skb,
> ...
>>   static int io_zcrx_tcp_recvmsg(struct io_kiocb *req, struct io_zcrx_ifq *ifq,
>>                   struct sock *sk, int flags,
>> -                unsigned issue_flags)
>> +                unsigned issue_flags, unsigned int *outlen)
>>   {
>> +    unsigned int len = *outlen;
>>       struct io_zcrx_args args = {
>>           .req = req,
>>           .ifq = ifq,
>>           .sock = sk->sk_socket,
>>       };
>>       read_descriptor_t rd_desc = {
>> -        .count = 1,
>> +        .count = len ? len : UINT_MAX,
> 
> typedef struct {
>     ...
>     size_t count;
> } read_descriptor_t;
> 
> Should be SIZE_MAX, but it's not worth of respinning.

I'll send a follow up.

> 

