Return-Path: <io-uring+bounces-7874-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 18351AACBC6
	for <lists+io-uring@lfdr.de>; Tue,  6 May 2025 19:02:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C3D1D4E23D8
	for <lists+io-uring@lfdr.de>; Tue,  6 May 2025 16:59:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D07B284688;
	Tue,  6 May 2025 16:59:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FhgXTJ7M"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 730F1285409
	for <io-uring@vger.kernel.org>; Tue,  6 May 2025 16:59:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746550754; cv=none; b=iNOZI2KZ/+Ykh+yZJkIcWzA5oDwsvbLHunis7Ns6YxTKey9j5nBtHkvco/1LEwuOlfBxeV1n3YHeAMZkx/LBuX3MFq33lpQpNW+kwzlVKk9SLpm0F5aljlgj4JbZk1drRZ/qdjw6M2T+stTrU9Kzs6GtECtFaA5D977Iz4NqWAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746550754; c=relaxed/simple;
	bh=H6JR/Mm0mEFBDu/7Ip86fI2Pri0aszEKMd4LwSC3i+8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=X9Gx/eRCerfoSYFwDiM+Va7acOcVRp8IhnHAaF+lck+/NjLfP1JxTY4r+CeRpUtshX4/ZEf2OxFx4Vb+MS0fRZnV4M0PbVEDNXz7jU2KbZezERsQ88+iCm02KUEVms6zNWeqBZXE+w3ugLzCQpoixq6JO/BsP3v9lJa57yvKRAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FhgXTJ7M; arc=none smtp.client-ip=209.85.160.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-477296dce8dso69163061cf.3
        for <io-uring@vger.kernel.org>; Tue, 06 May 2025 09:59:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746550751; x=1747155551; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QoqIvS5Bzy6Oo8AwXf1abQ+tdHS+SHHQ3iRGjLWXkYg=;
        b=FhgXTJ7MYwJ/pvkZxNDy8db2DI4qgkUL5hgbhUdZV3yWiGc/b5shenoWgKz9kGZOGR
         UI4itouNKgFf5xpmW5lUPpbfAew6r0dGRI3YU5jksglcoMlSxUr8mbaFfEX67YGSWB+d
         gICUKpNWN82xN9+bfhdVzd9YjpP8+s59lIJkfAOJVNSrcq7Bwkgi+BM/4vKcYGuOpb8d
         IDKRK/FXFmO9KMVrdWGcDRE/Ef2EZETMRqeyeoRhUbj4fRa3vRc43Ub/TTNWwSPb+wOb
         1KJ0bnE3YMztPtyoBW0Cx/87PzaBr757LSl0qsQQVp2gMGMoFL+tHBrMFv3PNuMGxmKr
         tL4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746550751; x=1747155551;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QoqIvS5Bzy6Oo8AwXf1abQ+tdHS+SHHQ3iRGjLWXkYg=;
        b=hrYyyxrAbXDdUswFFER6CWr0E4WmjJVS5dDLUlvvWhrXaux4yDJpARNGyFBHrGmx7K
         CSXMCnIGFbyZfSkXHgCtzBb4SIJlDCFO/gSPP3TQPTxyluk2+QfDOcJ0rAqrUGAwP9iE
         wSJsKE2Ekh8Gt5yf9QGDz/piiGYZrq3kXq7u6+8Oi6j+lmrzahNYMlLbiR+6cD9pofvC
         N7/tlLW0qTAb8KaC4HrPGHnuFIG/ba5apEe5eIkPVrqrHJBq8XeG7ASnKGVJ9i/6CPdd
         W1Ci84uT89b9wH3BhIqOfMTGWQZUslj1AVShCxyl3dhDdf860zzyNALmIK1B0EQYykng
         LjcA==
X-Gm-Message-State: AOJu0YwyEuhIn0MzmPVAOLoomOmwpvXwFDCzyJC7snlcwZ2TwJVYpU/Z
	oovkYibM+DB2G2o2ayV6Cz6fg+9pnvyJo3CNiTKbk6ANibxn3bS9eku/C8JY2zC2icxFjnOVizu
	o+lQKRzO08NiPUGBYCRRuVqszTfe0tJLn6+4=
X-Gm-Gg: ASbGncvgktyQME93xU6Nz5Qc2CNKA6YW1azz7yNyAg8Bd/6X8US+o9rzNm2l9Ie7fM0
	ca+3x33eAJwUYGdfgetJyNtRcIpy7hgYoHtR2kXJTA9Ao9t3F6CS2Zl06vHgCV4UqoJyNJjTyiR
	fDQNGnmZG5bQJJKe5WdQ7q
X-Google-Smtp-Source: AGHT+IFCojf477Hg1XNap42r6BUfpS1OEUXhIe5ugrAhAa/9MTICxGVpXQfeQOIy5XT/4Lsy8ORfWn8rbX3AuYCD6Tw=
X-Received: by 2002:a05:622a:180e:b0:48e:170c:cc63 with SMTP id
 d75a77b69052e-4920c1d4387mr4928601cf.18.1746550751210; Tue, 06 May 2025
 09:59:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <6e37db97303212bbd8955f9501cf99b579f8aece.1746547722.git.asml.silence@gmail.com>
In-Reply-To: <6e37db97303212bbd8955f9501cf99b579f8aece.1746547722.git.asml.silence@gmail.com>
From: Alexey Charkov <alchark@gmail.com>
Date: Tue, 6 May 2025 20:58:59 +0400
X-Gm-Features: ATxdqUE7ENYQqBh7U1L9xcInH3HwVibMf7P-3a-vSMl_Coc8LprUcbVa7a3V8TY
Message-ID: <CABjd4Yz01BWsS=2dnk-81oZLoGxsGGaGZ1yMayTsyx_WjygeAQ@mail.gmail.com>
Subject: Re: [PATCH 1/1] io_uring/zcrx: fix builds without dmabuf
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, May 6, 2025 at 8:07=E2=80=AFPM Pavel Begunkov <asml.silence@gmail.c=
om> wrote:
>
> armv7a-unknown-linux-gnueabihf-ld: io_uring/zcrx.o: in function
> `io_release_dmabuf':
> zcrx.c:(.text+0x1c): undefined reference to `dma_buf_unmap_attachment_unl=
ocked'
> armv7a-unknown-linux-gnueabihf-ld: zcrx.c:(.text+0x30): undefined
> reference to `dma_buf_detach'
> armv7a-unknown-linux-gnueabihf-ld: zcrx.c:(.text+0x40): undefined
> reference to `dma_buf_put'
> armv7a-unknown-linux-gnueabihf-ld: io_uring/zcrx.o: in function
> `io_register_zcrx_ifq':
> zcrx.c:(.text+0x15cc): undefined reference to `dma_buf_get'
> armv7a-unknown-linux-gnueabihf-ld: zcrx.c:(.text+0x15e8): undefined
> reference to `dma_buf_attach'
> armv7a-unknown-linux-gnueabihf-ld: zcrx.c:(.text+0x1604): undefined
> reference to `dma_buf_map_attachment_unlocked'
> make[2]: *** [scripts/Makefile.vmlinux:91: vmlinux] Error 1
> make[1]: *** [/home/alchark/linux/Makefile:1242: vmlinux] Error 2
> make: *** [Makefile:248: __sub-make] Error 2
>
> There are no definitions for dma-buf functions without
> CONFIG_DMA_SHARED_BUFFER, make sure we don't try to link to them
> if dma-bufs are not enabled.
>
> Reported-by: Alexey Charkov <alchark@gmail.com>
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  io_uring/zcrx.c | 8 ++++++++
>  1 file changed, 8 insertions(+)

Just wanted to confirm that this fixes the build in my setup, thanks a
lot Pavel!

Best regards,
Alexey

