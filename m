Return-Path: <io-uring+bounces-6669-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6BD6FA4206F
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2025 14:23:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 03B21189AA7F
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2025 13:22:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6751E221F12;
	Mon, 24 Feb 2025 13:21:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PDaiO+IO"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89D0918B482
	for <io-uring@vger.kernel.org>; Mon, 24 Feb 2025 13:21:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740403287; cv=none; b=Bdo9lrxXshYLP+E4IiB/hBdT08TynxE5D+VAcBtAukDhXt16gqsKCJpoDrVA13oq6Im1LHfGQPGjvb87SfJ6OriAfzvPsdSO1JdldbS5YZXYunTOX1gZiuYpsbKgyEtKqadysVWIiEFmLQEKqpxQu49J7YX7Wfq4LzivsCDgTUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740403287; c=relaxed/simple;
	bh=O/Pd0MtD0eJiwbPuzLhvxnxopeoCFeBWmTgyugx7VjQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=t9hZAyb7JklW53OcrI8FYeq82a3WVTAkB6c4N5cve4tKnMiTfbgcrNyb4fi3ia8bt8vaSWWMyoHydmoFEgGcq7iyJqRyGLou8BcehYQvCxNMrzW8yOlvRYtPY69yKu2Tm17RlaGa73ht2G3UC17p2toATkMg+cs5LnRsvJLa58E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PDaiO+IO; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-abbdc4a0b5aso810572966b.0
        for <io-uring@vger.kernel.org>; Mon, 24 Feb 2025 05:21:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740403284; x=1741008084; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=O/Pd0MtD0eJiwbPuzLhvxnxopeoCFeBWmTgyugx7VjQ=;
        b=PDaiO+IO372Uj9U/IU6jRmXnhXy9J3cVa53yZMkFp1cpw3sgXS9n1YmRx/WMyFwcC+
         YbNT9CYdMQ0YYG8eFJGzUWtRPx2Atu7I4hU7GX/4mxXuiUW7KVYp/AF/ajE/2twrzLdW
         k16us+KHNEYc4Dlq7gcP3c6hekacLYuwa4Ym3okcf+L0ljaJfVT+dGT95VLEhAg5B+ct
         FwM3T+xX6M8Ddi2+9gnaCxHnznQZtBiN4iaZnL83Y2gU+lrvBwihtKGNTfYKwKgs05+n
         Mt+bVjlgW4WAhkgbRKK3UaxMu1dCnrMVwN0BBO8yYT5jfi8HykYvdX5NjVowB2QXHJjU
         OGLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740403284; x=1741008084;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=O/Pd0MtD0eJiwbPuzLhvxnxopeoCFeBWmTgyugx7VjQ=;
        b=mVxv8QMwGKrFpDxF05cdS7whthCSK1MFN2OxTun7LdQsRtFcwrB8LBdgAMgWwuMXnv
         PuOWn/4Da3bEmo6x2PXhVsGwlFToIUCtPFyxRc00J0JSR3DAHfZs8XDLetp8M+4nj505
         VkPpE7aRiggGimQeksS44S5SpkQiTt2AA4iBu2rix93/zEFWslUONpIwuENiW1WES9ku
         /ymngaLJOoFNv+puwYo9/pevZ72/lwELTXkhl+JIzGQzpjsMmjdSZLJh4oSXXx2Q4bOp
         pOAZaA0qika1R4aeEDPFkxZ8pIGGM/p6SqDW05ZmCN8btgK6IyUqjzYZO8Bx1qHbPJ6r
         ADbA==
X-Gm-Message-State: AOJu0YxBuF3H2506UFKDr3WFgBjpdLKUO+UjG/FPk+QEABqZ/isnYB3D
	TXWqTCUGYI+xuFqjfzHST5kLnUyDsXZps8uaSgR/2v3PVM5IYj13KSVsfXtvZaEhmAykydrimQE
	r33yJBMfpD7EyMPhdVuJrNr0Xyg==
X-Gm-Gg: ASbGncsFpnVDpDqfDMhGlbxOZOd8l3hNcNKurdZjqMAx/GgIFP1eVCj/MrsH1KuFbOu
	eKMyIe/K9fMzAx0J343FA5MYw20005t+pApBWtn/rquTd/wTRH/JZ53RWF+ogIAru+O9LVNbdSr
	XAWOMST/8=
X-Google-Smtp-Source: AGHT+IF9UzG15CgUn6cMoHSvv0jEVyfvGpYDb0V0MEd+MeXmey9pBO9iG15H+r7nFXMX7YIqgWzIjuK6ZZWEH30NstA=
X-Received: by 2002:a17:907:1c92:b0:ab6:ed8a:3c14 with SMTP id
 a640c23a62f3a-abc0b0c6084mr1135708766b.27.1740403283539; Mon, 24 Feb 2025
 05:21:23 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1740400452.git.asml.silence@gmail.com> <1a87a640265196a67bc38300128e0bfd7839ab1f.1740400452.git.asml.silence@gmail.com>
In-Reply-To: <1a87a640265196a67bc38300128e0bfd7839ab1f.1740400452.git.asml.silence@gmail.com>
From: Anuj gupta <anuj1072538@gmail.com>
Date: Mon, 24 Feb 2025 18:50:46 +0530
X-Gm-Features: AWEUYZnXsl1c1PfbNgqLyBMGzGvWyTwZs38TG-4BgfT9O8tQa0A1-PMVaWeflpU
Message-ID: <CACzX3At_g_cOOQ5Po1gN0EfCStxybWsP-AtWTds_aBcAj2GUvg@mail.gmail.com>
Subject: Re: [PATCH v2 1/6] io_uring: introduce io_is_compat()
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Content-Type: text/plain; charset="UTF-8"

Looks good:
Reviewed-by: Anuj Gupta <anuj20.g@samsung.com>

