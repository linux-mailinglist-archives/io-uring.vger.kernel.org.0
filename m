Return-Path: <io-uring+bounces-8739-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0BCC6B0B6DC
	for <lists+io-uring@lfdr.de>; Sun, 20 Jul 2025 18:11:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 791EB3BD764
	for <lists+io-uring@lfdr.de>; Sun, 20 Jul 2025 16:11:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7E8A21C17D;
	Sun, 20 Jul 2025 16:11:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=furiosa.ai header.i=@furiosa.ai header.b="gljd6VJg"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DAB1218E9F
	for <io-uring@vger.kernel.org>; Sun, 20 Jul 2025 16:11:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753027894; cv=none; b=iXnmVHy/I81g8LFTBAZIk2a9SQecqG8JNqhQEitGLcJi5zoZgVE2UuAYZfSZs21cRXXi+wJqcJ+W/m7fgBnHTkInQ9UgCs7KJp06PKLD9f5n9WM2nVW6MuKXXqdWttx5GXCqPVZF4KOxnSq7a9bno9Qj4m4vTV6tIdkrbP916Cc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753027894; c=relaxed/simple;
	bh=1kkgAJedVRmqE+NjlLS/JrjnCCyYksp2IzhgSl3fYFs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=b5T1x+HuK1SxqwbkPt0+H0ADoOOPmxsXGiaT1UqPXUqlcM6Vs3y07M8oiP7nyphxVgFhpVDxhpE67iChCcGxVl78Mww3nzVUYmsSb4rnFJuaUmjsZqYK+7Cut5GgkglKNEFucjThVNEaN6rRdA+RLPQky0nmj1ZKfdY706YbIAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=furiosa.ai; spf=none smtp.mailfrom=furiosa.ai; dkim=pass (1024-bit key) header.d=furiosa.ai header.i=@furiosa.ai header.b=gljd6VJg; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=furiosa.ai
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=furiosa.ai
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-74801bc6dc5so3476049b3a.1
        for <io-uring@vger.kernel.org>; Sun, 20 Jul 2025 09:11:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=furiosa.ai; s=google; t=1753027892; x=1753632692; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=X3sE27/WAqZP41FkkjgAc8UwvwE9+GItC8A+pDEL148=;
        b=gljd6VJgL9tenY51GmrzISWJaspcwktvmmlnYdsPmJNkEmv8IbkkS2Iu8TUlkyroiA
         X1oUNW+UCYOm+K3KXk5cuGKVeE854iqsCvxZAQKsHQf4yo6eY4H128qOYEsEVfQ6DEkC
         mHt+/hum/JToqmEuhN6dagarFy4Zff18BR0pM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753027892; x=1753632692;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=X3sE27/WAqZP41FkkjgAc8UwvwE9+GItC8A+pDEL148=;
        b=Xqt3mJZRNeNzPfERiJBvlRyUU1rmordhEebB9YyQAMV3cZL2BpfcOevfPvHfLq8jPa
         VhOUhAERuVcDzMWQGlDlXqwvek4t0DTjb3yXDYU5WaXuyslk7AoITmxEOSTOQb7C3/DE
         zxpdrxujXPXLSYDDowfF9SpcfVWZeZx+7v4yROutWHcLO25Bq0Da1MOZwJHeVlej/bpb
         Urq8+Xme3Txtsb5+JJglpA9QmdvaS2+PPuc4HhE/huCK0PsyAmNP4HnpFI/af93+QorK
         2eSHSpEmuaKPM+MVl5PifmK1yWYGzKrxn97VjtFJdGWPyGUdsLf5tP3Q8qzPpG5h9H3b
         /xBA==
X-Forwarded-Encrypted: i=1; AJvYcCWuHwS/E7VeysRwwhdFKFkS36DlFYkDyRDeePrzOHfykwErvKaQX65znsa+CMAhxIy0UQ9GVZPVwg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yxf9ZjP892M2g60jBHbeViUQBTpMUhxTUIzdUcqPvDrlBrnCDJJ
	MH8Ch+LTwJ1uDfMRL9j76uIcTuVH8D1G3DWPRzjN5GDNTWQ5dMuafqGC6yA1GOtcV+JN17pZ83T
	6/OC+
X-Gm-Gg: ASbGncvfsAEO+Z7qy4fgU0eWxEUDY2HA+HxlmVaTDe48AnJAQukKnTGL5KcVAJf/WfT
	emyB3N6ifRCHHd9NkgQdua8rr+sKyfseKyRd4E4RglQD/Jthvdm6TbHBwKsAlJ8sFyw15CRNIev
	izw2FvuFMSh4x02gWBY3MAOWnooZhn1mtVCgq1kE+ApsBfOl7Pld17O+cZqHrbewvRWjNrmYFQA
	uo+/qDHLPi9YGNR0C3FwPQfJOhRCjYUqFpqOOP/fID4Pl1NToNpD00f6R0lkZYGEC3hrHdV/Z9w
	XBafvIFTEUrSeynBcke8waZCeoBwcyyNcPzusLzdfLrrVsq+zMCRWRfsdTiaBTAtKkvfwu4cM0Q
	DOkFvkFSYCYMmKCrfaifQXPM+ORXIG9uYvHwS/hVvEwmSdBXq6t9VU5NJFw==
X-Google-Smtp-Source: AGHT+IFF1fTWCOr6/BH6HO2z3c4L025UX0QqK8oCHrmmePFPB5CppScDYdz+haI97RiMoMTtOxzo2g==
X-Received: by 2002:a05:6a00:3e15:b0:736:4d05:2e35 with SMTP id d2e1a72fcca58-75836faac4emr20252321b3a.3.1753027892574;
        Sun, 20 Jul 2025 09:11:32 -0700 (PDT)
Received: from sidongui-MacBookPro.local ([61.83.209.48])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-759c8acb61csm4358217b3a.64.2025.07.20.09.11.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Jul 2025 09:11:32 -0700 (PDT)
Date: Mon, 21 Jul 2025 01:11:26 +0900
From: Sidong Yang <sidong.yang@furiosa.ai>
To: Danilo Krummrich <dakr@kernel.org>
Cc: Miguel Ojeda <ojeda@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
	Jens Axboe <axboe@kernel.dk>, rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>
Subject: Re: [RFC PATCH 0/4] rust: miscdevice: abstraction for uring-cmd
Message-ID: <aH0VLhYptH_Sw0Py@sidongui-MacBookPro.local>
References: <20250719143358.22363-1-sidong.yang@furiosa.ai>
 <a0a868ef-107e-4b1b-8443-f10b7a35aabb@kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a0a868ef-107e-4b1b-8443-f10b7a35aabb@kernel.org>

On Sat, Jul 19, 2025 at 07:03:24PM +0200, Danilo Krummrich wrote:
> Hi Sidong,
> 
> On 7/19/25 4:33 PM, Sidong Yang wrote:
> > This patch series implemens an abstraction for io-uring sqe and cmd and
> > adds uring_cmd callback for miscdevice. Also there is an example that use
> > uring_cmd in rust-miscdevice sample.
> 
> Please also add Greg, maybe get_maintainer.pl does not list him, since the
> entries for miscdevice were missing for a while I think.
> 
> For new abstractions I also recommend to Cc the RUST reviewers.

Thanks for a advice. I've added Greg, and other RUST reviewers to Cc. 

Thanks,
Sidong

> 
> Thanks,
> Danilo

