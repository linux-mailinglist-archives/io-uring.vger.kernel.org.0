Return-Path: <io-uring+bounces-10031-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id B5814BE3414
	for <lists+io-uring@lfdr.de>; Thu, 16 Oct 2025 14:10:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id A34634F3406
	for <lists+io-uring@lfdr.de>; Thu, 16 Oct 2025 12:10:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2616331DD82;
	Thu, 16 Oct 2025 12:10:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="dSsyKO3h"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f49.google.com (mail-ot1-f49.google.com [209.85.210.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1336E31D75C
	for <io-uring@vger.kernel.org>; Thu, 16 Oct 2025 12:10:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760616603; cv=none; b=aRn7zsmUSIr+sVq2jQykpRv9EZ9WmemFsi6AISuaJirh/uCIWrMe/7qjEy2wTYHRWrOw21npr8yaOYjBm+xrlHpnsvgz82Fkk+x1fAmLVf8jJgfl4imKQIyen3Usz8lV87TLVyx4Gq3BVZsyJrr6tKX/BhJMYA686Qoz4/CdZyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760616603; c=relaxed/simple;
	bh=6c/p81gtZ8CE8ler2J/X0MFYEnCWpfjDI/rpVf+zCBI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=M7m8IbNFYGJ/yLL099bLhnN2WdhUTJ5b/z/9f9qIX3L0l0nGj+y7cqh9sxxeOAsHTkRcMGBGG27Jv8P/2ePqWimTuoAjg3IKh4KIXFbziiK2awKS4JdDNFDB2PtQG35e/bGqtg8oyTF1tES5b4qiDXkldI2Ici6jfkeVz5qfuvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=dSsyKO3h; arc=none smtp.client-ip=209.85.210.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Received: by mail-ot1-f49.google.com with SMTP id 46e09a7af769-7bc626c5461so206153a34.3
        for <io-uring@vger.kernel.org>; Thu, 16 Oct 2025 05:10:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1760616600; x=1761221400; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TLfh3Dl2prgD3owbbrD+6dJKgcIz3VRTi9F759iFZ1g=;
        b=dSsyKO3hk/75ILRHzsNw0tqc8YdAhbkc8250nEfAhkal0QbeAAX+2doM23Ko5oiTCk
         iEhYsYVAympGi3E0syjMbutDoDXDnEuVRKWvxOiIt17/wbk2qr8ColO0vMktMZNJ5IID
         gtQPcGdusops5sNdXqcroHyz/fL9T8RwAmcv3pUtkluGpozrKci9gegNdyf+Azd6gs06
         7m8Kbq/EGrdOhUhI40vb58Ou9ZM+lnbi2XBUeXBSM4aksuDr1q3S3KI/s0tMa3nGHoZs
         UoOQWntYXpIhkPi+z9sC08AFtLDIhEr/nrczbUc7n+7kXmHOfYWIST7yNuxGR4mNlWjt
         Y+lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760616600; x=1761221400;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TLfh3Dl2prgD3owbbrD+6dJKgcIz3VRTi9F759iFZ1g=;
        b=h263CKFFOS+KSpxPmpeucEQEU12Ye/k3pUK/kCq5Z/QCOJ6zQh6usrLUG7/ZRESOTm
         kmZk/20/cWD2gKSefcHSmoLjMtZqQNxpI93ddjwUBtdDXCAy1DxizpUC/fwJYNdwc9Mj
         7s/NZXZ7HJpMP004DPNWvy/RqxXRquIcggjwQs8Giz/CaXbDAwd6liEwVNMnY2oqdG51
         AJEK93FNGcF6+uuU2HGkscx9CI8lpE86ht3APqTH2qlzLziNrdbSJY4VbmHWPCBY/vEh
         /3hUTVCRYdLsqMJHN6Zrq/S60FiZ/bOWK05AlKx/toxWsPCCq5WR2xz7LZqH90gEg0Gi
         c0ww==
X-Forwarded-Encrypted: i=1; AJvYcCUMZRcmR+Lf9QNCmw3wmOIL/DQtIl83QocVCbIXNUVfEK2YwlmMGLo077epFWZgZQ+zh5TpCt5M1A==@vger.kernel.org
X-Gm-Message-State: AOJu0YxJIm0W0PPthyvovi0QWeI9FzejxljU1An+J/5i0zpO6zA+hBs7
	RWB32szsPzMaHuFQwTi3XtRrI/J4h31FzC2AjAJu/ND+V0O31hiQeIZoKxMVNLpKxhvHGZNK+Ij
	KhqRvwSvA9WND0HO/lTjI0DpdpC9jytFDokcYUW6kgByz1Gci2Ut1iN4=
X-Gm-Gg: ASbGnctEZLHsxtvQx46rSTpPg0TanUhZ7gTb347BOM6Z2vXi7IRO1iaQ8XQseprJ1dU
	38t44zAtP6gPFzGt+e9CzoyVVfCe7/nLKHVwDEXuL2Nthpdv6ddfgGtVRU7nOyhOsVltPoinlVp
	YBwqgfYCk77OZZISyhNKLhBus6UsXx+it9OQXlxmFwt1+IojROaCxPO/ETLF0KKhwcY0IrvEAN6
	L8xtInY5ISXznMmVryjuLxCr/tdcq5oIo0jcvPvEdxG/zNgidibI7wl4RUchQ6Hc0Ol
X-Google-Smtp-Source: AGHT+IEnNjCppfUz7Xk51CPR9QfPK71NSrXiOPtoh3PXUfMb4Ezb3VzsKqVWPHZYjy6koMLmLSmuxBPNNfy9SRTLX1E=
X-Received: by 2002:a05:6870:c18f:b0:369:c7ae:6425 with SMTP id
 586e51a60fabf-3c0f81e5e7amr15319884fac.28.1760616598825; Thu, 16 Oct 2025
 05:09:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251016114519.57780-1-changfengnan@bytedance.com> <28a8fdc0-2693-4ff1-bcb3-2b8f67e7b794@gmail.com>
In-Reply-To: <28a8fdc0-2693-4ff1-bcb3-2b8f67e7b794@gmail.com>
From: Fengnan Chang <changfengnan@bytedance.com>
Date: Thu, 16 Oct 2025 20:09:47 +0800
X-Gm-Features: AS18NWBweC_jkFMp8JhCmcgKdNbnFP4_Ich7YAAv53duEYMa72jrx-SHzppe9PA
Message-ID: <CAPFOzZuhDU0yD=nGioR1a3u9C0ZXxOpahZxv=PsHThEJJK=A3w@mail.gmail.com>
Subject: Re: [External] Re: [PATCH] io_uring: add IORING_SETUP_NO_SQTHREAD_STATS
 flag to disable sqthread stats collection
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: axboe@kernel.dk, xiaobing.li@samsung.com, io-uring@vger.kernel.org, 
	Diangang Li <lidiangang@bytedance.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Pavel Begunkov <asml.silence@gmail.com> =E4=BA=8E2025=E5=B9=B410=E6=9C=8816=
=E6=97=A5=E5=91=A8=E5=9B=9B 20:03=E5=86=99=E9=81=93=EF=BC=9A
>
> On 10/16/25 12:45, Fengnan Chang wrote:
> > introduces a new flag IORING_SETUP_NO_SQTHREAD_STATS that allows
> > user to disable the collection of statistics in the sqthread.
> > When this flag is set, the getrusage() calls in the sqthread are
> > skipped, which can provide a small performance improvement in high
> > IOPS workloads.
>
> It was added for dynamically adjusting SQPOLL timeouts, at least that
> what the author said, but then there is only the fdinfo to access it,
> which is slow and unreliable, and no follow up to expose it in a
> better way. To be honest, I have serious doubts it has ever been used,
> and I'd be tempted to completely remove it out of the kernel. Fdinfo
> format wasn't really stable for io_uring and we can leave it printing
> some made up values like 100% util.

Agree,  IMO turning off stats by default would be a better approach, but
I'm concerned that some people are using this in fdinfo. I'd like to hear
the author's opinion.

>
> If it's there for outside monitoring, that should be done with bpf,
> with maybe additional tracepoints.
>
> --
> Pavel Begunkov
>

