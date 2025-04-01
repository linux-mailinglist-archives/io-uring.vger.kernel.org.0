Return-Path: <io-uring+bounces-7338-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 895BAA77A89
	for <lists+io-uring@lfdr.de>; Tue,  1 Apr 2025 14:17:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 203F1168DAC
	for <lists+io-uring@lfdr.de>; Tue,  1 Apr 2025 12:17:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E55A202F88;
	Tue,  1 Apr 2025 12:17:21 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55FC4202965;
	Tue,  1 Apr 2025 12:17:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743509841; cv=none; b=eacJtYPfKHsoIRC+M3tv1+YcNDnXISCVZjga/WScjI3rUzMA80ON2iQiszo+sOdwyRqOoANOYINbF/T6O/XbyS1LI5SKTEw2+ofKfILgBIp1y7y0eWm7Vd9keCqc94dIJrEeua8SEU9jcFtNLqPZmC0AbSSHtrqGk9oS3G7BrIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743509841; c=relaxed/simple;
	bh=3mz+zkd+0flPsLy0Ofm1nfq5/fbalcBJT6YtqE7p5ow=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c6gDlaBCHU9dREDDtJVC1oXkA/LUEXd1D7vJERmeZsldSHfv1XuJFvVs9tnbrvFGT2niO/LrweDyeaDHpkLrh/KIarHe0IOoL8pgeoetfscNnvFSABspxRfJrRROVYwplx7UcVYEpBxfmK34jCZTjg8GFgpXZ+wgkvLUoIgkxOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-5ed1ac116e3so9462884a12.3;
        Tue, 01 Apr 2025 05:17:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743509836; x=1744114636;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Le/fZ22YF+TB0PY0qqmz1Qiiab5GI/mdQmTFzYxcG4I=;
        b=tiXww2r0781mneYgxH9z7mg8pgo3jhMDcZq+26cJ+Hoh+5bQsDcL+DiSDc/RyCvKP2
         ZHCeTwQnFgpgqmjSdejvq6FnHChV66kTSg1tEqR8FfZWg8HCY7hbIxWsBBaIRTLlJ+5L
         BWI8hBXBc6TWVHlhVZIG6niGp27BC6PtuRir5jrOlIEVnyUAl5P7Vgo2S0tKdXOJCxqR
         IXemX9VIm2vjFJGqBzTETb1WIcq506x/8+XJEUcu9StEVDnmbXpuV3pxvd4WhQznewk+
         8qVbMbsPDojaaoMMILesXm7egtC8yPczKJscrCH2qvAvskv9kcnO8/IxgrnqOFlwM86I
         EYAg==
X-Forwarded-Encrypted: i=1; AJvYcCU+PaEMmljuTidEfyjK1KNeTRu6vsWiwlABmYi2FRzjIL7wJoNubvBT8kWM5Q7TaodpPOnyP0b63yGbIz3LGOjC@vger.kernel.org, AJvYcCU6LinRDa3RkrxTiRw5OR8fIoqPus07QVq0DNtsIoRZkotn7GWmQcZSD1iy3lkIlH+uHn9xlB2/9to=@vger.kernel.org, AJvYcCUKDCrTm29DSu8VC1278vU3l36ZXnMScQ3oLw1OdmBMl6mqKBHtm6YVPMV0lziuR3uZEO8XbXj03lsZUg+h@vger.kernel.org, AJvYcCUobLm1LYSWmtA+WSFOC/8GwhYItRRg4r+p5VnhxebN5WJ3qlhVA4wEyLQfl5FCZalJsng+H6nX@vger.kernel.org, AJvYcCVWp7jILbT/+ax0UMneqs3UsvAYmV9DNfzgSVqOOFsW+Xn7Ynb+Z6ykBEQs8chiQiLOC7DFReVgyjVRgg==@vger.kernel.org, AJvYcCVrBwxkxrv++hSc9HNBj/crKKTC2XNzmGQDKmo7Z6l6xVcUOfU8eVT6bNhROv53oHDZWypMkKqurTCrIw==@vger.kernel.org, AJvYcCWE1spL4JwQrhqSEZdrsCvFnXw4SdrsqrchA3OQ0oudy4C+id8nfqHSN6zwcz5/cBoq+0z1fp19ew8U@vger.kernel.org, AJvYcCWOxLuN7+WXel60zUlNyB4WeOhKgpOtcT0qG0GiosBzbbZe1stp37NOZM1Ti0UMwKIg+2Uja1ElI9prWw==@vger.kernel.org, AJvYcCWfeqo4td43zvrLkSggo/oEFxaPZVHU6JP+Yc+bEIQrdaV5M12/cbdOj1UFvOjL+DW6QX6Kkdd+u3J1XQ==@vger.kernel.org, AJvYcCX+Eah1SuAFPLKZxIRur9ig
 Wzqjzfn1pGEjuOjgxv0CiXc6YIH+sQSMaV+BjN24p+CByeUmlM2ImEDymQ==@vger.kernel.org, AJvYcCXBp4JJVdttGdnDV5l8Do10TlAeZJ6oIcIx7Dv2zP3Nc5TAr/e2ayPiHUgAcYZY2JmP4Tq3UA==@vger.kernel.org, AJvYcCXSVfvVPiXq0DQAQtYgM2BToHFLvwiVh93nYUYBQub+grHYDT/R8ZvqWu4+6hRZs+fEZv44krwctoDU@vger.kernel.org, AJvYcCXg3LlsUyJtvsxI4QBwkqHrlpecTzAk7d9xKc9SfhzJ3DPUqiR2NC39IP4UpP0k/3QmgZY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy41sxJG1EgEMJS+0Lr+MvpGg7CB6CERi8HGG7AJEBJv681V3R2
	EtM4IfaQEi4mgU4HRI7/Rm4QUkZ2Hi1gCC2l+3pqd3sngFoK4lRu
X-Gm-Gg: ASbGncvW2OafqMDoMgTvg9sHyFmGf2O+WEEe0/BCdiSB0PxAU4XdZJ0yIQH87jSZ5JK
	W3I9ZhaG5JlK7qLJlLuCrnuxRA3eHfKx8q7Vz8Gwidr42I0bMCImhMpJ+MSsnVqjD5+vpM3xnPB
	T9IsTgoNOB7ciet9sbFwisLM0xzxM79I63W4w+jJmmm8rPVnzC3mt7STKPHchkdVLE8XC0BOBb1
	EY9LtzWgbzYuQQSD6061Qi6pk0y/pUN/NKXbSLv4JqmFfEbk1k8SVwE4xA1sKhw5jJsCR+OsFJK
	vCGx6xvAXvxUHu9mCIgVzIcItHZuZK2g0X4=
X-Google-Smtp-Source: AGHT+IFIWumNmX/1ZXWS3yLA6haOkNuwqHqavN++vEeVvWZeAOABaH1HwDwax0vsW9FqMkDo2Sxlag==
X-Received: by 2002:a05:6402:26c8:b0:5e5:be7f:a1f6 with SMTP id 4fb4d7f45d1cf-5edfcc021a5mr10721198a12.1.1743509836211;
        Tue, 01 Apr 2025 05:17:16 -0700 (PDT)
Received: from gmail.com ([2a03:2880:30ff:3::])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5edc16eda94sm7144316a12.33.2025.04.01.05.17.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Apr 2025 05:17:14 -0700 (PDT)
Date: Tue, 1 Apr 2025 05:17:09 -0700
From: Breno Leitao <leitao@debian.org>
To: Stefan Metzmacher <metze@samba.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>, Christoph Hellwig <hch@lst.de>,
	Karsten Keil <isdn@linux-pingi.de>,
	Ayush Sawal <ayush.sawal@chelsio.com>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Willem de Bruijn <willemb@google.com>,
	David Ahern <dsahern@kernel.org>,
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	Xin Long <lucien.xin@gmail.com>,
	Neal Cardwell <ncardwell@google.com>,
	Joerg Reuter <jreuter@yaina.de>,
	Marcel Holtmann <marcel@holtmann.org>,
	Johan Hedberg <johan.hedberg@gmail.com>,
	Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
	Oliver Hartkopp <socketcan@hartkopp.net>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Robin van der Gracht <robin@protonic.nl>,
	Oleksij Rempel <o.rempel@pengutronix.de>, kernel@pengutronix.de,
	Alexander Aring <alex.aring@gmail.com>,
	Stefan Schmidt <stefan@datenfreihafen.org>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Alexandra Winter <wintera@linux.ibm.com>,
	Thorsten Winkler <twinkler@linux.ibm.com>,
	James Chapman <jchapman@katalix.com>,
	Jeremy Kerr <jk@codeconstruct.com.au>,
	Matt Johnston <matt@codeconstruct.com.au>,
	Matthieu Baerts <matttbe@kernel.org>,
	Mat Martineau <martineau@kernel.org>,
	Geliang Tang <geliang@kernel.org>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Remi Denis-Courmont <courmisch@gmail.com>,
	Allison Henderson <allison.henderson@oracle.com>,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	Wenjia Zhang <wenjia@linux.ibm.com>,
	Jan Karcher <jaka@linux.ibm.com>,
	"D. Wythe" <alibuda@linux.alibaba.com>,
	Tony Lu <tonylu@linux.alibaba.com>,
	Wen Gu <guwen@linux.alibaba.com>, Jon Maloy <jmaloy@redhat.com>,
	Boris Pismenny <borisp@nvidia.com>,
	John Fastabend <john.fastabend@gmail.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Martin Schiller <ms@dev.tdt.de>,
	=?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn@kernel.org>,
	Magnus Karlsson <magnus.karlsson@intel.com>,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	Jonathan Lemon <jonathan.lemon@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Jesper Dangaard Brouer <hawk@kernel.org>, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-sctp@vger.kernel.org,
	linux-hams@vger.kernel.org, linux-bluetooth@vger.kernel.org,
	linux-can@vger.kernel.org, dccp@vger.kernel.org,
	linux-wpan@vger.kernel.org, linux-s390@vger.kernel.org,
	mptcp@lists.linux.dev, linux-rdma@vger.kernel.org,
	rds-devel@oss.oracle.com, linux-afs@lists.infradead.org,
	tipc-discussion@lists.sourceforge.net,
	virtualization@lists.linux.dev, linux-x25@vger.kernel.org,
	bpf@vger.kernel.org, isdn4linux@listserv.isdn4linux.de,
	io-uring@vger.kernel.org
Subject: Re: [RFC PATCH 1/4] net: introduce get_optlen() and put_optlen()
 helpers
Message-ID: <Z+vZRcbvh6r1fnZL@gmail.com>
References: <cover.1743449872.git.metze@samba.org>
 <156e83128747b2cf7c755bffa68f2519bd255f78.1743449872.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156e83128747b2cf7c755bffa68f2519bd255f78.1743449872.git.metze@samba.org>

Hello Stefan,

On Mon, Mar 31, 2025 at 10:10:53PM +0200, Stefan Metzmacher wrote:
> --- a/include/linux/sockptr.h
> +++ b/include/linux/sockptr.h
> @@ -169,4 +169,26 @@ static inline int check_zeroed_sockptr(sockptr_t src, size_t offset,
>  	return memchr_inv(src.kernel + offset, 0, size) == NULL;
>  }
>  
> +#define __check_optlen_t(__optlen)				\
> +({								\
> +	int __user *__ptr __maybe_unused = __optlen; 		\
> +	BUILD_BUG_ON(sizeof(*(__ptr)) != sizeof(int));		\
> +})

I am a bit confused about this macro. I understand that this macro's
goal is to check that __optlen is a pointer to an integer, otherwise
failed to build.

It is unclear to me if that is what it does. Let's suppose that __optlen
is not an integer pointer. Then:

> int __user *__ptr __maybe_unused = __optlen;

This will generate a compile failure/warning due invalid casting,
depending on -Wincompatible-pointer-types.

> BUILD_BUG_ON(sizeof(*(__ptr)) != sizeof(int));

Then this comparison will always false, since __ptr is a pointer to int,
and you are comparing the size of its content with the sizeof(int).

