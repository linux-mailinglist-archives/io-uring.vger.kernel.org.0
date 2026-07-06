Return-Path: <io-uring+bounces-13898-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id H/09KEDnS2r7cQEAu9opvQ
	(envelope-from <io-uring+bounces-13898-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 06 Jul 2026 19:34:56 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 3721D713ED6
	for <lists+io-uring@lfdr.de>; Mon, 06 Jul 2026 19:34:56 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=q+PzQfMb;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13898-lists+io-uring=lfdr.de@vger.kernel.org" designates 172.232.135.74 as permitted sender) smtp.mailfrom="io-uring+bounces-13898-lists+io-uring=lfdr.de@vger.kernel.org";
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id A1482301A127
	for <lists+io-uring@lfdr.de>; Mon,  6 Jul 2026 17:34:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 890E73AF656;
	Mon,  6 Jul 2026 17:34:54 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FE7C3AEF4C
	for <io-uring@vger.kernel.org>; Mon,  6 Jul 2026 17:34:53 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783359294; cv=none; b=DGow7Cj5qeGeDq1vfCXXMxqkSna8rouBKcijBi4qA3Lv7LsdqZM2n8hpakkbOhOSe3DVkrSuanQJQFO5UzSov06tu7dBG/4ontKgaufp+YoLqCKoSPZCv1NZbS3hsw+nzE6vH5IkrLwcOu3PNDU+dPb9suWuhpYjmBnZI/eVSjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783359294; c=relaxed/simple;
	bh=GnGbPIB5vEGoh2+MT7DSP3FGysI2pjlO2rdd5C1mpW4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JUI1QRUlcmqNxzrvcoNWRqQ0BCaptV30hQUWwZco4u9l55lWxUsAIXsSrBftkNBnQV3F6QSG3IL04HTl3p0q+Ilh6HKF9ncj0I2u9ZBqSdAOFBvhwR98l+j7hjegCHr4U303xB1upsj3jKsqrN/+FuU0NMl6Gcqd8FlvWJfmdnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=q+PzQfMb; arc=none smtp.client-ip=209.85.214.180
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2cad8076b01so42748975ad.2
        for <io-uring@vger.kernel.org>; Mon, 06 Jul 2026 10:34:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783359293; x=1783964093; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=sP4hw4x9wC/jfaZoTNoWPTTQPTkbv3TV+M54+z0unKM=;
        b=q+PzQfMb4hYtRrFE6dR9Orgzcb9tOfNyttSOkTOh7nD0HLSAZ+vA12KKP4fzbGhJhy
         Op9IFOPRMbHqQwuxqBcAsYmkQDTadMu2omWLeO2pt+Ye42JMTw+TQHhLAqfJc3mOY2Oj
         wzkb1XBs/GKee3nJzVurNkDsHqGosjhnWwhvSEyIsmb3pq+Ywf9MM0k1pzR3EbXx9t3z
         bJlKkJeyVqPRjfsA2sbUkNIqkOyY6tSJB5R7z7lOvs8AX7MA3vlHI9TmEDleLvy0feCM
         orlQKU3T9WKrrKep0gKYega5s8s7D31ZUAAeica5sDQTGVF2xCZ1GMQVvkCjEP9Pnz8y
         QLQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783359293; x=1783964093;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sP4hw4x9wC/jfaZoTNoWPTTQPTkbv3TV+M54+z0unKM=;
        b=LHDX5at0l+bK5zK2Hl5KRskgFOT7YeORgZfb+PMPUYWX3dwUPRqbu5q6b5KOW5OIEK
         gofJAmEphqyjVKGIq4WQZIdUbv4HRtHWocGPQEa6fWOI7SfVIYw9xpxUUA5EjbAthpJg
         FoJQqzAaKtzfrq4L2Y6BoAaluyXUGu5x37iTnLB8fSUGq6oHsxRvHqn6Hdso1OBFYusZ
         qATkY/e/L8KqYn454fDcXCJ8i3KubtcQdvL/vCzVpapimk6pWOdmT4jsMPaNLOgxvZ3Q
         XvA1WrkL0JJBBm30Nd47v/85TwWD4motnG7Z50K00N6KUqQliutkw+xEpZILnIbJ7O6W
         Ev6A==
X-Forwarded-Encrypted: i=1; AHgh+RpSE+vAz3vmDG3PQR/Sdqc84JIw6crat4CqxBg0hmDN8Z/WjQiaLCnYY9POOkAeOf5UG43Oc/x5YA==@vger.kernel.org
X-Gm-Message-State: AOJu0YxjPhz+TiTkD7YVJslG3vvZTxxeSzycinEnxEKimZLv0WlHkq5A
	c1OFo14EMtLt7tc5KhSVNd7deUXrH3Q4jyIZldyOaEGxn/zPrj4A2UGC
X-Gm-Gg: AfdE7clChJ5O87po/yC2pyhUfx9QJMx6ge837SwOq2XGRutqs/xtARIy99harKjKu/5
	v4RkkjdCp2UYlaUJEE6ZXQyk+Zsdd5NlNIsrvI5hSb5N4a67FM2juKKtr8/vk7+8FkzXoh3xVAN
	0iW+s2SbcIaz+kpUys8uBkgaUJQsMHpCLwFQ809afF6hNb8xPsRWqxlf6KU1jKcQQxCxNot5Sx8
	2uODlVzgKwZozaNptZ+HIVRB0Li5dhW9l43DjGqZggwMVNfFnqvjgNSgN5x/WKZDMuPJCEg9M+H
	63RShWKkMQHAbVdUWFkjhrYFANBAz1BkOS5tu9EDbk3flMnRoQVm34bZNH47XjciKND1NQ4QiJN
	s1IOh7nbvsZgXptrDj9aL/uYHlgMY/xcGlLtm78h/3XsJiB1IC7P5mOF9LErroRV76Bm1J6NVsI
	Fxt7jDE0l6QGTYykdUxS6zULWTmtXMZn+Ef7tokUg=
X-Received: by 2002:a17:903:3550:b0:2ca:d666:df72 with SMTP id d9443c01a7336-2ccbec1e9f8mr16071265ad.21.1783359292584;
        Mon, 06 Jul 2026 10:34:52 -0700 (PDT)
Received: from naup-virtual-machine ([140.113.139.102])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cad6f260acsm54803395ad.6.2026.07.06.10.34.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jul 2026 10:34:52 -0700 (PDT)
Date: Tue, 7 Jul 2026 01:34:49 +0800
From: Hao-Yu Yang <naup96721@gmail.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: [PATCH v1] io_uring: fix dangling iovec after provided-buffer
 bundle grow failure
Message-ID: <akvnOaiLOvcHyalG@naup-virtual-machine>
References: <20260705234534.768138-1-naup96721@gmail.com>
 <0a370728-f8be-4aaa-bbc6-276376adc5ce@kernel.dk>
 <akvfYLvrpF5104us@naup-virtual-machine>
 <dbf0ae11-ce9a-4c98-bfcc-ff3f8f12b26f@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dbf0ae11-ce9a-4c98-bfcc-ff3f8f12b26f@kernel.dk>
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	MID_RHS_NOT_FQDN(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-13898-lists,io-uring=lfdr.de];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_RECIPIENTS(0.00)[m:axboe@kernel.dk,m:linux-kernel@vger.kernel.org,m:io-uring@vger.kernel.org,s:lists@lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_SENDER(0.00)[naup96721@gmail.com,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	FORGED_SENDER_FORWARDING(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[naup96721@gmail.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[gmail.com:+];
	ALIAS_RESOLVED(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	FREEMAIL_FROM(0.00)[gmail.com];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[vger.kernel.org:from_smtp,sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,naup-virtual-machine:mid]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 3721D713ED6

On Mon, Jul 06, 2026 at 11:13:55AM -0600, Jens Axboe wrote:
> On 7/6/26 11:01 AM, Hao-Yu Yang wrote:
> > Sorry, i forgot to cc others mail
> > 
> > I discovered and wrote the PoC myself. Trigger way is
> >  send1: Submit an IORING_OP_SEND request with four valid
> >  provided buffers. The system will allocate and cache an
> >  iovec array (of size 4) for this request and store the
> >  pointer in kmsg->vec.iovec.
> > 
> >  send2: Submit a second send request with 8, and I set
> >  the fourth passed-in address to point to an invalid address.
> >  Now kmsg still hold old iovec, but old iovec object have
> >  been freed.
> > 
> >  So this will lead dangling pointer.
> 
> Side note: please don't top post, linux mailing lists always reply
> under the text for better readability. Top posting turns any kind
> of threaded conversation into both a mess, and it's also wasteful.
> 
> Great thanks! Want to turn this into a liburing test case? Then we can
> include it there as well, and it'd catch both UAF and memory leaks when
> run.
> 
> -- 
> Jens Axboe

How to turn this into a liburing test case? Should this be included in the v2 patch?

