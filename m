Return-Path: <io-uring+bounces-8052-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C385ABF1C2
	for <lists+io-uring@lfdr.de>; Wed, 21 May 2025 12:36:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7EDE41BA530E
	for <lists+io-uring@lfdr.de>; Wed, 21 May 2025 10:36:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D2A42397B0;
	Wed, 21 May 2025 10:36:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="R08qbMjr"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8C982367D4
	for <io-uring@vger.kernel.org>; Wed, 21 May 2025 10:36:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747823767; cv=none; b=LyG5P7qpT7SHvqTVsKvYAjRmAgxW2DCiSEQFyDXkLn7/0SleslT1PAxgXgYUGRXKeig8iyAZARR89iHxT5wobcn/8WoTdH70NvQDrkHTuBtjOJGxKPHwNvV7Uj0l83wrFyw/Q68y1VkhwkHTBHpANHX3ZyHe3eNQnrNSHJJLU6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747823767; c=relaxed/simple;
	bh=3bjZvtZ7qDJluKRiTPEtvISWZVye5XI9Qsrqp7BlSqw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DpSLLl0Ug1Lqu/IwH7WGu3cTC4BkPfzn7BqikgRcGcAGUuI582c7cUXHMbny9uQa25BurL6b4FtD87TdAVeCJ9vxiMs2c9CEypYEZ8b9afzh6W0q6SdR2KJJ3P/Wj9fdWnQBabK+4+bT/kJf2pKYUKk0xRUAAtbOGnQtt6m8pBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=R08qbMjr; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-ad53cd163d9so839472566b.0
        for <io-uring@vger.kernel.org>; Wed, 21 May 2025 03:36:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747823764; x=1748428564; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3bjZvtZ7qDJluKRiTPEtvISWZVye5XI9Qsrqp7BlSqw=;
        b=R08qbMjrRvJtM1L27b/b00MWHGwCkmZ7ftaIsr9tcHGDgC/RG2lz1J5rkbofzwV5iE
         pG7+ZA0rQDEHfAuS7L+r5tLkAK7eBax2LXmKfWmhjpyzxgpVADez7wq6H3QfPtbw0rJ6
         2IdybvWLCJtbmAAHkL5l0zeeeR45xv+hS73VMrjIdXijpJquwSQVVNy4j94m8VAAA2z8
         RJw7cJEFGiE67hQpUqS9gdJys0IJWUzQcWZfoF5BSSPQDrTzbkINAJZzP8lv3eyfTyKQ
         jQON0g+IMOzfJs7AgSjZ1IELdeW5Z/J+Hs6trkplJc/ao6n9Zsq4c8JqqK2yTRh6rH7x
         W1bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747823764; x=1748428564;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3bjZvtZ7qDJluKRiTPEtvISWZVye5XI9Qsrqp7BlSqw=;
        b=iUGdMZHEOxCprz/LE9Q02bgA10LgbFGFcESRXMED65z5/AbFjYWEZw21688atnbLrO
         EFLbIjYANDvydFW3YKqwEqmW/8g1Cg8kb7uRkg4W7C7mRE7tmWR6SYc4uPZyqXHXlzT3
         rvrjmQI+lJuTs2z/2Lnj+esrfMGxMpEe9qXbK7C1F/iHRKHidCwwtQule/yzlLiZ6oCs
         VDbcoKsXwnojVF+zygMTTHuMwXu1WYyrdY1JGdIius+kUB+Jq2WZ/2mczTc3ErcX0FkP
         rm7tBLN5JwoCRX8vYCFDGg/hmQw2Cq6BDMzANsmMW//ydOwQZeO1IzeubtuQI03Dq51g
         rrDA==
X-Forwarded-Encrypted: i=1; AJvYcCWddHeyD1RdNYXQFseRUsb1nR15jfPhzqTDK0eU5xMu/6/vxVyqHYtWf7ruyaCH+Ccve2qZgvoyFA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yzu6bd75ChrWHp820KnivwU0bZjDNo7u19mQC7FimYQQn2Tcdeb
	euHZ5iC95H07etrohPyxrU+k+lNakgzWEaT8BL85fSZQcmT7L9o0AlWzG+CdCYcK0yTLK1Lm9kw
	7zx2SuBtgOlrwrBXhmElOTctkAUSBGQ==
X-Gm-Gg: ASbGncu6SsbkiJB9Q7jbfoU+tnPw2WwuFczbu6zLzxpnNCBstjkdqFc/c8abaYRQjbH
	zb8Y0tsJ5QyEYGAjdiAGeDpv6k2QiQmXdH2ZvVD7KoPPW74YfHFnbx0qA7SPyZyjwXdMoq2MxWY
	6kaT4zqBQkXeQzQ1Vj1ARzCsdwT0oPPWR1pSXBwaiFimJ7Y6QkVVJegZ9ooz8qnk8/Pw==
X-Google-Smtp-Source: AGHT+IF86W+quI1z5OOH/mOSn+1bJ2Nv7s4s92BllFXmivcnEFM+ezVuWEa/YHZuSqfAAKsMqvtMzBly5QgyxlktqIY=
X-Received: by 2002:a17:906:8d7:b0:ad5:372d:87e3 with SMTP id
 a640c23a62f3a-ad5372dbbb2mr1429272866b.27.1747823763577; Wed, 21 May 2025
 03:36:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CGME20250521083658epcas5p2c2d23dbcfac4242343365bb85301c5ea@epcas5p2.samsung.com>
 <20250521081949.10497-1-anuj20.g@samsung.com> <7e846c8a-3506-4581-bbc5-fdf9e084a5bf@gmail.com>
In-Reply-To: <7e846c8a-3506-4581-bbc5-fdf9e084a5bf@gmail.com>
From: Anuj gupta <anuj1072538@gmail.com>
Date: Wed, 21 May 2025 16:05:24 +0530
X-Gm-Features: AX0GCFvJGApY5yz7B7xl-azFkfWRnh8JtNXl02AdnQXC5eGWWx_XqQGEO6cXhXw
Message-ID: <CACzX3Av3G1K0aoZXDOHjfT=Su6G9D-_RyKWjdMwsNpba8T7CFA@mail.gmail.com>
Subject: Re: [PATCH liburing] test/io_uring_passthrough: add test for vectored fixed-buffers
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Anuj Gupta <anuj20.g@samsung.com>, io-uring@vger.kernel.org, axboe@kernel.dk, 
	joshi.k@samsung.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

> LGTM, it's great to have the test, thanks Anuj. FWIW, that's the
> same way I tested the kernel patch.
>
> Somewhat unrelated questions, is there some particular reason why all
> vectored versions are limited to 1 entry iovec? And why do we even care
> calling io_uring_prep_read/write*() helpers when non of the rw related
> fields set are used by passthrough? i.e. iovec passed in the second half
> of the sqe.

Thanks, Pavel!

Regarding the vectored I/O being limited to 1 iovec =E2=80=94 yeah, I kept =
it
simple initially because the plumbing was easier that way. It=E2=80=99s the=
 same
in test/read-write.c, where vectored calls also use just one iovec. But
I agree, for better coverage, it makes sense to test with multiple
iovecs. I=E2=80=99ll prepare and post a follow-up patch that adds that.

About the use of io_uring_prep_read/write*() helpers =E2=80=94 you're right=
,
they don=E2=80=99t really add much here since the passthrough command handl=
es
the fields directly. I=E2=80=99ll work on a cleanup patch to remove those a=
nd
simplify the submission code.

>
> --
> Pavel Begunkov
>

