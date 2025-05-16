Return-Path: <io-uring+bounces-8020-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 91D24ABA664
	for <lists+io-uring@lfdr.de>; Sat, 17 May 2025 01:17:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C9E347BC905
	for <lists+io-uring@lfdr.de>; Fri, 16 May 2025 23:11:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5DE9522E41D;
	Fri, 16 May 2025 23:10:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="E/6bOY5J"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84EE423504D
	for <io-uring@vger.kernel.org>; Fri, 16 May 2025 23:10:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747437032; cv=none; b=VCunZWFkOXHXsEcURsC9zobKfzzjJbAQU2RozJMLX5Yf7Ly7FQl6R0h+nQLFiXbGx29EKyabUOsWHupR0mnSvf+Y8QSyaHRAnMwFwG/Ii8YbZwgazF5dJpL8gyLzt6XjjLIVuLgw3pKI7EEDHfSfMn1yjPFerYCf9nd5ub40J6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747437032; c=relaxed/simple;
	bh=7JwaBzECba3jx3QH7urgwZT3w3vj6uaDMHEMoD1JhaM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FtrnecO8y0t8+Ejvjx8Syiw+6Yl4v8tRcGzCeEl7vDLydkKpc1dun806/yOcU/B+LZZ9Xz4WQPrvLjsC55zw04eemj/k2MigqetndeMArtS0nu38U+brwfBODB/VduooNw0j0PqcajVRWEy6AtXaUebQQGXMa+pQX5h+bthc/NA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=E/6bOY5J; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-30ab2041731so329925a91.2
        for <io-uring@vger.kernel.org>; Fri, 16 May 2025 16:10:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1747437030; x=1748041830; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7JwaBzECba3jx3QH7urgwZT3w3vj6uaDMHEMoD1JhaM=;
        b=E/6bOY5JbYfAWiQBrW3s6vvavuPThp1R5LOEVOox22Ri7u1ibM5WMJuIjnUbLsj9el
         h3832v9uM3LVOa/JczjZr7Rd6HHA4+cEzWvepDrq9I+TbPNnLkPyat+E/urZzZTJA0ne
         5sbfmhJ4GWpDu8fuUKK/Tm50aOEGlBw5RCieDB2rDaa2ToJyGKRaHsiZpZtPu4XfAW6y
         G0L2atPpy3aITauBrf4E1o1OYs0rJCR6bGZuvpBi6GzAJbAKuBey2QkzkE2X9SVjQbFr
         C5pl3XiNz+SB1DX5t9PMZQIg9/58XK8GZBvl/9opcvbUx+kXwxVieaGgEBnzhp07QDr/
         zs+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747437030; x=1748041830;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7JwaBzECba3jx3QH7urgwZT3w3vj6uaDMHEMoD1JhaM=;
        b=Q23Aadd1wyM2FSZ6dYN6u2wQVrM4p6uMcRM2JojBFybvrm1boFnXXXKz3SEw9mEaGW
         NV7cOioz8DhuchEuZ7GUFL3w7UOQyoKJbQE0ZOAe6ETCk4VHtUolAeqt/0NXA6LYEgvx
         aT1igHReNXUJQZb+GAKDmpqklCjqWghkh6VWVw6/oxZ5yEojorIqUpdFB8xQiNIRWjJ6
         l66X1Z0nVLUcLqEfaVQmITal7swME6n52qEk87Nyo0/HbKOA14Vbvb44Pn1FpKkaSlzF
         ILtQdzkY3G0Vbo4TgGlpMAoWgACBR156mbXSt7kiHgOgk8MgUCXKNmTDcA0Y4eG9vTmb
         IaBQ==
X-Gm-Message-State: AOJu0YwDXnj2tNrKujqdYuNcqVMlfRsSmVzx9NS65c2mU3YKrKOhSF2Y
	IaMqsGxZfx3gk/vK2RoYqgEbKvLCGkDJt9OxnVF4Q1+t8+AzhPAVt7Ht8iPpJrjqNWh9QU7zKjr
	7SiGL+rwq3nIj6p2Wzxp1+IAMwbe/seS3qXBvIwYYPg==
X-Gm-Gg: ASbGncu5npkia05m8L9KrKYDWv+XO86Wu0i/qED3WuPyUTc7CEoHSv0LGeNTaG/vk9L
	vFMJQu0/CjkQ8J2LbMxY8SpjgRtGr8dEFr5BB6PT/V4SvPzTDCI0k6Bory7nU+1dkozcmoKEecK
	4DwqKsybJKKRoOf2hC/Bsm3VjJ30+qTt0=
X-Google-Smtp-Source: AGHT+IHSbXANxgUoUzQdgW/W9F6MvoWZMF2TAkSabKmHHrv63CeLTFPYNuFPzvBv3++S32y00hkoxZwDiEHDo/lfuJA=
X-Received: by 2002:a17:903:2f43:b0:231:d156:b271 with SMTP id
 d9443c01a7336-231d43a65e7mr25538985ad.5.1747437029768; Fri, 16 May 2025
 16:10:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250516201007.482667-1-axboe@kernel.dk> <20250516201007.482667-5-axboe@kernel.dk>
In-Reply-To: <20250516201007.482667-5-axboe@kernel.dk>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Fri, 16 May 2025 16:10:18 -0700
X-Gm-Features: AX0GCFtTPyM6JluuLtrBMSVpyltPaaqpoD_SYA77b4giI-o9btiVkyP8qw-08gU
Message-ID: <CADUfDZpLi-YWhnzUntychzMYeLZCMGrrLMKXHRq2Hzk+jZX-FA@mail.gmail.com>
Subject: Re: [PATCH 4/5] io_uring: pass in struct io_big_cqe to io_alloc_ocqe()
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org, asml.silence@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, May 16, 2025 at 1:10=E2=80=AFPM Jens Axboe <axboe@kernel.dk> wrote:
>
> Rather than pass extra1/extra2 separately, just pass in the (now) named
> io_big_cqe struct instead. The callers that don't use/support CQE32 will
> now just pass a single NULL, rather than two seperate mystery zero
> values.
>
> Move the clearing of the big_cqe elements into io_alloc_ocqe() as well,
> so it can get moved out of the generic code.
>
> Signed-off-by: Jens Axboe <axboe@kernel.dk>

Reviewed-by: Caleb Sander Mateos <csander@purestorage.com>

