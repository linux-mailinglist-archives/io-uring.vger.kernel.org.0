Return-Path: <io-uring+bounces-11995-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id gJcuIz/VfGlbOwIAu9opvQ
	(envelope-from <io-uring+bounces-11995-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 30 Jan 2026 16:58:55 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E38B7BC50E
	for <lists+io-uring@lfdr.de>; Fri, 30 Jan 2026 16:58:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D5EFC300577E
	for <lists+io-uring@lfdr.de>; Fri, 30 Jan 2026 15:55:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 57EF3338925;
	Fri, 30 Jan 2026 15:55:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="pKqgN+E7"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oo1-f43.google.com (mail-oo1-f43.google.com [209.85.161.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C103132E6BF
	for <io-uring@vger.kernel.org>; Fri, 30 Jan 2026 15:55:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769788556; cv=none; b=BcKJaxC28OtOB51kpGJD7SixJlZ6ed1VVXbp5Gy6Sh0sSLKSZ5/5YtYxiyhK1nCeZetdb86HMEWnkgQ+KpWZblXcf2X0o1vOg6ZdB7Iz8ZtDLiI+XYbhjIdKKlnoBba3iW5ea532PeRLVNDIR4M9fd6a+dtb8jClNACej+ZTwnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769788556; c=relaxed/simple;
	bh=S6/wlnlkVd8QOoTfZgPiX6vOKJ+YGKjfc44IiMZ4qAU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=A7CHbkJdh7HbXrE4fCupEGdnE0zMBZcDspHmafSv3RfdnxpWLt93s2VXWhbEdxRoZd2JvH2C9eXahsyLK8KWoSwb0U9noKv73GXbUc99LCcKxr8JXD9aEQ2408Yhig0M+BPOqY1rgsyRMAdJ/Vhi3urrSf7GJt5r0tWKK2bnaQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=pKqgN+E7; arc=none smtp.client-ip=209.85.161.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oo1-f43.google.com with SMTP id 006d021491bc7-6630b08ad60so918745eaf.2
        for <io-uring@vger.kernel.org>; Fri, 30 Jan 2026 07:55:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1769788552; x=1770393352; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4lWqgXH8a8eOxRrwfmqGJmpBJIu/eoT2SMMiuVC7jWk=;
        b=pKqgN+E7OvoGjg1GTHiGptLp30FBgVvmeekOV/FnO36CqLo1LP60HT6tmLP5e6R/J7
         yhJAiynmPrUzmEzuUIinrunTrOSkE+cqfem1mgmBqSkSprjR3Yjdnz814pAcDo7zm8LU
         Mj9gcutHrq+DeyHsMgY1yiF9Xe9swn6gaMIe1Oji7iFPECnAKajfZrO+V5w5itjdbGHs
         A0B8gPj0ibrSknw/qyFP4cIKRgMdF/0rvD0c1Y018ErB6+0ObwAm4y2OLMM1Nu26NO4i
         LGEPgZf5Wg1v9SjlMQJGvs+Q1OqLWaqLB+bWjxzZLzI8Dx/8XU0qGX25C4GdOku/5qKf
         4v/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769788552; x=1770393352;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4lWqgXH8a8eOxRrwfmqGJmpBJIu/eoT2SMMiuVC7jWk=;
        b=SgrMHPjPMP2hhzNo8z5SxJdscSH7NHgLjSuKclMGaXICNZPHpZtV3oF4dJbOgChrwt
         lx9EOzvE1UWW9RgfCl4LxO/AZvCKStMaM6I0fhmCFWoYpkMXXHhNTcEDZWNoDtTbi402
         fRw8Ey/nZsw4+gZLfGHli8nkgghDiRtMW6oada5RnKmG0pO03gszioMdd9C/qc6NTzwP
         pZ6bHFfEgvISQDHN6p2mdykGbVLQD2/9xuHNI41gc3T8QCWMcvPpzTJJ2ebw8myY6+n7
         UdchY1h1L9S1lGJx8YOyzoUXk2WG6/THb37pruBCf2v5J6B4qW0GaKmdpO2JME1zV2pt
         MQVQ==
X-Gm-Message-State: AOJu0YzOFW2J7jlLWxNJYn9ESUQddnpZLkVvnxkhOWs+9vvgIuUi2Kki
	kC4xzzKnudFU2WN56dzIEs6LoAvhj3TO5sARsB3A9KY0vwKzlpNNU1iE4rg6i3jQqW0=
X-Gm-Gg: AZuq6aL3pT76LSmyfKde0sUpmsMh//qKYs1nG8ePopt9UHGRD/dyTbkewkQZ9yW8Lbp
	oDSWnc1WSzngKh+Q3kIKdig+LgrdqLBZC6oX9YJGMuiXQ3k2n3fFWZ2XPljx8qYjsOcZPI/g2vY
	q5nQtUdkhpyQ2SEV/AKFA/HX4A1GADWVUFNIkpujTl6ba2oUnEoumzZQzEXQUucpIXIUi45+jV5
	ACSVO6pV6dr3XKs9gqAhnCR/0FN0fcRq5OeI7n/LGvtJPydAYKksd+Q29MU61LqU8B68LPUA9c0
	YvEABdb6tVldcojnyWkXjPrphKfrFVa9TvE3wF7NJgE9Lo4Jtdk6Tr0a+yNGTsdyF8Cg3niSych
	kqFKKvCBKia1Wbrq7HEKGohLQ2SewNkhYsp2Fd45cZuzTYNi8Z17MZeQgCXt+oZbZ4OVdQj7EWE
	JWeqe8QOxmBpdoGASa5WsbBZ1FqBCgU9VbpOmLcXSZuig3U7Y1+Ktr2XVXGhDakOIWn5E6
X-Received: by 2002:a05:6820:f014:b0:663:46f:603f with SMTP id 006d021491bc7-6630f02bd9dmr1550651eaf.22.1769788552396;
        Fri, 30 Jan 2026 07:55:52 -0800 (PST)
Received: from [192.168.1.102] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-662f982703fsm5202672eaf.0.2026.01.30.07.55.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 Jan 2026 07:55:51 -0800 (PST)
Message-ID: <efa7714d-565d-41c4-af85-d7a89e7fa399@kernel.dk>
Date: Fri, 30 Jan 2026 08:55:50 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] io_uring: introduce IORING_OP_MMAP
To: Gabriel Krisman Bertazi <krisman@suse.de>
Cc: io-uring@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 linux-mm@kvack.org
References: <20260129221138.897715-1-krisman@suse.de>
 <20260129221138.897715-3-krisman@suse.de>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20260129221138.897715-3-krisman@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-11995-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DMARC_NA(0.00)[kernel.dk];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[11];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	TO_DN_SOME(0.00)[]
X-Rspamd-Queue-Id: E38B7BC50E
X-Rspamd-Action: no action

On 1/29/26 3:11 PM, Gabriel Krisman Bertazi wrote:
> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
> index b5b23c0d5283..e24fe3b00059 100644
> --- a/include/uapi/linux/io_uring.h
> +++ b/include/uapi/linux/io_uring.h
> @@ -74,6 +74,7 @@ struct io_uring_sqe {
>  		__u32		install_fd_flags;
>  		__u32		nop_flags;
>  		__u32		pipe_flags;
> +		__u32		mmap_flags;
>  	};
>  	__u64	user_data;	/* data to be passed back at completion time */
>  	/* pack this to avoid bogus arm OABI complaints */
> @@ -303,6 +304,7 @@ enum io_uring_op {
>  	IORING_OP_PIPE,
>  	IORING_OP_NOP128,
>  	IORING_OP_URING_CMD128,
> +	IORING_OP_MMAP,
>  
>  	/* this goes last, obviously */
>  	IORING_OP_LAST,
> @@ -1113,6 +1115,14 @@ struct zcrx_ctrl {
>  	};
>  };
>  
> +struct io_uring_mmap_desc {
> +	void __user *addr;
> +	unsigned long len;
> +	unsigned long pgoff;
> +	unsigned int prot;
> +	unsigned int flags;
> +};

You can't use pointers or unsigned long or unsigned int in a uapi, as
they'd be different sizes on 32-bit and 64-bit. And then you need compat
handling. It's much better to make this:

struct io_uring_mmap_desc {
	__u64 addr
	__u64 len;
	__u64 pgoff;
	__u32 prot;
	__u32 flags;
};

and then generally also a good idea to have a bit of expansion space
there, so you don't need a new desc down the line.

> +int io_mmap_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
> +{
> +	struct io_mmap_data *mmap = io_kiocb_to_cmd(req, struct io_mmap_data);
> +	struct io_mmap_async *maps;
> +	int nr_maps;
> +
> +	mmap->uaddr = u64_to_user_ptr(READ_ONCE(sqe->addr));
> +	mmap->flags = READ_ONCE(sqe->mmap_flags);
> +	nr_maps = READ_ONCE(sqe->len);
> +
> +	if (mmap->flags & MAP_ANONYMOUS && req->cqe.fd != -1)
> +		return -EINVAL;
> +	if (nr_maps < 0 || nr_maps > MMAP_MAX_BATCH)
> +		return -EINVAL;
> +	if (!access_ok(mmap->uaddr, nr_maps*sizeof(struct io_uring_mmap_desc)))
> +		return -EFAULT;

Does this access_ok actually provide anything? We're copying it in later
anyway, no?

> +static int io_prep_mmap_hugetlb(struct file **filp, unsigned long *len,
> +				int flags)
> +{
> +	if (*filp) {
> +		*len = ALIGN(*len, huge_page_size(hstate_file(*filp)));
> +	} else {
> +		struct hstate *hs;
> +		unsigned long nlen = *len;
> +
> +		hs = hstate_sizelog((flags >> MAP_HUGE_SHIFT) & MAP_HUGE_MASK);
> +		if (!hs)
> +			return -EINVAL;
> +		nlen = ALIGN(nlen, huge_page_size(hs));
> +		*filp = hugetlb_file_setup(HUGETLB_ANON_FILE, nlen,
> +					   VM_NORESERVE,
> +					   HUGETLB_ANONHUGE_INODE,
> +				   (flags >> MAP_HUGE_SHIFT) & MAP_HUGE_MASK);

This looks like it dips into vm_mmap_pgoff(). More on that below.

> +		desc->addr = (void *) vm_mmap_pgoff(file,
> +					   (unsigned long) desc->addr,
> +					   len, desc->prot, flags, desc->pgoff);

One concern here is that vm_mmap_pgoff() ends up doing:

mmap_write_lock_killable(mm)
	grabs mm lock, can block, for a long time?

which could potentially stall the io_uring pipeline for a long time.
Ideally you'd be able to do something where you try to grab the mm lock
from io_mmap(), and if it fails, then either fail the request (if it's a
killable thing) or punt it with -EAGAIN to let an io-wq thread handle
it.

I'm not so sure simply wrapping vm_mmap_pgoff() either directly or
indirectly via the hugetlb stuff is going to be super useful, if we can
end up blocking for a long time on these operations.

-- 
Jens Axboe

