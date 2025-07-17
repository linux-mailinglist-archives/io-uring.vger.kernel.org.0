Return-Path: <io-uring+bounces-8710-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4ED66B09567
	for <lists+io-uring@lfdr.de>; Thu, 17 Jul 2025 22:04:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E14C43BA52F
	for <lists+io-uring@lfdr.de>; Thu, 17 Jul 2025 20:04:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8502223DCE;
	Thu, 17 Jul 2025 20:04:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="X/RnAtaM"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 556F91E0E14
	for <io-uring@vger.kernel.org>; Thu, 17 Jul 2025 20:04:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752782685; cv=none; b=OckrNttfGtJR/2Y9r9TMfWbbRc10ThUyqSFiahz4wTrUwyPZOxQ5oDoIuXwump4OdJjdD58ajiuf88C6ZdhzdwXfrvxs6hPTZIbS3QV8TN3kBcC0Z0qVM5ZbJ+IW0wswKEij4+HFMEGRvTPZp8c7PgQlnYv6k65KIqaQk3Pyg3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752782685; c=relaxed/simple;
	bh=U/+v7KLWnVxoUKhIBBslHybhE/t5sUE6Pg10SYhDzK4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LT3pCxwzTpcq4DiL/CMjU6Jh3iAmcR3u/kATs4963Up2Sb5w+oSYoWcZtTKt0R1tvUzV/Z0kU1KfVx+aj/iJ/R7CJWF+tsuDHyPH0e7o3RmUrq9YG1CqE0DUcVGilgEQB6Vr7CMJoLsPsu4lgWlv5uwmYqfHCa6otbfv7mze64s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=X/RnAtaM; arc=none smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-313fab41fd5so318409a91.1
        for <io-uring@vger.kernel.org>; Thu, 17 Jul 2025 13:04:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1752782683; x=1753387483; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3/v0WT+7vq9SCfoMg2Yag6ZEXMrfYo0BDeUgpiKJwjw=;
        b=X/RnAtaMalF0WoNywXqWuMCKNDVBr5wz/XH7cZ3kn1ZoHkxK41QbmfBML9phnPCbbY
         jkMiQYiMrAX4EBHgF8+i9YX4rKzZtz6swxrPBOBW9EZDPE5OH5c/oAX33IdS1zUqnSFd
         8hcf77p2eZ8I3Zs8RikJMWPLU4zLGbowu4NdS/ZK53MzJXj/SYcBtT6bgz7nk2hR4xfX
         So39mTbNFkb/4+QgXjgGlh4m9FJnZmbcdPCw8S1M5yTXwnBqyaMh6N+gKa+C4f/2nwD0
         0waZ3sseO6QbGjWDLzxcoWAE0FZyTpUdRFTFUMcvtaXR3oFsVU4wDqOJx8IxL95DsyxJ
         0RMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752782683; x=1753387483;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3/v0WT+7vq9SCfoMg2Yag6ZEXMrfYo0BDeUgpiKJwjw=;
        b=GzPMGiX519LFYlJdPw+SU34SVMHNQIzVql3J3LwPbK0V9pbVPOVRlDXURLSJgklmTE
         BB8ISii1t05NWYeOHVWRcRBlwLL0Nq/LUqnu6Q5FLjxXx6TX/lJkl8tbLkG4e1KPMmaV
         MvjmgDKZjlcCoZWlDZSHzn+ivfOn2/tF3cQEqeKtPk/AbURhTNAWy6fUMR1morajb8KC
         iCqNwAu2W00pJcrLXlGQDlAOTyIqVZ+wYCs0T5EAQUkDl2Regfs83w8NtLbOgin6ci1P
         WZjaZv88Lw1VrvTpHdJEkslWjAt0AvXdT0R2hi1uIy2BjxipcT61VFstIzkcEeM/dYY5
         aC9w==
X-Forwarded-Encrypted: i=1; AJvYcCWxvIcOKBRt7PQNB3Kf3oAJ6fBDhmz5lYPIOcoevgn3FaIfvsdRYziaH7kpJioMvBG8sj6zbWATig==@vger.kernel.org
X-Gm-Message-State: AOJu0YxuVE3bxBsYHMlBjZrAAbFgprrIkvcLiaWrXdSxDL8LHaEH5Lab
	+ah5I5T8v6fzH7c/2Xyj8ykUbIVReVldP2rzoY3gy8FXAVXbeuS9oJRbU/fZuGbtg2KnKkDka6M
	gEGIREuX1VA+0Y8tIHkn63HgxmiTF72kfbyyZzb7S2Q==
X-Gm-Gg: ASbGncsysRCBLWUVrJo1QhXYvo9cvalrrLbvuM9WuOL1Qd4xdVFqGGR1sGXRd0AeHnN
	JlFWhAFWyg7cVtnUrqiVIOey0qvb/w0Iy3twU7+olhsWsOo9K9Qif6kTnGUtMup6QbC2xHbgiQf
	ZmbzFJeJvUfQaTTS3xAYIUDjYfvDcxGwnKpqmlGahPuUMau744SEiqwizhiCyzF5D8fi6MGQjif
	+haNy4V
X-Google-Smtp-Source: AGHT+IEhtJhj93AM6HYFT5RBg05Ilw6taTJ3/mXZBlGWr1wjpnrg+tZXlSuFBThy/hFSUe1C/9a92iYVg1S6R9eX2Uk=
X-Received: by 2002:a17:90b:3d09:b0:311:fde5:c4ae with SMTP id
 98e67ed59e1d1-31c9e776737mr4663891a91.6.1752782682862; Thu, 17 Jul 2025
 13:04:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250708202212.2851548-1-csander@purestorage.com>
In-Reply-To: <20250708202212.2851548-1-csander@purestorage.com>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Thu, 17 Jul 2025 16:04:31 -0400
X-Gm-Features: Ac12FXz4umVHFmIzVUIOYyEMbfS69u7WsqSmgyR0PovCc2BoXLdELiz-nczSAh8
Message-ID: <CADUfDZr6d_EV6sek0K1ULpg2T862PsnnFT08PhoX9WjHGBA=0w@mail.gmail.com>
Subject: Re: [PATCH v2 0/4] io_uring/btrfs: remove struct io_uring_cmd_data
To: Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>, David Sterba <dsterba@suse.com>, 
	Jens Axboe <axboe@kernel.dk>
Cc: Mark Harmstone <maharmstone@fb.com>, linux-btrfs@vger.kernel.org, 
	io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Jens,
Are you satisfied with the updated version of this series? Let me know
if there's anything else you'd like to see.

Thanks,
Caleb

On Tue, Jul 8, 2025 at 4:22=E2=80=AFPM Caleb Sander Mateos
<csander@purestorage.com> wrote:
>
> btrfs's ->uring_cmd() implementations are the only ones using io_uring_cm=
d_data
> to store data that lasts for the lifetime of the uring_cmd. But all uring=
_cmds
> have to pay the memory and CPU cost of initializing this field and freein=
g the
> pointer if necessary when the uring_cmd ends. There is already a pdu fiel=
d in
> struct io_uring_cmd that ->uring_cmd() implementations can use for storag=
e. The
> only benefit of op_data seems to be that io_uring initializes it, so
> ->uring_cmd() can read it to tell if there was a previous call to ->uring=
_cmd().
>
> Introduce a flag IORING_URING_CMD_REISSUE that ->uring_cmd() implementati=
ons can
> use to tell if this is the first call to ->uring_cmd() or a reissue of th=
e
> uring_cmd. Switch btrfs to use the pdu storage for its btrfs_uring_encode=
d_data.
> If IORING_URING_CMD_REISSUE is unset, allocate a new btrfs_uring_encoded_=
data.
> If it's set, use the existing one in op_data. Free the btrfs_uring_encode=
d_data
> in the btrfs layer instead of relying on io_uring to free op_data. Finall=
y,
> remove io_uring_cmd_data since it's now unused.
>
> Caleb Sander Mateos (4):
>   btrfs/ioctl: don't skip accounting in early ENOTTY return
>   io_uring/cmd: introduce IORING_URING_CMD_REISSUE flag
>   btrfs/ioctl: store btrfs_uring_encoded_data in io_btrfs_cmd
>   io_uring/cmd: remove struct io_uring_cmd_data
>
>  fs/btrfs/ioctl.c             | 41 +++++++++++++++++++++++++-----------
>  include/linux/io_uring/cmd.h | 11 ++--------
>  io_uring/uring_cmd.c         | 18 ++++++----------
>  io_uring/uring_cmd.h         |  1 -
>  4 files changed, 37 insertions(+), 34 deletions(-)
>
> v2:
> - Don't branch twice on -EAGAIN in io_uring_cmd() (Jens)
> - Rebase on for-6.17/io_uring
>
> --
> 2.45.2
>

