Return-Path: <io-uring+bounces-8625-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A03D2AFD678
	for <lists+io-uring@lfdr.de>; Tue,  8 Jul 2025 20:32:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EFD5B4A7A02
	for <lists+io-uring@lfdr.de>; Tue,  8 Jul 2025 18:32:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 320F42DFA22;
	Tue,  8 Jul 2025 18:32:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="apBFbMGB"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B84701C6FEC
	for <io-uring@vger.kernel.org>; Tue,  8 Jul 2025 18:32:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751999559; cv=none; b=rXnwkAo6cKokFz9ALpCWvbdb2MUzj8k4cpnOOwZp9KBKr/mGvR3dVt/v0ScqvSAcPuSnI/VkEjImna61EUKm26yYjPZwtvwt7cOFYUch0+emk76mCyaJewGitfOAnhTGrn/5JbeG99Q7tkx+VUBDP+PjthiV7pWEanRJg1i5CHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751999559; c=relaxed/simple;
	bh=O1GcTiIi/oWvVrYOvUmB5bjT3cWL6oGGPmNHOi/KSRk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=i9EWl19dDCo3H7Ezs5vCAUyG0knVWcI8VRiStcdciu4HLRfov3r11ATs+pXhZW3yItlG+SHQATuKDK7g/tV1tnEeN8c/9jgu1egyje4VoBzgAqB8cL+QDwmggCORuMAkpkvlwvSAJljkMVo7G5dkbKU47qQwMy+K3Xw8XcL89/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=apBFbMGB; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-31305ee3281so857132a91.0
        for <io-uring@vger.kernel.org>; Tue, 08 Jul 2025 11:32:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1751999556; x=1752604356; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KG1Wx6OUZ9cQBjqvnO/QEWRp1+n48srDtYVZJzr7dSU=;
        b=apBFbMGB//ztyDe0OTLIySD6nWBigzg6u21pe9kABNcjUVkigTBDqDwIkNDD7YdPy8
         cIOyBUNPLTBB49x8OPMlopbVx2zzL9cy1kJ2b0fSOG8DfR1cbBK85KJHrZZcA//Sqxm7
         syhIJDpFt8TsV7OQdemvqy/kQDvZ7x/VWwETmrbOTxPF7JWfO0sbZTNZPbBeurXJEu9u
         wBqL6QdOMDym1/pK/evEbBefXExykl8kZnYR8/OucfreD9WfcGbIgFp0rvqF2yT1XxVl
         78D3EIvK7ImxqtB2styUH/hrVaYie4YLc6cBIXkmiU/xmpjE5pcBTK4WfJRdx2x2XsQT
         XRNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751999556; x=1752604356;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KG1Wx6OUZ9cQBjqvnO/QEWRp1+n48srDtYVZJzr7dSU=;
        b=j7GtFVOdrlIMZ4dM2JlqybFl/TAjX67Q/UOBmJcYwycZ/kE8uwOspNJdlDmUCj0nlf
         q/z3DwMdMS1bizqGNSBRNN7+J+ZQM3ZY6JPDw2yIdJfSxmcjJWjdo9RiyxBXYFB8R2z3
         O6cIwt63BAYnw+1/rPtTNHYkHQHBwLwcvBmN8fPxp+uXPPn8YFJsz+z7AiIATLVOtBQh
         NufCBLEzKBgEWB8EPdfKSf5+MDMmZR5IGrnd+e/b+u7Sefpq3SMEVaqHioMIR2GYb7BB
         ML8qndGUQJEzOwYeSpIUFwy4jHoqDrgravZPPwUhQ0F2PnFLHRcgslpSnpR7GUH2unbw
         R0RQ==
X-Forwarded-Encrypted: i=1; AJvYcCUXZPU+c+PA0vQ7uC++FNx09H4o5zbGlaEvXyU1eNbt3Gl2fQoZmdaoAgUohRrTJ4a3Pk6kSKylSQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Ywanzg0Qdw8kZLM3P+0AS7ihk3DYpdxV6ZSW7oGTO/bRtfPztAs
	awZ1aFzrkQD6XH4YutMxp9eEc9r0KwJcbMVKNqVcpYDzfgn3or0XM+nV1po0Qb66U5WpR22rpIh
	DYT2FOZdTQ076C3KRsNDCSq0KLzXimyT9aS0YXV4ZGw==
X-Gm-Gg: ASbGncucvGx69yY6tnCQAvRAXOFE+6aBYDRx6PZT5EMbqRtr5kyY1piFDETi4MIqI2L
	ZX4bGKqZRdVbsN51u999mtIOv4rEWdUtujZCOWgE/6j6meeFVLFEmcbSjkr19jiFla+h0v2o4IU
	Sz0KGO0mUp0AYGNnP2l/spnSnewy5EvPtGK6wSaPSee/8q
X-Google-Smtp-Source: AGHT+IGjquqT49t3mk9uGsBdWrji9vx+SHIhp2vhXIPomfvzssP2TLOXJlJDWqiYxr3KiEgZnyLCabCV7oJzVVEChrA=
X-Received: by 2002:a17:90b:3e44:b0:311:c939:c842 with SMTP id
 98e67ed59e1d1-31aaccd7e36mr9067045a91.7.1751999556030; Tue, 08 Jul 2025
 11:32:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250619192748.3602122-1-csander@purestorage.com>
 <20250619192748.3602122-4-csander@purestorage.com> <c83a2cb6-3486-4977-9e1e-abda015a4dad@kernel.dk>
 <CADUfDZr6A51QxVWw2hJF6_FZW7QYoUHwH-JtNEgmkAefMiUjqQ@mail.gmail.com> <76ea020f-7f57-42d5-9f86-b21f732be603@kernel.dk>
In-Reply-To: <76ea020f-7f57-42d5-9f86-b21f732be603@kernel.dk>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Tue, 8 Jul 2025 14:32:24 -0400
X-Gm-Features: Ac12FXyEbJh8A-70IJqk1u3VgKtVIrMS8nYA9UhDEjT4t4zZd9AHBYP8tZeznMI
Message-ID: <CADUfDZppvPG9iZg6ED0ZUW_ms1EnNUJwwYyAJ7eCTWsJqa417w@mail.gmail.com>
Subject: Re: [PATCH 3/4] btrfs/ioctl: store btrfs_uring_encoded_data in io_btrfs_cmd
To: Jens Axboe <axboe@kernel.dk>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>, David Sterba <dsterba@suse.com>, 
	Mark Harmstone <maharmstone@fb.com>, linux-btrfs@vger.kernel.org, io-uring@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 8, 2025 at 2:17=E2=80=AFPM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 7/2/25 1:51 PM, Caleb Sander Mateos wrote:
> > On Tue, Jul 1, 2025 at 3:06?PM Jens Axboe <axboe@kernel.dk> wrote:
> >>
> >>> @@ -4811,11 +4813,15 @@ static int btrfs_uring_encoded_read(struct io=
_uring_cmd *cmd, unsigned int issue
> >>>       loff_t pos;
> >>>       struct kiocb kiocb;
> >>>       struct extent_state *cached_state =3D NULL;
> >>>       u64 start, lockend;
> >>>       void __user *sqe_addr;
> >>> -     struct btrfs_uring_encoded_data *data =3D io_uring_cmd_get_asyn=
c_data(cmd)->op_data;
> >>> +     struct io_btrfs_cmd *bc =3D io_uring_cmd_to_pdu(cmd, struct io_=
btrfs_cmd);
> >>> +     struct btrfs_uring_encoded_data *data =3D NULL;
> >>> +
> >>> +     if (cmd->flags & IORING_URING_CMD_REISSUE)
> >>> +             data =3D bc->data;
> >>
> >> Can this be a btrfs io_btrfs_cmd specific flag? Doesn't seem like it
> >> would need to be io_uring wide.
> >
> > Maybe. But where are you thinking it would be stored? I don't think
> > io_uring_cmd's pdu field would work because it's not initialized
> > before the first call to ->uring_cmd(). That's the whole reason I
> > needed to add a flag to tell whether this was the first call to
> > ->uring_cmd() or a subsequent one.
> > I also put the flag in the uring_cmd layer because that's where
> > op_data was defined. Even though btrfs is the only current user of
> > op_data, it seems like it was intended as a generic mechanism that
> > other ->uring_cmd() implementations might want to use. It seems like
> > the same argument would apply to this flag.
> > Thoughts?
>
> It's probably fine as-is, it was just some quick reading of it.
>
> I'd like to stage this up so we can get it done for 6.17. Can you
> respind with the other minor comments addressed? And then we can attempt
> to work this out with the btrfs side.

Sure, I can definitely incorporate the refactoring suggestion. Will
try to resend the patch series today.

Best,
Caleb

