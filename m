Return-Path: <io-uring+bounces-9741-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id AFE2DB531FA
	for <lists+io-uring@lfdr.de>; Thu, 11 Sep 2025 14:21:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EFBE81C86CAD
	for <lists+io-uring@lfdr.de>; Thu, 11 Sep 2025 12:22:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81831320A2D;
	Thu, 11 Sep 2025 12:21:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YkCZkaxQ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1003317712
	for <io-uring@vger.kernel.org>; Thu, 11 Sep 2025 12:21:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757593298; cv=none; b=jY+uE6IOCpZGMjz8ad8MYtpB12DFrIt6Mm2DJVtIx07ndz5I42L4/dN5ljiK8tXHIfKWg27uZC5klawqmJVGlJX9feHjgVWpcyzBzPcSVvbvxGq1k8pNQooVqc4+fNVZoqGnvmext50QJW/bLSlHnv8sutyX2KfJ4OTSU7sTo10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757593298; c=relaxed/simple;
	bh=zsjFv5zr1LpOBJ94icfsXcnZZdQg2TC0dE3twphEhkI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=is5cIHzir3YAsNVXrT6KE7ZUA7Mv3REyg5aYyjD9ayFWyvGTKI5JcII/WUaco2Ah3abAxyKRpTZzxTXxVsDzrOeVotn7tPS+FUjmTDcP94k1bLeARkkS4crtvoOU5YnxKBHdIS2KnO+fz1KJ98CzlkzuSZIcRohIUE/C0L5O8Ek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YkCZkaxQ; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-6188b6f7f15so843886a12.2
        for <io-uring@vger.kernel.org>; Thu, 11 Sep 2025 05:21:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757593295; x=1758198095; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QW1bR3dT4ig6jICrP0+Uk0rGADCReVxH2fzr0rO2otM=;
        b=YkCZkaxQx7mIJqsL5+k9f+3baFLv7NThUZhY8NjImb1IQBmupAWNY7IwfczNJDhjhp
         awqCNLcIcizHYnyJRTWiDg74bNTqc1C8WcYfMVFQp3bxEXV7OkdfPlVid4EUqXdqSv7+
         8sMbNfPbvRq0dzi+3XNbFKleeCwkC2LoisXFjg0LMfnzMMK4ETgnTwnfOVdibQAxEwYu
         Nm8ykRA8yel2j3wUDOZONK5yUwEE47mSAhxWCjeuXOrUwORedHU2CxqOmlL9lLCbmY5s
         tiBhIsSd/AtUFIeuPvXfP+hnJPVTcJceqm2T8OGT9RYAPgpsk8K7dmVkMs1EYaIX2s61
         8Ssw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757593295; x=1758198095;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QW1bR3dT4ig6jICrP0+Uk0rGADCReVxH2fzr0rO2otM=;
        b=eiXaJ5kEQ1esT5fewGoGlWTcxEzodjlhmMmjX5UJHKypvEZrGEcvNc7+Vkb24D7WQ3
         jJ4XIi7xmNRuR27EMwWux65Xpe8/Vf1sC/ecBavIFfukw0/+RbQOdOQuJFp60WMEsUOW
         OY/6FLUJ7Fhi9kIeGE9/RKUxbX/LfO9AKpnuPxOQPMXtubEzizZT+o3zFwB3nCpk41sW
         Qpc8D3BvgegLOgJkVIfsW5ZoNSM3EeNG0DNSu6yJ2PVXLb8t5LD6YJQmNMzPU93PAO/f
         tbjMVk1b3gCOXgGjSE57j9uePr2TkpiruoIG7GXvbEjWZXXA50lAEFO0pWsquRSae5jb
         FKYA==
X-Forwarded-Encrypted: i=1; AJvYcCVawzSmL8iFJ2Txu2c0nktWRY+kLKK2RTeg//p+i0qe9Wc8nSX1SVx/bS6XZZuJw8QJK+mNh1Q33w==@vger.kernel.org
X-Gm-Message-State: AOJu0YzaqxIeR8n2VAh3FhkqiubNbRwpce8XjGH+6yHixwurlcngLfN0
	ce3fzu4MOsjLxzcMfxT8ag/fLVCXeN3jryUrZ6K2w6Pyd+hgNN6c43KYmDQqmpnE/Xu0kFIyWXe
	hqGwUVNhHxI8k3ykWKyiQRcwUILgiDPc=
X-Gm-Gg: ASbGnct0s12IQZPjjdzCmok1UmGFNZ3dOJ962WiF8WUryzfbNmADNMLH1Qq4k2G+M0j
	fhM3hckmYZeBTPg6roLjLPNTIYPzGN9V2FEfHVNnNOFnz9W6Yhn/VYoLYUO82vWsrXSW4f0u+Ab
	1J2PCHQkNPOHhgSO4lmuMtWo659QiWh/woGsbbCsYj+J11+0BkeJvwZ4FI+CWAmbWFr1QwISTxs
	9jasTeEDGdSDxFLmA==
X-Google-Smtp-Source: AGHT+IEOtkqzFL8PXhrosjpXvuR6sCfAdER8NfA1zUZso1KJwXrMcisMdPmIZ1UPB4FtaW3bfelQnQy+IfM10Lg/90I=
X-Received: by 2002:a05:6402:90e:b0:61c:35c0:87c6 with SMTP id
 4fb4d7f45d1cf-62373df677emr16291803a12.12.1757593294978; Thu, 11 Sep 2025
 05:21:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250910214927.480316-1-tahbertschinger@gmail.com>
 <20250910214927.480316-5-tahbertschinger@gmail.com> <20250911005312.GU31600@ZenIV>
In-Reply-To: <20250911005312.GU31600@ZenIV>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 11 Sep 2025 14:21:23 +0200
X-Gm-Features: AS18NWB0WGVdQiNKClrYvBv-3z0NQbmG39ZPh18gG3MBd4a44MagvnggPo4jNyA
Message-ID: <CAOQ4uxjNf0sq8eY4kq00sF9tLO9P4kYbYWGGTWrEMX8NWjbE2Q@mail.gmail.com>
Subject: Re: [PATCH 04/10] fhandle: create do_filp_path_open() helper
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Thomas Bertschinger <tahbertschinger@gmail.com>, io-uring@vger.kernel.org, axboe@kernel.dk, 
	linux-fsdevel@vger.kernel.org, brauner@kernel.org, linux-nfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 11, 2025 at 2:53=E2=80=AFAM Al Viro <viro@zeniv.linux.org.uk> w=
rote:
>
> On Wed, Sep 10, 2025 at 03:49:21PM -0600, Thomas Bertschinger wrote:
> > This pulls the code for opening a file, after its handle has been
> > converted to a struct path, into a new helper function.
> >
> > This function will be used by io_uring once io_uring supports
> > open_by_handle_at(2).
>
> Not commenting on the rest of patchset, but...
>
> Consider the choice of name NAKed with extreme prejudice.
> 0.01:fs/ioctl.c:        struct file * filp;
> 0.01:fs/ioctl.c:        if (fd >=3D NR_OPEN || !(filp =3D current->filp[f=
d]))
> which was both inconsistent *and* resembling hungarian notation just
> enough to confuse (note that in the original that 'p' does *NOT* stand fo=
r
> "pointer" - it's "current IO position").  Unfortunately, it was confusing
> enough to stick around; at some point it even leaked into function names
> (filp_open(); that one is my fault - sorry for that brainfart).
>
> Let's not propagate that wart any further, please.  If you are opening a =
file,
> put "file" in the identifier.
>

If I may join the bikeshedding. I find that an exported vfs helper called
do_file_path_open() does not sound like something that is expected
to call path.mnt->mnt_sb->s_export_op->open().

I am not sure how to express that in a good helper name.
IDK. Running out of names. Maybe do_handle_path_open()?

Thanks,
Amir.

