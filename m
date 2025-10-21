Return-Path: <io-uring+bounces-10095-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F2410BF9057
	for <lists+io-uring@lfdr.de>; Wed, 22 Oct 2025 00:13:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A61EF5630D6
	for <lists+io-uring@lfdr.de>; Tue, 21 Oct 2025 22:13:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77DEE299950;
	Tue, 21 Oct 2025 22:13:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="A3M1GiZA"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f41.google.com (mail-io1-f41.google.com [209.85.166.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F76D296BA9
	for <io-uring@vger.kernel.org>; Tue, 21 Oct 2025 22:13:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761084800; cv=none; b=VWKQJ57pWqsRM50IhIqTVBK7Ml8+8xLQ8Q9zBfJodKOMbiT8xzCwlY0AZxhFY3MlhTrubUybzIM/gMfZkKBRr0j0EO991+2lPW+ke7841MDzDMxpdw+/iRUvKTlZ6BK4mWcCZJK4XBOqv6LWTXiTTLVPwBu/LNAc6sghupldeH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761084800; c=relaxed/simple;
	bh=AP7ARTOiIi5YE3ZDHSa+aBoKiMC9aHbtqHXp1+PRGU4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mZK9Oot1YbywgIobs77ydDTdir93A36TkgcAt9dvurclvDgHwNyKaaPQBntUmgxjNO832OVNZv8e6vltciiGlcuDcTu4O+74Y8zZ9fxBvEQjPCWw3Izy7RfrOXVIwFPoquyLKfTEplfnMg0Idp96xSFT7ni+NLOZ9ZRqQ7s9o7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=A3M1GiZA; arc=none smtp.client-ip=209.85.166.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f41.google.com with SMTP id ca18e2360f4ac-93e8d7d177aso127401839f.0
        for <io-uring@vger.kernel.org>; Tue, 21 Oct 2025 15:13:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1761084797; x=1761689597; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ONz7pOY3jOdic6OCLVMtjRJ42T1jXYwo+p4gKBlKtJ4=;
        b=A3M1GiZASbGtrNPG4gcW+6toKEJJzY9cAX9EXSRxLpWQ3Cv7RBa4Q6t2KQ5/DryRDh
         Z9snBZXInZYi3mzMy049hzkayhNYRtCMy5jQKOD6RxaHZNTHF2zvm7LAOjLOSwMaeoNs
         4D2aarRlRh3kOqSNphKacg4o96c3Nh6bO5GkSf+7Ns5necm1DiDdUb8SOIlCmqx/s/fM
         604QuKFlo00Bc/rd1P6K5pgj5u7pdCBca0GCSdlOmKEQuv3dUVOTl9y6++yLigO8z/od
         JnKZvRft2WVSxhCO19LRoP5xSow5c27TB0FWEo2hwn1Ln7aauxgS/N2d1a3ozqBlolSd
         e2rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761084797; x=1761689597;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ONz7pOY3jOdic6OCLVMtjRJ42T1jXYwo+p4gKBlKtJ4=;
        b=SxKKfMUL5S9R9rib+LAoDYGQo6IIwMIOeb5tM5VazMeeOdvbuZxJO9uyLV9qaCSVUH
         INxtRspCE66vlox6jTgpP15X6u9TitqkeJT3FFBjm0HUBHyGHykAdpbDqwgvSmKBVv6Y
         v4SYsb6D8JutoxdLm//UnLIMhRxJN5uvqqt9G7RJqXwg/ISgEMqdIBCFG47GHiMMc1Ag
         F/vneRx+KZyZ4q5w3qkVL2GsJuNOK3fD7WqC2q7xHikFi/h616FUiYAWrgch/YLhZqVi
         TzViKzgjJEeBkSZk1h381qcIJ/trb2BsQWqXgqNednxokKdC5oqxeQ07K0PAasj83DNQ
         93bw==
X-Forwarded-Encrypted: i=1; AJvYcCUyqDiT7H2LRo4dWOToJg8LoURzDYCpAhHfBR0lpAQGRc4SE05myGXlMkBbLMmsqMVQSzOWEQsDWQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YydUPS8HoaiLm2J8sbEcaAO62Di916YJr8SbP6abkP4/N3EOXS6
	QXkBPmNISBQNhzuV99CxW4w4UA1mMBUhqXvz2dcPCxhPc3nkI5aLrj7pl2DETte23Mc=
X-Gm-Gg: ASbGnct/skve3bM2qqY7GHeFVrxbgV2tZQLgjm/09rh8BdWoLSBnxaliA6W3bJI4K0A
	jWRcSg8zecnkV0LIIZlX28lCvIUfh9d9dXzeZjLFAP1c9SNcalG7d2CmpHyQUyKotLNgvHJfs2f
	s4LpyvG8bcAY3YQ0GgExUm1uMwyGPFTR17JdcwxRYdu4iNzitM7jqRShuuXC0NKb81dred8UCRN
	IhEe4kX4KvrP6UwtAJ/QV2vuJDPTvANjTAFGcFcjh56Wv9iVdzCA3I9SaDmEDHPZCG5WAORE40K
	WQNcIPv37J6yfISRsV55pKKFY2iQQjjDGhkH9TRiyHWpK0YgieF27FfgKWldphkKQOBsAc8DMvD
	uSQrxYAn+Xahp5FvciLqi148jEVyQ+qG6lMB7lsTXwoYDK5EHEZYJ/Pj/0WwRNGPFC5uKT+wNi1
	IkdMwjAEGP
X-Google-Smtp-Source: AGHT+IEfFwVGGAL/yOas7wnHXxlJFjUf/Wr7oZhJh5Elg9O/N2OEhLd0Eo0kDXBGDlNqzekk2owDaQ==
X-Received: by 2002:a05:6602:6d8e:b0:92e:298e:eedb with SMTP id ca18e2360f4ac-940ddd85445mr1138226739f.10.1761084797531;
        Tue, 21 Oct 2025 15:13:17 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-93e866ca57bsm449885439f.14.2025.10.21.15.13.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Oct 2025 15:13:16 -0700 (PDT)
Message-ID: <e1b86212-7d57-4224-921c-43fd5a073ca0@kernel.dk>
Date: Tue, 21 Oct 2025 16:13:14 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC] fuse: check if system-wide io_uring is enabled
To: Bernd Schubert <bschubert@ddn.com>, Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
 Pavel Begunkov <asml.silence@gmail.com>,
 Joanne Koong <joannelkoong@gmail.com>, Luis Henriques <luis@igalia.com>
References: <20251021-io-uring-fix-check-systemwide-io-uring-enable-v1-1-01d4b4a8ef4f@ddn.com>
 <fa59bbce-cde5-4780-a18c-1883c3f9ebf9@kernel.dk>
 <2460d0d7-486f-4520-b691-eb189912fade@ddn.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <2460d0d7-486f-4520-b691-eb189912fade@ddn.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

> On 10/21/25 23:56, Jens Axboe wrote:
>> On 10/21/25 2:31 PM, Bernd Schubert wrote:
>>> Add check_system_io_uring() to determine if systee-wide io_uring is
>>> available for a FUSE mount. This is useful because FUSE io_uring
>>> can only be enabled if the system allows it. Main issue with
>>> fuse-io-uring is that the mount point hangs until queues are
>>> initialized. If system wide io-uring is disabled queues cannot
>>> be initialized and the mount will hang till forcefully umounted.
>>> Libfuse solves that by setting up the ring before replying
>>> to FUSE_INIT, but we also have to consider other implementations
>>> and might get easily missed in development.
>>>
>>> When mount specifies user_id and group_id (e.g., via unprivileged
>>> fusermount with s-bit) not equal 0, the permission check must use
>>> the daemon's credentials, not the mount task's (root) credentials.
>>> Otherwise io_uring_allowed() incorrectly allows io_uring due to
>>> root's CAP_SYS_ADMIN capability.
>>
>> Rather than need various heuristics, it'd be a lot better if asking for
>> fuse-io_uring would just not "hang" at mount time and be able to recover
>> better?
> 
> We can consider this as well. Issue is that fuse has a limit on
> background requests that is protected with a lock. And there is lock order
> to handle. Initially I didn't have this hanging mount, until I handled
> this background request limit in fuse-io-uring with the lock order. 
> I.e. when one switches from /dev/fuse read/write to io-uring lock order
> changes.
> A way to avoid that issue is to split the background request limit equally
> between queues. Although I wouldn't like to do that before fallback
> to other queues is possible - which brings its own discussion points
> 
> https://lore.kernel.org/r/20251003-reduced-nr-ring-queues_3-v2-0-742ff1a8fc58@ddn.com

In any case, I do think it's just wrong to both need to add heuristics,
and then still not be able to catch all of the cases where limitations
prevent you from initializing without hanging. That does seem like the
crux of the issue to me, and this more of a work-around than anything
else.

>> There are also other considerations that may mean that part of init will
>> fail, doesn't seem like the best idea to me to attempt to catch all of
>> this rather than just be able to gracefully handle errors at
>> initialization time.
> 
> It is still doesn't seem to be right to me that fuse advertizes io-uring
> in FUSE_INIT to the daemon, when system wide io-uring is disabled.

On the surface, I agree. But I don't think you can catch all the cases
anyway, or if you could, it'd be fragile and may change. And then it's
just a bit of false pretense. I'd just view it as a "the kernel supports
the feature", which is true.

-- 
Jens Axboe

