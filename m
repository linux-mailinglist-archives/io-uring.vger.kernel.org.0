Return-Path: <io-uring+bounces-4128-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B2989B4F95
	for <lists+io-uring@lfdr.de>; Tue, 29 Oct 2024 17:39:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8ED821C210F8
	for <lists+io-uring@lfdr.de>; Tue, 29 Oct 2024 16:39:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 897921CC885;
	Tue, 29 Oct 2024 16:38:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AAtnnpTW"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 230C01D9A51;
	Tue, 29 Oct 2024 16:38:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730219920; cv=none; b=iT5m0USgcFV1buMTGp1Qxr9BiuHfGYbhAdJdVGHcwlVI0rm882ImvZTn4UMe4pkESFMRgHH0R/J+jtpTY6iD+KjiguxgDRWeeUMKjo+IhpeBnf8D4vSNrBj7UPPDF2nBIVR/Kx3hZm9FqE6CRR218l7Vu844C/2TC3r3dBB3LQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730219920; c=relaxed/simple;
	bh=dSQechY7kKZJkZNicyQbJ3cyE+OPqhZQ1obuU+tkcfU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=j9I/8g+XZ2dOOZGBUfSgQ9laQPG5OYPHmVxqN7lfIYwVcuXswFuKc4MQecQ2U9d7+xTVBfuUnMcOUW50gTZsoo3JjJm4ZJ9R2QIhWll9s2dhnTG/b7BzlE6W4jGeY285h2gPAXUvo4ogSBBfkZCeZTlaDL7zjQXjzFtM+rk5/Cc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AAtnnpTW; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-43155afca99so56595e9.1;
        Tue, 29 Oct 2024 09:38:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730219916; x=1730824716; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=cVGyxAIaxcFI0Z/SaAj/2sA3gCvkq4jv863YJyc1V9I=;
        b=AAtnnpTWdHo8BzAvw0n+jIQ0RepEDSBvFrrsU8MyMKPfv3K1WP9A1tJDtpzitHueG5
         6Uovf6DxB8KQw6k2KVYcu4l+acoJJrr4s1o98PKNkoEMHEWTNH+gPS7IKoTDmrVxMZCr
         P8HZXLTZIYs5ZV9UaG7SOvy2BJ0H8CY4vuVLDxmIvRecZCkEFyVeDhx5dpDg/K7Jwles
         A5cbWRcw0JF2b+tCg3ND5DmreH1PPhLf1tqrLoiwHeiOfxrzTmNGdDB54MBIguwS/qRz
         FLsZfn622yRGje+/NwEkiRqYVtWUb+BMta56O0HBsfloL1L3/VIycsnkKAouv7mTsId7
         ZT1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730219916; x=1730824716;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cVGyxAIaxcFI0Z/SaAj/2sA3gCvkq4jv863YJyc1V9I=;
        b=E2T0Ey5zzxOgiwNhEwUWK6DmFiTXNhEqBPhPp/REbyds1LVYYjyOsJ2iE5iiTXNAuG
         7zFcU6onsZSPDQx9BEUnms1SAxy4JpfNSsEsMI/rvb2e/VMcbUgc2QIWtapSZFkJcizF
         iccdki0Vi+WCm7cqfdiPIBC5pwULOaWKPDz9HBGjR/Oweu8thyrIJLtn9lDb47fMbTzH
         SgFnfi9AZIgLF0EfDKC80Up3+3MufPcYnpfmRKxFIaJbDPx6TaicN9mySvUbbLG/EUWz
         My5pg7fizyZYnJkkhkGuOMlL6Xg0/8nG74ZrWXoGqyDMApzH8v7+pUWMg2a8mNKevle3
         QbJw==
X-Forwarded-Encrypted: i=1; AJvYcCUXxT3A0KB++fDh32SDxIcERviC8ydlSgKB/j9vV5JmAZS7o5fz2oO+8qy3oy8aEWiQpxaSqWP3ca5IkA==@vger.kernel.org
X-Gm-Message-State: AOJu0YxgHtXeiet2lBe3QjwXzqO8/LqD5yrkPm9IHXyPgkYbhbu48tNm
	gWgNHWmYsVlsY6Z4873jKnmevyP86ZO4IsudHWg6+6EIoNiyBuG4
X-Google-Smtp-Source: AGHT+IF447NseM2GzhbL85pACWbqOtidpVfM1Qg3JoFEFPvXZWdm+CnKoLkQwDVFvqanl3mXwRgUKw==
X-Received: by 2002:a5d:5d85:0:b0:381:b20b:ff3e with SMTP id ffacd0b85a97d-381b20bffa5mr1781847f8f.26.1730219916265;
        Tue, 29 Oct 2024 09:38:36 -0700 (PDT)
Received: from [192.168.42.53] ([148.252.132.209])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38058b1c65dsm13110992f8f.8.2024.10.29.09.38.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Oct 2024 09:38:36 -0700 (PDT)
Message-ID: <2bcce6c2-29c5-4b36-9840-7db516a40c41@gmail.com>
Date: Tue, 29 Oct 2024 16:38:55 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V8 4/7] io_uring: support SQE group
To: Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org, linux-block@vger.kernel.org,
 Uday Shankar <ushankar@purestorage.com>,
 Akilesh Kailash <akailash@google.com>, Kevin Wolf <kwolf@redhat.com>
References: <20241025122247.3709133-1-ming.lei@redhat.com>
 <20241025122247.3709133-5-ming.lei@redhat.com>
 <5417bcc5-e766-4044-905b-da5768d69f29@kernel.dk> <ZyA_dbiU0ho5IJYA@fedora>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <ZyA_dbiU0ho5IJYA@fedora>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/29/24 01:50, Ming Lei wrote:
> On Mon, Oct 28, 2024 at 06:12:34PM -0600, Jens Axboe wrote:
>> On 10/25/24 6:22 AM, Ming Lei wrote:
>>> SQE group is defined as one chain of SQEs starting with the first SQE that
>>> has IOSQE_SQE_GROUP set, and ending with the first subsequent SQE that
>>> doesn't have it set, and it is similar with chain of linked SQEs.
>>>
>>> Not like linked SQEs, each sqe is issued after the previous one is
>>> completed. All SQEs in one group can be submitted in parallel. To simplify
>>> the implementation from beginning, all members are queued after the leader
>>> is completed, however, this way may be changed and leader and members may
>>> be issued concurrently in future.
>>>
>>> The 1st SQE is group leader, and the other SQEs are group member. The whole
>>> group share single IOSQE_IO_LINK and IOSQE_IO_DRAIN from group leader, and
>>> the two flags can't be set for group members. For the sake of
>>> simplicity, IORING_OP_LINK_TIMEOUT is disallowed for SQE group now.
>>>
>>> When the group is in one link chain, this group isn't submitted until the
>>> previous SQE or group is completed. And the following SQE or group can't
>>> be started if this group isn't completed. Failure from any group member will
>>> fail the group leader, then the link chain can be terminated.
>>>
>>> When IOSQE_IO_DRAIN is set for group leader, all requests in this group and
>>> previous requests submitted are drained. Given IOSQE_IO_DRAIN can be set for
>>> group leader only, we respect IO_DRAIN by always completing group leader as
>>> the last one in the group. Meantime it is natural to post leader's CQE
>>> as the last one from application viewpoint.
>>>
>>> Working together with IOSQE_IO_LINK, SQE group provides flexible way to
>>> support N:M dependency, such as:
>>>
>>> - group A is chained with group B together
>>> - group A has N SQEs
>>> - group B has M SQEs
>>>
>>> then M SQEs in group B depend on N SQEs in group A.
>>>
>>> N:M dependency can support some interesting use cases in efficient way:
>>>
>>> 1) read from multiple files, then write the read data into single file
>>>
>>> 2) read from single file, and write the read data into multiple files
>>>
>>> 3) write same data into multiple files, and read data from multiple files and
>>> compare if correct data is written
>>>
>>> Also IOSQE_SQE_GROUP takes the last bit in sqe->flags, but we still can
>>> extend sqe->flags with io_uring context flag, such as use __pad3 for
>>> non-uring_cmd OPs and part of uring_cmd_flags for uring_cmd OP.
>>
>> Since it's taking the last flag, maybe a better idea to have the last
>> flag mean "more flags in (for example) __pad3" and put the new flag
>> there? Not sure you mean in terms of "io_uring context flag", would it
>> be an enter flag? Ring required to be setup with a certain flag? Neither
>> of those seem super encouraging, imho.
> 
> I meant:
> 
> If "more flags in __pad3" is enabled in future we may claim it as one
> feature to userspace, such as IORING_FEAT_EXT_FLAG.
> 
> Will improve the above commit log.

And we can't take it in either case. The field is in a union, and
other opcodes use that part of the SQE. Enabling a generic feature
for a subset of requests only is not a good idea.

-- 
Pavel Begunkov

