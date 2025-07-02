Return-Path: <io-uring+bounces-8588-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 83B46AF653B
	for <lists+io-uring@lfdr.de>; Thu,  3 Jul 2025 00:32:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 41A8D487B97
	for <lists+io-uring@lfdr.de>; Wed,  2 Jul 2025 22:32:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 802824C7F;
	Wed,  2 Jul 2025 22:32:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="mwkHNUZ5"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0478B7E0E4
	for <io-uring@vger.kernel.org>; Wed,  2 Jul 2025 22:32:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751495552; cv=none; b=PJ1lPo9sP4Px5+88TPHWxkIuMRIck8r3+FL3LYrar9sVa19wIUbqdANzK/r3HfcVL8w6Et3+fQ64hHVL8n1LZKJrET2xmwrMsaEVJH9Ao8Z+w3WHo5ncKuRz1B/AA4lElLbHD+o/nXxkSUP93/M7nD34vLFKR2Y2ZAmYCAsQFw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751495552; c=relaxed/simple;
	bh=EgoU+nIF9ApWX/qr5jA6ptpsjvQkkPHW6RCd1t5XV4I=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=WZSbxVbYX9Ax04zp7U453GxhKB2LHmcR77iX9qZg/IMuwONvwW7LwVRVAhQ94QypCi+HDKiwg3kMJ1GvdQeogJCtZ/TbExeDtGn1aKpGKcJE0BPhSZ6Yr1UaoGZdkWepd3YvTDZ6tmYOXoi0yonejiCp0SXaK6fGkM6HIDFAIbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=mwkHNUZ5; arc=none smtp.client-ip=209.85.216.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-31223a4cddeso3214071a91.1
        for <io-uring@vger.kernel.org>; Wed, 02 Jul 2025 15:32:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1751495550; x=1752100350; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=7Ldt7fzKM+K+HCvo3y1B59JebW5lAoNY4kc02ANsA54=;
        b=mwkHNUZ5kHYl1FHw4spc49oXdfBAvJSAjZZo1wmCSuNTaEdiYTZc6lJEKG/gaoUp2u
         ggaHS6k6G1VTFS4GSMq2uKa67zhEtVgDBIUnm8iA8Jv8+TOFMGOKHScQW9DuQhG2S7CJ
         v6ZevtqF86cqUvQUmSdDHW03+ZKNVnjp8lRgl9HBcqpW9d+r/2rn68PDkoBPHQYBZOf9
         1srPu7hvAZ0SA9s3wKPuRfqP+/JU1pHIufESeUgBA1CwDvIpMdSDSEYPh21JbjoqK2yx
         xapiJnRxGVCaD29qw1RYOs33dstX3dHNITkPpdVETKjjyg4oBlqQIc4cfuZ803vGC2qI
         E2qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751495550; x=1752100350;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7Ldt7fzKM+K+HCvo3y1B59JebW5lAoNY4kc02ANsA54=;
        b=OMP6eIMZzGrbAqEx3UmX5qnqkG66s/db4DXxJrVJ8jk8zzAcDAxHdoh/kACblWN1Ni
         mqFR+/IPdQ43oYsI3/29MA90wzyXclKMUCGJv3jc3hVE+CigPfTgFsqnLqSswtFPuVAs
         xtEBBMf9wTWrbWqEHlmtW106skNkYLYcb+tOgWEMAzVRQG/zhkGxY6Oz1MqEMqnQbhNv
         xD/9BNr5GbMt6CXLelhBEhBgHgTeyEiG8kG8BcDonn5FK3Ol1rRCu6fZEfi5U05bcWwt
         qJhMIFeD2NKHbosyuoWIIBK1p8tKKLmqgTwbQhKkRRfdZc/QIFxcQrEB6cCJ5VmqeaFZ
         dHvA==
X-Forwarded-Encrypted: i=1; AJvYcCWOy6tlfqyKaByTZRMltGy6exSigDR9pJjp3AycqmuUtH6WYnytXI6ZrcY9VYLr5fdkNuYoGJFkAQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YxM+5ljY7JW7/ZcAcLNm9wnXqINlIUNHht4xPuBg76BrYIQQHRM
	9uSSXM3jkdBejRsVjm0ZCoCFSiedkx2Eg3dcEs0G4O1WqVGTvzizQAaNtHG1MnCJj9SaguLHMKz
	Tf/a3h6w=
X-Gm-Gg: ASbGnct0J/ERvYKZiqQiJVU95Wxzg4AIfa/zRdp/p+kruxghFNNg4gOATC4j6sWr3xD
	KQ9VPJmIaEBhVeQyRkRkX22Ak0L+jGCN1is0wvxsPv1l26QMvSmXmqTubPQvnQknXbVAwlVqY0C
	nxigJm7vdssWLaLqErmEk/2fBusPt/fFsEmHHRQy0BQdEiBApNclGZLF9ZgVp9E7oNxH8VvfqNK
	BDip6U8R3Up7Xd+4IAUukMewVU5rSOGex4NU88a7JCBT1TqAXLnozx0cM7Txbhqx/9c+SUunkVC
	ol7NGAucNApmUzTZqOpJwT9kjGXzsTfmGJH3KffGWX/EJlPbmfR/9E5hr8YxKFaTtKN5HSPE9P0
	lVpkfK6fbARUXob5ziZG51m4H
X-Google-Smtp-Source: AGHT+IEX2vIx5MmnTfwFq9ToDbRv5u+StJmbszMnkoc378bp73Vs+8A3K+GVXKNLsD8LDAcHf8WcIQ==
X-Received: by 2002:a17:90b:2e0f:b0:311:abba:53c0 with SMTP id 98e67ed59e1d1-31a90b473damr7131436a91.9.1751495549886;
        Wed, 02 Jul 2025 15:32:29 -0700 (PDT)
Received: from ?IPV6:2a03:83e0:1156:1:14f8:5a41:7998:a806? ([2620:10d:c090:500::5:b65f])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-31a9cc673ffsm700189a91.17.2025.07.02.15.32.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Jul 2025 15:32:29 -0700 (PDT)
Message-ID: <bed9ed3c-b1cc-421f-bf0c-0debf3c89de4@davidwei.uk>
Date: Wed, 2 Jul 2025 15:32:26 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/6] io_uring/zcrx: always pass page to
 io_zcrx_copy_chunk
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1751466461.git.asml.silence@gmail.com>
 <b8f9f4bac027f5f44a9ccf85350912d1db41ceb8.1751466461.git.asml.silence@gmail.com>
Content-Language: en-US
From: David Wei <dw@davidwei.uk>
In-Reply-To: <b8f9f4bac027f5f44a9ccf85350912d1db41ceb8.1751466461.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2025-07-02 07:29, Pavel Begunkov wrote:
> io_zcrx_copy_chunk() currently takes either a page or virtual address.
> Unify the parameters, make it take pages and resolve the linear part
> into a page the same way general networking code does that.
> 
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>   io_uring/zcrx.c | 21 ++++++++++-----------
>   1 file changed, 10 insertions(+), 11 deletions(-)
> 
> diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
> index 797247a34cb7..99a253c1c6c5 100644
> --- a/io_uring/zcrx.c
> +++ b/io_uring/zcrx.c
> @@ -943,8 +943,8 @@ static struct net_iov *io_zcrx_alloc_fallback(struct io_zcrx_area *area)
>   }
>   
>   static ssize_t io_zcrx_copy_chunk(struct io_kiocb *req, struct io_zcrx_ifq *ifq,
> -				  void *src_base, struct page *src_page,
> -				  unsigned int src_offset, size_t len)
> +				  struct page *src_page, unsigned int src_offset,
> +				  size_t len)
>   {
>   	struct io_zcrx_area *area = ifq->area;
>   	size_t copied = 0;
> @@ -958,7 +958,7 @@ static ssize_t io_zcrx_copy_chunk(struct io_kiocb *req, struct io_zcrx_ifq *ifq,
>   		const int dst_off = 0;
>   		struct net_iov *niov;
>   		struct page *dst_page;
> -		void *dst_addr;
> +		void *dst_addr, *src_addr;
>   
>   		niov = io_zcrx_alloc_fallback(area);
>   		if (!niov) {
> @@ -968,13 +968,11 @@ static ssize_t io_zcrx_copy_chunk(struct io_kiocb *req, struct io_zcrx_ifq *ifq,
>   
>   		dst_page = io_zcrx_iov_page(niov);
>   		dst_addr = kmap_local_page(dst_page);
> -		if (src_page)
> -			src_base = kmap_local_page(src_page);
> +		src_addr = kmap_local_page(src_page);
>   
> -		memcpy(dst_addr, src_base + src_offset, copy_size);
> +		memcpy(dst_addr, src_addr + src_offset, copy_size);
>   
> -		if (src_page)
> -			kunmap_local(src_base);
> +		kunmap_local(src_addr);
>   		kunmap_local(dst_addr);
>   
>   		if (!io_zcrx_queue_cqe(req, niov, ifq, dst_off, copy_size)) {
> @@ -1003,7 +1001,7 @@ static int io_zcrx_copy_frag(struct io_kiocb *req, struct io_zcrx_ifq *ifq,
>   
>   	skb_frag_foreach_page(frag, off, len,
>   			      page, p_off, p_len, t) {
> -		ret = io_zcrx_copy_chunk(req, ifq, NULL, page, p_off, p_len);
> +		ret = io_zcrx_copy_chunk(req, ifq, page, p_off, p_len);
>   		if (ret < 0)
>   			return copied ? copied : ret;
>   		copied += ret;
> @@ -1065,8 +1063,9 @@ io_zcrx_recv_skb(read_descriptor_t *desc, struct sk_buff *skb,
>   		size_t to_copy;
>   
>   		to_copy = min_t(size_t, skb_headlen(skb) - offset, len);
> -		copied = io_zcrx_copy_chunk(req, ifq, skb->data, NULL,
> -					    offset, to_copy);
> +		copied = io_zcrx_copy_chunk(req, ifq, virt_to_page(skb->data),
> +					    offset_in_page(skb->data) + offset,
> +					    to_copy);
>   		if (copied < 0) {
>   			ret = copied;
>   			goto out;

Looks fine, mechanical changes.

Reviewed-by: David Wei <dw@davidwei.uk>

