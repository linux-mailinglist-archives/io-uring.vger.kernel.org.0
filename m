Return-Path: <io-uring+bounces-4507-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F8749BF157
	for <lists+io-uring@lfdr.de>; Wed,  6 Nov 2024 16:15:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 06FB31F21C0C
	for <lists+io-uring@lfdr.de>; Wed,  6 Nov 2024 15:15:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6834217B439;
	Wed,  6 Nov 2024 15:15:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="sDW+x7M5"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f49.google.com (mail-io1-f49.google.com [209.85.166.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E05681DF738
	for <io-uring@vger.kernel.org>; Wed,  6 Nov 2024 15:15:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730906117; cv=none; b=pcl57o1xWHtKWXOU3HpGyTrg2B6XtQ1Cy+ZCO7hfhn/pmZcC55cTojIlNANCQZGJ5rIYz7XRSYoxZf+YrrVFHKyOhSC4k+r8IW/oEQqtm9+fBgr0f84hzViVW2fgHLikRO3gviOQAQH9JbpLNTIAJo/sV4J7djF4AiPyZPIMFD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730906117; c=relaxed/simple;
	bh=mI87ONyrfsdIccibGrLHNw6DKQhtCF27Su6JcV1xmhg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MbbR70/vY5tiFIZBh408HcTe8SqdkRjcGdz5xY+LC+U7qqqHhS5001+GBywwHIpLa8d+KwZujeH3kPhsHbGXpvVZufqgzt/TiSVMz66igADDXdCCIER9x6N2ujIhtvBHPWFS6bt8yfJmM2lensHemGgMVhhTqhSXRRBTOYuQP9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=sDW+x7M5; arc=none smtp.client-ip=209.85.166.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f49.google.com with SMTP id ca18e2360f4ac-83ab694ebe5so260501139f.0
        for <io-uring@vger.kernel.org>; Wed, 06 Nov 2024 07:15:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1730906115; x=1731510915; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LHucz0Nh6HKCiVFTyjOpd7Ni5+roDQnO4ocJ2GfplS0=;
        b=sDW+x7M5uJLUOzl2cnlwYczn0O/hgYrcH1g7qFmWc/y3mhqvjZS4G9uaFL/BQUrmWc
         iZFKkPZ2El2NV3C0tIh650libS2cXjwBgzadEE4FAeHQUF2eO57Z+G8knf9XZ33LH1Fc
         IgtpLYUKHHzTumHcLk80KGYd2dGjqb8nGdz1xiQgVjGQpaay+MaxxvZe/jHMeWHnE/qk
         cZwqjSX+tLTr8hfq6KzuslQbsVINu4rE1ZqULJxwcMtlv9G29X6UmzBzL8e+dzUiiQ2w
         NS5rDUacwUPqymSMiZeOERma3vyVuKQ1sOv9F+WrJOh4YQx6v8Cvp5mfENYBRVUjuXNF
         Ri4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730906115; x=1731510915;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LHucz0Nh6HKCiVFTyjOpd7Ni5+roDQnO4ocJ2GfplS0=;
        b=EkOh7nl04NTmYA/plSHX909yui+dWlFVYmdFijiRc6B+aIMEA0uwBv6zH210sxkuNa
         JaXi8RzqOkA/hXfncFzcUCUYUl5aeaYjqKo+QkDchydOsGGxiCWZ9xglTTk3nlL0agMJ
         gAlCHxPImbn2TOnjxo9D04EHTAKjQSmTHz7vE1zHlCaLebe3QgdgrAMYksgyJbyTO3yE
         BA3boLo5hRG0IR0mG0DuM9Y68BCoH6L/SyIFdBbcZVcrA9Jqeb0PABLAtsYopHjuy1EQ
         gZHUFkQzN/B/226JSZCNd/8yWlx3FrQcIwhmYMETlUpnzfdQwFhdvugdrkID5FQAIrPp
         G/DA==
X-Forwarded-Encrypted: i=1; AJvYcCVv6Ajp/y0xpsyWhvgTJRdEJ/1vClolKHPo4JdTBwPvsvdrB4aqf4YodOleYlKfayv8Fay6lUl/3g==@vger.kernel.org
X-Gm-Message-State: AOJu0YyKXyZ89qWgXoIhMtZECXqg0/ubeYNsrwFiy5d7XzrpFaAbQicD
	oHdvoD3T9Xsf5irms7FNmXR5V9kCg5tjAI90FbB93Gstq0Vza3ZuoEWDh5w6XXs=
X-Google-Smtp-Source: AGHT+IFKCDyN6WkCDr4ZwVsLnYfqxZODDnEoArzdPxCJqBHdrLb+CI4bzAtvm4yIDKuaEuZKb83FEQ==
X-Received: by 2002:a05:6602:2c8a:b0:835:45f9:c2ee with SMTP id ca18e2360f4ac-83b1c3de174mr4303326739f.4.1730906114893;
        Wed, 06 Nov 2024 07:15:14 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-83b67bb8455sm314414939f.31.2024.11.06.07.15.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Nov 2024 07:15:14 -0800 (PST)
Message-ID: <e27c7b11-4fa0-4c51-a596-67c0773a657a@kernel.dk>
Date: Wed, 6 Nov 2024 08:15:13 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V9 4/7] io_uring: reuse io_mapped_buf for kernel buffer
To: Ming Lei <ming.lei@redhat.com>, io-uring@vger.kernel.org,
 Pavel Begunkov <asml.silence@gmail.com>
Cc: linux-block@vger.kernel.org, Uday Shankar <ushankar@purestorage.com>,
 Akilesh Kailash <akailash@google.com>
References: <20241106122659.730712-1-ming.lei@redhat.com>
 <20241106122659.730712-5-ming.lei@redhat.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20241106122659.730712-5-ming.lei@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/6/24 5:26 AM, Ming Lei wrote:
> Prepare for supporting kernel buffer in case of io group, in which group
> leader leases kernel buffer to io_uring, and consumed by io_uring OPs.
> 
> So reuse io_mapped_buf for group kernel buffer, and unfortunately
> io_import_fixed() can't be reused since userspace fixed buffer is
> virt-contiguous, but it isn't true for kernel buffer.
> 
> Also kernel buffer lifetime is bound with group leader request, it isn't
> necessary to use rsrc_node for tracking its lifetime, especially it needs
> extra allocation of rsrc_node for each IO.

While it isn't strictly necessary, I do think it'd clean up the io_kiocb
parts and hopefully unify the assign and put path more. So I'd strongly
suggest you do use an io_rsrc_node, even if it does just map the
io_mapped_buf for this.

> +struct io_mapped_buf {
> +	u64		start;
> +	unsigned int	len;
> +	unsigned int	nr_bvecs;
> +
> +	/* kbuf hasn't refs and accounting, its lifetime is bound with req */
> +	union {
> +		struct {
> +			refcount_t	refs;
> +			unsigned int	acct_pages;
> +		};
> +		/* pbvec is only for kbuf */
> +		const struct bio_vec	*pbvec;
> +	};
> +	unsigned int	folio_shift:6;
> +	unsigned int	dir:1;		/* ITER_DEST or ITER_SOURCE */
> +	unsigned int	kbuf:1;		/* kernel buffer or not */
> +	/* offset in the 1st bvec, for kbuf only */
> +	unsigned int	offset;
> +	struct bio_vec	bvec[] __counted_by(nr_bvecs);
> +};

And then I'd get rid of this union, and have it follow the normal rules
for an io_mapped_buf in that the refs are valid. Yes it'll take 8b more,
but honestly I think unifying these bits and keeping it consistent is a
LOT more important than saving a bit of space.

This is imho the last piece missing to make this conform more nicely
with how resource nodes are generally handled and used.

-- 
Jens Axboe

