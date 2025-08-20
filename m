Return-Path: <io-uring+bounces-9104-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B97AB2E08D
	for <lists+io-uring@lfdr.de>; Wed, 20 Aug 2025 17:17:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 498D8188845B
	for <lists+io-uring@lfdr.de>; Wed, 20 Aug 2025 15:13:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C82C6349231;
	Wed, 20 Aug 2025 15:00:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="F0fitD2+"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B20F34924E;
	Wed, 20 Aug 2025 15:00:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755702027; cv=none; b=FL0AttlrczAxvsKDx7YsV68Gw/mauENWDf64TpKdFUUBhyrztJZ70hjOhxs+97kKQb5NQcAYby40x3eZrw+LkUJGimpEKgWDn3598ujyNuBHMyfnwGN5A4dzU0ziQnsH0NRqVfyu1Ekd689V4cuZZqeWttn6Xk4UOp3r8H29rq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755702027; c=relaxed/simple;
	bh=HcUocu8ykYcNQNL7uxc8gkzCEymZ97/xUCXbX2OkNnk=;
	h=Mime-Version:Content-Type:Date:Message-Id:Subject:From:To:Cc:
	 References:In-Reply-To; b=XIj883l6oU48qCNWsZgS0Rz/bac+9gdZ2Hvjest74bjslIHGQW5hwYwmHuWWfZEwNC5Sl1Vr8q/qX0er2v0+7q2jSw7TLvXahrzptSjOmtJr4fNNNXyObq+KqUQrFE3OF1zfauxGV8fR5knD8lA36haluwuOgj/LwP7yGOaNcwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=F0fitD2+; arc=none smtp.client-ip=209.85.215.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-b476cfc2670so401796a12.3;
        Wed, 20 Aug 2025 08:00:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755702025; x=1756306825; darn=vger.kernel.org;
        h=in-reply-to:references:cc:to:from:subject:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HcUocu8ykYcNQNL7uxc8gkzCEymZ97/xUCXbX2OkNnk=;
        b=F0fitD2+4pC2lxTxhuWYNswlcIYKo2pQOMNHk7A44OfKweCRNX5leDabR42wq9GHZr
         gWC/0NNoMxIMti2KM+QSzhJtGXnreEEKXdtDIsDYtYlqMgP0dhQWY4PwN4vlUdcMMld7
         O9IkUB/aN0jdG3zWOqZLFjfUXp4hNT7l+c+017VxLCcu2uu1K5IM1fTCDMaLAi12rfgH
         Rp1Jt5ZAlvXTIPG7RhmS6duBqsX4UN6pOzZVI9eFRCdCC6c2dc2yOUWxoOd5ew9lJmMK
         5QEJY+9NuUYjQWRqHZmO94gXTTj/NONIzdsEoH2Jap3GJCSzkreT9Bv+GAHgyWWYKLTm
         nWyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755702025; x=1756306825;
        h=in-reply-to:references:cc:to:from:subject:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=HcUocu8ykYcNQNL7uxc8gkzCEymZ97/xUCXbX2OkNnk=;
        b=pq7/6n1/bzwo9nKC//2CNQ7aYVBd5SV9SwErdTkzl8QpyPu3WeKb4YRa2eave7RVpM
         Y/ckYhiihjTY/F+9OiR6QKg9E5CrqVL7TikBEZScYsq0nnqLB254dKXW0BuqScrl1GhP
         mh8Dt4QiZilggOtwjLYLb8mtIoxyCKlD2NhlRXbNVH899I6uG26YsNbZrKXThH2x8IAa
         JB8s9uCX9PV4P8+y65gIDNHcE/HOK7xNXakj6FZWRkvprSJazK79rgW3EPnZ82tF9iu8
         qnV/SQ3V4847l1w5Y+KUD64aBvF8aL/H6eNVbobPXo1EwLSOZ+oJMYtr41l557g42Chx
         hQBw==
X-Forwarded-Encrypted: i=1; AJvYcCVSgHOBzvnikGIhEvY6WXE5BOn3JMD6Mivb/UiCk2bO3SWqF5S95ApXa5qZfsiiSQgYEDwnitXwd3/h@vger.kernel.org, AJvYcCWo6/wRWZdA2BAi7nUCA5A+qxLMjMkqq/ebqbHuL8xUTXleIZcb6mQNOrReN4G30S0je89PeJaVfg==@vger.kernel.org, AJvYcCXg58IP8hToUFV4u/8Jh0Wxecz0tkYCFKFTdbOpKbUv0fO353QuXON4GHmea6iZIzfxhFDz3rrmDyvbbfjCXw==@vger.kernel.org
X-Gm-Message-State: AOJu0YxCzGhNt6VUiQ4UdWxxMgvwuHBfPpQ01rV+l7QjnSBdJSqtM6CH
	Upja8uakv/3Ih8oRbaIyLARNy+Mg/3afDJUtuaSysM0z6ViqZXX7qwqt
X-Gm-Gg: ASbGncsQRWxgIaKdjorqQxT1mAtaXWRmFVmV5+G+ojdwmvxGpjSOCaPn2Skjod2+DpI
	D5/AhferN+WwbH3FW6CKYgthIrncL/z58z1psybNitJ0RECoCMAfQEFK2OgFfQZ1JRTWKX9oZ4M
	giLbln05l0y4nVda1OeJ5mPFOJDncR7mItHjwXuMWSKHaXjZ8hL7gwDpFxLgFFv6LAq3JcDhVgU
	3cT+XPqk8Ve5Y+VEh6kRqjplTpAnGLBat6YsBm1YD+x3oj3/QGZrNcLvOUxWNG4IuXwBEeJS1Pj
	5qTCRUs9MK9txOoB4Q32mIuPc+VkOZu1/TTi9JVo2d8macFQpYfoDG/t53FA17J3TdOpQvxzptZ
	YIilwfjB5fXRzv+kVV08rjjsgpAs=
X-Google-Smtp-Source: AGHT+IF+xR/A0UKdUrdig4MsgN3farISyyfZyVO405kQD0hK/nbh996Heg9FE8bJhKV3B3WmVAwkUA==
X-Received: by 2002:a17:902:f691:b0:23f:f68b:fa0b with SMTP id d9443c01a7336-245ef22dc84mr33747695ad.37.1755702025126;
        Wed, 20 Aug 2025 08:00:25 -0700 (PDT)
Received: from localhost ([65.144.169.45])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-324e254e59esm2579224a91.17.2025.08.20.08.00.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Aug 2025 08:00:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 20 Aug 2025 09:05:07 -0600
Message-Id: <DC7CIXI2T3FD.1I8C9PE5V0TRI@gmail.com>
Subject: Re: [PATCHSET RFC 0/6] add support for name_to,
 open_by_handle_at(2) to io_uring
From: "Thomas Bertschinger" <tahbertschinger@gmail.com>
To: "Amir Goldstein" <amir73il@gmail.com>
Cc: "Jens Axboe" <axboe@kernel.dk>, <io-uring@vger.kernel.org>,
 <linux-fsdevel@vger.kernel.org>, <viro@zeniv.linux.org.uk>,
 <brauner@kernel.org>, <linux-nfs@vger.kernel.org>
X-Mailer: aerc 0.20.1-0-g2ecb8770224a-dirty
References: <20250814235431.995876-1-tahbertschinger@gmail.com>
 <e914d653-a1b6-477d-8afa-0680a703d68f@kernel.dk>
 <DC6X58YNOC3F.BPB6J0245QTL@gmail.com>
 <CAOQ4uxj=XOFqHBmYY1aBFAnJtSkxzSyPu5G3xP1rx=ZfPfe-kg@mail.gmail.com>
In-Reply-To: <CAOQ4uxj=XOFqHBmYY1aBFAnJtSkxzSyPu5G3xP1rx=ZfPfe-kg@mail.gmail.com>

On Wed Aug 20, 2025 at 2:34 AM MDT, Amir Goldstein wrote:
> On Wed, Aug 20, 2025 at 4:57=E2=80=AFAM Thomas Bertschinger
> <tahbertschinger@gmail.com> wrote:
>> Any thoughts on that? This seemed to me like there wasn't an obvious
>> easy solution, hence why I just didn't attempt it at all in v1.
>> Maybe I'm missing something, though.
>>
>
> Since FILEID_IS_CONNECTABLE, we started using the high 16 bits of
> fh_type for FILEID_USER_FLAGS, since fs is not likely expecting a fh_type
> beyond 0xff (Documentation/filesystems/nfs/exporting.rst):
> "A filehandle fragment consists of an array of 1 or more 4byte words,
> together with a one byte "type"."
>
> The name FILEID_USER_FLAGS may be a bit misleading - it was
> never the intention for users to manipulate those flags, although they
> certainly can and there is no real harm in that.
>
> These flags are used in the syscall interface only, but
> ->fh_to_{dentry,parent}() function signature also take an int fh_flags
> argument, so we can use that to express the non-blocking request.
>
> Untested patch follows (easier than explaining):

Ah, that makes sense and makes this seem feasible. Thanks for pointing
that out!

It also seems that each FS could opt in to this with a new EXPORT_OP
flag so that the FSes that want to support this can be updated
individually. Then, updating most or every exportable FS isn't a
requirement for this.

Do you have an opinion on that, versus expecting every ->fh_to_dentry()
implementation to respect the new flag?

