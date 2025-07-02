Return-Path: <io-uring+bounces-8584-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 78FB8AF62DA
	for <lists+io-uring@lfdr.de>; Wed,  2 Jul 2025 21:51:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C77921BC4FDF
	for <lists+io-uring@lfdr.de>; Wed,  2 Jul 2025 19:52:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B3DF2DCF49;
	Wed,  2 Jul 2025 19:51:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="QUHkN5Iy"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03ADA22578A
	for <io-uring@vger.kernel.org>; Wed,  2 Jul 2025 19:51:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751485904; cv=none; b=ATqC4ummfziYY+5Eplz4w1Vkv/LrQyMWUPQVrq1ffinTbEbvggmHfkxiw+IylyCOpWUl4GQieXxBVlE4VMVGEyBaxKJZLsOHNRKCEs90JbHGywH9y9kSHA2GY0DhmYi62Dzyu/a8B3P8oZWx9laRVF4WUnZLeqm836Q/wjSAsh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751485904; c=relaxed/simple;
	bh=s084wtR88k+Zm0T48J86wDm0Hr7gnC1awK4eSCCArW4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dLIjefWXU6K2RRu4hJAY22cFvvaKg6k/gf3O6CxNbRblFLkmedX4BvNEJEbMA3k/7WPsQaZ/4+hQvPh0bf95jwZjOgjObb3KrR/Sz5PepLIMcPtydhUMS6KxVfdJtcSJbPYW8k0Zaae7e1wrH9BjOtuBH64NREnNT+odvUTa404=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=QUHkN5Iy; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-237d849253fso8976435ad.1
        for <io-uring@vger.kernel.org>; Wed, 02 Jul 2025 12:51:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1751485900; x=1752090700; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FztTel//e5oyaa7vSr+Ve5ZZ9B/kFDNC6EmcHFeFbgE=;
        b=QUHkN5Iywct1or5wb2t3ssdRk8eTVsaWTmsS4Ap4npa7wXD47/p1UC8VpWb7s/t2pk
         jWUU0xjgQdLmyVbtVcsOBKatgYYT6keeN8X8E0812GQ/wC+iWbxzPTzGwL6dIDL+NHrN
         hzJO3Q7ibV0Hi0MrNNcHnrIwfWxT6gGKs/EvRVgSu/doAFCHmCsyQ6Il5307C4hu/JGu
         leDzC1nNzwrSesoWI/JtgcfiDgUWCldox/r+vXzmS2EM0na8OB4SFSILY7Q4PAGVLis+
         RnsMFvcp+rm4FhqTIe6bD+YAJuhyX9mRvt0Q15/Oxu+ocxqx68bd7dywHEaZp8RWp7g4
         oVJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751485900; x=1752090700;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FztTel//e5oyaa7vSr+Ve5ZZ9B/kFDNC6EmcHFeFbgE=;
        b=bvymCKq/bZXAXDOaS4ULjQw7gjseaMydLUYsBqoxReoDVmsBFbx5bb7pPKSqmYE55Z
         vL1omnqKy8uav7hVuh91f2oFaPHR8aEkFKtXPcc1GSZft8GJMLtDDRvy5RlbVzIOX6fu
         YCvXbRJIqjANqSQu9FS2zcZZTdAWvzBOdaMYINKmSfqjCfDTorjruTxf6rC+r5rFWHGX
         8gY5JQ9aHw4eqpK9qwCJaxM2F+bKH9TKHRUmin3L018u1rNypEeSWc3pP10xk/PlijF6
         qosIZNzh1WwM4VtgN9NnYe6cFDMnsROeAWrOAlPQY2x3vGYVgdNzE6eZFmubOj8AduAo
         X6tA==
X-Forwarded-Encrypted: i=1; AJvYcCWEP6Tbg7UCj/ZC42QaiWCWk+/kjvjIb6fT6lznJg5v3lQIPqZqxtt4Yc2BOIeLlPmJosaGT0u0dQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx4jYebRjU7wE59PkfSepwL23JWHoBNi5/UhJ5Q0CMFVDIJiK7v
	AI95aUdX3NOzYglT8vj8lfswLGD2E1CNHfsgcHdioA0VodJk5+8MrgbrjO9de8xp7GlL6bFsSei
	rCHlimN4sw8+vzOdS2joo83LFexp7Ldx4XZnWxZERCrXYyNndMd9hxkX9pw==
X-Gm-Gg: ASbGncus2GdIDLtYiU+dodvNR4zbHqiMq4cggLbW3fuVjdl0LMRH6DHm4Nm9X6gXqa4
	6VNrbH5RHA0RHgloM/hE1fHF/HRSEGYJDZFsb4VUdsgIpOmjTvo9klydlsiF1G/7fHxqW5ptdwr
	S5jRkHPFcb89wsulLsTxcvFETZ4rTKNJhJUl1yRDtRChBKmHUoa0HfZw==
X-Google-Smtp-Source: AGHT+IHzKax4rWzgTagFExREvUdZKzP7gz6GIK5OKEX/A1gv3DbccqXrJXg9Q79q2ToGLz5xqYGJ7FpbAJTwCWI+3ts=
X-Received: by 2002:a17:903:124d:b0:23c:5f36:46a6 with SMTP id
 d9443c01a7336-23c6fcea87bmr20535465ad.12.1751485900234; Wed, 02 Jul 2025
 12:51:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250619192748.3602122-1-csander@purestorage.com>
 <20250619192748.3602122-4-csander@purestorage.com> <c83a2cb6-3486-4977-9e1e-abda015a4dad@kernel.dk>
In-Reply-To: <c83a2cb6-3486-4977-9e1e-abda015a4dad@kernel.dk>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Wed, 2 Jul 2025 15:51:28 -0400
X-Gm-Features: Ac12FXzYvCEJprNA84OmEAiR_yc-BbACnKsWI1JFO0q24cJQIzcr5F8BHED8eZ4
Message-ID: <CADUfDZr6A51QxVWw2hJF6_FZW7QYoUHwH-JtNEgmkAefMiUjqQ@mail.gmail.com>
Subject: Re: [PATCH 3/4] btrfs/ioctl: store btrfs_uring_encoded_data in io_btrfs_cmd
To: Jens Axboe <axboe@kernel.dk>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>, David Sterba <dsterba@suse.com>, 
	Mark Harmstone <maharmstone@fb.com>, linux-btrfs@vger.kernel.org, io-uring@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 1, 2025 at 3:06=E2=80=AFPM Jens Axboe <axboe@kernel.dk> wrote:
>
> > @@ -4811,11 +4813,15 @@ static int btrfs_uring_encoded_read(struct io_u=
ring_cmd *cmd, unsigned int issue
> >       loff_t pos;
> >       struct kiocb kiocb;
> >       struct extent_state *cached_state =3D NULL;
> >       u64 start, lockend;
> >       void __user *sqe_addr;
> > -     struct btrfs_uring_encoded_data *data =3D io_uring_cmd_get_async_=
data(cmd)->op_data;
> > +     struct io_btrfs_cmd *bc =3D io_uring_cmd_to_pdu(cmd, struct io_bt=
rfs_cmd);
> > +     struct btrfs_uring_encoded_data *data =3D NULL;
> > +
> > +     if (cmd->flags & IORING_URING_CMD_REISSUE)
> > +             data =3D bc->data;
>
> Can this be a btrfs io_btrfs_cmd specific flag? Doesn't seem like it
> would need to be io_uring wide.

Maybe. But where are you thinking it would be stored? I don't think
io_uring_cmd's pdu field would work because it's not initialized
before the first call to ->uring_cmd(). That's the whole reason I
needed to add a flag to tell whether this was the first call to
->uring_cmd() or a subsequent one.
I also put the flag in the uring_cmd layer because that's where
op_data was defined. Even though btrfs is the only current user of
op_data, it seems like it was intended as a generic mechanism that
other ->uring_cmd() implementations might want to use. It seems like
the same argument would apply to this flag.
Thoughts?

Best,
Caleb

