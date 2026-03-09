Return-Path: <io-uring+bounces-12609-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QEMQJppBr2mYSwIAu9opvQ
	(envelope-from <io-uring+bounces-12609-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 09 Mar 2026 22:54:34 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id A6889241F42
	for <lists+io-uring@lfdr.de>; Mon, 09 Mar 2026 22:54:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id C99133009399
	for <lists+io-uring@lfdr.de>; Mon,  9 Mar 2026 21:54:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C993A36C0BB;
	Mon,  9 Mar 2026 21:54:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ciDFF7Aw"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7A78368264
	for <io-uring@vger.kernel.org>; Mon,  9 Mar 2026 21:54:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773093264; cv=none; b=IdWVg64T+W6zSrvk5VY9u5K+HBZRUK0j1sTqpk7G+2UAzGfIhCXa6zx+VjSUPc8HF+sn3BKGQ8jdm9qqH5PnskCZoMJo/TnGAF2xS/JahOqYjp9A/HF60luefuQaXwE2zcjOKQIuAjzKwxS3hLCLydlNtWITJ0LIRVdZICfr9Jw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773093264; c=relaxed/simple;
	bh=ubkZCPrm0zH5k6WzWUsnR6syFajk3pX3GyPLdc9lkws=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iS/13GCdGRjT2btWqvghB1F3UmotpSR8EhjM34vGxI1pTwfoPZOwmOtAVgiRwbFffhUkIhJhjfw3dXLN3RYY8NK8PWseT4bWuWtDdOg2QGVXcaBv8GrIzMeIaWkbHmOuYw3fASCm9B5vxB7xNqAVzsH4daJR2hIN4+/t/PyjTZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ciDFF7Aw; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13716C4CEF7;
	Mon,  9 Mar 2026 21:54:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773093264;
	bh=ubkZCPrm0zH5k6WzWUsnR6syFajk3pX3GyPLdc9lkws=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ciDFF7AweC7PW+CTIoUpNm5bU1quNVG9U7dRoVMvOGc9LgXRpkLvj/6LsF6/iWbX7
	 rcduLiFY3kS+HGk2ahXPY9tuR17vsXaZBN0dKlqSx6HGWqh31Pyepj7xn51Trpz/bl
	 oYTRPUSG91SSaVqtLBxZCCyQa8JSUuRb1TFRtfShjEFUKgwpPrFg+SXiI4i1pNH9Z6
	 scge+fgGoG2mQUoSSBqMo8qpR4lzWAPd68EHsvhOGVwm4B2fY401ziyudGM/SlP6r4
	 HKZ3KShiJY548jzHfXdR1ZsEaUJUDtfO4oqjYW6yDUWFndFBXNvzLXMQ8cfRxpo4F2
	 yHstO34jMSo/g==
Date: Mon, 9 Mar 2026 15:54:21 -0600
From: Keith Busch <kbusch@kernel.org>
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: Tom Ryan <ryan36005@gmail.com>, io-uring@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>, Greg KH <gregkh@linuxfoundation.org>
Subject: Re: io_uring: OOB read in SQE_MIXED mode via sq_array physical index
 bypass
Message-ID: <aa9Bjbplx3b_Uvmj@kbusch-mbp>
References: <CAJuauuPNcDAAzjzVjOE_sNcUT5FX6dwcV9o=hLC6ZaQkkZ72Pg@mail.gmail.com>
 <aa871Xk0EHzDxOd6@kbusch-mbp>
 <CADUfDZpQ9=ZMR0kWzX_o3CT4G=9vGp2zsL_KKdPs6tUpG00c5A@mail.gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CADUfDZpQ9=ZMR0kWzX_o3CT4G=9vGp2zsL_KKdPs6tUpG00c5A@mail.gmail.com>
X-Rspamd-Queue-Id: A6889241F42
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12609-lists,io-uring=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,vger.kernel.org,kernel.dk,linuxfoundation.org];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	NEURAL_HAM(-0.00)[-0.998];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[kbusch@kernel.org,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel.org:+];
	TAGGED_RCPT(0.00)[io-uring];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:rdns,sin.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Mon, Mar 09, 2026 at 02:45:59PM -0700, Caleb Sander Mateos wrote:
> On Mon, Mar 9, 2026 at 2:34 PM Keith Busch <kbusch@kernel.org> wrote:
> >
> > On Mon, Mar 09, 2026 at 02:20:38PM -0700, Tom Ryan wrote:
> > > Patch attached.
> >
> > You can just submit the patch as text in the mail message.
> >
> > > @@ -1747,6 +1747,9 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
> > >               if (!(ctx->flags & IORING_SETUP_SQE_MIXED) || *left < 2 ||
> > >                   !(ctx->cached_sq_head & (ctx->sq_entries - 1)))
> > >                       return io_init_fail_req(req, -EINVAL);
> > > +             /* Validate physical SQE index has room for 128-byte read */
> > > +             if ((unsigned)(sqe - ctx->sq_sqes) >= ctx->sq_entries - 1)
> > > +                     return io_init_fail_req(req, -EINVAL);
> >
> > Isn't this new check redundant with the "left < 2" check preceding it?
> 
> I think it's orthogonal with *left < 2. How many SQEs are remaining to
> submit is unrelated to the index of each SQE. It is, however,
> redundant with !(ctx->cached_sq_head & (ctx->sq_entries - 1)), but
> only in the IORING_SETUP_NO_SQARRAY case. For
> non-IORING_SETUP_NO_SQARRAY rings, the SQ indirection array entry can
> point to the last entry of the SQE array, causing the big SQE to
> extend past the end. Probably, this added condition can replace
> !(ctx->cached_sq_head & (ctx->sq_entries - 1)). That checks whether
> this is the last entry *in the SQ indirection array*, but it should be
> checking the SQE array.

Oh, right. The left < 2 was to confirm we have contiguous entries for a
big sqe, but you could index to an unaligned end with the sqarray.

Folding this into the previous 'if' sounds good. And please consider an
addition to liburing tests.

