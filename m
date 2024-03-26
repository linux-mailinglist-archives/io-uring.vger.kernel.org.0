Return-Path: <io-uring+bounces-1218-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3379688C14F
	for <lists+io-uring@lfdr.de>; Tue, 26 Mar 2024 12:57:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 65C541C39C73
	for <lists+io-uring@lfdr.de>; Tue, 26 Mar 2024 11:57:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF90A6EB59;
	Tue, 26 Mar 2024 11:57:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hMw4D1PQ"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D7FE6E61D;
	Tue, 26 Mar 2024 11:57:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711454264; cv=none; b=USrDyUDbxrTHXCsaC/FoL9kxSgpT+B+QK8wqLMxPXTJNOd+h0gAs0CCGBNlpD3T0eICy0mB1n825GvHvXus7IqSRGm9eK9sn3M+RhjlKa2FNpAaunKdje7B1D0pPTBlWujsm+YOWld3VjRAklwNuvoWfvkhogTFUXn9b3tnvWy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711454264; c=relaxed/simple;
	bh=EKJhulSFxLWQLaF7yaxSDnu58jC9IeQn/dXAU0JKliQ=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=QoPZOEwAk0Yt6nEs/hzNVqxnig8kslz/wTvcTI/TW57XOoaVHHnZzsngqormlyVJfCCu+L+CNjtq9lGn6RcoQwcCmOf405Y9daau7UXgq/mE3zda2M5HjZE67E+o1QZhNHGm4UOdeZl2x3HzdUXJ73us5PAoYPZmZ3Gjm9j5F+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hMw4D1PQ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E9C1C433F1;
	Tue, 26 Mar 2024 11:57:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711454264;
	bh=EKJhulSFxLWQLaF7yaxSDnu58jC9IeQn/dXAU0JKliQ=;
	h=Date:Cc:Subject:From:To:References:In-Reply-To:From;
	b=hMw4D1PQCahqfw8MtYxsjzHrzUNPiIFh/by6PO26L5JBoud0NXvOoP+pWDolP6A7W
	 MHWxMfRihenzXqisqycL3g12C+CTWoltIvH4CNPUdz+72PbKPN+WRf81R/oXG8bDpf
	 T1dkgCTQSYki+AzT7VZB67H8zKEuIGM/3R4nByOKzGAkwCto7GnC2k4qJLIzF7Eq/D
	 /5kSEGrmMOO3Stz0ZnDtyv2/s9EdzPUq06xhiB22b5Veavz/fy0YY//StezneyCMcw
	 b0BhOnWShhQodg0X1OfcREnyS8OlaUMwqW9UypBtbcnB46bzRA+9vjV1wmjQjZJ4Bo
	 J5FymRUa+DgSQ==
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 26 Mar 2024 13:57:37 +0200
Message-Id: <D03NWFQM9XP2.1AWMB9VW98Z98@kernel.org>
Cc: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
 <linux-s390@vger.kernel.org>, <sparclinux@vger.kernel.org>,
 <linux-sgx@vger.kernel.org>, <nvdimm@lists.linux.dev>,
 <linux-cxl@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
 <io-uring@vger.kernel.org>, <bpf@vger.kernel.org>
Subject: Re: [PATCH v4 02/14] mm: Switch mm->get_unmapped_area() to a flag
From: "Jarkko Sakkinen" <jarkko@kernel.org>
To: "Rick Edgecombe" <rick.p.edgecombe@intel.com>,
 <Liam.Howlett@oracle.com>, <akpm@linux-foundation.org>, <bp@alien8.de>,
 <broonie@kernel.org>, <christophe.leroy@csgroup.eu>,
 <dave.hansen@linux.intel.com>, <debug@rivosinc.com>, <hpa@zytor.com>,
 <keescook@chromium.org>, <kirill.shutemov@linux.intel.com>,
 <luto@kernel.org>, <mingo@redhat.com>, <peterz@infradead.org>,
 <tglx@linutronix.de>, <x86@kernel.org>
X-Mailer: aerc 0.17.0
References: <20240326021656.202649-1-rick.p.edgecombe@intel.com>
 <20240326021656.202649-3-rick.p.edgecombe@intel.com>
In-Reply-To: <20240326021656.202649-3-rick.p.edgecombe@intel.com>

On Tue Mar 26, 2024 at 4:16 AM EET, Rick Edgecombe wrote:
> The mm_struct contains a function pointer *get_unmapped_area(), which
> is set to either arch_get_unmapped_area() or
> arch_get_unmapped_area_topdown() during the initialization of the mm.

In which conditions which path is used during the initialization of mm
and why is this the case? It is an open claim in the current form.

That would be nice to have documented for the sake of being complete
description. I have zero doubts of the claim being untrue.

BR, Jarkko

