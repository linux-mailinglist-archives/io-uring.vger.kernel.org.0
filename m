Return-Path: <io-uring+bounces-8983-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 49E8CB285B7
	for <lists+io-uring@lfdr.de>; Fri, 15 Aug 2025 20:19:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 580165E253D
	for <lists+io-uring@lfdr.de>; Fri, 15 Aug 2025 18:19:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2658B31770D;
	Fri, 15 Aug 2025 18:19:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eaSaueHF"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9C04317714;
	Fri, 15 Aug 2025 18:19:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755281975; cv=none; b=JIrzTdug5kXG4Dh5ilb0czhKXl1EEx3m1FECmz705TzTUBhpVS0B648dJFLCeQIE8q0Bcw+eUrueQFBvel8TIan9bAR1aSi+IjFcrlkiP6lJx67769B6yvbfQPdk1jf3xdhXCRdUXI2Q6PuscJtgRdY6H9diNX/rt4gDYtj3JUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755281975; c=relaxed/simple;
	bh=A0JnXgLp0PKfhdVUi/McwhBhvFFu/902GDhAGTuRJW4=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=XFj9gMSljjdBP/d6SfZoYwndJntVAO+hOsw3lTF+k28aK/HuA/D8pXbxRf2uQzK4laH9llwDbcMJ45Gi4OamZdd3rogJwQZowRWQCxweRZTjRXxLuaqFYng9nUJuOb2lNx0hWN/gtqMlfL5YPZHhB4cNz6CHpCIHIfvc8CUZ2GE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eaSaueHF; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-76e2eb4a171so3027982b3a.3;
        Fri, 15 Aug 2025 11:19:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755281973; x=1755886773; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=A0JnXgLp0PKfhdVUi/McwhBhvFFu/902GDhAGTuRJW4=;
        b=eaSaueHFPXYCE1+8q5J1DJnkH2FB4WlkxX7DPRfG5vXwuKb/Qp7ayfPa+07U69P4zg
         W8RcVnQVb8GUkmyNL1JEdjJbUxyKPFH7mWBUsfa8YtDBO3ky1N2SXhJHmjbf40fynyVy
         UXH/oI633Yv14FhGT0od2WjLAztQ7Pg+R/it2aQl6JsU13qXGWS0Ag1N9gAO5PVexr+9
         8mD0hxQdssdmPyT+Tpqev8+iQxXhFb2tzUfMuvagd+PN3QGHxtK92+Qksnot/agjIUh3
         5C3i31PpDSYu7CqxZ4Wqc8zn7uH0MBG7Y1vZntQkAJtAZywUD67YudsVys6mazbYKvuA
         HEug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755281973; x=1755886773;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=A0JnXgLp0PKfhdVUi/McwhBhvFFu/902GDhAGTuRJW4=;
        b=bWwT89a00apRaHIZFBO3JBzU/Er1ZULKNJ1SzmO4WLW/2OFT0Ogt8djZFLaHOesH1d
         5nYWZnMJemx9qRdaNPSXZJjOsXhr52yXFI4D76mvBiDOLCu7fXh9bJYTskbB8/NfWUJX
         9tEljB12uXT9efaya3LrDEX0Sy5G7yU2abA+93E9HTHu9thTbJmyVFCW67R53Hw5EHPm
         NXPDiosU3WrP4dkCHLO2e/4fbu9b3wHEI3iJSPd12JN3VV8g9mSLNQuDMB3PbOUysRmI
         K5l3jeyFjKz7alYwdCM/L/uiJhRle+F3JyMwj9PNDS3obC5Npyf1lBPZdhIUCMeFSGbM
         VvXg==
X-Forwarded-Encrypted: i=1; AJvYcCWmpfSziFP7Hm8Q7r7shs2gvPZehYObRw57qvG817inDAW6hbma+xKtOAC8z4/RzZnolOxfHCk+PjESpSKs@vger.kernel.org, AJvYcCX0NxqiS/b5tyVCcWVcu3oeKYqiH/qoVyfpYxPjpgDE0SPea7X162GFD+zZHhv5WCm+HGILQdGAqtw1@vger.kernel.org
X-Gm-Message-State: AOJu0Yw01/bDzM9M1i8qanqGc0X6qlz6m/nMC227IQLGy7Syc7JpZkZR
	u7DL6FDFpcd5/dNN+QOhQG6qk6WUZ1JuQEpMmpNtpfU2Six1TWvTjNvm
X-Gm-Gg: ASbGncvg5o9D1zdT8YZ7aY17/s/KoBdyA9N/URTjZPPtON8eVaZvPzQrLe0YnhGR8cX
	97Dyv+6IY825vVAuhTIiHmnVS9WKNDsYe/eDe0rzLL8/lt7CZxmDRkMYfeis7uVK1aAWE4yrkxi
	av2RNzFikal7ZC04fkJ0wkRh9jS7DrnYX7DuA6kcLI+TgxjrvGfgqlvBku7PaeOWuQRFvj0pLII
	5+Fc8EfN491prOgqOIoz6cuzMYTgKXYYdCOOS94UBdb+/BFFJ9pemJPQjZkiofAcppZrrn4zF0X
	QWS4uub5F9Hx6NYe/M9Siprs/V8NbU9hWqx7TyRMc24Cxr/awI8MCpHfPwpq8TCp+JAAeBx9Zdc
	ezHxtrkoifugCP2CPkIZgDQ3Za477RMymf9LE
X-Google-Smtp-Source: AGHT+IFRFBJeAelwFegow+jxmq3bwIkpY06Kr4BCE9CEoGWxn9SNdyQe3zYbCPUFRpseqYc7+sCMJA==
X-Received: by 2002:a05:6a00:1acd:b0:748:e585:3c42 with SMTP id d2e1a72fcca58-76e447ab3b2mr3875304b3a.15.1755281972667;
        Fri, 15 Aug 2025 11:19:32 -0700 (PDT)
Received: from localhost ([65.144.169.45])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-76e4558cba5sm1615636b3a.88.2025.08.15.11.19.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Aug 2025 11:19:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 15 Aug 2025 12:24:03 -0600
Message-Id: <DC37MILZEZV8.2P3JEY8VJ66DO@gmail.com>
Cc: <io-uring@vger.kernel.org>, <axboe@kernel.dk>,
 <linux-fsdevel@vger.kernel.org>, <viro@zeniv.linux.org.uk>,
 <brauner@kernel.org>, <linux-nfs@vger.kernel.org>
Subject: Re: [PATCHSET RFC 0/6] add support for name_to,
 open_by_handle_at(2) to io_uring
From: "Thomas Bertschinger" <tahbertschinger@gmail.com>
To: "Amir Goldstein" <amir73il@gmail.com>
X-Mailer: aerc 0.20.1-0-g2ecb8770224a-dirty
References: <20250814235431.995876-1-tahbertschinger@gmail.com>
 <CAOQ4uxij17qNiTq6Gjy0Q_aOv8-k9ggsZ3vFA1Uz-tw-gS7xxQ@mail.gmail.com>
In-Reply-To: <CAOQ4uxij17qNiTq6Gjy0Q_aOv8-k9ggsZ3vFA1Uz-tw-gS7xxQ@mail.gmail.com>

On Fri Aug 15, 2025 at 3:52 AM MDT, Amir Goldstein wrote:
> On Fri, Aug 15, 2025 at 1:50=E2=80=AFAM Thomas Bertschinger
> <tahbertschinger@gmail.com> wrote:
>> No attempt is made to support a non-blocking open_by_handle_at()--the
>> attempt is always immediately returned with -EAGAIN if
>> IO_URING_F_NONBLOCK is set.
>>
>> This isn't ideal and it would be nice to add support for non-blocking
>> open by handle in the future. This would presumably require updates to
>> the ->encode_fh() implementation for filesystems that want to
>> support this.
>
> Correction: ->encode_fh() is for name_to_handle()
> You want to say that ->fh_to_dentry() need to support cached lookup,
Yes, that is what I meant, whoops.

> but FWIW, the blocking code is more likely to come from the
> lookup in exportfs_decode_fh_raw() =3D> ... reconnect_one()
> not from the filesystem code.
>
> The fs would "only" need to be taught to return an alias to a
> cached inode and generic code would "only" need to be taught
> to give up on a disconnected dir dentry.
>
> Doesn't sound too hard (famous last words).
>
> Thanks,
> Amir.
>

Thanks for the ideas on how to support this!

