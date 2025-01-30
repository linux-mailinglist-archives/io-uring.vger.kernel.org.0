Return-Path: <io-uring+bounces-6185-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CA997A22899
	for <lists+io-uring@lfdr.de>; Thu, 30 Jan 2025 06:36:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3E1FE16595E
	for <lists+io-uring@lfdr.de>; Thu, 30 Jan 2025 05:36:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7F2014EC73;
	Thu, 30 Jan 2025 05:36:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b="ENqtLE8I"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 345294431
	for <io-uring@vger.kernel.org>; Thu, 30 Jan 2025 05:36:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738215387; cv=none; b=cq60qD+HwrXRYLxn8uMgGdXBRIWzCoWaBf9L9GvWr+ThTpToYK8a5M45CO9k1fzJnEsOyOpmWiSklxu06KeSWJjzLpL6mbHC61vRUDFKYUhsn+vLMZrQdYU5WFmI2KP/kEcWsVH2g4h+jHpFxY/Z/x2ZjewbZI49XKtipiR3qvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738215387; c=relaxed/simple;
	bh=1xTxT7nUEIxCVrTlcmiwYeUPhc+yvExv6p307nMZzgI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DSdOpnix7V8y6/JwhIS4yhxlZhjkc3tufYBNk34J/TfwmnhvuTjYsUeBXgiAKB0EtwFhj8YAt/3Ovj8NVV7Q+QfroTmmLIPxkrtSK0VLbfLx3yuYCU+ZAcOfZSpcp0DuoNZcmoN4xEnC4gC6lcQelEz9QzS9rVhEBa0tc68W7r4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b=ENqtLE8I; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-aaf6b1a5f2bso314822666b.1
        for <io-uring@vger.kernel.org>; Wed, 29 Jan 2025 21:36:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1738215383; x=1738820183; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1xTxT7nUEIxCVrTlcmiwYeUPhc+yvExv6p307nMZzgI=;
        b=ENqtLE8IApL5uqn45MoLvhZNnEtsCWR2NBbbANDJvjQGZ9UswaXykJU/62x2jani9V
         HgTXZYcaVk+RrikbFSnaT8O+g49KpmZ4isKsq7j50bvP+aoxqfLCimfQp3pIyIVOvWVV
         7eBX0IKx2APUPvgvQvPpGoj/pYlfqsE1BNqpbtiumr8W2O+6p1BbA3c7wEBpP4oWLyZi
         GtxsQBZpnFH6HAQAWpVQA+OkkIHXXF1HAuQaPB+4RyRvqQjtgNeK49EvQpUVu9Yvbs7b
         G3Q8xSwVcBTDhQrpYkUYMfHD5luG0On9E2WRJd2v4HXqdPUh5lQLBxnDbsY9rrQ5Eb11
         B2uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738215383; x=1738820183;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1xTxT7nUEIxCVrTlcmiwYeUPhc+yvExv6p307nMZzgI=;
        b=uSuIPLHril9V4UQbAg7aQ/tQToLJXCuZv9b9qibRhwBvDnEb3AhgBB7QRFR5rOj7iA
         PJTbpR76QU/+lmJDXkj1VqVe1EqrZQG0DIVbGsXQfmT5cyg+CeQOpoft5NIN5bCyn/XO
         p+r+3yWuMe6GcOgc1c8j5E0ki+TY0AMaybXioeWkXVjqyCnrZBdi1tZJJd9OwtkakEVx
         1b1o/kffHUXKr7YpSmqlWz8SLCY5tih6R3fgJr7TeC2VoH04OT9DG1CMbTc+zji44BQA
         BPH06azrdur0t56a9KJFSF6iC5I6GCdiXZSvxAnVV0fvTH3+E8apyJIVixiIhxgouwQx
         pEvw==
X-Forwarded-Encrypted: i=1; AJvYcCUjsR0Y7lG499B+ilIMKlKLNpzU6oNmC9dMGhXPoSHAw+0jm4MktToaE3ykE25IDpxCRCTBpZdQoQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YwAp5mJteYof3aQez/6epUwqJIGVrBljLiTdLpOn5StViV63iMi
	Lt9wlcQIhAVMwdt5PSta0TBbUV9Yuq9/3mhsW2HYfMpsWQcxJwOHlouIY6hkKD87VzVDjjW36d2
	0URzRrwA3aZ3W2mcVCgbIvosmjg2EIr8GcDDs8w==
X-Gm-Gg: ASbGncvFkvzXbpcOhtfnimU+WkCjlPaHBuAm8NaRrOEtY/meZjmWUQOKviAneGZ2RIX
	fNHL0Fcb240v3NO44qMjaZPSFUaAwYkmxYKxjfbUa9WGIMmkqy22Vvse/PLBDJUc/zoSiNq+R/M
	/gIfuirxnI5fe81NItvKsh1xbRJg==
X-Google-Smtp-Source: AGHT+IFTcRDxyjeIL7TMQ2abh3dRBE51uKAm7+BpaUm/hXSSx0Cx1xieccfc4AS5DG07NNp6kfdSRCMkyPBWCqxX+j4=
X-Received: by 2002:a17:907:2d23:b0:ab6:8c29:57d7 with SMTP id
 a640c23a62f3a-ab6e0ccc0d0mr138750666b.27.1738215383553; Wed, 29 Jan 2025
 21:36:23 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250128133927.3989681-1-max.kellermann@ionos.com>
 <20250128133927.3989681-5-max.kellermann@ionos.com> <856ed55d-b07b-499c-b340-2efa70c73f7a@gmail.com>
 <CAKPOu+-Mfx9q79nin7tGi1Rr4qGGY=y-2OhuP80U=7EtRpfBdg@mail.gmail.com> <19750632-1f9d-4075-ac5c-f44fab3690a6@gmail.com>
In-Reply-To: <19750632-1f9d-4075-ac5c-f44fab3690a6@gmail.com>
From: Max Kellermann <max.kellermann@ionos.com>
Date: Thu, 30 Jan 2025 06:36:12 +0100
X-Gm-Features: AWEUYZmzk3Zthvn5UCDK9Xy4WQiz5Fcury-2hvYI_R5rgcJ9y-3vqehzkGcdTzg
Message-ID: <CAKPOu+8_Tivtyh0oj7UEuWPmdw-P96k3qRLvte1F1C9XivjS7A@mail.gmail.com>
Subject: Re: [PATCH 4/8] io_uring/io-wq: cache work->flags in variable
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: axboe@kernel.dk, io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 30, 2025 at 12:41=E2=80=AFAM Pavel Begunkov <asml.silence@gmail=
.com> wrote:
> Ok, then it's an architectural problem and needs more serious
> reengineering, e.g. of how work items are stored and grabbed

Rough unpolished idea: I was thinking about having multiple work
lists, each with its own spinlock (separate cache line), and each
io-wq thread only uses one of them, while the submitter round-robins
through the lists.

