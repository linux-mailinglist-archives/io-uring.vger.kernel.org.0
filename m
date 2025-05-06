Return-Path: <io-uring+bounces-7865-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CBCC2AAC812
	for <lists+io-uring@lfdr.de>; Tue,  6 May 2025 16:34:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E9C863BC26D
	for <lists+io-uring@lfdr.de>; Tue,  6 May 2025 14:34:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D37B18D656;
	Tue,  6 May 2025 14:34:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PugnSh8e"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BEF31862;
	Tue,  6 May 2025 14:34:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746542059; cv=none; b=EJcLZRKppjJmToqgReoIN4Kd5scNC4wyGUfJ6HzT5LV1hMYmH3Rbd1wjpkb2E87MWgyL+ps8o9yL6po4Cb08313Xvf80AzUpOlikW+Ryfr6d6i5HaxmINBs2QSLsSl6cApdjX9+TR6eSOq1bpWw30Yx/xncnftm5z3/WhyT81v8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746542059; c=relaxed/simple;
	bh=LHaPPpwPca6kcj5NTuDFy2qHBqEn3ONm9X4gAbWeSgM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=N6JumF1oHcUughs3HLvPEr382vj21Dn2Bn45j0P1VMjkGnWqLtF3r6gxWRuhoWPm2FemGnhrqqMRMR0klgN5NzbJXAqV5uThdDrHBabjhDAEdAJOohRFjafFBbJq/vWuIpKryuHzQTslsScwXNREVf1Tv/Jvbzhb45oLVPcMPaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PugnSh8e; arc=none smtp.client-ip=209.85.160.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-476a304a8edso70315741cf.3;
        Tue, 06 May 2025 07:34:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746542057; x=1747146857; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=StuB9y+BMojZ5vD2oKAZyZwlKbmEBqnfY2yebCn+Als=;
        b=PugnSh8ewiQBcoksicYEIx9uEf7sHyJ1aXPvwE7SOEkKbuHJst5b1Mcrfpfv4dEr8n
         KtnPsekr+i3IrX7ajlv+ngka6LCU88hsqDXXFLncQFIpJgbIVobj4quQFIqXDB9G8TYe
         9uqIzxp2DluGmCJzKQkPXioL8bSRt7UKl4BnhVw80XWoYqAjKNQCdcIsD+dlDHhUv4fK
         N6N5lDkBUCLlLa/2/JRdotQoMwizNtDa+s6xwQLnylyhtOjS+GLzmuHHCcncoU88S1EL
         8AX2mynviU6FGZx9eWv/ftyxT3+wi4jJdtd8WrskzICNlLkzv7GWL+w7M+uZyM7X9tJy
         x1hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746542057; x=1747146857;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=StuB9y+BMojZ5vD2oKAZyZwlKbmEBqnfY2yebCn+Als=;
        b=AbbE6+KHrh5tiFL9h8baEOMhAHnQ1KMoa3EK97QnRF1zv6d3hrsXHXCg0jUs2j0Pn4
         FXqKSm/fTfOzISm0S960AGdr+vmunR9QRYoDg2qehu8LQ+VATLj/UaR3IPJu7vXFiGlg
         PfW8wtW/3jr8ikd2NkFTcyhQtRtVGDhAmyeaW5HojIrPdsLnm2bDNqif71IFAXpdkL56
         6qJM2GPL1y2X1QiUFyF/VIlmZQHxId1It5ceKsyQT0zFIrj7ciR9ayF3x6UoRA7d8npn
         gWY9W8yBc+JDKXOrMpxyAqylSWE3259HqtUbVN5I/bEYdEA3ijY5Jx5KGF927ewLZo2t
         Inmg==
X-Forwarded-Encrypted: i=1; AJvYcCWapWOiFnnYdtR9Ypx/nZyLwsAt1mepz1rRm12QzpTQHuX8pH8pMjvsoSk8seD82x9vLvckFG8=@vger.kernel.org
X-Gm-Message-State: AOJu0YzilHcSI/T2Wfahc7ngHA1TACmod+h8BzT+T/ZgHtCkAjBkL8ub
	lJG7Jd9i0ebVwd/suWpGlw/eDOGlSFKPhU4d2vQaCUX20LzmKTWTIQWCqtvOnnL/INz4I/laSqR
	OvRZWRBXPubTPCiyA6IkvNJ1nG6I=
X-Gm-Gg: ASbGncu1EzESvODPJQZA1H/kARGwYj7doSmC5d+vtc3/31aBGHX1nBnVB7UV62gjPvH
	GoDpjC+oAHOUDboXKWJC0p7bOoYaQblXXq5I0AVyGlY0/pw9bSIPsAxWva3r+JYkSUIuyEA5XF+
	2xvNu0A7vOJ0oxMJlqhRS1hf0MHlea19A=
X-Google-Smtp-Source: AGHT+IHtr6ibI5qatfCXKLwwmfLr6Qne/aSffQUrP0zvR9uPdOQ7tTGSzG9ulDYSVkUq8zzGWsDVbg0WFje76C/bDVM=
X-Received: by 2002:a05:622a:580b:b0:476:b02d:2b4a with SMTP id
 d75a77b69052e-4910ca57e5fmr50336411cf.27.1746542056992; Tue, 06 May 2025
 07:34:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1746097431.git.asml.silence@gmail.com>
In-Reply-To: <cover.1746097431.git.asml.silence@gmail.com>
From: Alexey Charkov <alchark@gmail.com>
Date: Tue, 6 May 2025 18:34:06 +0400
X-Gm-Features: ATxdqUEPdSxTv8cThP_o2Pc53GH7dN6KGGj3rg-UQL_ryuYNnVzqSRrhJFCF1M0
Message-ID: <CABjd4YzAJqvLiNid7RoVpLospTrAFzrBpTcFHuem2-JxfkzpmA@mail.gmail.com>
Subject: Re: [PATCH io_uring 0/5] Add dmabuf support for io_uring zcrx
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: io-uring@vger.kernel.org, David Wei <dw@davidwei.uk>, netdev@vger.kernel.org, 
	Jamal Hadi Salim <jhs@mojatatu.com>, Pedro Tammela <pctammela@mojatatu.com>, 
	Victor Nogueira <victor@mojatatu.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, May 6, 2025 at 6:29=E2=80=AFPM Pavel Begunkov <asml.silence@gmail.c=
om> wrote:
>
> Currently, io_uring zcrx uses regular user pages to populate the
> area for page pools, this series allows the user to pass a dmabuf
> instead.
>
> Patches 1-4 are preparatory and do code shuffling. All dmabuf
> touching changes are in the last patch. A basic example can be
> found at:
>
> https://github.com/isilence/liburing/tree/zcrx-dmabuf
> https://github.com/isilence/liburing.git zcrx-dmabuf
>
> Pavel Begunkov (5):
>   io_uring/zcrx: improve area validation
>   io_uring/zcrx: resolve netdev before area creation
>   io_uring/zcrx: split out memory holders from area
>   io_uring/zcrx: split common area map/unmap parts
>   io_uring/zcrx: dmabuf backed zerocopy receive
>
>  include/uapi/linux/io_uring.h |   6 +-
>  io_uring/rsrc.c               |  27 ++--
>  io_uring/rsrc.h               |   2 +-
>  io_uring/zcrx.c               | 260 +++++++++++++++++++++++++++-------
>  io_uring/zcrx.h               |  18 ++-
>  5 files changed, 248 insertions(+), 65 deletions(-)

Hi Pavel,

Looks like another "depends" line might be needed in io_uring/Kconfig:

diff --git a/io_uring/Kconfig b/io_uring/Kconfig
index 4b949c42c0bf..9fa2cf502940 100644
--- a/io_uring/Kconfig
+++ b/io_uring/Kconfig
@@ -9,3 +9,4 @@ config IO_URING_ZCRX
        depends on PAGE_POOL
        depends on INET
        depends on NET_RX_BUSY_POLL
+       depends on DMA_SHARED_BUFFER

Otherwise I'm having trouble compiling the next-20250506 kernel for
VT8500, which doesn't select DMA_BUF by default. The following linking
error appears at the very end:

armv7a-unknown-linux-gnueabihf-ld: io_uring/zcrx.o: in function
`io_release_dmabuf':
zcrx.c:(.text+0x1c): undefined reference to `dma_buf_unmap_attachment_unloc=
ked'
armv7a-unknown-linux-gnueabihf-ld: zcrx.c:(.text+0x30): undefined
reference to `dma_buf_detach'
armv7a-unknown-linux-gnueabihf-ld: zcrx.c:(.text+0x40): undefined
reference to `dma_buf_put'
armv7a-unknown-linux-gnueabihf-ld: io_uring/zcrx.o: in function
`io_register_zcrx_ifq':
zcrx.c:(.text+0x15cc): undefined reference to `dma_buf_get'
armv7a-unknown-linux-gnueabihf-ld: zcrx.c:(.text+0x15e8): undefined
reference to `dma_buf_attach'
armv7a-unknown-linux-gnueabihf-ld: zcrx.c:(.text+0x1604): undefined
reference to `dma_buf_map_attachment_unlocked'
make[2]: *** [scripts/Makefile.vmlinux:91: vmlinux] Error 1
make[1]: *** [/home/alchark/linux/Makefile:1242: vmlinux] Error 2
make: *** [Makefile:248: __sub-make] Error 2

Best regards,
Alexey

