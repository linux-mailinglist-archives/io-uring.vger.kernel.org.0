Return-Path: <io-uring+bounces-12933-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id mMDQJmqOzmkbogYAu9opvQ
	(envelope-from <io-uring+bounces-12933-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 02 Apr 2026 17:42:34 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id EE28A38B5F2
	for <lists+io-uring@lfdr.de>; Thu, 02 Apr 2026 17:42:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D891E3049242
	for <lists+io-uring@lfdr.de>; Thu,  2 Apr 2026 15:39:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0FDF43E1CE7;
	Thu,  2 Apr 2026 15:39:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="Pee1gnhO"
X-Original-To: io-uring@vger.kernel.org
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5963C3E51C4;
	Thu,  2 Apr 2026 15:39:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775144391; cv=none; b=Ez5EHdMG1Aso9f2YeFAOiAlP3CQL/ZmOOOnLuyXHFSf+yMGhseAWQTpWSoCy98KQBcUmnsYi044ksOolNgnBnuE25fPOdxk+q+Ls4YNrJ9GIXEZXKVN/t2zy41dIwEwHVyjbRb4TxX2AtIKQtHACXaAmSShLVTmUBrsaea9I3+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775144391; c=relaxed/simple;
	bh=VDon9Q6DSE3+7qnaS/hyrzZkF8Rx+JEWqlgHs4bivEw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=REx4V8fGaIulHX9+axz0EW7HjAyj+VhsLzrdwLBEveLcwyqScS7kDYFU1iWVHExQcuV8YeT3bUNkRWbSABF7l54EmaHC7/py5zEbUj/DVsNuJ9ooaBycIWt1a49PeUoAvPlMMfjanIJqd1ZxdAjNpurHdOTZSjxsE/kHxag6At0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=none smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=Pee1gnhO; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=debian.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=KaX2Za9i1qMHE3vSTTBXqMAjRIFb68sQ8EbB8U/9fT8=; b=Pee1gnhO/lQUDnJWBmG0zdJ1xB
	INT9E880vn1xsappBNZ1xowEEDE6PNd7OYRhMo5RMVXotd/T8pkYfIoqW24p9RpRtEKB7ZFDfc3Bj
	CzZMka9U9nhvlcYGiKb3UBW2L6oh+L6inYjLaM/EPElPxpiCz6nwi80nPmsIyBknO7tgisboRqnKk
	wWnCRC98QsXph3jsOb1Sz4XWd9BQgMPBqIXoo2b3PwrBRj05vXMjGv7ROWiD8gxXeP6V0GefmKNPN
	+kgIXeVkuL0odXDlrWkraG3vxD2pkQIekCdz8BnKvZdaSvyiorNIQSRm2P/i2vExZ8mqsjXVEeH+y
	DjHh0vfQ==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1w8K8r-003rew-2N;
	Thu, 02 Apr 2026 15:39:32 +0000
Date: Thu, 2 Apr 2026 08:39:26 -0700
From: Breno Leitao <leitao@debian.org>
To: Stanislav Fomichev <stfomichev@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	Kuniyuki Iwashima <kuniyu@google.com>, Willem de Bruijn <willemb@google.com>, metze@samba.org, 
	axboe@kernel.dk, Stanislav Fomichev <sdf@fomichev.me>, io-uring@vger.kernel.org, 
	bpf@vger.kernel.org, netdev@vger.kernel.org, 
	Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH net-next v2 2/4] net: call getsockopt_iter if available
Message-ID: <ac6MAdYyuPGsB4am@gmail.com>
References: <20260401-getsockopt-v2-0-611df6771aff@debian.org>
 <20260401-getsockopt-v2-2-611df6771aff@debian.org>
 <ac1I_CMr43XTpvHj@mini-arch>
 <ac1Pzt4tpt73SkC6@gmail.com>
 <ac1fjvVDfatpXwPY@mini-arch>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ac1fjvVDfatpXwPY@mini-arch>
X-Debian-User: leitao
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_RHS_MATCH_TO(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[debian.org:s=smtpauto.stravinsky];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_COUNT_THREE(0.00)[4];
	DMARC_NA(0.00)[debian.org];
	FREEMAIL_TO(0.00)[gmail.com];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[17];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-12933-lists,io-uring=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-0.986];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[leitao@debian.org,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[debian.org:+];
	TAGGED_RCPT(0.00)[io-uring];
	MISSING_XM_UA(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: EE28A38B5F2
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Hello Stanislav,

On Wed, Apr 01, 2026 at 11:10:22AM -0700, Stanislav Fomichev wrote:
> So maybe something like this is better to communicate your long term intent?
> 
> 	} else if (ops->getsockopt_iter) {
> 		optval = sockptr_to_iter(optval)
> 		optlen = sockptr_to_iter(optlen)
> 		do_sock_getsockopt_iter(...) /* does not know what sockpt_t is */
> 	}
> 
> ?
> 
> Then your new do_sock_getsockopt_iter is sockptr-free from the beginning
> and at some point we'll just drop/move those sockptr_to_iter calls?

Sure, that would work as well. It would look like the following, from my
current implemention:

+static int sockptr_to_sockopt(sockopt_t *opt, sockptr_t optval,
+                             sockptr_t optlen, struct kvec *kvec)
+{
+       int koptlen;
+
+       if (copy_from_sockptr(&koptlen, optlen, sizeof(int)))
+               return -EFAULT;
+
+       if (optval.is_kernel) {
+               kvec->iov_base = optval.kernel;
+               kvec->iov_len = koptlen;
+               iov_iter_kvec(&opt->iter_out, ITER_DEST, kvec, 1, koptlen);
+               iov_iter_kvec(&opt->iter_in, ITER_SOURCE, kvec, 1, koptlen);
+       } else {
+               iov_iter_ubuf(&opt->iter_out, ITER_DEST, optval.user, koptlen);
+               iov_iter_ubuf(&opt->iter_in, ITER_SOURCE, optval.user,
+                             koptlen);
+       }
+       opt->optlen = koptlen;
+
+       return 0;
+}
+
 int do_sock_getsockopt(struct socket *sock, bool compat, int level,
                       int optname, sockptr_t optval, sockptr_t optlen)
 {
@@ -2366,15 +2390,31 @@ int do_sock_getsockopt(struct socket *sock, bool compat, int level,

+       } else if (ops->getsockopt_iter) {
+               struct kvec kvec;
+               sockopt_t opt;
+
+               err = sockptr_to_sockopt(&opt, optval, optlen, &kvec);
+               if (err)
+                       return err;
+
+               err = ops->getsockopt_iter(sock, level, optname, &opt);
+
+               /* Always write back optlen, even on failure. Some protocols
+                * (e.g. CAN raw) return -ERANGE and set optlen to the
+                * required buffer size so userspace can discover it.
+                */
+               if (copy_to_sockptr(optlen, &opt.optlen, sizeof(int)))
+                       return -EFAULT;
+       } else if (ops->getsockopt) {
....

> I hope this way it will be easier to review protocol handler changes.
> 
> For example, looking at your AF_PACKET patch, you won't have to care
> about flipping the source and doing the revert. Most/all of the changes will
> be simple:
> - s/get_user(len, optlen)/len = opt->optlen/
> - s/put_user(len, optlen)/opt->optlen = len/
> - s/copy_from_user(xxx, optval, len)/copy_from_iter(xxx, len, &opt->iter_in)/
> - s/copy_to_user(optval, xxx, len)/copy_to_iter(xxx, len, &opt->iter_out)/

That is, in fact, a great proposal. It will make the protocol changes review
way easier.

This is what I have right now.

	typedef struct sockopt {
		struct iov_iter iter_out;
		struct iov_iter iter_in;
		int optlen;
	} sockopt_t;


And then, the drivers change would be as simple as:

 static int packet_getsockopt(struct socket *sock, int level, int optname,
-                            char __user *optval, int __user *optlen)
+                            sockopt_t *opt)
 {
        int len;
        int val, lv = sizeof(val);
@@ -4065,8 +4066,7 @@ static int packet_getsockopt(struct socket *sock, int level, int optname,
        if (level != SOL_PACKET)
                return -ENOPROTOOPT;

-       if (get_user(len, optlen))
-               return -EFAULT;
+       len = opt->optlen;

        if (len < 0)
                return -EINVAL;
@@ -4115,7 +4115,7 @@ static int packet_getsockopt(struct socket *sock, int level, int optname,
                        len = sizeof(int);
                if (len < sizeof(int))
                        return -EINVAL;
-               if (copy_from_user(&val, optval, len))
+               if (copy_from_iter(&val, len, &opt->iter_in) != len)
                        return -EFAULT;
                switch (val) {
                case TPACKET_V1:
@@ -4171,9 +4171,8 @@ static int packet_getsockopt(struct socket *sock, int level, int optname,

        if (len > lv)
                len = lv;
-       if (put_user(len, optlen))
-               return -EFAULT;
-       if (copy_to_user(optval, data, len))
+       opt->optlen = len;
+       if (copy_to_iter(data, len, &opt->iter_out) != len)
                return -EFAULT;
        return 0;

This is not fully tested yet, but, in case you want to see how this looks like
so far, I have it in https://github.com/leitao/linux/tree/b4/getsockopt_v3.

I will submit a newer version after I am done with the testing.

Thanks for the insights,
--breno

