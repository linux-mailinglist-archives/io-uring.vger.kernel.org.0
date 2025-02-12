Return-Path: <io-uring+bounces-6397-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4AB27A3339E
	for <lists+io-uring@lfdr.de>; Thu, 13 Feb 2025 00:46:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E6969163B05
	for <lists+io-uring@lfdr.de>; Wed, 12 Feb 2025 23:46:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C7A3201039;
	Wed, 12 Feb 2025 23:46:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="Ldvvc3op"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A14B21FBC9C
	for <io-uring@vger.kernel.org>; Wed, 12 Feb 2025 23:46:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739404009; cv=none; b=NvxX0MMxV+aFqVfWiZQdhJdrXtX4JIOtMzIEcP3GVmvZdQfoXz4A6Lckqv7KgTdsm09J6CZjrdru8tqgqurqDU5uzON5MKHWY+BfcNXWEaQCYiYQoBMFSP5dQMA7yWfnDATg4H5A2FygAVjmwMMD9xRam5ZtbnOZYOa9opqWEGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739404009; c=relaxed/simple;
	bh=o6FDtd+rlSa8IIiwz0tvMUjI0siD1ajnHXHA0qLGxTA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LJesRoUUMwMuqhWvU6zHkeJSZM7zm9wz4jkWR3mVcrfmEkvBMjAsj3OVZXSNZOzqT/1sSrbKU/U8NlYbMLpJ4zn2evQy75tagMCUR1diYdEmLsaVfF5QQ0EgFijMKoMGgNf4fzcwbno5P+nDhVAYKQtX4cQYZl2oGNGpq+vhCuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=Ldvvc3op; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-2fa200c3d16so70734a91.2
        for <io-uring@vger.kernel.org>; Wed, 12 Feb 2025 15:46:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1739404007; x=1740008807; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=o6FDtd+rlSa8IIiwz0tvMUjI0siD1ajnHXHA0qLGxTA=;
        b=Ldvvc3opMEZidGkydWHylsEzqF9pl5POspaUypyrzogGSdVRg1k906P1tyBs39rV6t
         qy+yFdjmO2ZkGbcTDRluUjoeSE5PsOQPpCOyb7OGh/luPH1HndqcbxcRbDM7h4DvrvEo
         qu+JY9hte81bH/6nPOnO5PPauKr3HE9ayDeWI90gbiNwIjkg9frNRoZE689CXtKgiPve
         9Jix32Joj9UpsVCdSnX8N1C51gnYybD+DVVVdnrqlLLyGhrKtN+D9qS1TrcyUPN6iFOT
         i0mTugUbkQkd7NQKmDlDabXKFFJdPkqC9uncChgS9u3V3nJtlOT+DKuxAssJj27d/Lx3
         HWZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739404007; x=1740008807;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=o6FDtd+rlSa8IIiwz0tvMUjI0siD1ajnHXHA0qLGxTA=;
        b=s2FXNzqu5FHv1N3CkSy+QF/YHynUzXuNjb1kgGct1i4uws4bXojOYFoSNOh74NaYOI
         +rBUPaR/+m0bPNkgKnVTOm6WQvdct+m0iINp1iQnKnrHlQoSZ1iN9vHZYZBpcYDD3mBq
         rwovEqauE/1FTvzv+GIq9rIEKxEMYZcsde9CX7TUABY3Us7FoHsxpPao4EFI5AHo/ECM
         UwvHu/i6EF3UzBQ6ioa6k7V3CfR1IwT9/4sb7ctO9aknbPdfmOCbPxD4aOGbyG4rdFwB
         2i0B3zK+wzzcklXESyXMP2licctRs/gxGqGWgj66EgpBjtLAcWGWpg0ZtaNd8Ojw73+e
         ILIQ==
X-Forwarded-Encrypted: i=1; AJvYcCXDKpHSfOvuggYE2hjr5/X3ryeUvNgJe30eum/0LMXJK4a89p8j6OzqVBkkGMPcQWWXV7mkG9Y9vQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YxV4S3oqwYbV9qF1ndqZLMd1iQi8oNiYEfp2sVf42BelUjbQZmF
	jInT2ucimichDecWDc/e+KISZlHqrLXfc2JifbFlOvyNBotPuK6pkzAM1UeUlk63AJqWjlbLq/M
	58xQbcwMisuMvolU96/4VOkfUzE2SNCnSgSPPiw==
X-Gm-Gg: ASbGncuTvxby/r5m59VGTlY40s3TqwhUhS16NftwWIjMTMp8PndUmUGd6Oqsqv/HlnU
	CHKGHLkSjcDTCBPf3OQUDTydeJ58xs8ECeN+2dxx9TvgNLfVVDuxrP2dY/k7AapO29TWqSjY=
X-Google-Smtp-Source: AGHT+IFUzD6F21FEiPi2oFeL5AqMhJ27H5M6NGdg1O+UC3vP8pRfnkjBXARokV8Obb0d2BBChyHfyOpmrmhnjIGPTY0=
X-Received: by 2002:a17:90b:3845:b0:2ee:948b:72d3 with SMTP id
 98e67ed59e1d1-2fbf5bb8de3mr3010403a91.1.1739404006850; Wed, 12 Feb 2025
 15:46:46 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250212204546.3751645-1-csander@purestorage.com>
 <401f9f7a-b813-43b0-b97f-0165072e2758@kernel.dk> <CADUfDZqK9+GLsRSdFVd47eZTsz863B3m16GtHc+Buiqdr7Jttg@mail.gmail.com>
 <999d55a6-b039-4a76-b0f6-3d055e91fd48@kernel.dk> <CADUfDZrjDF+xH1F98mMdR6brnPMARZ64yomfTYZ=5NStFM5osQ@mail.gmail.com>
 <Z60s3ryl5UotleV-@kbusch-mbp>
In-Reply-To: <Z60s3ryl5UotleV-@kbusch-mbp>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Wed, 12 Feb 2025 15:46:34 -0800
X-Gm-Features: AWEUYZnYCZGJbY6mpKpWZGNclaPT0GiXmiIEetwGyU1NF3JZsUGwzvo9IcWcJjg
Message-ID: <CADUfDZqa5v7Rb-EXp-v_iMXAESts8u-DisMtjdBEu2+kK-ykeQ@mail.gmail.com>
Subject: Re: [PATCH 0/2] uring_cmd SQE corruptions
To: Keith Busch <kbusch@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, 
	Riley Thomasson <riley@purestorage.com>, io-uring@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 12, 2025 at 3:21=E2=80=AFPM Keith Busch <kbusch@kernel.org> wro=
te:
>
> On Wed, Feb 12, 2025 at 03:07:30PM -0800, Caleb Sander Mateos wrote:
> >
> > Yes, we completely agree. We are working on incorporating Keith's
> > patchset now. It looks like there is still an open question about
> > whether userspace will need to enforce ordering between the requests
> > (either using linked operations or waiting for completions before
> > submitting the subsequent operations).
>
> In its current form, my series depends on you *not* using linked
> requests. I didn't think it would be a problem as it follows an existing
> pattern from the IORING_OP_FILES_UPDATE operation. That has to complete
> in its entirety before prepping any subsequent commands that reference
> the index, and using links would get the wrong results.

As implementers of a ublk server, we would also prefer the current
interface in your patch series! Having to explicitly order the
requests would definitely make the interface more cumbersome and
probably less performant. I was just saying that Ming and Pavel had
raised some concerns about guaranteeing the order in which io_uring
issues SQEs. IORING_OP_FILES_UPDATE is a good analogy. Do we have any
examples of how applications use it? Are they waiting for a
completion, linking it, or relying on io_uring to issue it
synchronously?

