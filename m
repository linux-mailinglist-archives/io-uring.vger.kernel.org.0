Return-Path: <io-uring+bounces-2159-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B1F879035C3
	for <lists+io-uring@lfdr.de>; Tue, 11 Jun 2024 10:21:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4D704288D05
	for <lists+io-uring@lfdr.de>; Tue, 11 Jun 2024 08:21:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DBAC75B1E0;
	Tue, 11 Jun 2024 08:20:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="kI3jT0P2"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-yb1-f182.google.com (mail-yb1-f182.google.com [209.85.219.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 213E8172799
	for <io-uring@vger.kernel.org>; Tue, 11 Jun 2024 08:20:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718094058; cv=none; b=OH3OyS0z4GpCh/NVJ/iio8ApkDCs47vgFR+xkqYBfutNfP2z99vO7jU+zf0s9S7CBFt0ExhnYgah++1ceNXsEado9hsfy9C5Tgk/2niXUyAsItDmVIe+0f++bS03Ag/v/VKfRG+n2qib3Kbqg92YW5eYzwG/y2dItubp8f3vNfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718094058; c=relaxed/simple;
	bh=vO3JurHnqRom7JH3aovwHNNB21erWLhlHlVhgVC7CNo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=duQKKspB21mTQKIY/wcjsO96qqcYRzWcybaDhHSDy9Fd/jePpRAz3dbCCx+J7b8cTAwmnSLPyT8KTz1x6B7bMbu+KC5mztpeLZqrtwxwhTIQXtONwYhU/B2iHGKFN9pUJcGLdsuX7s3B80Mj1f+zBt+B8gBS3qtukm4Xi2Z1V6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=kI3jT0P2; arc=none smtp.client-ip=209.85.219.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Received: by mail-yb1-f182.google.com with SMTP id 3f1490d57ef6-dfaf47d3d9fso4334744276.0
        for <io-uring@vger.kernel.org>; Tue, 11 Jun 2024 01:20:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1718094055; x=1718698855; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=TsjHdLyVH+/QRYOQgnmFiCH9v5EDjsTLPrAqffUv+uc=;
        b=kI3jT0P2KoEAKR0OFfxgrm+lSJa8fnnG9jygTm0WYzgi41Ocy9RAZGAI21u8Nj03WX
         0VIPhNcO4DzsbYm4xxzUe07ZGzCkDwDIWLTJYsowhKcNK15V3A8gSNTlbuig3zwiU3Kq
         DUeja4q9KY1HJkwORhh18PB+mWu2Vqf4mUvXI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718094055; x=1718698855;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TsjHdLyVH+/QRYOQgnmFiCH9v5EDjsTLPrAqffUv+uc=;
        b=JU1frXfuLcUs8G5jFHw2BTs46iTY609KSvO6OhOoRak56eVsalAxWtd2z6hoyfmDUY
         GLVLlx70uCNbfEveboiv5UWnIXz+8KI3JsFSgN/OFdht0hK/3NuhUdaiBNdZFBMcwDdH
         ZrnaiaSD2LX7TVAGVRldMbMD7CyTiWld3rC2JztYMaPfyTuxGkqWQj+Y9uwCOVYf1VWO
         QZSnQXnxaFpOujjLEUHjOZqyZ5qXXQ0ojEjhDHgTMoJ5+89+qLNs+hF0A1WZJa7XnJ35
         43jyICSD853Ej1mAkaIK91bsgEnbK7/f1VmHoPDCVSDWwPAw3V23waL1K4XUeKBkFwgM
         Xz2Q==
X-Forwarded-Encrypted: i=1; AJvYcCWaD/G7i82/LnQRAYgX1vovNwt18pAFEhhu5FgMl4Ne7YlKwSKljfhG5pbpKCR6qHTKq3pNR949uNbh02HcRpngx90+vxo1D/0=
X-Gm-Message-State: AOJu0Yy3+q4UOQI/Qw5WiF2CwgipqsWp2GPTgOaHxjvwWpC09U32VI8M
	3ZMr2aLITX15fDYKkJIH3UEHVu2Oju0FR/XrEwHc38j4THnwelEPaLvtUm6joRztmcHCAYLkMxN
	51tj/DctivXWaE0JwLK4ohD+HN8JmUYgmcEx/IA==
X-Google-Smtp-Source: AGHT+IGV43mp6SccLEJHmFQqXVggcZgGWtTaNQ77TCVt0LJrCuabfnXvVEhVcOdoMIPnLgFfeGrshI120aFHrmTB4yk=
X-Received: by 2002:a25:ce11:0:b0:dfa:fff4:8ef5 with SMTP id
 3f1490d57ef6-dfafff492e6mr9926637276.48.1718094054913; Tue, 11 Jun 2024
 01:20:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240529-fuse-uring-for-6-9-rfc2-out-v1-0-d149476b1d65@ddn.com>
In-Reply-To: <20240529-fuse-uring-for-6-9-rfc2-out-v1-0-d149476b1d65@ddn.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 11 Jun 2024 10:20:42 +0200
Message-ID: <CAJfpegurSNV3Tw1oKWL1DgnR-tST-JxSAxvTuK2jirm+L-odeQ@mail.gmail.com>
Subject: Re: [PATCH RFC v2 00/19] fuse: fuse-over-io-uring
To: Bernd Schubert <bschubert@ddn.com>
Cc: Amir Goldstein <amir73il@gmail.com>, linux-fsdevel@vger.kernel.org, 
	bernd.schubert@fastmail.fm, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
	Andrei Vagin <avagin@google.com>, io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Wed, 29 May 2024 at 20:01, Bernd Schubert <bschubert@ddn.com> wrote:
>
> From: Bernd Schubert <bschubert@ddn.com>
>
> This adds support for uring communication between kernel and
> userspace daemon using opcode the IORING_OP_URING_CMD. The basic
> appraoch was taken from ublk.  The patches are in RFC state,
> some major changes are still to be expected.

Thank you very much for tackling this.  I think this is an important
feature and one that could potentially have a significant effect on
fuse performance, which is something many people would love to see.

I'm thinking about the architecture and there are some questions:

Have you tried just plain IORING_OP_READV / IORING_OP_WRITEV?  That's
would just be the async part, without the mapped buffer.  I suspect
most of the performance advantage comes from this and the per-CPU
queue, not from the mapped buffer, yet most of the complexity seems to
be related to the mapped buffer.

Maybe there's an advantage in using an atomic op for WRITEV + READV,
but I'm not quite seeing it yet, since there's no syscall overhead for
separate ops.

What's the reason for separate async and sync request queues?

> Avoiding cache line bouncing / numa systems was discussed
> between Amir and Miklos before and Miklos had posted
> part of the private discussion here
> https://lore.kernel.org/linux-fsdevel/CAJfpegtL3NXPNgK1kuJR8kLu3WkVC_ErBPRfToLEiA_0=w3=hA@mail.gmail.com/
>
> This cache line bouncing should be addressed by these patches
> as well.

Why do you think this is solved?

> I had also noticed waitq wake-up latencies in fuse before
> https://lore.kernel.org/lkml/9326bb76-680f-05f6-6f78-df6170afaa2c@fastmail.fm/T/
>
> This spinning approach helped with performance (>40% improvement
> for file creates), but due to random server side thread/core utilization
> spinning cannot be well controlled in /dev/fuse mode.
> With fuse-over-io-uring requests are handled on the same core
> (sync requests) or on core+1 (large async requests) and performance
> improvements are achieved without spinning.

I feel this should be a scheduler decision, but the selecting the
queue needs to be based on that decision.  Maybe the scheduler people
can help out with this.

Thanks,
Miklos

