Return-Path: <io-uring+bounces-4520-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 352009BFF07
	for <lists+io-uring@lfdr.de>; Thu,  7 Nov 2024 08:26:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E8A812831E4
	for <lists+io-uring@lfdr.de>; Thu,  7 Nov 2024 07:26:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF5A5198A0F;
	Thu,  7 Nov 2024 07:26:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iSovhelU"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E51A8198840;
	Thu,  7 Nov 2024 07:26:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730964405; cv=none; b=VafUqt8pLP1iyhtDT7zdDd+VzuyXTyO1w3VEWoKyDTfmy7GWAsUo5qg09xnIyHYtHLvQYP10vCRYSjWKCItTXEH3S3DoWCX53z4LxXEgAs0PafKksrF0W7DA2OIuxjt2couNWQ/WHvJBNs7IKtPD6rCUWWd6d0CN638dtqHIDxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730964405; c=relaxed/simple;
	bh=frNK5641T9qn3TdM3yOMYN7IZTrIVYD34gG0mvWCMAU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=J1xQsizn1NGIKQqTavMNI/vRlSwCNPb4oByFM5AJ3rYwg1qiNAspgm8t/gjSlaIdjaEbRZupajM5hk18iNNcylw1sNvHHZX2SjNDbQSotYoRtRlD5AEPQBYaJWLadUBAMhxa0Hn8nSidz+Gej4qgKoLSAiFOdw3/zoJeyBLNj7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iSovhelU; arc=none smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-5c96b2a10e1so762042a12.2;
        Wed, 06 Nov 2024 23:26:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730964401; x=1731569201; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QTcYDh6w3WSbtss1ZztiWPAsLIjMqzVuMVfuZwTMWrs=;
        b=iSovhelUZK0MPzgrRnovuPJRQ3TF6LAOK4HC18BZBOkjYZnkVT9cawfECPEBB4V0B5
         iRBPTYEXxuTKGjtoq1wQKIuawhjw7IK548r3uOxGTS4puxK7gdsGQSrwL4BztqyPT/x1
         7+JaT1ySyIPIZ/Cpz1mQe4hSCIsq8MTcGo8v37OLZDYFDGDa8/261exWWkWvPMdqwejj
         9ks/6o0UzM6jkXFMo0eRgrI5fz2sciVUn75hSloxDZ+AUqtMEC+3zz312bQbZDJauNTK
         aAVmVcAOX1wQAgZEcLAt71a9GzTdhqRkFEwaLeRV/TuNF52UdYlgv8ZXAuxKCC37QLDP
         CocA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730964401; x=1731569201;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QTcYDh6w3WSbtss1ZztiWPAsLIjMqzVuMVfuZwTMWrs=;
        b=dwuVVN4p5CmAFQmvXe4hkaDH65YyuIZiG/HBmr7xYv/pMPpYlXNppCQ/FIFjGjySGz
         ncYZFT2AvK5+VZRoyzCoimn4+GTqZkV4docuIgJS2ALTkzwKirKE6+zvDlYTFPAeY8mq
         qm8E/0X4mNj+w5aT9AFRvf05fMz/eLQGkAYr79eh4E93JSrKLipFngEAIKDVMuglWepQ
         Ex1JCBmVoUUB5o/4nUbEbDel8zPBl+xPLf8EGbx/BZwvmCJpfQ6HVpgq2OfsTuhrNY2L
         mZ8zgPV8+xGfpQPHp34/nud1qYY9UYBgOLsBATYCDcqLN0OivKqsIgYVvFUzDBEpvS6/
         qXog==
X-Forwarded-Encrypted: i=1; AJvYcCUDsLiU7/d/ASDuEXSO/QYGyzoI+46IkaNIzAAcElZv40pLVyu4f/e3zLPGG3YU5m6saz/sAFA4cyq9kg/+uw==@vger.kernel.org, AJvYcCVSxPALjg5826A/oAIYX2z/PSfnTWMA8eeKEqylKPgY5w65oOZqq/KfPddU3Y1Kk3QASapyR+UvtA==@vger.kernel.org, AJvYcCXA9JaSTh78H/78eNKpWdYEFqRc9SDpvShnNfaKrc1oguKjGbMoRWqbL3AFpDmSmKuLP/eJ6KokAT2Ebw==@vger.kernel.org, AJvYcCXWsnoEQfAreCS3jedl6sneVguIgCvOhZaYOwbGpkdBMER42MS/Q8pAN1N0LoVYpQkSG+DkqoNBlMC31uQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YzA1mASEiHyn66/wqrd5Z33CwfSh3aGwbf8vBejD1o92JXZcVXq
	4YEmlozze6UULCCs/QY/WcEk8IhovjSfXFlsZ+N/LWA6by03Ks7cU8mbWwDk9QgR0Ogzn/OaHWk
	JOk8iytUA2A9aF+EP+DJGJhN8kyfKGH0aeA==
X-Google-Smtp-Source: AGHT+IEmztZiX9RvL4Wp4cYy/lRffLhfZBQFee2u3aKQ+DQ0b5UOxznkRmoqhvkZAmXI8iHH6cBqc6s06Vm3nCEkFPk=
X-Received: by 2002:a05:6402:3591:b0:5cb:ae1b:4bd9 with SMTP id
 4fb4d7f45d1cf-5cbbf888505mr32855258a12.6.1730964400802; Wed, 06 Nov 2024
 23:26:40 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241106121842.5004-1-anuj20.g@samsung.com> <CGME20241106122710epcas5p2b314c865f8333c890dd6f22cf2edbe2f@epcas5p2.samsung.com>
 <20241106121842.5004-7-anuj20.g@samsung.com> <20241107055542.GA2483@lst.de>
In-Reply-To: <20241107055542.GA2483@lst.de>
From: Anuj gupta <anuj1072538@gmail.com>
Date: Thu, 7 Nov 2024 12:56:03 +0530
Message-ID: <CACzX3As284BTyaJXbDUYeKB96Hy+JhgDXs+7qqP6Rq6sGNtEsw@mail.gmail.com>
Subject: Re: [PATCH v8 06/10] io_uring/rw: add support to send metadata along
 with read/write
To: Christoph Hellwig <hch@lst.de>
Cc: Anuj Gupta <anuj20.g@samsung.com>, axboe@kernel.dk, kbusch@kernel.org, 
	martin.petersen@oracle.com, asml.silence@gmail.com, brauner@kernel.org, 
	jack@suse.cz, viro@zeniv.linux.org.uk, io-uring@vger.kernel.org, 
	linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, 
	gost.dev@samsung.com, linux-scsi@vger.kernel.org, vishak.g@samsung.com, 
	linux-fsdevel@vger.kernel.org, Kanchan Joshi <joshi.k@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 7, 2024 at 11:25=E2=80=AFAM Christoph Hellwig <hch@lst.de> wrot=
e:
>
> > +enum io_uring_sqe_ext_cap_bits {
> > +     EXT_CAP_PI_BIT,
> > +     /*
> > +      * not a real extended capability; just to make sure that we don'=
t
> > +      * overflow
> > +      */
> > +     EXT_CAP_LAST_BIT,
> > +};
> > +
> > +/* extended capability flags */
> > +#define EXT_CAP_PI   (1U << EXT_CAP_PI_BIT)
>
> This is getting into nitpicking, but is the a good reason to have that
> enum, which is never used as a type and the values or only defined to
> actually define the bit positions below?  That's a bit confusing to
> me.

The enum is added to keep a check on the number of flags that can
be added, and make sure that we don't overflow.

>
> Also please document the ABI for EXT_CAP_PI, right now this is again
> entirely undocumented.
>

We are planning to document this in man/io_uring_enter.2 in the liburing
repo, right after this series goes in. Or should it go somewhere else?

> > +/* Second half of SQE128 for IORING_OP_READ/WRITE */
> > +struct io_uring_sqe_ext {
> > +     __u64   rsvd0[4];
> > +     /* if sqe->ext_cap is EXT_CAP_PI, last 32 bytes are for PI */
> > +     union {
> > +             __u64   rsvd1[4];
> > +             struct {
> > +                     __u16   flags;
> > +                     __u16   app_tag;
> > +                     __u32   len;
> > +                     __u64   addr;
> > +                     __u64   seed;
> > +                     __u64   rsvd;
> > +             } rw_pi;
> > +     };
>
> And this is not what I though we discussed before.  By having a
> union here you imply some kind of "type" again that is switched
> on a value, and not flags indication the presence of potential
> multiple optional and combinable features.  This is what I would
> have expected here based on the previous discussion:

The attempt here is that if two extended capabilities are not known to
co-exist then they can be kept in the same place. Since each extended
capability is now a flag, we can check what combinations are valid and
throw an error in case of incompatibility. Do you see this differently?

>
> struct io_uring_sqe_ext {
>         /*
>          * Reservered for please tell me what and why it is in the beginn=
ing
>          * and not the end:
>          */
>         __u64   rsvd0[4];

This space is reserved for extended capabilities that might be added down
the line. It was at the end in the earlier versions, but it is moved
to the beginning
now to maintain contiguity with the free space (18b) available in the first=
 SQE,
based on previous discussions [1].

[1] https://lore.kernel.org/linux-block/ceb58d97-b2e3-4d36-898d-753ba69476b=
e@samsung.com/

>
>         /*
>          * Only valid when EXT_CAP_PI is set:
>          */
>         __u16   pi_flags; /* or make this generic flags, dunno? */
>         __u16   app_tag;
>         __u32   pi_len;
>         __u64   pi_addr;
>         __u64   pi_seed;
>
>         __u64   rsvd1;
> };
>

