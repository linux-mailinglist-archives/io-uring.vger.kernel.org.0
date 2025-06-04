Return-Path: <io-uring+bounces-8200-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 910E4ACD84F
	for <lists+io-uring@lfdr.de>; Wed,  4 Jun 2025 09:16:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4BCF016B6F9
	for <lists+io-uring@lfdr.de>; Wed,  4 Jun 2025 07:16:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F20F2C3246;
	Wed,  4 Jun 2025 07:16:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IkumhM5a"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E65D2F32;
	Wed,  4 Jun 2025 07:16:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749021385; cv=none; b=NxsmLJPX45XEjszkb790f/wBqW7UEciFP8HVwK83HkcGcOgBRwfsfhSlkX3GyF1prj7Bz0PpqB7f1UL0Y8N/FAL+06TJrVN4ycUaYmuzaU4K7esj0AXaXORnYm+0EVQg8nWSFMLAOInBcGzS6szD8t2byXwC4RxEZ73RnessNao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749021385; c=relaxed/simple;
	bh=gyq4T5ZXjQihkyDK3S1CMFRq8Y1066mnUDwDpdNk+6M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aU+kcN7ShPLQ9NdM9V5vx3AWLsR3vZdbGzX0sOEpYAhDtxAB8L9/AqdLbcA3VPaEOB3xiddm/WoBQCB6S4JsvkVFPeK5FFtKObsylMp8dLg3C2O2Ltsoxlyv6PN8BJ/Rc63P/y1ZOyrexqGSGG5PSzlAely1L3rIyXF1SipdPYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IkumhM5a; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-acb5ec407b1so1013097066b.1;
        Wed, 04 Jun 2025 00:16:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749021382; x=1749626182; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZvVRZGR4kcYhZPhtOACMXE0Zb57gL/uh1lF70ODprqw=;
        b=IkumhM5apYShBYoOI5VhxY3xBJLWGdX6bC8ENMF/8wEUNpy01yuEAVLRlTBYmVVvkj
         HYa4wh3w8IGbSawT2L2shfY2d2ry7KAUcco9UUZDxDPrhYnLL1SDNETZqAnNb32KFDhy
         v0e07bO2qLKDdqLk7sEg9iJat4S7tE/5FdWlcovXFukTzX7v0G3UZWfz7Oqo3qEkz/nY
         Dv832eH6KLBYHwovnBO0rDtlU/WFt5ZJhrJnOzYNzbANtCwxTZ5EKtmTbXHDVWcWu1yP
         FY7GOXxhmZOxFGEremD36UeXb1a+Y8RQdq5it1SK4hs32KEeH+JbH/MpvG7eP0pgUFXG
         Uqew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749021382; x=1749626182;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZvVRZGR4kcYhZPhtOACMXE0Zb57gL/uh1lF70ODprqw=;
        b=MHFFGfN3xf/nfmQ2VZztIzkDfwBmz3DiauGGTfPNR/+Q1gd1R3dg9QMVrOfn5sV4M/
         9fQiE5Gk0QC7krIPry87cadcZWCP8MlC5MOlKRvcWEaxWYcN5NeQSDs5tssyg7JApVjg
         AB0kQLSYrExakoHkiLHTDCzdtLnLK7wak0i6vHEp2jzTXa+HOPjP8uvUtHHXQA+u9EU7
         i56o4tV0oTEvrkJRYWUVn4RkT1wnOEXt1DYoZ/WCtv/NW6ZweqyEdmWS1mUFJe1ypgQl
         MUx3Tn5CaSKESBtuAWDIy0gwOb9LWfwdJjF1OLA46RESjXt+To7HIe2C9WURZGETKMkx
         7Weg==
X-Forwarded-Encrypted: i=1; AJvYcCUjU9yeq94pHU2hCdRHpxIG0R2+1fCoCCFTcqZyiVcx8IMd1xt28R+ONm3ySLHT4E0hOLQ9WPJhcg+W8w==@vger.kernel.org, AJvYcCV/AFQ70kL2003RF9vt2r5IMEsMrcOwkLJVdnZEyEAJGgXy5Vvle8Ww23e59b/LU5tCIbwJm1abw5ElJCI=@vger.kernel.org, AJvYcCVkXsIQVw3kH88I1OxKJHYG51D1pd7DE4KsOACbhvmvnCfa3+nY89aOhb8nmOy/NMqEO/Y3NLe0qw==@vger.kernel.org, AJvYcCXgPGBk5h2clrFfaWOoz/JUcAentNiJK4i4lHCwB8fBbBKbeBJr0c0wCvh1HP8RKOd5uTV2LvYZdYdaizy5Gg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy/hnuv6oMazKMxNZFocL6JmJ/wJvfuLdZAND8ttEHJEeccUVEx
	DAEVq7X01G7N4ySid7WOQWTewSHc4tr8KuYm3B6H8TsrDYrR0m6OCIjOKO8qGDu3q3raSESBA2L
	x7bpjoV/f2VDEpnzyKC8OK7LbOvutNQ==
X-Gm-Gg: ASbGncszW8xA65gxjCptzXQ+8uNS1AEbU/HKCOWKrAIDMm9++rCEQNC9nQOkzlS8zaw
	Rl53dP5QgtGZorjEpQoDq3VaZoAhsvg3LW4W4bu4yRc4dciU/Jrpuj20GzkYUMqbdsO+xRyaSl7
	830oukBRuzMwl7JLwfwf5TAWFflNQ6ylt6ZrGCU7X4dyfXFV+IA/LPnKs7EI+zUPw=
X-Google-Smtp-Source: AGHT+IGv7nMMBhCO9I/kxpkV9tKggZGisNrEMKyC/c6Ko9L3Dq41EcoCpqVkVTtWWh+LVoU3WVL2eqPBB4U2dHwA3RQ=
X-Received: by 2002:a17:906:d54c:b0:adb:4203:cc9c with SMTP id
 a640c23a62f3a-addf8fd4675mr119512666b.50.1749021382308; Wed, 04 Jun 2025
 00:16:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CGME20241128113036epcas5p397ba228852b72fff671fe695c322a3ef@epcas5p3.samsung.com>
 <20241128112240.8867-1-anuj20.g@samsung.com> <aD_qN7pDeYXz10NU@infradead.org>
In-Reply-To: <aD_qN7pDeYXz10NU@infradead.org>
From: Anuj gupta <anuj1072538@gmail.com>
Date: Wed, 4 Jun 2025 12:45:44 +0530
X-Gm-Features: AX0GCFsYorPtf7YCFjzZMLK3eHzgUo8z6eXW6_zwZeYqi4jYb7D58zSfQuMfz0E
Message-ID: <CACzX3As_FH1tMgZHMoCJMPhnuB__oh7KBzd9Z_JLtg2CLFZ4rA@mail.gmail.com>
Subject: Re: [PATCH v11 00/10] Read/Write with meta/integrity
To: Christoph Hellwig <hch@infradead.org>
Cc: Anuj Gupta <anuj20.g@samsung.com>, axboe@kernel.dk, hch@lst.de, kbusch@kernel.org, 
	martin.petersen@oracle.com, asml.silence@gmail.com, brauner@kernel.org, 
	jack@suse.cz, viro@zeniv.linux.org.uk, io-uring@vger.kernel.org, 
	linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, 
	gost.dev@samsung.com, linux-scsi@vger.kernel.org, vishak.g@samsung.com, 
	linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

> > Testing has been done by modifying fio:
> > https://github.com/SamsungDS/fio/tree/priv/feat/pi-test-v11
>
> It looks like this never got into upstream fio.  Do you plan to submit
> it?  It would also be extremely useful to have a testing using it in
> blktests, because it seems like we don't have any test coverage for the
> read/write with metadata code at the moment.
>
> Just bringing this up because I want to be able to properly test the
> metadata side of the nvme/block support for the new DMA mapping API
> and I'm =D1=95truggling to come up with good test coverage.
>

Hi Christoph,

The fio plumbing I had done for testing was pretty hacky (e.g., using
NVMe ioctls directly to query PI capabilities), so I didn=E2=80=99t send it
upstream. I plan to submit a liburing test. While working on it, I
realized that writing generic userspace tests is tricky without a way to
query the device=E2=80=99s integrity capabilities. The current sysfs interf=
ace
is limited =E2=80=94 it doesn't expose key fields like pi_size or metadata_=
size,
which are necessary to correctly prepare protection information in
userspace.

That=E2=80=99s what motivated the ioctl RFC I sent earlier =E2=80=94 to mak=
e it feasible
for userspace to construct metadata buffers correctly. Once it gets
settled, I can write some tests using it. Do you see this differently?

