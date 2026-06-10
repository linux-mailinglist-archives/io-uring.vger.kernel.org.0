Return-Path: <io-uring+bounces-13661-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id WL0nDx6gKWp0awMAu9opvQ
	(envelope-from <io-uring+bounces-13661-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 10 Jun 2026 19:34:22 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A295A66BF9F
	for <lists+io-uring@lfdr.de>; Wed, 10 Jun 2026 19:34:21 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=NHUzFGRI;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13661-lists+io-uring=lfdr.de@vger.kernel.org" designates 2600:3c04:e001:36c::12fc:5321 as permitted sender) smtp.mailfrom="io-uring+bounces-13661-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 854B1302DF87
	for <lists+io-uring@lfdr.de>; Wed, 10 Jun 2026 17:34:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3832D343896;
	Wed, 10 Jun 2026 17:34:19 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA8FE32E143
	for <io-uring@vger.kernel.org>; Wed, 10 Jun 2026 17:34:17 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781112859; cv=none; b=kxzirdGuNhhRjTNof7GbTUsLH/EC37vvm9CRbOqNBdvTU6zYLWM0sCG5r+MSCrBH+v9/HQGBVhmSbJqG2VnBvsDFP1ANdJIAVqglhxF/QWnyxZhNqP2bwM/p60rP/14NAL7q3U5OL7uOlCqnKfxrqBT0Ad+ae5xGkgYSGnRJmto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781112859; c=relaxed/simple;
	bh=hvqgbsrBRXUaMJphi0xOHdhb/O3o5jtTUlIvVUaKvR4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uiRG3QPd1QE74g8P7gdthYDCD6ivjIk4jCkbMuTQLSDQQ5OoYu1qNtWd3GOACwLKNSbXaoWZ3FzAiSwT2Mjhv0Jl9+mmWJOu0paHEFvTIKZfxsOu38JTkp08gdxmwmm0CzUzPxDyLV8NE8MMnRApVTlqh3L8dmftqDP5ToB88AY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NHUzFGRI; arc=none smtp.client-ip=170.10.129.124
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1781112856;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=u5lOfnqz6cdvQq+455ibVbtGRpcoEQAcIdcUZsugK+8=;
	b=NHUzFGRI7T/vQJccUvQgrvAV44Y4IJL1a34x0kMlPoSAfIPrvCRATWP7urob06Gb9uPblb
	0/O0dNf0xNS8kzcTxO3xXcAF0XbR3rUtBBKNEOoFSrH4dPkpa6V3cFycxuL6STrI/I6bcN
	h2/qIf611xF7uGchZ/f3cLfI5sX1kX8=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-49-bvmQV3fVPWK-8eCh33Dk7w-1; Wed,
 10 Jun 2026 13:34:13 -0400
X-MC-Unique: bvmQV3fVPWK-8eCh33Dk7w-1
X-Mimecast-MFC-AGG-ID: bvmQV3fVPWK-8eCh33Dk7w_1781112851
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E380D1964CE4;
	Wed, 10 Jun 2026 17:34:10 +0000 (UTC)
Received: from bfoster (unknown [10.22.80.93])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8AE271800586;
	Wed, 10 Jun 2026 17:34:08 +0000 (UTC)
Date: Wed, 10 Jun 2026 13:34:06 -0400
From: Brian Foster <bfoster@redhat.com>
To: Gregg Leventhal <gleventhal@janestreet.com>
Cc: Eric Hagberg <ehagberg@janestreet.com>, hch@infradead.org,
	djwong@kernel.org, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>, stable@vger.kernel.org
Subject: Re: [BUG] iomap/io_uring: O_APPEND async buffered write silently
 re-appends a data chunk (corruption) on XFS, 6.1.y/6.12.y
Message-ID: <aimgDnzB_NYqOTx1@bfoster>
References: <CAFN_u7FrgM4Dzie2jjkLwWV8P0dvUG_Wwy3Q9B3-2HnnWiDu8w@mail.gmail.com>
 <aiLxe-9Sub8cI3Py@bfoster>
 <aibns0xP6IVVNWh3@bfoster>
 <CAAH4uRB+Bh9UEVEW8Sb2yM4YhB-Q5UJ6KJJXari3DDF3n3S+-g@mail.gmail.com>
 <aig9Vm2a_13bPc5G@bfoster>
 <CAFN_u7ELBj3YKncm6HA4-QUNyi-a3qPDEYxuLP+skVhm-r87uw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAFN_u7ELBj3YKncm6HA4-QUNyi-a3qPDEYxuLP+skVhm-r87uw@mail.gmail.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Rspamd-Action: no action
X-Spamd-Result: default: False [2.34 / 15.00];
	MID_END_EQ_FROM_USER_PART(4.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	MID_RHS_NOT_FQDN(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13661-lists,io-uring=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:gleventhal@janestreet.com,m:ehagberg@janestreet.com,m:hch@infradead.org,m:djwong@kernel.org,m:linux-xfs@vger.kernel.org,m:linux-fsdevel@vger.kernel.org,m:io-uring@vger.kernel.org,m:axboe@kernel.dk,m:stable@vger.kernel.org,s:lists@lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_SENDER(0.00)[bfoster@redhat.com,io-uring@vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	FORWARDED(0.00)[lists@lfdr.de];
	DKIM_TRACE(0.00)[redhat.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[vger.kernel.org:from_smtp,tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo,bfoster:mid]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: A295A66BF9F

On Tue, Jun 09, 2026 at 01:14:40PM -0400, Gregg Leventhal wrote:
> I reproduce it by running 25 ~ concurrent instances of the attached reproducer,
> each writing its own file, on an otherwise-idle 15 GB VM:
> 
>   DIR=$(mktemp -d /tmp/uring.XXXXXX)
>   for i in {1..25}; do
>       ./repro_uring_dup "$DIR/file_$i" 120 48 &
>   done
> ...
> *** CORRUPTION DETECTED in /tmp/UmgK/file_17.1 ***
>   bytes kernel said it wrote (sum of CQE results): 53621960
>   actual file size:                                56218824
>   extra (duplicated) bytes:                        2596864
>   first mismatching offset: 6791168 (0x67a000)  page_aligned=YES
>     expected u64 848896 but found 524288 (content from byte offset
> 4194304 reappeared here)
>   (file kept for inspection)
> 
> 
> 
>   wait
> 
> *** CORRUPTION DETECTED in /tmp/Gznx/file_18.2 ***
>   bytes kernel said it wrote (sum of CQE results): 58112616
>   actual file size:                                60303976
>   extra (duplicated) bytes:                        2191360
>   first mismatching offset: 2191360 (0x217000)  page_aligned=YES
>     expected u64 273920 but found 0 (content from byte offset 0 reappeared here)
>   (file kept for inspection)
> 

Thanks. I had to bump up the concurrency a bit and then was able to
reproduce.

The patch I sent survived my regression testing but when taking another
look at the upstream patch, I realized something else I had previously
missed. The code in master doesn't actually return -EAGAIN directly
along with partial completion. It just returns the partial completion,
loops again in iomap, and then presumably returns -EAGAIN at that point
which makes its way back to io_uring. I think that is mostly harmless
but technically a bug in the upstream patch as the intent was to be able
to advance the iter, return -EAGAIN, and let the operation unwind from
there.

I think this actually leaves at least a couple options here. One is that
we could presumably just do the same thing on stable as current master:
forget the flag and just remove the iov revert and direct -EAGAIN return
at the cost of one more iter before returning to the caller. Another is
to fix up the code in master and use the patch I posted as a customized
stable backport of that.

WRT the latter I suppose we could also just stick with this patch for
stable and I can follow up with a separate patch for the loop thing on
master. Hmm.. I want to think about it a little more so if any iomap
folks have Opinions in the meantime, let me know.

Brian

> 
> On Tue, Jun 9, 2026 at 12:20 PM Brian Foster <bfoster@redhat.com> wrote:
> >
> > On Mon, Jun 08, 2026 at 01:17:10PM -0400, Eric Hagberg wrote:
> > > On Mon, Jun 8, 2026 at 12:03 PM Brian Foster <bfoster@redhat.com> wrote:
> > > > Another idea that came to mind is to try and just replace the -EAGAIN
> > > > return sequence from the low level iterator with a flag that triggers
> > > > -EAGAIN from the next iter advance. The idea here is to allow the write
> > > > to return partial completion (i.e. so no iov_iter revert) without having
> > > > to return an error from the lowest level in the stack. I had claude come
> > > > up with a quick patch [1] for reference/experimentation.
> > > >
> > > > This is based on v6.12 stable and compile tested only. It needs more
> > > > review and testing in general but might be worth throwing your
> > > > reproducer at if you can..?
> > >
> > > With that patch applied, the reproducer runs clean - no errors - and
> > > gets roughly the same performance (maybe slightly better) as when run
> > > against a 6.18 kernel on the same VM.
> > >
> >
> > Thanks for testing. I'll look into some more regression testing of this
> > patch and try to clean it up and post it for proper review for stable.
> >
> > Are you using the reproducer program in your original mail to test? If
> > so, does it require some concurrent memory pressure to reproduce, and
> > are you using anything in particular for that?
> >
> > That test seems small enough that we could potentially include it in
> > fstests, though I'm still not so sure about the mem pressure part..
> > Since you guys wrote the test, any interest in porting into fstests? If
> > not I can look into it.
> >
> > Brian
> >
> > > Thanks,
> > > -Eric
> > >
> >
> 


