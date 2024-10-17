Return-Path: <io-uring+bounces-3778-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0303F9A22E6
	for <lists+io-uring@lfdr.de>; Thu, 17 Oct 2024 15:00:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A01571F22EFE
	for <lists+io-uring@lfdr.de>; Thu, 17 Oct 2024 13:00:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 82FA61DC19F;
	Thu, 17 Oct 2024 13:00:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="X/bpNVpz"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54EEF1E535;
	Thu, 17 Oct 2024 13:00:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729170014; cv=none; b=djC77/26uDKTd5gUVUzsZBqX6/edGPM7PyXvHfV1VpXmzWI6J7snuxw0s8ZQK1SXPXuF1HbggD3nBrvCy2Sg650KEfcEd3n9EfBp8sBdMBY5EA/cU1YJjE52FpQRJ89CXadRA7nq5prSo8Uh1uZLcvLOlwc6+Dkb+RsdIadBtfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729170014; c=relaxed/simple;
	bh=JbDr14ZmSSH8ZRECFFjdhYYrcMXnKSWFvjLSCRJOJMw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ghugcEZRgcqCrm6QkyP4NwT4HHWcw1PEStOFV7Ouc+5gD2pWhWttvhmnPw6s5NvIHYJ48FlpcpAXipiUqZ2Mga/SMC+QWfw5pQPinIPRdEkBpUxP0FZtmC3SOYvUXYba+OxocM4aGlwVvB/I2sYF8b3rP83TX0lOnkDJ7sQNAHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=X/bpNVpz; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-5c9693dc739so1269711a12.3;
        Thu, 17 Oct 2024 06:00:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729170010; x=1729774810; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=M/sNAOttTRehTqH0GNrvZWX70JRS2nI++C9n6sUsvlg=;
        b=X/bpNVpzi382JW2KcKMZ83Ord1YBm0G4HcxBhf8RiVl0RDsANvAefuuWI0yQleN4aF
         B68iYlsQ3Xk8jh8YvvEz/vl33F/w8q/8ufmB6JYUR9YW0xNP1f9ZA6rxqV4vGblap+SD
         X7MD3K7tzRB5Rd3mwW5IxN7Guo4pmA+aVrAI0KkVEEKPhGl0cwgGgqn1SSM/KyDgh74k
         C1i3sRd50SrjXwY3HYm1ser9cKl4M3t9fiQjniRPVdfk6VLBnHaCOdRzT6XgB0v7ieGQ
         VsFP0/tKouEBulMv0rJMfZi1zhEr+upF1fjD+mLfxZPlao4oDd9AnU4qh6ZpC1XHrzwc
         iHCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729170010; x=1729774810;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=M/sNAOttTRehTqH0GNrvZWX70JRS2nI++C9n6sUsvlg=;
        b=bIpmyQl3nH0hzwR/76o1Iw3jWYrHrTYZ1o2xD9QMC1iuErM0zcRd+848RwHj68HM06
         3b6VYPmAvJakTCNpNKwzJQARtbeDVprQSX1MZkHlL4P2iFMBePOSudwYymR+/OOFFbQ6
         Pf8KoTW+5cG8n9y7sJA6f3zl5D6FztdlnfdV+ivLY+fLdBpGohCqLMmVz0+ksgA+w/Gw
         ZepcwJcGu11iCH9GwmUzp1v6+6ChekQHtZll8JiwgHgNOY1V48RidjvqGsElRGpXyit/
         5P7/uKfTqN6Y3GSKaf1QVL/9Nu0xDn5NLhCk+3e8A0AdLKrnAbnaJsR+rR4kwWVmotyh
         xlow==
X-Forwarded-Encrypted: i=1; AJvYcCVYIRXIn5B674FhHQwrdHisgaZJE8R6zKAN3atK0SrC6L0XPZy+dd6q3zBatBgKFRYlbdTilzhk5A==@vger.kernel.org, AJvYcCW5434Jab6Z341FZETk5TIHPTc/LkiL6ba+NnfZVFeRdMzXDApYAezC/KmsdtrBC+plS4ynpIlh63dLrQ==@vger.kernel.org, AJvYcCXmMAPgOcZ3U2n/kIXGHIvDFWm8iSiIzplqD3bqMn8Ii6lYFCxRMvvNcbfwmIBICDhNuNy5C54onQOmJoI=@vger.kernel.org
X-Gm-Message-State: AOJu0YxZ3z5q+GgzTCFg0ko04iyt121Qivr+AVkDDdn0JSlNfMnwjLKc
	aSZ2Htst6H/HBrk9YiH0iaIq2n9Qx8p075fmwRg2AwK47pyXkdMAI3o6guTnFOMKFJTywpz12Xv
	5VC1QEQGaBVmrWn3k6xTm+PbDHA==
X-Google-Smtp-Source: AGHT+IGamr6o9HLDmizk/nvlvLBMhG6G/RCi0w9Y4JF1DiWP92T0nkk2YMw0YxLct0p0RxUNoQIKIat0oNYuXcfKwF0=
X-Received: by 2002:a50:cac7:0:b0:5c8:a01d:314f with SMTP id
 4fb4d7f45d1cf-5c95ac0d47amr10642342a12.12.1729170009425; Thu, 17 Oct 2024
 06:00:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241016112912.63542-1-anuj20.g@samsung.com> <CGME20241016113745epcas5p1723d91b979fd0e597495fef377ad0f62@epcas5p1.samsung.com>
 <20241016112912.63542-7-anuj20.g@samsung.com> <20241017080015.GD25343@lst.de>
 <20241017104502.GA1885@green245> <20241017120102.GA10883@lst.de>
In-Reply-To: <20241017120102.GA10883@lst.de>
From: Anuj gupta <anuj1072538@gmail.com>
Date: Thu, 17 Oct 2024 18:29:32 +0530
Message-ID: <CACzX3AtdmWgEggmQsfqHU-GjdbQHTq9DwCzW07VG9zaoXaWfgA@mail.gmail.com>
Subject: Re: [PATCH v4 06/11] block: add flags for integrity meta
To: Christoph Hellwig <hch@lst.de>
Cc: Anuj Gupta <anuj20.g@samsung.com>, axboe@kernel.dk, kbusch@kernel.org, 
	martin.petersen@oracle.com, asml.silence@gmail.com, krisman@suse.de, 
	io-uring@vger.kernel.org, linux-nvme@lists.infradead.org, 
	linux-block@vger.kernel.org, gost.dev@samsung.com, linux-scsi@vger.kernel.org, 
	vishak.g@samsung.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 17, 2024 at 5:31=E2=80=AFPM Christoph Hellwig <hch@lst.de> wrot=
e:
>
> On Thu, Oct 17, 2024 at 04:15:02PM +0530, Anuj Gupta wrote:
> > On Thu, Oct 17, 2024 at 10:00:15AM +0200, Christoph Hellwig wrote:
> > > On Wed, Oct 16, 2024 at 04:59:07PM +0530, Anuj Gupta wrote:
> > > > Add flags to describe checks for integrity meta buffer. These flags=
 are
> > > > specified by application as io_uring meta_flags, added in the next =
patch.
> > >
> > > These are now blkdev uapis, but io_uring ones even if currently only
> > > the block file operations implement them.  I do plan to support these
> > > through file systems eventually.
> >
> > Are these flags placed correctly here or you see that they should be
> > moved somewhere else?
>
> They are not as they aren't blkdev apis.  They are generic for io_uring,
> or maybe even VFS-wide.
>
The last iteration of this series added these flags as io-uring flags [1].
Based on feedback received [2], I moved it here in this version.
Should I move them back to io-uring?

[1] https://lore.kernel.org/linux-block/20240823103811.2421-7-anuj20.g@sams=
ung.com/
[2] https://lore.kernel.org/linux-block/20240824083358.GE8805@lst.de/

