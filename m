Return-Path: <io-uring+bounces-6928-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 39273A4DDD8
	for <lists+io-uring@lfdr.de>; Tue,  4 Mar 2025 13:25:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 685117AC007
	for <lists+io-uring@lfdr.de>; Tue,  4 Mar 2025 12:24:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53C0978F4C;
	Tue,  4 Mar 2025 12:25:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="BR6OUMA1"
X-Original-To: io-uring@vger.kernel.org
Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21DC71FCCEC
	for <io-uring@vger.kernel.org>; Tue,  4 Mar 2025 12:25:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741091131; cv=none; b=kr5QnLY8tE1xo67A3HVA0LoNENjxYASr3NBQb5MoHi5Eo7GGC31qvDbHFcZBrkY3gGL8rSDj6pa1qpCsmtXSNHLg0cIMQ8WU32V3ofvKtKriekuLQJ3DwKpJLWGH2qKS34LRSmSYVT2riliGhQ+pjSpRQXloJAP2IIQzQ8IQt7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741091131; c=relaxed/simple;
	bh=9tAmg4ySK3KHwzyfpiEXvvsVWeOFHOejwpe/zHRu14Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YEohSY4OSxhTeoycRaigofh714yTyd97P6m5qn83G+lucO6iYLuETyHpg7YM31hLS5vx5vWZJo1wfPEtQxaxv0BPV5dMFivmOpi1moEqXro9yl3gN5L6Qu16mvluhWhS1HMQIAU5UqGsJL841UyvoFINOXRZdi8oxqF9gHqLtyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=BR6OUMA1; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=dFQw2LNLNexUgvzLvsoTRucGgPnTDQKQ0VyGysT0EBA=; b=BR6OUMA1Bdw/NQmxN52/GgfjUC
	gfF0U2aHDXdfKfRk0eokNdAyI7dtXRV3Ho4Z7Ruefd+5XdttBfJ36xQZcrsYCpcrZDNIng1TmFsm3
	DXThfve80vdXBuv7l/mv27+8WWYD8GIm9x9QnePtzWlmQlkFl+XdVS6dHfEOCyC7wPsClvo+GjSYE
	zNdCu6MNR5j7OO6tUjWw6xvFTjUdIM3XcOkNE7U6stP8IRTCCyibIaQ5kMgKEyjC5pv8VxXT9OZfp
	E8eW+dCLScjeZXkfGrSzJaw+aHE+yqHmqItWmWwG7KALA/1PHmUAmY8Ep0JSDrpjqC76WlfQvqyAx
	IK9vjjQmA2lUw94sdK5VWk32zb3EXWHhdrxwRS7nXwoKYADSBqXmBXfFsbtgFv4LZTKH/7sH7tQ29
	D6xqx8Jk6t0VxNbH1Y5V82To+8aYskugjGbyUrugPZfTg6j2/CmoP4iYHndBECYvL8ASz5zb8L9AM
	QVmpTJDG/WJV42cI5Bilb/05;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1tpR8V-003JAZ-0P;
	Tue, 04 Mar 2025 12:12:35 +0000
Message-ID: <f5f1571e-d2b9-4675-9bc9-f5bc95fdff3f@samba.org>
Date: Tue, 4 Mar 2025 13:12:34 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/8] Add support for vectored registered buffers
To: Caleb Sander Mateos <csander@purestorage.com>,
 Pavel Begunkov <asml.silence@gmail.com>
Cc: io-uring@vger.kernel.org, Andres Freund <andres@anarazel.de>
References: <cover.1741014186.git.asml.silence@gmail.com>
 <CADUfDZqrXsdnwT=W3HqaVUeegY0jee4G4YztancBfsNBXMKWOg@mail.gmail.com>
Content-Language: en-US, de-DE
From: Stefan Metzmacher <metze@samba.org>
In-Reply-To: <CADUfDZqrXsdnwT=W3HqaVUeegY0jee4G4YztancBfsNBXMKWOg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Pavel,

>> Add registered buffer support for vectored io_uring operations. That
>> allows to pass an iovec, all entries of which must belong to and
>> point into the same registered buffer specified by sqe->buf_index.
>>
>> The series covers zerocopy sendmsg and reads / writes. Reads and
>> writes are implemented as new opcodes, while zerocopy sendmsg
>> reuses IORING_RECVSEND_FIXED_BUF for the api.
>>
>> Results are aligned to what one would expect from registered buffers:
>>
>> t/io_uring + nullblk, single segment 16K:
>>    34 -> 46 GiB/s
>> examples/send-zerocopy.c default send size (64KB):
>>    82558 -> 123855 MB/s
> 
> Thanks for implementing this, it's great to be able to combine these 2
> optimizations! Though I suspect many applications will want to perform
> vectorized I/O using iovecs that come from different registered
> buffers (e.g. separate header and data allocations). Perhaps a future
> improvement could allow a list of buffer indices to be specified.

I'm wondering about the same. And it's not completely
clear to me what the value of iov_base is in this case,
is it the offset into the buffer, or the real pointer address
that must within the range of the registered buffer?

It might also be very useful to have some vector elements pointing
into one of the registered buffer, while others refer to non-registered
buffers.

metze




