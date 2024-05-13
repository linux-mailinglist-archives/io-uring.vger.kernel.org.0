Return-Path: <io-uring+bounces-1890-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AF7458C4079
	for <lists+io-uring@lfdr.de>; Mon, 13 May 2024 14:11:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DEE361C20E42
	for <lists+io-uring@lfdr.de>; Mon, 13 May 2024 12:11:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 51AB614D2B2;
	Mon, 13 May 2024 12:11:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hrG08BQu"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ua1-f49.google.com (mail-ua1-f49.google.com [209.85.222.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D38F314C5BA
	for <io-uring@vger.kernel.org>; Mon, 13 May 2024 12:11:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715602314; cv=none; b=l4WZsPs/lk/LP/fPIGU8vA4aBxYP0Bp0d01CWUcLQUouW42PxjXyyWPVaRZX4wCepDJz15OQWB5BOCzZs9PYdPbIpCbU9I11I1BFkBveydOMM72zDS/+4EpeQjlgCz8jIEv6AT/XlnzGemWndagDG/v5gle4iDqVqfyC45Dl+PQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715602314; c=relaxed/simple;
	bh=GMvOXb5bWKr1swqI48IDQwy7SqnKCTQgBTJXPpwJ7Kk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dgTMvuEXtNJldZQnt/WlJPWx5Zd33MGK4u61BqBVGG+MUGXMnOt6cyLacfX9LpA6sAYIvJpUiwhzgxWyx9T0JxwgEEWthpnlYcZmXCJY6X1P6K4oL2Uv6eKQtbvl56obbBlEKPq6w4S1u7GvusJJqGGyEfLYD43nxpvEADm/y+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hrG08BQu; arc=none smtp.client-ip=209.85.222.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ua1-f49.google.com with SMTP id a1e0cc1a2514c-7f18331b308so1619342241.0
        for <io-uring@vger.kernel.org>; Mon, 13 May 2024 05:11:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1715602312; x=1716207112; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GMvOXb5bWKr1swqI48IDQwy7SqnKCTQgBTJXPpwJ7Kk=;
        b=hrG08BQu1984FXXQEmaxX9mzwrWbP2SBReLBlVXvXWmsrB3/P5PKjopywrUIAksZn/
         UQWv3sl4rqAHCxnmLfxlwp7mngeLaGhantpxBesq8sImWEPD8AlWHc/duKpni/yHNojD
         9PoRJJXo9+QZUhQ6m/1HJnQ01nr+lpjikNXWFDw091iE+Zm0ysJ4UadUMOLqiwWdpZKw
         hq/zBb0qadfSNPqt9g0xfGN7v/yq4l69HttS27YCpxb1uNr63RL8wZe7M87tdRiZFGlT
         GCjVDC2nRsj4hJ8JXURsU+vlnvx3hTUF8++Kfzv80Qcc5YnBlxGJeVjLMu3bEgLKW5TM
         +IlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715602312; x=1716207112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GMvOXb5bWKr1swqI48IDQwy7SqnKCTQgBTJXPpwJ7Kk=;
        b=hXdzcIizT8TW1/TOEqm49hvueXtq4gdtK3C2dJK6/UCePnKkU2gZKIWnSD86Jalt4I
         b+dYFgYfhU3gFWvpmfSBrX6RznBMiOF5m6Bw896FKUXWK3JHI6aSidl1H32QJfjBm2jh
         7ZqvP7R+Z4yWeH3j5a+yztE21R2zqoo4aEMr/g9qEBwZspty/SU87YMKvUC9wWp8cvA+
         AyGnuYzgjVdq0Z/Q+R76mHiS2c2ue5AhRvHemmlxS5hud5D9XrPs+LeNUM79H11Yx7aR
         pc9ZLvBfa2NrM67Ylhak5zIppkS+zdtcqMhl6HAHRHrlx0Rgz5h41DqTg5J/SqbtK+wd
         ImKA==
X-Forwarded-Encrypted: i=1; AJvYcCUV/352Ws5C1AlFgisdiFN53+BJjNoNt/cd9On1gm0sPrYvwZR04RIUWPFR+tYXSPk+n2jtJycM/1buu3/seiHnHuybOnZwnLU=
X-Gm-Message-State: AOJu0YwXRwIF8WUtQ5Rb38nzGo5YDLi5yQTB7hwTq/3y9sGGQKR+bvul
	SaCtPozEJW41+IeHQ8LExpZwZni+G5ujBwNRoOyOlsybcXoS1yuh+EfQuJGM+rxxItqH/FYWVnm
	013sc0A3TIgdifpvoAjR7T11URw==
X-Google-Smtp-Source: AGHT+IH3TS/kpAgZAqDcF7I/CJrgp5eEEQW+j6ucD2GSsndLx3UqMmN7jMwtWbI3KTM9DmgUqhZ/hm5zQJKEP3scxBY=
X-Received: by 2002:a05:6122:3124:b0:4d4:1a1a:6db7 with SMTP id
 71dfb90a1353d-4df8828087amr7218330e0c.2.1715602311661; Mon, 13 May 2024
 05:11:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CGME20240513082313epcas5p2a781d3393e4bf92d13d04ac62bb28fb7@epcas5p2.samsung.com>
 <20240513082300.515905-1-cliang01.li@samsung.com> <20240513082300.515905-5-cliang01.li@samsung.com>
In-Reply-To: <20240513082300.515905-5-cliang01.li@samsung.com>
From: Anuj gupta <anuj1072538@gmail.com>
Date: Mon, 13 May 2024 17:41:14 +0530
Message-ID: <CACzX3AtWK52NQfWfnYvxtTKi03kxQS6+uKgxhuc2Xc2Yix9uBg@mail.gmail.com>
Subject: Re: [PATCH v3 4/5] io_uring/rsrc: enable multi-hugepage buffer coalescing
To: Chenliang Li <cliang01.li@samsung.com>
Cc: axboe@kernel.dk, asml.silence@gmail.com, io-uring@vger.kernel.org, 
	peiwei.li@samsung.com, joshi.k@samsung.com, kundan.kumar@samsung.com, 
	gost.dev@samsung.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, May 13, 2024 at 2:04=E2=80=AFPM Chenliang Li <cliang01.li@samsung.c=
om> wrote:
>
> Modify the original buffer registration path to expand the
> one-hugepage coalescing feature to work with multi-hugepage
> buffers. Separated from previous patches to make it more
> easily reviewed.

The last line should not be a part of the commit description IMO.
--
Anuj Gupta

