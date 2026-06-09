Return-Path: <io-uring+bounces-13653-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id XMa3ARtFKGp9BQMAu9opvQ
	(envelope-from <io-uring+bounces-13653-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 09 Jun 2026 18:53:47 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 5AD72662A48
	for <lists+io-uring@lfdr.de>; Tue, 09 Jun 2026 18:53:46 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=icXC3Fgh;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13653-lists+io-uring=lfdr.de@vger.kernel.org" designates 172.234.253.10 as permitted sender) smtp.mailfrom="io-uring+bounces-13653-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 620AF3396CF2
	for <lists+io-uring@lfdr.de>; Tue,  9 Jun 2026 16:22:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 166D13AEF5F;
	Tue,  9 Jun 2026 16:20:52 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C43A83AEF30
	for <io-uring@vger.kernel.org>; Tue,  9 Jun 2026 16:20:50 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781022052; cv=none; b=ufNdkOvMiJBe4Koif3jotogPpODnr1TGpBOAeZY6UJH+MKOhU02v1gqUQPKfH7mOMwXfq27VQENVy0RTkiULEaPa3cFrnvRSx+/oRmylmV2Kej+5aKesxUOaLYazuFHcckTk3v7Z7KYA9cMo4snpucax6C5SuZlAeN/Hecpkd8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781022052; c=relaxed/simple;
	bh=kdzjhGbLB/20GSErxZ1mVIgUWD0e739DSeSt3mySW70=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KO05Ruawg/3aIWLeGFmxaKSQhD/OlxW1oCkARW2AaG+OubsN2Zag4QjvaMxIDgrlRlIPDGF+wExwFTpEjDryqj53XdmnIwyoUbstBSWFY6APQl3ZSbi92oAvn7uZbfbxiwXsEclTc6S7Fmmr84fYcikU+w0r6Ypm/GD+ldgQIyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=icXC3Fgh; arc=none smtp.client-ip=170.10.129.124
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1781022049;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oQTypC+zUo+gB9LA59kpzVIAOOhzbl/lP+y21Fa313o=;
	b=icXC3FghM5ZKnDJDnEw891ytqJXQrTH9/AoSvPzemg5lv27oli4XggbDA1/W7WGrPfxIhh
	rnyW0F+pYRMXxbXoGnp6E0Rx24yRKDG8JJ7pxv6iFIaMNojLugyLtd5PFhwQybTiugKNB2
	AqvWlziR6BQ2HX4A7KpU0jhUTX/yibw=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-679-Qh-hSxSlPOiKJiFO7uVcJA-1; Tue,
 09 Jun 2026 12:20:46 -0400
X-MC-Unique: Qh-hSxSlPOiKJiFO7uVcJA-1
X-Mimecast-MFC-AGG-ID: Qh-hSxSlPOiKJiFO7uVcJA_1781022043
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0D239180AC70;
	Tue,  9 Jun 2026 16:20:42 +0000 (UTC)
Received: from bfoster (unknown [10.22.80.93])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3EAA01956053;
	Tue,  9 Jun 2026 16:20:40 +0000 (UTC)
Date: Tue, 9 Jun 2026 12:20:38 -0400
From: Brian Foster <bfoster@redhat.com>
To: Eric Hagberg <ehagberg@janestreet.com>
Cc: Gregg Leventhal <gleventhal@janestreet.com>, hch@infradead.org,
	djwong@kernel.org, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>, stable@vger.kernel.org
Subject: Re: [BUG] iomap/io_uring: O_APPEND async buffered write silently
 re-appends a data chunk (corruption) on XFS, 6.1.y/6.12.y
Message-ID: <aig9Vm2a_13bPc5G@bfoster>
References: <CAFN_u7FrgM4Dzie2jjkLwWV8P0dvUG_Wwy3Q9B3-2HnnWiDu8w@mail.gmail.com>
 <aiLxe-9Sub8cI3Py@bfoster>
 <aibns0xP6IVVNWh3@bfoster>
 <CAAH4uRB+Bh9UEVEW8Sb2yM4YhB-Q5UJ6KJJXari3DDF3n3S+-g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAAH4uRB+Bh9UEVEW8Sb2yM4YhB-Q5UJ6KJJXari3DDF3n3S+-g@mail.gmail.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Rspamd-Action: no action
X-Spamd-Result: default: False [2.34 / 15.00];
	MID_END_EQ_FROM_USER_PART(4.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	MID_RHS_NOT_FQDN(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13653-lists,io-uring=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:ehagberg@janestreet.com,m:gleventhal@janestreet.com,m:hch@infradead.org,m:djwong@kernel.org,m:linux-xfs@vger.kernel.org,m:linux-fsdevel@vger.kernel.org,m:io-uring@vger.kernel.org,m:axboe@kernel.dk,m:stable@vger.kernel.org,s:lists@lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_SENDER(0.00)[bfoster@redhat.com,io-uring@vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	FORWARDED(0.00)[lists@lfdr.de];
	DKIM_TRACE(0.00)[redhat.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[bfoster@redhat.com,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[9];
	TO_DN_SOME(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[vger.kernel.org:from_smtp,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,bfoster:mid]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 5AD72662A48

On Mon, Jun 08, 2026 at 01:17:10PM -0400, Eric Hagberg wrote:
> On Mon, Jun 8, 2026 at 12:03 PM Brian Foster <bfoster@redhat.com> wrote:
> > Another idea that came to mind is to try and just replace the -EAGAIN
> > return sequence from the low level iterator with a flag that triggers
> > -EAGAIN from the next iter advance. The idea here is to allow the write
> > to return partial completion (i.e. so no iov_iter revert) without having
> > to return an error from the lowest level in the stack. I had claude come
> > up with a quick patch [1] for reference/experimentation.
> >
> > This is based on v6.12 stable and compile tested only. It needs more
> > review and testing in general but might be worth throwing your
> > reproducer at if you can..?
> 
> With that patch applied, the reproducer runs clean - no errors - and
> gets roughly the same performance (maybe slightly better) as when run
> against a 6.18 kernel on the same VM.
> 

Thanks for testing. I'll look into some more regression testing of this
patch and try to clean it up and post it for proper review for stable.

Are you using the reproducer program in your original mail to test? If
so, does it require some concurrent memory pressure to reproduce, and
are you using anything in particular for that?

That test seems small enough that we could potentially include it in
fstests, though I'm still not so sure about the mem pressure part..
Since you guys wrote the test, any interest in porting into fstests? If
not I can look into it.

Brian

> Thanks,
> -Eric
> 


