Return-Path: <io-uring+bounces-8094-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C1540AC2132
	for <lists+io-uring@lfdr.de>; Fri, 23 May 2025 12:35:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D9DB4A24312
	for <lists+io-uring@lfdr.de>; Fri, 23 May 2025 10:34:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0D8E18E02A;
	Fri, 23 May 2025 10:35:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MaBozEi0"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E824189919
	for <io-uring@vger.kernel.org>; Fri, 23 May 2025 10:35:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747996511; cv=none; b=QJhImAHtKuFmmZlACkXJg6/1eYITTybN/3dQzDTmN6z4iAUQfa/8S3JM1VJbtUIqG3XPjNkjFCtxAL6is1VI6K3drmNJgDAmdjEBoqr19Y/dmLfBRcmuJtyEzBOvsET3dhUAUFRwd/sBs/6vKdV3UbSEPTNTVYKA6O+yr2YJSJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747996511; c=relaxed/simple;
	bh=gm1y3HjSbfjetP2qj6SkQ/PvAerOiP935sq/jHQIUpg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=eWmjpB85oNUYS9fZxDPvFsxOTySImZSr3bwG9nYK2/JquizoxmPNw6X4EYsirN2x4WQ6coFyLO3Z9rBXSIBKbeDc2o9pcNb5wgscFDkMBx2tFh4tfgpg3BFbjGitH0LDhGeCLlMjn38rOxye/h+tjxJ1fB64oot2NFXtlUaTrGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MaBozEi0; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-ad5533c468cso977509966b.0
        for <io-uring@vger.kernel.org>; Fri, 23 May 2025 03:35:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747996508; x=1748601308; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=gm1y3HjSbfjetP2qj6SkQ/PvAerOiP935sq/jHQIUpg=;
        b=MaBozEi09ZNNLMY6VbQku8jSXTUzmKmhhlFhPyac04J8dBi4UFmrlvFiqsznAu+fps
         JIUksWm0WfODH9oSP7kKEfi5AQk/XM8a259CZX997vcZXxWvfIABEc+p5xxsJc8EkYCE
         4UVqFa7SWpZptLrX/V827qqm/F10Jou8lybmplOch9kqqoH4vIUsZgX6Kv9yS0MeeNIK
         Q5axokCbH6azxfzRs9vt7P9s0R/989jhwgFKBMnR2+Tt1Fte9PmXlI94yb61r4yB1gS3
         hSrE/UjxvlbI4TC9ShNANdLoWNlbSfMeXXEl0WnSgmcagO+5OIy+9k7md/gyHo8jWwRH
         qZ6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747996508; x=1748601308;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gm1y3HjSbfjetP2qj6SkQ/PvAerOiP935sq/jHQIUpg=;
        b=GVjTbMWTw9Gl4thoS7CkObwu6DBVuITkuOebcG8XC27mBtIdcBBxL8jMfknMI6IQqe
         PCwAM6GWZmM/s+J+6JMbnCCYwbvqJP6MtJ96uE38iGCjcis4YrRcYNYBApKf6z8UnBvY
         M+GifUXwUv1SJaLniTNUWKqGYCYVyFAgULPnJEsY93tAQTndmaspGyzwP/NR88ZtW3wP
         nzvhEqXM9qXQQEgznvKhMm2dadZraiM0vSK+oEoo+aarEjvg6A+Srxxv7Nt91si+/64B
         J/Vrw10ugTF17bJRlxx0jR55APFmPpbvJ4QfQ9gxL+7Xy6i202ek9vjOFQT4JU6ol0Cq
         MG8Q==
X-Gm-Message-State: AOJu0YwGMTIFSfMrT3w0lWAXJIHNVvQFJqbos9rOlGj2AGCxZ4qz2jkH
	9vdM5ry5vddb+nQFC1c5iSUBNiikoa+RRqs4dWWI+fSFrBc+WAOHqMDzq1HyUDCKO8QQoQlRQjD
	5MJqK5IqobG7kDLVJiu2UTgqa+WVfwQnzunogEg==
X-Gm-Gg: ASbGnctgboi8dvExEBdacB7UNKkc/Sp83Dg+3VR9INh5a11Oz9dp2oU1Xuo7b4uySff
	+1ZV86E9J6JXs9gs5rFxo9l+DulslnUf+VP9KC9HaJgKaZGIwt/YWJfSsXgIJXAVMTeOH0Htzq3
	x1+a40OXWaPGf2cOGrisnQYYZEPsa/rjMXwfFt2Zt4iZEG
X-Google-Smtp-Source: AGHT+IFPIDH297VeawC3C2+CX9sK1etlvRbBDPTndDcCDQlNs0okngJmOGnfQRXCFlAK9re26Ojgp1lHU3FzGvonfUg=
X-Received: by 2002:a17:907:2d24:b0:ad5:a29c:fda1 with SMTP id
 a640c23a62f3a-ad5a29cfebbmr1118458666b.46.1747996507901; Fri, 23 May 2025
 03:35:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <a1c2c88e53c3fe96978f23d50c6bc66c2c79c337.1747991070.git.asml.silence@gmail.com>
In-Reply-To: <a1c2c88e53c3fe96978f23d50c6bc66c2c79c337.1747991070.git.asml.silence@gmail.com>
From: Anuj gupta <anuj1072538@gmail.com>
Date: Fri, 23 May 2025 16:04:30 +0530
X-Gm-Features: AX0GCFtz_TauBXMbJbY8VS9JDvbd18q8yMr2B-XEDUf94kcBNlIfm1mqu7u5pnM
Message-ID: <CACzX3AsZ_omma5kqdjt3LZk0G2qAdQt_Dc4em2VSqKRRMqbOSA@mail.gmail.com>
Subject: Re: [PATCH 1/1] io_uring/cmd: warn on reg buf imports by ineligible cmds
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Reviewed-by: Anuj Gupta <anuj20.g@samsung.com>

