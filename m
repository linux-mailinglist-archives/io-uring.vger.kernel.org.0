Return-Path: <io-uring+bounces-13228-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IDDbBq+M+GkHwgIAu9opvQ
	(envelope-from <io-uring+bounces-13228-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 04 May 2026 14:10:23 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id AC3464BCC20
	for <lists+io-uring@lfdr.de>; Mon, 04 May 2026 14:10:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 054563015441
	for <lists+io-uring@lfdr.de>; Mon,  4 May 2026 12:10:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F4033CE4BA;
	Mon,  4 May 2026 12:10:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G7Bvhdu/"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0BC93B9600
	for <io-uring@vger.kernel.org>; Mon,  4 May 2026 12:10:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777896620; cv=none; b=l4fjop82W+KEhB7T0oMwDnvq4IqA9EcjXpqF7vFUYyziuyMZC3ojvRYRkYbU3QvLFZYmeWI+po6ba3p7Pg1ZsutsvuzJhmdr+BCziTh8EZAlZVwK/4MgLlUn0A+93A/Zc6JA5Wuu1xg/qGthoab6qOcONmc/CtVnMve4RSxjpvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777896620; c=relaxed/simple;
	bh=0Wm6CLOEwddQc/Sf73RpwZP5AUTVDaSUAbK5avJdtZU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RWOw36++Vm5zifRZHnkox7EjKwwhUS8FFUxWpFfWEo6RfxqsN33Z9ZoWWQ1SSySVl9N+lAqGkb3PzFLoVrwS3AmZbp97+7v0mcO5ia1s43EZdiNLqiCM9KszikeHKlVOZG3QUcjGfFSzx3XHesHYfUszVCFVYtcgtmHkkZOwZQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G7Bvhdu/; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66AB3C2BCB8;
	Mon,  4 May 2026 12:10:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777896619;
	bh=0Wm6CLOEwddQc/Sf73RpwZP5AUTVDaSUAbK5avJdtZU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=G7Bvhdu/Dc/1osIuva33mELVFQ8pNenlTxQ9mrrXAkT6H4pNteGiBT4FX/B0RJGfG
	 eMZ+MtO02UHgJ8YFVMGlRqub8NsYqVFzmlr28tEKyaPCsD8RI8Sm5BepwLCXd+2TnO
	 tyPSeYXc6oWVAl+TbIK3baf3S/bshqrML2ypTSQs=
Date: Mon, 4 May 2026 14:10:17 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Carlo Conti <carlottoconti344@gmail.com>
Cc: axboe@kernel.dk, io-uring@vger.kernel.org
Subject: Re: [SECURITY] io_uring UAF: io_uring_cmd_issue_blocking missing sqe
 copy before RESIZE_RINGS
Message-ID: <2026050401-juniper-undocked-190c@gregkh>
References: <CAAiJJe3rVHjEO6yZ=w6S0igYFE8ROBay+An7PnuMX0KndxwXOg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAiJJe3rVHjEO6yZ=w6S0igYFE8ROBay+An7PnuMX0KndxwXOg@mail.gmail.com>
X-Rspamd-Queue-Id: AC3464BCC20
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [2.34 / 15.00];
	MID_END_EQ_FROM_USER_PART(4.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[linuxfoundation.org,none];
	MID_RHS_NOT_FQDN(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[linuxfoundation.org:s=korg];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13228-lists,io-uring=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	FREEMAIL_TO(0.00)[gmail.com];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	NEURAL_HAM(-0.00)[-0.999];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[gregkh@linuxfoundation.org,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[linuxfoundation.org:+];
	TAGGED_RCPT(0.00)[io-uring];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,linuxfoundation.org:dkim]

On Mon, May 04, 2026 at 01:59:01PM +0200, Carlo Conti wrote:
> Hello,
> 
> I have identified a Use-After-Free vulnerability in the Linux kernel
> io_uring subsystem, confirmed on Linux 6.19.11.

That is an unsupported and obsolete kernel version, does this happen on
the latest 7.0 release?

And can you provide a patch to fix this issue as you seem to be able to
test this?

Also, you sent this to a public mailing list, so I'll take security@k.o
off the response now as it's not needed.

thanks,

greg k-h

