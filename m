Return-Path: <io-uring+bounces-10513-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0C0A2C49DC2
	for <lists+io-uring@lfdr.de>; Tue, 11 Nov 2025 01:24:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 04F63188E785
	for <lists+io-uring@lfdr.de>; Tue, 11 Nov 2025 00:24:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 777CC19C542;
	Tue, 11 Nov 2025 00:23:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b="POT8RZoV"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC89119B5A7
	for <io-uring@vger.kernel.org>; Tue, 11 Nov 2025 00:23:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762820605; cv=none; b=IEDZWHKEInDu1lVWnRcv5tb94Q5VGPA5VrYLkwjBnerqCMEcCRRVIgZoOVI80ILFy92qOznBkB0r00YNNQzL0CKZr7MqngQeKMHNauFuMgYxV03/2mygCCgzpmkSPT1vTvkPq3e4rpdjnr3dyEh2az1ANBRdg/UfoFLWXd1lJkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762820605; c=relaxed/simple;
	bh=SY/HFJpytkf+nFpwanwJw1fx9K5HCqkmPfW8bqd6qg4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tZofJj3jbMv855s2YMsdBLfKKruaulvnTeC92pWOSGInRPBeormj4o/eAP5v+TkIPqpnpLbVXXyDsCOgcLHX8ERsYJiUdotznswynncIpmptw2MFZ1AHbjq+SQ94mVlx23bxHdEmOrt/gTeQrE9HuGJocR+DJm3DEF2AMSoafR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com; spf=pass smtp.mailfrom=paul-moore.com; dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b=POT8RZoV; arc=none smtp.client-ip=209.85.216.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=paul-moore.com
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-340bcc92c7dso335376a91.0
        for <io-uring@vger.kernel.org>; Mon, 10 Nov 2025 16:23:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1762820603; x=1763425403; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=W3+9M+5M55tGV3eZYdGtHuJ5xbHqc1TJ5Xfs5N1S3t8=;
        b=POT8RZoVu860iAuf0MhS4qkWDubeYbY2qGXKU0WJ27bIuAT/7zNXiexSend+G/vp4L
         YzVjrs6wLuQBs+DHIHIBnu/5N4gZEcZSEIZoHkMNePzdtftd6OYfp1nUW3FyJhpfBO8q
         TertUfnmUrm9lW1RK91RVdk245zEykfathgrvKYbHNgVB6LHnCtSd8jaimRAQsaAponl
         Rl6S/HHzTrlPfPd/oYYW1QRdhjUVgU4jEGuLi3nt0RPmjPVdJX/UoyvNHAuqy2YwqWaH
         SoZYp/Ffd60TEfuUxK4++NCnndBXJ2u5WCzt03iVAu67a6jBLgXzS8ZZ2x8c5TuwtP17
         nD0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762820603; x=1763425403;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=W3+9M+5M55tGV3eZYdGtHuJ5xbHqc1TJ5Xfs5N1S3t8=;
        b=KdqvCv1SyOys1sA0WcdZokuMdX2/A3VRQ/M70VFFmBAQdH7VKSjAcsKQW+Es76y3+z
         0Tkor9+v9dxQyH4K3mtngDlLqKOjUySX4OLss2af2fSUCLirJBWFe/SL9Fh/AVriQTPh
         rhYvuVD5NQjVNfTJDSs7ofAm6eYJIRVA6Vn3ljZD9QwcRhcWbxqlmDp0r2/PhdKrx7Z8
         cR2gj5RTqS3srywRZiC4p6puB0xy7W/ZsmuM0WYMrQfoH7Fzm8x8RsfdzVY0ZGX2YEm+
         SXXzmXkznR/LQS9Je435+k6Iv1UajRuKIcyghNsHPMlXAxBkOqYYketjei05i5brpZj8
         dFiA==
X-Forwarded-Encrypted: i=1; AJvYcCWxcLtTz50qCNfnMC30iIYoy3h5Ga987zZDHJhfx5pbY/8XbBdGnoBOtiy9Z0XYMuMQ+JfTazRy6A==@vger.kernel.org
X-Gm-Message-State: AOJu0YxBjog6YxA8/eKxDEz/8ECiNSYtmryag5u+pXMoqLzL2oAphxce
	44GSda8NAfKgbxEY4JvehVY8ytTOMNTQMloAno0ny4U/Y9naFoWnKJVw/n1462d5BHVTCGhEqxK
	0KRkomUFKM0U41h6eV/h/pg2Am9jEYg/bP17kw2Cm
X-Gm-Gg: ASbGncvA7XjIpcNnMqtJHSkjRr0x21hzs4Nay2x3X5NRnrC6S3bJ9MrXNTuzyo+T4ln
	4zcxFAzG1t7surewfPVQEhKRWPWxl/nfHZhUvW2QvfvMONeA7RxU8t+gcT36O6MmuKFwOG7jxyt
	H/LEAcFbS7RoWKZAbb/cU75yWTXdhcpsIHH1sCmJQnxXu0C5Oez+KH0TnpY+Myo/j/ReXEpzY98
	5CCiGCwHHrT7Y12wa8LQb4lEBLq3bBi4/KVuBDqHBQXa8jtpq2sI7bV3kdo
X-Google-Smtp-Source: AGHT+IGKKFXvoGiwpuj7250U6R+lXP80Kgo4s5yoGQEaNtVEqrSDNucZT1Bw9ABkyZhxSNT9x1CFxaxjgHbtulHgNlg=
X-Received: by 2002:a17:90b:5201:b0:343:7410:5b66 with SMTP id
 98e67ed59e1d1-343bf23e94cmr1515386a91.11.1762820603008; Mon, 10 Nov 2025
 16:23:23 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251109063745.2089578-1-viro@zeniv.linux.org.uk>
 <20251109063745.2089578-11-viro@zeniv.linux.org.uk> <CAHC9VhQjzt0nJnbwXuwT7UPBwtHjEOPZu6z=c=G=+-Wdkuj5Vw@mail.gmail.com>
In-Reply-To: <CAHC9VhQjzt0nJnbwXuwT7UPBwtHjEOPZu6z=c=G=+-Wdkuj5Vw@mail.gmail.com>
From: Paul Moore <paul@paul-moore.com>
Date: Mon, 10 Nov 2025 19:23:10 -0500
X-Gm-Features: AWmQ_bmO_J1uWwhkfIMjYLf5xJIaX93Sr0Zwq3mSA3wxHuho5Pw0As_fNioTvOo
Message-ID: <CAHC9VhROakxXe-ZJNFtpNLeV+P8g5W4VZOdQtuY9NbaOHwEYuQ@mail.gmail.com>
Subject: Re: [RFC][PATCH 10/13] get rid of audit_reusename()
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, torvalds@linux-foundation.org, 
	brauner@kernel.org, jack@suse.cz, mjguzik@gmail.com, axboe@kernel.dk, 
	audit@vger.kernel.org, io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 10, 2025 at 6:13=E2=80=AFPM Paul Moore <paul@paul-moore.com> wr=
ote:
> On Sun, Nov 9, 2025 at 1:37=E2=80=AFAM Al Viro <viro@zeniv.linux.org.uk> =
wrote:
> >
> > Originally we tried to avoid multiple insertions into audit names array
> > during retry loop by a cute hack - memorize the userland pointer and
> > if there already is a match, just grab an extra reference to it.
> >
> > Cute as it had been, it had problems - two identical pointers had
> > audit aux entries merged, two identical strings did not.  Having
> > different behaviour for syscalls that differ only by addresses of
> > otherwise identical string arguments is obviously wrong - if nothing
> > else, compiler can decide to merge identical string literals.
> >
> > Besides, this hack does nothing for non-audited processes - they get
> > a fresh copy for retry.  It's not time-critical, but having behaviour
> > subtly differ that way is bogus.
> >
> > These days we have very few places that import filename more than once
> > (9 functions total) and it's easy to massage them so we get rid of all
> > re-imports.  With that done, we don't need audit_reusename() anymore.
> > There's no need to memorize userland pointer either.
> >
> > Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> > ---
> >  fs/namei.c            | 11 +++--------
> >  include/linux/audit.h | 11 -----------
> >  include/linux/fs.h    |  1 -
> >  kernel/auditsc.c      | 23 -----------------------
> >  4 files changed, 3 insertions(+), 43 deletions(-)
>
> Looks reasonable to me.  Not sure if you've run it through the
> audit-testsuite yet, but I'm building a test kernel as I write this,
> I'll let you know how it goes.
>
> Acked-by: Paul Moore <paul@paul-moore.com>

FWIW, it passes the audit-testsuite.

Tested-by: Paul Moore <paul@paul-moore.com>

--=20
paul-moore.com

