Return-Path: <io-uring+bounces-5675-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id F0411A017D1
	for <lists+io-uring@lfdr.de>; Sun,  5 Jan 2025 03:12:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A3DFB3A3794
	for <lists+io-uring@lfdr.de>; Sun,  5 Jan 2025 02:12:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CEF6044360;
	Sun,  5 Jan 2025 02:12:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b="CySZ8vf9"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-yb1-f172.google.com (mail-yb1-f172.google.com [209.85.219.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E8C93597A
	for <io-uring@vger.kernel.org>; Sun,  5 Jan 2025 02:12:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736043159; cv=none; b=BDCMPHmjgcNQccfdNFECCnYkfe+pnY8bWMTnvjfRqmvfbn1AF3JkZhzTtgTJTCHgN7NCmVoxqvw5KHoK3NGc30oZE5MZEzclHiKME7yaDuexAae2fZBSHwi91ogOmVVcekTpxsYuDSMhvViXZu2tJXz0zGb5QRF09Vm4j2jUMKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736043159; c=relaxed/simple;
	bh=Jzfp8M24ZGYO8CfByHmvPRILhEgp3SAXkuYYuv0i5/I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jaJJtHFa2Kjpfmvn4zo0r5Lv/zOqIquYeK09vAZqujjcluC2/xu4gIkTLY4ytPOSpnMKW8a3rEjss4NiA+lLQwk8beYYZ1FP0U6rSogbc8sJPC7t9XvUDDtGvCGjXfZkAgx8BbfylrLNBII5QNf8FNobGI8E+tSrFk9nustysB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com; spf=pass smtp.mailfrom=paul-moore.com; dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b=CySZ8vf9; arc=none smtp.client-ip=209.85.219.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=paul-moore.com
Received: by mail-yb1-f172.google.com with SMTP id 3f1490d57ef6-e3a26de697fso17198193276.3
        for <io-uring@vger.kernel.org>; Sat, 04 Jan 2025 18:12:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1736043157; x=1736647957; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qVhkp6+4+SyxA1C7vrnL8lux54uiVvQyU708Zob6d9M=;
        b=CySZ8vf9OLOhU24WKEejG0p3XnXqR//c4ziWRDp7La6dRSXO59Y1Oy0jjA8GTgbpEP
         hJsdXrQFqfzjFUFgb/6VMYSH24vTFN1R7fTN2bMVl0aJEpuQA3Zm2YRCG7Kr7f4//zNh
         tEoYIoSaQssNv7AQv+QINIvjodklba+Qmb3ZTl9kojYvBQet4/bhhUVCUxFySH2RgVnn
         8G/t8bUOZWrIrvhSF4Ho1LuyUuhgLQwPeqpTapRUNOvmVhqSYo3XBQEUR2ikHXhfNLan
         Sbfzgh5mlGL8F3Lvc5duhXxCe64VKPZxGd75bi2R93t5XcFQHpL52a5cRGzMGKKDqEEw
         rs8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736043157; x=1736647957;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qVhkp6+4+SyxA1C7vrnL8lux54uiVvQyU708Zob6d9M=;
        b=kJ9VimgAUOYTgd8prOxWzSaA3IE3HOQRvA3HYn0kr4Ga9u3hBZvlVDap0OsU6kAyYl
         rGeRbbcRUvC1blFsqLo5RYp/B2TG3p7yPwUw+i5IZbmuAyfxq5QWyZAh7pocgxCeLur7
         Ejfvgnlw47CXXbCRJb2Ycxn2VqHmLNM9h2044mzN3ddIJx8F9DgbTkG2s/aQhiv9LTB4
         GgszbYCuF+ATvefwP/gW9YyQ8EQsjGuhuMlCIXSboRxgM/sTgbsEAs6wW6X++B6eQ9qQ
         WzEJaZEH0mRYRTWirE/yYJUHKKadNg7ozaRMiiiEb5jEQzm1MUnE8MNJ7RjP5OZ/tUaD
         Roow==
X-Forwarded-Encrypted: i=1; AJvYcCUS/aufgW53AQGq6k4cEvHHVSQ4U0ObZ4flUZTon+s4CGCBvwOO05v2ZE788VppJ1OwCHXsGWA8tA==@vger.kernel.org
X-Gm-Message-State: AOJu0YzdZrTdC06BYebub3bYT06DAIo+3Qqb8VLGMineAWh087PJBK8j
	sg4QdR2iJqOIaeZyL3fb+VRMHAvxZfnTZCuh1+WDv3D6ezewOXzqp+Y9PRLVq85b8IgUvJQxEAF
	9I+FHn5HpzwLm5wp96b+iM6bZ5iVklNa45Eot
X-Gm-Gg: ASbGnctTp//CZygDWwOygOQ8Vo0GDI1RUvJGs2SpVVRK/YG5W0NMe4KIOyx9LkzOFkL
	+uOWq0mfw4H5zzoAARD6p6v1LBxr9ohBXZrb0
X-Google-Smtp-Source: AGHT+IECujpE4SlfMSgDTibr3ecgQxCdF8XBs81RAecEaO9HiXL8b8vWykU+LPwyt7KcvSbGf6hiT7jTg2ydSuKCgd8=
X-Received: by 2002:a05:690c:6009:b0:6f2:8781:32dc with SMTP id
 00721157ae682-6f3f820ae78mr369384597b3.30.1736043157303; Sat, 04 Jan 2025
 18:12:37 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241219204143.74736-1-hamzamahfooz@linux.microsoft.com> <4ad606c2-c7d1-4463-a2f1-4fd0c63c6e9b@schaufler-ca.com>
In-Reply-To: <4ad606c2-c7d1-4463-a2f1-4fd0c63c6e9b@schaufler-ca.com>
From: Paul Moore <paul@paul-moore.com>
Date: Sat, 4 Jan 2025 21:12:26 -0500
Message-ID: <CAHC9VhSWUNfFUZPtEQdHN4ON6VzWoRN38NeoHJHmGZj68NprYw@mail.gmail.com>
Subject: Re: [PATCH] lsm,io_uring: add LSM hooks for io_uring_setup()
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>, linux-security-module@vger.kernel.org, 
	io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, 
	James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, 
	Pavel Begunkov <asml.silence@gmail.com>, Stephen Smalley <stephen.smalley.work@gmail.com>, 
	Ondrej Mosnacek <omosnace@redhat.com>, =?UTF-8?Q?Thi=C3=A9baud_Weksteen?= <tweek@google.com>, 
	Masahiro Yamada <masahiroy@kernel.org>, =?UTF-8?Q?Bram_Bonn=C3=A9?= <brambonne@google.com>, 
	linux-kernel@vger.kernel.org, selinux@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 19, 2024 at 4:34=E2=80=AFPM Casey Schaufler <casey@schaufler-ca=
.com> wrote:
> On 12/19/2024 12:41 PM, Hamza Mahfooz wrote:
> > It is desirable to allow LSM to configure accessibility to io_uring.
>
> Why is it desirable to allow LSM to configure accessibility to io_uring?

Look at some of the existing access controls that some LSMs, including
Smack, have implemented to control access to certain parts of io_uring
such as credential sharing.  While having a control point at the top
of io_uring_setup() is a fairly coarse way to restrict io_uring, the
advantage is that it is very simple.

--
paul-moore.com

