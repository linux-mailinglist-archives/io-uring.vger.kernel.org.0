Return-Path: <io-uring+bounces-1216-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A183288B899
	for <lists+io-uring@lfdr.de>; Tue, 26 Mar 2024 04:32:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3E9D51F3F5CC
	for <lists+io-uring@lfdr.de>; Tue, 26 Mar 2024 03:32:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A67B129A6D;
	Tue, 26 Mar 2024 03:32:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GQ/yKgv4"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D637F128823;
	Tue, 26 Mar 2024 03:32:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711423974; cv=none; b=PLrxTrwdjILWshfjMuC5XDmwSW/IMqKlj9FqLkUyO1KIt8GRkUfPuJbIhkC2JX61fkpqwbNF7ITxMW6Pm0CM4KQUiEEp0WpAiMv1qfuxAnVNCJsoryeaiFb6jR3cKkwpJzVkQuXOiw+OsIK5HqIfpwotPjH3VEKPl9caz3gU67g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711423974; c=relaxed/simple;
	bh=f5P7jXuaPxF8gxKTJOiUPKZMuLKQpBGNZmyCMdfpQew=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=W8AGvVYmbVUe2apVdz2PsqbPJLgZQSM/KTAOfUD01iaYVo2ZMihkLuX9HAWNCoMwYKUsWAoNAQKu8LyM3KyBqleOwEy0bpgzUuPxFU//s0GFX3sbIuqmt9ji0GzmL1Uffn5h8/1Mg/sa7QspryVqnCUKldOdm70XjBWKMZOhlbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GQ/yKgv4; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-41488d6752eso10821765e9.2;
        Mon, 25 Mar 2024 20:32:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1711423971; x=1712028771; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lA5o6h754u6ODWqcXZI/yfZmhgXKlz5ceCEo4tpQucE=;
        b=GQ/yKgv46sqFnSCBelHnAnN508cFDTH28rJLuZ6V2bjpScVQ3HKjJalz+ylvKz2hmB
         DBF3ShSXyxxp6u0Kh1ZhSdVJ8hxor/zl5vsZPXMp20oXODQvp5897+fIEUkKcf93x8mL
         KBbtYe3H2NGGyMYstb37YLWepFJmicNDM/0G0InWzIDnL7gjDG5InDxMlTPBz/nxPNab
         7cPgbPTjscyAqu5npqXXomA8HAwVfxqTr3TXc4svWbzx41gzXXtezxDS1rc1mJ69ESi3
         E5ybo69ULxBgoZgrSVqtEtktM/wdkmCLjC9ch73wt+VrBL4JzbIiZoZ9S87j9hApctwr
         aEmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711423971; x=1712028771;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lA5o6h754u6ODWqcXZI/yfZmhgXKlz5ceCEo4tpQucE=;
        b=N0klvxvfSE8JxEsdNayWaepFKiRxCYeXN4J1qGYyqy6Tl5G1NkaUHbJsrZWINdG+gh
         imcVFh7GREh5T9bAALkEHRZG0U88I4Strc90PB2zUd1lQqfYuOM12FlnzDT8VfsegaDY
         bSSiQlase5SvGmWJcXcvrfqOIlOFmUJNl7sScAloJNZu86gu8pB9tyX6bdiMtdIUaYcB
         ZUPFY/dbvyO+hOCl8v9mdHxijLUi+yB/tL7Y7/u0C+CoNDx3KFMO+zyDzyFw4DkO+HOB
         z/SaDAkpcO7WAVKgomKrb6t+D8OUqETOKztnEpoozB088OsswWeZuQFnQy+LytRdcWpP
         fyjA==
X-Forwarded-Encrypted: i=1; AJvYcCXt9vUv1hboSJIa2Wk0CGjD1afSVZLRfkz3WSs2uB+fCN65VGYGcmrmRcOfoG4Xs4iKa8chh2WPpcHwo05wQLJltymwj2gQ1X8OJxtW4tq7vtGeV1EstlKt9JT+ekJWHrLEeX+Yg8cRddUlA23iz7n+lW0jjQb96hOWwJhQOgcriKDZAEVBKUoLG0T9E6OpuprnBS2pBKUH15e2XVku5Ifj1qiJFwq3MB4XCEwqIN67kdpvlH0aoDHYJc17pqJ1E5aBxcBNSVhKjATrKvk3NIBb6MgWtcXcbfybFCQwwlBlXgSjJ/OwEDAeTNYxT5JmB/r2qQlCN+3Uma/G+KUoFfNRkT+BBWg8dEc=
X-Gm-Message-State: AOJu0Yx2L+Ugcmv/iPcXz+KA1Brw1i6kPdtRDEdgyN7EpNBACsVJs0tc
	NXCkdqwe6fTxnLigincKMPvAT7kV0WCeCuq0mxzZijtq3AI4i0vtMjhznrefb+Iv7GQA/uroAZ9
	LDyiTZLKcC2GOHr9ryTmt3djgMus=
X-Google-Smtp-Source: AGHT+IFQ9mbx3pz3lWDfK2p6wsj2aDG+6I6RjpqCge2Sd5poBB31E3vi/9DrtwhPj4IF4gJiiqaho8oQ5gTSaHJ4YJE=
X-Received: by 2002:a05:6000:120d:b0:33e:a5e1:eccc with SMTP id
 e13-20020a056000120d00b0033ea5e1ecccmr5218777wrx.68.1711423971122; Mon, 25
 Mar 2024 20:32:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240326021656.202649-1-rick.p.edgecombe@intel.com> <20240326021656.202649-3-rick.p.edgecombe@intel.com>
In-Reply-To: <20240326021656.202649-3-rick.p.edgecombe@intel.com>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Mon, 25 Mar 2024 20:32:40 -0700
Message-ID: <CAADnVQKHtRX2WS9c2qcMUJTmNNda+attkXoiNurFyMKvHNfa=A@mail.gmail.com>
Subject: Re: [PATCH v4 02/14] mm: Switch mm->get_unmapped_area() to a flag
To: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: Liam.Howlett@oracle.com, Andrew Morton <akpm@linux-foundation.org>, 
	Borislav Petkov <bp@alien8.de>, Mark Brown <broonie@kernel.org>, 
	Christophe Leroy <christophe.leroy@csgroup.eu>, Dave Hansen <dave.hansen@linux.intel.com>, 
	debug@rivosinc.com, "H. Peter Anvin" <hpa@zytor.com>, Kees Cook <keescook@chromium.org>, 
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Andy Lutomirski <luto@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
	Thomas Gleixner <tglx@linutronix.de>, X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>, 
	linux-mm <linux-mm@kvack.org>, linux-s390 <linux-s390@vger.kernel.org>, 
	sparclinux@vger.kernel.org, linux-sgx@vger.kernel.org, nvdimm@lists.linux.dev, 
	linux-cxl@vger.kernel.org, Linux-Fsdevel <linux-fsdevel@vger.kernel.org>, 
	io-uring@vger.kernel.org, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 25, 2024 at 7:17=E2=80=AFPM Rick Edgecombe
<rick.p.edgecombe@intel.com> wrote:
>
>
> diff --git a/mm/util.c b/mm/util.c
> index 669397235787..8619d353a1aa 100644
> --- a/mm/util.c
> +++ b/mm/util.c
> @@ -469,17 +469,17 @@ void arch_pick_mmap_layout(struct mm_struct *mm, st=
ruct rlimit *rlim_stack)
>
>         if (mmap_is_legacy(rlim_stack)) {
>                 mm->mmap_base =3D TASK_UNMAPPED_BASE + random_factor;
> -               mm->get_unmapped_area =3D arch_get_unmapped_area;
> +               clear_bit(MMF_TOPDOWN, &mm->flags);
>         } else {
>                 mm->mmap_base =3D mmap_base(random_factor, rlim_stack);
> -               mm->get_unmapped_area =3D arch_get_unmapped_area_topdown;
> +               set_bit(MMF_TOPDOWN, &mm->flags);
>         }
>  }
>  #elif defined(CONFIG_MMU) && !defined(HAVE_ARCH_PICK_MMAP_LAYOUT)
>  void arch_pick_mmap_layout(struct mm_struct *mm, struct rlimit *rlim_sta=
ck)
>  {
>         mm->mmap_base =3D TASK_UNMAPPED_BASE;
> -       mm->get_unmapped_area =3D arch_get_unmapped_area;
> +       clear_bit(MMF_TOPDOWN, &mm->flags);
>  }
>  #endif

Makes sense to me.
Acked-by: Alexei Starovoitov <ast@kernel.org>
for the idea and for bpf bits.

