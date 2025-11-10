Return-Path: <io-uring+bounces-10512-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 310B6C49B69
	for <lists+io-uring@lfdr.de>; Tue, 11 Nov 2025 00:14:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D686F1888720
	for <lists+io-uring@lfdr.de>; Mon, 10 Nov 2025 23:14:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C4DF301495;
	Mon, 10 Nov 2025 23:13:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b="RXDBiAkn"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA29B2D8DD0
	for <io-uring@vger.kernel.org>; Mon, 10 Nov 2025 23:13:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762816435; cv=none; b=P6ruUYp1UHd4VUyU4WFVoXr3P/5liZ3nCpW0xG1jQmPJZ+1DviJHujhe/ZravZlMPxhrY2odw0MIZiKAig0zOLVDMMRDQx2Bszhd+spFzVmOItpQP/4E9cWCC/CH/ydpoVCToJnII3TW9fFqPMwCU3BmJma7ArNRpmFjeGDmV0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762816435; c=relaxed/simple;
	bh=6HrRYtMJ/Wfde6dGoSgVBHgpsjkZ4V5YvSNZm+omjEU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RtwMgdlqwWXo+K95vU7DaSOmS5No/mUwbk3wp/i/Itepwu/ZF3OBqaJmvT4yx5XIOmpVtTnjjIyzbzRbQ5FjDOt1BPPZxI13bvkGCF14JHNS4OEVGB6B4PjKazoRIzVzIO4AredSHW+Dqy1ZrMishldzE6WmzuvT9xmYTMtwZFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com; spf=pass smtp.mailfrom=paul-moore.com; dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b=RXDBiAkn; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=paul-moore.com
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-781997d195aso2302415b3a.3
        for <io-uring@vger.kernel.org>; Mon, 10 Nov 2025 15:13:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1762816432; x=1763421232; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=q3KPhXF0t2wnycc2aLqfqc1/q03aoID4kpmhgGyPorc=;
        b=RXDBiAkn2dVPauk49CpNDOtPnDvSFfSspcrEAPutbLHjiBHmU1W1Ub62avfwLMPtyK
         SQWjsersDoMq9bs4StfgDCQwkqwxJsZpLVnA8Y7kA2p22+B5UUBgOF+JcseAGc4jOlOm
         sMOeLSW22SdBJUHAIwlZdbuJRl52SOQJNJ6EV+6dDsItSbt25/KRq0tMVbY6XtdbU0vk
         MkBSyM0rHtyPpnsWE+kXlPOffLGxD1A83l5m33Qmn2cBrOz2TjaiIqyYb5DG2zTwFqpp
         7Hgh8M8LISoDLOpDJnzozZZRw5TPRWzY9PRCXUkrC0kG+r16N2mS+l8HkXl/13J8X0Mk
         L4pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762816432; x=1763421232;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=q3KPhXF0t2wnycc2aLqfqc1/q03aoID4kpmhgGyPorc=;
        b=dWML34Aoh2eW63CpyD+7ZAfMMtXaJBRXI5pULD96pDBKXDa3iBnj5gl2ZcAYt70z+b
         AeaZpgcupaxfqNzbyn3CvCazZY29t4AUYag4sViElhYaX5EC/g2J0sOT/SWT+amKt4Zw
         fYqn8SEDwjw6O02TwbFzX+uOTm9s67jcItf765hQpCG9d2Z6B40qRSYOmoBDnlULburd
         jtV1AdfmvdiS6pjxFMWNeCx1sfKZZOa9YiLoZQxkrr/qa6q+SQCmUuzFcv0eRezW56oR
         cMGqT0jecaYIoHonjMzFWqhKWYau85DCR1qEZHXQGtcsKnFIuDOJ4shHUpd67RRZVt2f
         gx5A==
X-Forwarded-Encrypted: i=1; AJvYcCXoGpwLXMuJhrvGT9zLRZTqs46gH2GWfCihzp+qa6/zjkNjKsRaJS/7GdlYUdlK6b65w1C0izUZvg==@vger.kernel.org
X-Gm-Message-State: AOJu0YxQvYknA0aBjYiAlIFpspVmMMciSTynxt8Wp3y3yguOsB7Yk8kq
	/maaYxT73qiIqyiVjn8CVbuxmbzy1k8GwXI94s96k9/Ys1FsBGHqAUI0RwLGsUGaOTP5axyhKLy
	G2HUBhhsMsYTPVCDcDQCbape890iXyICja/qyQkyo
X-Gm-Gg: ASbGnct6isrEQm2VFOb2qeoTAjihz9RNyJC1gQAaVOndTUj7IxJ0WskbrsefeMBw8Ur
	kpt7jO2RwU68d/4IbtBosOrqNC3zcwqo3tHRpVonZyxTzWwyysOgLOkW28qSYMM00Ypj2cvKkyj
	+hiUw7BHN8MTpNjl+03l+7X1wuphMsvyj3rQ575zm7foNcrdOuH6P715CWLdjBTedQypgKn9mlX
	wgWhD9ePtUoLB4WgEAmwRwS1zdxPlgrV0VGIzboxMP8Rg1aMOUJ3ziKBgZ8
X-Google-Smtp-Source: AGHT+IFYNRYOcq3lXTSLxepvhFlsqHyQOENBHvM+0XEW3jFrOeqIEOlKzMsifFBfU3mbMDgiQHfz3UnA14dsSUJ+7p0=
X-Received: by 2002:a17:90b:1809:b0:340:2a16:94be with SMTP id
 98e67ed59e1d1-3436cb73f03mr11262409a91.4.1762816432065; Mon, 10 Nov 2025
 15:13:52 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251109063745.2089578-1-viro@zeniv.linux.org.uk> <20251109063745.2089578-11-viro@zeniv.linux.org.uk>
In-Reply-To: <20251109063745.2089578-11-viro@zeniv.linux.org.uk>
From: Paul Moore <paul@paul-moore.com>
Date: Mon, 10 Nov 2025 18:13:39 -0500
X-Gm-Features: AWmQ_bnCgAh0ZKGySfJXTPcRIiGidW5nkGfPuxkAP29SXlrBtrADhb7UtVTCqhw
Message-ID: <CAHC9VhQjzt0nJnbwXuwT7UPBwtHjEOPZu6z=c=G=+-Wdkuj5Vw@mail.gmail.com>
Subject: Re: [RFC][PATCH 10/13] get rid of audit_reusename()
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, torvalds@linux-foundation.org, 
	brauner@kernel.org, jack@suse.cz, mjguzik@gmail.com, axboe@kernel.dk, 
	audit@vger.kernel.org, io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Nov 9, 2025 at 1:37=E2=80=AFAM Al Viro <viro@zeniv.linux.org.uk> wr=
ote:
>
> Originally we tried to avoid multiple insertions into audit names array
> during retry loop by a cute hack - memorize the userland pointer and
> if there already is a match, just grab an extra reference to it.
>
> Cute as it had been, it had problems - two identical pointers had
> audit aux entries merged, two identical strings did not.  Having
> different behaviour for syscalls that differ only by addresses of
> otherwise identical string arguments is obviously wrong - if nothing
> else, compiler can decide to merge identical string literals.
>
> Besides, this hack does nothing for non-audited processes - they get
> a fresh copy for retry.  It's not time-critical, but having behaviour
> subtly differ that way is bogus.
>
> These days we have very few places that import filename more than once
> (9 functions total) and it's easy to massage them so we get rid of all
> re-imports.  With that done, we don't need audit_reusename() anymore.
> There's no need to memorize userland pointer either.
>
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> ---
>  fs/namei.c            | 11 +++--------
>  include/linux/audit.h | 11 -----------
>  include/linux/fs.h    |  1 -
>  kernel/auditsc.c      | 23 -----------------------
>  4 files changed, 3 insertions(+), 43 deletions(-)

Looks reasonable to me.  Not sure if you've run it through the
audit-testsuite yet, but I'm building a test kernel as I write this,
I'll let you know how it goes.

Acked-by: Paul Moore <paul@paul-moore.com>

--=20
paul-moore.com

