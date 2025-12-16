Return-Path: <io-uring+bounces-11055-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 78EC8CC094A
	for <lists+io-uring@lfdr.de>; Tue, 16 Dec 2025 03:15:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id DF6653002B90
	for <lists+io-uring@lfdr.de>; Tue, 16 Dec 2025 02:15:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED9A52DEA73;
	Tue, 16 Dec 2025 02:15:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b="WwNKOCS3"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F98C2DECAA
	for <io-uring@vger.kernel.org>; Tue, 16 Dec 2025 02:15:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765851306; cv=none; b=Ye/9eZdGfONFekW/ZMVGBe6vO8IFr9I+/IPWtrIEyvgMWBBm5QqlRzkp6Pv0NPNEkhAageLDP9i8SBb/gKL1djayOOzVbbvJCKotKs31DHmrUVmFwi1RlyVLjCS44j+N4rU57/qedgiFDDaVrEaJVa8PguXb8vD11E8G5Q81DnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765851306; c=relaxed/simple;
	bh=mHIQ3K7sP7Qo6HURq375MN+fcdkJK/fECc7bztH5Gg0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uZeIKZeDwZC/4li9rWspnPWB4OnZ1uD/PbCrh1cuaolZZ8KrXS8liu6+vZfxOw5aRcsSPARCaNY9W9IrV1nSEsQdfBu8GhYGAO82Etzy5MJ7MPQW08X2l8eJVoC67bTf+tKbV72e6D7XE5+BKnwaSZ/DTKty6/HYBbZFTHa3ECM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com; spf=pass smtp.mailfrom=paul-moore.com; dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b=WwNKOCS3; arc=none smtp.client-ip=209.85.216.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=paul-moore.com
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-34a4078f669so4230263a91.1
        for <io-uring@vger.kernel.org>; Mon, 15 Dec 2025 18:15:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1765851301; x=1766456101; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=38ml30ZTmrZzOgNljrSkMybnSbK+YMYdltkMc1v5iPQ=;
        b=WwNKOCS3xFOgRYBgCEGy2byHp2QnL/DF1z9W4q6GUGQZxPzo17NJtF29hwBaqrQKDh
         FG6I2PZzl6hnNZ6H6zSkdUGYROMEUWyrnzmdN35n7BW6BmZBtIkzK+T6CfOHUAlYV1J3
         wWPmW44lxv6PqmCsbjzvauKfQjidLzNVwWd09ihKLjkHLMNi7qoQnNZQ/PrvOJC4vewV
         Bx885w7fZoCdBR/3hsY6zVihW2UToL35CxpOhV3jOJ1O/BwAlK6iAvLJ+zTb2DxJ0Fhu
         wgLcXhOkO2DR22Iy7z3uZMoSyeRFXVhIfKjtUT1uQzeKruGjhWwVQ+4YoltXmbyZPqrQ
         pNWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765851301; x=1766456101;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=38ml30ZTmrZzOgNljrSkMybnSbK+YMYdltkMc1v5iPQ=;
        b=CpIAv8yK/OnzlPBJXTR/hES26GyTJGVaqYD4n7sT1cB1rb13vNjbfINFZ7jlLTRMl3
         mKVA1xLe0Sih+rZ2yDrggMBeyoUnNonVMBgxEIvq6d44S1yHer8XXPAWAW0l1SyKxGIn
         /2d4EpVj72hMeVm9JlCnPP4po2CYyvL9dGr4rJN0fsdBzoOLq0Rh/KSvBDojrIADifw9
         FrmN8kQwpXGmp5CrqzIx1eqk4JpSyWdySeaOgyMHj6tRdv7cxsXHzT7GjpR3VSnXBvNU
         mZspW3Nw9NRmjvU9ruztWIbe3Jk4QU4LQuorZMQQrQ4s1kLxTNq7pRYN4Qy2T2Vxy1iL
         5GVw==
X-Forwarded-Encrypted: i=1; AJvYcCWLBplmekMzWuAvQqwA7aUBM6qAeiuBNjhyFKrkIpH6X3x3//A29mDQhUFvJ3OPoZOpfHCjVDT+2A==@vger.kernel.org
X-Gm-Message-State: AOJu0YxLkj5WDn2zj5mNxTr8qIw5ydV/jKJ/fw96vY8e1lo2Gkl8uMie
	rn7vat8PS2d9O2mFt7fNUaAEzF9E6rmXrAc8XwzgV1cnKsOXqN50tLsgLnHU42E0Ao7gixmeKUw
	GhEAJYvHkER8RaAz3CWjjivzPjRPHcl3QQvABXFnB
X-Gm-Gg: AY/fxX4Q/fyRDbntDUqG4/l5ll2V5whC8+l8594+5NuXKcjZYQ3JelwluzdaA2ElUo0
	o9De+K5BaNfVdNuOYXmyByfYfLljsVl1qrAc+CaM+wm8AXEkMH+gq/oAV/Yj8xJjdyEFUCub9o1
	WUw/171SmqQSNQmXDH9qQBETOqrFB7hUQN577XHkPi7+gao4msmX3WuDNMeJAy6ehgpAYQzwIr9
	4I4wpZWy7sUb98SI0jossu1+eqsA1kyoExEOhgqNCGjlE9OvKkzvEYNzhV+d9i/VRiJu8Q=
X-Google-Smtp-Source: AGHT+IEzILe8qN9GD+El6RTbu57JAPcibcqUHe3pox4dYTObNHDk/4LK8IIO6QY7li/HRvvvM7+FagcZijrn+duBKEY=
X-Received: by 2002:a17:90b:3910:b0:349:2154:eede with SMTP id
 98e67ed59e1d1-34abd6dd274mr12326997a91.14.1765851301257; Mon, 15 Dec 2025
 18:15:01 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251129170142.150639-1-viro@zeniv.linux.org.uk> <20251129170142.150639-11-viro@zeniv.linux.org.uk>
In-Reply-To: <20251129170142.150639-11-viro@zeniv.linux.org.uk>
From: Paul Moore <paul@paul-moore.com>
Date: Mon, 15 Dec 2025 21:14:49 -0500
X-Gm-Features: AQt7F2otW5TQ5LB6ayzoga_HfwJjV0bPobz73V93964UI8HoCd4VmH9OihuPZCs
Message-ID: <CAHC9VhTaQU6311zSx7P+oyv+rbrehfdQ7n7QJAEeqnSnMmL1Pw@mail.gmail.com>
Subject: Re: [RFC PATCH v2 10/18] get rid of audit_reusename()
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, torvalds@linux-foundation.org, 
	brauner@kernel.org, jack@suse.cz, mjguzik@gmail.com, axboe@kernel.dk, 
	audit@vger.kernel.org, io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Nov 29, 2025 at 12:01=E2=80=AFPM Al Viro <viro@zeniv.linux.org.uk> =
wrote:
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

Acked-by: Paul Moore <paul@paul-moore.com>

--=20
paul-moore.com

