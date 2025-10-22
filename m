Return-Path: <io-uring+bounces-10114-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F549BFCFDB
	for <lists+io-uring@lfdr.de>; Wed, 22 Oct 2025 18:00:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D8B8F3ABAB5
	for <lists+io-uring@lfdr.de>; Wed, 22 Oct 2025 16:00:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E94D25A35E;
	Wed, 22 Oct 2025 16:00:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RS9ulQ2l"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ACD525A350
	for <io-uring@vger.kernel.org>; Wed, 22 Oct 2025 16:00:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761148808; cv=none; b=nhYj/AiaGPcLKVg2e8IPniDv3yvj2JHJrigEhCp5wO5PC5aVK5zM8dVooolqEx3/HzvpyG/8ZbYmIZkH+RedXflV/7sZJD/qHELck3gWDMS7+HJL1G6sdoceel4yuxx7NNKbfCHtREhYSPfMzVRsEp0OiBMQY95dk8Ra52h9DXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761148808; c=relaxed/simple;
	bh=KzWGAXTtJNaWOtBKzMnXWFA9Pc/O+vKz4Cro7WOAr4U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=D0rVPE5nXMEmSpBkr++QfbdaFqQKl004f5X/sCLJadef6hvIKJNzVlr0PeeWfLl7wESU3LTG1XP8e3KAsqPwoaXYPKFHfvsOJ6T0PTWVQLRH3ZTGJ2SaYAKBMazgwM+VdrnTWciltDkdrxiRydx89giKi0+L/aWqUiz4XFN89n8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RS9ulQ2l; arc=none smtp.client-ip=209.85.219.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-879b99b7ca8so94617216d6.0
        for <io-uring@vger.kernel.org>; Wed, 22 Oct 2025 09:00:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761148802; x=1761753602; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KzWGAXTtJNaWOtBKzMnXWFA9Pc/O+vKz4Cro7WOAr4U=;
        b=RS9ulQ2lHiWmy/gV+7Kqw9PImxGQyCkaYijbZlLPIiPyGsXg2F/zorj+UmdBeVB6en
         Q/xu8+Q0vOXlYETVNZV0ClMR9763WXUOG9A71PMyT+ZFA2PwLnYz502V1c9mAeNNX3XB
         x7/1IACU7b+K62ZQ086pDExJbBH0lgAJrAcBuViflBDB9v2MW3oPDcI99ycWEtZQBTtj
         2aMilXNef/AKOVsDvB9faKPOg8BGZbuvW9MklZbXCcncAKD7BN9XF67IheTJuYUi/mVT
         gvzMCDdZx16eWs47ONvkakvAJWAH/dCdAlDgIBtZPPUibYOZAv6yZ5lsb5gq7AUZGS7C
         OoBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761148802; x=1761753602;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KzWGAXTtJNaWOtBKzMnXWFA9Pc/O+vKz4Cro7WOAr4U=;
        b=OSjfUAbR7OhpusqukOrbJczs0asxltGNY0n7p3lPInizOAGLoEy/zcbE4Ltd4XOdP1
         pQ7x1pGkbXX8h2+ViVKg6ivLIQWmR/Ik2uH8dJsL70Xhpm6M4Zs8Y72aKmFDjY6YZ+ce
         9PKrWab2ySuz0Aiv9W5MEGraA+1JHw98VPTbec5RAIziFgwfWdlRXpZHmCMoy1ZVqAIs
         a6Lo3EtUkP77chsIsLgXovAbYPTAWjIUlAp66jnqRP7NbtZ5slg5uVG1Z6hOVhduQqmY
         A0C1GTzKAhQcCV7sXlIkV1Q1s1BvU9r3XS0Rfmwahsd8SYFCSQBfP7ypSsjCtrkiQcbX
         SUxQ==
X-Gm-Message-State: AOJu0Yw/HL/wp/oCJezGCcgQQIVo1XRF/hE7at6SXyOrt9sWwzdFX4H8
	bsXDih1cc+wQkMsOgitGDB1KHZefHe60bskfrcmEFBV//72ejNj5p7BVJ7PeAhvOxyOnWI33Z16
	UOh5IVJBwswMovtR+sHEnUtN4paYt1A8=
X-Gm-Gg: ASbGncuGbztRDjwrE5CvI3hYmwaLklSfSpFHCsiLNjPzRp6LW7121kFAe8hHAVKEdPQ
	UVIaU88TbTnYr1rMyANDI1sDR3ivrm7IxTVjfy9JH0w9vUYYiN5yoHms9aBoEgYFUstUrx/uRdV
	OuvMeANvq1O7dfqaxs5DaeSN26byYE/o55vr7HuXX4XYFPaVaVsqvcBvQz1V2oo2jNvTZWp6k/Q
	IQoV9Haj+n5XSt2GDXFgCtqEuFM8+d042dgmh8FmYsX6aaqQ2twVlMk0cTvF1KzxjLbc4aJSD70
	KwrVcOJt/J7zBx3S8Wsft9GtpS8=
X-Google-Smtp-Source: AGHT+IHxWCD/w+o2vmfbuWDtKOmy2UCQxI4nvjqy0zKHd7wCbrRbTr3WpmmN6Tt3lY3nMvE06CH78X9xcKtEFyAyF3c=
X-Received: by 2002:a05:6214:2469:b0:7c6:bbaf:11b4 with SMTP id
 6a1803df08f44-87c2081ccffmr315026216d6.54.1761148802138; Wed, 22 Oct 2025
 09:00:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251022150716.2157854-1-mallikarjunst09@gmail.com> <5b78c30d-26de-4e49-9bfa-121c9f40b4e0@kernel.dk>
In-Reply-To: <5b78c30d-26de-4e49-9bfa-121c9f40b4e0@kernel.dk>
From: Mallikarjun S T <mallikarjunst09@gmail.com>
Date: Wed, 22 Oct 2025 17:59:51 +0200
X-Gm-Features: AS18NWAJWcskmCUPndr9Lli3CHnsvOgWgxEkWkWuX7hMLeLHsGN9TYgqSU5HGMA
Message-ID: <CADv35-T8XchxB43FZ2XdJ+8nWDCULqz1FLX5vC9WN3gtgeSpQQ@mail.gmail.com>
Subject: Re: [PATCH] io_uring: initialize vairable "sqe" to silence build warning
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org, 
	regressions@lists.linux.dev, "kernelci . org bot" <bot@kernelci.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Thanks, Greg and Jens, for pointing this out.

I understand that this issue has already been fixed, and I=E2=80=99ll make
sure to pay closer attention in future submissions.

regards,
Mallikarjun

