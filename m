Return-Path: <io-uring+bounces-8478-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 633CAAE6A18
	for <lists+io-uring@lfdr.de>; Tue, 24 Jun 2025 17:06:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DF79C3AB786
	for <lists+io-uring@lfdr.de>; Tue, 24 Jun 2025 15:03:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 60F932D542A;
	Tue, 24 Jun 2025 15:03:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EJRBYBap"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7D4D2D5439
	for <io-uring@vger.kernel.org>; Tue, 24 Jun 2025 15:02:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750777381; cv=none; b=gHHRPztpQ5E7ey0cqBwC6/IUhT+Obt72lIgvd0gpEb5kh9IJkF1JT9rsdB0dSMEapEp8TuiS/iLoz1wgwxEox8CpL8OLL8NEsn2gZpaK2sYMQnHgmnlrhkuBaCdZGgoP0+v3v+GZeTDYnkRfuU124X2tAAo6DZynRd67gZFmYaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750777381; c=relaxed/simple;
	bh=aZ6d2ww+sAxXhhU8DObEXMjD5Yjx9X+/HeWN0awnxJs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WuQzjOzdy6GoK8eEWha/xPprE6Pd6xNBCW1x3J3x4ho3Jshfk7vfgLA+S+ZPmWaSpSkrHoimqEUr8TUvPnXlV3xmcQwks5SDD3VJbbfN/6ii8IZ2ubuJfhK4o0M7gPKOZEQlEzRS62r5Hl7qUHgZsjNR4Wyw0ugtMWECzRNK+v8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EJRBYBap; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750777378;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=26knUQsm6IfAjeqD8XI9QpiX0JprUBMdNcpaBL6aJPw=;
	b=EJRBYBapxtIcVhJHBiPtNnk2OA8BW1aozUiqUmOoom6yHORD15LimXR9YKINXTOPDD4dpx
	0zC+MLXVMBrfE+lYEeyvIE2pjkTWlzZQDs0s/P3yQuf9wNMzGsauCdzgWcEjlUbA/VrFxn
	n+JEnPipSjY0CiOccRrovvU3LoIGcpo=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-362-nKVYY2jHNeaHD_aJn9C7eA-1; Tue, 24 Jun 2025 11:02:53 -0400
X-MC-Unique: nKVYY2jHNeaHD_aJn9C7eA-1
X-Mimecast-MFC-AGG-ID: nKVYY2jHNeaHD_aJn9C7eA_1750777373
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-311e98ee3fcso4846172a91.0
        for <io-uring@vger.kernel.org>; Tue, 24 Jun 2025 08:02:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750777372; x=1751382172;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=26knUQsm6IfAjeqD8XI9QpiX0JprUBMdNcpaBL6aJPw=;
        b=ZurQPKZPdjeTGNqngYyHWEdum81DkQEuSXME78ttq65rTh/A2ifwQeKD9OeceRQseP
         YDFD1DwoK5Chd+CPwC4hdme+QGRuGoXaehGm0991TjgEavXqR8EUslelt1WioeuCqN6G
         ORZUbiFLO+2K3wXqTsSH/jtccX0K4aj1BiGdRkbOFIr/LXZdMCiz9IamHM3m4EU64qgq
         2FFuRFOwe744GFoRqTvXkgSQWi0oClT4K74OexIjDsNzZMy/xSw4TWTyhOeFA1kw8Niy
         9ITAIWzagUvosJivE3G7iEiWrcSStQd/nDBoUIjmDNJXa1CWOG3Snqxa9GYlPky7jxUC
         H/pQ==
X-Forwarded-Encrypted: i=1; AJvYcCVu4mUd+r4kAPVbctQptKOR5LQS7HVVU4nGiuJ9cM5H7+8ZCkZZMBqpIYHMwX/YS5IzpoD7TRgdag==@vger.kernel.org
X-Gm-Message-State: AOJu0Yxb+FwjhEsk01qpFJpBjhKi/5Fx057uHqL/8gXBEoNqS3wbaMh3
	IB8r7/63IwjGP31SPYbyTnnfPUrDyVImi0fO6mTBJantzSAOL07WgQvo0ugBQnkOxbe5CO/LRne
	wCyqZULiRa3d7S+k+7EDFgrD0SO/PjlgyB89H98GdMxzdulhtCNXm+mD8FNQY9ubdh2ONc5tX0s
	woZ2ycO4tNgjyaNOxiGFrm0AazZT5mK2bPI/159OmN9EBZOQ==
X-Gm-Gg: ASbGncsYT8A93+Wpq4Y2zDZcv2X88QyCENmXR8jnpFxFYqfXAIANF1k3CrYxMtHQlgm
	/xVBct1mDa/CW+xFHJhBEwpjwy9IPogIxPlWJLZPUEH9VoRJTkiBmtbnOYm3WMgqPFc8UO6yYPC
	lVDF35
X-Received: by 2002:a17:90b:2e07:b0:30e:3737:7c87 with SMTP id 98e67ed59e1d1-315ccc94eabmr5231071a91.5.1750777371794;
        Tue, 24 Jun 2025 08:02:51 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHUoxnJOmDWOiFN6+y0j0WjolvSI3k0vnLz5GanKeKUeNgZzu6/9x1t8stmhncEliSTG7rQEkKF9/x2jTX0AqA=
X-Received: by 2002:a17:90b:2e07:b0:30e:3737:7c87 with SMTP id
 98e67ed59e1d1-315ccc94eabmr5230998a91.5.1750777371158; Tue, 24 Jun 2025
 08:02:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAGVVp+UFKKb4ydw1+zWX9Bre6vt9TUFt9FY2qOx0LMv+8VaVoA@mail.gmail.com>
 <aFpb3BjH4T8q8KAY@fedora>
In-Reply-To: <aFpb3BjH4T8q8KAY@fedora>
From: Changhui Zhong <czhong@redhat.com>
Date: Tue, 24 Jun 2025 23:02:39 +0800
X-Gm-Features: Ac12FXwnHZkJcRl6FvYU6yXk_BvQss7qEWIOp8lSPnfnln_4oRxx-uvcIcMYZG8
Message-ID: <CAGVVp+VNFCUt68A1-P+Rx85kKJpVioJt7U-=hKyw6ji7_5OzZA@mail.gmail.com>
Subject: Re: [bug report] WARNING: CPU: 3 PID: 175811 at io_uring/io_uring.c:2921
 io_ring_exit_work+0x155/0x288
To: Ming Lei <ming.lei@redhat.com>
Cc: Linux Block Devices <linux-block@vger.kernel.org>, io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 24, 2025 at 4:03=E2=80=AFPM Ming Lei <ming.lei@redhat.com> wrot=
e:
>
> On Tue, Jun 24, 2025 at 01:37:55PM +0800, Changhui Zhong wrote:
> > Hello,
> >
> > the following warnning info was triggered by ubdsrv  generic/004 tests,
> > please help check and let me know if you need any info/test, thanks.
> >
> > repo: https://github.com/torvalds/linux.git
> > branch: master
> > INFO: HEAD of cloned kernel
> > commit 86731a2a651e58953fc949573895f2fa6d456841
> > Author: Linus Torvalds <torvalds@linux-foundation.org>
> > Date:   Sun Jun 22 13:30:08 2025 -0700
> >
> >     Linux 6.16-rc3
> >
> >
> > reproducer:
> > # echo 0 > /proc/sys/kernel/io_uring_disabled
> > # modprobe ublk_drv
> > # for i in {0..30};do make test T=3Dgeneric; done
>
> Hi Changhui,
>
> Please try the fix for your yesterday's report:
>
> https://lore.kernel.org/linux-block/20250624022049.825370-1-ming.lei@redh=
at.com/
>
> The same test can survive for hours in my VM with the fix.
>
>
> Thanks,
> Ming
>

Hi=EF=BC=8CMing

I ran the test 'make test T=3Dgeneric' 50 times with your patch V2 and
not hit this issue.

Thanks=EF=BC=8C


