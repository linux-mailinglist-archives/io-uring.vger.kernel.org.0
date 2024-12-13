Return-Path: <io-uring+bounces-5472-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AA5B49F07FC
	for <lists+io-uring@lfdr.de>; Fri, 13 Dec 2024 10:36:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 72AA328251B
	for <lists+io-uring@lfdr.de>; Fri, 13 Dec 2024 09:36:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 515181B0F0A;
	Fri, 13 Dec 2024 09:36:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Qgh/6jmF"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-yw1-f174.google.com (mail-yw1-f174.google.com [209.85.128.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B69A21AD403;
	Fri, 13 Dec 2024 09:36:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734082575; cv=none; b=oGfVjSMQXXLM/1q3M0c36sZi102JvASAu2UyU0b68FIR4wrt/Vq/K150HNToXiD0uD0WaHjWQUkm5oiSBsrDO1U7NQHm6p848mtLytCgOLEMu1pggM/7VsS74XQ+NTGmEGdRHoiz4YieaXTfFtoXsXkQKkYMfH2MSILJiob2v7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734082575; c=relaxed/simple;
	bh=+rxdRkCEpJyZXEgcDtkC1TaJssU/OargQPdjt2CzW+A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RW0mrwiGCLItTZrRHTZilQcApVjlesEKe6Sp/XgwmDUIDQhdF33AMZ/Qy7JDl5/J6SiPDTLrTeXTA5iUCWnzqbmR8kxozx3nx2br9zMaTjGpxMJj40xfi0314Y9ZlN3llWxmUUelDTEgq8XcSFfKrVmT2nQJSWIfCUE1XPl2GMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Qgh/6jmF; arc=none smtp.client-ip=209.85.128.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yw1-f174.google.com with SMTP id 00721157ae682-6ef66a7ac14so26435967b3.0;
        Fri, 13 Dec 2024 01:36:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1734082572; x=1734687372; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+rxdRkCEpJyZXEgcDtkC1TaJssU/OargQPdjt2CzW+A=;
        b=Qgh/6jmF9E0GWfgsCOcWI63EqHL7qCVe19TuioCG4nDrXcp9GlerYolAMVrqMoUmPH
         Aw3LGi1hrxII5YIY+xRZKd1qKXNwKcmUi6/fdCCu2Pbo+N/78OobC45/FUh2cw5/m6yy
         i6nHftrVVZggXeQFiIKgEcVfN49+3MSuBmcvjKHWHdzyXfdYMzqFNjyxWrKzDHuH4B98
         betxeB5agqsx3CvPT8Qjg03PVHyazzNzqHjyhIpPF5TStNyABAndh6/tt5FlSyXPtgmj
         qmy6X1/A2jahx8HaRpRt4kmnCZeFbAp6e6t5dRaeP1f1bjWdRlqUGB78rDSao+zbF29y
         hahQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734082572; x=1734687372;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+rxdRkCEpJyZXEgcDtkC1TaJssU/OargQPdjt2CzW+A=;
        b=G73ydBhFrB4lieesHcD9uGDG5WdYiBedf+6SUol2cvFB/REQJ5/JmIP89mnLRvTUa1
         oWI58Gi+cOhr7qn5Snh4uumTagTozLbPjdbFdRD00T+PXmDt88r7FJmyTY2JgE7LQxOw
         Ga3qAH6OJzoIEIjBVTL2eMSyzVlQ1X5ZqVYDoa2pkFlp3LTsPXTEjAE2CcDsVJ1hbwAS
         djEVTGyw44OPnGHWEJrMJLpGAv0Xe3OoqRFmbQxwS/ltRIbTmFLVQnwSx/o+8c/FLFQO
         dRLdm+u7m3KiXUPgynBA8BPg4thSmOg9yXX8xy5UGtk2CZcIKSQa5XYVAmumzSfLKdZB
         OXog==
X-Forwarded-Encrypted: i=1; AJvYcCVa6m7YntwdcL0bmC5NnMAJ30JDadPIdcgvCbn8q0rMY+T6iZB3VtfFIBzLdHR35cDXYw9QWP6dFQ==@vger.kernel.org, AJvYcCX6lFi2Rux6epj7vDUOiGuj3lSZmFiHOrOI4ttGV0mLaSHTZkR6vgZWwL+PzQADV69oNOEKTSiKrnKZyKjO@vger.kernel.org
X-Gm-Message-State: AOJu0YwtyBbSghMoM219NqRYtwxxVEfJl+Cpjvn5f1pw1lKNvMpeUcCx
	SmC0ovOunBHkZTtvRgIM1jBkZJn+dnx9IpPOhRkjrJNznZW5++stB8ZWv9+TPeTCifHz22JHLc9
	/hngA00YkSOcfqfDBLMKDaPHXzKFRDy8n
X-Gm-Gg: ASbGncuo3z4jL1Aa6rYIgjXq4Cw3jeWx1qoIQYqESL/OWpiU/p2xmUF76dVxut3R9px
	i3Twrqep14rOHJjtINZ7qn1Cr90/ms0yMMH8i8rWNxCV+2HQYeiPQEadhrbc1cBfNnufyFHlL
X-Google-Smtp-Source: AGHT+IETYv4yCgY15jQaAl0eCYeRVzINNlYAO/KWq2Chq8NjOD5ilaX3qfuou590SeL3PTEYOetNTnvZlFEtc9C9GSw=
X-Received: by 2002:a05:6902:220d:b0:e39:9e17:62e1 with SMTP id
 3f1490d57ef6-e438930b56fmr1387241276.8.1734082572680; Fri, 13 Dec 2024
 01:36:12 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CADZouDRFJ9jtXHqkX-PTKeT=GxSwdMC42zEsAKR34psuG9tUMQ@mail.gmail.com>
 <1a779207-4fa8-4b8e-95d7-e0568791e6ac@kernel.dk> <CADZouDQEe6gZgobLOAR+oy1u+Xjc4js=KW164n0ha7Yv+gma=g@mail.gmail.com>
 <f1f0be9c-b66c-4444-a63b-6bae05219944@kernel.dk>
In-Reply-To: <f1f0be9c-b66c-4444-a63b-6bae05219944@kernel.dk>
From: chase xd <sl1589472800@gmail.com>
Date: Fri, 13 Dec 2024 10:36:02 +0100
Message-ID: <CADZouDS5xH8wC9k6SpgZ=dP8A99MvppEt70Eh1o+vpA-k8ZXTw@mail.gmail.com>
Subject: Re: possible deadlock in __wake_up_common_lock
To: Jens Axboe <axboe@kernel.dk>
Cc: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Yeah sorry it was my mistake, the patch works perfectly!

On Thu, Dec 12, 2024 at 3:28=E2=80=AFPM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 12/11/24 4:46 AM, chase xd wrote:
> > Hi, the same payload triggers another deadlock scene with the fix:
>
> Looks like the same thing, are you sure you have the patch in that
> kernel?
>
> --
> Jens Axboe
>

