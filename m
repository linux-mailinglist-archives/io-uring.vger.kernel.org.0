Return-Path: <io-uring+bounces-9748-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 68482B5332F
	for <lists+io-uring@lfdr.de>; Thu, 11 Sep 2025 15:07:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 186425A244A
	for <lists+io-uring@lfdr.de>; Thu, 11 Sep 2025 13:07:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 44CC4322A08;
	Thu, 11 Sep 2025 13:07:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LUpoGIrJ"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82407320CC7
	for <io-uring@vger.kernel.org>; Thu, 11 Sep 2025 13:07:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757596065; cv=none; b=gEdr6/2KhhgBdEkm/o0igFhytbjmB1kiiNSLkAd2IFvu2O9Ijvn+r/6IblH+GQx151Y/dhZx3ail1Chs+8foLViYcFkYMiRTpPXc3qgEfPsgQUlU94fUVD0KFlQzFVQKf25yybJ3cE3gjuDbZVxuH24gzOK4XkRBf62TZuBeVj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757596065; c=relaxed/simple;
	bh=vuK6Je+YmVc6nSK3SNmpMj3REIhAMtRNKfHQcYZTUp0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CoUsmjN4guofljQHuSkyJaD5j5JPbpJBE/YtdYbgnb4WhTFe72f3fwMJ505TDgkNglbI20s6AmeuK/M9H6US3gVCbBO9UM+i8BMoKRAhTAvy5/0zIrlNwl8ngFu3dnsXlZ8AXxjpsqPZyBs9TO4yDDncr+3bM0Li6+ZaZQn9wS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LUpoGIrJ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757596062;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vuK6Je+YmVc6nSK3SNmpMj3REIhAMtRNKfHQcYZTUp0=;
	b=LUpoGIrJSBZeRi4c0qm2+o0lWIdddgyeEFU1SlKeeX0GrmvBbzxe6gw1eoA/PFrMLnJRX0
	qcpNLNvZu+Boc6cN53BHne/tRpz7nu92a4FsFlgYlQg1O4Jjz9sKx0wRdX6IzVyjA1oSsX
	sxM59M9HN3/UIbtLsXDex7Nn5mNtMLI=
Received: from mail-vk1-f197.google.com (mail-vk1-f197.google.com
 [209.85.221.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-450-ZYa0gShHOs23Vc_kaIbSBg-1; Thu, 11 Sep 2025 09:07:41 -0400
X-MC-Unique: ZYa0gShHOs23Vc_kaIbSBg-1
X-Mimecast-MFC-AGG-ID: ZYa0gShHOs23Vc_kaIbSBg_1757596060
Received: by mail-vk1-f197.google.com with SMTP id 71dfb90a1353d-549ec3ae677so872208e0c.1
        for <io-uring@vger.kernel.org>; Thu, 11 Sep 2025 06:07:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757596060; x=1758200860;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vuK6Je+YmVc6nSK3SNmpMj3REIhAMtRNKfHQcYZTUp0=;
        b=cPy8J1/npMAtDQEHm3YkBMHwX/l6ehcI8il8lLRd/LRF8RYo54HXN0otTsQAsovLZt
         vNpaYBle85J89Uv/xPyHU003MDhl7q0ovzYFhAUBfD1hlSSTzlMzHc/y97uzNyCjju1B
         STpOQ8wGJFjAOkiVHrRaepNKhYbnkqy7z2gTA6OKpDbaHj8NA4bsozCF8qhU2rIFsNzQ
         mEAeAj5YDx2eWeyiXWpUBBt6Lds2fKuiNTctgKznp0xNMFWV6QB+ZkDGpgAeKKpBA5oY
         pw4i/79TMs5fLEgMXrrW6v2FQbrDuq2GmrFl5eZpiH/6dvUPeCB6cF2ww97GFdolCvJ4
         HZ8A==
X-Forwarded-Encrypted: i=1; AJvYcCW+h5j3uCTK4PY5OA6B0n+J4wg+Hkb7SXaWGHp9bWH8Gz+osarEKiWaNpAgqm7AIkBOpoTLl7Jfdw==@vger.kernel.org
X-Gm-Message-State: AOJu0Ywg1cXp+1StLURu935G066K07oSCRzdxo9YYDXabxVrPpJWWzIR
	Z3Jvkt7aN+CXOtQ8FCVJcKDcnob/RokZIfu3pPS3k1UVSTtZLOMBA8y1v+YLdsSuugjCKap2Fi3
	wVmE8HZBquJGL9Ro6BzdzSELU7hWgMhnlg4Y1/8wTT172Rw1p3quXXdpp03q/W7+CF8YQBT1z6w
	1rrYKCBTg3hInhZaxRmUT1qNkVMtPnfT5Xm3E=
X-Gm-Gg: ASbGncvT1nRCLV/gr5G1vCxCysIUPZCyyv97eDqOemExeXMHOWRgqPvIBoyjXa5auyF
	aG6Gtj91dPYYwpR9huOuWf18FKJ8HH+w/oI0QIeTgpiOc9cDVv8lmzg7mlYzul/QoyeQSJm7Jsm
	39USnoIMXxQ0STpyRu0glPYA==
X-Received: by 2002:a05:6122:1d9e:b0:541:baf7:bbe9 with SMTP id 71dfb90a1353d-5473c3ce0ebmr7052255e0c.11.1757596060408;
        Thu, 11 Sep 2025 06:07:40 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGw15QkztOudGtD2w0FFnEFzcPSaI4KwntTIE8fJ5u1B5t3y1ngGb1yxMlk8/I6z048bbf5Poh3pLUS+a0iD9U=
X-Received: by 2002:a05:6122:1d9e:b0:541:baf7:bbe9 with SMTP id
 71dfb90a1353d-5473c3ce0ebmr7052213e0c.11.1757596060005; Thu, 11 Sep 2025
 06:07:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250904192716.3064736-1-kbusch@meta.com> <20250904192716.3064736-3-kbusch@meta.com>
 <CADUfDZrmuJyqkBx7-8qcqKCsCJDnKTUYMk4L7aCOTJGSeMzq6g@mail.gmail.com>
 <8cb8a77e-0b11-44ba-8207-05a53dbb8b9b@kernel.dk> <aMIv4zFIJVj-dza5@fedora>
 <aMIxmiGv5D0GvSro@fedora> <aMLIU19CfgOAuo8i@kbusch-mbp>
In-Reply-To: <aMLIU19CfgOAuo8i@kbusch-mbp>
From: Ming Lei <ming.lei@redhat.com>
Date: Thu, 11 Sep 2025 21:07:28 +0800
X-Gm-Features: AS18NWCp0P3QaQVNejMUKpP4wQ1K468o3W17j5DQmN8AsqXibRuiJ9daKVftoJk
Message-ID: <CAFj5m9Kbg_S_rES1BXRXpaGGnatiEmwEsN+-f4t6zGUH79LPCg@mail.gmail.com>
Subject: Re: [RFC PATCHv2 1/1] io_uring: add support for IORING_SETUP_SQE_MIXED
To: Keith Busch <kbusch@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Caleb Sander Mateos <csander@purestorage.com>, 
	Keith Busch <kbusch@meta.com>, io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 11, 2025 at 9:02=E2=80=AFPM Keith Busch <kbusch@kernel.org> wro=
te:
>
> On Thu, Sep 11, 2025 at 10:19:06AM +0800, Ming Lei wrote:
> > On Thu, Sep 11, 2025 at 10:11:47AM +0800, Ming Lei wrote:
> > > SQE128 is used for uring_cmd only, so it could be one uring_cmd
> > > private flag. However, the implementation may be ugly and fragile.
> >
> > Or in case of IORING_SETUP_SQE_MIXED, IORING_OP_URING_CMD is always int=
erpreted
> > as plain 64bit SQE, also add IORING_OP_URING_CMD128 for SQE128 only.
>
> Maybe that's good enough, but I was looking for more flexibility to have
> big SQEs for read/write too. Not that I have a strong use case for it
> now, but in hindsight, that's where "io_uring_attr_pi" should have been
> placed instead of outide the submission queue.

Then you can add READ128/WRITE128...

Thanks,


