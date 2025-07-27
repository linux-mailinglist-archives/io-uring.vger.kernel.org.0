Return-Path: <io-uring+bounces-8803-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A4F0B12DCC
	for <lists+io-uring@lfdr.de>; Sun, 27 Jul 2025 07:50:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 546577A6029
	for <lists+io-uring@lfdr.de>; Sun, 27 Jul 2025 05:48:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2390E145B3F;
	Sun, 27 Jul 2025 05:49:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=apple.com header.i=@apple.com header.b="fn/7ZbCi"
X-Original-To: io-uring@vger.kernel.org
Received: from rn-mx01.apple.com (rn-mx01.apple.com [17.132.108.0])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C74B1F95C
	for <io-uring@vger.kernel.org>; Sun, 27 Jul 2025 05:49:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=17.132.108.0
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753595398; cv=none; b=uIG/GXdiHCzkjRPFSknadx/2/SMX0AnNaWxWkcq/XITQmSUKnN8z7bfR9J8aln+W1hsF+keYgkqOI6wyMeSHXIyxLt03MSj51oXGxBlc0wTJa/M8Z3r5TqLllobzqQhBA+hJDpLHGWfdv9gQFcml1MiTSiWbLRokbT4Faxkszss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753595398; c=relaxed/simple;
	bh=xZrJhvrO8tSXHjybRo8myinUt7nq6LF/g9xFeNSSdyQ=;
	h=Content-type:MIME-version:Subject:From:In-reply-to:Date:Cc:
	 Message-id:References:To; b=gvjQb57s8nYw9n9R0/Bb3c/0sVc8GE57oGe5nOGh/wOFg23j5de+P5FG5W2IgBsC1lPc3Cm0JjOlBEa4PcJeEgxbRAJ4sAZnZESXL8KkVRnAbj0xVKUVYuVsVLADeOOCOunm/goQQ63CyjQAjv+Bj/RX6SaKZgu9XnKazgc8lDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=apple.com; spf=pass smtp.mailfrom=apple.com; dkim=pass (2048-bit key) header.d=apple.com header.i=@apple.com header.b=fn/7ZbCi; arc=none smtp.client-ip=17.132.108.0
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=apple.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=apple.com
Received: from mr55p01nt-mtap05.apple.com
 (mr55p01nt-mtap05.apple.com [10.170.185.195]) by mr55p01nt-mxp01.apple.com
 (Oracle Communications Messaging Server 8.1.0.27.20250130 64bit (built Jan 30
 2025)) with ESMTPS id <0T011YAATK32K100@mr55p01nt-mxp01.apple.com> for
 io-uring@vger.kernel.org; Sun, 27 Jul 2025 04:49:50 +0000 (GMT)
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-27_02,2025-07-24_01,2025-03-28_01
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=apple.com; h=cc :
 content-transfer-encoding : content-type : date : from : in-reply-to :
 message-id : mime-version : references : subject : to; s=20180706;
 bh=2T6q0UXG/+v9zjZRpYuxUy2pQcR8QEqdDCnvyxdHRsk=;
 b=fn/7ZbCi2NTXY3PkI6cNLW5wKxMsASIbhOyOyhqTvir0jEwLo34VwyODD8JbIotgph9z
 +2JInDcFTEg7LmSyUncnMch5j+ze2EihPB3pUZ1khemaxPX858DX1U7NVj3HoBrsU3rx
 nn+Fuoh16/YcFp4IXhEeOF7ftu6IX4mvYxXKyOHuMp9L/8Jp44dt9KA7PS3PDBNSINTS
 55PSnQK82TZceybMmqJdWnIezCtXiOX89UXIrhorCzRaS4pk5xVt82D6OKVsSFgtTjBf
 gjy8BQF4reRs0BQot0YKtQSmXahAf07A93JR7XJWqTwyC2iRQ7k7sGbz624T9fMLlM1/ 8Q==
Received: from mr55p01nt-mmpp05.apple.com
 (mr55p01nt-mmpp05.apple.com [10.170.185.201]) by mr55p01nt-mtap05.apple.com
 (Oracle Communications Messaging Server 8.1.0.27.20250130 64bit (built Jan 30
 2025)) with ESMTPS id <0T012BG14K32F420@mr55p01nt-mtap05.apple.com>; Sun,
 27 Jul 2025 04:49:50 +0000 (GMT)
Received: from process_milters-daemon.mr55p01nt-mmpp05.apple.com by
 mr55p01nt-mmpp05.apple.com
 (Oracle Communications Messaging Server 8.1.0.27.20250130 64bit (built Jan 30
 2025)) id <0T0120200JSBYC00@mr55p01nt-mmpp05.apple.com>; Sun,
 27 Jul 2025 04:49:50 +0000 (GMT)
X-Va-A:
X-Va-T-CD: b2a1b406627e92422e591dd6a6e430db
X-Va-E-CD: 7dad28dc0eaf0341dbd15fcb6b4ff50d
X-Va-R-CD: 0d12db3b668e318dce88f6c15ddcb773
X-Va-ID: d480bea0-5faa-4357-9156-0569c940f7d7
X-Va-CD: 0
X-V-A:
X-V-T-CD: b2a1b406627e92422e591dd6a6e430db
X-V-E-CD: 7dad28dc0eaf0341dbd15fcb6b4ff50d
X-V-R-CD: 0d12db3b668e318dce88f6c15ddcb773
X-V-ID: 6184ea3e-f392-4d6c-9158-aab146b6b78c
X-V-CD: 0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-27_02,2025-07-24_01,2025-03-28_01
Received: from smtpclient.apple (unknown [17.11.14.39])
 by mr55p01nt-mmpp05.apple.com
 (Oracle Communications Messaging Server 8.1.0.27.20250130 64bit (built Jan 30
 2025)) with ESMTPSA id <0T012011GK313P00@mr55p01nt-mmpp05.apple.com>; Sun,
 27 Jul 2025 04:49:50 +0000 (GMT)
Content-type: text/plain; charset=utf-8
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-version: 1.0 (Mac OS X Mail 16.0 \(3826.600.51.1.1\))
Subject: Re: [PATCH] io_uring/net: Allow to do vectorized send
From: Norman Maurer <norman_maurer@apple.com>
In-reply-to: <9d13f0b8-e224-40ed-acb3-0dcd50f94ddd@kernel.dk>
Date: Sat, 26 Jul 2025 18:49:38 -1000
Cc: io-uring@vger.kernel.org
Content-transfer-encoding: quoted-printable
Message-id: <BBF14DA5-76EE-4E73-86B1-9F7EA392A2D6@apple.com>
References: <20250724051643.91922-1-norman_maurer@apple.com>
 <9d13f0b8-e224-40ed-acb3-0dcd50f94ddd@kernel.dk>
To: Jens Axboe <axboe@kernel.dk>
X-Mailer: Apple Mail (2.3826.600.51.1.1)



> On Jul 24, 2025, at 4:49=E2=80=AFAM, Jens Axboe <axboe@kernel.dk> =
wrote:
>=20
> On 7/23/25 11:16 PM, norman.maurer@googlemail.com wrote:
>> From: Norman Maurer <norman_maurer@apple.com>
>>=20
>> At the moment you have to use sendmsg for vectorized send. While this
>> works it's suboptimal as it also means you need to allocate a struct
>> msghdr that needs to be kept alive until a submission happens. We can
>> remove this limitation by just allowing to use send directly.
>=20
> Looks pretty clean, just a few minor comments below. For the commit
> message above, you should wrap it at ~72 chars.

Will do in a v2=E2=80=A6

>=20
>> diff --git a/include/uapi/linux/io_uring.h =
b/include/uapi/linux/io_uring.h
>> index b8a0e70ee2fd..6957dc539d83 100644
>> --- a/include/uapi/linux/io_uring.h
>> +++ b/include/uapi/linux/io_uring.h
>> @@ -392,12 +392,16 @@ enum io_uring_op {
>>  * the starting buffer ID in cqe->flags as per
>>  * usual for provided buffer usage. The buffers
>>  * will be contiguous from the starting buffer ID.
>> + *
>> + * IORING_SEND_VECTORIZED If set, SEND[_ZC] will take a pointer to a =
io_vec
>> + * to allow vectorized send operations.
>>  */
>> #define IORING_RECVSEND_POLL_FIRST (1U << 0)
>> #define IORING_RECV_MULTISHOT (1U << 1)
>> #define IORING_RECVSEND_FIXED_BUF (1U << 2)
>> #define IORING_SEND_ZC_REPORT_USAGE (1U << 3)
>> #define IORING_RECVSEND_BUNDLE (1U << 4)
>> +#define IORING_SEND_VECTORIZED (1U << 5)
>=20
> Do we want to support this on the recv side too? I guess that can be
> added later and IORING_RECV_VECTORIZED can just be defined to
> IORING_SEND_VECTORIZED in that case.

I think we can do this a follow if we want too..

>=20
>> diff --git a/io_uring/net.c b/io_uring/net.c
>> index ba2d0abea349..d4a59f5461ed 100644
>> --- a/io_uring/net.c
>> +++ b/io_uring/net.c
>> @@ -420,6 +424,9 @@ int io_sendmsg_prep(struct io_kiocb *req, const =
struct io_uring_sqe *sqe)
>> sr->flags =3D READ_ONCE(sqe->ioprio);
>> if (sr->flags & ~SENDMSG_FLAGS)
>> return -EINVAL;
>> +        if (req->opcode !=3D IORING_OP_SEND && req->opcode !=3D =
IORING_OP_SEND_ZC && sr->flags & IORING_SEND_VECTORIZED)
>> +                return -EINVAL;
>> +
>=20
> if (req->opcode =3D=3D IORING_OP_SENDMSG && sr->flags & =
IORING_SEND_VECTORIZED)
> return -EINVAL;
>=20
> ?

Sure works for me=E2=80=A6 Just wanted to make it more explicit but I =
can change it as part of a v2.

>=20
> --=20
> Jens Axboe


