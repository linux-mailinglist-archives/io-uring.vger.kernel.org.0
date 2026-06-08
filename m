Return-Path: <io-uring+bounces-13645-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id YdSENWP6JmpnpAIAu9opvQ
	(envelope-from <io-uring+bounces-13645-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 08 Jun 2026 19:22:43 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 4CCBF6592F2
	for <lists+io-uring@lfdr.de>; Mon, 08 Jun 2026 19:22:43 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=e93lJ4K7;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13645-lists+io-uring=lfdr.de@vger.kernel.org" designates 2600:3c0a:e001:db::12fc:5321 as permitted sender) smtp.mailfrom="io-uring+bounces-13645-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 96CFD3349237
	for <lists+io-uring@lfdr.de>; Mon,  8 Jun 2026 16:03:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B0AE3314D2;
	Mon,  8 Jun 2026 16:03:12 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 807D432FA3C
	for <io-uring@vger.kernel.org>; Mon,  8 Jun 2026 16:03:09 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780934591; cv=none; b=DKhqAb9zuL9gxyXCOQFJL1Wth81R1yZS5eYaCl779OCOZMO5tds++0WhRpXMGxqsm7gAMW1MfltSUCdFpd01fDM5bY/b3srNVsZtkR8idOiHU9AqU4Jih9xG0dfYK0u1EtuAZn2+1iy6gUSN2k5R9SABd5EcLyNxZ/EG2ZTd83A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780934591; c=relaxed/simple;
	bh=3OEYPQ0LuldlA4kK0ltSgEasEnp1AHL6R+Hk8t53mTc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oSnIoGUAL8Sb/JGj+RrreRGBHMGWYQLF2y05+VdEBkcgLk2TvIGOCFS/8lvq/VzzGGpcssh0q1+ZxRB147cQ48C6uxSTuD72x32jTz2z7zUpSgXisGOOOqo1wVNoWHRILrJSfV4QEbpXmBwgY9aCi7h7leZgrQYMMEoGb/JfdWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=e93lJ4K7; arc=none smtp.client-ip=170.10.129.124
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780934588;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=EDh9iLkNa5MgatT3zv9wGFe3hH6UdmFTOJoPoHnhCQY=;
	b=e93lJ4K7EgKIYltpS5jNGVYJivkX6260ElFTZVRIfymZTG6/IsAwKmy6c69A39kgFFDr1O
	s5/55xPuMFJfjUg10O/2/mV7ULuiEG3mPLpatZb5xEkR0BI3nuFYC0dWpbcFUHT+Y+0h0V
	PSUdXqsJrprls2lquzE4q5HSyOfLIlw=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-493-qfFibvlWP7e46SMOpHdpkg-1; Mon,
 08 Jun 2026 12:03:05 -0400
X-MC-Unique: qfFibvlWP7e46SMOpHdpkg-1
X-Mimecast-MFC-AGG-ID: qfFibvlWP7e46SMOpHdpkg_1780934583
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4A2C71800605;
	Mon,  8 Jun 2026 16:03:03 +0000 (UTC)
Received: from bfoster (unknown [10.22.80.93])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 85CE11955BE0;
	Mon,  8 Jun 2026 16:03:01 +0000 (UTC)
Date: Mon, 8 Jun 2026 12:02:59 -0400
From: Brian Foster <bfoster@redhat.com>
To: Gregg Leventhal <gleventhal@janestreet.com>
Cc: hch@infradead.org, djwong@kernel.org,
	Eric Hagberg <ehagberg@janestreet.com>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>, stable@vger.kernel.org
Subject: Re: [BUG] iomap/io_uring: O_APPEND async buffered write silently
 re-appends a data chunk (corruption) on XFS, 6.1.y/6.12.y
Message-ID: <aibns0xP6IVVNWh3@bfoster>
References: <CAFN_u7FrgM4Dzie2jjkLwWV8P0dvUG_Wwy3Q9B3-2HnnWiDu8w@mail.gmail.com>
 <aiLxe-9Sub8cI3Py@bfoster>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aiLxe-9Sub8cI3Py@bfoster>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Rspamd-Action: no action
X-Spamd-Result: default: False [2.34 / 15.00];
	MID_END_EQ_FROM_USER_PART(4.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	MID_RHS_NOT_FQDN(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13645-lists,io-uring=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:gleventhal@janestreet.com,m:hch@infradead.org,m:djwong@kernel.org,m:ehagberg@janestreet.com,m:linux-xfs@vger.kernel.org,m:linux-fsdevel@vger.kernel.org,m:io-uring@vger.kernel.org,m:axboe@kernel.dk,m:stable@vger.kernel.org,s:lists@lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_SENDER(0.00)[bfoster@redhat.com,io-uring@vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	FORWARDED(0.00)[lists@lfdr.de];
	DKIM_TRACE(0.00)[redhat.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[vger.kernel.org:from_smtp,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 4CCBF6592F2

On Fri, Jun 05, 2026 at 11:55:39AM -0400, Brian Foster wrote:
...
> 
> One thing I might try here is to see if just deferring append writes to
> !NOWAIT context avoids this problem because I wonder how sane that sort
> of retry situation really is. I'm not quite sure what the expectations
> are in that sort of case. Is that something that's easy to test? Of
> course that wouldn't prevent this issue if other applications have this
> same write pattern.
> 
> Another potential option for a stable only fix might be tweak the iomap
> code to not update i_size for append (&& nowait?) writes until an
> iter->pos update is imminent, but I think we'd need to be careful there
> due to the pagecache_isize_extended() call. I think that's more for
> non-append cases, but I'd have to take a closer look. Maybe we could
> also replace that iov_iter revert with a hardcoded advance of the iomap
> iter and emulate the same behavior as newer kernels. That seems
> cleanest actually, but again needs some thought and testing...
> 

The above is harder than I initially thought because iomap_iter()
expects the iter->pos to reflect the original position. This gets into
some of the dependency patches in the associated rework series.

Another idea that came to mind is to try and just replace the -EAGAIN
return sequence from the low level iterator with a flag that triggers
-EAGAIN from the next iter advance. The idea here is to allow the write
to return partial completion (i.e. so no iov_iter revert) without having
to return an error from the lowest level in the stack. I had claude come
up with a quick patch [1] for reference/experimentation.

This is based on v6.12 stable and compile tested only. It needs more
review and testing in general but might be worth throwing your
reproducer at if you can..?

Brian

[1]

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 0178292c1864..956700441f6a 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -1037,10 +1037,9 @@ static loff_t iomap_write_iter(struct iomap_iter *iter, struct iov_iter *i)
 		}
 	} while (iov_iter_count(i) && length);
 
-	if (status == -EAGAIN) {
-		iov_iter_revert(i, total_written);
-		return -EAGAIN;
-	}
+	if (status == -EAGAIN)
+		iter->iomap.flags |= IOMAP_F_ASYNC_RETRY;
+
 	return total_written ? total_written : status;
 }
 
diff --git a/fs/iomap/iter.c b/fs/iomap/iter.c
index 79a0614eaab7..6021b09ddc2f 100644
--- a/fs/iomap/iter.c
+++ b/fs/iomap/iter.c
@@ -22,6 +22,7 @@
 static inline int iomap_iter_advance(struct iomap_iter *iter)
 {
 	bool stale = iter->iomap.flags & IOMAP_F_STALE;
+	bool async_retry = iter->iomap.flags & IOMAP_F_ASYNC_RETRY;
 
 	/* handle the previous iteration (if any) */
 	if (iter->iomap.length) {
@@ -35,6 +36,8 @@ static inline int iomap_iter_advance(struct iomap_iter *iter)
 		iter->len -= iter->processed;
 		if (!iter->len)
 			return 0;
+		if (async_retry)
+			return -EAGAIN;
 	}
 
 	/* clear the state for the next iteration */
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index d204dcd35063..8d60073a255d 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -74,9 +74,14 @@ struct vm_fault;
  * IOMAP_F_STALE indicates that the iomap is not valid any longer and the file
  * range it covers needs to be remapped by the high level before the operation
  * can proceed.
+ *
+ * IOMAP_F_ASYNC_RETRY indicates that a buffered write made partial progress
+ * but needs to return -EAGAIN to trigger an async retry. The iter has already
+ * been advanced to reflect the partial progress.
  */
 #define IOMAP_F_SIZE_CHANGED	(1U << 8)
 #define IOMAP_F_STALE		(1U << 9)
+#define IOMAP_F_ASYNC_RETRY	(1U << 10)
 
 /*
  * Flags from 0x1000 up are for file system specific usage:


