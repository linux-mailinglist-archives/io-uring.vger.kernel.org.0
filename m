Return-Path: <io-uring+bounces-8688-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 28CB7B06A40
	for <lists+io-uring@lfdr.de>; Wed, 16 Jul 2025 02:03:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1E9AD3B6049
	for <lists+io-uring@lfdr.de>; Wed, 16 Jul 2025 00:03:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A91072E36E6;
	Wed, 16 Jul 2025 00:03:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gnuweeb.org header.i=@gnuweeb.org header.b="Y3Un8kWL"
X-Original-To: io-uring@vger.kernel.org
Received: from server-vie001.gnuweeb.org (server-vie001.gnuweeb.org [89.58.62.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7AD610E4;
	Wed, 16 Jul 2025 00:03:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.62.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752624232; cv=none; b=GJ93f36wkpNVfgFdTchQRC/n2QndMIj94zcaKXVyKMmT5upVTiGzqM/awsH/q9L9eOqz5RpaL0kvEuJmSlqZIP7d74Nb6wad+KqPx5aQ/nVcmy+uRhzSPVVc59KFhAqg+XRtJr0ENRVSuOPy1V6cmitZfFSwpTjYHFXIZNOQjqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752624232; c=relaxed/simple;
	bh=Zx8gZ64ZCUPL9p6z3WNV/aCoZ1jX3+uA5S29gR4546A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ew3G41+JTECZIzivo0sKPpAV301gzk2UC5lo1KaZbYk62/fc8jq1lHavXiR+cTvNuCyWW+ZcIQ5SLSeOTMDbJD4v7+c3lMNo2esQQjSZoeBOpTtnD05zcACMEWbahP/EParQjs81L5Ax6ObKKrw7GfpiH2LinSQqrsl3I0BrPN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gnuweeb.org; spf=pass smtp.mailfrom=gnuweeb.org; dkim=pass (2048-bit key) header.d=gnuweeb.org header.i=@gnuweeb.org header.b=Y3Un8kWL; arc=none smtp.client-ip=89.58.62.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gnuweeb.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnuweeb.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
	s=default; t=1752624228;
	bh=Zx8gZ64ZCUPL9p6z3WNV/aCoZ1jX3+uA5S29gR4546A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type:Content-Transfer-Encoding:Message-ID:Date:From:
	 Reply-To:Subject:To:Cc:In-Reply-To:References:Resent-Date:
	 Resent-From:Resent-To:Resent-Cc:User-Agent:Content-Type:
	 Content-Transfer-Encoding;
	b=Y3Un8kWL0IPuvc9N39bG8Y3kAm7a1Lx4z1TXRP9l3+MHNH7wzdNE6BakGReufLlMK
	 taVN1DdaxWxytO/XAF06HED33z6vFsx9fgqwQCcsApWN8JQ+dd10CnfK9s8FvFc75A
	 pvkIZXrp1WGjSuSy5qhD/CgRBREopJg8X6Zl/mx0698zgBi8aimVRYm+GdZm8xrM57
	 zn/EifSW7sPVMTb6Vv2LxhjcLyobspvthvD+Y7QDAFAOunfGKn1chiBt/RmbOIB2Rh
	 wwZTS8W+aCuWpO8jyGDVDD2Qloxf8i7eHzKdnLun5AS9gksIO9f0yYyzkGTbSfbemY
	 deaeYm71GxibA==
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	by server-vie001.gnuweeb.org (Postfix) with ESMTPSA id AA3F62109A7D;
	Wed, 16 Jul 2025 00:03:48 +0000 (UTC)
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-3137c20213cso5771871a91.3;
        Tue, 15 Jul 2025 17:03:48 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCV7+UpChl4nVXo1IG0rTkwdHv7CMmYExbdLfwSwqIjQ33LI14eB77QMbOM7UYEH6N0iJ/l0s8eXG0VRcfUd@vger.kernel.org, AJvYcCX6OScU7yPgUuMkYobZdWALaE/SovJb71wMSolIVowKwk1ey+0ykEz9q6gwERbpmFqugb95408V1w==@vger.kernel.org
X-Gm-Message-State: AOJu0YxWs1ZTxCmBG4OJeTDg4UbRL3UGM8Wg74ATRSEQHSMA5GnM6WRJ
	vWvlM5z4REAOD7UN/WZ0s6yNk7SoCuNC9VDDOhXQ4rNPRQjsTq/lwNWMG4Ljnk5H3WvIXUDUWSt
	1+93ZBXGPSb5oRaSfChYeHQETgon0Phg=
X-Google-Smtp-Source: AGHT+IHxE+6NdUlJHc//wMLQbRtx/EAVxdHKQW3RhEimCZx5/yH/prnD5DIs/cjBEUWcJToU9tymJAzKY/Gyx9OecOY=
X-Received: by 2002:a17:90b:5283:b0:311:d28a:73ef with SMTP id
 98e67ed59e1d1-31c9f3fbc01mr854728a91.10.1752624226957; Tue, 15 Jul 2025
 17:03:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250715050629.1513826-1-alviro.iskandar@gnuweeb.org>
 <20250715050629.1513826-2-alviro.iskandar@gnuweeb.org> <4bc75566-9cb5-42ec-a6b7-16e04062e0c6@kernel.dk>
In-Reply-To: <4bc75566-9cb5-42ec-a6b7-16e04062e0c6@kernel.dk>
From: Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
X-Gw-Bpl: wU/cy49Bu1yAPm0bW2qiliFUIEVf+EkEatAboK6pk2H2LSy2bfWlPAiP3YIeQ5aElNkQEhTV9Q==
Date: Wed, 16 Jul 2025 07:03:35 +0700
X-Gmail-Original-Message-ID: <CAOG64qOsyNUWW5xiYQh1ftkFwEH2TryzawtNnZ3CBJobDsgTGg@mail.gmail.com>
X-Gm-Features: Ac12FXzkS9jDB0DHLmyV5EMpkpYd9fFDus5PR_ReEnMXl5_d7vhDI7MPDeDDWcY
Message-ID: <CAOG64qOsyNUWW5xiYQh1ftkFwEH2TryzawtNnZ3CBJobDsgTGg@mail.gmail.com>
Subject: Re: [PATCH liburing 1/3] Revert "test/io_uring_register: kill old
 memfd test"
To: Jens Axboe <axboe@kernel.dk>
Cc: Ammar Faizi <ammarfaizi2@gnuweeb.org>, "GNU/Weeb Mailing List" <gwml@vger.gnuweeb.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, 
	io-uring Mailing List <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 15, 2025 at 9:10=E2=80=AFPM Jens Axboe wrote:
> Maybe just bring back the configure parts? The test, as mentioned in
> that commit, is pretty useless.

Ok, I'll send a v2 with the test omitted.

-- Viro

