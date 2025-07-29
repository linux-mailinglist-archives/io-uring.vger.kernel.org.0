Return-Path: <io-uring+bounces-8861-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D19CB151C8
	for <lists+io-uring@lfdr.de>; Tue, 29 Jul 2025 19:00:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 747ED166BF3
	for <lists+io-uring@lfdr.de>; Tue, 29 Jul 2025 17:00:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC04B149C4D;
	Tue, 29 Jul 2025 17:00:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="HixE0ysf"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A4EA757EA
	for <io-uring@vger.kernel.org>; Tue, 29 Jul 2025 17:00:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753808438; cv=none; b=s+rUoQ3p0fmGL42XM2wr+RIbnr2oxe4JfQbxR+O9DtEUgIOSNtHjuLr/JNc9dFKxths7/sp1OnJUuehHT/dWYt4wlosf1D+Z/qm14ehXGoIyWhFtBxctBqMdMIzuALLZu8YDVIeq0grzf6b/T41odcdqIHFWx879GxXL3YOGq5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753808438; c=relaxed/simple;
	bh=xzpjlascUXwVxOvfxnC+WNW9UVXk2ZQ51IQvIkywdek=;
	h=Content-Type:From:Mime-Version:Subject:Date:Message-Id:References:
	 Cc:In-Reply-To:To; b=m5V+k/BD16WNj5HiEXMY4nXTaMLjiQ6vIdQFk6pP4WzGkVHvAfztT2Mol0Tr7rJbrXgcZ3+TxG6HJDi+DQwBbPbzw0pBfDlMfcG8AXo+lQAIVS4KYkALmLtDJGpga45twcOnDzkWW8bug8BuDrSgkDlLm7sfIVkD6rAHqGDXcx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=HixE0ysf; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-76858e9e48aso2083707b3a.2
        for <io-uring@vger.kernel.org>; Tue, 29 Jul 2025 10:00:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1753808436; x=1754413236; darn=vger.kernel.org;
        h=to:in-reply-to:cc:references:message-id:date:subject:mime-version
         :from:content-transfer-encoding:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dXS+YMzEG8j2phfNCq1AVaPhW1ss87j+i4kNTPlT7Eo=;
        b=HixE0ysfzu3twJfmvuMZm4JqrPpkUHSys3u/c3LXW7ylFSqJ/1p7VKiQAee0hJt7Yx
         bxMl3xjybHNF6beEYI8gyXC1vWwiNc1ZxqjKE8MhAYXDyuO8R6asRhGcgD8yDqIkPXTa
         ifjlkijJgMa8BACittA2peHQmbno3+1fuUSljL7HOmCOZuRA4b5hzkWqk5nfSlFdatBq
         y8+rHKCvA2qBc7tUR/+QoYGe4T/I4kA6rrH/P9BoJpbdN8gNmjjWHIyaNckLXEm4YJt/
         NBa/qQOpW30w5ze3yxPrgsmctkoGHFvYQemH8dFb0CpaTUuXiu2L4sVDjqn5V3zghwHb
         T4Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753808436; x=1754413236;
        h=to:in-reply-to:cc:references:message-id:date:subject:mime-version
         :from:content-transfer-encoding:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dXS+YMzEG8j2phfNCq1AVaPhW1ss87j+i4kNTPlT7Eo=;
        b=Aa7NnccjWIXMFZmDStCW0ByTqTSSBgjm093/TGWgdaLaS62MZBsfG/Obw3kqGW6K/J
         tVypudpd1U6gunx9S5gVmCnv0KuMdgY9uGgmTFcfuXI3nkMnDSbz4aXO4hLACe3eI8pR
         HFBnT7I2WRtoYxgBED3FlIWBwgxMPQ39Tn+yBAf83unrLfZjizdsCPtNGz+AGZDlsiMs
         yhs/wVyary4QFIAm4vDBkq6UHOcS3t2Ylbqbkphiuoe67y1jIjM+grHyI/NfWdbnqaCK
         HtcE+NNwyVju1CDMStbWGT9GBXYoJz7FPqDJIEP6q5qPpu2ZdqO9cIzGiWr/X5E2qkCH
         Rx2w==
X-Gm-Message-State: AOJu0YyRrfsxlb61C+1p4MR3EYBQQxycfxpQql7jrqas38HOHGMc80gB
	3cypKakGcYjtsMSSAQ+gNqTaccWinNcpxRXHMSon7L3xKCMc3fD7c3frIsBqnC1a
X-Gm-Gg: ASbGnctJ1pAuRse3VsGmrvuDBNLGcHCKhG6h9D8z54G9wgYASpodVqBtOnPhelzckFX
	W/c2irt9nsHs7Cl1YCgZImV+QEey86c741MDPYUS4EkGsNWaD7vPufVwPfvjk8xoxsUiofqxrJk
	++9EOCRonf//uRhh43oZaYrJIFkEz9YZVNcLug63qU6JTVsytiwFIMRs93Adf3dFPXDeBEjss8g
	JeY7Ffl4OTz24HadO68XRnOWrOC6u5TIqbaXZp6XdXk7PEUx898Ge5W+HTPcBACJm9DfyIBnlAZ
	1ZG+Wt8C6dUCaqqAPD4fT+otFrvlt8d3exkOK1SzNhytKpQbEMSgJyVJ6jRle8ZAaGnTNEMDZks
	RoCWrEHLYYs4d2poCYUEb43gJopV8OBxt/25PA85m7EGDplPXCn1QPLXF47X8YkRuHpPo9T1uNk
	jtmZC2yVbTLDiBag==
X-Google-Smtp-Source: AGHT+IFzpEAylFIU55nk4EIuZwv3KB3DtffAkhmO1mnOsM+gOtAhml59L85RVI6w/FYwCVhgFW/LGg==
X-Received: by 2002:a05:6a00:949c:b0:759:4c66:9917 with SMTP id d2e1a72fcca58-76ab30cd7e7mr551279b3a.20.1753808434370;
        Tue, 29 Jul 2025 10:00:34 -0700 (PDT)
Received: from smtpclient.apple (syn-072-130-199-032.res.spectrum.com. [72.130.199.32])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7640b2de006sm7892297b3a.108.2025.07.29.10.00.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Jul 2025 10:00:34 -0700 (PDT)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From: Norman Maurer <norman.maurer@googlemail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH v3] io_uring/net: Allow to do vectorized send
Date: Tue, 29 Jul 2025 07:00:22 -1000
Message-Id: <4D6BAE51-ECCB-4459-A579-B1419B201249@googlemail.com>
References: <9cb63fda-89b8-46f6-b316-24550150cf7e@kernel.dk>
Cc: io-uring@vger.kernel.org, Norman Maurer <norman_maurer@apple.com>
In-Reply-To: <9cb63fda-89b8-46f6-b316-24550150cf7e@kernel.dk>
To: Jens Axboe <axboe@kernel.dk>
X-Mailer: iPhone Mail (22G77)



> Am 29.07.2025 um 02:15 schrieb Jens Axboe <axboe@kernel.dk>:
>=20
> =EF=BB=BFOn 7/29/25 12:59 AM, norman.maurer@googlemail.com wrote:
>> From: Norman Maurer <norman_maurer@apple.com>
>>=20
>> At the moment you have to use sendmsg for vectorized send.
>> While this works it's suboptimal as it also means you need to
>> allocate a struct msghdr that needs to be kept alive until a
>> submission happens. We can remove this limitation by just
>> allowing to use send directly.
>>=20
>> Signed-off-by: Norman Maurer <norman_maurer@apple.com>
>> ---
>> Changes since v1: Simplify flag check and fix line length of commit messa=
ge
>> Changes since v2: Adjust SENDMSG_FLAGS =20
>>=20
>> ---
>> include/uapi/linux/io_uring.h | 4 ++++
>> io_uring/net.c                | 9 ++++++++-
>> 2 files changed, 12 insertions(+), 1 deletion(-)
>>=20
>> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.=
h
>> index b8a0e70ee2fd..6957dc539d83 100644
>> --- a/include/uapi/linux/io_uring.h
>> +++ b/include/uapi/linux/io_uring.h
>> @@ -392,12 +392,16 @@ enum io_uring_op {
>>  *                the starting buffer ID in cqe->flags as per
>>  *                usual for provided buffer usage. The buffers
>>  *                will be    contiguous from the starting buffer ID.
>> + *
>> + * IORING_SEND_VECTORIZED    If set, SEND[_ZC] will take a pointer to a i=
o_vec
>> + *                to allow vectorized send operations.
>>  */
>> #define IORING_RECVSEND_POLL_FIRST    (1U << 0)
>> #define IORING_RECV_MULTISHOT        (1U << 1)
>> #define IORING_RECVSEND_FIXED_BUF    (1U << 2)
>> #define IORING_SEND_ZC_REPORT_USAGE    (1U << 3)
>> #define IORING_RECVSEND_BUNDLE        (1U << 4)
>> +#define IORING_SEND_VECTORIZED        (1U << 5)
>>=20
>> /*
>>  * cqe.res for IORING_CQE_F_NOTIF if
>> diff --git a/io_uring/net.c b/io_uring/net.c
>> index ba2d0abea349..3ce5478438f0 100644
>> --- a/io_uring/net.c
>> +++ b/io_uring/net.c
>> @@ -382,6 +382,10 @@ static int io_send_setup(struct io_kiocb *req, const=
 struct io_uring_sqe *sqe)
>>    }
>>    if (req->flags & REQ_F_BUFFER_SELECT)
>>        return 0;
>> +
>> +    if (sr->flags & IORING_SEND_VECTORIZED)
>> +               return io_net_import_vec(req, kmsg, sr->buf, sr->len, ITE=
R_SOURCE);
>> +
>>    return import_ubuf(ITER_SOURCE, sr->buf, sr->len, &kmsg->msg.msg_iter)=
;
>> }
>>=20
>> @@ -409,7 +413,7 @@ static int io_sendmsg_setup(struct io_kiocb *req, con=
st struct io_uring_sqe *sqe
>>    return io_net_import_vec(req, kmsg, msg.msg_iov, msg.msg_iovlen, ITER_=
SOURCE);
>> }
>>=20
>> -#define SENDMSG_FLAGS (IORING_RECVSEND_POLL_FIRST | IORING_RECVSEND_BUND=
LE)
>> +#define SENDMSG_FLAGS (IORING_RECVSEND_POLL_FIRST | IORING_RECVSEND_BUND=
LE | IORING_SEND_VECTORIZED)
>>=20
>> int io_sendmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)=

>> {
>> @@ -420,6 +424,9 @@ int io_sendmsg_prep(struct io_kiocb *req, const struc=
t io_uring_sqe *sqe)
>>    sr->flags =3D READ_ONCE(sqe->ioprio);
>>    if (sr->flags & ~SENDMSG_FLAGS)
>>        return -EINVAL;
>> +    if (req->opcode =3D=3D IORING_OP_SENDMSG && sr->flags & IORING_SEND_=
VECTORIZED)
>> +        return -EINVAL;
>> +
>>    sr->msg_flags =3D READ_ONCE(sqe->msg_flags) | MSG_NOSIGNAL;
>>    if (sr->msg_flags & MSG_DONTWAIT)
>>        req->flags |=3D REQ_F_NOWAIT;
>=20
> I think this looks simple enough, but after pondering this a bit, I also
> think we can just skip the check right above here. OP_SENDMSG is, by
> definition, working on IORING_SEND_VECTORIZED data. Hence returning
> -EINVAL from that seems a bit redundant. Maybe just delete this hunk?
> What do you think?

Works for me=20

>=20
> No need for v3 for that, I can just edit out that hunk with a note. I'll
> run some testing today.

Thanks! Looking forward to hear back on the results=20

>=20
> --
> Jens Axboe

Bye
Norman=20=

