Return-Path: <io-uring+bounces-8058-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A002BABF5C3
	for <lists+io-uring@lfdr.de>; Wed, 21 May 2025 15:13:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6DA191896DCE
	for <lists+io-uring@lfdr.de>; Wed, 21 May 2025 13:14:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 322642D613;
	Wed, 21 May 2025 13:13:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HvhcD+QY"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B69E2609FE
	for <io-uring@vger.kernel.org>; Wed, 21 May 2025 13:13:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747833218; cv=none; b=ND9CzFrmRtHU2LLvJUwytSVp1iQVs/NLB4vfnWSjG/6ziednZ+SpRXt0vhnjNAoLe2yQJD7ClndNkxxBIntAmstMEl1tqi5VzWXq7PDoH6NfR5YBPZ3QEK+y+aGpz2xuhFnLW2hJwOjopfZodujAKywr4lRKb2sahyrYsCxcTGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747833218; c=relaxed/simple;
	bh=wxn5XqZLx57QVBvo1Pdat2azwPhwWZdB1AWrd49a5RI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EUk3Ua9hcu+qHFTbJMEwW8FrgsUY/9u2TPZRgiv57rpGQCjB0597bIFmkksz95r7XQWGVvk1jIIXTfOh15Kr8XKcQ+gUTY3RPYsziPsLqSpYFOvIqZ3XLYGZQ1dTLCXLT7fK1Tv/WNMlFzOFRpXaB4VDo/PjWZMWRGFInzkMhco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HvhcD+QY; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-ad5394be625so276369366b.2
        for <io-uring@vger.kernel.org>; Wed, 21 May 2025 06:13:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747833215; x=1748438015; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wxn5XqZLx57QVBvo1Pdat2azwPhwWZdB1AWrd49a5RI=;
        b=HvhcD+QYL9PHTP//sqSSSMJQJt1aF+fbI0udvmVnqANFPr9TmpnXVcx+1dGCw9NCmv
         R4ddYQ307VCpu2NmqXWHdxF+c/tHPDLVu85Mfy7/EX5DfsQBRgMPluI3P2N/FLxu7vh1
         mwmwviNWoROy2/SPGekHP1NkdF3X6/eoMb6fCGX4h2rxMkPqEztw8oubWeF0rltF9H+8
         CauUDRvkmgZvfrGnYvoE8Abn70tKkt2jQ84MD5S/hcqeK687MXAcbD4nYwBazEDzEktB
         XNefEaabT2AlPgE1hn6rNt+19A3aHckfcmy6kECzcwJb2Kv6JIUO7rJKOupU4bVVzTyS
         fNfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747833215; x=1748438015;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wxn5XqZLx57QVBvo1Pdat2azwPhwWZdB1AWrd49a5RI=;
        b=LyhGXlFLrGoDs/rYxd13/sDzpDvl3JVLHsQNp98LdtL3uJZyeazlpgWRB8nWW4urzl
         0pPyeqMkTuQ5VLBB0ewGfnmYEXXt6vZ6zg4EttyDoUfk4L07kB2SdonaZLlI2E025kdV
         hcdwaa37ryp3adML/Ak2AmUyWA0YRs+wh7GtDSBhOP8jDfrFxlSg9FmJDwpZzyS21d+l
         W2D6wXKDYsEggMllQmgdGhcaHPtCoc0ziMhGIZkTEY9ygDZvkbErJlgcqmadxLj5UYaf
         GZRwumgheXmAPeR+A0BlRWB3du8FiYH8FqU8XSP1sXe2TSwCp/BjcsR02p92BAR6dtjb
         2Ykg==
X-Forwarded-Encrypted: i=1; AJvYcCXak1DoPAQCQzKfCVEw2Y6I9+BygmAwEv5ojiK3tNgMbWkza1y10PKbX3Y0ssA6dinle/UKUzEqAQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YwlYhpsX05AwuRHtI6EM69qeZa78kTyNAilyZBx8XZnLofem2I1
	QKJKfRPHT99Fti9jMbgpdNqmf9QylQwBF+QZy1yGxz1zgmtS1TRyqjCJoLXIs4LaI7B+gLOJAWh
	ge6JDoWJDCVC++nlx4aXd1lM2xTu0Nw==
X-Gm-Gg: ASbGncvVSnsUOAfjycQwJ2PWcTU1ONZmgEHihPCNGlZNFiwDDYJCJcKmMgO4T9hhcmI
	9rzpGQjstgZ2OXLtp2Enc7A0nFfwFhe3eqgkl76OfGdJizffpkxXJ419gCj5+q0SleYcfqZj4Of
	kr+4mgT0p6iy8lDuZ8Qu5rMM8UqmCy3U4zIbt0mfdS7A==
X-Google-Smtp-Source: AGHT+IEdlFWglRl/zX62Tq7o55i6LsnTJBxglZlP+bIhf56wVjgkN2s+fEhy4Lb1sA16QYd3hVF3qPzAXP9qiGsBD7Q=
X-Received: by 2002:a17:907:2688:b0:ad2:3f21:a092 with SMTP id
 a640c23a62f3a-ad536f38547mr1894884166b.56.1747833214427; Wed, 21 May 2025
 06:13:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CGME20250521125340epcas5p44d0f9a187e59ded5975323dc3017a8e3@epcas5p4.samsung.com>
 <20250521123643.4793-1-anuj20.g@samsung.com> <2f4cbebc-987a-4c82-b51e-64e47cf2c683@kernel.dk>
In-Reply-To: <2f4cbebc-987a-4c82-b51e-64e47cf2c683@kernel.dk>
From: Anuj gupta <anuj1072538@gmail.com>
Date: Wed, 21 May 2025 18:42:57 +0530
X-Gm-Features: AX0GCFspjJTMMRlFVqAIzzxF6xojwMzSj2ycZPweVWvr46XJPeb3lBqkaDqhkJM
Message-ID: <CACzX3Av1d4wFUxLnJgzHoQe2+-pz2=94EFQEsOGs7gjO13ADpQ@mail.gmail.com>
Subject: Re: [PATCH liburing] test/io_uring_passthrough: remove
 io_uring_prep_read/write*() helpers
To: Jens Axboe <axboe@kernel.dk>
Cc: Anuj Gupta <anuj20.g@samsung.com>, io-uring@vger.kernel.org, asml.silence@gmail.com, 
	joshi.k@samsung.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, May 21, 2025 at 6:40=E2=80=AFPM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 5/21/25 6:36 AM, Anuj Gupta wrote:
> > io_uring passthrough doesn't require setting the rw fields of the SQE.
> > So get rid of them, and just set the required fields.
>
> This conflicts with the patch you just sent...

Right, I will resend after rebasing on top of latest. Sorry for the noise.

>
> --
> Jens Axboe
>

