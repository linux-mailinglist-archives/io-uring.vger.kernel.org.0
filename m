Return-Path: <io-uring+bounces-12940-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id /wl7FWf1zmnTsAYAu9opvQ
	(envelope-from <io-uring+bounces-12940-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 03 Apr 2026 01:01:59 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 529DD38EF3C
	for <lists+io-uring@lfdr.de>; Fri, 03 Apr 2026 01:01:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 06E91300EC5B
	for <lists+io-uring@lfdr.de>; Thu,  2 Apr 2026 23:00:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 969103EF0C7;
	Thu,  2 Apr 2026 23:00:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RnMDDQpl"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-dy1-f180.google.com (mail-dy1-f180.google.com [74.125.82.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E21E3EE1DD
	for <io-uring@vger.kernel.org>; Thu,  2 Apr 2026 23:00:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775170832; cv=none; b=l+INhj00DK9ui1qUDhUQH/jF4ieqBmspb6qZ4Pz0aw4l2nucFniCM8oiCVVUhwWhHQzQbgy/qCJHItWb3k2iea90Y2lbDvuPe1cjnhQKtc+cDOHewNucfbRzJ7ZYY8uNWbjfqNSfBffPU+TGoonPIFJHnlmpj4Km1ah/MUOJ7y0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775170832; c=relaxed/simple;
	bh=UNP/i09LPDrr5ofwIWjeoZzvRploUuqwNY48RB4hwgE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sFmXHINwecF8p2CoBh/dxiTwd++3VFFYSBCgVRMstn43YdSMQHghPB+jdAdvNIUTyqPBCSsmPDqBgsOZo4YAAI4JZM5ARJXbqukKFTYdHVjm9ZSykidfYSElBmln19UZGpy+AKNlTPjVwcM/drlbB8UASEwO95arHdxoWoxcPeY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RnMDDQpl; arc=none smtp.client-ip=74.125.82.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-dy1-f180.google.com with SMTP id 5a478bee46e88-2c5b3d8eab1so441883eec.1
        for <io-uring@vger.kernel.org>; Thu, 02 Apr 2026 16:00:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775170829; x=1775775629; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=yd3zShC3yJuODpByZ8XJoFDD8uo8tECYjo5Z5kbc02I=;
        b=RnMDDQplJFelTDLkVqWYULFg4HJqfJYxcSmeq76s0gdV/9iJn6pjKLpNyL7MW+tYlN
         39vLpNRUGW8/2WVX7xuxh0NBrulzo9XlK5bYAH3GdqaHRm/+q1rzcRq/5IFoID5tDw+W
         plbuSbJCfdaqHiKl4HTMx17jIypgGSusMKnRzlqWedgW1KucD6frpZ+EAOpd+PYv/l72
         N6H+lYDVwRF3CKeWv4yOutGQjCz4KRNqERvba2LBSscQaC2QXvRBp8To+A+SKLCm+ALx
         6/iCJMvYP34UMMp23ZInHsZyjs8dZPBaH6zIlokcx/JXl2uwfOWlSYdd2HKY/DGKiEx/
         ut2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775170829; x=1775775629;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yd3zShC3yJuODpByZ8XJoFDD8uo8tECYjo5Z5kbc02I=;
        b=MWX7v/oH6bKAaWLOECIBp7iUYK1AmDjDYO6sg2GrAar+oPjkNcN8Zmv6XDpz2FpfHl
         ULlUwQaLv4pUVIMkgZG8bhnfKJAPSWLzh3l8GzUY4IGVYks0Kg4jEgFUL47BvPc/9jfR
         IxLtvisKWTqYN67hz3UBqAtzxiIQqdEIcSuzH1rPHO3/FGkeISmnl43ZRWXFU2Hg6isz
         143qqv+4OaQp7e1udjpT8tag1bZOETDd2FT0P2bQukTvfclTJY4APCyyHuxWBGoSAeuv
         qsNtMW/UPkMgaDZVjFROZnikc57w7aKyv85Ns2/s0d3AUHzyYBzLf25xHZpueYfha066
         k8eQ==
X-Forwarded-Encrypted: i=1; AJvYcCXTCHD7wzJCkXmnI4v6L6vtdRQpayU7wnT0XI8ZTuxH5iMURU2tND1oTb7zuqqBgVtM5pYXWdhceA==@vger.kernel.org
X-Gm-Message-State: AOJu0YyDigs0RWWo5pusLCicHIpU4+Eeadvi8I/IFcZIRnhEQNCxyoBR
	s7wQGbwwP8+K7qyxRZTdjhZQgXDst5kTtRoYskY5QRe4SIUiqzAmYD8=
X-Gm-Gg: AeBDietePeUtD1OJlWqg/lE01kfWH1/3ODlMdqVqaJPN6NoESjYNYOfA01mpEq0M/DW
	0IRLafsV2gGDB0TTHic+XlS/TNnkfjPC5TXHMkn4K1GdbT0KVlY8BpP5z8fayP5J/zDPLw/sYQc
	8e8Wwwczl7+sGAZl2RsEzshQP6tpxhQgVY4YkeJNVfEpOl+BS72FSd56VZOUFIegDZdJDTSQwXZ
	9XavV3Tfl5p9XBl0EOGc8VrzIeBnFMDAh7EfMN+ksXIfwh/gRwuVE+/Hle7I8Yr5XbAJeHzqOho
	pzVJHMd87jogIGcdPz8sFjt34vM0V2sqdJT6nFOa+6h+MgOkNH3uxpBWMOsTrXwASbhhC1kx9Qo
	VZQswzSprXjN8PYEY9f8YHn+YFR5M2+QaqPZFU2aKNlCbhgQLg7+1rtsquUjHmCKqQhnYEGRqSE
	VVT2B58G7PToQrukCLtulfY9OGYYrRdgUFbkHdZzTDstGEhFsQwG3CuQeWp3j7HzKEEviYuY/Zr
	yWG3cmBkj2Io0ZGPUd2JVbElS0b
X-Received: by 2002:a05:7301:2b07:b0:2ca:f181:9b17 with SMTP id 5a478bee46e88-2cbfca5c3dfmr519556eec.33.1775170828604;
        Thu, 02 Apr 2026 16:00:28 -0700 (PDT)
Received: from localhost (c-76-102-12-149.hsd1.ca.comcast.net. [76.102.12.149])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2ca7cae9e9esm3403523eec.23.2026.04.02.16.00.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2026 16:00:28 -0700 (PDT)
Date: Thu, 2 Apr 2026 16:00:27 -0700
From: Stanislav Fomichev <stfomichev@gmail.com>
To: Breno Leitao <leitao@debian.org>
Cc: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Willem de Bruijn <willemb@google.com>, metze@samba.org,
	axboe@kernel.dk, Stanislav Fomichev <sdf@fomichev.me>,
	io-uring@vger.kernel.org, bpf@vger.kernel.org,
	netdev@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH net-next v2 2/4] net: call getsockopt_iter if available
Message-ID: <ac71Czwqzsyw0Lyd@mini-arch>
References: <20260401-getsockopt-v2-0-611df6771aff@debian.org>
 <20260401-getsockopt-v2-2-611df6771aff@debian.org>
 <ac1I_CMr43XTpvHj@mini-arch>
 <ac1Pzt4tpt73SkC6@gmail.com>
 <ac1fjvVDfatpXwPY@mini-arch>
 <ac6MAdYyuPGsB4am@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ac6MAdYyuPGsB4am@gmail.com>
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12940-lists,io-uring=lfdr.de];
	FREEMAIL_FROM(0.00)[gmail.com];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[17];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[stfomichev@gmail.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[gmail.com:+];
	NEURAL_HAM(-0.00)[-0.999];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	TO_DN_SOME(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 529DD38EF3C
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 04/02, Breno Leitao wrote:
> Hello Stanislav,
> 
> On Wed, Apr 01, 2026 at 11:10:22AM -0700, Stanislav Fomichev wrote:
> > So maybe something like this is better to communicate your long term intent?
> > 
> > 	} else if (ops->getsockopt_iter) {
> > 		optval = sockptr_to_iter(optval)
> > 		optlen = sockptr_to_iter(optlen)
> > 		do_sock_getsockopt_iter(...) /* does not know what sockpt_t is */
> > 	}
> > 
> > ?
> > 
> > Then your new do_sock_getsockopt_iter is sockptr-free from the beginning
> > and at some point we'll just drop/move those sockptr_to_iter calls?
> 
> Sure, that would work as well. It would look like the following, from my
> current implemention:
> 
> +static int sockptr_to_sockopt(sockopt_t *opt, sockptr_t optval,
> +                             sockptr_t optlen, struct kvec *kvec)
> +{
> +       int koptlen;
> +
> +       if (copy_from_sockptr(&koptlen, optlen, sizeof(int)))
> +               return -EFAULT;
> +
> +       if (optval.is_kernel) {
> +               kvec->iov_base = optval.kernel;
> +               kvec->iov_len = koptlen;
> +               iov_iter_kvec(&opt->iter_out, ITER_DEST, kvec, 1, koptlen);
> +               iov_iter_kvec(&opt->iter_in, ITER_SOURCE, kvec, 1, koptlen);
> +       } else {
> +               iov_iter_ubuf(&opt->iter_out, ITER_DEST, optval.user, koptlen);
> +               iov_iter_ubuf(&opt->iter_in, ITER_SOURCE, optval.user,
> +                             koptlen);
> +       }
> +       opt->optlen = koptlen;
> +
> +       return 0;
> +}
> +
>  int do_sock_getsockopt(struct socket *sock, bool compat, int level,
>                        int optname, sockptr_t optval, sockptr_t optlen)
>  {
> @@ -2366,15 +2390,31 @@ int do_sock_getsockopt(struct socket *sock, bool compat, int level,
> 
> +       } else if (ops->getsockopt_iter) {
> +               struct kvec kvec;
> +               sockopt_t opt;
> +
> +               err = sockptr_to_sockopt(&opt, optval, optlen, &kvec);
> +               if (err)
> +                       return err;
> +
> +               err = ops->getsockopt_iter(sock, level, optname, &opt);
> +
> +               /* Always write back optlen, even on failure. Some protocols
> +                * (e.g. CAN raw) return -ERANGE and set optlen to the
> +                * required buffer size so userspace can discover it.
> +                */
> +               if (copy_to_sockptr(optlen, &opt.optlen, sizeof(int)))
> +                       return -EFAULT;
> +       } else if (ops->getsockopt) {
> ....
> 
> > I hope this way it will be easier to review protocol handler changes.
> > 
> > For example, looking at your AF_PACKET patch, you won't have to care
> > about flipping the source and doing the revert. Most/all of the changes will
> > be simple:
> > - s/get_user(len, optlen)/len = opt->optlen/
> > - s/put_user(len, optlen)/opt->optlen = len/
> > - s/copy_from_user(xxx, optval, len)/copy_from_iter(xxx, len, &opt->iter_in)/
> > - s/copy_to_user(optval, xxx, len)/copy_to_iter(xxx, len, &opt->iter_out)/
> 
> That is, in fact, a great proposal. It will make the protocol changes review
> way easier.
> 
> This is what I have right now.
> 
> 	typedef struct sockopt {
> 		struct iov_iter iter_out;
> 		struct iov_iter iter_in;
> 		int optlen;
> 	} sockopt_t;
> 
> 
> And then, the drivers change would be as simple as:
> 
>  static int packet_getsockopt(struct socket *sock, int level, int optname,
> -                            char __user *optval, int __user *optlen)
> +                            sockopt_t *opt)
>  {
>         int len;
>         int val, lv = sizeof(val);
> @@ -4065,8 +4066,7 @@ static int packet_getsockopt(struct socket *sock, int level, int optname,
>         if (level != SOL_PACKET)
>                 return -ENOPROTOOPT;
> 
> -       if (get_user(len, optlen))
> -               return -EFAULT;
> +       len = opt->optlen;
> 
>         if (len < 0)
>                 return -EINVAL;
> @@ -4115,7 +4115,7 @@ static int packet_getsockopt(struct socket *sock, int level, int optname,
>                         len = sizeof(int);
>                 if (len < sizeof(int))
>                         return -EINVAL;
> -               if (copy_from_user(&val, optval, len))
> +               if (copy_from_iter(&val, len, &opt->iter_in) != len)
>                         return -EFAULT;
>                 switch (val) {
>                 case TPACKET_V1:
> @@ -4171,9 +4171,8 @@ static int packet_getsockopt(struct socket *sock, int level, int optname,
> 
>         if (len > lv)
>                 len = lv;
> -       if (put_user(len, optlen))
> -               return -EFAULT;
> -       if (copy_to_user(optval, data, len))
> +       opt->optlen = len;
> +       if (copy_to_iter(data, len, &opt->iter_out) != len)
>                 return -EFAULT;
>         return 0;
> 
> This is not fully tested yet, but, in case you want to see how this looks like
> so far, I have it in https://github.com/leitao/linux/tree/b4/getsockopt_v3.
> 
> I will submit a newer version after I am done with the testing.
> 
> Thanks for the insights,
> --breno

LGTM, thanks!

