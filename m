Return-Path: <io-uring+bounces-8233-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A33A8ACF74B
	for <lists+io-uring@lfdr.de>; Thu,  5 Jun 2025 20:42:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 688373ADC63
	for <lists+io-uring@lfdr.de>; Thu,  5 Jun 2025 18:41:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F30627F72E;
	Thu,  5 Jun 2025 18:34:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MomzGR2r"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1A6F1F099A
	for <io-uring@vger.kernel.org>; Thu,  5 Jun 2025 18:34:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749148466; cv=none; b=o7YlfvkA0b1Q+neiAlXtJzyQ+JdmGzxLhcdZRuP/Eeg4j2RbktMcHtiUyoTbJZA5iMo1B9OvWLLRuS5tDm0l26GQW6+/KaE02eiAQmWnU9vjzXsmuiVVPMrIyewksJ/J5TeV2SNyc068WzZuy5qrL3/DI5Ubg99E+XdElqIf9pc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749148466; c=relaxed/simple;
	bh=iFCd0wpgRJFbL4Jf6wbbEYYEU3wz31hjGOPPneRDEcc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rj9n8RtH8BIyT/hse9TQWmwYYW9icKpTqqeytruG6lzBWU1YXAJdvDJ+VYWMtJEx1lI/Rl1ZDlvmRo76O0IA17s8I1bQbaY5pRz9L0gylD+Qmtkob8BAL3WlteWTht30FPgJInlD60f3UzVvvDNWaBQg3ypar2ewz7Q/x053ti4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MomzGR2r; arc=none smtp.client-ip=209.85.160.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-4a58197794eso36201cf.1
        for <io-uring@vger.kernel.org>; Thu, 05 Jun 2025 11:34:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749148463; x=1749753263; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iFCd0wpgRJFbL4Jf6wbbEYYEU3wz31hjGOPPneRDEcc=;
        b=MomzGR2r3obVuNha5cQvSi//2Zr+arQY4N0awS2YWS2fCY0QRhigIYfeyuEDb9BKBu
         fGy+fjmd/CpeIeznLkVDpAwwvAbpudvFP5cqK2F5qSwZlxXcOITnbcxwr5IfjHxZoCyF
         fVOiUe2uRZ6Mhs4fZNshLqZEJBNckADVikCQ0L5OKriMW8cU+/0t2GCTXFra3KayrIDb
         7LHWz9uVvJ24vfDM9EZ4a9vLhQwMTAIlqHC7wRaVM61NY+q7g+hmwYRBiATmENTHdIq4
         wntzoVcu6E49uxqUqhMcmDyAXY71mC3Xu3PzzIk+NVcVF4Oo2aDXEKDLVJ8MA0bbNUS0
         2Puw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749148463; x=1749753263;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iFCd0wpgRJFbL4Jf6wbbEYYEU3wz31hjGOPPneRDEcc=;
        b=IWu+q5Rdp2nbBePtqv74ZJMrkkGTSzC632tiMOcctKdc+9UGLDI2t4UogDsTLB6O0h
         DvxEol8YiBCvTuBv6byOP0rQafgpxejMbV+5UdDv7iZETTCA+EG8qpaidalOW9yKIxii
         FuMkGBxTJGDYSbuvH+yd3xJdyzAntN8TuzQbiy8iqs0MQDnzJUHdF7NUpevNxSLnoQTa
         TNBCNgQ0J+i0gE8VT/pUmUzxquJtcT3aj75THeaFFv3oNhmldZztcUr1z/oZiNnrBdFg
         dmGwMbp/2IulExj57PInhxEg9amUrW12mW+GTqAHkofglDRghabXLigcuo3dvdRjzpml
         Q9Tg==
X-Forwarded-Encrypted: i=1; AJvYcCU7lSu6KNypMs3SBCmHwBTMu2jaPsGpOf2vE4uULwL4FnYiNKTiVtADCQRDTtSkoq74mULfpGlkRA==@vger.kernel.org
X-Gm-Message-State: AOJu0YyJksdFDXGvLK6jrb5QIdrLob+fdT46mzGBKjuNTvQLjia9smXV
	mrdGheP8xvqR6iGebpypYCzDEmthA1AYMtWyhjN5OEBTlhQTebecJGZNrrMrVwx8w0I2zMRXv51
	SJpZWZtmtKJIg4l0fC2Qtkgpm8Ax6rcOD/A02uhzmAT90t9eOqCqV34YgtL4=
X-Gm-Gg: ASbGncuywoXMm3qRDO6aibuaGxgxrxfLOhJX25Lz11fsT9kakLQEidVQUG5oI3Jw4Qo
	lrxvZ4zssF1+8HbFaXpMQFE9rU6bF3znzDrfBIJs0juxTXg8pNDgjVk3o9nM1Md8nqCK18ZTgMe
	OOQkmNyKPelQEbi5Md22OID0aoRlDQxpQpoZtrdPnaaV8NSE0eKiFakuwjb7XDVU6qWrVjUYqHa
	Q==
X-Google-Smtp-Source: AGHT+IHJgivjORRUGSyOdnKwc/j/YUOaIyFLPXMeXTtZN3bS7fASxuj1kukT7nKX2tz03k/1gqjLUSAvmHiOo/kmYCo=
X-Received: by 2002:ac8:5c93:0:b0:48a:5b89:473b with SMTP id
 d75a77b69052e-4a5cb4260ffmr132921cf.7.1749148463196; Thu, 05 Jun 2025
 11:34:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <67bd7af0.050a0220.bbfd1.009e.GAE@google.com> <68342b47.a70a0220.253bc2.0090.GAE@google.com>
In-Reply-To: <68342b47.a70a0220.253bc2.0090.GAE@google.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Thu, 5 Jun 2025 11:34:12 -0700
X-Gm-Features: AX0GCFsaIXiP66tcFR1RPkYYCN8KeQPAYTtDTfBLiOP4HzV-Eu2RNhwCtT_7elw
Message-ID: <CAJuCfpGur7p19=HKkmqfD-KXf6FEbvwCV1ewFgBCGPDkoY0Wdw@mail.gmail.com>
Subject: Re: [syzbot] general protection fault in lock_vma_under_rcu
To: syzbot <syzbot+556fda2d78f9b0daa141@syzkaller.appspotmail.com>
Cc: akpm@linux-foundation.org, asml.silence@gmail.com, axboe@kernel.dk, 
	eadavis@qq.com, io-uring@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, shivankg@amd.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, May 26, 2025 at 1:50=E2=80=AFAM syzbot
<syzbot+556fda2d78f9b0daa141@syzkaller.appspotmail.com> wrote:
>
> This bug is marked as fixed by commit:
> mm: fix a crash due to vma_end_read() that should have been removed
>
> But I can't find it in the tested trees[1] for more than 90 days.
> Is it a correct commit? Please update it by replying:
>
> #syz fix: exact-commit-title

Yeah, the fix was folded into the original patch

#syz fix: mm: replace vm_lock and detached flag with a reference count

>
> Until then the bug is still considered open and new crashes with
> the same signature are ignored.
>
> Kernel: Linux
> Dashboard link: https://syzkaller.appspot.com/bug?extid=3D556fda2d78f9b0d=
aa141
>
> ---
> [1] I expect the commit to be present in:
>
> 1. for-kernelci branch of
> git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git
>
> 2. master branch of
> git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git
>
> 3. master branch of
> git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git
>
> 4. main branch of
> git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git
>
> The full list of 10 trees can be found at
> https://syzkaller.appspot.com/upstream/repos

