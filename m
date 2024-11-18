Return-Path: <io-uring+bounces-4782-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 26F629D1BB6
	for <lists+io-uring@lfdr.de>; Tue, 19 Nov 2024 00:10:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 84836B2265E
	for <lists+io-uring@lfdr.de>; Mon, 18 Nov 2024 23:10:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9EDAD192D77;
	Mon, 18 Nov 2024 23:10:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EDxOX/MF"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0845B153BE4;
	Mon, 18 Nov 2024 23:10:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731971441; cv=none; b=pSEyEQv129d10vDJXjiVD8Pf5hu1l1VafvlcQ5g63xkaorBhhHttsgyKbwW77BkPrE2k3qMSAxG84hY3rQM9iYEDqpAzEG0LrYnfdRlOUY3EFURGdjLIENTOFla4tPOpBTJmI+GhqMCwHVQFG5k9y5SVwAnoQdjFzLdTYZlTyvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731971441; c=relaxed/simple;
	bh=UTsScOuiOnZAf0N7bi0kKSG8twQH/EN51DMMmvUFUJs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=svah+dhRSyiFCjBIB9O2BGmX+Dj+wgxAI2nthFOUTgVhJNSeFWXuk2LJiWTV2kK6UhZJtgp6swI8AtC6ZFpju187/VStOpfsMfStkV8V5SqHpdLxqMHL3w7o3MJ8gxpQvu6crKAcNjOMDjU98kvXbEzyW/Aqc9eqFWyyN0DXzz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EDxOX/MF; arc=none smtp.client-ip=209.85.160.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-460ad0440ddso1877641cf.3;
        Mon, 18 Nov 2024 15:10:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731971439; x=1732576239; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DXiyuALWVuDoOJhucZvM36T1DPAUGVkjFgg29QK7pNc=;
        b=EDxOX/MFglYkyd4iGLgWUwKFuknijiNuJ4UqcZAFPNz/qTVLHYM0c8cbCzE8FcFCvk
         zVuEaqfeJa+UZgSclfH/9UjERe3hGNqrk5mt/tWXg9DqTdwXZSH5v/+co/M7SQMZwdN6
         3oRnD8ElV7GEmk8+ObFvRMgXnY8fiUp/rLeqwsHbu52/ZFgm2/G1M39QedB1Ic4mDIfc
         g983APD2vNZIZMzA5fzFmWEE6naTSUnOgwyHuyVJcQIuXGkIlfFUVn0mN166AQKhe0zZ
         y0YwHnIxNFYVz8bZL6yW3q6nUJ3dnuLI1AHHfLB80jRh7w222/d+W6rWWrAHq3GgFseH
         IAHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731971439; x=1732576239;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DXiyuALWVuDoOJhucZvM36T1DPAUGVkjFgg29QK7pNc=;
        b=UOciCMgOqluVNV4wCJQtT+nF8ozVOIPMBDplR3/Ad9/Gt/x40aPk2E9l591XokM+Tq
         sDPHDacW1kQP8r6VmUgs0XXiYVtpO4xiRBl52CuPXyZxBLKziHHqX0nLFv9JnLB42aIu
         J14n4Ceag0OfHXRKeuAZnMcUz8J+3bFNvSiG5MINxZNCRUM8foQepQhiMTupCdH3pwRk
         q84+d9E2Wvq9zaKQDn2LhSJhiIC67g99wg8z+pqDae9nVfdpI/6cJ9bqp7LhgnNNpKgP
         +njfvPPIa9nUCwH9uuoBZRsi89VYm058oBmwinJA4I7YtzuPDysOtK69jTEB4IHzXOUk
         nNkw==
X-Forwarded-Encrypted: i=1; AJvYcCWBzIz/1hcibf2Q9rAzVZB/bbsdhqiWFODjCnO2iKVhZEFr/KJzTxfTE53XjZJBwEE37lOGEMmQpQ==@vger.kernel.org, AJvYcCWx0AhCpY+PzirXXEGKZm5VCspYQviyrFtdojnf8vjx6j4dS2MZOLDnld7O1zidsBguiwLEq7dKZWG5TAzVyg==@vger.kernel.org
X-Gm-Message-State: AOJu0YxkHII0jT4bO5oeEYmb4hNgKhfWeAOclTfP+IXnhZ7TGYE/ejv2
	u1QsspGgkyqLI7z24h2JGIN2ceLFVF2lYnvW6M+xIJ26Nk1VFaKBibFnj3QyJ9pshXkWXdqIUkB
	f3anN7PocGoxrrFPkA3a37jyunKA=
X-Google-Smtp-Source: AGHT+IH3hbsCbzRg6Xo/GzchZfftr06ZcozEZW4kQLl75ssXq19oaaWMvfZICQLMND19LBrrHqXDTPRzxTMmW3OWm3Y=
X-Received: by 2002:a05:622a:529b:b0:461:57f9:6294 with SMTP id
 d75a77b69052e-46363e9fba9mr191600851cf.38.1731971438724; Mon, 18 Nov 2024
 15:10:38 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241107-fuse-uring-for-6-10-rfc4-v5-0-e8660a991499@ddn.com>
 <20241107-fuse-uring-for-6-10-rfc4-v5-15-e8660a991499@ddn.com>
 <CAJnrk1ZexeFu7PopHUe_jPNRCGWWG5ha-P9min0VV+LJO5mAZw@mail.gmail.com> <97f18455-7651-42c1-9e76-4fb62220e739@fastmail.fm>
In-Reply-To: <97f18455-7651-42c1-9e76-4fb62220e739@fastmail.fm>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Mon, 18 Nov 2024 15:10:27 -0800
Message-ID: <CAJnrk1aF0DDBX08KcPD3Y4pP-KyeoS0-tRsDH0a9SJnRzgHwJg@mail.gmail.com>
Subject: Re: [PATCH RFC v5 15/16] fuse: {io-uring} Prevent mount point hang on
 fuse-server termination
To: Bernd Schubert <bernd.schubert@fastmail.fm>
Cc: Bernd Schubert <bschubert@ddn.com>, Miklos Szeredi <miklos@szeredi.hu>, Jens Axboe <axboe@kernel.dk>, 
	Pavel Begunkov <asml.silence@gmail.com>, linux-fsdevel@vger.kernel.org, 
	io-uring@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>, 
	Amir Goldstein <amir73il@gmail.com>, Ming Lei <tom.leiming@gmail.com>, David Wei <dw@davidwei.uk>, 
	bernd@bsbernd.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 18, 2024 at 11:55=E2=80=AFAM Bernd Schubert
<bernd.schubert@fastmail.fm> wrote:
>
>
> On 11/18/24 20:32, Joanne Koong wrote:
> > On Thu, Nov 7, 2024 at 9:04=E2=80=AFAM Bernd Schubert <bschubert@ddn.co=
m> wrote:
> >>
> >> When the fuse-server terminates while the fuse-client or kernel
> >> still has queued URING_CMDs, these commands retain references
> >> to the struct file used by the fuse connection. This prevents
> >> fuse_dev_release() from being invoked, resulting in a hung mount
> >> point.
> >
> > Could you explain the flow of what happens after a fuse server
> > terminates? How does that trigger the IO_URING_F_CANCEL uring cmd?
>
> This is all about daemon termination, when the mount point is still
> alive. Basically without this patch even plain (non forced umount)
> hangs.
> Without queued IORING_OP_URING_CMDs there is a call into
> fuse_dev_release() on daemon termination, with queued
> IORING_OP_URING_CMDs this doesn't happen as each of these commands
> holds a file reference.
>
> IO_URING_F_CANCEL is triggered from from io-uring, I guess when
> the io-uring file descriptor is released
> (note: 'io-uring fd' !=3D '/dev/fuse fd').

Gotcha. I took a look at the io_uring code and it looks like the call
chain looks something like this:

io_uring_release()
  io_ring_ctx_wait_and_kill()
    io_ring_exit_work()
      io_uring_try_cancel_requests()
        io_uring_try_cancel_uring_cmd()
            file->f_op->uring_cmd() w/ IO_URING_F_CANCEL issues_flag

>
>
> I guess I need to improve the commit message a bit.
>
>
>
> Cheers,
> Bernd
>
>
>
>

