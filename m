Return-Path: <io-uring+bounces-123-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id EF6D07F334C
	for <lists+io-uring@lfdr.de>; Tue, 21 Nov 2023 17:11:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8FAE6B21D70
	for <lists+io-uring@lfdr.de>; Tue, 21 Nov 2023 16:11:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D8EA5917A;
	Tue, 21 Nov 2023 16:11:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="i4Zwg5oV"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-x22a.google.com (mail-oi1-x22a.google.com [IPv6:2607:f8b0:4864:20::22a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B15C3CB;
	Tue, 21 Nov 2023 08:10:57 -0800 (PST)
Received: by mail-oi1-x22a.google.com with SMTP id 5614622812f47-3b837d974ecso331195b6e.2;
        Tue, 21 Nov 2023 08:10:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1700583057; x=1701187857; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=y7pnqI74NKLkaXfyd8GQP0kyMyA4yNmTqJMM3pVvHaM=;
        b=i4Zwg5oVJh2qf5b3g5CCwdkrGU21PECnkDQxHy2VoApP9NEMaLyDz7csVPcGBjd2CD
         hdA2drpAGkYbncNMdcrbu1k54O4+9Ra8jAiyygU0Y9yhjH69OZkfANciHuYD9Ftz91Av
         NWmBeaxSVAG6uddAgWmDjtINOP/DtUnlmLckqebi1N5k+4SnxZ+j59O1iORiYNWU6ncO
         MhXQ62wzOiXNo64fPOTg1n1N7HQTb6jzph2FEPCbBHWoMvQ74mtO+aSN33kXroProfOH
         goPWN9dKgPH2CzFvqPouUzUca5orbqVniOCtIwzdk/htFtdcgqYX6RLUdlhCnAytvvlj
         +fwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700583057; x=1701187857;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=y7pnqI74NKLkaXfyd8GQP0kyMyA4yNmTqJMM3pVvHaM=;
        b=UHNowg0WSEzm6Op3HdFR2iAtdLW42qrPmj2qZ4/zNpXFD5MdF0BRajKl5ipTyjeuez
         07vtBtB/I7MyRDKawkOTFsojkB9PqZ1RJLjJbNXAnPkqgnlRE6tToqw1rLjxjmAUjW3E
         7l29DxfbbNZLF/hY3YmxZLfBqRFwzNEzUQnmEFZDgKDewVstCJdpnt+FnUeCj+pnL4Kk
         sd4NLXR4VT5J7pQRnXV2pWUtEGDrBRBpRDSVgAmzlkC600I1NQuKiC7d/fG4blgooLhF
         cf0v/4L/ZMFAK9JE8C/lMqbn+tVDeWOXXjzzbxBd7iNuoOldCg0oodq5hUGjApX07ELG
         Jasw==
X-Gm-Message-State: AOJu0YwDco8TZ2L5hqYB0mhORsSXMHMHzzjYcdRz6Hb7G2SCR9jPbs7r
	2dz5ew6ODbF7Ik1e5IgUQJTVD97m3KgM0lEBtQ==
X-Google-Smtp-Source: AGHT+IFiRaCf/Q+x81UKnU4Wpey3wIOZJlFvG9RRGz5EHrrlf7aahHCnKG4nyEynHxf6qjGLknAONjzHifddupR97R0=
X-Received: by 2002:a05:6359:d23:b0:16b:b8b1:f684 with SMTP id
 gp35-20020a0563590d2300b0016bb8b1f684mr9672260rwb.22.1700583056876; Tue, 21
 Nov 2023 08:10:56 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231120224058.2750705-1-kbusch@meta.com> <20231120224058.2750705-3-kbusch@meta.com>
In-Reply-To: <20231120224058.2750705-3-kbusch@meta.com>
From: Anuj gupta <anuj1072538@gmail.com>
Date: Tue, 21 Nov 2023 21:40:20 +0530
Message-ID: <CACzX3AvO2GSvwagd=PkxsG3uiKgT4vpiMzYA1RJOjEMQD=yN6A@mail.gmail.com>
Subject: Re: [PATCHv3 2/5] block: bio-integrity: directly map user buffers
To: Keith Busch <kbusch@meta.com>
Cc: linux-block@vger.kernel.org, linux-nvme@lists.infradead.org, 
	io-uring@vger.kernel.org, axboe@kernel.dk, hch@lst.de, joshi.k@samsung.com, 
	martin.petersen@oracle.com, Keith Busch <kbusch@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 21, 2023 at 4:11=E2=80=AFAM Keith Busch <kbusch@meta.com> wrote=
:
>
> From: Keith Busch <kbusch@kernel.org>
>
> Passthrough commands that utilize metadata currently bounce the user
> space buffer through the kernel. Add support for mapping user space
> directly so that we can avoid this costly overhead. This is similiar to

Nit: s/similiar/similar

 >  /**
>   * bio_integrity_free - Free bio integrity payload
>   * @bio:       bio containing bip to be freed
> @@ -105,6 +136,8 @@ void bio_integrity_free(struct bio *bio)
>
>         if (bip->bip_flags & BIP_BLOCK_INTEGRITY)
>                 kfree(bvec_virt(bip->bip_vec));
> +       else if (bip->bip_flags & BIP_INTEGRITY_USER)
> +               bio_integrity_unmap_user(bip);;

Nit: extra semicolon here

--
Anuj Gupta

