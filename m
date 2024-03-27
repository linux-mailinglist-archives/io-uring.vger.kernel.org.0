Return-Path: <io-uring+bounces-1241-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B82E388E6A7
	for <lists+io-uring@lfdr.de>; Wed, 27 Mar 2024 15:41:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EA2421C2E14C
	for <lists+io-uring@lfdr.de>; Wed, 27 Mar 2024 14:41:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 950A113AA5A;
	Wed, 27 Mar 2024 13:15:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WlC5zEpA"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F8E112FB05;
	Wed, 27 Mar 2024 13:15:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711545324; cv=none; b=MQslS2d2Kcq7bd4yKDRyRNlMZcOt0t4FP2SsMDtGlTCkQ6deC6RRgh4F5y5naiTMWWcxRrxqoxaVEmDK80EtoAcjt8Zbkgf36ray0hz08HgrjwTbVTfe57mG6sUAKT1fBF8BrM01r4izkc2Aka1922zhzUPaWoafUuBfNtVBC8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711545324; c=relaxed/simple;
	bh=hVWGFMnT3NSh/Y5bcfvnFJ7BOfpWRpHZTt1+sFeRYK4=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=aGvzmMwbQy1HSWRX6ovW9PwQgpqdb/iW6Yurb+Iq7lVjV1FZbQrD59MQr2QzKFggHXI+dCvFghIz0kRFcsLTr+auonKSlY82Jt+70bU6BXdi6Mj2LhjzuRKLy9kCKjDlhlqwEqAcrD1IZ/v3YiJzlkG0Mu5HhmhdccWLlFjpQRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WlC5zEpA; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24B85C433F1;
	Wed, 27 Mar 2024 13:15:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711545323;
	bh=hVWGFMnT3NSh/Y5bcfvnFJ7BOfpWRpHZTt1+sFeRYK4=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=WlC5zEpALyHcMLL7crzKzm7z4rnrwW8uowh4E59sISP/prn0iAEbwxHXS7+uKc/Bw
	 wqYGQilNWFJ+5kfznbP5jYfOcjMrK1brNMdB9bdD3SvgfimE43gkSodM2ShnLCFCEv
	 dajJ3Yz10qJsLnDCfEhKopyfEJq0gvIwVYovDawkfcn6oHnklPZtey6rVEgLmyWPEW
	 E4PyqpPn0WepobbP4ZCzTB0lH2Gu+IQbfjUU9TXdLpBKot4bTj6an5nQ1I4caHFct3
	 xEXFx6xrVEhsmAkJsShcH7vHCWmfF6SFD+e74pyrl9dxggHDC3ksSqQCHRrsdwas/m
	 v4ecGkxzUp56A==
Message-ID: <e15019f54d26898e4b67b84c331cd52d09427258.camel@kernel.org>
Subject: Re: [PATCH v4 02/14] mm: Switch mm->get_unmapped_area() to a flag
From: Jarkko Sakkinen <jarkko@kernel.org>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
 "keescook@chromium.org" <keescook@chromium.org>, "luto@kernel.org"
 <luto@kernel.org>,  "dave.hansen@linux.intel.com"
 <dave.hansen@linux.intel.com>, "debug@rivosinc.com" <debug@rivosinc.com>, 
 "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
 "Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>, 
 "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
 "mingo@redhat.com" <mingo@redhat.com>,  "christophe.leroy@csgroup.eu"
 <christophe.leroy@csgroup.eu>, "tglx@linutronix.de" <tglx@linutronix.de>, 
 "hpa@zytor.com" <hpa@zytor.com>, "peterz@infradead.org"
 <peterz@infradead.org>, "bp@alien8.de" <bp@alien8.de>, "x86@kernel.org"
 <x86@kernel.org>, "broonie@kernel.org" <broonie@kernel.org>
Cc: "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>, 
 "linux-s390@vger.kernel.org"
	 <linux-s390@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
 "linux-cxl@vger.kernel.org"
	 <linux-cxl@vger.kernel.org>, "sparclinux@vger.kernel.org"
	 <sparclinux@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	 <linux-kernel@vger.kernel.org>, "io-uring@vger.kernel.org"
	 <io-uring@vger.kernel.org>, "linux-fsdevel@vger.kernel.org"
	 <linux-fsdevel@vger.kernel.org>, "nvdimm@lists.linux.dev"
	 <nvdimm@lists.linux.dev>, "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Date: Wed, 27 Mar 2024 15:15:17 +0200
In-Reply-To: <5b585bcced9b5fffbcfa093ea92a6403ee8ac462.camel@intel.com>
References: <20240326021656.202649-1-rick.p.edgecombe@intel.com>
	 <20240326021656.202649-3-rick.p.edgecombe@intel.com>
	 <D03NWFQM9XP2.1AWMB9VW98Z98@kernel.org>
	 <5b585bcced9b5fffbcfa093ea92a6403ee8ac462.camel@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.0 
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Wed, 2024-03-27 at 02:42 +0000, Edgecombe, Rick P wrote:
> On Tue, 2024-03-26 at 13:57 +0200, Jarkko Sakkinen wrote:
> > In which conditions which path is used during the initialization of
> > mm
> > and why is this the case? It is an open claim in the current form.
>=20
> There is an arch_pick_mmap_layout() that arch's can have their own
> rules for. There is also a
> generic one. It gets called during exec.
>=20
> >=20
> > That would be nice to have documented for the sake of being
> > complete
> > description. I have zero doubts of the claim being untrue.
>=20
> ...being untrue?
>=20

I mean I believe the change itself makes sense, it is just not
fully documented in the commit message.

BR, Jarkko

