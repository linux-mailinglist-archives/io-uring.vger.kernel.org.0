Return-Path: <io-uring+bounces-9688-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D9476B5050B
	for <lists+io-uring@lfdr.de>; Tue,  9 Sep 2025 20:13:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 940183B128B
	for <lists+io-uring@lfdr.de>; Tue,  9 Sep 2025 18:13:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 166FD25B1E0;
	Tue,  9 Sep 2025 18:13:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LX+FIajQ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C8762F4A;
	Tue,  9 Sep 2025 18:13:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757441628; cv=none; b=lbaiNlQXhemAtrhKsCMLv7N9tEarw6yuRJwMp9krzVTYgzf/ZA4FLuVdmCuRlzhPRsETxynoVIntnz3+W8BTtQwS9OsccYRz57IBIGtJ3jCN4IBhZHHKjsI7wFUZgLShwjOvQoTws1okKTDsL0r0fu5IUWJzwVIj+2KJjkfiJXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757441628; c=relaxed/simple;
	bh=v5MIgyNMcuVeoaHKE3jeJkB/cPJ+KgcPL9K1KGUT/k8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=W9rwS9kUg/R5VishGb2jVJaxUKfEjlCn9Q2mTsajBqFbdu7K56bawNMzP86Hk9ysCrFjEQUxtjsfQ36Pwhi0t5xXdWvZGailUyH9rv+OBEpdjOE84tORBj4sItAqmJQBxISIArzpdADpt2b5USuZKxLyaPI/L8lhB3y1RFjl6Os=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LX+FIajQ; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-3df2f4aedc7so3381520f8f.2;
        Tue, 09 Sep 2025 11:13:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757441625; x=1758046425; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=v5MIgyNMcuVeoaHKE3jeJkB/cPJ+KgcPL9K1KGUT/k8=;
        b=LX+FIajQ5OjUSzsiavrNlsyr5HLxSzyzQmcmuJxfRLq9QXW6lE/IhuHywlaDXC8zMN
         Z5CnG7Gnyypb0ck1rndAOzgMhc1VJ3Pw52LtbzKcNO3VsLmJmVhJoVVL8Dmbc+08oh39
         1dwQaBjGhoJ21oteGNuFS6ZPz7zsU2BOKGLrgxSC6tPCATdlm9Gzk3DHn6M67Gy3JYWW
         8kmRpwdmBxBYXb6GHNRYosKU7vNxlGL2az42SS6ql9hBH0ewUjAhNniVPJnUVKyGRlIz
         LfbwdbV5LtYpNp5lD2QCILTJHQFqr5AD0wrZX9XfBnRPGtZUNZavRvcWZSQTdIg9056U
         K/1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757441625; x=1758046425;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=v5MIgyNMcuVeoaHKE3jeJkB/cPJ+KgcPL9K1KGUT/k8=;
        b=C+Kz+6Vw0gL8Tq+CZFJXQwUnBSxt4DjJQp52GqVqmacxzR9N9Xg447nWDx0gnthyq8
         I0fLXxZztjUzGNARAAuxVI16H45zO5h9noTcGeW03oxr0BeI2FFfoWXJRocb23CqN4VT
         +0DUsjCddYCv0TUsqPD1+F/17vyslTewbAkbEz2Haix2NMoCX70NfzGnHYDDAfI23Hss
         gzmxCpsWg1mTMplaogE98KWl9imi2KQT5lgl5FJ2Qsz4rVPvGMM4crrn/plyyswmGLwB
         Tn1u7X2uwBTsG8KV+crV453kq8gz8yZThMjxX67CuG9X4MO7H2UGLlrb4o3mXazTpFJY
         cgcw==
X-Forwarded-Encrypted: i=1; AJvYcCVuqt5q9vS+B9852UAHvq+bD9EO2g2do71mHMxClX6FnAN1wgzWxeDwPNvF4hs07O4B2lPiQqUBXA==@vger.kernel.org, AJvYcCX4Bj8Z5Dqj+EDrB3+MXYUcSQrOyZHrzwTsmJ7iMa/hFDOfq0zwgxTkBq1zkJbRjCCbilKQO9iI923T@vger.kernel.org
X-Gm-Message-State: AOJu0YzjbwBZHmcGMPSJwxJZu2eCsnevo5hhA+1Q5okjgh1KGjAo8pJq
	GrbACnJtPsSqyi55oAPh6WZ5WlbWkIyDRbZFw25vI5E/6qSMcwjr9s3qe9jfa9tKQxO6d70pgUU
	yd65cFRoRcchH/1mCpBc4W5bwA3DYxlE=
X-Gm-Gg: ASbGnculhQpogps6JpgmZ5+XXWUzDHMbCLZaFc9bDYqd93dklBg1ACCsu7mpx2BzKk6
	9mlAeWCT7NgBbPPqAs+cI5+ybs8DreM0M4MYs+pehag+ukHvbDIgpP8Cm0YcAJfJuuu0QqZyeWM
	rclIhp/OwcJTAuegNRFa/BbsYeNOxv8irQm1BRvLaobB14ylcmpAe+++5b1SHfXZHPhMXqxEp+Q
	KtJQGT4BSLkWgkkBiU7eS620agfQwbt1w==
X-Google-Smtp-Source: AGHT+IG69/CJrKJwYK4JKcm+s+1TRjF8ogI0fllaYgf11+PXm91pngy54nGXIr1gtbJ2ajS4oMoihnLsVSPRe5IbZgo=
X-Received: by 2002:a05:6000:4184:b0:3e7:d46:2f64 with SMTP id
 ffacd0b85a97d-3e70d4632a2mr10640424f8f.28.1757441624642; Tue, 09 Sep 2025
 11:13:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250905-sparkling-stalwart-galago-8a87e0@lemur>
 <68bf3854f101b_4224d100d7@dwillia2-mobl4.notmuch> <5922560.DvuYhMxLoT@rafael.j.wysocki>
 <20250909071818.15507ee6@kernel.org> <92dc8570-84a2-4015-9c7a-6e7da784869a@kernel.dk>
 <20250909-green-oriole-of-speed-85cd6d@lemur> <497c9c10-3309-49b9-8d4f-ff0bc34df4e5@suse.cz>
 <be98399d-3886-496e-9cf4-5ec909124418@kernel.dk> <CAHk-=whP2zoFm+-EmgQ69-00cxM5jgoEGWyAYVQ8bQYFbb2j=Q@mail.gmail.com>
 <68c062f7725c7_75db100eb@dwillia2-mobl4.notmuch> <u7jigxix5g3l274ciqkrcvg64fnrqute4vaiwn4tftfzs3cwzv@o4fyr7guogzj>
 <CAHk-=winCxfCXfTgjfhdqkp2EXrx7fbrGookkHuAtT3Lp5xT1w@mail.gmail.com>
In-Reply-To: <CAHk-=winCxfCXfTgjfhdqkp2EXrx7fbrGookkHuAtT3Lp5xT1w@mail.gmail.com>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Tue, 9 Sep 2025 11:13:31 -0700
X-Gm-Features: AS18NWCcde3u6VnJ3IQPqJInT2PGGtXFf7eGHpXP9Gg3U1Fpz872BScmUYyp-9w
Message-ID: <CAADnVQKAR-MnALzJXdvdef4ftgMA1=Z_c4bnzep68yO20vLAow@mail.gmail.com>
Subject: Re: Link trailers revisited (was Re: [GIT PULL] io_uring fix for 6.17-rc5)
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dan Williams <dan.j.williams@intel.com>, Jens Axboe <axboe@kernel.dk>, 
	Vlastimil Babka <vbabka@suse.cz>, Konstantin Ryabitsev <konstantin@linuxfoundation.org>, 
	Jakub Kicinski <kuba@kernel.org>, "Rafael J. Wysocki" <rafael@kernel.org>, 
	Caleb Sander Mateos <csander@purestorage.com>, io-uring <io-uring@vger.kernel.org>, 
	workflows@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 9, 2025 at 11:01=E2=80=AFAM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Tue, 9 Sept 2025 at 10:56, Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > It doesn't work reliably. Often enough maintainers massage the patch
> > a bit while applying to fix minor nits and patch-id will be different.
>
> Honestly, if you massage a patch you should probably mention it.
>
> THAT is the kind of thing where it actually makes sense to say
> "modified version of XYZ" and pointing to the original.
>
> Look, at that point it's actually *IMPORTANT* to explicitly state that
> you didn't actually apply the original patch.

and I did in the email reply (as you could see in the lore link).
That's what we always do.
Email is the way to communicate such changes.
Sometimes we rewrite the commit log too to reduce verbosity,
fix typos or whatever. Without direct email reply developers
don't notice that commit was tweaked.

The point is that 'git patch-id --stable' is not reliable.

