Return-Path: <io-uring+bounces-11371-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 7DC2DCF5449
	for <lists+io-uring@lfdr.de>; Mon, 05 Jan 2026 19:51:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id DD6C33057103
	for <lists+io-uring@lfdr.de>; Mon,  5 Jan 2026 18:48:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D4453009D4;
	Mon,  5 Jan 2026 18:48:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="d9VrOgxv"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oo1-f54.google.com (mail-oo1-f54.google.com [209.85.161.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 972D41A9F85
	for <io-uring@vger.kernel.org>; Mon,  5 Jan 2026 18:48:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767638917; cv=none; b=pWiX9PW36P+phPb83jil9CSWkihgHk1XtEMlT4NER7lIA9HxmvkmoUjNBfopLtLQAXVeD8yE0Rq2oQE0Ak2Uxr0xhOnRTrY3CEHeJqFTEQxdWYdMHviTS2SyH2WXKpkIwzdxli3ufxQxZsFCaoq34YPGSpCxW4ysIKTA5tDmYQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767638917; c=relaxed/simple;
	bh=DTZ8KiTOYhKKF7JWpxvSypjJd/tyi/UI8lOO/R/foeo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RWU4RmWAmauNq3cNN/VRrHEZnAKcST5zXWB6D/B+6APTRu8LpNCFYziSgVgSvGFr8kF5kAkFD6rshhp0/IiSOiXipEc6aiY6qR1hHSD/LcxjH03oyG04LR01DdNQmD08wcKAUeM2Ll/yXFPt4mRW7ohgFboHm5njFSaNmpIU1q0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=d9VrOgxv; arc=none smtp.client-ip=209.85.161.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oo1-f54.google.com with SMTP id 006d021491bc7-65b6b69baf8so64200eaf.3
        for <io-uring@vger.kernel.org>; Mon, 05 Jan 2026 10:48:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767638914; x=1768243714; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OtolCuYzYAufR5Qi+keXAb6Ku5HPbADoe47YYKB+jAw=;
        b=d9VrOgxvYgqwOF7hHVBQXne41xGlbjOnnFPNGw3GDI/8rRen7TBcimLYJcIglVZJwL
         pF2Z9vn4RZbzBYWkIl1ds7yG8onfPXLxmRn6+eFQd1UDwP1Cl8C0YEaFMMTEPOEgDsom
         ztRxYs2s+aACOOpfKnxzC5/j2NaKwmDXCpvOVyfJkilndylO4XiAuISeFAWwLS+H45HH
         lkY9SWetlsoRtHvbQu3xls+rLsXqQsvwNoxyrlNaWjVRXvM31Snp1F2MMqHiWmFyEsPz
         skCuLGwhptK3gshiIzZEP5ITcn9STOp3iilq7BomuIt62yL269TeLzpLEiKnu5Dz049l
         F8qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767638914; x=1768243714;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=OtolCuYzYAufR5Qi+keXAb6Ku5HPbADoe47YYKB+jAw=;
        b=pYCxa4sgj8euPJxXpYw4QuYFvNOadYVsHHJpN9KyZ11k/d1j9wHOen0HDANoUm+tWv
         ZAyu5SlCXXINTnSUqMjU3oRePYPkKdgw0c3/4+dtN3DR9h1+OZLIQYqEKQ9+i/latUlS
         eRmqI9vFZSMOXt9sxYtnYepFi9RMWqdPffPbPfEhfOljwTKqYr2IejvHPth2TdAHe2eo
         /xTgVWfSs7wM07luM0LztCdzunMBX0btpjV1ndbEGGB8ndF9x5W+qO7IPeDdQyqq6i0U
         7uqxBtrPwUGd5R1uTiyHdzwGabG917SZHopNyT1Uu/8nLf4I1uRXzwCyblqi8mqTTIwN
         rmBw==
X-Forwarded-Encrypted: i=1; AJvYcCXZ6TZYdlVlj54FAxM0rS6qPQMacXxIYPYk4e42e39r+dSLQ5x/Ifbquk0tTA0fyl7vCpY+RzpmkQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw6jJua07RsCJ+/RGylH3KSzHZX3RW0dZrbDBzSXRqnjoIDAKwM
	abO23eB4Nmnv/61uyzjFV4fKQLdjwH/OnNcD/vIhQEC9/90j2poknA9kZnmR6xOvP+5HiTEw8dN
	WOVcBoFz3z7NTMyxa0Olu4T3MR1BYhXtusw==
X-Gm-Gg: AY/fxX5S9002dIRCZJlrazgfR7s6aq6cdv1J9CI6TxcSLJJwiJKwZx3dG0jMtHJ21W8
	XoYxTq93E9zzROg/XIeGixhPZW9cjAWKvcNvhahwV+AcroTrVRt/XmH+0vCkToD6Ay2TUlwZxKk
	hMFtnYsbMBWZisEsseR6gUccaqZISRmIu4pU7LWeu/oQDTVLE+8TIjcWqsLbrJYp1cgJF3w9ahQ
	IYQ9kcpRxslpqP7Ys1hjTccxdZFfL8HUaPBaI6uXwaeMP6HcOIB1z/1NDDeCqPea/B5L7I=
X-Google-Smtp-Source: AGHT+IFHfv73Y3+mWKIEQ8fD1NYvD2ClmijWLCv3FtUKYMFJTc4JQ4rh8Q4MGpnBlu8Ckp4YrMju5xzUoKctf9JSWqk=
X-Received: by 2002:a05:6820:1501:b0:65d:1e7:953c with SMTP id
 006d021491bc7-65f47a62978mr211576eaf.73.1767638914427; Mon, 05 Jan 2026
 10:48:34 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <f98f318f-0c3b-4b01-afb2-2b276f3fe6cd@kernel.dk>
 <87y0mc6ihs.fsf@mailhost.krisman.be> <53244a6d-75ca-4fa0-90f6-8d2952d85b46@kernel.dk>
In-Reply-To: <53244a6d-75ca-4fa0-90f6-8d2952d85b46@kernel.dk>
From: David Kahurani <k.kahurani@gmail.com>
Date: Mon, 5 Jan 2026 21:54:18 +0300
X-Gm-Features: AQt7F2oyT74kgNXO5pX8F2KXLmcGw04OSyHjk08nsy-ddZFy5IJEgAAe2bm_kmU
Message-ID: <CAAZOf26OeMPr7wrcJsZ94NVXBSstYLWNQDU8_JNeuAw_gszeTw@mail.gmail.com>
Subject: Re: [PATCH v2] io_uring/io-wq: fix incorrect io_wq_for_each_worker()
 termination logic
To: Jens Axboe <axboe@kernel.dk>
Cc: Gabriel Krisman Bertazi <krisman@suse.de>, io-uring <io-uring@vger.kernel.org>, 
	Max Kellermann <max.kellermann@ionos.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

FOSS is generally in perfect condition for rip off :-)

On Mon, Jan 5, 2026 at 9:41=E2=80=AFPM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 1/5/26 11:07 AM, Gabriel Krisman Bertazi wrote:
> > Jens Axboe <axboe@kernel.dk> writes:
> >
> >> A previous commit added this helper, and had it terminate if false is
> >> returned from the handler. However, that is completely opposite, it
> >> should abort the loop if true is returned.
> >>
> >> Fix this up by having io_wq_for_each_worker() keep iterating as long
> >> as false is returned, and only abort if true is returned.
> >
> > The fix is good, but the API is just weird.
> >
> > io_acct_for_each_worker returning true indicates an error that will
> > abort the wq walk.  It is a non-issue, since all the two callers cannot
> > fail and always return false for success :-)
> >
> > Reviewed-by: Gabriel Krisman Bertazi <krisman@suse.de>
>
> Thanks for taking a look! Was going to post a followup just killing
> the return value of io_wq_for_each_worker() to void as nobody uses
> it. Only the cancelation side with its matching will use a true
> return, most of iterations want to iterate all of them.
>
> --
> Jens Axboe
>

