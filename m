Return-Path: <io-uring+bounces-10309-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 41CC6C268F7
	for <lists+io-uring@lfdr.de>; Fri, 31 Oct 2025 19:30:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id DFF39347C4B
	for <lists+io-uring@lfdr.de>; Fri, 31 Oct 2025 18:29:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B5AD3351FD8;
	Fri, 31 Oct 2025 18:29:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="Llr3y5I+"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E69B634F492
	for <io-uring@vger.kernel.org>; Fri, 31 Oct 2025 18:29:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761935392; cv=none; b=q0MGLgum24BQGp+ssvf3rfbPU1suM72Tw73FrWhKYeLV+OIdSDXmCI2hzMP4uKjmXlBW0cWApPCxxOFWGvz92D+cHS9LiOmYm5m16WRrPfg5TLc1YVKDYbL93AZFnnWkIcVV8dFOARLsOgB0C5IntYfY3rIvLvVJB5SZYcM0310=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761935392; c=relaxed/simple;
	bh=GcWNr8ONcdUk3tv3RdW5BzwUDCvDbBv2CleRoh2qN1A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NFiuzr2YU6r6Jvfu8jzJLvVeolMdpPojBsUjriAWuOGdRpBUzt3/b14XvtW6YH560Iu11XAIygB41bvOyrOO2dnwhZ2rpTrZVLUIm/jAe/+qXbl5SRsOmz+fovPKyzYMyIlswMn5ECZo1oHZJKctQxD57Z+OVeFdADKYVcQDngA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=Llr3y5I+; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-290a38a2fe4so2887725ad.0
        for <io-uring@vger.kernel.org>; Fri, 31 Oct 2025 11:29:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1761935390; x=1762540190; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=z55zmfhPZ/JH3r6Axk9zdxLaTNVRfIBYZwVYwYMTc5I=;
        b=Llr3y5I+97HxllqBCRtK5H4f0aJsmc5PViNZgIIYZiMPpVXG6Y/BxrJFjL7X3Dc2Vi
         h1cCj6yLOulY66SZyjfXdkCrDxWYQmtLJCZXzlG6OOhYrg4rJRp6MqFH9FS+fpbP6BZ4
         w98oW87ATaOMb/UaHNM9YpMv0gTbuFkuUhAqeoMyun4zHTiIc3bHA3dhr0qRwtDiIi05
         8cOegTxHcTAkdfvToqqktqX7wYia7JvYEnPVvaGFDWbXgQN1LyJ2wk+1HlbGU6git7Eg
         SIk6OxqDYCvJ4mIlsFXF54miGNQiskdLmGleOjgx8baXX20HlAtPahV3vxAo/lBTFxEw
         C7ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761935390; x=1762540190;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=z55zmfhPZ/JH3r6Axk9zdxLaTNVRfIBYZwVYwYMTc5I=;
        b=X9SAvMtbZpU4fACYFV9y+V3UhESQ/3zhmaDVRLtg4wCRqe1HWcO7nDXI2JI+E6t00X
         w3u0CC1CffiuDyceSCOgmb5E0rt3KEd6Ae/De9T99ABpFoz9kO9JlLGgw6whON83KBS9
         riSaDcATMCGkPSoGCYgjp2Tjt2DBpNwPC4hmxQa+b6cOOhuelqkAjx6Z7Lf4GVEfLPJV
         yPz4uVg3pjKjmD54Q1i6v929zYUDjcH4d9eF2D3I5znhP6/dltdp7YZSWg4g11Pfer2I
         aEseerlxDMWfTkQnbU++4p/snNqmhE188cfovuM3S9hfj+alUljkNsdZDIkuEFS87D1j
         1KGg==
X-Forwarded-Encrypted: i=1; AJvYcCW7C/V2tQDL4jSjBddyAGLhc4O7Yw5+5wJ8gXh/WPH7Qfb/8olUYt9xgyOGOWtIWyKit60MVEYu7g==@vger.kernel.org
X-Gm-Message-State: AOJu0Yzp+pmWLhAe8dZkUjrpBTHYoiKA7bqqUM98qEn8qhTK9IyvUg1m
	45qxgRDE6OSGx+ipSJ2UNJH8fqjNRiWozLNR3P34GZabEREOtheD2BcuZ0dR9Kih6Sa3WU0hWL+
	I4CSE/yHiP+STAqaoa2nVkCJm+8dMkaBXx8urezsUuQ==
X-Gm-Gg: ASbGnctsJgkyS4IZApxl8Z9wddEsrYRJbb+/KW+J28fGiIWbStT5dazwadz/hmu1et0
	6XA+/STI1JKGuFc5MVgRE/FkZcraapjV386P/3u9k7gXwga3vgq3fznFGAtnbptuJx14SaiI2Mh
	tk1S5hp7rKrTpqlT84he9yrlra/OgQn3hEDq1Ujbq7pRexXCoH9ca5RoOsQEOhU4aG8ODzYi6Eb
	OtCATnINpp0g5iYBswBDu0eruEMabpo3bjhLMqeVHu/0FnMMk1kH0+7WViyakKw4+cJjoWiQD8R
	z7VUtI0xptH8UeTdv4MzoL81ZPoReQ==
X-Google-Smtp-Source: AGHT+IG4bOkdfsFJZblcFZ6qJHvTEYrpwiVlyRYTXktlwfAYyq7KD0P/FbFEhEndkdVv+NprV5snVBt3nCQR/grG0qM=
X-Received: by 2002:a17:902:ce88:b0:290:aaff:344e with SMTP id
 d9443c01a7336-2951a36c31cmr37241305ad.2.1761935390144; Fri, 31 Oct 2025
 11:29:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251027020302.822544-1-csander@purestorage.com>
 <20251027020302.822544-5-csander@purestorage.com> <20251027075142.GA14661@lst.de>
In-Reply-To: <20251027075142.GA14661@lst.de>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Fri, 31 Oct 2025 11:29:38 -0700
X-Gm-Features: AWmQ_bnD9cmB_he1htZLcay_wVtXtWzu-O7fBpjGn-Ny_vwA3iif2bU7bDu7dec
Message-ID: <CADUfDZq88mkARUOx-RQw72dwkTc2EB+0KiBtC6BL66e4pgiZxw@mail.gmail.com>
Subject: Re: [PATCH v3 4/4] io_uring/uring_cmd: avoid double indirect call in
 task work dispatch
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Miklos Szeredi <miklos@szeredi.hu>, Ming Lei <ming.lei@redhat.com>, 
	Keith Busch <kbusch@kernel.org>, Sagi Grimberg <sagi@grimberg.me>, Chris Mason <clm@fb.com>, 
	David Sterba <dsterba@suse.com>, io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-block@vger.kernel.org, linux-nvme@lists.infradead.org, 
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 27, 2025 at 12:51=E2=80=AFAM Christoph Hellwig <hch@lst.de> wro=
te:
>
> > +static void blk_cmd_complete(struct io_tw_req tw_req, io_tw_token_t tw=
)
> >  {
> > +     unsigned int issue_flags =3D IO_URING_CMD_TASK_WORK_ISSUE_FLAGS;
>
> In most of these ioctl handlers issue_flags only has a single user,
> so you might as well pass it directly.

Sure, happy to get rid of the intermediate variable in places where
issue_flags is only referenced once.

>
> In fact asm most external callers of io_uring_cmd_done pass that, would
> a helper that just harcodes it make sense and then maybe switch the
> special cases to use __io_uring_cmd_done directly?

While issue_flags is mainly used to pass to io_uring_cmd_done(), there
are some other uses too. For example, ublk_cmd_tw_cb() and
ublk_cmd_list_tw_cb() pass it to io_buffer_register_bvec() via
ublk_dispatch_req(), ublk_prep_auto_buf_reg(), and
ublk_auto_buf_reg(). Since uring_cmd implementations can perform
arbitrary work in task work context, I think it makes sense to keep
IO_URING_CMD_TASK_WORK_ISSUE_FLAG so it can be used wherever it's
required.

Best,
Caleb

