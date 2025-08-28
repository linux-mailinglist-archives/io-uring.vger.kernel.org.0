Return-Path: <io-uring+bounces-9390-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C292EB39909
	for <lists+io-uring@lfdr.de>; Thu, 28 Aug 2025 12:05:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DDD605E5195
	for <lists+io-uring@lfdr.de>; Thu, 28 Aug 2025 10:05:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A6E63081C4;
	Thu, 28 Aug 2025 10:05:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Vi61sIvF"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99EAC3081B0
	for <io-uring@vger.kernel.org>; Thu, 28 Aug 2025 10:05:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756375540; cv=none; b=d7ZmvKEc1MmarEMdyMofy1sK5UGXsOHmZ+UhXXx4+4Il2udO3kXEKp3bhuO5NHL+zwxEtjwzv6Ap9k6nA1sM0FGk79mslYWiyOaDO/n6av0srr2tWLaekC3LDUPExK43TS0AOZvTr9kziXeFSlg1yt51EaXICehuj7wDTbvKXW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756375540; c=relaxed/simple;
	bh=Ku1yzjDdHS56Wo0QHQg7lQzpp+LhHdoBvhe979tiHU8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I8r6uyyn7/5dJmuaLYJrg3+v40vjtTDFoegTUDkjRjtGWf38EBwUcCcFpeQxnXG8hFF438Y6f8gy813U2CauXsvKz18lQHqH3N6+5J35mtJMNAqvSkHtw6H5ZF0VpmnMj20NcSUwzpCgxDDjtso5qFkBhT9vUsjo/1hhgQ49xk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Vi61sIvF; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756375537;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=iOWLjvSk+7GndF8AQckdONEc6IGjNeDFaijnw8WVqT8=;
	b=Vi61sIvFwLiq6niuBILwoLwqY9hXTzNSG+r4GSDdz9ITpwewHqugDZTSuKRYAiaUF/KsBB
	51+97zeIW5YBqS0P4hHbIpPAJm6HQRvORtc0fYEwutGvoOzzpwawIAkaMc6qu+S+Fh/Xut
	XGzC0AX/RXyc3T5I/vsLGx2C/RWWnoY=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-670-ortSZ0rXOL2G-MSw2cSS7w-1; Thu,
 28 Aug 2025 06:05:32 -0400
X-MC-Unique: ortSZ0rXOL2G-MSw2cSS7w-1
X-Mimecast-MFC-AGG-ID: ortSZ0rXOL2G-MSw2cSS7w_1756375530
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 914CF1956086;
	Thu, 28 Aug 2025 10:05:30 +0000 (UTC)
Received: from fedora (unknown [10.72.116.22])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EC38519560B4;
	Thu, 28 Aug 2025 10:05:21 +0000 (UTC)
Date: Thu, 28 Aug 2025 18:05:16 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Benno Lossin <lossin@kernel.org>
Cc: Sidong Yang <sidong.yang@furiosa.ai>, Jens Axboe <axboe@kernel.dk>,
	Daniel Almeida <daniel.almeida@collabora.com>,
	Caleb Sander Mateos <csander@purestorage.com>,
	Miguel Ojeda <ojeda@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
	io-uring@vger.kernel.org
Subject: Re: [RFC PATCH v3 3/5] rust: io_uring: introduce rust abstraction
 for io-uring cmd
Message-ID: <aLAp3OUhsxUEsEWT@fedora>
References: <20250822125555.8620-1-sidong.yang@furiosa.ai>
 <20250822125555.8620-4-sidong.yang@furiosa.ai>
 <aK-kd3GBhxOzt_mA@fedora>
 <DCDVRPJKZBC3.31KGTGS90WUUA@kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DCDVRPJKZBC3.31KGTGS90WUUA@kernel.org>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

On Thu, Aug 28, 2025 at 09:25:56AM +0200, Benno Lossin wrote:
> On Thu Aug 28, 2025 at 2:36 AM CEST, Ming Lei wrote:
> > On Fri, Aug 22, 2025 at 12:55:53PM +0000, Sidong Yang wrote:
> >> +    /// Reads protocol data unit as `T` that impl `FromBytes` from uring cmd
> >> +    ///
> >> +    /// Fails with [`EFAULT`] if size of `T` is bigger than pdu size.
> >> +    #[inline]
> >> +    pub fn read_pdu<T: FromBytes>(&self) -> Result<T> {
> >> +        // SAFETY: `self.inner` is guaranteed by the type invariant to point
> >> +        // to a live `io_uring_cmd`, so dereferencing is safe.
> >> +        let inner = unsafe { &mut *self.inner.get() };
> >> +
> >> +        let len = size_of::<T>();
> >> +        if len > inner.pdu.len() {
> >> +            return Err(EFAULT);
> >> +        }
> >> +
> >> +        let mut out: MaybeUninit<T> = MaybeUninit::uninit();
> >> +        let ptr = &raw mut inner.pdu as *const c_void;
> >> +
> >> +        // SAFETY:
> >> +        // * The `ptr` is valid pointer from `self.inner` that is guaranteed by type invariant.
> >> +        // * The `out` is valid pointer that points `T` which impls `FromBytes` and checked
> >> +        //   size of `T` is smaller than pdu size.
> >> +        unsafe {
> >> +            core::ptr::copy_nonoverlapping(ptr, out.as_mut_ptr().cast::<c_void>(), len);
> >> +        }
> >> +
> >> +        // SAFETY: The read above has initialized all bytes in `out`, and since `T` implements
> >> +        // `FromBytes`, any bit-pattern is a valid value for this type.
> >> +        Ok(unsafe { out.assume_init() })
> >> +    }
> >> +
> >> +    /// Writes the provided `value` to `pdu` in uring_cmd `self`
> >> +    ///
> >> +    /// Fails with [`EFAULT`] if size of `T` is bigger than pdu size.
> >> +    #[inline]
> >> +    pub fn write_pdu<T: AsBytes>(&mut self, value: &T) -> Result<()> {
> >> +        // SAFETY: `self.inner` is guaranteed by the type invariant to point
> >> +        // to a live `io_uring_cmd`, so dereferencing is safe.
> >> +        let inner = unsafe { &mut *self.inner.get() };
> >> +
> >> +        let len = size_of::<T>();
> >> +        if len > inner.pdu.len() {
> >> +            return Err(EFAULT);
> >> +        }
> >> +
> >> +        let src = (value as *const T).cast::<c_void>();
> >> +        let dst = &raw mut inner.pdu as *mut c_void;
> >> +
> >> +        // SAFETY:
> >> +        // * The `src` is points valid memory that is guaranteed by `T` impls `AsBytes`
> >> +        // * The `dst` is valid. It's from `self.inner` that is guaranteed by type invariant.
> >> +        // * It's safe to copy because size of `T` is no more than len of pdu.
> >> +        unsafe {
> >> +            core::ptr::copy_nonoverlapping(src, dst, len);
> >> +        }
> >> +
> >> +        Ok(())
> >> +    }
> >
> > pdu is part of IoUringCmd, which is live in the whole uring_cmd lifetime. But
> > both read_pdu()/write_pdu() needs copy to read or write any byte in the pdu, which
> > is slow and hard to use, it could be more efficient to add two methods to return
> > Result<&T> and Result<mut &T> for user to manipulate uring_cmd's pdu.
> 
> That can also be useful, but you do need to ensure that the pdu is
> aligned to at least the required alignment of `T` for this to be sound.

Yes, `IoUringCmd` is actually one C struct, so `T` is supposed to be `#[repr(C)]`
too, and the usage should be just like what io_uring_cmd_to_pdu() provides.

> I also don't follow your argument that reading & writing the pdu is
> slow.

Please look at how pdu is used in existing C users, such as, the tag field of
`pdu` can be read/write directly via:

	`io_uring_cmd_to_pdu(ioucmd, struct ublk_uring_cmd_pdu)->tag`

but read_pdu()/write_pdu() needs whole 32bytes copy for read/write any
single field.

User may only need to store single byte data in pdu...

Thanks,
Ming


