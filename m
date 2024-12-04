Return-Path: <io-uring+bounces-5205-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A0379E3F8D
	for <lists+io-uring@lfdr.de>; Wed,  4 Dec 2024 17:25:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BE2EC2818FD
	for <lists+io-uring@lfdr.de>; Wed,  4 Dec 2024 16:25:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 281D420ADCB;
	Wed,  4 Dec 2024 16:25:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="EkAml4HD"
X-Original-To: io-uring@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D5E420CCC8;
	Wed,  4 Dec 2024 16:25:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733329526; cv=none; b=GhsKecNN/CBtSTavmHHau5Q613cVWnHt3uj/MGPaiTG3DJIVsnfHEcBPMq0wUMsn9NuzFNV2zcAQ8un1n3pYmX4/TO4zUOf3s5QJRi1x3WxCOLiPZq8bZrKpVOX2pjg3lDi3mwtG7+WOws2+EfvRhmnhuy8EZ7P83JuVu3PkGkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733329526; c=relaxed/simple;
	bh=J0NkytdeoSDuYK02EGcBE+sEaWUWn9wKPlUOOeTyzhs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YkQ+NvstCLfwjGk+UtsCeB5GvJ0R4fZ6EbwB8DUF6FIZ9HdHtVva7p7WVZG9scLR/jgJiiaFW1SKIU3xfJ53zMsJg3wp/F6DVYdoTcE7C0mH/03WCb/8FB8lZzFmBQbxRhWXMK8r080EdNPsMtJLnOHrG29GrzJ9XYJs9nVdbrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=EkAml4HD; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=tnChT+DuHDBrgRdPGMFu9O3S0vDozFvAcTxya8Mah08=; b=EkAml4HDHQeTM3S4ksspHSqI8V
	9cFfB11GrmxwQkmfOEMi2i2TgvicxvqYQqUOhH2dih+gHtguzxJqv2uqChF6piP6kwRXdI9aF8zA/
	v84rDyJJ05mN/MqBOHPLQcxYQworusOLBYA1Ru3hJNIdUSfd/Sx4ni5i5ESKMdWa69omqGqFxqjBN
	q84ZnqCC90vda5XOmCWnaesmuhsIkjRZTloYUlu8IuuFXecwe3BrmnGTH1+u8IK3oaaLrDKs0Fw60
	DU9JWhAGsNHsOYUGVKtWMJzeOeG3ugvxBhVznCxA/agYVqLZDILr38kDuFSUuYIEw8OtBRFLpCH0C
	XJ1WFfmQ==;
Received: from willy by casper.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tIsBk-0000000BdtE-0GgU;
	Wed, 04 Dec 2024 16:25:20 +0000
Date: Wed, 4 Dec 2024 16:25:19 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Tamir Duberstein <tamird@gmail.com>,
	syzbot <syzbot+092bbab7da235a02a03a@syzkaller.appspotmail.com>,
	asml.silence@gmail.com, io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [syzbot] [io-uring?] KASAN: null-ptr-deref Write in
 sys_io_uring_register
Message-ID: <Z1CCbyZVOXQRDz_2@casper.infradead.org>
References: <67505f88.050a0220.17bd51.0069.GAE@google.com>
 <6be84787-b1d9-4a20-85f3-34d8d9a0d492@kernel.dk>
 <a41eb55f-01b3-4388-a98c-cc0de15179bd@kernel.dk>
 <CAJ-ks9kN_qddZ3Ne5d=cADu5POC1rHd4rQcbVSD_spnZOrLLZg@mail.gmail.com>
 <1ab4e254-0254-4089-888b-2ec2ce152302@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1ab4e254-0254-4089-888b-2ec2ce152302@kernel.dk>

On Wed, Dec 04, 2024 at 09:17:27AM -0700, Jens Axboe wrote:
> >   XA_STATE(xas, xa, index);
> > - return xas_result(&xas, xas_store(&xas, NULL));
> > + return xas_result(&xas, xa_zero_to_null(xas_store(&xas, NULL)));
> >  }
> >  EXPORT_SYMBOL(__xa_erase);
> > 
> > This would explain deletion of a reserved entry returning
> > `XA_ZERO_ENTRY` rather than `NULL`.
> 
> Yep this works.
> 
> > My apologies for this breakage. Should I send a new version? A new
> > "fixes" patch?
> 
> Since it seems quite drastically broken, and since it looks like Andrew
> is holding it, seems like the best course of action would be to have it
> folded with the existing patch.

... and please include an addition to the test-suite that would catch
this bug.

Wait, why doesn't this one catch it?  You did run the test-suite, right?

        /* xa_insert treats it as busy */
        XA_BUG_ON(xa, xa_reserve(xa, 12345678, GFP_KERNEL) != 0);
        XA_BUG_ON(xa, xa_insert(xa, 12345678, xa_mk_value(12345678), 0) !=
                        -EBUSY);
        XA_BUG_ON(xa, xa_empty(xa));
        XA_BUG_ON(xa, xa_erase(xa, 12345678) != NULL);
        XA_BUG_ON(xa, !xa_empty(xa));


